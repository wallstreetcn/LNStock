//
//  LNChartHighlight.h
//  Market
//
//  Created by vvusu on 5/12/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface LNChartHighlight : NSObject

@property (nonatomic, assign) NSInteger index;                  //高亮点的下标
@property (nonatomic, assign) CGPoint point;                    //高亮点的坐标
@property (nonatomic, assign) CGPoint touchPoint;               //触摸点的坐标
@property (nonatomic, assign) CGFloat maxPriceRatio;            //最大的涨跌幅

@property (nonatomic, strong) UIColor *pointColor;              //高亮点的颜色
@property (nonatomic, strong) UIColor *pointLineColor;          //高亮线的颜色
@property (nonatomic, assign) CGFloat pointLineWidth;           //高亮线的宽度
@property (nonatomic, assign) CGFloat pointRadius;              //高亮点的半径

@property (nonatomic, strong) UIColor *levelLineColor;          //横线的颜色
@property (nonatomic, assign) CGFloat levelLineWidth;           //横线的的宽度

@property (nonatomic, strong) UIColor *verticalLineColor;       //竖线的颜色
@property (nonatomic, assign) CGFloat verticalLineWidth;        //竖线的的宽度

@property (nonatomic, strong) UIFont *labelFont;                //高亮提示框的字体
@property (nonatomic, strong) UIColor *labelColor;              //高亮提示框的颜色

@property (nonatomic, assign,getter=isHighlight) BOOL highlight;                    //是否显示高亮
@property (nonatomic, assign,getter=isDrawLevelLine) BOOL drawLevelLine;            //是否画水平线
@property (nonatomic, assign,getter=isVolumeChartType) BOOL volumeChartType;        //是否是交易量图
@property (nonatomic, assign,getter=isDrawVerticalLine) BOOL drawVerticalLine;      //是否画竖线
@property (nonatomic, assign,getter=isDrawHighlightPoint) BOOL drawHighlightPoint;  //是否画高亮的点
@property (nonatomic, assign,getter=isDrawLabelWithinAxis) BOOL drawLabelWithinAxis;//是否画在轴里面

@end
