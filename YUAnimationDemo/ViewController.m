//
//  ViewController.m
//  YUAnimationDemo
//
//  Created by 于博洋 on 2017/6/15.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import "ViewController.h"
#import "UIViewAnimateViewController.h"
#import "CALayerAnimateViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UIViewAnimateViewController * next = [[UIViewAnimateViewController alloc] init];
//    [self.navigationController pushViewController:next animated:YES];
    
    CALayerAnimateViewController * next = [[CALayerAnimateViewController alloc] init];
    [self.navigationController pushViewController:next animated:YES];
    
}

















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
