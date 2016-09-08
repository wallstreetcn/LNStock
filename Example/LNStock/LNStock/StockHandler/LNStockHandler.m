//
//  QuoteHandler.m
//  Market
//
//  Created by ZhangBob on 5/6/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockHandler.h"
#import "LNStockColor.h"

@implementation LNStockHandler

+ (LNStockHandler *)sharedManager {
    static LNStockHandler *stockHandler = nil;
    static dispatch_once_t onceQuoteHandler;
    dispatch_once(&onceQuoteHandler, ^{
        stockHandler = [[LNStockHandler alloc]init];
        stockHandler.verticalScreen = YES;
        stockHandler.tradeStatus = @"TRADE";
    });
    return stockHandler;
}

+ (void)resetData {
    [LNStockHandler sharedManager].verticalScreen = YES;
    [LNStockHandler sharedManager].stocktype = @"";
    [LNStockHandler sharedManager].tradeStatus = @"TRADE";
    [LNStockHandler sharedManager].titleType = LNChartTitleType_1m;
    [LNStockHandler sharedManager].chartType = LNStockChartType_Candles;
}

- (void)setNightMode:(BOOL)nightMode {
    _nightMode = nightMode;
    [[LNStockColor manager] getStockColors];
}

+ (NSString *)code {
    return [LNStockHandler sharedManager].code;
}

//股票状态
+ (NSString *)tradeStatus {
    return [LNStockHandler sharedManager].tradeStatus;
}

//价格保留位数
+ (NSString *)price_precision {
    NSString *precision = [LNStockHandler sharedManager].price_precision.stringValue;
    if (!precision) {
        precision = @"2";
    }
    NSMutableString *type = [@"%.lf" mutableCopy];
    [type insertString:precision atIndex:2];
    return type;
}

+ (NSString *)tradeStatusContents {
    if ([[LNStockHandler sharedManager].tradeStatus isEqualToString:@"TRADE"]) {
        return @"交易中";
    }
    else if ([[LNStockHandler sharedManager].tradeStatus isEqualToString:@"HALT"]) {
        return @"停牌";
    }
    else if ([[LNStockHandler sharedManager].tradeStatus isEqualToString:@"BREAK"]) {
        return @"休市";
    }
    else if ([[LNStockHandler sharedManager].tradeStatus isEqualToString:@"OCALL"]) {
        return @"集合竞价";
    }
    else if ([[LNStockHandler sharedManager].tradeStatus isEqualToString:@"ENDTR"]) {
        return @"收盘";
    } else {
        return @"";
    }
}

+ (BOOL)isNightMode {
    return [LNStockHandler sharedManager].isNightMode;
}

+ (BOOL)isGreenUp {
    return [LNStockHandler sharedManager].isGreenUp;
}

+ (BOOL)isVerticalScreen {
    return [LNStockHandler sharedManager].isVerticalScreen;
}

+ (BOOL)isLongPress {
    return [LNStockHandler sharedManager].isLongPress;
}

+ (LNStockTitleType)titleType {
    return [LNStockHandler sharedManager].titleType;
}

+ (LNStockPriceType)priceType {
    return [LNStockHandler sharedManager].priceType;
}

+ (LNStockChartType)chartType {
    return [LNStockHandler sharedManager].chartType;
}
//复权类型
+ (LNStockAdjustType)adjustType {
   return [LNStockHandler sharedManager].adjustType;
}

//因子类型
+ (LNStockFactorType)factorType {
   return [LNStockHandler sharedManager].factorType;
}

+ (NSDate *)currentlyDate {
    return [LNStockHandler sharedManager].currentlyDate;
}

//是否是A股指数
+ (BOOL)isIndexStock {
    if ([[[LNStockHandler sharedManager].stocktype lowercaseString] isEqualToString:@"index"]) {
        return YES;
    } else {
        return NO;
    }
}

//判断是否是基金
+ (BOOL)isFundStock {
    if ([[[LNStockHandler sharedManager].stocktype lowercaseString] isEqualToString:@"fund"]) {
        return YES;
    } else {
        return NO;
    }
}

/*
 TRADE => 交易中
 HALT => 停牌
 BREAK => 休市
 OCALL => 集合竞价
 ENDTR => 收盘
 */
@end
