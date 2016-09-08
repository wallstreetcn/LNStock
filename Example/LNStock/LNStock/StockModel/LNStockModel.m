//
//  LNStockModel.m
//  LNStock
//
//  Created by vvusu on 9/7/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockModel.h"
#import "LNStockHandler.h"

@implementation LNStockModel

- (void)setupWithCode:(NSString *)code dataDic:(NSDictionary *)dataDic {
    //解析
    NSDictionary *data = [dataDic valueForKey:@"data"];
    NSDictionary *stockDic = [data valueForKey:@"snapshot"];
    
    NSArray *fieldsArray = [stockDic valueForKey:@"fields"];
    NSArray *dataArray = [stockDic valueForKey:code];
    
    NSInteger lastPxIndex = [fieldsArray indexOfObject:@"last_px"];
    if (lastPxIndex < fieldsArray.count) {
        self.last_px = [dataArray objectAtIndex:lastPxIndex];
    }
    
    NSInteger pxChangeIndex = [fieldsArray indexOfObject:@"px_change"];
    if (pxChangeIndex < fieldsArray.count) {
        self.px_change = [dataArray objectAtIndex:pxChangeIndex];
    }
    
    NSInteger pxChangeRateIndex = [fieldsArray indexOfObject:@"px_change_rate"];
    if (pxChangeRateIndex < fieldsArray.count) {
        self.px_change_rate = [dataArray objectAtIndex:pxChangeRateIndex];
    }
    
    NSInteger openPxIndex = [fieldsArray indexOfObject:@"open_px"];
    if (openPxIndex < fieldsArray.count) {
        self.open_px = [dataArray objectAtIndex:openPxIndex];
    }
    
    NSInteger preClosePxIndex = [fieldsArray indexOfObject:@"preclose_px"];
    if (preClosePxIndex < fieldsArray.count) {
        self.preclose_px = [dataArray objectAtIndex:preClosePxIndex];
    }
    
    NSInteger businessAmountIndex = [fieldsArray indexOfObject:@"business_amount"];
    if (businessAmountIndex < fieldsArray.count) {
        self.business_amount = [dataArray objectAtIndex:businessAmountIndex];
    }
    
    NSInteger turnoverRatioIndex = [fieldsArray indexOfObject:@"turnover_ratio"];
    if (turnoverRatioIndex < fieldsArray.count) {
        self.turnover_ratio = [dataArray objectAtIndex:turnoverRatioIndex];
    }
    
    NSInteger highPxIndex = [fieldsArray indexOfObject:@"high_px"];
    if (highPxIndex < fieldsArray.count) {
        self.high_px = [dataArray objectAtIndex:highPxIndex];
    }
    
    NSInteger lowPxIndex = [fieldsArray indexOfObject:@"low_px"];
    if (lowPxIndex < fieldsArray.count) {
        self.low_px = [dataArray objectAtIndex:lowPxIndex];
    }
    
    NSInteger peRateIndex = [fieldsArray indexOfObject:@"pe_rate"];
    if (peRateIndex < fieldsArray.count) {
        self.pe_rate = [dataArray objectAtIndex:peRateIndex];
    }
    
    NSInteger amplitudeIndex = [fieldsArray indexOfObject:@"amplitude"];
    if (amplitudeIndex < fieldsArray.count) {
        self.amplitude = [dataArray objectAtIndex:amplitudeIndex];
    }
    
    NSInteger businessAmountInIndex = [fieldsArray indexOfObject:@"business_amount_in"];
    if (businessAmountInIndex < fieldsArray.count) {
        self.business_amount_in = [dataArray objectAtIndex:businessAmountInIndex];
    }
    
    NSInteger businessAmountOutIndex = [fieldsArray indexOfObject:@"business_amount_out"];
    if (businessAmountOutIndex < fieldsArray.count) {
        self.business_amount_out = [dataArray objectAtIndex:businessAmountOutIndex];
    }
    
    NSInteger marketValueIndex = [fieldsArray indexOfObject:@"market_value"];
    if (marketValueIndex < fieldsArray.count) {
        self.market_value = [dataArray objectAtIndex:marketValueIndex];
    }
    
    NSInteger circulationValueIndex = [fieldsArray indexOfObject:@"circulation_value"];
    if (circulationValueIndex < fieldsArray.count) {
        self.circulation_value = [dataArray objectAtIndex:circulationValueIndex];
    }
    
    //名字
    NSInteger nameIndex = [fieldsArray indexOfObject:@"prod_name"];
    if (nameIndex < fieldsArray.count) {
        self.prod_name = [dataArray objectAtIndex:nameIndex];
    }
    
    //价格保留小数位数
    NSInteger price_precisionIndex = [fieldsArray indexOfObject:@"price_precision"];
    if (price_precisionIndex < fieldsArray.count) {
        self.price_precision = [dataArray objectAtIndex:price_precisionIndex];
        [LNStockHandler sharedManager].price_precision = self.price_precision;
    }
    
    //股票面板选择
    NSInteger marketTypeIndex = [fieldsArray indexOfObject:@"market_type"];
    if (marketTypeIndex < fieldsArray.count) {
        self.market_type = [dataArray objectAtIndex:marketTypeIndex];
    }
    
    //股票类型
    NSInteger securitiesTypeIndex = [fieldsArray indexOfObject:@"securities_type"];
    if (securitiesTypeIndex < fieldsArray.count) {
        self.securities_type = [dataArray objectAtIndex:securitiesTypeIndex];
    }
    
    //股票类型 （以后不需要）
    NSInteger securities_typeIndex = [fieldsArray indexOfObject:@"securities_type"];
    if (securities_typeIndex < fieldsArray.count) {
        self.securities_type = [dataArray objectAtIndex:securities_typeIndex];
        [LNStockHandler sharedManager].stocktype = self.securities_type;
    }
    
    //交易状态
    NSInteger tradeStatusValueIndex = [fieldsArray indexOfObject:@"trade_status"];
    if (tradeStatusValueIndex < fieldsArray.count) {
        self.trade_status = [dataArray objectAtIndex:tradeStatusValueIndex];
        [LNStockHandler sharedManager].tradeStatus = self.trade_status;
    }
    
    //外汇
    //买入价格
    NSInteger buy_pxIndex = [fieldsArray indexOfObject:@"buy"];
    if (buy_pxIndex < fieldsArray.count) {
        self.buy_px = [dataArray objectAtIndex:buy_pxIndex];
    }
    
    //卖出价格
    NSInteger sell_pxIndex = [fieldsArray indexOfObject:@"sell"];
    if (sell_pxIndex < fieldsArray.count) {
        self.sell_px = [dataArray objectAtIndex:sell_pxIndex];
    }
    
    NSInteger update_timeIndex = [fieldsArray indexOfObject:@"update_time"];
    if (update_timeIndex < fieldsArray.count) {
        self.update_time = [dataArray objectAtIndex:update_timeIndex];
    }
    
    NSInteger real_statusIndex = [fieldsArray indexOfObject:@"real_status"];
    if (real_statusIndex < fieldsArray.count) {
        self.real_status = [dataArray objectAtIndex:real_statusIndex];
    }
    
    NSInteger week52_lowIndex = [fieldsArray indexOfObject:@"week_52_low"];
    if (week52_lowIndex < fieldsArray.count) {
        self.week_52_low = [dataArray objectAtIndex:week52_lowIndex];
    }
    
    NSInteger week52_highIndex = [fieldsArray indexOfObject:@"week_52_high"];
    if (week52_highIndex < fieldsArray.count) {
        self.week_52_high = [dataArray objectAtIndex:week52_highIndex];
    }
}

+ (NSMutableArray *)parseDataWithDataDic:(NSDictionary *)dataDic {
    NSDictionary *stockDic = dataDic;
    
    NSArray *fieldsArray = [stockDic valueForKey:@"fields"];
    
    NSMutableArray *returnArray = [NSMutableArray array];
    NSArray *allKeys = [stockDic allKeys];
    for (NSInteger i = 0; i< allKeys.count; i++) {
        NSString *key = allKeys[i];
        if ([key isEqualToString:@"fields"]) {
            continue;
        }
        NSArray *dataArray = [stockDic valueForKey:key];
        NSDictionary *snapshot = [NSDictionary dictionaryWithObjectsAndKeys:dataArray, key, fieldsArray, @"fields", nil];
        NSDictionary *snapshotDic = [NSDictionary dictionaryWithObject:snapshot forKey:@"snapshot"];
        NSDictionary *dataDic = [NSDictionary dictionaryWithObject:snapshotDic forKey:@"data"];
        LNStockModel *model = [[LNStockModel alloc]init];
        [model setupWithCode:key dataDic:dataDic];
        model.prod_code = key;
        //沪深排行的所有股票均为A股
        model.market_type = @"mdc";
        [returnArray addObject:model];
    }
    
    return returnArray;
}

/**
 *  解析外汇数据
 *
 *  @param dataDic 外汇数据，是服务器返回数据中的snapshot字典
 *
 *  @return 返回数据
 */
+ (NSMutableArray *)parseForexDataWithDataDic:(NSDictionary *)dataDic {
    //数据
    NSArray *dataArray = [dataDic valueForKey:@"data_arrs"];
    //字段
    NSArray *fieldsArray = [dataDic valueForKey:@"fields"];
    NSMutableArray *returnArray = [NSMutableArray array];
    for (NSInteger i = 0; i < dataArray.count; i++) {
        NSDictionary *item = dataArray[i];
        NSArray *keys = [item allKeys];
        NSArray *data = [item valueForKey:keys.firstObject];
        NSDictionary *snapshot = [NSDictionary dictionaryWithObjectsAndKeys:data, keys.firstObject, fieldsArray, @"fields", nil];
        NSDictionary *snapshotDic = [NSDictionary dictionaryWithObject:snapshot forKey:@"snapshot"];
        NSDictionary *dataDic = [NSDictionary dictionaryWithObject:snapshotDic forKey:@"data"];
        
        LNStockModel *model = [[LNStockModel alloc]init];
        [model setupWithCode:keys.firstObject dataDic:dataDic];
        model.prod_code = keys.firstObject;
        
        [returnArray addObject:model];
    }
    return returnArray;
}

/**
 *  解析自选返回数据
 *
 *  @param dataDic     服务器返回数据
 *  @param prodCodeArr 用户自选列表（主要是取该列表的顺序）
 *
 *  @return 以数组的形式返回数据，数组中元素的顺序和prodCodeArr的顺序一致
 */
+ (NSMutableArray *)parseForexDataWithDataDic:(NSDictionary *)dataDic prodCodeArr:(NSArray *)prodCodeArr {
    NSDictionary *stockDic = [dataDic valueForKey:@"snapshot"];
    NSArray *fieldsArray = [stockDic valueForKey:@"fields"];
    
    NSMutableArray *returnArray = [NSMutableArray array];
    for (NSInteger i = 0; i < prodCodeArr.count; i++) {
        NSString *prodCode = prodCodeArr[i];
        NSArray *dataArray = [stockDic valueForKey:prodCode];
        if (!dataArray) {
            continue;
        }
        
        NSDictionary *snapshot = [NSDictionary dictionaryWithObjectsAndKeys:dataArray, prodCode, fieldsArray, @"fields", nil];
        NSDictionary *snapshotDic = [NSDictionary dictionaryWithObject:snapshot forKey:@"snapshot"];
        NSDictionary *dataDic = [NSDictionary dictionaryWithObject:snapshotDic forKey:@"data"];
        
        LNStockModel *model = [[LNStockModel alloc]init];
        [model setupWithCode:prodCode dataDic:dataDic];
        model.prod_code = prodCode;
        
        [returnArray addObject:model];
    }
    return returnArray;
}

/**
 *  将对象写入文件的时候调用
 *  在这个方法中写清楚：要存储哪些对象的哪些属性，以及怎样存储属性
 */
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.prod_name forKey:@"prod_name"];
    [aCoder encodeObject:self.prod_code forKey:@"prod_code"];
    [aCoder encodeObject:self.trade_status forKey:@"trade_status"];
    [aCoder encodeObject:self.hq_type_code forKey:@"hq_type_code"];
    [aCoder encodeObject:self.price_precision forKey:@"price_precision"];
    [aCoder encodeObject:self.market_type forKey:@"market_type"];
    [aCoder encodeObject:self.securities_type forKey:@"securities_type"];
    
    [aCoder encodeObject:self.last_px forKey:@"last_px"];
    [aCoder encodeObject:self.px_change forKey:@"px_change"];
    [aCoder encodeObject:self.px_change_rate forKey:@"px_change_rate"];
    
    [aCoder encodeObject:self.high_px forKey:@"high_px"];
    [aCoder encodeObject:self.low_px forKey:@"low_px"];
    [aCoder encodeObject:self.open_px forKey:@"open_px"];
    [aCoder encodeObject:self.preclose_px forKey:@"preclose_px"];
    [aCoder encodeObject:self.amplitude forKey:@"amplitude"];
    [aCoder encodeObject:self.business_balance forKey:@"business_balance"];
    [aCoder encodeObject:self.business_amount forKey:@"business_amount"];
    
    [aCoder encodeObject:self.dyn_pb_rate forKey:@"dyn_pb_rate"];
    [aCoder encodeObject:self.market_value forKey:@"market_value"];
    [aCoder encodeObject:self.turnover_ratio forKey:@"turnover_ratio"];
    [aCoder encodeObject:self.circulation_value forKey:@"circulation_value"];
    
    [aCoder encodeObject:self.bps forKey:@"bps"];
    [aCoder encodeObject:self.pe_rate forKey:@"pe_rate"];
    [aCoder encodeObject:self.bid_grp forKey:@"bid_grp"];
    [aCoder encodeObject:self.offer_grp forKey:@"offer_grp"];
    
    [aCoder encodeObject:self.business_amount_in forKey:@"business_amount_in"];
    [aCoder encodeObject:self.business_amount_out forKey:@"business_amount_out"];
    
    [aCoder encodeObject:self.buy_px forKey:@"buy_px"];
    [aCoder encodeObject:self.sell_px forKey:@"sell_px"];
    [aCoder encodeObject:self.update_time forKey:@"update_time"];
    [aCoder encodeObject:self.real_status forKey:@"real_status"];
    [aCoder encodeObject:self.week_52_low forKey:@"week_52_low"];
    [aCoder encodeObject:self.week_52_high forKey:@"week_52_high"];
}

/**
 *  当从文件中解析出一个对象的时候调用
 *  在这个方法中写清楚：怎么解析文件中的数据
 */
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.prod_name = [aDecoder decodeObjectForKey:@"prod_name"];
        self.prod_code = [aDecoder decodeObjectForKey:@"prod_code"];
        self.trade_status = [aDecoder decodeObjectForKey:@"trade_status"];
        self.hq_type_code = [aDecoder decodeObjectForKey:@"hq_type_code"];
        self.price_precision = [aDecoder decodeObjectForKey:@"price_precision"];
        self.market_type = [aDecoder decodeObjectForKey:@"market_type"];
        self.securities_type = [aDecoder decodeObjectForKey:@"securities_type"];
        
        self.last_px = [aDecoder decodeObjectForKey:@"last_px"];
        self.px_change = [aDecoder decodeObjectForKey:@"px_change"];
        self.px_change_rate = [aDecoder decodeObjectForKey:@"px_change_rate"];
        
        self.high_px = [aDecoder decodeObjectForKey:@"high_px"];
        self.low_px = [aDecoder decodeObjectForKey:@"low_px"];
        self.open_px = [aDecoder decodeObjectForKey:@"open_px"];
        self.preclose_px = [aDecoder decodeObjectForKey:@"preclose_px"];
        self.amplitude = [aDecoder decodeObjectForKey:@"amplitude"];
        self.business_balance = [aDecoder decodeObjectForKey:@"business_balance"];
        self.business_amount = [aDecoder decodeObjectForKey:@"business_amount"];
        
        self.dyn_pb_rate = [aDecoder decodeObjectForKey:@"dyn_pb_rate"];
        self.market_value = [aDecoder decodeObjectForKey:@"market_value"];
        self.turnover_ratio = [aDecoder decodeObjectForKey:@"turnover_ratio"];
        self.circulation_value = [aDecoder decodeObjectForKey:@"circulation_value"];
        
        self.bps = [aDecoder decodeObjectForKey:@"bps"];
        self.pe_rate = [aDecoder decodeObjectForKey:@"pe_rate"];
        self.bid_grp = [aDecoder decodeObjectForKey:@"bid_grp"];
        self.offer_grp = [aDecoder decodeObjectForKey:@"offer_grp"];
        
        self.business_amount_in = [aDecoder decodeObjectForKey:@"business_amount_in"];
        self.business_amount_out = [aDecoder decodeObjectForKey:@"business_amount_out"];
        
        self.buy_px = [aDecoder decodeObjectForKey:@"buy_px"];
        self.sell_px = [aDecoder decodeObjectForKey:@"sell_px"];
        self.update_time = [aDecoder decodeObjectForKey:@"update_time"];
        self.real_status = [aDecoder decodeObjectForKey:@"real_status"];
        self.week_52_low = [aDecoder decodeObjectForKey:@"week_52_low"];
        self.week_52_high = [aDecoder decodeObjectForKey:@"week_52_high"];
    }
    return self;
}

@end
