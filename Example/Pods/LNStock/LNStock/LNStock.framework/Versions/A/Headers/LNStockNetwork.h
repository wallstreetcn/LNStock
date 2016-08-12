//
//  QuotesNetwork.h
//  Market
//
//  Created by vvusu on 5/10/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, StockListType) {
    StockListType_Forex = 0,    //外汇
    StockListType_Commodity,    //商品
    StockListType_Bond,         //债券
    StockListType_Indice,       //股指
    StockListType_Cfdindice     //股指期货
};

typedef NS_ENUM(NSInteger, SortType) {
    SortTypeAscending_pxChangeRate = 0,  //涨跌幅升序
    SortTypeAscending_pxChange,          //涨跌额升序
    SortTypeDescending_pxChangeRate,     //涨跌幅降序
    SortTypeDescending_pxChange          //涨跌额降序
};

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
+ (void)getAstockDataWithStockCode:(NSString *)code adjust:(NSString *)adjust type:(NSString *)type block:(PriceNetworkBlock)block;
#pragma mark - 外汇
//请求外汇K线图数据
+ (void)getBstockDataWithStockCode:(NSString *)code
                              type:(NSString *)type
                               num:(NSInteger)num
                           endTime:(NSString *)endTime
                             block:(PriceNetworkBlock)block;

#pragma mark - RealAPI 行情API
+ (void)getStockRealDataWithCode:(NSString *)code block:(PriceNetworkBlock)block;

#pragma mark - 行情列表
/**
 *  行情列表（沪深)
 *
 *  @param type  排序方式
 *  @param num   数据个数: 该值为非负数。
 *  @param block Block返回数据
 */
+ (void)getAstockListDataWithSortType:(SortType)type
                                  num:(NSInteger)num
                                block:(PriceNetworkBlock)block;


/**
 *  行情列表(外汇、商品、债券、股指、股指期货行)
 *
 *  @param type  外汇数据的类型: forex(外汇)，commodity(商品)，bond(债券)，indice(股指)，cfdindice(股指期货)
 *  @param block Block返回数据
 */
+ (void)getBstockListDataWithType:(StockListType)type block:(PriceNetworkBlock)block;

/**
 *  行情列表(自选，上证指数、深证成指、创业板指)
 *
 *  @param prodCodeArr 存放股票代码的数组，该数组至少有一个元素，股票代码的格式:A股对应 xxxxx.SZ，外汇对应 xxxx
 *  @param block       Block返回数据
 */
+ (void)getStockListDataWithProdCodeArr:(NSArray *)prodCodeArr block:(PriceNetworkBlock)block;

@end
