//
//  LNChartView.h
//  Market
//
//  Created by vvusu on 4/28/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNChartBase.h"
#import "LNYAxis.h"
#import "LNDataRender.h"
#import "LNYAxisRender.h"
#import "LNXAxisRender.h"
#import "LNLegendRender.h"
#import "LNChartLegend.h"
#import "LNChartAnimator.h"

typedef NS_ENUM(NSUInteger, ChartViewType) {
    ChartViewType_Normal = 0,
    ChartViewType_Line,
    ChartViewType_FiveDayLine,
    ChartViewType_KLine,
    ChartViewType_Columnar,
    ChartViewType_FiveDayColumnar,
    ChartViewType_KColumnar
};

typedef void (^LNChartViewPinchRecognizerBlock)(LNChartData *data);
typedef void (^LNChartViewPanRecognizerBlock)(BOOL isEnded, LNChartData *data);
typedef void (^LNChartViewHighlightBlock)(LNChartHighlight *highlight, UILongPressGestureRecognizer *longPress);

@interface LNChartView : LNChartBase
@property (nonatomic, strong) LNYAxis *leftAxis;                                  //左轴
@property (nonatomic, strong) LNYAxis *rightAxis;                                 //右轴
@property (nonatomic, strong) LNChartLegend *chartLegend;                         //图标
@property (nonatomic, assign) ChartViewType chartViewType;                        //chart类型
@property (nonatomic, strong) LNChartAnimator *animator;                          //动画管理

@property (nonatomic, strong) LNDataRender *dataRender;
@property (nonatomic, strong) LNYAxisRender *leftRender;
@property (nonatomic, strong) LNYAxisRender *rightRender;
@property (nonatomic, strong) LNXAxisRender *xAxisRender;
@property (nonatomic, strong) LNLegendRender *legendRender;

@property (nonatomic, assign, getter=isDragEnabled) BOOL dragEnabled;             //是否可以拖拽
@property (nonatomic, assign, getter=isZoomEnabled) BOOL zoomEnabled;             //是否可以缩放
@property (nonatomic, assign, getter=isLongPressEnabled) BOOL longPressEnabled;   //是否可以长按

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;

@property (nonatomic, copy) LNChartViewHighlightBlock highlightBlock;
@property (nonatomic, copy) LNChartViewPanRecognizerBlock panRecognizerBlock;
@property (nonatomic, copy) LNChartViewPinchRecognizerBlock pinchRecognizerBlock;

//设置数据
- (void)setupWithData:(NSMutableArray *)data;

//缩放手势回调
- (void)zoomPage:(LNChartData *)data;

//滑动手势回调
- (void)slidingPage:(BOOL)isEnded data:(LNChartData *)data;

//长按手势回调
- (void)addCrossLine:(LNChartHighlight *)highlight longPress:(UILongPressGestureRecognizer *)longPress;
@end
