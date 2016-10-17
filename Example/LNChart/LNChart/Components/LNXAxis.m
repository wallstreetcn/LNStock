//
//  LNXAxis.m
//  Market
//
//  Created by vvusu on 4/27/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNXAxis.h"
#import "LNChartData.h"

@implementation LNXAxis

- (instancetype)init {
    if (self = [super init]) {
        _labelCount = 5;
        _dateFormatter = @"yyyy-MM-dd";
        _labelSite = XAxisLabelSiteCenter;
        _labelPosition = XAxisLabelPositionBottom;
    }
    return self;
}

//基金需要用到
- (void)setupLineValues:(LNChartData *)data {
    if (_labelCount > data.dataSets.count) {
        _labelCount = data.dataSets.count;
    }
    NSMutableArray *values = [NSMutableArray array];
    if (data.lineSet.drawPart) { //五日
        //便利数组取出日期值
        NSString *tempString;
        for (NSInteger i = 0; i< data.dataSets.count; i++) {
            LNDataSet *dataSet = data.dataSets[i];
            NSString *dateString = [LNChartFormatter dateWithFormatter:_dateFormatter date:dataSet.date];
            if (![dateString isEqualToString:tempString]) {
                if (dateString) {
                    [values addObject:dateString];
                }
            }
            tempString = dateString;
        }
        //判断没有五个数据，就添加一个空的
        if (values.count < _labelCount) {
            [values addObject:@""];
        }
        _values = values;
    }
    else {
        //非五日通常情况
        [self setupKLineValues:data];
    }
}

- (void)setupKLineValues:(LNChartData *)data {
    _labelCount = 5;
    NSMutableArray *xVals = [NSMutableArray array];
    NSInteger num = data.valCount / (_labelCount - 1);
    NSInteger dNum = data.valCount % (_labelCount -1);
    NSInteger tempNum = 0;
    for (NSInteger i = 0 ; i < _labelCount; i++) {
        LNDataSet *dataSet;
        tempNum = data.lastStart + i * num;
        if (dNum > 0 && i > 0) {
            tempNum += dNum%i;
        }
        if (tempNum <= data.dataSets.count) {
            if (tempNum < data.dataSets.count) {
                dataSet = data.dataSets[tempNum];
            }
            else {
                dataSet = data.dataSets.lastObject;
            }
        }
        
        if (dataSet.date) {
            [xVals addObject:[LNChartFormatter dateWithFormatter:_dateFormatter date:dataSet.date]];
        }
        else {
            [xVals addObject:@""];
        }
    }
    //自定义X轴显示数据
    if (data.xVals.count > 0) {
        xVals = data.xVals;
    }
    _values = xVals;
}

- (void)setupVolumeValues:(LNChartData *)data {
    NSMutableArray *xVals = [@[@"",@"",@"",@"",@""] mutableCopy];
    _values = xVals;
}

@end
