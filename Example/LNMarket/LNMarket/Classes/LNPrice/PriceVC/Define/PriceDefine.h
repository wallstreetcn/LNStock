//
//  PriceDefine.h
//  Market
//
//  Created by ZhangBob on 4/22/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#ifndef PriceDefine_h
#define PriceDefine_h
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

#endif /* PriceDefine_h */
