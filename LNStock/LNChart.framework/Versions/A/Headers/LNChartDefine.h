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

//图表类型
typedef NS_ENUM(NSUInteger, ChartViewType) {
    ChartViewType_Line = 0,
    ChartViewType_Columnar,
    ChartViewType_Candle,
    ChartViewType_HollowCandle,
    ChartViewType_Bars,
    ChartViewType_MACD,
    ChartViewType_BOLL,
    ChartViewType_OBV
};

//左拉加载更多状态
typedef NS_ENUM(NSUInteger, ChartLoadMoreType) {
    ChartLoadMoreType_Normal = 0,
    ChartLoadMoreType_Start,
    ChartLoadMoreType_Loading,
    ChartLoadMoreType_NoData
};

#endif /* LNChartDefine_h */
