//
//  LNChartLineSet.m
//  Market
//
//  Created by vvusu on 5/20/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNLineSet.h"
#import "LNChartDefine.h"

@implementation LNLineSet

- (instancetype)init {
    
    if (self = [super init]) {
        _drawPoint = NO;
        _fillEnabled = YES;
        _drawLastPoint = NO;
        _drawLastPriceLine = YES;
        _lineWidth = 0.5f;
        _pointRadius = 1.5f;
        _linePoints = [NSMutableArray array];
        _fillPoints = [NSMutableArray array];
        _fiveDayPoints = [NSMutableArray array];
        _fillColor = [UIColor colorWithRed:24/255.0 green:96/255.0 blue:254/255.0 alpha:0.95];
        _endFillColor = [UIColor colorWithRed:24/255.0 green:96/255.0 blue:254/255.0 alpha:0.15];
        _startFillColor = [UIColor colorWithRed:24/255.0 green:96/255.0 blue:254/255.0 alpha:0.6];
        _lineColors = @[kCHex(0x4A8FE3),kCHex(0xF9D124),kCHex(0x10E75D),kCHex(0x10E75D),kCHex(0x10E75D)];
        _pointColors = @[kCHex(0x2462A8),kCHex(0xFF7034),kCHex(0x46E73F),kCHex(0x4655FF),kCHex(0x46E78F)];
    }
    return self;
}

@end
