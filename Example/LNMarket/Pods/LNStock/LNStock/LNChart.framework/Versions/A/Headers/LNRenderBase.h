//
//  LNRenderBase.h
//  Market
//
//  Created by vvusu on 5/4/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNChartFormatter.h"
#import "LNChartHandler.h"
#import "LNChartUtils.h"

@interface LNRenderBase : NSObject

@property (nonatomic, assign) NSInteger minX;
@property (nonatomic, assign) NSInteger maxX;
@property (nonatomic, strong) LNChartHandler *viewHandler;

@end
