//
//  LNChartView.m
//  Market
//
//  Created by vvusu on 4/28/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNChartView.h"
#import "LNDataSet.h"
#import "LNChartUtils.h"
#import "LNDataRender.h"
#import "LNYAxisRender.h"
#import "LNXAxisRender.h"
#import "LNLegendRender.h"
#import "LNLimitRender.h"

@interface LNChartView ()
@property (nonatomic, strong) LNDataRender *dataRender;
@property (nonatomic, strong) LNYAxisRender *leftRender;
@property (nonatomic, strong) LNYAxisRender *rightRender;
@property (nonatomic, strong) LNXAxisRender *xAxisRender;
@property (nonatomic, strong) LNLimitRender *limitRender;
@property (nonatomic, strong) LNLegendRender *legendRender;
@end

@implementation LNChartView

#pragma mark - GET SET

- (void)setupChart {
    [super setupChart];
    [self setupAnimation];
    _limitLine = [[LNLimitLine alloc]init];
    _chartLegend = [[LNChartLegend alloc]init];
    _leftAxis = [LNYAxis initWithType:AxisDependencyLeft];
    _rightAxis = [LNYAxis initWithType:AxisDependencyRight];
    _dataRender = [LNDataRender initWithHandler:self.viewHandler];
    _leftRender = [LNYAxisRender initWithHandler:self.viewHandler yAxis:_leftAxis];
    _rightRender = [LNYAxisRender initWithHandler:self.viewHandler yAxis:_rightAxis];
    _xAxisRender = [LNXAxisRender initWithHandler:self.viewHandler xAxis:self.xAxis];
    _limitRender = [LNLimitRender initWithHandler:self.viewHandler limit:_limitLine];
    _legendRender = [LNLegendRender initWithHandler:self.viewHandler legend:_chartLegend];

    _longPressEnabled = YES;
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGestureRecognized:)];
    _longPressGestureRecognizer.minimumPressDuration = 0.5;
    [self addGestureRecognizer:_longPressGestureRecognizer];
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognized:)];
    [self addGestureRecognizer:_panGestureRecognizer];
    _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGestureRecognized:)];
    [self addGestureRecognizer:_pinchGestureRecognizer];
    //添加Point动画Layer
    _pointCALayer = [[LNChartPointLayer alloc] init];
    [self.layer addSublayer:_pointCALayer];
}

- (void)setupAnimation {
    __weak typeof (self)wself = self;
    _chartAction = [LNChartAction setupWithData:self.data];
    _chartAction.animatorBlock = ^(LNChartActionType type, id empty, BOOL isEnd){
        if (wself.anctionBlock) {
            wself.anctionBlock(type, wself.data, empty, isEnd);
        }
        [wself setNeedsDisplay];
    };
}

- (void)setupWithData:(NSMutableArray *)data {
    //解决，动画过程中刷新数据会断的情况
    if (self.chartAction.isScrolling || [self.data hasEmptyNum]) {
        return;
    }
    self.data.dataSets = data;
    [self.data computeLastStartAndLastEnd];
    [self notifyDataSetChanged];
    [self.chartAction setupDefaultValue]; //动画
}

- (void)updataChartData:(NSMutableArray *)data {
    if (data.count > 0) {
        self.data.loadMoreType = ChartLoadMoreType_Normal;
        NSInteger num = self.data.dataSets.count;
        NSInteger countNum = data.count - num + self.data.emptyStartNum;
        NSInteger endNum = self.data.lastEnd + countNum;
        NSInteger startNum = self.data.lastStart + countNum;
        [self.data resetDataSetsAfterAnimation];
        self.data.dataSets = data;
        self.data.lastEnd = endNum;
        self.data.lastStart = startNum;
        [self.chartAction stopAnimation];
        [self notifyDataSetChanged];
    } else {
        self.data.loadMoreType = ChartLoadMoreType_NoData;
    }
}

- (void)notifyDataSetChanged {
    [super notifyDataSetChanged];
    [self setNeedsDisplay];
}

- (void)setChartViewType:(ChartViewType)chartViewType {
    _chartViewType = chartViewType;
    self.data.chartType = chartViewType;
}

#pragma mark - 绘制相关方法

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.data.dataSets.count == 0) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self calcMinMax];
    [self drawGridBackground:context];
    
    //绘制左边轴
    [_leftRender renderGridLines:context];
    [_leftRender renderYAxis:context];
    //绘制右边轴
    [_rightRender renderYAxis:context];
    //画X轴
    [_xAxisRender renderGridLines:context];
    [_xAxisRender renderXAxis:context];
    [self drawData:context];
    //绘制XY轴显示的Lables
    [_leftRender renderYAxisLabels:context];
    [_rightRender renderYAxisLabels:context];
    [_xAxisRender renderAxisLabels:context];
    //画标示虚线
    [_limitLine setupValues:self.data];
    [_limitRender renderLimit:context data:self.data];
    //绘制图标示
    [_legendRender renderLegend:context data:self.data];
    //绘制高亮的十线
    [_dataRender drawCrossLine:context data:self.data];
    //改变Point动画位置
    [_pointCALayer changeLayerStatus:self.data];
}

- (void)drawGridBackground:(CGContextRef)context {
    //绘制背景 绘制线框
    CGContextSaveGState(context);
    [LNChartUtils drawRect:context lineColor:self.borderColor fillColor:self.gridBackgroundColor lineWidth:self.borderLineWidth rect:self.viewHandler.contentRect];
}

- (void)drawData:(CGContextRef)context {
    switch (self.chartViewType) {
        case ChartViewType_Line:
        case ChartViewType_OBV:
            [self.data computeLinePointsCoord];
            [_chartLegend setupLineLegend:self.data];
            if (!self.data.lineSet.isDrawPart) {
                [_dataRender drawLineData:context data:self.data];
            } else {
                [_dataRender drawFiveDayLineData:context data:self.data];
            }
            break;
        case ChartViewType_Columnar:
            [_chartLegend setupVolumeLegend:self.data];
            [_dataRender drawVolume:context data:self.data];
            break;
        case ChartViewType_Candle:
        case ChartViewType_HollowCandle:
            [_chartLegend setupCandleLegend:self.data];
            [_dataRender drawCandle:context data:self.data];
            break;
        case ChartViewType_Bars:
            [_chartLegend setupBarsLegend:self.data];
            [_dataRender drawBars:context data:self.data];
            break;
        case ChartViewType_MACD:
            [_chartLegend setupMACDLegend:self.data];
            [_dataRender drawMACD:context data:self.data];
            break;
        case ChartViewType_BOLL:
            [_chartLegend setupBOLLLegend:self.data];
            [_dataRender drawBars:context data:self.data];
            break;
    }
    //画左拉加载更多文字
    [_dataRender drawLoadMoreContent:context data:self.data];
}

- (void)calcMinMax {
    if ([self.data hasEmptyNum]) {
        return;
    }
    switch (self.chartViewType) {
        case ChartViewType_Line:
            [self.data computeLineMinMax];
            [self.xAxis setupLineValues:self.data];
            [self.leftAxis setupValues:self.data];
            [self.rightAxis setupValues:self.data];
            break;
        case ChartViewType_Columnar:
            [self.data computeVolumeMinMax];
            [self.xAxis setupVolumeValues:self.data];
            [self.leftAxis setupVolumeValues:self.data];
            [self.rightAxis setupVolumeValues:self.data];
            break;
        case ChartViewType_Candle:
        case ChartViewType_HollowCandle:
        case ChartViewType_Bars:
            [self.data computeKLineMinMax];
            [self.xAxis setupKLineValues:self.data];
            [self.leftAxis setupKLineValues:self.data];
            [self.rightAxis setupKLineValues:self.data];
            break;
        case ChartViewType_MACD:
            [self.data computeMACDMinMax];
            [self.leftAxis setupMACDValues:self.data];
            break;
        case ChartViewType_BOLL:
            [self.data computeKLineMinMax];
            [self.leftAxis setupKLineValues:self.data];
            break;
        case ChartViewType_OBV:
            [self.data computeLineMinMax];
            [self.leftAxis setupOBVValues:self.data];
            break;
    }
}

#pragma mark - 长按手势
- (void)longGestureRecognized:(UILongPressGestureRecognizer *)longPress {
    if (!self.longPressEnabled || self.data.dataSets.count == 0) {
        return;
    }
    [self.chartAction animationWithLongPressGestureRecognizer:longPress view:self chartTyoe:self.chartViewType];
}

#pragma mark - 缩放手势
- (void)pinchGestureRecognized:(UIPinchGestureRecognizer *)pinch {
    if (!self.isZoomEnabled || self.data.dataSets.count == 0) {
        return;
    }    
    [self.chartAction animationWithPinchGestureRecognizer:pinch view:self];
}

#pragma mark - 滑动手势
- (void)panGestureRecognized:(UIPanGestureRecognizer *)pan {
    if (!self.isDragEnabled || self.data.dataSets.count == 0) {
        return;
    }
    [self.chartAction animationWithPanGestureRecognizer:pan view:self];
}

#pragma mark - 外部调用链接
- (void)addCrossLine:(LNChartHighlight *)highlight longPress:(UILongPressGestureRecognizer *)longPress {
    self.zoomEnabled = !highlight.highlight;
    self.longPressEnabled = !highlight.highlight;
    self.data.highlighter.index = highlight.index;
    self.data.highlighter.highlight = highlight.highlight;
    self.data.highlighter.touchPoint  = [longPress locationInView:self];
    [self setNeedsDisplay];
}

- (void)slidingPage:(BOOL)isEnded data:(LNChartData *)data {
    self.dragEnabled = isEnded;
    self.data.dataSets = data.dataSets;
    self.data.lastEnd = data.lastEnd;
    self.data.lastStart = data.lastStart;
    self.data.emptyEndNum = data.emptyEndNum;
    self.data.emptyStartNum = data.emptyStartNum;
    [self setNeedsDisplay];
}

- (void)zoomPage:(LNChartData *)data {
    self.data.lastEnd = data.lastEnd;
    self.data.lastStart = data.lastStart;
    self.data.valCount = data.valCount;
    self.data.candleSet.candleW = data.candleSet.candleW;
    [self setNeedsDisplay];
}

@end
