//
//  LNAxisBase.m
//  Market
//
//  Created by vvusu on 4/27/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNAxisBase.h"

@implementation LNAxisBase

- (instancetype)init {
    
    if (self = [super init]) {
        _axisLineWidth = 0.5f;
        _axisLineColor = [UIColor blackColor];
        _labelFont = [UIFont systemFontOfSize:9];
        _labelTextColor = [UIColor colorWithRed:0.55 green:0.56 blue:0.55 alpha:1.0];
        
        _gridLineWidth = 0.5f;
        _gridLineCap = kCGLineCapButt;
        _gridColor = [UIColor colorWithRed:0.04 green:0.04 blue:0.04 alpha:1.0];
        _limitLines = [NSMutableArray array];
        
        _drawLabelsEnabled = YES;
        _drawAxisLineEnabled = NO;
        _drawGridLinesEnabled = YES;
        _gridAntialiasEnabled = YES;
    }
    return self;
}

@end
