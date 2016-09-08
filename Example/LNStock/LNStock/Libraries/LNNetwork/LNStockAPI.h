//
//  LNStockAPI.h
//  LNStock
//
//  Created by vvusu on 6/2/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - A股数据
extern NSString *const KIAStockAPI;
extern NSString *const KIAStockTestAPI;

//A股分时图数据
extern NSString *const KIAStockTrendAPI;
//A股分时交易数据
extern NSString *const KIAStockPriceAPI;

//A股五日图数据
extern NSString *const KIAStockTrend5DayAPI;
//A股K线图数据
extern NSString *const KIAStockKLineAPI;
//KLine
extern NSString *const KIAStockKLineFields;
//MA
extern NSString *const KIAStockMAFields;
//交易量
extern NSString *const KIAStockAmountFields;
//MACD
extern NSString *const KIAStocMACDFields;
//BOLL
extern NSString *const KIAStocBOLLFields;
//KDJ
extern NSString *const KIAStocKDJFields;
//RSI
extern NSString *const KIAStocRSIFields;
//OBV
extern NSString *const KIAStocOBVFields;
//行情列表(沪深)
extern NSString *const KIAStockListAPI;
//行情列表(沪深)Fields
extern NSString *const KIAStockListFields;
//行情搜索
extern NSString *const KIAStockSearchAPI;

//返回一直或多只股票行情报价
extern NSString *const KIStockRealAPI;
//默认行情面板Fields
extern NSString *const KIAStockRealFields;

#pragma mark - B股数据 （外汇）
extern NSString *const KIBStockAPI;
extern NSString *const KIBStockTestAPI;

//B股行情请求
extern NSString *const KIBStockRealAPI;
extern NSString *const KIBStockRealFields;

extern NSString *const KIBStockPriceAPI;
extern NSString *const KIBStockKLineAPI;

//行情列表(外汇),行情列表Fields
extern NSString *const KIBStockListAPI;
extern NSString *const KIBStockListFields;

#pragma mark - 恒生API
extern NSString *const KIHSAPI;
extern NSString *const KIHSTestAPI;

//恒生AccessTokenUrl
extern NSString *const KIHSTokenAPI;
//恒生
extern NSString *const KIHSFullFieldsAPI;

@interface LNStockAPI : NSObject
@end
