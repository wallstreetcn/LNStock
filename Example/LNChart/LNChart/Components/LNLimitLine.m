//
//  LNLimitLine.m
//  LNChart
//
//  Created by vvusu on 6/30/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNLimitLine.h"
#import "LNChartData.h"
#import "LNChartFormatter.h"

@implementation LNLimitLine

- (instancetype)init {
    if (self = [super init]) {
        _drawTitle = NO;
        _lineWidth = 0.5f;
        _points = [NSMutableArray array];
        _textFont = [UIFont systemFontOfSize:10];
        _textColor = [UIColor whiteColor];
        _lineColor = [UIColor colorWithRed:0.16 green:0.45 blue:0.89 alpha:1.0];
        _textBGColor = [UIColor colorWithRed:47/255.0 green:90/255.0 blue:200/255.0 alpha:1.0];
    }
    return self;
}

- (void)setupValues:(LNChartData *)data {
    if (_drawEnabled) {  //昨收价格虚线
        [_points removeAllObjects];
        CGFloat limitY = 0;
        
        if (data.isBStock) {
            LNDataSet *dataSet = data.dataSets.lastObject;
            NSNumber *closeNum = dataSet.values.lastObject;
            CGFloat close = closeNum.floatValue;
            _content = [LNChartFormatter formatterWithPosition:data.precision num:close];
            limitY = (data.yMax - close) * data.drawScale + data.viewHandler.contentTop + data.viewHandler.emptyHeight;
        } else {
            LNDataSet *dataSet = data.dataSets.firstObject;
            limitY = (data.yMax - dataSet.preClosePx) * data.drawScale + data.viewHandler.contentTop + data.viewHandler.emptyHeight;
        }
        
        if (limitY < data.viewHandler.contentTop) {
            limitY = data.viewHandler.contentTop;
        }
        if (limitY > data.viewHandler.contentBottom) {
            limitY = data.viewHandler.contentBottom;
        }
        CGPoint startPoint = CGPointMake(data.viewHandler.contentLeft, limitY);
        CGPoint endPoint = CGPointMake(data.viewHandler.contentRight, limitY);
        [_points addObject:[NSValue valueWithCGPoint:startPoint]];
        [_points addObject:[NSValue valueWithCGPoint:endPoint]];
    }
}

@end
