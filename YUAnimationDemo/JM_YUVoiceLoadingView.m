//
//  JM_YUVoiceLoadingView.m
//  YUAnimationDemo
//
//  Created by 于博洋 on 2017/7/27.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import "JM_YUVoiceLoadingView.h"

static CGFloat const AllLineWidth = 4.0f;

@interface JM_YUVoiceLoadingView ()

@property (strong, nonatomic) CAShapeLayer * oneLayer;

@property (strong, nonatomic) CAShapeLayer * twoLayer;

@property (strong, nonatomic) CAShapeLayer * threeLayer;

@property (nonatomic,strong) dispatch_source_t timer;

@end


@implementation JM_YUVoiceLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.oneLayer];
        [self.layer addSublayer:self.twoLayer];
        [self.layer addSublayer:self.threeLayer];
        
        [self updateInitialState];
    }
    return self;
}

- (void)updateInitialState {
    self.oneLayer.strokeStart = 0.3;
    self.oneLayer.strokeEnd = 0.6;
    
    self.twoLayer.strokeStart = 0.2;
    self.twoLayer.strokeEnd= 0.8;
    
    self.threeLayer.strokeStart = 0;
    self.threeLayer.strokeEnd = 1;
}

- (void)startAnimation {
    
    [self updateInitialState];
    
    CGFloat increment = 0.04;
    __block CGFloat minimumNum = 0.6;
    __block BOOL isOneAdd = YES;
    __block BOOL isTwoAdd = YES;
    __block BOOL isThreeAdd = YES;
    
    __weak __typeof(self)weakSelf = self;
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    uint64_t interval = (uint64_t)(0.04 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), interval, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        
        if (weakSelf.oneLayer.strokeEnd >= 1) {
            isOneAdd = NO;
        }
        else if (weakSelf.oneLayer.strokeEnd <= minimumNum) {
            isOneAdd = YES;
        }
        
        if (weakSelf.twoLayer.strokeEnd >= 1) {
            isTwoAdd = NO;
        }
        else if (weakSelf.twoLayer.strokeEnd <= minimumNum) {
            isTwoAdd = YES;
        }
        
        if (weakSelf.threeLayer.strokeEnd >= 1) {
            isThreeAdd = NO;
        }
        else if (weakSelf.threeLayer.strokeEnd <= minimumNum) {
            isThreeAdd = YES;
        }
        
        
        if (isOneAdd) {
            weakSelf.oneLayer.strokeStart -= increment;
            weakSelf.oneLayer.strokeEnd += increment;
        }
        else {
            weakSelf.oneLayer.strokeStart += increment;
            weakSelf.oneLayer.strokeEnd -= increment;
        }
        
        if (isTwoAdd) {
            weakSelf.twoLayer.strokeStart -= increment;
            weakSelf.twoLayer.strokeEnd += increment;
        }
        else {
            weakSelf.twoLayer.strokeStart += increment;
            weakSelf.twoLayer.strokeEnd -= increment;
        }
        
        if (isThreeAdd) {
            weakSelf.threeLayer.strokeStart -= increment;
            weakSelf.threeLayer.strokeEnd += increment;
        }
        else {
            weakSelf.threeLayer.strokeStart += increment;
            weakSelf.threeLayer.strokeEnd -= increment;
        }
        
    });
    dispatch_resume(self.timer);
}

- (void)stopAnimation {
    [self updateInitialState];
    if (self.timer) {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
}


#pragma mark - getter

- (CAShapeLayer *)twoLayer {
    if (_twoLayer == nil) {
        _twoLayer = [CAShapeLayer layer];
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(self.frame.size.width/2 - AllLineWidth, 0)];
        [path addLineToPoint:CGPointMake(self.frame.size.width/2 - AllLineWidth, self.frame.size.height)];
        
        _twoLayer.borderColor = [UIColor blackColor].CGColor;
        _twoLayer.lineWidth = AllLineWidth;
        _twoLayer.path = path.CGPath;
        _twoLayer.fillColor = [UIColor clearColor].CGColor;
        _twoLayer.strokeColor = [UIColor blackColor].CGColor;
        _twoLayer.strokeEnd = 1;
        
    }
    return _twoLayer;
}

- (CAShapeLayer *)threeLayer {
    if (_threeLayer == nil) {
        _threeLayer = [CAShapeLayer layer];
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(self.frame.size.width - AllLineWidth, 0)];
        [path addLineToPoint:CGPointMake(self.frame.size.width - AllLineWidth, self.frame.size.height)];
        
        _threeLayer.borderColor = [UIColor blackColor].CGColor;
        _threeLayer.lineWidth = AllLineWidth;
        _threeLayer.path = path.CGPath;
        _threeLayer.fillColor = [UIColor clearColor].CGColor;
        _threeLayer.strokeColor = [UIColor blackColor].CGColor;
        _threeLayer.strokeEnd = 1;
        
    }
    return _threeLayer;
}

- (CAShapeLayer *)oneLayer {
    if (_oneLayer == nil) {
        _oneLayer = [CAShapeLayer layer];
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
        
        _oneLayer.borderColor = [UIColor blackColor].CGColor;
        _oneLayer.lineWidth = AllLineWidth;
        _oneLayer.path = path.CGPath;
        _oneLayer.fillColor = [UIColor clearColor].CGColor;
        _oneLayer.strokeColor = [UIColor blackColor].CGColor;
        _oneLayer.strokeEnd = 1;
        
    }
    return _oneLayer;
}

























@end
