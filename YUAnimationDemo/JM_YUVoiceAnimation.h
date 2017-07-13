//
//  JM_YUVoiceAnimation.h
//  YUAnimationDemo
//
//  Created by 于博洋 on 2017/7/13.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JM_YUVoiceAnimation : UIView

//0.1 - 1
- (void)updateWithLevel:(CGFloat)percentage;

- (void)stopAnimation;

@end

