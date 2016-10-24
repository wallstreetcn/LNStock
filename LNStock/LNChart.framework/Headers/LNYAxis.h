//
//  LNYAxis.h
//  Market
//
//  Created by vvusu on 4/27/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNAxisBase.h"

typedef NS_ENUM(NSUInteger, YAxisLabelPosition) {
    YAxisLabelPositionOutsideChart = 0,
    YAxisLabelPositionInsideChart
};

typedef NS_ENUM(NSUInteger, AxisDependency) {
    AxisDependencyLeft = 0,
    AxisDependencyRight
};

@class LNChartData;
@interface LNYAxis : LNAxisBase
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, assign) NSInteger labelCount;
@property (nonatomic, assign) AxisDependency yPosition;          //Y轴的类型
@property (nonatomic, assign) YAxisLabelPosition labelPosition;  //Label的方位

+ (instancetype)initWithType:(AxisDependency)position;
- (void)setupValues:(LNChartData *)data;
- (void)setupKLineValues:(LNChartData *)data;
- (void)setupVolumeValues:(LNChartData *)data;
- (void)setupMACDValues:(LNChartData *)data;
- (void)setupOBVValues:(LNChartData *)data;
@end
