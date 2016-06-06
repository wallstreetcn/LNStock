//
//  LNYAxisRender.h
//  Market
//
//  Created by vvusu on 5/4/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNRenderBase.h"
#import "LNYAxis.h"

@interface LNYAxisRender : LNRenderBase {
@private
    CGPoint gridLineBuffer[2];
}

@property (nonatomic, strong) LNYAxis *yAxis;
+ (instancetype)initWithHandler:(LNChartHandler *)handler yAxis:(LNYAxis *)yAxis;
- (void)renderYAxis:(CGContextRef)context;
- (void)renderGridLines:(CGContextRef)context;
- (void)renderYAxisLabels:(CGContextRef)context;

@end
