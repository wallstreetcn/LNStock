//
//  LNChartLineSet.h
//  Market
//
//  Created by vvusu on 5/20/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LNChartLineSet : NSObject

@property (nonatomic, strong) UIColor *pointColor;      //点的颜色
@property (nonatomic, assign) CGFloat pointRadius;      //点的半径
@property (nonatomic, strong) UIColor *lineColor;       //线的颜色
@property (nonatomic, assign) CGFloat lineWidth;        //线的宽度
@property (nonatomic, strong) UIColor *fillColor;       //填充颜色
@property (nonatomic, strong) UIColor *startFillColor;  //填充开始颜色
@property (nonatomic, strong) UIColor *endFillColor;    //填充结束颜色
@property (nonatomic, strong) NSMutableArray *points;   //点的坐标
@property (nonatomic, strong) NSMutableArray *fillPoints;//fill点的坐标
@property (nonatomic, strong) NSMutableArray *fiveDayPoints;//五日的起始点

@property (nonatomic, assign) CGFloat avgLineWidth;     //均线的宽度
@property (nonatomic, strong) UIColor *avgLineColor;    //均线的颜色
@property (nonatomic, strong) UIColor *avgPointColor;   //均线点的颜色
@property (nonatomic, assign) CGFloat avgPointRadius;   //均线点的半径
@property (nonatomic, strong) NSMutableArray *avgPoints;//点的坐标

@property (nonatomic, strong) UIColor *lastPriceColor;          //昨日收盘价虚线颜色
@property (nonatomic, assign) CGFloat lastPriceLineWidth;       //昨日收盘价虚线的宽度
@property (nonatomic, strong) NSMutableArray *lastPricePoints;  //昨日收盘价虚线的坐标

@property (nonatomic, assign,getter=isDrawPoint) BOOL drawPoint;       //是否画点
@property (nonatomic, assign,getter=isDrawAVGPoint) BOOL drawAVGPoint; //是否画AVG点
@property (nonatomic, assign,getter=isFillEnabled) BOOL fillEnabled;   //是否填充颜色
@property (nonatomic, assign,getter=isDrawAVGLine) BOOL drawAVGLine;   //是否画均线
@property (nonatomic, assign,getter=isDrawLastPriceLine) BOOL drawLastPriceLine; //是否画昨收价格

@end
