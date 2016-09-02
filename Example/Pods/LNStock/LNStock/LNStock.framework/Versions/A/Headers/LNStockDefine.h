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

#define kColorHex(a) [UIColor \
colorWithRed:((float)((a & 0xFF0000) >> 16))/255.0 \
green:((float)((a & 0xFF00) >> 8))/255.0 \
blue:((float)(a & 0xFF))/255.0 alpha:1.0]

/*
    LNStock 控制面板颜色设置
 */

//行情面板——背景颜色
#define kSCViewBG_D kColorHex(0xffffff)
#define kSCViewBG_N kColorHex(0x1a1a1a)

//行情面板——头部涨跌颜色
#define kSCPrice_U [LNStockHandler isGreenUp] ? kColorHex(0x03DC4E) : kColorHex(0xFA132D)
#define kSCPrice_D [LNStockHandler isGreenUp] ? kColorHex(0xFA132D) : kColorHex(0x03DC4E)

//行情面板——头部价格背景动画（涨跌颜色）
#define kSCLast_Price_U [LNStockHandler isGreenUp] ? kColorHex(0x59f05a) : kColorHex(0xe84740)
#define kSCLast_Price_D [LNStockHandler isGreenUp] ? kColorHex(0xe84740) : kColorHex(0x59f05a)

//行情面板——头部分割线背景色
#define kSCBorder_D kColorHex(0xeaeaea)
#define kSCBorder_N kColorHex(0x123122)

//行情面板——头部titleView label 颜色
#define kSCTitleLabelBG_D kColorHex(0x323232)
#define kSCTitleLabelBG_N kColorHex(0xe2e1e3)

//行情面板——头部HeaderLabel字体颜色（夜晚N，白天D）
#define kSCHeaderLabel_D kColorHex(0x323232)
#define kSCHeaderLabel_N kColorHex(0xcdcdcd)

//行情面板——头部选择SelectView 背景颜色
#define kSCSelectViewBG_D kColorHex(0xf5f5f5)
#define kSCSelectViewBG_N kColorHex(0x222222)

//行情面板——头部选择SelectView 下标线颜色
#define kSCSelectView_LineColor kColorHex(0x4a90e2)

//行情面板——头部选择SelectView Button颜色
#define kSCSelectView_Btn_NC kColorHex(0x8b8b8e)
#define kSCSelectView_Btn_SC kColorHex(0x4a90e2)

//行情面板——头部长按显示InfoView 背景颜色
#define kSCInfoBG_D kColorHex(0xf5f5f5)
#define kSCInfoBG_N kColorHex(0x222222)

//行情面板——五档DetailListView Cell的Lable颜色
#define kSCDetailListV_Cell_D kColorHex(0x323232)
#define kSCDetailListV_Cell_N kColorHex(0xcdcdcd)

//行情面板——复权指标OptionView Button颜色
#define kSCOptionView_Btn_NC kColorHex(0x9EA0A0)
#define kSCOptionView_Btn_SC kColorHex(0x1478F0)

//行情面板——横屏 刷新Button颜色 关闭Button颜色
#define kSCHeaderView_CloseBtn [UIcolor red]
#define kSCHeaderView_RefreshBtn kColorHex(0x000000)

//行情面板——外汇 选择图形样式 Button颜色
#define kSCSelectView_ChartTypeBtn kColorHex(0x4a90e2)

/*
    Chart 图表颜色设置
 */

//Chart 背景颜色
#define kSChartBG_D kColorHex(0xffffff)
#define kSChartBG_N kColorHex(0x191919)

//Chart 格子线的颜色
#define kSChartBorder_D kColorHex(0xeaeaea)
#define kSChartBorder_N kColorHex(0x0A0A0A)

//Chart 长按高亮显示的颜色设置
#define kSChart_HL_LBG_D kColorHex(0xDBE6F0)
#define kSChart_HL_LBG_N kColorHex(0xEDEDED)

#define kSChart_HL_LLBG_D kColorHex(0xDBE6F0)
#define kSChart_HL_LLBG_N kColorHex(0xEDEDED)

#define kSChart_HL_VLBG_D kColorHex(0xDBE6F0)
#define kSChart_HL_VLBG_N kColorHex(0xEDEDED)

//Chart K线涨跌颜色
#define kSChart_Candle_RiseColor kColorHex(0xF52929)
#define kSChart_Candle_FallColor kColorHex(0x40D94D)

//Chart 折线填充颜色
#define kSChart_Line_FillStartColor [UIColor colorWithRed:24/255.0 green:96/255.0 blue:254/255.0 alpha:0.6]
#define kSChart_Line_FillEndColor [UIColor colorWithRed:24/255.0 green:96/255.0 blue:254/255.0 alpha:0.15]

/*
    LNStock 控制面板 视图Frame 设置
 */

#define kFBaseWidth [[UIScreen mainScreen]bounds].size.width
#define kFBaseHeight [[UIScreen mainScreen]bounds].size.height

//默认StockView 高度
#define kFStockBGH 473.0
#define kFStockAHeaderH 173.0   //AStock 头部视图高度
#define kFStockBHeaderH 185.0   //BStock 头部视图高度
#define kFStockTitleViewH 50.0  //Stock  头部视图高度

/*
    LNStock 控制面板 Notification
 */

#define LNQuoteTitleViewNotification @"LNQuoteTitleViewNotification"

/*
    LNStock 控制面板 ENUM 枚举
 */

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

//复权
typedef NS_ENUM(NSInteger, LNStockAdjustType) {
    LNStockAdjustType_Normal = 0,  //不复权
    LNStockAdjustType_Befor,       //前复权
    LNStockAdjustType_After        //后复权
};

//股票指标
typedef NS_ENUM(NSInteger, LNStockFactorType) {
    LNStockFactorType_Volume = 0,
    LNStockFactorType_MACD,
    LNStockFactorType_BOLL,
    LNStockFactorType_KDJ,
    LNStockFactorType_RSI,
    LNStockFactorType_OBV,
    LNStockFactorType_DMI,
    LNStockFactorType_WR,
    LNStockFactorType_SAR
};

//请求类型 加载 K线 数据的不同方式
typedef NS_ENUM(NSInteger, LNStockRequestType) {
    LNStockRequestType_Normal = 0,
    LNStockRequestType_Refresh,
    LNStockRequestType_LoadMore
};

#endif /* LNStockDefine_h */
