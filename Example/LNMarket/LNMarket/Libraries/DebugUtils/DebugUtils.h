//
//  DebugUtils.h
//  AtourLiftAdmin
//
//  Created by vvusu on 3/21/16.
//  Copyright © 2016 atour. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DebugUtils : NSObject
//是否是Debug
+ (BOOL)isDebug;
+ (void)switchDebug;

//是否是测试服
+ (BOOL)isTestAPI;
+ (void)switchTestAPI;

//是否是Web测试服
+ (BOOL)isWebTestAPI;
+ (void)switchWebTestAPI;

//是否夜间模式
+ (BOOL)isNightMode;
+ (void)switchNightMode;
@end
