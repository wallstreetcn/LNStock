//
//  LNLimitRender.h
//  LNChart
//
//  Created by vvusu on 6/30/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNRenderBase.h"
#import "LNLimitLine.h"

@interface LNLimitRender : LNRenderBase
@property (nonatomic, strong) LNLimitLine *limit;
+ (instancetype)initWithHandler:(LNChartHandler *)handler limit:(LNLimitLine *)limit;
- (void)renderLimit:(CGContextRef)context data:(LNChartData *)data;
@end
