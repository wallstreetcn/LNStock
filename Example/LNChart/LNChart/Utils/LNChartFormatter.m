//
//  LNChartFormatter.m
//  Market
//
//  Created by vvusu on 5/12/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNChartFormatter.h"

@implementation LNChartFormatter

+ (NSString *)formatterWithPosition:(NSString *)position num:(CGFloat)num {
    NSString *string = [NSString stringWithFormat:position,num];
    if (!string) {
        string = @"";
    }
    return string;
}

+ (NSString *)MAFormatterWithPosition:(NSString *)position num:(CGFloat)num {
    if (num == -1) {
        return @"--";
    } else {
        return [NSString stringWithFormat:position,num];
    }
}

+ (NSString *)conversionWithFormatter:(NSString *)formatter value:(CGFloat)num {
    return [NSString stringWithFormat:@"%.2f%@",num,formatter];
}

+ (NSString *)notRounding:(float)price afterPoint:(int)position {
    //NSRoundDown 只舍不入  //保留小数几位
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
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

#pragma mark - Volume
+ (NSString *)volumeCutWithNum:(CGFloat)num maxNum:(CGFloat)maxNum {
    num = num/100.0;
    maxNum = maxNum/100.0;
    return [NSString stringWithFormat:@"%.2f",num/[self getLongFormatterNum:maxNum]];
}

+ (NSString *)volumeTypeWithNum:(CGFloat)num {
    num = num/100.0;
    if (num < 10000.0) {
        return @"手";
    }
    else if (num > 10000.0 && num < 100000000.0){
        return @"万手";
    }
    else {
        return @"亿手";
    }
}

#pragma mark - Number OBV
+ (NSString *)longFormatterWithPosition:(CGFloat)num maxNum:(CGFloat)maxNum {
    return [NSString stringWithFormat:@"%.2f",num/[self getLongFormatterNum:maxNum]];
}

+ (NSString *)longFormatterType:(CGFloat)num {
    if (num < 10000.0) {
        return [NSString stringWithFormat:@"%.2f",num];
    }
    else if (num > 10000.0 && num < 100000000.0){
        return @"万";
    }
    else {
        return @"亿";
    }
}

+ (CGFloat)getLongFormatterNum:(CGFloat)num {
    if (num < 10000.0) {
        return 1.0;
    }
    else if (num > 10000.0 && num < 100000000.0){
        return 10000.0;
    }
    else {
        return 100000000.0;
    }
}

//NSDate通过格式转成 NSString
+ (NSString *)dateWithFormatter:(NSString *)formatter date:(NSDate *)date {
    NSDateFormatter* dateFormat = [LNChartFormatter sharedInstanceFormatter];
    dateFormat.dateFormat = formatter;
    NSString *dateString = [dateFormat stringFromDate:date];
    if (dateString) {
        return dateString;
    }
    else {
        return @"";
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
