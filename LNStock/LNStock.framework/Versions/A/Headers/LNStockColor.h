//
//  LNStockColor.h
//  LNStock
//
//  Created by vvusu on 8/30/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LNStockColor : NSObject
- (void)getStockColors;
+ (LNStockColor *)manager;

#pragma mark - LNStock 控制面板颜色设置
//行情面板——背景颜色
+ (UIColor *)stockViewBG;
//行情面板——头部分割线背景色
+ (UIColor *)borderLine;
//行情面板——头部涨跌颜色
+ (UIColor *)priceUp;
+ (UIColor *)priceDown;
//行情面板——头部价格背景动画（涨跌颜色）
+ (UIColor *)priceLastUp;
+ (UIColor *)priceLastDown;
//行情面板——头部titleView label 颜色
+ (UIColor *)titleLabelBG;
//行情面板——头部HeaderLabel字体颜色
+ (UIColor *)headerLabelText;
//行情面板——头部选择SelectView 背景颜色
+ (UIColor *)selectViewBG;
//行情面板——头部选择SelectView 下标线颜色
+ (UIColor *)selectViewLine;
//行情面板——头部选择SelectView Button颜色
+ (UIColor *)selectViewBtnN;
+ (UIColor *)selectViewBtnS;
//行情面板——头部长按显示InfoView 背景颜色
+ (UIColor *)infoViewBG;
//行情面板——五档DetailListView Cell的Label颜色
+ (UIColor *)detailListViewLabel;
//行情面板——复权指标OptionView Button颜色
+ (UIColor *)optionViewBtnN;
+ (UIColor *)optionViewBtnS;
//行情面板——复权指标OptionView ButtonImage的颜色
+ (UIColor *)optionViewBtnImage;
//行情面板——横屏 刷新Button颜色 关闭Button颜色
+ (UIColor *)headerViewCloseBtn;
+ (UIColor *)headerViewRefreshBtn;
//行情面板——外汇 选择图形样式 Button颜色
+ (UIColor *)selectViewChartTypeBtn;
//行情面板——停牌颜色设置
+ (UIColor *)stockHALT;

#pragma mark - Chart 图表颜色设置
//Chart 背景颜色
+ (UIColor *)chartBG;
//Chart 格子线的颜色
+ (UIColor *)chartBorder;
//Chart 长按高亮显示的颜色设置
+ (UIColor *)chartHighlighterLabelBG;
//Chart 长按高亮显示的Line颜色设置
+ (UIColor *)chartHighlighterLine;
//Chart K线涨跌颜色
+ (UIColor *)chartCandleRiseColor;
+ (UIColor *)chartCandleFallColor;
//Chart 折线填充颜色
+ (UIColor *)chartLineFillStartColor;
+ (UIColor *)chartLineFillEndColor;

@end
