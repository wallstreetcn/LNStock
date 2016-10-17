//
//  LNComponentBase.m
//  Market
//
//  Created by vvusu on 5/3/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNComponentBase.h"

@implementation LNComponentBase

- (instancetype)init {
    if (self = [super init]) {
        _enabled = YES;
        _xOffset = 2.0;
        _yOffset = 2.0;
    }
    return self;
}

@end
