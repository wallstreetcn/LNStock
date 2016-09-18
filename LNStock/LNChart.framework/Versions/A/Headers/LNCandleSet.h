//
//  LNChartCandleSet.h
//  Market
//
//  Created by vvusu on 5/20/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LNCandleSet : NSObject

@property (nonatomic, assign) CGFloat candleW;                  //candle宽度
@property (nonatomic, assign) CGFloat candleMaxW;               //candle最大宽度
@property (nonatomic, assign) CGFloat candleMinW;               //candle最小宽度
@property (nonatomic, strong) NSMutableArray *pointColors;      //点的颜色

@property (nonatomic, strong) NSArray *MAType;                  //MAType 标示 (MA5 MA10 MA20 ...)
@property (nonatomic, strong) NSArray *MAColors;                //MA颜色
@property (nonatomic, assign) CGFloat MALineWidth;              //MA线宽度

@property (nonatomic, strong) UIColor *candleRiseColor;         //上涨颜色
@property (nonatomic, strong) UIColor *candleFallColor;         //下跌颜色
@property (nonatomic, strong) UIColor *candleEqualColor;        //等值的颜色
@property (nonatomic, strong) UIColor *candleColor;             //整体颜色
@property (nonatomic, assign,getter=isGreenUp) BOOL greenUp;    //是否是绿涨红跌

@end
