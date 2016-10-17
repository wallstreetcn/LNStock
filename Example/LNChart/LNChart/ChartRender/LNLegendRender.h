//
//  LNLegendRender.h
//  Market
//
//  Created by vvusu on 5/21/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNRenderBase.h"
#import "LNChartLegend.h"

@class LNChartData;
@interface LNLegendRender : LNRenderBase {
@private
    CGPoint formLineSegmentsBuffer[2];
}
@property (nonatomic, strong) LNChartLegend *legend;

+ (instancetype)initWithHandler:(LNChartHandler *)handler legend:(LNChartLegend *)legend;
- (void)renderLegend:(CGContextRef)context data:(LNChartData *)data;

@end
