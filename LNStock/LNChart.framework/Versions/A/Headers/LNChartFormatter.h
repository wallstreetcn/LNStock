//
//  LNChartFormatter.h
//  Market
//
//  Created by vvusu on 5/12/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

//Color
#define kColorHex(a) [UIColor \
colorWithRed:((float)((a & 0xFF0000) >> 16))/255.0 \
green:((float)((a & 0xFF00) >> 8))/255.0 \
blue:((float)(a & 0xFF))/255.0 alpha:1.0]

@interface LNChartFormatter : NSObject
//保留两位小数
+ (NSString *)twoDigitFormatter:(CGFloat)num;
+ (NSString *)fourDigitFormatter:(CGFloat)num;
+ (NSString *)LengendMAFormatter:(CGFloat)num;

//交易量格式转换
+ (NSString *)volumeCutWithNum:(CGFloat)num;
+ (NSString *)volumeTypeWithNum:(CGFloat)num;
+ (NSString *)volumeFormatterWithNum:(CGFloat)num;

//保留几位小数
+ (NSString *)notRounding:(float)price afterPoint:(int)position;
//添加一个格式
+ (NSString *)conversionWithFormatter:(NSString *)formatter value:(CGFloat)num;

//转换Date格式
+ (NSString *)dateWithFormatter:(NSString *)formatter date:(NSDate *)date;

@end
