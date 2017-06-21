//
//  AdvancedAnimationViewController.m
//  YUAnimationDemo
//
//  Created by 于博洋 on 2017/6/20.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import "AdvancedAnimationViewController.h"
#import "JMEyeAnimationView.h"
#import "ReflectionView.h"

@interface AdvancedAnimationViewController ()

@property (nonatomic,strong) JMEyeAnimationView * eyeCloseAnimation;

@property (nonatomic,strong) ReflectionView * reflectionView;

@end

@implementation AdvancedAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.eyeCloseAnimation];
    [self.view addSubview:self.reflectionView];
    
    self.eyeCloseAnimation.backgroundColor = [UIColor redColor];
    [self.eyeCloseAnimation animationStartWithCloseEyesNum:1];
    
}

#pragma mark - getter

- (ReflectionView *)reflectionView {
    if (_reflectionView == nil) {
        _reflectionView = [[ReflectionView alloc] initWithFrame:CGRectMake(0, 64 + 70, self.view.frame.size.width, 300)];
    }
    return _reflectionView;
}

- (JMEyeAnimationView *)eyeCloseAnimation {
    if (_eyeCloseAnimation == nil) {
        _eyeCloseAnimation = [[JMEyeAnimationView alloc] initWithFrame:CGRectMake(0, 64, 150, 70)];
    }
    return _eyeCloseAnimation;
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
