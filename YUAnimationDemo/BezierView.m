//
//  BezierView.m
//  YUAnimationDemo
//
//  Created by 于博洋 on 2017/6/15.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import "BezierView.h"

@interface BezierView ()

@property (nonatomic,strong) UIView * whiteView;

@property (nonatomic,strong) CALayer * beginPointLayer;
@property (nonatomic,strong) CALayer * endPointLayer;
@property (nonatomic,strong) CALayer * beginPointControlPointLayer;
@property (nonatomic,strong) CALayer * endPointControlPointLayer;

@property (nonatomic,strong) CAShapeLayer * shapeLayer;

@end

@implementation BezierView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.whiteView];
        
        [self.layer addSublayer:self.beginPointLayer];
        [self.layer addSublayer:self.endPointLayer];
        [self.layer addSublayer:self.beginPointControlPointLayer];
        [self.layer addSublayer:self.endPointControlPointLayer];
        
        //显示出贝塞尔曲线
        CALayer *rootLayer = [self layer];
        [rootLayer addSublayer:self.shapeLayer];
        [rootLayer addSublayer:self.beginPointLayer];
        [rootLayer addSublayer:self.endPointLayer];
        [rootLayer addSublayer:self.beginPointControlPointLayer];
        [rootLayer addSublayer:self.endPointControlPointLayer];
        
        self.whiteView.center = self.beginPointLayer.position;
    }
    return self;
}

// ownership is transferred to the caller
CGPathRef BTSPathCreateForCurrentControlPointPositions(CALayer *beginPointLayer, CALayer *endPointLayer, CALayer *beginPointControlPointLayer, CALayer *endPointControlPointLayer) {
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, [beginPointLayer position].x, [beginPointLayer position].y);
    CGPathAddCurveToPoint(path, NULL, [beginPointControlPointLayer position].x, [beginPointControlPointLayer position].y, [endPointControlPointLayer position].x, [endPointControlPointLayer position].y, [endPointLayer position].x, [endPointLayer position].y);
    return path;
}

- (void)updateAnimationForPath:(CGPathRef)path {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation setPath:path];
    [animation setAutoreverses:YES];
    [animation setRepeatCount:MAXFLOAT];
    [animation setDuration:5.0];
//    [animation setDelegate:self];
    [animation setCalculationMode:kCAAnimationPaced];
    
    [self.whiteView.layer addAnimation:animation forKey:@"bezierPathAnimation"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    
    [self updateAnimationForPath:[self.shapeLayer path]];

}


#pragma mark -- getter

- (CAShapeLayer *)shapeLayer {
    if (_shapeLayer == nil) {
        CGPathRef path = BTSPathCreateForCurrentControlPointPositions(self.beginPointLayer, self.endPointLayer, self.beginPointControlPointLayer, self.endPointControlPointLayer);
        
        _shapeLayer = [CAShapeLayer layer];
        [_shapeLayer setPath:path];
        [_shapeLayer setFillRule:kCAFillRuleEvenOdd];
        [_shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
        [_shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
        [_shapeLayer setLineWidth:2.0];
        
        CFRelease(path);
    }
    return _shapeLayer;
}

- (CALayer *)endPointControlPointLayer {
    if (_endPointControlPointLayer == nil) {
        CGFloat midY = CGRectGetMidY([self bounds]);
        
        _endPointControlPointLayer = [CALayer layer];
        _endPointControlPointLayer.backgroundColor = [UIColor grayColor].CGColor;
        _endPointControlPointLayer.frame = CGRectMake(0, 0, 10, 10);
        [_endPointControlPointLayer setPosition:CGPointMake([self bounds].size.width - 40.0, midY)];
    }
    return _endPointControlPointLayer;
}

- (CALayer *)beginPointControlPointLayer {
    if (_beginPointControlPointLayer == nil) {
        CGFloat midY = CGRectGetMidY([self bounds]);
        
        _beginPointControlPointLayer = [CALayer layer];
        _beginPointControlPointLayer.backgroundColor = [UIColor blueColor].CGColor;
        _beginPointControlPointLayer.frame = CGRectMake(0, 0, 10, 10);
        [_beginPointControlPointLayer setPosition:CGPointMake(40.0, midY)];
    }
    return _beginPointControlPointLayer;
}

- (CALayer *)endPointLayer {
    if (_endPointLayer == nil) {
        CGFloat midX = CGRectGetMidX([self bounds]);
        
        _endPointLayer = [CALayer layer];
        _endPointLayer.backgroundColor = [UIColor grayColor].CGColor;
        _endPointLayer.frame = CGRectMake(0, 0, 10, 10);
        [_endPointLayer setPosition:CGPointMake(midX, [self bounds].size.height - 40.0)];
    }
    return _endPointLayer;
}

- (CALayer *)beginPointLayer {
    if (_beginPointLayer == nil) {
        
        CGFloat midX = CGRectGetMidX([self bounds]);
        
        _beginPointLayer = [CALayer layer];
        _beginPointLayer.backgroundColor = [UIColor blueColor].CGColor;
        _beginPointLayer.frame = CGRectMake(0, 0, 10, 10);
        [_beginPointLayer setPosition:CGPointMake(midX, 80.0)];
    }
    return _beginPointLayer;
}

-(UIView *)whiteView {
    if (_whiteView == nil) {
        _whiteView = [[UIView alloc] init];
        _whiteView.frame = CGRectMake(0, 0, 40, 40);
        _whiteView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteView;
}

@end
