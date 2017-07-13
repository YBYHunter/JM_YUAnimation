//
//  JM_YUVoiceAnimation.m
//  YUAnimationDemo
//
//  Created by 于博洋 on 2017/7/13.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import "JM_YUVoiceAnimation.h"
#import "WaveView.h"

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]


@interface JM_YUVoiceAnimation ()

@property (nonatomic,strong) WaveView * waveView;

@property (nonatomic,strong) WaveView * waveViewTwo;

@property (nonatomic,strong) WaveView * waveViewThree;

@end



@implementation JM_YUVoiceAnimation

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.waveViewThree];
        [self addSubview:self.waveViewTwo];
        [self addSubview:self.waveView];
        
        [self.waveView startPhaseAnimation:0.01];
        [self.waveViewTwo startPhaseAnimation:0.02];
        [self.waveViewThree startPhaseAnimation:0.009];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.waveView.frame = self.bounds;
    self.waveViewTwo.frame = self.bounds;
    self.waveViewThree.frame = self.bounds;
}


- (void)updateWithLevel:(CGFloat)percentage {
    
    percentage = fmax(percentage, 0.266667);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.waveView.amplitude = percentage;
        self.waveViewTwo.amplitude = fmin(percentage, 0.4);
    });
}


- (void)stopAnimation {
    [self.waveView endPhaseAnimation];
    [self.waveViewTwo endPhaseAnimation];
    [self.waveViewThree endPhaseAnimation];
}


#pragma amrk - getter


- (WaveView *)waveView {
    if (_waveView == nil) {
        _waveView = [[WaveView alloc] init];
        
        _waveView.backgroundColor = [UIColor clearColor];
        _waveView.primaryWaveLineColor = [UIColor whiteColor];
        _waveView.primaryWaveLineWidth = 1;
        _waveView.density = 1.800000;
        _waveView.frequency = 7.533334;
        _waveView.amplitude = 0.266667;
    }
    return _waveView;
}

- (WaveView *)waveViewTwo {
    if (_waveViewTwo == nil) {
        _waveViewTwo = [[WaveView alloc] init];
        
        _waveViewTwo.backgroundColor = [UIColor clearColor];
        _waveViewTwo.primaryWaveLineColor = RGBACOLOR(223, 158, 147, 1);
        _waveViewTwo.primaryWaveLineWidth = 1;
        _waveViewTwo.density = 1.800000;
        _waveViewTwo.frequency = 7.533334;
        _waveViewTwo.amplitude = 0.266667;
    }
    return _waveViewTwo;
}

- (WaveView *)waveViewThree {
    if (_waveViewThree == nil) {
        _waveViewThree = [[WaveView alloc] init];
        _waveViewThree.backgroundColor = RGBACOLOR(216, 133, 119, 1);
        _waveViewThree.primaryWaveLineColor = RGBACOLOR(223, 158, 147, 1);
        _waveViewThree.primaryWaveLineWidth = 2;
        _waveViewThree.density = 4.466667;
        _waveViewThree.frequency = 2.866667;
        _waveViewThree.amplitude = 0.620000;
    }
    return _waveViewThree;
}

























@end
