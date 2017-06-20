//
//  JMEyeAnimationView.h
//  YUAnimationDemo
//
//  Created by 于博洋 on 2017/6/16.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMEyeAnimationView : UIView

/**
 * method 根据y值改变眼睛 眼袋的弧度
 */
- (void)animationWith:(CGFloat)y;

/**
 * method 开始动画 眼睛左右移动 
 * mobileNum 移动的次数 
 * mobileNum == 0时为无限循环
 */
- (void)animationStartWithMobileNum:(NSInteger)mobileNum;

/**
 * method 开始动画 眼睛上下合并
 * mobileNum 移动的次数
 * mobileNum == 0时为无限循环
 */
- (void)animationStartWithCloseEyesNum:(NSInteger)mobileNum;

@end
