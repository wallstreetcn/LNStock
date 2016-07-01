//
//  LNChartLegend.h
//  Market
//
//  Created by vvusu on 5/21/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNComponentBase.h"

typedef NS_ENUM(NSUInteger, ChartLegendPosition) {
    ChartLegendPositionTopLeft = 0,
    ChartLegendPositionTopRight,
    ChartLegendPositionBottomLeft,
    ChartLegendPositionBottomRight
};

typedef NS_ENUM(NSUInteger, ChartLegendForm) {
    ChartLegendFormLine = 0,   //线
    ChartLegendFormCircle,     //圆
    ChartLegendFormSquare,     //方
    ChartLegendFormNULL        //没有
};

@class LNChartData;
@interface LNChartLegend : LNComponentBase

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat heigth;
@property (nonatomic, strong) NSArray *labels;          //文字值
@property (nonatomic, strong) NSArray *colors;          //颜色值
@property (nonatomic, strong) UIFont *textFont;         //文字的字体
@property (nonatomic, strong) UIColor *textColor;       //文字的颜色
@property (nonatomic, assign) CGFloat formSize;         //标示符的大小
@property (nonatomic, assign) CGFloat formLineWidth;    //线的宽度
@property (nonatomic, assign) CGFloat stackSpace;       //间隙

@property (nonatomic, assign) ChartLegendForm legendFormType;
@property (nonatomic, assign) ChartLegendPosition LegendPosition;
@property (nonatomic, assign, getter=isDrawEnabled) BOOL drawEnabled; //是否画Legend

- (void)setupKLineLegend:(LNChartData *)data;
- (void)setupVolumeLegend:(LNChartData *)data;

@end
