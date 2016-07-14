//
//  LNStockDefine.h
//  Market
//
//  Created by vvusu on 6/2/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#ifndef LNStockDefine_h
#define LNStockDefine_h

#import "LNStockHandler.h"

//Color
#define kColorHex(a) [UIColor \
colorWithRed:((float)((a & 0xFF0000) >> 16))/255.0 \
green:((float)((a & 0xFF00) >> 8))/255.0 \
blue:((float)(a & 0xFF))/255.0 alpha:1.0]

//行情涨跌颜色
#define kSCPrice_U [LNStockHandler isGreenUp] ? kColorHex(0x03DC4E) : kColorHex(0xFA132D)
#define kSCPrice_D [LNStockHandler isGreenUp] ? kColorHex(0xFA132D) : kColorHex(0x03DC4E)

//行情头部价格背景——涨跌颜色
#define kSCLast_Price_U [LNStockHandler isGreenUp] ? kColorHex(0x59f05a) : kColorHex(0xe84740)
#define kSCLast_Price_D [LNStockHandler isGreenUp] ? kColorHex(0xe84740) : kColorHex(0x59f05a)

//行情背景颜色
#define kSCViewBG_D kColorHex(0xffffff)
#define kSCViewBG_N kColorHex(0x1a1a1a)

//行情分割线背景色
#define kSCBorder_D kColorHex(0xeaeaea)
#define kSCBorder_N kColorHex(0x000000)

//行情titleView info 背景颜色
#define kSCInfoBG_D kColorHex(0xf5f5f5)
#define kSCInfoBG_N kColorHex(0x222222)

//行情titleView label 颜色
#define kSCTitleLabelBG_D kColorHex(0x323232)
#define kSCTitleLabelBG_N kColorHex(0xe2e1e3)

//行情HeaderLabel字体颜色（夜晚N，白天D）
#define kSCHeaderLabel_D kColorHex(0x323232)
#define kSCHeaderLabel_N kColorHex(0xcdcdcd)

//Chart Color
#define kSChartBG_D kColorHex(0xffffff)
#define kSChartBG_N kColorHex(0xeaeaea)

//UI Frame ----------------------------
//默认StockView 高度
#define kFStockBGH 473.0
#define kFStockAHeaderH 173.0   //AStock 头部视图高度
#define kFStockBHeaderH 185.0   //BStock 头部视图高度
#define kFStockTitleViewH 50.0  //Stock 头部视图高度

#define kFBaseWidth [[UIScreen mainScreen]bounds].size.width
#define kFBaseHeight [[UIScreen mainScreen]bounds].size.height

//Notification ------------------------
#define LNQuoteTitleViewNotification @"LNQuoteTitleViewNotification"

//ENUM --------------------------------
typedef NS_ENUM(NSInteger, LNStockTitleType) {
    LNChartTitleType_1m = 0,    //分时(A股/外汇)
    LNChartTitleType_5m,        //5分(A股/外汇)
    LNChartTitleType_15m,       //15分(A股/外汇)
    LNChartTitleType_30m,       //30分(A股/外汇)
    LNChartTitleType_1H,        //1小时(A股/外汇)
    LNChartTitleType_2H,        //2小时(外汇)
    LNChartTitleType_4H,        //4小时(外汇)
    LNChartTitleType_1D,        //1天(A股/外汇)
    LNChartTitleType_5D,        //五日(A股)
    LNChartTitleType_1W,        //1周(A股/外汇)
    LNChartTitleType_1M,        //1月(A股/外汇)
    LNChartTitleType_NULL       //A股为分钟Button，外汇为K线类型
};

#endif /* LNStockDefine_h */
