//
//  LNDataRender.h
//  Market
//
//  Created by vvusu on 5/20/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNRenderBase.h"

@class LNChartData;
@interface LNDataRender : LNRenderBase

+ (instancetype)initWithHandler:(LNChartHandler *)handler;

//绘制点线
- (void)drawLineData:(CGContextRef)context data:(LNChartData *)data;
- (void)drawFiveDayLineData:(CGContextRef)context data:(LNChartData *)data;
- (void)drawCandle:(CGContextRef)context data:(LNChartData *)data;
- (void)drawBars:(CGContextRef)context data:(LNChartData *)data;

//绘制交易量
- (void)drawVolume:(CGContextRef)context data:(LNChartData *)data;
//绘制十线
- (void)drawCrossLine:(CGContextRef)context data:(LNChartData *)data;

@end
