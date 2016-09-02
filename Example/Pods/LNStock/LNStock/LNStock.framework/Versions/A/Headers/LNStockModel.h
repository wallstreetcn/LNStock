//
//  LNStockModel.h
//  LNStock
//
//  Created by vvusu on 6/2/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNStockModel : NSObject
//KLine
@property (nonatomic, strong) NSNumber *open;           //开盘价
@property (nonatomic, strong) NSNumber *close;          //收盘价
@property (nonatomic, strong) NSNumber *high;           //最高价
@property (nonatomic, strong) NSNumber *low;            //最低价
//MA
@property (nonatomic, strong) NSNumber *MA1;            //MA1
@property (nonatomic, strong) NSNumber *MA2;            //MA2
@property (nonatomic, strong) NSNumber *MA3;            //MA3
@property (nonatomic, strong) NSNumber *MA4;            //MA4
@property (nonatomic, strong) NSNumber *MA5;            //MA5
//Price
@property (nonatomic, strong) NSNumber *price;          //价格
@property (nonatomic, strong) NSNumber *preClosePx;     //昨收价格
@property (nonatomic, strong) NSNumber *averagePrice;   //平均价
@property (nonatomic, strong) NSDate *date;             //日期
//交易量
@property (nonatomic, strong) NSNumber *volume;
//MACD
@property (nonatomic, strong) NSNumber *macd;
@property (nonatomic, strong) NSNumber *diff;
@property (nonatomic, strong) NSNumber *dea;
//BOLL
@property (nonatomic, strong) NSNumber *mid;
@property (nonatomic, strong) NSNumber *upper;
@property (nonatomic, strong) NSNumber *lower;
//KDJ
@property (nonatomic, strong) NSNumber *kdj_k;
@property (nonatomic, strong) NSNumber *kdj_d;
@property (nonatomic, strong) NSNumber *kdj_j;
//RSI
@property (nonatomic, strong) NSNumber *rsi_6;
@property (nonatomic, strong) NSNumber *rsi_12;
@property (nonatomic, strong) NSNumber *rsi_24;
//OBV
@property (nonatomic, strong) NSNumber *obv;

+ (NSMutableArray *)AnalyticalData:(NSString *)code Dic:(NSDictionary *)dataDic;
@end
