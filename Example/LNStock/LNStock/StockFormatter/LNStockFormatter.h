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
+ (NSString *)formatterPriceType:(CGFloat)num;
+ (NSString *)formatterDefaultType:(CGFloat)num;
+ (NSString *)formatterChangeRateType:(CGFloat)num;
+ (NSString *)formatterChangeRateTwoType:(CGFloat)num;
+ (NSString *)volumeFormatterWithNum:(CGFloat)num;
+ (NSString *)businessAmountFormatterWithNum:(CGFloat)num;
+ (NSDateFormatter *)sharedInstanceFormatter;
@end
