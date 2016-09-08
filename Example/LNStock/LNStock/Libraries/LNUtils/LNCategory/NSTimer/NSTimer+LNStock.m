//
//  NSTimer+LNStock.m
//  LNStock
//
//  Created by vvusu on 7/15/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "NSTimer+LNStock.h"

@implementation NSTimer (LNStock)

+ (NSTimer *)ln_timerWithTimeInterval:(NSTimeInterval)timeInterval
                               repeat:(BOOL)isRepeat
                                block:(void (^)())inBlock {
    
    void (^block)() = [inBlock copy];
    NSTimer * timer = [self timerWithTimeInterval:timeInterval
                                           target:self
                                         selector:@selector(__executeTimerBlock:)
                                         userInfo:block
                                          repeats:isRepeat];
    return timer;
}

+ (NSTimer *)ln_scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                        repeat:(BOOL)isRepeat
                                         block:(void (^)())inBlock {
    void (^block)() = [inBlock copy];
    NSTimer *timer = [self scheduledTimerWithTimeInterval:timeInterval
                                                    target:self
                                                  selector:@selector(__executeTimerBlock:)
                                                  userInfo:block
                                                   repeats:isRepeat];
    return timer;
}

+ (void)__executeTimerBlock:(NSTimer *)timer {
    if([timer userInfo]) {
        void (^block)() = (void (^)())[timer userInfo];
        block();
    }
}

@end
