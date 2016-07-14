//
//  UIColor+Tool.h
//  Market
//
//  Created by vvusu on 4/21/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Tool)
//颜色转换成Image
- (UIImage *)transformImage;

//16进制转换成UIColor
+ (UIColor *)colorWithRGBHex:(UInt32)hex;
+ (UIColor *)colorWithRGBHex:(UInt32)hex alpha:(CGFloat)alpha;

//根据字符串创建Color,比如d16c11
+ (UIColor *)createColorWithString:(NSString *)colorStr;

@end
