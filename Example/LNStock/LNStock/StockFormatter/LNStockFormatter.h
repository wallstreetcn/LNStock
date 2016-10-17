//
//  LNStockFormatter.h
//  LNStock
//
//  Created by vvusu on 6/6/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LNStockFormatter : NSObject
+ (UIColor *)priceColor:(CGFloat)num;
+ (NSString *)volumeFormatterWithNum:(CGFloat)num;
+ (NSString *)formatterChangeRateType:(CGFloat)num;
+ (NSString *)formatterChangeRateTwoType:(CGFloat)num;
+ (NSString *)businessAmountFormatterWithNum:(CGFloat)num;
+ (NSString *)formatterPriceType:(NSString *)formatter num:(CGFloat)num;
+ (NSString *)formatterDefaultType:(NSString *)formatter num:(CGFloat)num;
+ (NSDateFormatter *)sharedInstanceFormatter;
@end
