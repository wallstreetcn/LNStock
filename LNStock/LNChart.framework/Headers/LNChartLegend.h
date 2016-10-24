//
//  LNChartLegend.h
//  Market
//
//  Created by vvusu on 5/21/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNComponentBase.h"

typedef NS_ENUM(NSUInteger, ChartLegendPosition) {
    ChartLegendPositionTopLeft = 0, //左上
    ChartLegendPositionTopRight,    //右上
    ChartLegendPositionBottomLeft,  //左下
    ChartLegendPositionBottomRight  //右下
};

typedef NS_ENUM(NSUInteger, ChartLegendForm) {
    ChartLegendFormLine = 0,        //线
    ChartLegendFormCircle,          //圆
    ChartLegendFormSquare,          //方
    ChartLegendFormContent,         //文本
    ChartLegendFormNULL             //没有
};

@class LNChartData;
@interface LNChartLegend : LNComponentBase

@property (nonatomic, assign) CGFloat width;                          //宽
@property (nonatomic, assign) CGFloat heigth;                         //高
@property (nonatomic, strong) NSArray *contents;                      //标示的文字
@property (nonatomic, strong) NSArray *colors;                        //标示的颜色值
@property (nonatomic, strong) NSArray *labels;                        //显示的文字值
@property (nonatomic, strong) NSArray *labelColors;                   //文字的颜色

@property (nonatomic, strong) UIFont *textFont;                       //文字的字体
@property (nonatomic, strong) UIColor *textDefaultColor;              //文字的颜色
@property (nonatomic, assign) CGFloat formSize;                       //标示符的大小
@property (nonatomic, assign) CGFloat formLineWidth;                  //线的宽度
@property (nonatomic, assign) CGFloat stackSpace;                     //间隙
@property (nonatomic, assign) ChartLegendForm legendFormType;         //标示样式
@property (nonatomic, assign) ChartLegendPosition LegendPosition;     //标示位置
@property (nonatomic, assign, getter=isDrawEnabled) BOOL drawEnabled; //是否画Legend
@property (nonatomic, assign, getter=isCustomLabel) BOOL customLabel; //是否是自定义

- (void)setupLineLegend:(LNChartData *)data;
- (void)setupVolumeLegend:(LNChartData *)data;
- (void)setupCandleLegend:(LNChartData *)data;
- (void)setupMALegend:(LNChartData *)data;
- (void)setupOHLCLegend:(LNChartData *)data;
- (void)setupMACDLegend:(LNChartData *)data;
- (void)setupBOLLLegend:(LNChartData *)data;
@end
