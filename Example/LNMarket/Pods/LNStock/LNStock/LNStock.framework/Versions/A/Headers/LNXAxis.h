//
//  LNXAxis.h
//  Market
//
//  Created by vvusu on 4/27/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNAxisBase.h"

typedef NS_ENUM(NSUInteger, XAxisLabelPosition) {
    XAxisLabelPositionTop = 0,
    XAxisLabelPositionBottom = 1,
    XAxisLabelPositionBothSided = 2,
    XAxisLabelPositionTopInside = 3,
    XAxisLabelPositionBottomInside = 4
};

typedef NS_ENUM(NSUInteger, XAxisLabelSite) {
    XAxisLabelSiteCenter = 0,
    XAxisLabelSiteLeft,
    XAxisLabelSiteRight
};

@class LNChartData;
@interface LNXAxis : LNAxisBase

@property (nonatomic, assign) NSInteger labelCount;
@property (nonatomic, strong) NSMutableArray *values;
@property (nonatomic, assign) XAxisLabelSite labelSite;
@property (nonatomic, assign) XAxisLabelPosition labelPosition;

- (void)setupValues:(LNChartData *)data;
- (void)setupLineValues:(LNChartData *)data;
- (void)setupKLineValues:(LNChartData *)data;
- (void)setupVolumeValues:(LNChartData *)data;

@end
