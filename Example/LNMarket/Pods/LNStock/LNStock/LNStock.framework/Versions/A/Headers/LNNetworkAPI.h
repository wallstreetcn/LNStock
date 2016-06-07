//
//  LNNetworkAPI.h
//  Market
//
//  Created by vvusu on 4/20/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LNBaseUrlType) {
    LNBaseUrlTypeWSCN = 0,
    LNBaseUrlTypeHengSheng
};

//默认BaseURL
extern NSString *const kIBaseApi;
extern NSString *const kIBaseTestApi;

//A股行情URL
extern NSString *const KIBAPriceUrl;
//外汇行情URL
extern NSString *const KIBPriceUrl;

//恒生BaseUrl
extern NSString *const KIHSBaseUrl;

//恒生AccessTokenUrl
extern NSString *const KIHSTokenUrl;

//A股行情请求
extern NSString *const KIBAStockPriceAPI;
extern NSString *const KIBAStockFullFields;

//B股行情请求
extern NSString *const KIBStockPriceAPI;

//A股K线图数据
extern NSString *const KIAStockKLineAPI;

//A股分时图数据
extern NSString *const KIAStockTrendAPI;

//A股五日图数据
extern NSString *const KIAStockTrend5DayAPI;

@interface LNNetworkAPI : NSObject
@end
