//
//  LNRealModel.m
//  LNStock
//
//  Created by vvusu on 6/2/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNRealModel.h"
#import "LNStockHandler.h"
#import "LNStockFormatter.h"

@implementation LNRealModel

+ (NSMutableArray *)AnalyticalData:(NSString *)code Dic:(NSDictionary *)dataDic {
    NSMutableArray *dataArr = [NSMutableArray array];
    
    NSDictionary *data = [dataDic valueForKey:@"data"];
    NSDictionary* candleInfo = [data valueForKey:@"candle"];
    NSArray* fields = [candleInfo valueForKey:@"fields"];
    NSDateFormatter* dateFormat = [LNStockFormatter sharedInstanceFormatter];
    dateFormat.dateFormat = @"yyyyMMdd";
    switch ([LNStockHandler titleType]) {
        case LNChartTitleType_5m:
        case LNChartTitleType_15m:
        case LNChartTitleType_30m:
        case LNChartTitleType_1H:
            dateFormat.dateFormat = @"yyyyMMddHHmm";
            break;
        default:
            break;
    }
    NSInteger openIndex = [fields indexOfObject:@"open_px"];
    NSInteger highIndex = [fields indexOfObject:@"high_px"];
    NSInteger lowIndex = [fields indexOfObject:@"low_px"];
    NSInteger closeIndex = [fields indexOfObject:@"close_px"];
    
    NSInteger minTimeIndex = [fields indexOfObject:@"min_time"];
    
    //MA
    NSInteger MA1Index = [fields indexOfObject:@"MA5"];
    NSInteger MA2Index = [fields indexOfObject:@"MA10"];
    NSInteger MA3Index = [fields indexOfObject:@"MA20"];
    
    //交易量
    NSInteger businessAmountIndex = [fields indexOfObject:@"business_amount"];
    
    //MACD
    NSInteger DIFIndex = [fields indexOfObject:@"dif"];
    NSInteger DEAIndex = [fields indexOfObject:@"dea"];
    NSInteger MACDIndex = [fields indexOfObject:@"macd"];
    
    //BOLL
    NSInteger MIDIndex = [fields indexOfObject:@"mid"];
    NSInteger UPPERIndex = [fields indexOfObject:@"upper"];
    NSInteger LOWERIndex = [fields indexOfObject:@"lower"];
    
    //KDJ
    NSInteger KIndex = [fields indexOfObject:@"k"];
    NSInteger DIndex = [fields indexOfObject:@"d"];
    NSInteger JIndex = [fields indexOfObject:@"j"];
    
    //RSI
    NSInteger RSI6Index = [fields indexOfObject:@"rsi6"];
    NSInteger RSI12Index = [fields indexOfObject:@"rsi12"];
    NSInteger RSI24Index = [fields indexOfObject:@"rsi24"];
    
    //OBV
    NSInteger OBVIndex = [fields indexOfObject:@"obv"];
    
    NSArray* kLineItems = [candleInfo valueForKey:code];
    for (NSArray* kLineItem in kLineItems){
        LNRealModel* data = [[LNRealModel alloc] init];
        data.open = kLineItem[openIndex];
        data.close = kLineItem[closeIndex];
        data.high = kLineItem[highIndex];
        data.low = kLineItem[lowIndex];
        NSString* dateString = [NSString stringWithFormat:@"%@", kLineItem[minTimeIndex]];
        data.date = [dateFormat dateFromString:dateString];
        
        data.MA1 = kLineItem[MA1Index];
        data.MA2 = kLineItem[MA2Index];
        data.MA3 = kLineItem[MA3Index];
        
        switch ([LNStockHandler factorType]) {
            case LNStockFactorType_Volume:
                if (businessAmountIndex < kLineItem.count) {
                    data.volume = kLineItem[businessAmountIndex];
                }
                break;
            case LNStockFactorType_MACD:
                if (DIFIndex < kLineItem.count && DEAIndex < kLineItem.count && MACDIndex < kLineItem.count) {
                    data.diff = kLineItem[DIFIndex];
                    data.dea = kLineItem[DEAIndex];
                    data.macd = kLineItem[MACDIndex];
                }
                break;
            case LNStockFactorType_BOLL:
                if (MIDIndex < kLineItem.count && UPPERIndex < kLineItem.count && LOWERIndex < kLineItem.count) {
                    data.mid = kLineItem[MIDIndex];
                    data.upper = kLineItem[UPPERIndex];
                    data.lower = kLineItem[LOWERIndex];
                }
                break;
            case LNStockFactorType_KDJ:
                if (KIndex < kLineItem.count && DIndex < kLineItem.count && JIndex < kLineItem.count) {
                    data.kdj_k = kLineItem[KIndex];
                    data.kdj_d = kLineItem[DIndex];
                    data.kdj_j = kLineItem[JIndex];
                }
                break;
            case LNStockFactorType_RSI:
                if (RSI6Index < kLineItem.count && RSI12Index < kLineItem.count && RSI24Index < kLineItem.count) {
                    data.rsi_6 = kLineItem[RSI6Index];
                    data.rsi_12 = kLineItem[RSI12Index];
                    data.rsi_24 = kLineItem[RSI24Index];
                }
                break;
            case LNStockFactorType_OBV:
                if (OBVIndex < kLineItem.count) {
                    data.obv = kLineItem[OBVIndex];
                }
                break;
            default:
                break;
        }
        [dataArr addObject:data];
    }
    return dataArr;
}

@end
