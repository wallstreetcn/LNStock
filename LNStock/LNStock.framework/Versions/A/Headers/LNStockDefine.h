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
