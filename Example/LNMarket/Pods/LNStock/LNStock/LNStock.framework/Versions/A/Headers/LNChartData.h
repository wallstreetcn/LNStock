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
#import "LNChartHandler.h"
#import "LNChartLineSet.h"
#import "LNChartCandleSet.h"
#import "LNChartVolumeSet.h"
#import "LNChartHighlight.h"

@interface LNChartData : NSObject

@property (nonatomic, assign) CGFloat yMax;
@property (nonatomic, assign) CGFloat yMin;
@property (nonatomic, assign) CGFloat sizeRatio;        //试图比例（默认 0.98）
@property (nonatomic, assign) CGFloat gapRatio;         //空隙的比例（默认是 1/6）
@property (nonatomic, assign) CGFloat drawScale;        //绘制的均等比值；
@property (nonatomic, assign) NSInteger valCount;       //dataSet展示的个数
@property (nonatomic, strong) NSMutableArray *xVals;    //x轴的数据
@property (nonatomic, strong) NSMutableArray *dataSets; //点的数据
@property (nonatomic, strong) LNChartHandler *viewHandler;

@property (nonatomic, strong) LNChartLineSet *lineSet;
@property (nonatomic, strong) LNChartCandleSet *candleSet;
@property (nonatomic, strong) LNChartVolumeSet *volumeSet;
@property (nonatomic, strong) LNChartHighlight *highlighter;

@property (nonatomic, assign) NSInteger lastEnd;        //结束下标
@property (nonatomic, assign) NSInteger lastStart;      //开始下标
@property (nonatomic, assign) NSInteger yAxisMax;       //当前屏幕最大值的下标
@property (nonatomic, assign) NSInteger yAxisMin;       //当前屏幕最小值的下标
@property (nonatomic, assign) NSInteger emptyStartNum;  //开始的空蜡烛个数
@property (nonatomic, assign) NSInteger emptyEndNum;    //结束的空蜡烛个数

+ (instancetype)initWithHandler:(LNChartHandler *)handler;

- (void)computeMinMax;
- (void)computeLineMinMax;
- (void)computeFiveDayLineMinMax;
- (void)computeKLineMinMax;
- (void)computeVolumeMinMax;
- (void)computeKLineMA;
- (void)computeLastStartAndLastEnd;

- (BOOL)hasEmptyNum;
- (void)addEmptyCandleWhenAnimation:(NSInteger)num;
- (void)resetDataSetsAfterAnimation;
- (void)addXValue:(NSString *)string;
- (void)removeXValue:(NSInteger)index;
- (void)removeAllDataSet;

@end
 