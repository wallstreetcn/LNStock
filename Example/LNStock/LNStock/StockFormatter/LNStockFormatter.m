//
//  LNStockFormatter.m
//  LNStock
//
//  Created by vvusu on 6/6/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockFormatter.h"
#import "LNStockHandler.h"
#import "LNStockColor.h"

@implementation LNStockFormatter

+ (NSString *)formatterDefaultType:(CGFloat)num {
    return [NSString stringWithFormat:[LNStockHandler price_precision],num];
}

+ (NSString *)formatterPriceType:(CGFloat)num {
    if (num >= 0) {
        return [NSString stringWithFormat:@"+%@",[self formatterDefaultType:num]];
    } else {
        return [self formatterDefaultType:num];
    }
}

+ (NSString *)formatterChangeRateType:(CGFloat)num {
    if (num >= 0) {
        return [NSString stringWithFormat:@"+%.2f%%",num];
    } else {
        return [NSString stringWithFormat:@"%.2f%%",num];
    }
}

+ (NSString *)formatterChangeRateTwoType:(CGFloat)num {
    return [NSString stringWithFormat:@"%.2f%%",num];
}

+ (NSString *)volumeFormatterWithNum:(CGFloat)num {
    num = num/100.0;
    if (num < 10000.0) {
        return [NSString stringWithFormat:@"%.0f手",num];
    }
    else if (num > 10000.0 && num < 100000000.0){
        return [NSString stringWithFormat:@"%.2f万手",num/10000.0];
    }
    else {
        return [NSString stringWithFormat:@"%.2f亿手",num/100000000.0];
    }
}

+ (NSString *)businessAmountFormatterWithNum:(CGFloat)num {
    if (num < 10000.0) {
        return [NSString stringWithFormat:@"%.0f",num];
    }
    else if (num > 10000.0 && num < 100000000.0){
        return [NSString stringWithFormat:@"%.2f万",num/10000.0];
    }
    else {
        return [NSString stringWithFormat:@"%.2f亿",num/100000000.0];
    }
}

+ (UIColor *)priceColor:(CGFloat)num {
    if (num > 0 ) {
        return [LNStockColor priceUp];
    } else if (num == 0) {
        if ([LNStockHandler isNightMode]) {
            return [UIColor whiteColor];
        } else {
            return [UIColor blackColor];
        }
    } else {
        return [LNStockColor priceDown];
    }
}

+ (NSDateFormatter *)sharedInstanceFormatter {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NSDateFormatter alloc] init];
    });
    return instance;
}

@end
