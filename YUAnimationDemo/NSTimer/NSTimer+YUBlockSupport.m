//
//  NSTimer+YUBlockSupport.m
//  test
//
//  Created by 于博洋 on 2017/3/31.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import "NSTimer+YUBlockSupport.h"

@implementation NSTimer (YUBlockSupport)

+ (NSTimer *)yu_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void(^)())block repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(yu_blockInvoke:) userInfo:[block copy] repeats:repeats];
}


        
+ (void)yu_blockInvoke:(NSTimer *)timer {
    void(^block)() = timer.userInfo;
    if (block) {
        block();
    }
}

- (void)yu_pauseTimer {
    
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}


- (void)yu_resumeTimer {
    
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
    
}

@end
