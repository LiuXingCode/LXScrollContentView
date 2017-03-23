//
//  LXScrollContentView.h
//  LXScrollContentView
//
//  Created by 刘行 on 2017/3/23.
//  Copyright © 2017年 刘行. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 ScollContentBlock
 
 @param index 滚动到第几个页面
 */
typedef void(^LXScrollContentViewBlock)(NSInteger index);

@interface LXScrollContentView : UIView

/**
 设置当前滚动到第几个页面，默认为0
 */
@property (nonatomic, assign) NSInteger currentIndex;


/**
 页面滚动停止时触发block回调
 */
@property (nonatomic, copy) LXScrollContentViewBlock scrollBlock;


/**
 刷新页面内容

 @param childVcs 当前View需要装入的控制器集合
 @param parentVC 当前View所在的父控制器
 */
- (void)reloadViewWithChildVcs:(NSArray<UIViewController *> *)childVcs parentVC:(UIViewController *)parentVC;

@end
