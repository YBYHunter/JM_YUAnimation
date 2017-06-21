//
//  LayerAnimationView.m
//  YUAnimationDemo
//
//  Created by 于博洋 on 2017/6/21.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import "LayerAnimationView.h"

@interface LayerAnimationView ()

@property (nonatomic,strong) UIButton * roundedCornersButton;

@property (nonatomic,strong) UIButton * sizeButton;

@property (nonatomic,strong) CALayer * animationLayer;

@end

@implementation LayerAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.animationLayer];
        [self addSubview:self.roundedCornersButton];
        [self addSubview:self.sizeButton];
    }
    return self;
}

- (void)layoutSubviews {
    
    self.roundedCornersButton.frame = CGRectMake(0, self.frame.size.height - self.roundedCornersButton.frame.size.height, self.roundedCornersButton.frame.size.width, self.roundedCornersButton.frame.size.height);
    
    self.sizeButton.frame = CGRectMake(self.sizeButton.frame.origin.x, self.frame.size.height - self.sizeButton.frame.size.height, self.sizeButton.frame.size.width, self.sizeButton.frame.size.height);
    
    
    
}

- (void)sizeButtonAction {
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationDuration:0.25];
    
    CGRect layerBounds = self.animationLayer.bounds;
    layerBounds.size.width = (layerBounds.size.width == layerBounds.size.height) ? 50.0 : 100.0;
    [self.animationLayer setBounds:layerBounds];
    
}

- (void)roundedCornersButtonAction {
    
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationDuration:0.25];
    [self.animationLayer setCornerRadius:([self.animationLayer cornerRadius] >= 25.0 ? 0.0 : 25.0)];
    
}

#pragma mark - getter

- (CALayer *)animationLayer {
    if (_animationLayer == nil) {
        _animationLayer = [CALayer layer];
        _animationLayer.frame = CGRectMake(100, 0, 100, 100);
        _animationLayer.contentsScale = [[UIScreen mainScreen] scale];
        _animationLayer.backgroundColor = [UIColor blueColor].CGColor;
    }
    return _animationLayer;
}

- (UIButton *)roundedCornersButton {
    if (_roundedCornersButton == nil) {
        _roundedCornersButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _roundedCornersButton.frame = CGRectMake(0, 0, 64, 44);
        [_roundedCornersButton setTitle:@"圆角动画" forState:UIControlStateNormal];
        _roundedCornersButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [_roundedCornersButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _roundedCornersButton.backgroundColor = [UIColor whiteColor];
        [_roundedCornersButton addTarget:self action:@selector(roundedCornersButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _roundedCornersButton;
}

- (UIButton *)sizeButton {
    if (_sizeButton == nil) {
        _sizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sizeButton.frame = CGRectMake(74, 0, 64, 44);
        [_sizeButton setTitle:@"大小动画" forState:UIControlStateNormal];
        _sizeButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [_sizeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _sizeButton.backgroundColor = [UIColor whiteColor];
        [_sizeButton addTarget:self action:@selector(sizeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sizeButton;
}




























@end
