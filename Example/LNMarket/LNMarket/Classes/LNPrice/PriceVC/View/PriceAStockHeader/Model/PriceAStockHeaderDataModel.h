//
//  PriceAStockHeaderDataModel.h
//  Market
//
//  Created by ZhangBob on 4/22/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PriceResponse)(BOOL isSucceed,id data);
@interface PriceAStockHeaderDataModel : NSObject

//行情数据的命名与恒生接口的Key相匹配，px即为price
@property (nonatomic, copy) NSString *lastPx;           //最新价
@property (nonatomic, copy) NSString *pxChange;         //涨跌额
@property (nonatomic, copy) NSString *pxChangeRate;     //涨跌幅

@property (nonatomic, copy) NSString *openPx;           //今开
@property (nonatomic, copy) NSString *preClosePx;       //昨收
@property (nonatomic, copy) NSString *businessAmount;   //成交量
@property (nonatomic, copy) NSString *turnoverRatio;    //换手率

@property (nonatomic, copy) NSString *highPx;           //最高
@property (nonatomic, copy) NSString *lowPx;            //最低
@property (nonatomic, copy) NSString *peRate;           //市盈率
@property (nonatomic, copy) NSString *amplitude;        //振幅

@property (nonatomic, copy) NSString *businessAmountIn; //内盘
@property (nonatomic, copy) NSString *businessAmountOut;//外盘
@property (nonatomic, copy) NSString *marketValue;      //总市值
@property (nonatomic, copy) NSString *circulationValue; //流通市值

+ (void)getPriceHeaderWithSymbol:(NSString *)symbol PriceResponse:(PriceResponse)priceResponse;

@end
