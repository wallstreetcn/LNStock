//
//  KLineDataModel.h
//  Market
//
//  Created by vvusu on 4/26/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLineDataModel : NSObject

@property (nonatomic, strong) NSDate *date;             //日期
@property (nonatomic, strong) NSNumber *open;           //开盘价
@property (nonatomic, strong) NSNumber *close;          //收盘价
@property (nonatomic, strong) NSNumber *high;           //最高价
@property (nonatomic, strong) NSNumber *low;            //最低价
@property (nonatomic, strong) NSNumber *price;          //价格
@property (nonatomic, strong) NSNumber *averagePrice;   //平均价
@property (nonatomic, strong) NSNumber *volume;         //成交量 = 返回数据中的business_amount
@property (nonatomic, strong) NSNumber *preClosePx;     //昨收价格
@property (nonatomic, copy) NSString *startFormatted;   //开始日期（yyyy-MM-DD HH:MM）外汇独有
@property (nonatomic, copy) NSString *endFormatted;     //结束日期（yyyy-MM-DD HH:MM）外汇独有

@end

