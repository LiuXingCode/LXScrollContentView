//
//  LXScrollContentView.m
//  LXScrollContentView
//
//  Created by 刘行 on 2017/3/23.
//  Copyright © 2017年 刘行. All rights reserved.
//

#import "LXScrollContentView.h"

static NSString *kContentCellID = @"kContentCellID";

@interface LXScrollContentView()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGFloat _startOffsetX;
}

@property (nonatomic, strong) NSMutableArray<UIViewController *> *childVcs;

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, assign) BOOL isForbidScrollDelegate;

@property (nonatomic, strong) UIViewController *parentVC;

@end

@implementation LXScrollContentView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
}

- (instancetype)initWithFrame:(CGRect)frame{
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

#pragma mark - lazy

- (NSMutableArray<UIViewController *> *)childVcs{
    if (!_childVcs) {
        _childVcs = [[NSMutableArray alloc] init];
    }
    return _childVcs;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.scrollsToTop = NO;
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView.bounces = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kContentCellID];
        [self addSubview:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.childVcs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kContentCellID forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIViewController *childVc = self.childVcs[indexPath.row];
    [self.parentVC addChildViewController:childVc];
    childVc.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:childVc.view];
}


- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *childVc = self.childVcs[indexPath.row];
    if (childVc.parentViewController) {
        [childVc removeFromParentViewController];
    }
    if (childVc.view.superview) {
        [childVc.view removeFromSuperview];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isForbidScrollDelegate = NO;
    _startOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
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
        if (toIndex > self.childVcs.count - 1) {
            toIndex = self.childVcs.count - 1;
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat endOffsetX = scrollView.contentOffset.x;
    NSInteger startIndex = floor(_startOffsetX / scrollView.frame.size.width);
    NSInteger endIndex = floor(endOffsetX / scrollView.frame.size.width);
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentViewDidEndDecelerating:startIndex:endIndex:)]) {
        [self.delegate contentViewDidEndDecelerating:self startIndex:startIndex endIndex:endIndex];
    }
}

- (void)reloadViewWithChildVcs:(NSArray *)childVcs parentVC:(UIViewController *)parentVC{
    self.parentVC = parentVC;
    [self.childVcs makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    self.childVcs = nil;
    [self.childVcs addObjectsFromArray:childVcs];
    [self.collectionView reloadData];
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    if (_currentIndex < 0 || _currentIndex > self.childVcs.count - 1) {
        return;
    }
    _currentIndex = currentIndex;
    self.isForbidScrollDelegate = YES;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

@end
