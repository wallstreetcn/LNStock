//
//  LNStockModel.h
//  LNStock
//
//  Created by vvusu on 9/7/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNStockModel : NSObject <NSCoding>
@property (nonatomic, copy) NSString *prod_name;                //股票名称
@property (nonatomic, copy) NSString *prod_code;                //股票代码
@property (nonatomic, copy) NSString *trade_status;             //交易状态
@property (nonatomic, copy) NSString *hq_type_code;             //证券分类信息
@property (nonatomic, copy) NSNumber *price_precision;          //价格保留几位小数
@property (nonatomic, copy) NSString *market_type;              //数据来源（mdc A股,forexdata 外汇)
@property (nonatomic, copy) NSString *finance_type;             //金融类型(6种：forex,commodity,bond,indice,cfdindice,stock)
@property (nonatomic, copy) NSString *securities_type;          //证券类型 (A股4种,外汇5种)

@property (nonatomic, copy) NSString *stockUrl;                 //股票url(主站 发表话题搜索股票)
@property (nonatomic, copy) NSString *htmlTag;                  //htmlTag(主站 发表话题搜索股票)

@property (nonatomic, strong) NSNumber *last_px;                //最新价
@property (nonatomic, strong) NSNumber *px_change;              //涨跌额
@property (nonatomic, strong) NSNumber *px_change_rate;         //涨跌幅

@property (nonatomic, strong) NSNumber *high_px;                //最高
@property (nonatomic, strong) NSNumber *low_px;                 //最低
@property (nonatomic, strong) NSNumber *open_px;                //开盘价
@property (nonatomic, strong) NSNumber *preclose_px;            //收盘价
@property (nonatomic, strong) NSNumber *amplitude;              //振幅
@property (nonatomic, strong) NSNumber *business_balance;       //成交额
@property (nonatomic, strong) NSNumber *business_amount;        //成交量

@property (nonatomic, strong) NSNumber *dyn_pb_rate;            //市盈率
@property (nonatomic, strong) NSNumber *market_value;           //总市值
@property (nonatomic, strong) NSNumber *turnover_ratio;         //换手率
@property (nonatomic, strong) NSNumber *circulation_value;      //流通市值

@property (nonatomic, strong) NSNumber *bps;                    //每股净资产
@property (nonatomic, strong) NSNumber *pe_rate;                //市盈率
@property (nonatomic, strong) NSNumber *bid_grp;                //买档位
@property (nonatomic, strong) NSNumber *offer_grp;              //卖档位

@property (nonatomic, strong) NSNumber *business_amount_in;     //内盘
@property (nonatomic, strong) NSNumber *business_amount_out;    //外盘

@property (nonatomic, strong) NSNumber *update_time;            //时间撮
@property (nonatomic, strong) NSNumber *buy_px;                 //外汇买入价格
@property (nonatomic, strong) NSNumber *sell_px;                //外汇卖出价格
@property (nonatomic, strong) NSNumber *real_status;            //外汇实时数据
@property (nonatomic, strong) NSNumber *week_52_low;            //外汇52周最低
@property (nonatomic, strong) NSNumber *week_52_high;           //外汇52周最高

- (void)setupWithCode:(NSString *)code dataDic:(NSDictionary *)dataDic;

/**
 *  解析沪深排行榜数据
 *
 *  @param dataDic 沪深数据，服务器返回的数据
 *
 *  @return 返回解析后的数据
 */
+ (NSMutableArray *)parseDataWithDataDic:(NSDictionary *)dataDic;

/**
 *  解析外汇数据
 *
 *  @param dataDic 外汇数据，是服务器返回数据中的snapshot字典
 *
 *  @return 返回数据
 */
+ (NSMutableArray *)parseForexDataWithDataDic:(NSDictionary *)dataDic;

/**
 *  解析自选返回数据
 *
 *  @param dataDic     服务器返回数据
 *  @param prodCodeArr 用户自选列表（主要是取该列表的顺序）
 *
 *  @return 以数组的形式返回数据，数组中元素的顺序和prodCodeArr的顺序一致
 */
+ (NSMutableArray *)parseForexDataWithDataDic:(NSDictionary *)dataDic prodCodeArr:(NSArray *)prodCodeArr;
@end
