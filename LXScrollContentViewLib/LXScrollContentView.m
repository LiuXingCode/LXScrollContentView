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
    self.backgroundColor = [UIColor clearColor];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
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
    NSInteger index = indexPath.row;
    UIViewController *childVc = self.childVcDicts[@(index)];
    if (!childVc) {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(scrollContentView:childVcAtIndex:)]) {
            childVc = [self.dataSource scrollContentView:self childVcAtIndex:index];
            self.childVcDicts[@(index)] = childVc;
        }
    }
    [self.parentVC addChildViewController:childVc];
    childVc.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:childVc.view];
}

- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = indexPath.row;
    UIViewController *childVc = self.childVcDicts[@(index)];
    if (!childVc) {
        return;
    }
    if (childVc.parentViewController) {
        [childVc removeFromParentViewController];
    }
    if (childVc.view.superview) {
        [childVc.view removeFromSuperview];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (scrollView != self.collectionView) {
        return;
    }
    self.isForbidScrollDelegate = NO;
    _startOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView != self.collectionView) {
        return;
    }
    if (self.isForbidScrollDelegate) {
        return;
    }
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView != self.collectionView) {
        return;
    }
    CGFloat endOffsetX = scrollView.contentOffset.x;
    NSInteger startIndex = floor(_startOffsetX / scrollView.frame.size.width);
    NSInteger endIndex = floor(endOffsetX / scrollView.frame.size.width);
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentViewDidEndDecelerating:startIndex:endIndex:)]) {
        [self.delegate contentViewDidEndDecelerating:self startIndex:startIndex endIndex:endIndex];
    }
}

#pragma mark - public
- (void)reloadData {
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfchildVcsInScrollContentView:)]) {
        self.childVcsCount = [self.dataSource numberOfchildVcsInScrollContentView:self];
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(parentVcInScrollContentView:)]) {
        self.parentVC = [self.dataSource parentVcInScrollContentView:self];
    }
    
    NSArray<UIViewController *> *childVcs = self.childVcDicts.allValues;
    [childVcs makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    [self.childVcDicts removeAllObjects];
    
    [self.collectionView reloadData];
}


- (void)setCurrentIndex:(NSInteger)currentIndex {
    
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

@end
