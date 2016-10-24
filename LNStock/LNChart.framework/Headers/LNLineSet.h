//
//  LNChartLineSet.h
//  Market
//
//  Created by vvusu on 5/20/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LNLineSet : NSObject
@property (nonatomic, assign) CGFloat pointRadius;          //点的半径
@property (nonatomic, assign) CGFloat lineWidth;            //线的宽度
@property (nonatomic, strong) NSArray *lineColors;          //线的颜色
@property (nonatomic, strong) NSArray *pointColors;         //点的颜色
@property (nonatomic, strong) NSMutableArray *linePoints;   //点的坐标

@property (nonatomic, strong) UIColor *fillColor;           //填充颜色
@property (nonatomic, strong) UIColor *startFillColor;      //填充开始颜色
@property (nonatomic, strong) UIColor *endFillColor;        //填充结束颜色
@property (nonatomic, strong) NSMutableArray *fillPoints;   //fill点的坐标
@property (nonatomic, strong) NSMutableArray *fiveDayPoints;//五日的起始点

@property (nonatomic, assign,getter=isDrawPart) BOOL drawPart;                   //是否分段画，目前五日数据是分开画
@property (nonatomic, assign,getter=isDrawPoint) BOOL drawPoint;                 //是否画点
@property (nonatomic, assign,getter=isFillEnabled) BOOL fillEnabled;             //是否填充颜色
@property (nonatomic, assign,getter=isDrawLastPoint) BOOL drawLastPoint;         //是否画最后一个动画点
@property (nonatomic, assign,getter=isDrawLastPriceLine) BOOL drawLastPriceLine; //是否画昨收价格

@end
