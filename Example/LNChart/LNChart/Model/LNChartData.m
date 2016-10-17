//
//  LNChartData.m
//  Market
//
//  Created by vvusu on 4/25/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNChartData.h"
#import "LNDataSet.h"

@implementation LNChartData

+ (instancetype)initWithHandler:(LNChartHandler *)handler {
    LNChartData *data = [[LNChartData alloc]init];
    data.viewHandler = handler;
    return data;
}

- (instancetype)init {
    if (self = [super init]) {
        _yAxisMax = 0;
        _yAxisMin = 0;
        _sizeRatio = 0.85;
        _gapRatio = 0.2;
        _precision = @"%.2f";
        _drawLoadMoreContent = YES;
        _xVals = [NSMutableArray array];
        _dataSets = [NSMutableArray array];
        _lineSet = [[LNLineSet alloc]init];
        _candleSet = [[LNCandleSet alloc]init];
        _highlighter = [[LNChartHighlight alloc]init];
    }
    return self;
}

- (LNChartHighlight *)highlighter {
    if (!_highlighter) {
        _highlighter = [[LNChartHighlight alloc]init];
    }
    return _highlighter;
}

- (LNLineSet *)lineSet {
    if (!_lineSet) {
        _lineSet = [[LNLineSet alloc]init];
    }
    return _lineSet;
}

- (LNCandleSet *)candleSet {
    if (!_candleSet) {
        _candleSet = [[LNCandleSet alloc]init];
    }
    return _candleSet;
}

- (void)setLastStart:(NSInteger)lastStart {
    _lastStart = lastStart;
    if (_lastStart < 0) {
        _lastStart = 0;
    }
}

- (void)setLastEnd:(NSInteger)lastEnd {
    _lastEnd = lastEnd;
    if (_lastEnd > _dataSets.count) {
        _lastEnd = _dataSets.count;
    }
}

- (void)addXValue:(NSString *)string {
    [self.xVals addObject:string];
}

- (void)removeXValue:(NSInteger)index {
    [self.xVals removeObjectAtIndex:index];
}

- (void)removeAllDataSet {
    _valCount = 0;
    _emptyEndNum = 0;
    _emptyStartNum = 0;
    _loadMoreType = ChartLoadMoreType_Normal;
    [_xVals removeAllObjects];
    [_dataSets removeAllObjects];
}

#pragma mark ---------
//初始化调用，计算偏移量 如果数量大于屏幕显示的最大数目，做偏移
- (void)computeLastStartAndLastEnd {
    if (_valCount == 0) {
        _valCount = _viewHandler.contentWidth / _candleSet.candleW;
    }
    //两种情况
    if (_dataSets.count > _valCount) {
        if (_lastEnd == 0) {
            _lastEnd = _dataSets.count;
            _lastStart = _dataSets.count - _valCount;
        }
    }
    else {
        _lastStart = 0;
        _lastEnd = _dataSets.count;
    }
}

- (NSInteger)computeMaxValCount {
    return _viewHandler.contentWidth / _candleSet.candleW;
}

//动画的时候添加空蜡烛
- (void)addEmptyCandleWhenAnimation:(NSInteger)num {
    if (_emptyStartNum > 0) {
        for (NSInteger i = 0; i < num; i++) {
            [_dataSets insertObject:[[LNDataSet alloc]init] atIndex:0];
        }
    }
}

//动画之后删除空蜡烛
- (void)resetDataSetsAfterAnimation {
    if (_emptyStartNum > 0) {
        if (_emptyStartNum <= _dataSets.count) {
            [_dataSets removeObjectsInRange:NSMakeRange(0, _emptyStartNum)];
        }
        _emptyStartNum = 0;
        _lastStart = 0;
        _lastEnd = _valCount;
    }
    
    if (_emptyEndNum > 0) {
        _emptyEndNum = 0;
        _lastEnd = _dataSets.count;
        _lastStart = _dataSets.count - _valCount;
    }
}

- (BOOL)hasEmptyNum {
    if (_emptyStartNum > 0 || _emptyEndNum > 0) {
        return YES;
    }
    else {
        return NO;
    }
}

//計算視圖比例
- (void)computeSizeRatio {
    //结果为+lnf 代表正无穷 会出现 除以 0 的情况 结果会正无穷
    if (_yMax == _yMin) {
        _yMax += 0.01;
        _yMin -= 0.01;
    }
    _drawScale = _viewHandler.contentHeight * _sizeRatio / (_yMax - _yMin);
    _viewHandler.emptyHeight = (_viewHandler.contentHeight * (1 - _sizeRatio))/2;
}

#pragma mark - 通常线图的计算
#pragma mark - 分时计算
//分时线
- (void)computeLineMinMax {
    _yMax = CGFLOAT_MIN;
    _yMin = CGFLOAT_MAX;
    
    if (_lastEnd > _dataSets.count) {
        return;
    }
    CGFloat offsetMaxPrice = 0;
    for (NSInteger i = _lastStart; i < _lastEnd; i++) {
        LNDataSet *entity = _dataSets[i];
        if (i == _lastStart) {
            _yMax = ((NSNumber *)entity.values.firstObject).floatValue;
            _yMin = _yMax;
        }
        //如果有价格线
        for (NSNumber *tempNum in entity.values) {
            CGFloat value = tempNum.floatValue;
            _yMin = _yMin > value ? value : _yMin;
            _yMax = _yMax < value ? value : _yMax;
            offsetMaxPrice = offsetMaxPrice > fabs(value - entity.preClosePx) ? offsetMaxPrice : fabs(value - entity.preClosePx);
        }
    }
    
    if (_dataSets.firstObject) {
         LNDataSet *entity = _dataSets.firstObject;
        if (entity.preClosePx > 0) {
            _yMax = ((LNDataSet *)[_dataSets firstObject]).preClosePx + offsetMaxPrice;
            _yMin = ((LNDataSet *)[_dataSets firstObject]).preClosePx - offsetMaxPrice;
        }
    }
    
    //五日分割数据
    if (_lineSet.isDrawPart) {
        [self computeFiveDayLinePointsCoord];
    }
    
    [self computeSizeRatio];
}

//计算分时线点的坐标
- (void)computeLinePointsCoord {
    if (!_dataSets || _lastEnd > _dataSets.count) {
        return;
    }
    [_lineSet.linePoints removeAllObjects];
    [_lineSet.fillPoints removeAllObjects];
    CGFloat volumeWidth = _viewHandler.contentWidth / _valCount;
    //滑动时之前为空数组时的灵石变量
    NSInteger n = _lastStart;
    for (NSInteger i = _lastStart; i < _lastEnd; i++) {
        LNDataSet *dataSet = _dataSets[i];
        NSNumber *valueNum = dataSet.values.firstObject;
        //解决有空蜡烛时，不画点和线
        if (!valueNum) {
            n++;
            continue;
        }
        //先生成点的可变数组
        if (i == n) {
            for (NSInteger j = 0; j < dataSet.values.count; j++) {
                [_lineSet.linePoints addObject:[NSMutableArray array]];
            }
        }
        
        CGFloat left = (_viewHandler.contentLeft + volumeWidth * (i - _lastStart)) + volumeWidth * _gapRatio;
        CGFloat startX = left + (volumeWidth - volumeWidth * _gapRatio)/2;
        CGFloat startY = 0;
        
        //如果是外汇情况不一样
        for (NSInteger j = 0; j < dataSet.values.count; j++) {
            NSNumber *tempNum = dataSet.values[j];
            startY = (_yMax - tempNum.floatValue) * _drawScale + _viewHandler.contentTop + _viewHandler.emptyHeight;
            CGPoint startPoint = CGPointMake(startX, startY);
            [_lineSet.linePoints[j] addObject:[NSValue valueWithCGPoint:startPoint]];
            
            //渐变色点计算
            if (j == 0) {
                //添加渐变色图路径
                if (_lineSet.isFillEnabled) {
                    CGPoint fillPoint = CGPointMake(0, 0);
                    if (i == n) {
                        fillPoint = CGPointMake(startX, startY);
                        CGPoint startPoint = CGPointMake(startX, _viewHandler.contentBottom);
                        [_lineSet.fillPoints addObject:[NSValue valueWithCGPoint:startPoint]];
                    }
                    
                    fillPoint = CGPointMake(startX, startY);
                    [_lineSet.fillPoints addObject:[NSValue valueWithCGPoint:fillPoint]];
                    
                    if (i == _lastEnd - 1) {
                        CGPoint endPoint = CGPointMake(startX, _viewHandler.contentBottom);
                        [_lineSet.fillPoints addObject:[NSValue valueWithCGPoint:endPoint]];
                    }
                }
            }
        }
        
        if (i == _highlighter.index) {  //十字线
            _highlighter.point = CGPointMake(startX, startY);
        }
    }
}

#pragma mark - 五日计算
- (void)computeFiveDayLinePointsCoord {
    //五日坐标点计算
    [_lineSet.fiveDayPoints removeAllObjects];
    NSString *tempString;
    for (NSInteger i = _lastStart; i < _lastEnd; i++) {
        LNDataSet *dataSet = _dataSets[i];
        //五日坐标点计算
        NSString *dateString = [LNChartFormatter dateWithFormatter:@"MM-dd" date:dataSet.date];
        if (![dateString isEqualToString:tempString]) {
            [_lineSet.fiveDayPoints addObject:[NSNumber numberWithInteger:i]];
        }
        tempString = dateString;
    }
}

#pragma mark - 交易量计算
- (void)computeVolumeMinMax {
    _yMax = CGFLOAT_MIN;
    _yMin = 0;
    if (_lastEnd > _dataSets.count) {
        return;
    }
    for (NSInteger i = _lastStart; i < _lastEnd; i++) {
        LNDataSet *entity = _dataSets[i];
        _yMax = _yMax > entity.volume ? _yMax : entity.volume;
    }
    [self computeSizeRatio];
}

#pragma mark - MACD
- (void)computeMACDMinMax {
    if (_lastEnd > _dataSets.count) {
        return;
    }
    _yMax = 0;
    _yMin = 0;
    for (NSInteger i = _lastStart; i < _lastEnd; i++) {
        LNDataSet *entity = _dataSets[i];
        for (NSNumber *tempNum in entity.values) {
            CGFloat value = tempNum.floatValue;
            _yMin = _yMin > value ? value : _yMin;
            _yMax = _yMax < value ? value : _yMax;
        }
    }
    //上下均等
    if (_yMax > fabs(_yMin)) {
        _yMin = -_yMax;
    } else {
        _yMax = fabs(_yMin);
    }
    [self computeSizeRatio];
}

#pragma mark - KLine
//K线
- (void)computeKLineMinMax {
    _yMax = CGFLOAT_MIN;
    _yMin = CGFLOAT_MAX;
    if (_lastEnd > _dataSets.count) {
        return;
    }
    for (NSInteger i = _lastStart; i < _lastEnd; i++) {
        LNDataSet *entity = _dataSets[i];
        if (i == _lastStart) {
            _yAxisMax = i;
            _yAxisMin = i;
            _yMax = ((NSNumber *)entity.candleValus[1]).floatValue;
            _yMin = ((NSNumber *)entity.candleValus[2]).floatValue;
        }
        
        CGFloat high = ((NSNumber *)entity.candleValus[1]).floatValue;
        if (_yMax < high) {
            _yMax = high;
            _yAxisMax = i;
        }
        
        CGFloat low = ((NSNumber *)entity.candleValus[2]).floatValue;
        if (_yMin > low) {
            _yMin = low;
            _yAxisMin = i;
        }
        
        NSArray *valusArr = entity.MAValus;
        if (_chartType == ChartViewType_BOLL) {
            valusArr = entity.values;
        }
        for (NSInteger j = 0; j < valusArr.count; j++) {
            CGFloat value = ((NSNumber *)valusArr[j]).floatValue;
            if (value >= 0) {
                _yMin = _yMin < value ? _yMin : value;
                _yMax = _yMax > value ? _yMax : value;
            }
        }
    }
    [self computeSizeRatio];
}

@end
