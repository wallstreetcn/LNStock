//
//  LNPriceModel.h
//  LNStock
//
//  Created by vvusu on 6/7/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNPriceModel : NSObject <NSCoding>
@property (nonatomic, copy) NSString *prod_name;                //股票名称
@property (nonatomic, copy) NSString *prod_code;                //股票代码
@property (nonatomic, copy) NSString *trade_status;             //交易状态
@property (nonatomic, copy) NSString *hq_type_code;             //证券分类信息
@property (nonatomic, copy) NSString *securities_type;          //证券类型
@property (nonatomic, copy) NSNumber *price_precision;          //价格保留几位小数

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

@property (nonatomic, strong) NSNumber *buy_px;                 //外汇买入价格
@property (nonatomic, strong) NSNumber *sell_px;                //外汇卖出价格
@property (nonatomic, strong) NSNumber *update_time;            //外汇时间撮
@property (nonatomic, strong) NSNumber *real_status;            //外汇实时数据
@property (nonatomic, strong) NSNumber *week_52_low;            //外汇52周最低
@property (nonatomic, strong) NSNumber *week_52_high;           //外汇52周最高

- (void)setupWithCode:(NSString *)code dataDic:(NSDictionary *)dataDic;
+ (NSMutableArray *)parseDataWithDataDic:(NSDictionary *)dataDic;
@end

/*
 prod_name	股票名称
 prod_code  股票代码
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
 business_amount_in	内盘
 business_amount_out	外盘
 circulation_value	流通市值
 securities_type	证券类型
 
 buy  外汇买入价格
 sell 外汇卖出价格
 update_time  跟新时间
 real_status  实时数据
 */