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
#import "AdvancedAnimationViewController.h"
#import "PracticalAnimationViewController.h"

@interface ViewController ()

@property (nonatomic,strong) UIButton * viewAnimationButton;

@property (nonatomic,strong) UIButton * layerAnimationButton;

@property (nonatomic,strong) UIButton * advancedLayerAnimationButton;

//实用的一些demo
@property (nonatomic,strong) UIButton * practicalLayerAnimationButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.viewAnimationButton];
    [self.view addSubview:self.layerAnimationButton];
    [self.view addSubview:self.advancedLayerAnimationButton];
    [self.view addSubview:self.practicalLayerAnimationButton];
}

- (void)layerAnimationAction {

    CALayerAnimateViewController * next = [[CALayerAnimateViewController alloc] init];
    [self.navigationController pushViewController:next animated:YES];
    
}

- (void)viewAnimationAction {
    UIViewAnimateViewController * next = [[UIViewAnimateViewController alloc] init];
    [self.navigationController pushViewController:next animated:YES];

}

- (void)advancedAnimationAction {
    AdvancedAnimationViewController * next = [[AdvancedAnimationViewController alloc] init];
    [self.navigationController pushViewController:next animated:YES];
}

- (void)practicalAnimationAction {
    PracticalAnimationViewController * next = [[PracticalAnimationViewController alloc] init];
    [self.navigationController pushViewController:next animated:YES];
}

#pragma mark - getter

- (UIButton *)practicalLayerAnimationButton {
    if (_practicalLayerAnimationButton == nil) {
        _practicalLayerAnimationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _practicalLayerAnimationButton.backgroundColor = [UIColor yellowColor];
        _practicalLayerAnimationButton.frame = CGRectMake(0, 64 * 4, self.view.frame.size.width, 64);
        [_practicalLayerAnimationButton setTitle:@"一些实用动画demo" forState:UIControlStateNormal];
        [_practicalLayerAnimationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_practicalLayerAnimationButton addTarget:self action:@selector(practicalAnimationAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _practicalLayerAnimationButton;
}


- (UIButton *)advancedLayerAnimationButton {
    if (_advancedLayerAnimationButton == nil) {
        _advancedLayerAnimationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _advancedLayerAnimationButton.backgroundColor = [UIColor redColor];
        _advancedLayerAnimationButton.frame = CGRectMake(0, 64 + 64 + 64, self.view.frame.size.width, 64);
        [_advancedLayerAnimationButton setTitle:@"高级一些的动画" forState:UIControlStateNormal];
        [_advancedLayerAnimationButton addTarget:self action:@selector(advancedAnimationAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _advancedLayerAnimationButton;
}

- (UIButton *)layerAnimationButton {
    if (_layerAnimationButton == nil) {
        _layerAnimationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _layerAnimationButton.backgroundColor = [UIColor yellowColor];
        _layerAnimationButton.frame = CGRectMake(0, 64 + 64, self.view.frame.size.width, 64);
        [_layerAnimationButton setTitle:@"layer层动画" forState:UIControlStateNormal];
        [_layerAnimationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_layerAnimationButton addTarget:self action:@selector(layerAnimationAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _layerAnimationButton;
}


- (UIButton *)viewAnimationButton {
    if (_viewAnimationButton == nil) {
        _viewAnimationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _viewAnimationButton.backgroundColor = [UIColor redColor];
        _viewAnimationButton.frame = CGRectMake(0, 64, self.view.frame.size.width, 64);
        [_viewAnimationButton setTitle:@"UIView层动画" forState:UIControlStateNormal];
        [_viewAnimationButton addTarget:self action:@selector(viewAnimationAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _viewAnimationButton;
}















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
