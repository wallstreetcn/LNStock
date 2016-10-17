//
//  LNChartHighlight.m
//  Market
//
//  Created by vvusu on 5/12/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNChartHighlight.h"

@implementation LNChartHighlight

- (instancetype)init {
    if (self = [super init]) {
        _highlight = NO;
        _drawTimeLabel = YES;
        _drawLevelLine = YES;
        _drawVerticalLine = YES;
        _drawHighlightPoint = NO;
        
        _index = 0;
        _pointRadius = 3.0f;
        _pointLineWidth = 2.0f;
        _positionType = HighlightPositionLeftOut;
        _pointColor = [UIColor whiteColor];
        _pointLineColor = [UIColor redColor];
        
        _levelLineWidth = 1.0f;
        _levelLineColor = [UIColor whiteColor];
        
        _verticalLineWidth = 1.0f;
        _verticalLineColor = [UIColor whiteColor];
        
        _labelColor = [UIColor blackColor];
        _labelFont = [UIFont systemFontOfSize:10.0f];
        _labelBGColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.8];
    }
    return self;
}

@end
