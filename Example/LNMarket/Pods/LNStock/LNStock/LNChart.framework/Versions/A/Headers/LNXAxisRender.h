//
//  LNXAxisRender.h
//  Market
//
//  Created by vvusu on 5/4/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNRenderBase.h"
#import "LNXAxis.h"

@interface LNXAxisRender : LNRenderBase {
@private
    CGPoint gridLineSegmentsBuffer[2];
}

@property (nonatomic, strong) LNXAxis *xAxis;

+ (instancetype)initWithHandler:(LNChartHandler *)handler xAxis:(LNXAxis *)xAxis;
- (void)renderXAxis:(CGContextRef)context;
- (void)renderGridLines:(CGContextRef)context;
- (void)renderAxisLabels:(CGContextRef)context;

@end
