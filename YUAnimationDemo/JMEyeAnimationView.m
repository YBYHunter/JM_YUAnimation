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

@property (nonatomic,assign) CGFloat currentY;

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
    }
    return self;
}

-(CGPathRef)pathCreateForCurrentControlPointPositions:(CALayer *)beginPointLayer endPointLayer:(CALayer *)endPointLayer controlPointLayer:(CALayer *)controlPointLayer {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, [beginPointLayer position].x, [beginPointLayer position].y);
    CGPathAddQuadCurveToPoint(path, NULL, [controlPointLayer position].x, [controlPointLayer position].y, [endPointLayer position].x, [endPointLayer position].y);
    
    return path;
}

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
        if (per >= 1.5) {
            per = 1.5;
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
    
    if (storkeEndNum >= 1) {
        [self updatSemiellipseLayer:-y/NeedTotalheightSliding];
        [self updatSemicircleLayer:-y/NeedTotalheightSliding];
    }
    else {
        self.semicircleLayer.opacity = 0.0f;
        self.semiellipseLayer.opacity = 0.0f;
    }
    
    
    _currentY = y;
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
