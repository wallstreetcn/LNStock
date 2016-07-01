//
//  LNChartCandleSet.h
//  Market
//
//  Created by vvusu on 5/20/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LNChartCandleSet : NSObject

@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) CGFloat lastTime;
@property (nonatomic, assign) NSInteger speedNum;        //滑动的偏移量

@property (nonatomic, assign) CGFloat candleW;            //candle宽度
@property (nonatomic, assign) CGFloat candleMaxW;         //candle最大宽度
@property (nonatomic, assign) CGFloat candleMinW;         //candle最小宽度
@property (nonatomic, strong) NSMutableArray *points;     //点的坐标
@property (nonatomic, strong) NSMutableArray *pointColors;//点的颜色
@property (nonatomic, strong) NSMutableArray *candleRacts;
@property (nonatomic, strong) NSMutableArray *candleLinePoints;

@property (nonatomic, strong) UIColor *MA1Color;         //MA1颜色
@property (nonatomic, strong) UIColor *MA2Color;         //MA2颜色
@property (nonatomic, strong) UIColor *MA3Color;         //MA3颜色
@property (nonatomic, strong) UIColor *MA4Color;         //MA3颜色
@property (nonatomic, strong) UIColor *MA5Color;         //MA3颜色
@property (nonatomic, assign) CGFloat MALineWidth;       //MA线宽度
@property (nonatomic, strong) NSMutableArray *MAPoints;

@property (nonatomic, strong) UIColor *candleRiseColor;  //上涨颜色
@property (nonatomic, strong) UIColor *candleFallColor;  //下跌颜色
@property (nonatomic, strong) UIColor *candleEqualColor; //等值的颜色

@end
