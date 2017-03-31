//
//  LXSegmentTitleView.h
//  LXScrollContentView
//
//  Created by 刘行 on 2017/3/31.
//  Copyright © 2017年 刘行. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXSegmentTitleView;

@protocol LXSegmentTitleViewDelegate <NSObject>

- (void)segmentTitleView:(LXSegmentTitleView *)segmentView didSelectedIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex;

@end

@interface LXSegmentTitleView : UIView

@property (nonatomic, weak) id<LXSegmentTitleViewDelegate> delegate;

/**
 文字未选中颜色，默认black
 */
@property (nonatomic, strong) UIColor *titleNormalColor;

/**
 文字选中和下方滚动条颜色，默认red
 */
@property (nonatomic, strong) UIColor *titleSelectedColor;


/**
 第几个标题处于选中状态，默认为0
 */
@property (nonatomic, assign) NSInteger selectedIndex;


/**
 标题font，默认14.f
 */
@property (nonatomic, strong) UIFont *titleFont;


/**
 下方指示条颜色，默认red
 */
@property (nonatomic, strong) UIColor *indicatorColor;

/**
 下方滚动指示条高度，默认2.f
 */
@property (nonatomic, assign) CGFloat indicatorHeight;


/**
 下方指示条延伸宽度，默认2.f
 */
@property (nonatomic, assign) NSInteger indicatorExtraW;


/**
 每个item之间最小间隔，默认20.f
 */
@property (nonatomic, assign) NSInteger itemMinMargin;

/**
 选项卡标题数组
 */
@property (nonatomic, strong) NSArray *segmentTitles;

@end
