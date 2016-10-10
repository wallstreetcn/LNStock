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
+ (void)getStockMinuteDataWithStockCode:(NSString *)code
                                  block:(PriceNetworkBlock)block;

//请求分时买卖五档数据
+ (void)getDealListDataWithStockCode:(NSString *)code
                               block:(PriceNetworkBlock)block;

//请求A股五日数据
+ (void)getAstockFiveDaysDataWithStockCode:(NSString *)code
                                     block:(PriceNetworkBlock)block;

//请求A股K线图数据
+ (void)getAstockDataWithStockCode:(NSString *)code
                            adjust:(NSString *)adjust
                              type:(NSString *)type
                               num:(NSString *)num
                           endTime:(NSString *)endTime
                             block:(PriceNetworkBlock)block;
#pragma mark - 外汇
//请求外汇K线图数据
+ (void)getBstockDataWithStockCode:(NSString *)code
                              type:(NSString *)type
                               num:(NSInteger)num
                           endTime:(NSString *)endTime
                             block:(PriceNetworkBlock)block;

#pragma mark - RealAPI 行情API
+ (void)getStockRealDataWithCode:(NSString *)code isAstock:(BOOL)isAstock block:(PriceNetworkBlock)block;

#pragma mark - 行情列表
/**
 *  行情列表（沪深)
 *
 *  @param type  排序方式，目前仅支持对涨跌幅进行排序pxChangeRate
 *  @param num   数据个数: 该值为非负数。
 *  @param block 返回数据 如果isSuccess=YES, response的数据类型一定是NSArray，数组中的每一个元素都是LNStockModel，以下数据有值：prod_name,prod_code,last_px,px_change,px_change_rate,high_px,low_px,price_precision,finance_type,securities_type,market_type；isSUccess=NO，response为String型，失败提示信息。
 */
+ (void)getAstockListDataWithSortType:(SortType)type
                                  num:(NSInteger)num
                                block:(PriceNetworkBlock)block;


/**
 *  行情列表(外汇、商品、债券、股指、股指期货)
 *
 *  @param type  外汇数据的类型: forex(外汇)，commodity(商品)，bond(债券)，indice(股指)，cfdindice(股指期货)
 *  @param block 返回数据 如果isSuccess=YES, response的数据类型一定是NSArray，数组中的每一个元素都是LNStockModel，以下数据有值：prod_name,prod_code,last_px,px_change,px_change_rate,high_px,low_px,price_precision,finance_type,securities_type,market_type；isSuccess=NO，response为String型，失败提示信息。
 */
+ (void)getBstockListDataWithType:(StockListType)type
                            block:(PriceNetworkBlock)block;

/**
 *  行情列表(自选，上证指数、深证成指、创业板指)
 *
 *  @param prodCodeArr 存放股票代码的数组，该数组至少有一个元素，股票代码的格式:A股对应 xxxxx.SZ，外汇对应 xxxx
 *  @param block       返回数据 如果isSuccess=YES, response的数据类型一定是NSArray，数组中的每一个元素都是LNStockModel，以下数据有值：prod_name,prod_code,last_px,px_change,px_change_rate,high_px,low_px,price_precision,finance_type,securities_type,market_type；isSuccess=NO，response为String型，失败提示信息。
 */
+ (void)getStockListDataWithProdCodeArr:(NSArray *)prodCodeArr
                                  block:(PriceNetworkBlock)block;

/**
 *  搜索列表
 *
 *  @param content 搜索的内容，NSString型
 *  @param num     返回结果的数量，NSInteger型
 *  @param block   返回数据 如果isSuccess=YES, response的数据类型一定是NSArray，数组中的每一个元素都是LNStockModel，以下数据有值：prod_name,prod_code,price_precision,finance_type,securities_type,market_type；isSuccess=NO，response为String型，失败提示信息。
 */
+ (void)getStockSearchListWithContent:(NSString *)content
                                  num:(NSString *)num
                                block:(PriceNetworkBlock)block;

@end
