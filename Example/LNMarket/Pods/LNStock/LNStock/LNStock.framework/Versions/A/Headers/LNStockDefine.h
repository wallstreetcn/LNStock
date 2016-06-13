//
//  LNStockDefine.h
//  Market
//
//  Created by vvusu on 6/2/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#ifndef LNStockDefine_h
#define LNStockDefine_h

#import "UIColor+Tool.h"
#define kColorHex(a) [UIColor colorWithRGBHex:a]
#define RGB3(a) [UIColor colorWithRed:a/255.0 green:a/255.0 blue:a/255.0 alpha:1.0]
#define RGB(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1.0]
#define RGBA(a,b,c,p) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:p]
// 随机色
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

// 背景色
#define kC1 RGB3(243)
#define kC2 [UIColor whiteColor]
#define kC3 RGB3(236)

//主体颜色
#define kCU1 RGB(182,150,102)
#define kCU2 [UIColor blackColor]

// 字体色
#define kFC1 RGB3(153)
#define kFC2 RGB(244,207,155)
#define kFC3 RGB(0,141,43) //绿
#define kFC4 RGB(209,0,0)  //红
#define kFC5 RGB3(68)

//行情涨跌颜色
#define kSCUp kColorHex(0xff2828)
#define kSCDown kColorHex(0x00da4a)

//行情导航栏背景色
#define kSCNNavBG kColorHex(0x172836)
#define kSCDNavBG [UIColor whiteColor]

//行情导航栏分割线背景色
#define kSCNNavBor kColorHex(0x0c0c0c)
#define kSCDNavBor kColorHex(0xe2e1e3)

//行情导航栏title字体颜色（夜晚N，白天D）
#define kSCNTitle kColorHex(0xffffff)
#define kSCDTitle kColorHex(0x000000)

//行情分割线背景色
#define kSCNBorder kColorHex(0x000000)
#define kSCDBorder kColorHex(0xeaeaea)

//行情Label字体颜色（夜晚N，白天D）
#define kSCNLabel kColorHex(0xcdcdcd)
#define kSCDLabel kColorHex(0x323232)

//行情背景色
#define kSCNBG kColorHex(0x1a1a1a)
#define kSCDBG [UIColor whiteColor]

//行情selectView背景色
#define kSCNSVGB kColorHex(0x222222)
#define kSCDSVBG kColorHex(0xf5f5f5)

//行情CellLabel 字体颜色
#define kSCNCellLabel kColorHex(0xcdcdcd)
#define kSCDCellLabel [UIColor blackColor]

//行情TableView分割线颜色
#define kSCNCellSepara kColorHex(0x141414)
#define kSCDCellSepara kColorHex(0xdddddd)

typedef NS_ENUM(NSInteger, LNStockTitleType) {
    LNChartTitleType_Min = 0,   //分时(A股/外汇)
    LNChartTitleType_5D,        //五日(A股/外汇)
    LNChartTitleType_1K,        //日K(A股)
    LNChartTitleType_7K,        //周K(A股/外汇)
    LNChartTitleType_30K,       //月K(A股/外汇)
    LNChartTitleType_5Min,      //5分(A股)
    LNChartTitleType_15Min,     //15分(A股)
    LNChartTitleType_30Min,     //30分(A股)
    LNChartTitleType_60Min,     //60分(A股)
    LNChartTitleType_1M,        //1月(外汇)
    LNChartTitleType_3M,        //3月(外汇)
    LNChartTitleType_1Y,        //1年(外汇)
    LNChartTitleType_3Y,        //3年(外汇)
    LNChartTitleType_5Y,        //5年(外汇)
    LNChartTitleType_NULL       //A股为分钟Button，外汇为K线类型
};

#endif /* LNStockDefine_h */
