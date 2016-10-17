//
//  LNChartFormatter.h
//  Market
//
//  Created by vvusu on 5/12/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface LNChartFormatter : NSObject
//保留两位小数
+ (NSString *)formatterWithPosition:(NSString *)position num:(CGFloat)num;
+ (NSString *)MAFormatterWithPosition:(NSString *)position num:(CGFloat)num;

//交易量格式转换
//+ (NSString *)volumeCutWithNum:(CGFloat)num;
+ (NSString *)volumeCutWithNum:(CGFloat)num maxNum:(CGFloat)maxNum;
+ (NSString *)volumeTypeWithNum:(CGFloat)num;
+ (NSString *)volumeFormatterWithNum:(CGFloat)num;

//普通格式转换
+ (NSString *)longFormatterWithPosition:(CGFloat)num maxNum:(CGFloat)maxNum;
+ (NSString *)longFormatterType:(CGFloat)num;

//保留几位小数
+ (NSString *)notRounding:(float)price afterPoint:(int)position;
//添加一个格式
+ (NSString *)conversionWithFormatter:(NSString *)formatter value:(CGFloat)num;
//转换Date格式
+ (NSString *)dateWithFormatter:(NSString *)formatter date:(NSDate *)date;

@end
