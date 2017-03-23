//
//  LXScollTitleView.h
//  LXScrollContentView
//
//  Created by 刘行 on 2017/3/23.
//  Copyright © 2017年 刘行. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 TitleSelectedBlock

 @param index 选中第几个标题
 */
typedef void(^BMPageTitleViewSelectedBlock)(NSInteger index);

@interface LXScollTitleView : UIView


/**
 文字未选中颜色，默认black
 */
@property (nonatomic, strong) UIColor *normalColor;

/**
 文字选中和下方滚动条颜色，默认red
 */
@property (nonatomic, strong) UIColor *selectedColor;


/**
 第几个标题处于选中状态，默认为0
 */
@property (nonatomic, assign) NSInteger selectedIndex;


/**
 每个标题宽度,默认85.f
 */
@property (nonatomic, assign) CGFloat titleWidth;


/**
 标题字体font，默认14.f
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 下方滚动指示条高度，默认2.f
 */
@property (nonatomic, assign) CGFloat indicatorHeight;

/**
 选中标题回调block
 */
@property (nonatomic, copy) BMPageTitleViewSelectedBlock selectedBlock;


/**
 刷新界面

 @param titles 标题数组
 */
- (void)reloadViewWithTitles:(NSArray *)titles;

@end
