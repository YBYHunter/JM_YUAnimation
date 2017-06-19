//
//  UIViewAnimateViewController.m
//  YUAnimationDemo
//
//  Created by 于博洋 on 2017/6/15.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import "UIViewAnimateViewController.h"

@interface UIViewAnimateViewController ()

@property (nonatomic,strong) UIView * redView;

@end

@implementation UIViewAnimateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"UIView动画";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.redView];
    
    
    //动画1
    [UIView animateWithDuration:0.35 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.redView.frame = CGRectMake(0, 200, 100, 100);
    } completion:^(BOOL finished) {
        
    }];
    
    //动画2
    [UIView animateWithDuration:0.35 delay:1.35 usingSpringWithDamping:0.9 initialSpringVelocity:15 options:UIViewAnimationOptionCurveLinear animations:^{
        self.redView.frame = CGRectMake(200, 300, 150, 150);
    } completion:^(BOOL finished) {
        
    }];
    
}




#pragma mark - getter

- (UIView *)redView {
    if (_redView == nil) {
        _redView = [[UIView alloc] init];
        _redView.backgroundColor = [UIColor redColor];
        _redView.frame = CGRectMake(100, 100, 100, 100);
    }
    return _redView;
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
