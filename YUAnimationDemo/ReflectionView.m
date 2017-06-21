//
//  ReflectionView.m
//  YUAnimationDemo
//
//  Created by 于博洋 on 2017/6/21.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import "ReflectionView.h"

@interface ReflectionView ()

@property (nonatomic,strong) CALayer * imageLayer;

@end

@implementation ReflectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage * image = [UIImage imageNamed:@"fd68f3e0584f.jpg"];
        
        //反射
        CAReplicatorLayer * replicatorLayer = [CAReplicatorLayer layer];
        [replicatorLayer setContentsScale:[[UIScreen mainScreen] scale]];
        [replicatorLayer setBounds:CGRectMake(0, 0, image.size.width, image.size.height * 2)];
        replicatorLayer.masksToBounds = YES;
        replicatorLayer.anchorPoint = CGPointMake(0.5, 0.0);
        [replicatorLayer setPosition:CGPointMake(self.frame.size.width / 2.0, 0)];
        [replicatorLayer setInstanceCount:2];
        replicatorLayer.backgroundColor = [UIColor blueColor].CGColor;
        
        //旋转
        CATransform3D transform = CATransform3DIdentity;
        transform = CATransform3DScale(transform, 1.0, -1.0, 1.0);
        transform = CATransform3DTranslate(transform, 0.0, -[image size].height * 2.0, 1.0);
        [replicatorLayer setInstanceTransform:transform];
        
        //添加图片
        self.imageLayer = [CALayer layer];
        [self.imageLayer setContentsScale:[[UIScreen mainScreen] scale]];
        [self.imageLayer setContents:(__bridge id)[image CGImage]];
        [self.imageLayer setBounds:CGRectMake(0, 0, image.size.width, image.size.height)];
        [self.imageLayer setAnchorPoint:CGPointMake(0.0, 0.0)];
        [replicatorLayer addSublayer:self.imageLayer];
        
        //渐变
        CAGradientLayer * gradientLayer = [CAGradientLayer layer];
        [gradientLayer setContentsScale:[[UIScreen mainScreen] scale]];
        [gradientLayer setColors:@[
            (__bridge id)[[[UIColor whiteColor] colorWithAlphaComponent:0.5] CGColor],
            (__bridge id)[[UIColor whiteColor] CGColor]
        ]];
        [gradientLayer setBounds:CGRectMake(0, 0, replicatorLayer.frame.size.width, image.size.height * 2.0)];
        [gradientLayer setAnchorPoint:CGPointMake(0.5, 0.0)];
        [gradientLayer setPosition:CGPointMake(self.frame.size.width / 2, image.size.height)];
        [gradientLayer setZPosition:1];
        
        [self.layer addSublayer:replicatorLayer];
        [self.layer addSublayer:gradientLayer];
        
        //文字
        CATextLayer *textLayer = [CATextLayer layer];
        [textLayer setContentsScale:[[UIScreen mainScreen] scale]];
        [textLayer setString:@"点我，点我"];
        [textLayer setAlignmentMode:kCAAlignmentCenter];
        CGFloat height = [(UIFont *)[textLayer font] lineHeight];
        [textLayer setBounds:CGRectMake(0.0, 0.0, [self.imageLayer frame].size.width, height)];
        [textLayer setPosition:CGPointMake([self.imageLayer frame].size.width / 2.0, [self.imageLayer frame].size.height - 25.0)];
        textLayer.foregroundColor = [UIColor redColor].CGColor;
        [textLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
        [self.imageLayer addSublayer:textLayer];
        
        [self setUserInteractionEnabled:YES];
        [self setMultipleTouchEnabled:YES];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animateTextLayer:)]];
    }
    return self;
}


- (void)animateTextLayer:(UIGestureRecognizer *)recognizer {
    CALayer *textLayer = (CALayer *)[[self.imageLayer sublayers] objectAtIndex:0];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    
    CGFloat halfBoxHeight = [textLayer frame].size.height / 2.0;
    [animation setFromValue:@([textLayer frame].origin.y + halfBoxHeight)];
    [animation setToValue:@(halfBoxHeight)];
    [animation setDuration:3.0];
    [animation setRepeatCount:MAXFLOAT];
    [animation setAutoreverses:YES];
    
    [textLayer addAnimation:animation forKey:nil];
}



















@end
