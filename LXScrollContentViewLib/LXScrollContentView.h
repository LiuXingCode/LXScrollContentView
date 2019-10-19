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

@required

- (NSInteger)numberOfchildVcsInScrollContentView:(LXScrollContentView *)scrollContentView;

- (UIViewController *)scrollContentView:(LXScrollContentView *)scrollContentView childVcAtIndex:(NSInteger)index;

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

- (void)reloadData;

@property (nonatomic, weak) id<LXScrollContentViewDataSource> dataSource;

@property (nonatomic, weak) id<LXScrollContentViewDelegate> delegate;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, weak, readonly) UICollectionView *collectionView;

@end
