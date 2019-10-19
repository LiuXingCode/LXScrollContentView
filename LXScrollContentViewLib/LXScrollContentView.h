//
//  LXScrollContentView.h
//  LXScrollContentView
//
//  Created by 刘行 on 2017/3/23.
//  Copyright © 2017年 刘行. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXScrollContentView;

@protocol LXScrollContentViewDataSource <NSObject>

- (NSArray<UIViewController *> *)childVcsInScrollContentView:(LXScrollContentView *)scrollContentView;

- (UIViewController *)parentVcInScrollContentView:(LXScrollContentView *)scrollContentView;

@end

@protocol LXScrollContentViewDelegate <NSObject>

@optional

- (void)contentViewDidScroll:(LXScrollContentView *)contentView
                   fromIndex:(NSInteger)fromIndex
                     toIndex:(NSInteger)toIndex
                    progress:(float)progress;

- (void)contentViewDidEndDecelerating:(LXScrollContentView *)contentView
                           startIndex:(NSInteger)startIndex
                             endIndex:(NSInteger)endIndex;

@end

@interface LXScrollContentView : UIView

/**
 加载滚动视图的界面
 
 @param childVcs 当前View需要装入的控制器集合
 @param parentVC 当前View所在的父控制器
 */
- (void)reloadViewWithChildVcs:(NSArray<UIViewController *> *)childVcs
                      parentVC:(UIViewController *)parentVC __deprecated_msg("使用dataSource方式获取");

- (void)reloadData;

@property (nonatomic, weak) id<LXScrollContentViewDataSource> dataSource;

@property (nonatomic, weak) id<LXScrollContentViewDelegate> delegate;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, weak) UICollectionView *collectionView;

@end
