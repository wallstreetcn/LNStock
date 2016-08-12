//
//  LNChartData.h
//  Market
//
//  Created by vvusu on 4/25/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LNXAxis.h"
#import "LNYAxis.h"
#import "LNDataSet.h"
#import "LNLineSet.h"
#import "LNCandleSet.h"
#import "LNColumnarSet.h"
#import "LNChartHighlight.h"
#import "LNChartHandler.h"
#import "LNChartDefine.h"
#import "LNChartFormatter.h"

@interface LNChartData : NSObject
@property (nonatomic, assign) CGFloat yMax;
@property (nonatomic, assign) CGFloat yMin;
@property (nonatomic, assign) CGFloat gapRatio;               //空隙的比例（默认是 1/5）
@property (nonatomic, assign) CGFloat sizeRatio;              //试图比例（默认 0.85）
@property (nonatomic, assign) CGFloat drawScale;              //绘制的均等比值；
@property (nonatomic, assign) NSInteger valCount;             //dataSet展示的个数
@property (nonatomic, assign) NSInteger lastEnd;              //结束下标
@property (nonatomic, assign) NSInteger lastStart;            //开始下标
@property (nonatomic, assign) NSInteger yAxisMax;             //当前屏幕最大值的下标
@property (nonatomic, assign) NSInteger yAxisMin;             //当前屏幕最小值的下标
@property (nonatomic, assign) NSInteger emptyEndNum;          //结束的空蜡烛个数
@property (nonatomic, assign) NSInteger emptyStartNum;        //开始的空蜡烛个数
@property (nonatomic, strong) NSMutableArray *xVals;          //x轴的数据
@property (nonatomic, strong) NSMutableArray *dataSets;       //点的数据
@property (nonatomic, copy) NSString *precision;              //保留几位小数

@property (nonatomic, strong) LNLineSet *lineSet;
@property (nonatomic, strong) LNCandleSet *candleSet;
@property (nonatomic, strong) LNColumnarSet *volumeSet;
@property (nonatomic, strong) LNChartHandler *viewHandler;
@property (nonatomic, strong) LNChartHighlight *highlighter;
@property (nonatomic, assign) ChartViewType chartType;        //是否是外匯
@property (nonatomic, assign) ChartLoadMoreType loadMoreType; //左拉加载更多状态
@property (nonatomic, assign) BOOL isBStock;                  //是否是外匯
@property (nonatomic, assign, getter=isDrawLoadMoreContent) BOOL drawLoadMoreContent;  //是否画左拉加载更多Info

+ (instancetype)initWithHandler:(LNChartHandler *)handler;

- (void)computeLineMinMax;
- (void)computeKLineMinMax;
- (void)computeVolumeMinMax;
- (void)computeMACDMinMax;
- (void)computeLinePointsCoord;
- (void)computeLastStartAndLastEnd;
//請求的當前屏幕最大個數
- (NSInteger)computeMaxValCount;

- (BOOL)hasEmptyNum;
- (void)removeAllDataSet;
- (void)resetDataSetsAfterAnimation;
- (void)addXValue:(NSString *)string;
- (void)removeXValue:(NSInteger)index;
- (void)addEmptyCandleWhenAnimation:(NSInteger)num;
@end
 