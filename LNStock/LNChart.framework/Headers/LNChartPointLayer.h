//
//  LNChartPointLayer.h
//  LNChart
//
//  Created by vvusu on 10/14/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@class LNChartData;
@interface LNChartPointLayer : CALayer

- (void)stopPointAnimation;
- (void)startPointAnimation;
- (void)changeLayerStatus:(LNChartData *)chartData;
@end
