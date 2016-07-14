//
//  QuotesNetwork.h
//  Market
//
//  Created by vvusu on 5/10/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PriceNetworkBlock)(BOOL isSuccess, id response);
@interface LNStockNetwork : NSObject

#pragma mark - A股
//请求分时图数据
+ (void)getStockMinuteDataWithStockCode:(NSString *)code block:(PriceNetworkBlock)block;

//请求分时买卖五档数据
+ (void)getDealListDataWithStockCode:(NSString *)code block:(PriceNetworkBlock)block;

//请求A股五日数据
+ (void)getAstockFiveDaysDataWithStockCode:(NSString *)code block:(PriceNetworkBlock)block;

//请求A股K线图数据
+ (void)getAstockDataWithStockCode:(NSString *)code type:(NSString *)type block:(PriceNetworkBlock)block;

#pragma mark - 外汇
//请求外汇K线图数据
+ (void)getBStockDataWithParamter:(NSDictionary *)paramter block:(PriceNetworkBlock)block;

#pragma mark - RealAPI 行情API
+ (void)getStockRealDataWithCode:(NSString *)code block:(PriceNetworkBlock)block;

@end
