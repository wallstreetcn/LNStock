//
//  PriceNetwork.h
//  Market
//
//  Created by ZhangBob on 4/28/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PriceNetworkBlock)(BOOL isSuccess, id response);

@interface PriceNetwork : NSObject

#pragma mark - 主站新闻请求

+ (void)getStockNewsWithParamter:(NSDictionary *)paramters block:(PriceNetworkBlock)block;

+ (void)getMoreStockNewsWihtParamter:(NSDictionary *)paramters block:(PriceNetworkBlock)block;

@end
