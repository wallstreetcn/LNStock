//
//  LNYAxis.m
//  Market
//
//  Created by vvusu on 4/27/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNYAxis.h"
#import "LNChartData.h"
#import "LNChartFormatter.h"

@implementation LNYAxis

- (instancetype)init {
    if (self = [super init]) {
        self.labelCount = 5;
        self.labelPosition = AxisDependencyLeft;
    }
    return self;
}

+ (instancetype)initWithType:(AxisDependency)position {
    LNYAxis *yAxis = [[LNYAxis alloc]init];
    yAxis.yPosition = position;
    return yAxis;
}

- (void)proportionValues:(LNChartData *)data {
    CGFloat avg = (data.yMax + data.yMin)/2;
    CGFloat price = data.yMax - data.yMin;
    price = price/data.sizeRatio/2;
    self.axisMaximum = avg + price;
    self.axisMinimum = avg - price;
}

//计算左右轴的Labels
- (void)setupValues:(LNChartData *)data {
    //是配比例视图，相应的Y轴数值变大变小
    [self proportionValues:data];
    //A股分时或者五日显示涨跌幅
    if (!data.isBStock && _yPosition == AxisDependencyRight) {
        //计算涨跌幅
        LNDataSet *dataSet = data.dataSets.firstObject;
        if (!dataSet.preClosePx) {
            return;
        }
        CGFloat closePrice = (self.axisMaximum - dataSet.preClosePx) / dataSet.preClosePx * 100;
        self.axisMaximum = closePrice;
        self.axisMinimum = -closePrice;
        data.highlighter.maxPriceRatio = closePrice;
    }
    [self creatValues:data];
}

//计算涨跌幅
- (void)setupKLineValues:(LNChartData *)data {
    if (data.yAxisMax > data.dataSets.count || data.yAxisMin > data.dataSets.count) {
        return;
    }
    LNDataSet *maxSet = data.dataSets[data.yAxisMax];
    LNDataSet *minSet = data.dataSets[data.yAxisMin];
    CGFloat max = ((NSNumber *)maxSet.candleValus[1]).floatValue;
    CGFloat min = ((NSNumber *)minSet.candleValus[2]).floatValue;
    
    CGFloat avg = (max + min)/2;
    CGFloat price = max - min;
    price = (price/data.sizeRatio)/2;
    self.axisMaximum = avg + price;
    self.axisMinimum = avg - price;
    [self creatValues:data];
}

//通常的价格
- (void)creatValues:(LNChartData *)data {
    NSMutableArray *valuesArr = [NSMutableArray array];
    CGFloat price = (self.axisMaximum - self.axisMinimum) / (_labelCount - 1);
    //通过Y轴显示label 的位置来判断是否为小图显示的标示
    if (_labelPosition == YAxisLabelPositionInsideChart) {
        //竖屏转态下
        for (CGFloat i = 0; i < _labelCount; i++) {
            if (i == 0 || i == _labelCount - 1) {
                if (_yPosition == AxisDependencyLeft) {
                    [valuesArr addObject:[LNChartFormatter formatterWithPosition:data.precision num:self.axisMaximum - (i * price)]];
                } else {
                    [valuesArr addObject:[LNChartFormatter conversionWithFormatter:@"%" value:self.axisMaximum - (i * price)]];
                }
            } else {
                [valuesArr addObject:@""];
            }
        }
    }//横屏的
    else {
        if (data.isBStock) {
            for (CGFloat i = 0; i < _labelCount; i++) {
                [valuesArr addObject:[LNChartFormatter formatterWithPosition:data.precision num:self.axisMaximum - (i * price)]];
            }
        } else {
            for (CGFloat i = 0; i < _labelCount; i++) {
                if (_yPosition == AxisDependencyLeft) {
                    [valuesArr addObject:[LNChartFormatter formatterWithPosition:data.precision num:self.axisMaximum - (i * price)]];
                } else {
                    [valuesArr addObject:[LNChartFormatter conversionWithFormatter:@"%" value:self.axisMaximum - (i * price)]];
                }
            }
        }
    }
    _values = valuesArr;
}

- (void)setupVolumeValues:(LNChartData *)data {
    [self proportionValues:data];
    NSString *maxString = [LNChartFormatter volumeCutWithNum:self.axisMaximum maxNum:self.axisMaximum];
    NSString *statusString = [LNChartFormatter volumeTypeWithNum:self.axisMaximum];
    _values = @[maxString,statusString];
}

- (void)setupMACDValues:(LNChartData *)data {
    [self proportionValues:data];
    NSString *maxString = [LNChartFormatter formatterWithPosition:data.precision num:self.axisMaximum];
    NSString *minString = [LNChartFormatter formatterWithPosition:data.precision num:self.axisMinimum];
    _values = @[maxString,@"0",minString];
}

- (void)setupOBVValues:(LNChartData *)data {
    [self proportionValues:data];
    NSString *maxString = [LNChartFormatter longFormatterWithPosition:self.axisMaximum maxNum:self.axisMaximum];
    NSString *minString = [LNChartFormatter longFormatterType:self.axisMinimum];
    _values = @[maxString,minString];
}

@end
