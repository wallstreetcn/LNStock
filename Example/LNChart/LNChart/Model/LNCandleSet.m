//
//  LNChartCandleSet.m
//  Market
//
//  Created by vvusu on 5/20/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNCandleSet.h"
#import "LNChartDefine.h"

@implementation LNCandleSet

- (instancetype)init {
    if (self = [super init]) {
        _candleW = 10;
        _candleMinW = 1;
        _candleMaxW = 30;
        _MALineWidth = 0.5f;
        _candleColor = kCHex(0x4A90E2);
        _candleEqualColor = [UIColor grayColor];
        _candleRiseColor = [UIColor colorWithRed:0.96 green:0.16 blue:0.16 alpha:1];
        _candleFallColor = [UIColor colorWithRed:0.25 green:0.85 blue:0.30 alpha:1];
        _MAColors = @[kCHex(0xF51F7D),kCHex(0xF0AB0A),kCHex(0x756BF7),kCHex(0xE7C70F),kCHex(0x47D8E7)];
        _MAType = @[[NSNumber numberWithInteger:5],[NSNumber numberWithInteger:10],[NSNumber numberWithInteger:20]];
    }
    return self;
}

- (void)setCandleW:(CGFloat)candleW {
    _candleW = candleW;
    if (_candleW > _candleMaxW) {
        _candleW = _candleMaxW;
    }
    else if (_candleW < _candleMinW) {
        _candleW = _candleMinW;
    }
}

- (UIColor *)candleRiseColor {
    if (_greenUp) {
        return _candleFallColor;
    } else {
        return _candleRiseColor;
    }
}

- (UIColor *)candleFallColor {
    if (_greenUp) {
        return _candleRiseColor;
    } else {
        return _candleFallColor;
    }
}

@end
