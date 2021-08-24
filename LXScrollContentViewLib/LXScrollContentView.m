//
//  LXScrollContentView.m
//  LXScrollContentView
//
//  Created by 刘行 on 2017/3/23.
//  Copyright © 2017年 刘行. All rights reserved.
//

#import "LXScrollContentView.h"

static NSString *kContentCellID = @"kContentCellID";

@interface LXScrollContentView()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    CGFloat _startOffsetX;
}

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UIViewController *> *childVcDicts;

@property (nonatomic, assign) NSInteger childVcsCount;

@property (nonatomic, assign) BOOL isForbidScrollDelegate;

@property (nonatomic, weak) UIViewController *parentVC;

@property (nonatomic, weak, readwrite) UICollectionView *collectionView;

@end

@implementation LXScrollContentView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.itemSize = self.bounds.size;
}

#pragma mark - lazy init

- (NSMutableDictionary<NSNumber *, UIViewController *> *)childVcDicts {
    if (!_childVcDicts) {
        _childVcDicts = [[NSMutableDictionary alloc] init];
    }
    return _childVcDicts;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.scrollsToTop = NO;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView.bounces = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kContentCellID];
        
        if (@available(iOS 11.0, *)) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [self addSubview:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.childVcsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kContentCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIViewController *childVc = [self fetchChildVcAtIndex:indexPath.row];
    if (childVc) {
        if (!childVc.parentViewController) {
            [self.parentVC addChildViewController:childVc];
        }
        [cell.contentView addSubview:childVc.view];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(childVcViewWillAppearAtIndex:)]) {
        [self.delegate childVcViewWillAppearAtIndex:indexPath.row];
    }
    
    if (!self.preloadNearVcs) return;
    [self preloadNearVcsAtIndex:indexPath.row];
}

- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(childVcViewDidDisappearAtIndex:)]) {
        [self.delegate childVcViewDidDisappearAtIndex:indexPath.row];
    }
    UIViewController *childVc = [self fetchChildVcAtIndex:indexPath.row];
    if (childVc == nil) return;
    
    if (childVc.parentViewController == self.parentVC) {
        [childVc removeFromParentViewController];
    }
    if (childVc.view.superview) {
        [childVc.view removeFromSuperview];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView != self.collectionView) return;
    
    self.isForbidScrollDelegate = NO;
    _startOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.collectionView) return;
    if (self.isForbidScrollDelegate) return;
    
    CGFloat endOffsetX = scrollView.contentOffset.x;
    NSInteger fromIndex = floor(_startOffsetX / scrollView.frame.size.width);
    CGFloat progress;
    NSInteger toIndex;
    if (_startOffsetX < endOffsetX) {//左滑
        progress = (endOffsetX - _startOffsetX) / scrollView.frame.size.width;
        toIndex = fromIndex + 1;
        if (toIndex > self.childVcsCount - 1) {
            toIndex = self.childVcsCount - 1;
        }
    } else if (_startOffsetX == endOffsetX){
        progress = 0;
        toIndex = fromIndex;
    } else {
        progress = (_startOffsetX - endOffsetX) / scrollView.frame.size.width;
        toIndex = fromIndex - 1;
        if (toIndex < 0) {
            toIndex = 0;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentViewDidScroll:fromIndex:toIndex:progress:)]) {
        [self.delegate contentViewDidScroll:self fromIndex:fromIndex toIndex:toIndex progress:progress];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollViewDidEndScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScroll:scrollView];
}

- (void)scrollViewDidEndScroll:(UIScrollView *)scrollView {
    if (scrollView != self.collectionView) return;
    
    CGFloat endOffsetX = scrollView.contentOffset.x;
    NSInteger startIndex = floor(_startOffsetX / scrollView.frame.size.width);
    NSInteger endIndex = floor(endOffsetX / scrollView.frame.size.width);
    _currentIndex = endIndex;
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentViewDidEndDecelerating:startIndex:endIndex:)]) {
        [self.delegate contentViewDidEndDecelerating:self startIndex:startIndex endIndex:endIndex];
    }
}

#pragma mark - public methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfchildVcsInScrollContentView:)]) {
        self.childVcsCount = [self.dataSource numberOfchildVcsInScrollContentView:self];
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(parentVcInScrollContentView:)]) {
        self.parentVC = [self.dataSource parentVcInScrollContentView:self];
    }
    
    NSArray<UIViewController *> *childVcs = self.childVcDicts.allValues;
    for (UIViewController *childVc in childVcs) {
        if (childVc.parentViewController == self.parentVC) {
            [childVc removeFromParentViewController];
        }
        if (childVc.view.superview) {
            [childVc.view removeFromSuperview];
        }
    }
    [self.childVcDicts removeAllObjects];
    
    [self.collectionView reloadData];
}


- (void)setCurrentIndex:(NSUInteger)currentIndex {
    if (currentIndex < 0
        || currentIndex > self.childVcsCount - 1
        || self.childVcsCount <= 0) {
        return;
    }
    _currentIndex = currentIndex;
    self.isForbidScrollDelegate = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
        [self.collectionView scrollToItemAtIndexPath:currentIndexPath
                                    atScrollPosition:UICollectionViewScrollPositionNone
                                            animated:NO];
    });
}

- (void)setDataSource:(id<LXScrollContentViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self reloadData];
}

#pragma mark - private methods

- (UIViewController *)fetchChildVcAtIndex:(NSUInteger)index {
    UIViewController *childVc = self.childVcDicts[@(index)];
    if (childVc) return childVc;
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(scrollContentView:childVcAtIndex:)]) {
        childVc = [self.dataSource scrollContentView:self childVcAtIndex:index];
        if (childVc) {
            childVc.view.frame = [self childVcFrameAtIndex:index];
            self.childVcDicts[@(index)] = childVc;
            return childVc;
        }
    }
    return nil;
}

- (CGRect)childVcFrameAtIndex:(NSUInteger)index {
    CGRect frame = self.bounds;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(scrollContentView:childVcContentInsetAtIndex:)]) {
        UIEdgeInsets inset = [self.dataSource scrollContentView:self childVcContentInsetAtIndex:index];
        CGFloat weight = MAX(0, self.bounds.size.width - inset.left - inset.right);
        CGFloat height = MAX(0, self.bounds.size.height - inset.top - inset.bottom);
        frame = CGRectMake(inset.left, inset.top, weight, height);
    }
    return frame;
}

- (void)preloadNearVcsAtIndex:(NSUInteger)index {
    if (index < self.childVcsCount - 1) {
        [self fetchChildVcAtIndex:index + 1];
    }
    if (index > 1) {
        [self fetchChildVcAtIndex:index - 1];
    }
}

@end
