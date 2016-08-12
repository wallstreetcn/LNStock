//
//  LNChartDefine.h
//  LNChart
//
//  Created by vvusu on 8/2/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#ifndef LNChartDefine_h
#define LNChartDefine_h

//Color
#define kCHex(a) [UIColor \
colorWithRed:((float)((a & 0xFF0000) >> 16))/255.0 \
green:((float)((a & 0xFF00) >> 8))/255.0 \
blue:((float)(a & 0xFF))/255.0 alpha:1.0]

//Chart MA均线
#define kC_MA1 kCHex(0xF47958)
#define kC_MA2 kCHex(0xA65084)
#define kC_MA3 kCHex(0x0063B1)
#define kC_MA4 kCHex(0x000000)
#define kC_MA5 kCHex(0xeaeaea)

//MACD
#define kC_MACD_DEA kCHex(0xD16A7C)
#define kC_MACD_DIFF kCHex(0xF9AD79)
#define kC_MACD_MACD kCHex(0x8873A2)

//BOLL
#define kC_BOLL_MID kCHex(0xD16A7C)
#define kC_BOLL_UPPER kCHex(0xF9AD79)
#define kC_BOLL_LOWER kCHex(0x8873A2)

//KDJ
#define kC_KDJ_K kCHex(0xD16A7C)
#define kC_KDJ_D kCHex(0xF9AD79)
#define kC_KDJ_J kCHex(0x8873A2)

//RSI
#define kC_RSI_6 kCHex(0xD16A7C)
#define kC_RSI_12 kCHex(0xF9AD79)
#define kC_RSI_24 kCHex(0x8873A2)

//OBV
#define kC_OBV kCHex(0xD16A7C)

//---------------------------
//图表类型
typedef NS_ENUM(NSUInteger, ChartViewType) {
    ChartViewType_Line = 0,
    ChartViewType_Columnar,
    ChartViewType_Candle,
    ChartViewType_HollowCandle,
    ChartViewType_Bars,
    ChartViewType_MACD
};

//左拉加载更多状态
typedef NS_ENUM(NSUInteger, ChartLoadMoreType) {
    ChartLoadMoreType_Normal = 0,
    ChartLoadMoreType_Start,
    ChartLoadMoreType_Loading,
    ChartLoadMoreType_NoData
};

#endif /* LNChartDefine_h */
