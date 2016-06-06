//
//  LNChartBase.h
//  Market
//
//  Created by vvusu on 4/27/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNChartData.h"
#import "LNChartUtils.h"
#import "LNChartHandler.h"
#import "LNChartAnimator.h"

@interface LNChartBase : UIView

@property (nonatomic, strong) LNXAxis *xAxis;
@property (nonatomic, strong) LNChartData *data;                    //绘制的数据
@property (nonatomic, strong) LNChartHandler *viewHandler;          //位置管理
@property (nonatomic, strong) LNChartAnimator *animator;            //动画管理

@property (nonatomic, assign) BOOL drawMarkers;                     //是否绘制mark线
@property (nonatomic, strong) UIColor *borderColor;                 //边线的颜色
@property (nonatomic, assign) CGFloat borderLineWidth;              //边线的宽度
@property (nonatomic, strong) UIColor *gridBackgroundColor;         //背景颜色

@property (nonatomic, strong) UIFont *descriptionFont;              //绘制的字体
@property (nonatomic, strong) UIColor *descriptionTextColor;        //绘制的颜色
@property (nonatomic, assign) CGPoint descriptionTextPosition;      //绘制文字的点
@property (nonatomic, assign) NSTextAlignment descriptionTextAlign; //绘制文字格式

@property (nonatomic, strong) UIFont *infoFont;                     //绘制提示信息的字体
@property (nonatomic, strong) UIColor *infoTextColor;               //绘制提示的颜色
@property (nonatomic, copy) NSString *noDataText;                   //没有数据的提示
@property (nonatomic, assign, getter=isDrawInfoEnabled) BOOL drawInfoEnabled; //是否画提示

- (void)setupChart;
- (void)notifyDataSetChanged;
- (void)setExtraOffsetsLeft:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom;

@end
