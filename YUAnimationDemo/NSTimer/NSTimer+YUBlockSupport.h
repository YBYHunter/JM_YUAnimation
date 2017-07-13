//
//  NSTimer+YUBlockSupport.h
//  test
//
//  Created by 于博洋 on 2017/3/31.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (YUBlockSupport)

+ (NSTimer *)yu_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void(^)())block repeats:(BOOL)repeats;

- (void)yu_pauseTimer;

- (void)yu_resumeTimer;



@end
