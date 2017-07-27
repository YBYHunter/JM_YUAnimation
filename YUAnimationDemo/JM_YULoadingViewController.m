//
//  JM_YULoadingViewController.m
//  YUAnimationDemo
//
//  Created by 于博洋 on 2017/7/26.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import "JM_YULoadingViewController.h"
#import "JM_YULoadingView.h"
#import "JM_YUVoiceLoadingView.h"

@interface JM_YULoadingViewController ()

@property (nonatomic,strong) JM_YULoadingView * loadingView;

@property (nonatomic,strong) JM_YUVoiceLoadingView * voiceLoadingView;

@property (nonatomic,strong) UIButton * startButton;

@property (nonatomic,strong) UIButton * stopButton;

@end

@implementation JM_YULoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self.view addSubview:self.loadingView];
    [self.view addSubview:self.voiceLoadingView];
    
    [self.view addSubview:self.startButton];
    
    [self.view addSubview:self.stopButton];
}

- (void)startButtonAction {
    [self.loadingView startAnimation];
    [self.voiceLoadingView startAnimation];
}

- (void)stopButtonAction {
    [self.loadingView pauseAnimation];
    [self.voiceLoadingView stopAnimation];
}

#pragma mark - getter

- (UIButton *)stopButton {
    if (_stopButton == nil) {
        _stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _stopButton.backgroundColor = [UIColor redColor];
        _stopButton.frame = CGRectMake(0, 64 * 8 + 10, self.view.frame.size.width, 64);
        [_stopButton setTitle:@"暂停动画" forState:UIControlStateNormal];
        [_stopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_stopButton addTarget:self action:@selector(stopButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopButton;
}

- (UIButton *)startButton {
    if (_startButton == nil) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.backgroundColor = [UIColor redColor];
        _startButton.frame = CGRectMake(0, 64 * 7, self.view.frame.size.width, 64);
        [_startButton setTitle:@"开始动画" forState:UIControlStateNormal];
        [_startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(startButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}


- (JM_YUVoiceLoadingView *)voiceLoadingView {
    if (_voiceLoadingView == nil) {
        _voiceLoadingView = [[JM_YUVoiceLoadingView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
        _voiceLoadingView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    }
    return _voiceLoadingView;
}

- (JM_YULoadingView *)loadingView {
    if (_loadingView == nil) {
        _loadingView = [[JM_YULoadingView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2, 64, 64)];
    }
    return _loadingView;
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
