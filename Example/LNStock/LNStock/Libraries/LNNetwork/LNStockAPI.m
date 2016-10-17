//
//  LNStockAPI.m
//  LNStock
//
//  Created by vvusu on 6/2/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockAPI.h"

@implementation LNStockAPI

#pragma mark - AStock
//http://mdc_test.wallstreetcn.com
NSString *const KIAStockAPI = @"http://mdc.wallstreetcn.com";
NSString *const KIAStockTestAPI = @"http://101.69.181.106:8080";

//行情搜索 （A股 和 外汇）
NSString *const KIAStockSearchAPI = @"/finance_search/?";

//A股分时数据
NSString *const KIAStockTrendAPI = @"/trend?prod_code=symbol&fields=last_px,avg_px,business_amount,business_balance";

//A股分时交易数据 （五档）
NSString *const KIAStockPriceAPI = @"/real?en_prod_code=symbol&";

//A股五日数据
NSString *const KIAStockTrend5DayAPI = @"/trend5day?prod_code=symbol";

//A股K线数据
NSString *const KIAStockKLineAPI = @"/kline?prod_code=symbol";

//默认K线Fields
NSString *const KIAStockKLineFields = @"min_time,open_px,close_px,high_px,low_px,ma5,ma10,ma20";

//MA
NSString *const KIAStockMAFields = @"ma5,ma10,ma20";

//交易量
NSString *const KIAStockAmountFields = @"business_amount";

//MACD
NSString *const KIAStocMACDFields = @"macd,dea,dif";

//BOLL
NSString *const KIAStocBOLLFields = @"mid,upper,lower";

//KDJ
NSString *const KIAStocKDJFields = @"k,d,j";

//RSI
NSString *const KIAStocRSIFields = @"rsi6,rsi12,rsi24";

//OBV
NSString *const KIAStocOBVFields = @"obv";

//行情列表(沪深)
NSString *const KIAStockListAPI = @"/sort?";

//行情列表(沪深)Fields
NSString *const KIAStockListFields = @"prod_name,last_px,px_change_rate,px_change,high_px,low_px,high_price,low_price,price_precision,market_type,securities_type";

/*
 min_time	时间戳
 open_px	开盘价
 close_px	收盘价
 high_px	最高价
 low_px	最低价
 business_amount	成交量
 business_balance	成交额
 */

/* MA均值
 ma5	5日/周/月移动平均线
 ma10	10日/周/月移动平均线
 mac20  20日/周/月移动平均线
 */

//股票行情数据 （返回一直或多只股票行情报价） en_prod_code  fields   format
NSString *const KIStockRealAPI = @"/real?";
//默认行情面板Fields
NSString *const KIAStockRealFields = @"prod_name,last_px,px_change,px_change_rate,open_px,preclose_px,business_amount,turnover_ratio,high_px,low_px,pe_rate,amplitude,business_amount_in,business_amount_out,market_value,circulation_value,trade_status,securities_type,price_precision";
/*
 字段名	含义
 prod_name	股票名称
 last_px	最新价
 px_change	涨跌额
 px_change_rate	涨跌幅
 high_px	最高价
 low_px	最低价
 open_px	开盘价
 preclose_px	昨收价
 business_amount	成交量
 business_balance	成交额
 market_value	总市值
 turnover_ratio	换手率
 dyn_pb_rate	市净率
 amplitude	振幅
 pe_rate	市盈率
 bps	每股净资产
 hq_type_code	证券分类信息
 trade_status	交易状态
 bid_grp	买档位
 offer_grp	卖档位
 business_amount_in	内盘
 business_amount_out	外盘
 circulation_value	流通市值
 securities_type	证券类型
 price_precision	客户端价格显示精度，值表示小数点后显示几位
*/


#pragma mark - BStock

NSString *const KIBStockAPI = @"https://forexdata.wallstreetcn.com";
NSString *const KIBStockTestAPI = @"http://139.196.20.6:8083";

//外汇行情面板Fields
NSString *const KIBStockRealFields = @"prod_name,last_px,px_change,px_change_rate,high_px,low_px,open_px,preclose_px,buy,sell,business_amount,update_time,trade_status,week_52_low,week_52_high,price_precision";

//外汇交易数据
NSString *const KIBStockPriceAPI = @"/real?";

//B股K线数据
NSString *const KIBStockKLineAPI = @"/kline?";

//行情列表(外汇)
NSString *const KIBStockListAPI = @"/real_list?";

//行情列表(外汇)Fields
NSString *const KIBStockListFields = @"prod_name,last_px,px_change_rate,px_change,high_px,low_px,price_precision,market_type,securities_type";



#pragma mark - 恒生API

NSString *const KIHSAPI = @"http://open.hs.net";
NSString *const KIHSTestAPI = @"http://open.hs.net";

//恒生AccessTokenUrl
NSString *const KIHSTokenAPI = @"https://api.wallstreetcn.com/v2/itn/token/public";
//恒生
NSString *const KIHSFullFieldsAPI = @"fields=last_px,px_change,px_change_rate,open_px,preclose_px,business_amount,turnover_ratio,high_px,low_px,pe_rate,amplitude,business_amount_in,business_amount_out,market_value,circulation_value";

@end
