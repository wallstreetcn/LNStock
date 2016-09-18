//
//  LNStockColor.h
//  LNStock
//
//  Created by vvusu on 8/30/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

/*
    说明：
    以下颜色都可以修改，要在Pods下 LNStock/Resources/LNStock.bundle/stockcolors.plist 中修改。
    更新的时候注意保存!!!
 */

#import <UIKit/UIKit.h>

@interface LNStockColor : NSObject
- (void)getStockColors;
+ (LNStockColor *)manager;

#pragma mark - LNStock 控制面板颜色设置

//行情面板——背景颜色
+ (UIColor *)stockViewBG;
//行情面板——头部分割线背景色
+ (UIColor *)borderLine;
//行情面板——头部涨 跌颜色
+ (UIColor *)priceUp;
+ (UIColor *)priceDown;
//行情面板——头部价格背景动画（涨跌闪烁颜色）
+ (UIColor *)priceLastUp;
+ (UIColor *)priceLastDown;
//行情面板——停牌颜色设置
+ (UIColor *)stockHALT;

//行情面板——头部titleView label 颜色
+ (UIColor *)titleLabelBG;
//行情面板——头部HeaderLabel字体颜色
+ (UIColor *)headerLabelText;

//行情面板——头部选择SelectView 背景颜色
+ (UIColor *)selectViewBG;
//行情面板——头部选择SelectView 下标线颜色
+ (UIColor *)selectViewLine;
//行情面板——头部选择SelectView Button颜色 (N 正常状态，S 选中状态)
+ (UIColor *)selectViewBtnN;
+ (UIColor *)selectViewBtnS;
//行情面板——外汇 选择图形样式 Button颜色（外汇面板）
+ (UIColor *)selectViewChartTypeBtn;

//行情面板——头部长按显示InfoView 背景颜色
+ (UIColor *)infoViewBG;
//行情面板——五档DetailListView Cell的Label颜色
+ (UIColor *)detailListViewLabel;

//行情面板——复权指标OptionView Button颜色 (N 正常状态，S 选中状态)
+ (UIColor *)optionViewBtnN;
+ (UIColor *)optionViewBtnS;
//行情面板——复权指标OptionView ButtonImage的颜色
+ (UIColor *)optionViewBtnImage;

//行情面板——横屏 刷新Button颜色
+ (UIColor *)headerViewCloseBtn;
//行情面板——横屏 关闭Button颜色
+ (UIColor *)headerViewRefreshBtn;

#pragma mark - Chart 图表颜色设置

//Chart 背景颜色
+ (UIColor *)chartBG;
//Chart 格子线的颜色
+ (UIColor *)chartBorder;
//Chart 长按高亮显示的颜色设置
+ (UIColor *)chartHighlighterLabelBG;
//Chart 长按高亮显示的Line颜色设置
+ (UIColor *)chartHighlighterLine;
//Chart 折线填充颜色
+ (UIColor *)chartLineFillStartColor;
+ (UIColor *)chartLineFillEndColor;

//Chart 蜡烛颜色颜色包括美国线
+ (UIColor *)chartCandleColor;
//Chart K线涨跌颜色
+ (UIColor *)chartCandleRiseColor;
+ (UIColor *)chartCandleFallColor;

//Chart Line颜色
+ (UIColor *)chartLine;
//Chart 均线颜色
+ (UIColor *)chartAVGLine;
//Chart 昨收价格线颜色
+ (UIColor *)chartLimitLine;

//Chart MA颜色
+ (UIColor *)chartMA1;
+ (UIColor *)chartMA2;
+ (UIColor *)chartMA3;
+ (UIColor *)chartMA4;
+ (UIColor *)chartMA5;

//Chart MACD颜色
+ (UIColor *)chartDIFF;
+ (UIColor *)chartDEA;
+ (UIColor *)chartMACD;

//Chart BOLL颜色
+ (UIColor *)chartUPPER;
+ (UIColor *)chartMID;
+ (UIColor *)chartLOWER;

//Chart KDJ颜色
+ (UIColor *)chartK;
+ (UIColor *)chartD;
+ (UIColor *)chartJ;

//Chart RSI颜色
+ (UIColor *)chartRSI6;
+ (UIColor *)chartRSI12;
+ (UIColor *)chartRSI24;

//Chart OBV颜色
+ (UIColor *)chartOBV;

@end
