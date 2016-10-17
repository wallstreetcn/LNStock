//
//  QuoteHandler.m
//  Market
//
//  Created by ZhangBob on 5/6/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockHandler.h"
#import "LNStockColor.h"
#import "LNStockModel.h"

@implementation LNStockHandler

+ (LNStockHandler *)sharedManager {
    static LNStockHandler *stockHandler = nil;
    static dispatch_once_t onceQuoteHandler;
    dispatch_once(&onceQuoteHandler, ^{
        stockHandler = [[LNStockHandler alloc]init];
        stockHandler.greenUp = NO;
        stockHandler.verticalScreen = YES;
    });
    return stockHandler;
}

+ (LNStockHandler *)setupWithStockModel:(LNStockModel *)model {
    LNStockHandler *stockInfo = [[LNStockHandler alloc]init];
    [stockInfo defaultSet];
    stockInfo.code = model.prod_code;
    stockInfo.stocktype = model.securities_type;
    if ([model.market_type isEqualToString:@"mdc"]) {
        stockInfo.priceType = LNStockPriceTypeA;
    } else {
        stockInfo.priceType = LNStockPriceTypeB;
    }
    return stockInfo;
}

+ (void)resetData {
    [LNStockHandler sharedManager].verticalScreen = YES;
    [LNStockHandler sharedManager].titleType = LNChartTitleType_1m;
    [LNStockHandler sharedManager].chartType = LNStockChartType_Candles;
}

- (void)setNightMode:(BOOL)nightMode {
    _nightMode = nightMode;
    [[LNStockColor manager] getStockColors];
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

+ (LNStockTitleType)titleType {
    return [LNStockHandler sharedManager].titleType;
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

//-------------------------实例------------------------

- (void)defaultSet {
    self.stocktype = @"stock";
    self.tradeStatus = @"TRADE";
    self.priceType = LNStockPriceTypeA;
}

//判断是否是AStock
- (BOOL)isAStock {
    if (self.priceType == LNStockPriceTypeA) {
        return YES;
    } else {
        return NO;
    }
}

//是否是A股指数
- (BOOL)isIndexStock {
    if ([[self.stocktype lowercaseString] isEqualToString:@"index"]) {
        return YES;
    } else {
        return NO;
    }
}

//判断是否是基金
- (BOOL)isFundStock {
    if ([[self.stocktype lowercaseString] isEqualToString:@"fund"]) {
        return YES;
    } else {
        return NO;
    }
}

//判断是否是A股股票
- (BOOL)isStock {
    if ([[self.stocktype lowercaseString] isEqualToString:@"stock"]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isTRADE {
    if ([self.tradeStatus isEqualToString:@"TRADE"]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)tradeStatusContents {
    if ([self.tradeStatus isEqualToString:@"TRADE"]) {
        return @"交易中";
    }
    else if ([self.tradeStatus isEqualToString:@"HALT"]) {
        return @"停牌";
    }
    else if ([self.tradeStatus isEqualToString:@"BREAK"]) {
        return @"休市";
    }
    else if ([self.tradeStatus isEqualToString:@"OCALL"]) {
        return @"集合竞价";
    }
    else if ([self.tradeStatus isEqualToString:@"ENDTR"]) {
        return @"收盘";
    } else {
        return @"";
    }
}

//价格保留位数
- (NSString *)pricePrecision {
    NSString *precision = self.price_precision.stringValue;
    if (!precision) {
        precision = @"2";
    }
    NSMutableString *type = [@"%.lf" mutableCopy];
    [type insertString:precision atIndex:2];
    return type;
}

@end
