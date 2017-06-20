//
//  JMEyeAnimationView.m
//  YUAnimationDemo
//
//  Created by 于博洋 on 2017/6/16.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import "JMEyeAnimationView.h"

#define toRadians(x) ((x) * M_PI / 180.0)
static CGFloat const NeedTotalheightSliding = 64.0f;

@interface JMEyeAnimationView ()

@property (nonatomic,strong) CAShapeLayer * topLineLayer;
@property (nonatomic,strong) CAShapeLayer * semicircleLayer;
@property (nonatomic,strong) CAShapeLayer * semiellipseLayer;

@property (nonatomic,strong) CALayer * beginPointLayer;
@property (nonatomic,strong) CALayer * endPointLayer;
@property (nonatomic,strong) CALayer * controlPointLayer;

//
@property (nonatomic,strong) dispatch_source_t timer;
@property (nonatomic,assign) CGFloat animationNum;

/**
 * increasingState == 1 开始递减
 * increasingState == 2 开始递加
 */
@property (nonatomic,assign) CGFloat increasingState;

@end

@implementation JMEyeAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.layer addSublayer:self.topLineLayer];
        [self.layer addSublayer:self.semicircleLayer];
        [self.layer addSublayer:self.semiellipseLayer];
        
        [self initData];
        
        _animationNum = 1;
    }
    return self;
}


//计算出一个椭圆
-(CGPathRef)pathCreateForCurrentControlPointPositions:(CALayer *)beginPointLayer endPointLayer:(CALayer *)endPointLayer controlPointLayer:(CALayer *)controlPointLayer {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, [beginPointLayer position].x, [beginPointLayer position].y);
    CGPathAddQuadCurveToPoint(path, NULL, [controlPointLayer position].x, [controlPointLayer position].y, [endPointLayer position].x, [endPointLayer position].y);
    
    return path;
}

//计算出一个半圆
-(CGPathRef)pathCreateForRadiusPositions:(CGPoint)centerPoint endPointLayer:(CALayer *)endPointLayer radius:(CGFloat)radius {
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat delta = -toRadians(180);
    CGFloat startAngle = (M_PI);
    
    CGPathAddRelativeArc(path, NULL, centerPoint.x, centerPoint.y, radius, startAngle, delta);
    
    return path;
}

- (void)initData {
    
    self.topLineLayer.strokeStart = 0.5f;
    self.topLineLayer.strokeEnd = 0.5f;
    
    [self updatSemiellipseLayer:0];
    [self updatSemicircleLayer:0];
    
}

//外面的圆
- (void)updatSemiellipseLayer:(CGFloat)per {
    if (per == 0) {
        self.semiellipseLayer.opacity = 0.0f;
    }
    else {
        self.semiellipseLayer.opacity = 1.0f;
        if (per >= 1) {
            per = 1;
        }
    }
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGPoint beginPoint = CGPointMake(0, 0);
    CGPoint endPoint = CGPointMake(width, 0);
    CGPoint controlPoint = CGPointMake(width/2, 125*width/415 * 2 * per);
    
    [self.beginPointLayer setPosition:beginPoint];
    [self.endPointLayer setPosition:endPoint];
    [self.controlPointLayer setPosition:controlPoint];
    
    CGPathRef path = [self pathCreateForCurrentControlPointPositions:self.beginPointLayer endPointLayer:self.endPointLayer controlPointLayer:self.controlPointLayer];
    [self.semiellipseLayer setPath:path];
    CFRelease(path);
}

//里面的圆
- (void)updatSemicircleLayer:(CGFloat)per {
    if (per == 0) {
        self.semicircleLayer.opacity = 0.0f;
    }
    else {
        self.semicircleLayer.opacity = 1.0f;
        if (per >= 1) {
            per = 1;
        }
    }
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGPoint centerPoint = CGPointMake(width/2, 0);
    
    //130 和 415 是根据设计计算的比例值
    CGPathRef path = [self pathCreateForRadiusPositions:centerPoint endPointLayer:self.endPointLayer radius:130*width/415/2 * per];
    [self.semicircleLayer setPath:path];
    CFRelease(path);
}

#pragma mark - 公共方法

- (void)animationStartWithMobileNum:(NSInteger)mobileNum {
    
}

- (void)animationStartWithCloseEyesNum:(NSInteger)mobileNum {
    
    [self updatSemiellipseLayer:1];
    [self updatSemicircleLayer:1];
    self.topLineLayer.strokeStart = 0.f;
    self.topLineLayer.strokeEnd = 1.0f;
    
    CGFloat animationTime = 1.5/2;
    CGFloat animationFrameTime = 0.05f;
    
    __weak __typeof(self)weakSelf = self;
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    uint64_t interval = (uint64_t)(animationFrameTime * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), interval, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        if (weakSelf.animationNum >= 1) {
            weakSelf.increasingState = 1;
            weakSelf.animationNum -= animationFrameTime/animationTime;
        }
        if (weakSelf.animationNum <= 0){
            weakSelf.increasingState = 2;
            weakSelf.animationNum += animationFrameTime/animationTime;
        }

        if (weakSelf.increasingState == 1) {
            weakSelf.animationNum -= animationFrameTime/animationTime * 2;
        }
        if (weakSelf.increasingState == 2) {
            weakSelf.animationNum += animationFrameTime/animationTime;
        }
        
        [self updatSemiellipseLayer:weakSelf.animationNum];
        [self updatSemicircleLayer:weakSelf.animationNum];

    });
    dispatch_resume(self.timer);
    
}

- (void)dealloc {
    if (self.timer) {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
}


- (void)animationWith:(CGFloat)y {

    //第一阶动画占20%
    CGFloat viewHeight1 = NeedTotalheightSliding * 0.2;
    
    CGFloat storkeStartNum = 0.5 - (-y/(viewHeight1/2));
    CGFloat storkeEndNum = -y/(viewHeight1/2) + 0.5;
    
    if (storkeStartNum <= 0) {
        storkeStartNum = 0;
    }
    
    if (storkeEndNum >= 1) {
        storkeEndNum = 1;
    }
    
    self.topLineLayer.strokeStart = storkeStartNum;
    self.topLineLayer.strokeEnd = storkeEndNum;
    
    //第一阶段结束
    //开始第二阶段
    if (storkeEndNum >= 1) {
        [self updatSemiellipseLayer:-y/NeedTotalheightSliding];
        [self updatSemicircleLayer:-y/NeedTotalheightSliding];
    }
    else {
        self.semicircleLayer.opacity = 0.0f;
        self.semiellipseLayer.opacity = 0.0f;
    }
    
}

#pragma mark - getter

- (CAShapeLayer *)semiellipseLayer {
    if (_semiellipseLayer == nil) {
        _semiellipseLayer = [CAShapeLayer layer];
        
        _semiellipseLayer.fillColor = [UIColor clearColor].CGColor;
        _semiellipseLayer.borderColor = [UIColor blackColor].CGColor;
        _semiellipseLayer.strokeColor = [UIColor whiteColor].CGColor;
        
    }
    return _semiellipseLayer;
}

- (CAShapeLayer *)semicircleLayer {
    if (_semicircleLayer == nil) {
        _semicircleLayer = [CAShapeLayer layer];
        
        _semicircleLayer.borderColor = [UIColor blackColor].CGColor;
        _semicircleLayer.fillColor = [UIColor whiteColor].CGColor;
        _semicircleLayer.strokeColor = [UIColor whiteColor].CGColor;
        _semicircleLayer.lineWidth = 1;
        
    }
    return _semicircleLayer;
}


- (CAShapeLayer *)topLineLayer {
    if (_topLineLayer == nil) {
        _topLineLayer = [CAShapeLayer layer];
        
        UIBezierPath * bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(0, 0)];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), 0)];
        
        _topLineLayer.borderColor = [UIColor blackColor].CGColor;
        _topLineLayer.fillColor = [UIColor clearColor].CGColor;
        _topLineLayer.strokeColor = [UIColor whiteColor].CGColor;
        _topLineLayer.lineWidth = 1;
        _topLineLayer.path = [bezierPath CGPath];
    }
    return _topLineLayer;
}




- (CALayer *)beginPointLayer {
    if (_beginPointLayer == nil) {
        _beginPointLayer = [CALayer layer];
    }
    return _beginPointLayer;
}

- (CALayer *)endPointLayer {
    if (_endPointLayer == nil) {
        _endPointLayer = [CALayer layer];
    }
    return _endPointLayer;
}

- (CALayer *)controlPointLayer {
    if (_controlPointLayer == nil) {
        _controlPointLayer = [CALayer layer];
    }
    return _controlPointLayer;
}











@end
