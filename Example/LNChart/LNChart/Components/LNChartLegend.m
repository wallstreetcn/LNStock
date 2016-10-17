//
//  LNChartLegend.m
//  Market
//
//  Created by vvusu on 5/21/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNChartLegend.h"
#import "LNChartData.h"
#import "LNChartFormatter.h"

@implementation LNChartLegend

- (instancetype)init {
    if (self = [super init]) {
        _heigth = 20;
        _formSize = 8.0f;
        _stackSpace = 4.0f;
        _formLineWidth = 4.f;
        _contents = [NSArray array];
        _labelColors = [NSArray array];
        _textDefaultColor = kCHex(0x8b8b8e);
        _textFont = [UIFont systemFontOfSize:10];
    }
    return self;
}

- (void)setupLineLegend:(LNChartData *)data {
    if (!data.dataSets || data.lastEnd > data.dataSets.count) {
        return;
    }
    if (data.isBStock) {
        [self setupBarsLegend:data];
    }
    else {
        if (_contents.count > 0) {
            _legendFormType = ChartLegendFormContent;
            _LegendPosition = ChartLegendPositionTopLeft;
        } else {
            _legendFormType = ChartLegendFormLine;
            _LegendPosition = ChartLegendPositionTopRight;
        }
        //高亮状态
        LNDataSet *dataSet;
        NSMutableArray *labelArr = [NSMutableArray array];
        NSMutableArray *labelColorArr = [NSMutableArray array];
        
        if (_customLabel) {
            for (NSInteger i = 0; i < _labels.count; i++) {
                [labelColorArr addObject:_textDefaultColor];
            }
        }
        else {
            if (data.highlighter.highlight) {
                dataSet = data.dataSets[data.highlighter.index];
                _LegendPosition = ChartLegendPositionTopLeft;
            }
            else {
                dataSet = data.dataSets[data.lastEnd -1];
            }
            for (NSInteger i = 0; i < dataSet.values.count; i++) {
                NSNumber *tempNum = dataSet.values[i];
                [labelArr addObject:[LNChartFormatter formatterWithPosition:data.precision num:tempNum.floatValue]];
                [labelColorArr addObject:_textDefaultColor];
            }
            _labels = labelArr;
        }
        _labelColors = labelColorArr;
        _colors = data.lineSet.lineColors;
    }
}

- (void)setupCandleLegend:(LNChartData *)data {
    if (!data.dataSets || data.lastEnd > data.dataSets.count) {
        return;
    }
    if (data.isBStock) {
        [self setupBarsLegend:data];
    }
    else {
        _legendFormType = ChartLegendFormCircle;
        _LegendPosition = ChartLegendPositionTopLeft;
        //高亮状态
        LNDataSet *dataSet;
        if (data.highlighter.highlight) {
            dataSet = data.dataSets[data.highlighter.index];
        } else {
            dataSet = data.dataSets[data.lastEnd -1];
        }
        NSMutableArray *labelArr = [NSMutableArray array];
        NSMutableArray *labelColorArr = [NSMutableArray array];
        for (NSInteger i = 0; i < dataSet.MAValus.count; i++) {
            NSNumber *tempNum = dataSet.MAValus[i];
            NSNumber *MATypeNum = data.candleSet.MAType[i];
            [labelArr addObject:[NSString stringWithFormat:@"MA%ld %@",(long)MATypeNum.integerValue,[LNChartFormatter MAFormatterWithPosition:data.precision num:tempNum.floatValue]]];
            [labelColorArr addObject:_textDefaultColor];
        }
        _labels = labelArr;
        _labelColors = labelColorArr;
        _colors = data.candleSet.MAColors;
    }
}

- (void)setupBarsLegend:(LNChartData *)data {
    if (!data.dataSets || data.lastEnd > data.dataSets.count) {
        return;
    }
    _legendFormType = ChartLegendFormContent;
    _LegendPosition = ChartLegendPositionTopLeft;
    //高亮状态
    LNDataSet *dataSet;
    //上一个Candle数据
    LNDataSet *preData;
    if (data.highlighter.highlight) {
        dataSet = data.dataSets[data.highlighter.index];
        preData = dataSet;
        if (data.highlighter.index > 0) {
            preData = data.dataSets[data.highlighter.index -1];
        }
    } else {
        if (data.lastEnd -1 > 0) {
            dataSet = data.dataSets[data.lastEnd - 1];
            preData = dataSet;
        }
        if (data.lastEnd - 2 > 0) {
            preData = data.dataSets[data.lastEnd - 2];
        }
    }
    NSMutableArray *labelArr = [NSMutableArray array];
    _contents = @[@"开=",@"高=",@"低=",@"收="];
    for (NSInteger i = 0; i < dataSet.candleValus.count; i++) {
        NSNumber *tempNum = dataSet.candleValus[i];
        CGFloat tempValue = tempNum.floatValue;
        [labelArr addObject:[LNChartFormatter formatterWithPosition:data.precision num:tempValue]];
    }
    _labels = labelArr;
    _colors = @[kCHex(0x4A90E2),kCHex(0x4A90E2),kCHex(0x4A90E2),kCHex(0x4A90E2)];
    _labelColors = @[_textDefaultColor,_textDefaultColor,_textDefaultColor,_textDefaultColor];
}

- (void)setupVolumeLegend:(LNChartData *)data {
    if (!data.dataSets || data.lastEnd > data.dataSets.count) {
        return;
    }
    _legendFormType = ChartLegendFormNULL;
    _LegendPosition = ChartLegendPositionTopLeft;
    //高亮状态
    LNDataSet *dataSet;
    if (data.highlighter.highlight) {
        dataSet = data.dataSets[data.highlighter.index];
    }
    if (dataSet) {
        _colors = @[[UIColor clearColor]];
        _labels = @[[LNChartFormatter volumeFormatterWithNum:dataSet.volume]];
    } else {
        _colors = @[];
        _labels = @[];
    }
    _labelColors = @[_textDefaultColor];
}

- (void)setupMACDLegend:(LNChartData *)data {
    if (!data.dataSets || data.lastEnd > data.dataSets.count) {
        return;
    }
    _legendFormType = ChartLegendFormContent;
    _LegendPosition = ChartLegendPositionTopLeft;
    //高亮状态
    LNDataSet *dataSet;
    if (data.highlighter.highlight) {
        dataSet = data.dataSets[data.highlighter.index];
    } else {
        dataSet = data.dataSets[data.lastEnd -1];
    }
    
    NSMutableArray *labelArr = [NSMutableArray array];
    NSMutableArray *labelColorArr = [NSMutableArray array];
    for (NSInteger i = 0; i < dataSet.values.count; i++) {
        NSNumber *tempNum = dataSet.values[i];
        [labelArr addObject:[LNChartFormatter MAFormatterWithPosition:data.precision num:tempNum.floatValue]];
        [labelColorArr addObject:[UIColor grayColor]];
    }
    _labels = labelArr;
    _labelColors = labelColorArr;
    _colors = data.lineSet.lineColors;
}

- (void)setupBOLLLegend:(LNChartData *)data {
    [self setupMACDLegend:data];
}

@end
