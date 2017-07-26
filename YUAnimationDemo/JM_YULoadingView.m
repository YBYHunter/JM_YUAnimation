//
//  JM_YULoadingView.m
//  YUAnimationDemo
//
//  Created by 于博洋 on 2017/7/26.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import "JM_YULoadingView.h"

static CGFloat const TimeCircleAnimation = 1.1;

@interface JM_YULoadingView ()

@property (strong, nonatomic) CAShapeLayer * insideLayer;

@property (strong, nonatomic) CAShapeLayer * outsideLayer;

@end

@implementation JM_YULoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.insideLayer];
        [self.layer addSublayer:self.outsideLayer];
        
        [self rotatingAnimation:self.insideLayer isClockwise:YES];
        [self rotatingAnimation:self.outsideLayer isClockwise:NO];
    }
    return self;
}


- (void)startAnimation {
    [self pauseLayer:self.outsideLayer];
    [self pauseLayer:self.insideLayer];
    
    [UIView animateWithDuration:TimeCircleAnimation/2 animations:^{
        self.insideLayer.strokeEnd = 1;
        self.outsideLayer.strokeEnd = 1;
        self.insideLayer.lineWidth = 2.f;
        self.outsideLayer.lineWidth = 2.f;
    } completion:^(BOOL finished) {
        
    }];
    
    [self resumeLayer:self.insideLayer];
    [self resumeLayer:self.outsideLayer];
}

- (void)pauseAnimation {
    [self pauseLayer:self.outsideLayer];
    [self pauseLayer:self.insideLayer];
}

#pragma mark - getter

- (void)rotatingAnimation:(CALayer *)layer isClockwise:(BOOL)isClockwise {
    CABasicAnimation * rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    if (isClockwise) {
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    }
    else {
        rotationAnimation.toValue = [NSNumber numberWithFloat: - M_PI * 2.0 ];
    }
    
    rotationAnimation.duration = TimeCircleAnimation;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.autoreverses = NO;
    [layer addAnimation:rotationAnimation forKey:@"bbcell_rotationAnimation"];
    [self pauseLayer:layer];
}

- (void)pauseLayer:(CALayer*)layer {
    
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}


- (void)resumeLayer:(CALayer*)layer {
    
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
    
}

- (CAShapeLayer *)insideLayer {
    if (_insideLayer == nil) {
        _insideLayer = [CAShapeLayer layer];
        CGPoint center = CGPointMake(0, 0);
        UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:center
                                                             radius:38/4
                                                         startAngle:(0.f / 180.f) * M_PI
                                                           endAngle:(180.f / 180.f) * M_PI
                                                          clockwise:NO];
        _insideLayer.borderColor = [UIColor blackColor].CGColor;
        _insideLayer.lineWidth = 0.f;
        _insideLayer.path = path.CGPath;
        _insideLayer.fillColor = [UIColor clearColor].CGColor;
        _insideLayer.strokeColor = [UIColor blackColor].CGColor;
        _insideLayer.strokeEnd = 0;
        _insideLayer.backgroundColor = [UIColor redColor].CGColor;
        _insideLayer.lineCap = kCALineCapRound;
    }
    return _insideLayer;
}

- (CAShapeLayer *)outsideLayer {
    if (_outsideLayer == nil) {
        _outsideLayer = [CAShapeLayer layer];
        CGPoint center = CGPointMake(0, 0);
        UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:center
                                                             radius:66/4
                                                         startAngle:(0.f / 180.f) * M_PI
                                                           endAngle:(180.f / 180.f) * M_PI
                                                          clockwise:YES];
        _outsideLayer.borderColor = [UIColor blackColor].CGColor;
        _outsideLayer.lineWidth = 0.f;
        _outsideLayer.path = path.CGPath;
        _outsideLayer.fillColor = [UIColor clearColor].CGColor;
        _outsideLayer.strokeColor = [UIColor blackColor].CGColor;
        _outsideLayer.strokeEnd = 0;
        _outsideLayer.lineCap = kCALineCapRound;
    }
    return _outsideLayer;
}






















@end
