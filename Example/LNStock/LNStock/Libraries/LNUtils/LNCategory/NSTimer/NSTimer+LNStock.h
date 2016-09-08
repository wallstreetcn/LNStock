//
//  NSTimer+LNStock.h
//  LNStock
//
//  Created by vvusu on 7/15/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (LNStock)
+ (NSTimer *)ln_timerWithTimeInterval:(NSTimeInterval)timeInterval repeat:(BOOL)isRepeat block:(void (^)())inBlock;
+ (NSTimer *)ln_scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval repeat:(BOOL)isRepeat block:(void (^)())inBlock;
@end
