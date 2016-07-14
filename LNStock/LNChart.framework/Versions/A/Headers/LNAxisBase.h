//
//  LNAxisBase.h
//  Market
//
//  Created by vvusu on 4/27/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNComponentBase.h"

@interface LNAxisBase : LNComponentBase

@property (nonatomic, strong) UIFont *labelFont;            //文字字体
@property (nonatomic, strong) UIColor *labelTextColor;      //文字颜色

@property (nonatomic, strong) UIColor *axisLineColor;       //轴的颜色
@property (nonatomic, assign) CGFloat axisLineWidth;        //轴的宽度
@property (nonatomic, assign) CGFloat axisLineDashPhase;    //轴虚线起始距离
@property (nonatomic, strong) NSArray *axisLineDashLengths; //轴虚线的数组
@property (nonatomic, strong) NSMutableArray *limitLines;   //分割线

@property (nonatomic, strong) UIColor *gridColor;           //格子的颜色
@property (nonatomic, assign) CGFloat gridLineWidth;        //格子的宽度
@property (nonatomic, assign) CGLineCap gridLineCap;        //格子样式
@property (nonatomic, assign) CGFloat gridLineDashPhase;    //格子的虚线起始距离
@property (nonatomic, strong) NSArray *gridLineDashLengths; //格子的虚线的数组 {5.f,5.f}

@property (nonatomic, assign) CGFloat axisMinimum;          //最小值
@property (nonatomic, assign) CGFloat axisMaximum;          //最大值
@property (nonatomic, assign) CGFloat axisRange;            //总值

@property (nonatomic, assign) BOOL customAxisMin;
@property (nonatomic, assign) BOOL customAxisMax;

@property (nonatomic, assign, getter=isDrawLabelsEnabled) BOOL drawLabelsEnabled;           //是否画文字
@property (nonatomic, assign, getter=isDrawAxisLineEnabled) BOOL drawAxisLineEnabled;       //是否画轴线
@property (nonatomic, assign, getter=isDrawGridLinesEnabled) BOOL drawGridLinesEnabled;     //是否画格子线
@property (nonatomic, assign, getter=isGridAntialiasEnabled) BOOL gridAntialiasEnabled;     //是否抗锯齿

@end
