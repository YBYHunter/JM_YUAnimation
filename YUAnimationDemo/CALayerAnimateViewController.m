//
//  CALayerAnimateViewController.m
//  YUAnimationDemo
//
//  Created by 于博洋 on 2017/6/15.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import "CALayerAnimateViewController.h"
#import "BezierView.h"
#import "WXEyeAnimationView.h"
#import "BendingAnimationView.h"
#import "JMEyeAnimationView.h"

@interface CALayerAnimateViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIView * baseAnimateView;

@property (nonatomic,strong) UIView * loadingView;

@property (nonatomic,strong) BezierView * bezierView;

@property (nonatomic,strong) WXEyeAnimationView * eyeAnimationView;

@property (nonatomic,strong) BendingAnimationView * bendingAnimationView;

@property (nonatomic,strong) JMEyeAnimationView * jmEyeAnimationView;

@property (nonatomic,strong) UIScrollView * aScrollView;

@end

@implementation CALayerAnimateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CALayer层动画";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:self.aScrollView];
    [self.aScrollView addSubview:self.loadingView];
    [self.aScrollView addSubview:self.baseAnimateView];
    [self.aScrollView addSubview:self.bezierView];
    
    
    
    //CABaseAnimation
    //可以试试 0  1 和其他值
    CABasicAnimation * basicAnimation = [self basicAnimationWithNum:0];
    UIView * redView = [[UIView alloc] init];
    redView.frame = CGRectMake(10, 10, 40, 40);
    redView.backgroundColor = [UIColor redColor];
    [redView.layer addAnimation:basicAnimation forKey:nil];
//    [self.baseAnimateView addSubview:redView];
    
//    CAKeyframeAnimation * keyframeAnimation = [[CAKeyframeAnimation alloc] init];
    
    
    //贝塞尔曲线
    //bezierView
    
    //
    [self.loadingView addSubview:self.eyeAnimationView];
    [self.loadingView addSubview:self.bendingAnimationView];
    [self.loadingView addSubview:self.jmEyeAnimationView];
    
    
}



#pragma mark - CABasicAnimation

- (CABasicAnimation *)basicAnimationWithNum:(BOOL)num {
    CGPoint fromPoint = CGPointMake(10, 10);
    CGPoint toPoint = CGPointMake(200, 150);
    
    CABasicAnimation * basicAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    basicAnimation.fromValue = [NSValue valueWithCGPoint:fromPoint];
    basicAnimation.toValue = [NSValue valueWithCGPoint:toPoint];
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    basicAnimation.duration = 0.5;
    if (num == 1) {
        basicAnimation.repeatCount = 1;
        basicAnimation.autoreverses = NO;
    }
    else if (num == 0) {
        basicAnimation.repeatCount = MAXFLOAT;
        basicAnimation.autoreverses = YES;
    }
    else {
        basicAnimation.repeatCount = num;
        basicAnimation.autoreverses = YES;
    }
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    return basicAnimation;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.eyeAnimationView animationWith:scrollView.contentOffset.y + 64];
    [self.bendingAnimationView animationWith:scrollView.contentOffset.y + 64];
    [self.jmEyeAnimationView animationWith:scrollView.contentOffset.y + 64];
}

#pragma mark - getter

- (JMEyeAnimationView *)jmEyeAnimationView {
    if (_jmEyeAnimationView == nil) {
        _jmEyeAnimationView = [[JMEyeAnimationView alloc] initWithFrame:CGRectMake((self.loadingView.frame.size.width - 50)/4 * 3, (self.loadingView.frame.size.height - 30)/2, 50, 30)];
    }
    return _jmEyeAnimationView;
}

- (BendingAnimationView *)bendingAnimationView {
    if (_bendingAnimationView == nil) {
        _bendingAnimationView = [[BendingAnimationView alloc] initWithFrame:CGRectMake((self.loadingView.frame.size.width - 50)/4, (self.loadingView.frame.size.height - 30)/2, 50, 30)];
        
    }
    return _bendingAnimationView;
}

- (WXEyeAnimationView *)eyeAnimationView {
    if (_eyeAnimationView == nil) {
        _eyeAnimationView = [[WXEyeAnimationView alloc] initWithFrame:CGRectMake((self.loadingView.frame.size.width - 50)/2, (self.loadingView.frame.size.height - 30)/2, 50, 30)];
    }
    return _eyeAnimationView;
}

- (UIView *)loadingView {
    if (_loadingView == nil) {
        _loadingView = [[UIView alloc] init];
        _loadingView.backgroundColor = [UIColor blackColor];
        _loadingView.frame = CGRectMake(0, -64, self.view.frame.size.width, 64);
    }
    return _loadingView;
}

-(UIScrollView *)aScrollView {
    if (_aScrollView == nil) {
        _aScrollView = [[UIScrollView alloc] init];
        _aScrollView.clipsToBounds = NO;
        _aScrollView.delegate = self;
        _aScrollView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
        _aScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 2);
    }
    return _aScrollView;
}

- (BezierView *)bezierView {
    if (_bezierView == nil) {
        _bezierView = [[BezierView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 400)];
        _bezierView.backgroundColor = [UIColor redColor];

    }
    return _bezierView;
}

- (UIView *)baseAnimateView {
    if (_baseAnimateView == nil) {
        _baseAnimateView = [[UIView alloc] init];
        _baseAnimateView.backgroundColor = [UIColor whiteColor];
        _baseAnimateView.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    }
    return _baseAnimateView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
