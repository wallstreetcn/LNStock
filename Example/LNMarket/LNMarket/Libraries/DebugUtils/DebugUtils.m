//
//  DebugUtils.m
//  AtourLiftAdmin
//
//  Created by vvusu on 3/21/16.
//  Copyright © 2016 atour. All rights reserved.
//

#import "DebugUtils.h"
#import "PListUtils.h"

@implementation DebugUtils

+ (BOOL)isDebug {
    return [[PListUtils valueForKey:@"IsDebug"] intValue] !=0;
}

+ (void)switchDebug {
    [DebugUtils switchItemWithKey:@"IsDebug" isOpen:[DebugUtils isDebug]];
}

+ (BOOL)isTestAPI {
    return [[PListUtils valueForKey:@"IsTestAPI"] intValue] !=0;
}

+ (void)switchTestAPI {
    [DebugUtils switchItemWithKey:@"IsTestAPI" isOpen:[DebugUtils isTestAPI]];
}

+ (BOOL)isWebTestAPI {
    return [[PListUtils valueForKey:@"IsWebTestAPI"] intValue] !=0;
}

+ (void)switchWebTestAPI {
    [DebugUtils switchItemWithKey:@"IsWebTestAPI" isOpen:[DebugUtils isWebTestAPI]];
}

+ (BOOL)isNightMode {
    return [[PListUtils valueForKey:@"IsNigthMode"] intValue] != 0;
}

+ (void)switchNightMode {
    [DebugUtils switchItemWithKey:@"IsNigthMode" isOpen:[DebugUtils isNightMode]];
}

#pragma mark - Other

+ (void)switchItemWithKey:(NSString *)key isOpen:(BOOL)isOpen {
    if (isOpen) {
        [PListUtils setValue:@"0" forKey:key];
    } else {
        [PListUtils setValue:@"1" forKey:key];
    }
}

@end
