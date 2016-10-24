//
//  LNLimitLine.h
//  LNChart
//
//  Created by vvusu on 6/30/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNComponentBase.h"

@class LNChartData;
@interface LNLimitLine : LNComponentBase
@property (nonatomic, copy) NSString *content;                      //文字
@property (nonatomic, strong) UIFont *textFont;                     //文字的字体
@property (nonatomic, strong) UIColor *textColor;                   //文本的颜色
@property (nonatomic, strong) UIColor *textBGColor;                 //文本背景颜色
@property (nonatomic, assign) CGFloat lineWidth;                    //线的宽度
@property (nonatomic, strong) UIColor *lineColor;                   //线的颜色
@property (nonatomic, strong) NSMutableArray *points;               //虚线的坐标
@property (nonatomic, assign, getter=isDrawTitle) BOOL drawTitle;   //可判断A股 和 外汇
@property (nonatomic, assign, getter=isDrawEnabled) BOOL drawEnabled;

- (void)setupValues:(LNChartData *)data;
@end
