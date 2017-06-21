//
//  BendingAnimationView.m
//  YUAnimationDemo
//
//  Created by 于博洋 on 2017/6/16.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import "BendingAnimationView.h"

@interface BendingAnimationView ()

@property (nonatomic,strong) CAShapeLayer * leftLineLayer;

@property (nonatomic,assign) CGFloat oldY;

@end

@implementation BendingAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        
        [self.layer addSublayer:self.leftLineLayer];

        [self setupAnimation];
    }
    return self;
}

- (void)setupAnimation {
    self.leftLineLayer.strokeStart = 0.f;
    self.leftLineLayer.strokeEnd = 0.0f;
}

- (void)animationWith:(CGFloat)y {
    
    CGFloat flag = 64.f;
    if (fabs(y) > flag) {
        if (_oldY > y) {
            self.leftLineLayer.strokeEnd += 0.05;
        }
        else {
            self.leftLineLayer.strokeEnd -= 0.05;
        }
    }
    
    
    
    
    _oldY = y;
    
    
}

#pragma mark - getter

- (CAShapeLayer *)leftLineLayer {
    if (_leftLineLayer == nil) {
        _leftLineLayer = [CAShapeLayer layer];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineCapStyle = kCGLineCapSquare;
        [path moveToPoint:CGPointMake(CGRectGetWidth(self.frame)/2, 0)];
        CGPoint endPoint = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame));
        [path addQuadCurveToPoint:endPoint controlPoint:CGPointMake(0, CGRectGetHeight(self.frame))];
        [path addLineToPoint:CGPointMake(0, 0)];
        
        _leftLineLayer.borderColor = [UIColor blackColor].CGColor;
        _leftLineLayer.fillColor = [UIColor clearColor].CGColor;
        _leftLineLayer.strokeColor = [UIColor whiteColor].CGColor;
        _leftLineLayer.lineWidth = 10.0f;
        _leftLineLayer.path = path.CGPath;
        
    }
    return _leftLineLayer;
}

























@end
