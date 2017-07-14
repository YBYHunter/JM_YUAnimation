//
//  PracticalAnimationViewController.m
//  YUAnimationDemo
//
//  Created by 于博洋 on 2017/6/22.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import "PracticalAnimationViewController.h"
#import "JM_YUVoiceAnimation.h"
#import "LVRecordTool.h"

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface PracticalAnimationViewController ()<LVRecordToolDelegate>

@property (nonatomic,strong) JM_YUVoiceAnimation * voiceAnimation;
@property (nonatomic,strong) LVRecordTool * recordTool;             //录音控件

@property (nonatomic,strong) UIButton * voiceButton;

@property (nonatomic,strong) UIButton * stopButton;

@property (nonatomic,strong) UIButton * startButton;

@property (nonatomic,strong) UISlider * dSlider;

@property (nonatomic,assign) double lowPassResults;

@end

@implementation PracticalAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.recordTool = [LVRecordTool sharedRecordTool];
    self.recordTool.delegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.voiceAnimation];
    
    UISlider * dSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 500, 300, 20)];
    dSlider.minimumValue = 0.0;// 设置最小值
    dSlider.maximumValue = 1;// 设置最大值
    dSlider.value = (dSlider.minimumValue + dSlider.maximumValue) / 2;// 设置初始值
    dSlider.continuous = YES;// 设置可连续变化
    [dSlider addTarget:self action:@selector(dsliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
    [self.view addSubview:dSlider];
    _dSlider = dSlider;
    
    [self.view addSubview:self.voiceButton];
    [self.view addSubview:self.stopButton];
    [self.view addSubview:self.startButton];
}

- (void)updateMeters {
    
}

- (void)dsliderValueChanged:(UISlider *)sender {
    
    [self.voiceAnimation updateWithLevel:sender.value];
    self.title = [NSString stringWithFormat:@"%.2f,",sender.value];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
}

#pragma mark - LVRecordToolDelegate

- (void)recordTool:(LVRecordTool *)recordTool didstartRecoring:(CGFloat)no {
    CGFloat normalizedValue = [recordTool.recorder averagePowerForChannel:0];
    if (normalizedValue < -60.0f || normalizedValue == 0.0f) {
        normalizedValue = 0.0f;
    }
    normalizedValue = powf((powf(10.0f, 0.05f * normalizedValue) - powf(10.0f, 0.05f * -60.0f)) * (1.0f / (1.0f - powf(10.0f, 0.05f * -60.0f))), 1.0f / 2.0f);
    normalizedValue = arc4random()%70/100.0;
    
    
    CGFloat aaaa = 0.05;
    const double ALPHA = aaaa;
    double peakPowerForChannel = pow(10, (aaaa * [recordTool.recorder peakPowerForChannel:0]));
    _lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * _lowPassResults;
    CGFloat currentLevel = _lowPassResults/aaaa/(1/aaaa) * 1.9;
    if (currentLevel >= 0.620000) {
        currentLevel = 0.620000;
    }
    [self.voiceAnimation updateWithLevel:currentLevel];
    self.title = [NSString stringWithFormat:@"%.2f,",currentLevel];
    _dSlider.value = currentLevel;
    
}

- (void)recordTool:(LVRecordTool *)recordTool recordingTimeout:(BOOL)isTimeout {

}


- (void)stopButtonAction {
    [self.voiceAnimation updateWithColor:[UIColor blackColor] color2:[UIColor blackColor]];
    [self.voiceAnimation pauseAnimation];
}

- (void)startButtonAction {
    [self.voiceAnimation updateWithColor:[UIColor whiteColor] color2:RGBACOLOR(223, 158, 147, 1)];
    [self.voiceAnimation startAnimation];
}

#pragma mark 按下不动，开始录音
- (void)touchDown:(UIButton *)button
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.recordTool startRecording];
    });
    
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (!granted) {
                //无麦克风
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.voiceAnimation pauseAnimation];
                    UIAlertView * alert =  [[UIAlertView alloc] initWithTitle:@"无法录音"
                                                                      message:@"请在iPhone的“设置-隐私-麦克风”选项中，允许积目访问你的手机麦克风"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"确定"
                                                            otherButtonTitles:nil];
                    [alert show];
                });
            }
        }];
        
    }
    
    
}

#pragma mark 进入内部
- (void)touchDragEnter:(UIButton *)button {
    
}
#pragma mark 进入外部
- (void)touchDragExit:(UIButton *)button {
    
}

#pragma mark 内部松开，发送语音
- (void)touchUpInside:(UIButton *)button {
    button.userInteractionEnabled = NO;
    
    double currentTime = self.recordTool.recorder.currentTime;
    if (currentTime < 1) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.recordTool stopRecording];
            
//            [self.voiceHud updateShowImage:[UIImage imageNamed:@"chat_error"] isShowVolume:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                button.userInteractionEnabled = YES;
//                [self.voiceHud hide];
            });
        });
        
    }
    else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.recordTool stopRecording];
            //把文件copy到其他路径下
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            button.userInteractionEnabled = YES;
        });
    }
}

#pragma mark 外部松开,取消发送语音
- (void)touchUpOutside:(UIButton *)button {
    dispatch_async(dispatch_get_main_queue(), ^{
        button.userInteractionEnabled = YES;
        [self.recordTool stopRecording];
    });
}

#pragma mark - getter

- (UIButton *)startButton {
    if (_startButton == nil) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width - 64 )/2 - 64 - 10, 400, 64, 64);
        _startButton.backgroundColor = [UIColor redColor];
        [_startButton setTitle:@"start" forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(startButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}

- (UIButton *)stopButton {
    if (_stopButton == nil) {
        _stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _stopButton.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width - 64 )/2, 400, 64, 64);
        _stopButton.backgroundColor = [UIColor redColor];
        [_stopButton setTitle:@"stop" forState:UIControlStateNormal];
        [_stopButton addTarget:self action:@selector(stopButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopButton;
}

- (UIButton *)voiceButton {
    if (_voiceButton == nil) {

        _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceButton.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width - 64 )/2, 330, 64, 64);
        _voiceButton.backgroundColor = [UIColor redColor];
        //按下
        [_voiceButton addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        //内部松开
        [_voiceButton addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        //外部松开
        [_voiceButton addTarget:self action:@selector(touchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        //进入内部
        [_voiceButton addTarget:self action:@selector(touchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        //进入外部
        [_voiceButton addTarget:self action:@selector(touchDragExit:) forControlEvents:UIControlEventTouchDragExit];
        
    }
    return _voiceButton;
}

- (JM_YUVoiceAnimation *)voiceAnimation {
    if (_voiceAnimation == nil) {
        _voiceAnimation = [[JM_YUVoiceAnimation alloc] init];
        _voiceAnimation.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 300);
    }
    return _voiceAnimation;
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
