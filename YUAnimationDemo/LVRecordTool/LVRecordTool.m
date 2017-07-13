//
//  LVRecordTool.m
//  RecordAndPlayVoice
//
//  Created by PBOC CS on 15/3/14.
//  Copyright (c) 2015年 liuchunlao. All rights reserved.
//

#define LVRecordFielName @"lvRecord.caf"

#import "LVRecordTool.h"
#import "NSTimer+YUBlockSupport.h"

@interface LVRecordTool () <AVAudioRecorderDelegate>

/** 定时器 */
@property (nonatomic, strong) NSTimer * timer;

@property (nonatomic, strong) AVAudioSession * session;

@property (nonatomic, assign) NSInteger recordTotalTime;

@end

@implementation LVRecordTool

- (void)startRecording {
    // 录音时停止播放 删除曾经生成的文件
    [self stopPlaying];
    [self destructionRecordingFile];
    
    AVAudioSession * session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [session setActive:YES error:nil];
    
    self.session = session;
    
    [self.recorder record];

    _recordTotalTime = 0;
    __weak __typeof(self)weakSelf = self;
    _timer = [NSTimer yu_scheduledTimerWithTimeInterval:0.1 block:^{
        [weakSelf updateImage];
    } repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [_timer fire];
}

- (void)updateImage {
//    if (_recordTotalTime >= 60) {
//        NSLog(@"超时");
//        if ([self.delegate respondsToSelector:@selector(recordTool:recordingTimeout:)]) {
//            [self.delegate recordTool:self recordingTimeout:YES];
//        }
//    }
    [self.recorder updateMeters];
    
    double lowPassResults = pow(10, (0.01 * [self.recorder peakPowerForChannel:0]));
    if ([self.delegate respondsToSelector:@selector(recordTool:didstartRecoring:)]) {
        [self.delegate recordTool:self didstartRecoring:lowPassResults];
    }
    _recordTotalTime++;
}

- (void)stopRecording {
    if ([self.recorder isRecording]) {
        [self.recorder stop];
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)playRecordingFile {
    // 播放时停止录音
    [self.recorder stop];
    
    // 正在播放就返回
    if ([self.player isPlaying]) return;

    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordFileUrl error:NULL];
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.player play];
}

- (void)stopPlaying {
    [self.player stop];
}

static id instance;
#pragma mark - 单例
+ (instancetype)sharedRecordTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [super allocWithZone:zone];
        }
    });
    return instance;
}

#pragma mark - 懒加载
- (AVAudioRecorder *)recorder {
    if (!_recorder) {
        
        // 获取沙盒地址
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [path stringByAppendingPathComponent:LVRecordFielName];
        self.recordFileUrl = [NSURL fileURLWithPath:filePath];
        
        // 设置录音的一些参数
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        // 音频格式
        setting[AVFormatIDKey] = @(kAudioFormatAppleIMA4);
        // 录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
        setting[AVSampleRateKey] = @(44100);
        // 音频通道数 1 或 2
        setting[AVNumberOfChannelsKey] = @(1);
        // 线性音频的位深度  8、16、24、32
        setting[AVLinearPCMBitDepthKey] = @(8);
        //录音的质量
        setting[AVEncoderAudioQualityKey] = [NSNumber numberWithInt:AVAudioQualityHigh];
        
        _recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:setting error:NULL];
        _recorder.delegate = self;
        _recorder.meteringEnabled = YES;
        
        [_recorder prepareToRecord];
    }
    return _recorder;
}

- (void)destructionRecordingFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (self.recordFileUrl) {
        [fileManager removeItemAtURL:self.recordFileUrl error:NULL];
    }
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (flag) {
//        [self.session setActive:NO error:nil];
    }
}


- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error {
    NSLog(@"error -- %@",error);
    
}

- (void)dealloc {
    NSLog(@"正常不会执行这个方法，因为是单例初始化");
    [_timer invalidate];
    _timer = nil;
}
















@end
