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

@property (nonatomic, strong) NSMutableArray *childVcs;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, assign) NSInteger startIndex;

@property (nonatomic, assign) BOOL isForbidScrollDelegate;

@end

@implementation LXScrollContentView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.childVcs = [[NSMutableArray alloc] init];
    [self setupUI];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.childVcs = [[NSMutableArray alloc] init];
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.itemSize = CGSizeZero;
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kContentCellID];
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    self.flowLayout.itemSize = self.bounds.size;
}

- (void)reloadViewWithChildVcs:(NSArray *)childVcs parentVC:(UIViewController *)parentVC{
    for (UIViewController *childVc in self.childVcs) {
        [childVc removeFromParentViewController];
    }
    [self.childVcs removeAllObjects];
    [self.childVcs addObjectsFromArray:childVcs];
    for (UIViewController *childVc in childVcs) {
        [parentVC addChildViewController:childVc];
    }
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.childVcs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kContentCellID forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIViewController *childVc = self.childVcs[indexPath.row];
    childVc.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:childVc.view];
    return cell;
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    self.isForbidScrollDelegate = YES;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.startIndex = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
    self.isForbidScrollDelegate = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.isForbidScrollDelegate) {
        return;
    }
    NSInteger endIndex = (self.collectionView.contentOffset.x + self.collectionView.frame.size.width / 2 )/ self.collectionView.frame.size.width;
    if (endIndex == self.startIndex) {
        return;
    }
    if (self.scrollBlock) {
        self.scrollBlock(endIndex);
    }
}

@end
