//
//  LNStockColor.m
//  LNStock
//
//  Created by vvusu on 8/30/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockColor.h"
#import "LNStockHandler.h"

#define kColorHex(a) [UIColor \
colorWithRed:((float)((a & 0xFF0000) >> 16))/255.0 \
green:((float)((a & 0xFF00) >> 8))/255.0 \
blue:((float)(a & 0xFF))/255.0 alpha:1.0]

@interface LNStockColor()
@property (nonatomic, strong) NSDictionary *colors;
@end

@implementation LNStockColor

+ (LNStockColor *)manager
{
    static LNStockColor *stockColor = nil;
    static dispatch_once_t onceQuoteColor;
    dispatch_once(&onceQuoteColor, ^{
        stockColor = [[LNStockColor alloc]init];
        [stockColor getStockColors];
    });
    return stockColor;
}

//转换颜色
+ (UIColor *)colorWithHex:(NSString *)color alpha:(NSString *)alpha
{
    if ([color length] < 6) {                 //长度不合法
        return [UIColor blackColor];
    }
    NSString *tempString = [color lowercaseString];
    if ([tempString hasPrefix:@"0x"]) {       //检查开头是0x
        tempString = [tempString substringFromIndex:2];
    } else if ([tempString hasPrefix:@"#"]) { //检查开头是#
        tempString = [tempString substringFromIndex:1];
    }
    if ([tempString length] != 6) {
        return [UIColor blackColor];
    }
    //分解三种颜色的值
    CGFloat colorAlpha = alpha.floatValue;
    NSRange range = NSMakeRange(0, 2);
    NSString *rString = [tempString substringWithRange:range];
    range.location = 2;
    NSString *gString = [tempString substringWithRange:range];
    range.location = 4;
    NSString *bString = [tempString substringWithRange:range];
    //取三种颜色值
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:colorAlpha];
}

- (void)getStockColors
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LNStock.bundle/stockcolors" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    if ([LNStockHandler isNightMode]) {
        data = [data valueForKey:@"night"];
    } else {
        data = [data valueForKey:@"day"];
    }
    //遍历替换颜色字符串
    NSMutableDictionary<NSString *, UIColor *> *temp = [NSMutableDictionary dictionary];
    [data enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary * _Nonnull obj, BOOL * _Nonnull stop) {
        temp[key] = [LNStockColor colorWithHex:[obj valueForKey:@"color"] alpha:[obj valueForKey:@"alpha"]];
    }];
    _colors = [NSDictionary dictionaryWithDictionary:temp];
}

+ (UIColor *)colorForKey:(NSString *)key {
    return [[LNStockColor manager] colors][key] ? : [UIColor clearColor];
}

+ (UIColor *)stockViewBG
{
    return [LNStockColor colorForKey:@"stockViewBG"];
}

+ (UIColor *)borderLine
{
    return [LNStockColor colorForKey:@"borderLine"];
}

+ (UIColor *)priceUp
{
    if ([LNStockHandler isGreenUp]) {
        return [LNStockColor colorForKey:@"priceDown"];
    } else {
        return [LNStockColor colorForKey:@"priceUp"];
    }
}

+ (UIColor *)priceDown
{
    if ([LNStockHandler isGreenUp]) {
        return [LNStockColor colorForKey:@"priceUp"];
    } else {
        return [LNStockColor colorForKey:@"priceDown"];
    }
}

+ (UIColor *)priceLastUp
{
    if ([LNStockHandler isGreenUp]) {
        return [LNStockColor colorForKey:@"priceLastDown"];
    } else {
        return [LNStockColor colorForKey:@"priceLastUp"];
    }
}

+ (UIColor *)priceLastDown
{
    if ([LNStockHandler isGreenUp]) {
        return [LNStockColor colorForKey:@"priceLastUp"];
    } else {
        return [LNStockColor colorForKey:@"priceLastDown"];
    }
}

+ (UIColor *)titleLabelBG
{
    return [LNStockColor colorForKey:@"titleLabelBG"];
}

+ (UIColor *)headerLabelText
{
    return [LNStockColor colorForKey:@"headerLabelText"];
}

+ (UIColor *)selectViewBG
{
    return [LNStockColor colorForKey:@"selectViewBG"];
}

+ (UIColor *)selectViewLine
{
    return [LNStockColor colorForKey:@"selectViewLine"];
}

+ (UIColor *)selectViewBtnN
{
    return [LNStockColor colorForKey:@"selectViewBtnN"];
}

+ (UIColor *)selectViewBtnS
{
    return [LNStockColor colorForKey:@"selectViewBtnS"];
}

+ (UIColor *)infoViewBG
{
    return [LNStockColor colorForKey:@"infoViewBG"];
}

+ (UIColor *)detailListViewLabel
{
    return [LNStockColor colorForKey:@"detailListViewLabel"];
}

+ (UIColor *)optionViewBtnN
{
    return [LNStockColor colorForKey:@"optionViewBtnN"];
}

+ (UIColor *)optionViewBtnS
{
    return [LNStockColor colorForKey:@"optionViewBtnS"];
}

+ (UIColor *)optionViewBtnImage
{
    return [LNStockColor colorForKey:@"optionViewBtnImage"];
}

+ (UIColor *)headerViewCloseBtn
{
    return [LNStockColor colorForKey:@"headerViewCloseBtn"];
}

+ (UIColor *)headerViewRefreshBtn
{
    return [LNStockColor colorForKey:@"headerViewRefreshBtn"];
}

+ (UIColor *)selectViewChartTypeBtn
{
    return [LNStockColor colorForKey:@"selectViewChartTypeBtn"];
}

+ (UIColor *)stockHALT {
    return [LNStockColor colorForKey:@"stockHALT"];
}

//---------------------
+ (UIColor *)chartBG
{
    return [LNStockColor colorForKey:@"chartBG"];
}

+ (UIColor *)chartBorder
{
    return [LNStockColor colorForKey:@"chartBorder"];
}

+ (UIColor *)chartHighlighterLabelBG
{
    return [LNStockColor colorForKey:@"chartHighlighterLabelBG"];
}

+ (UIColor *)chartHighlighterLine
{
    return [LNStockColor colorForKey:@"chartHighlighterLine"];
}

+ (UIColor *)chartCandleRiseColor
{
    return [LNStockColor colorForKey:@"chartCandleRiseColor"];
}

+ (UIColor *)chartCandleFallColor
{
    return [LNStockColor colorForKey:@"chartCandleFallColor"];
}

+ (UIColor *)chartLineFillStartColor
{
    return [LNStockColor colorForKey:@"chartLineFillStartColor"];
}

+ (UIColor *)chartLineFillEndColor
{
    return [LNStockColor colorForKey:@"chartLineFillEndColor"];
}

+ (UIColor *)chartCandleColor
{
    return [LNStockColor colorForKey:@"chartCandleColor"];
}

//Chart Line颜色
+ (UIColor *)chartLine
{
    return [LNStockColor colorForKey:@"chartLine"];
}
//Chart 均线颜色
+ (UIColor *)chartAVGLine
{
    return [LNStockColor colorForKey:@"chartAVGLine"];
}
//Chart 昨收价格线颜色
+ (UIColor *)chartLimitLine
{
    return [LNStockColor colorForKey:@"chartLimitLine"];
}

//Chart MA颜色
+ (UIColor *)chartMA1
{
    return [LNStockColor colorForKey:@"chartMA1"];
}
+ (UIColor *)chartMA2
{
    return [LNStockColor colorForKey:@"chartMA2"];
}
+ (UIColor *)chartMA3
{
    return [LNStockColor colorForKey:@"chartMA3"];
}
+ (UIColor *)chartMA4
{
    return [LNStockColor colorForKey:@"chartMA4"];
}
+ (UIColor *)chartMA5
{
    return [LNStockColor colorForKey:@"chartMA5"];
}

//Chart MACD颜色
+ (UIColor *)chartDIFF
{
    return [LNStockColor colorForKey:@"chartDIFF"];
}
+ (UIColor *)chartDEA
{
    return [LNStockColor colorForKey:@"chartDEA"];
}
+ (UIColor *)chartMACD
{
    return [LNStockColor colorForKey:@"chartMACD"];
}

//Chart BOLL颜色
+ (UIColor *)chartUPPER
{
    return [LNStockColor colorForKey:@"chartUPPER"];
}
+ (UIColor *)chartMID
{
    return [LNStockColor colorForKey:@"chartMID"];
}
+ (UIColor *)chartLOWER
{
    return [LNStockColor colorForKey:@"chartLOWER"];
}

//Chart KDJ颜色
+ (UIColor *)chartK
{
    return [LNStockColor colorForKey:@"chartK"];
}
+ (UIColor *)chartD
{
    return [LNStockColor colorForKey:@"chartD"];
}
+ (UIColor *)chartJ
{
    return [LNStockColor colorForKey:@"chartJ"];
}

//Chart RSI颜色
+ (UIColor *)chartRSI6
{
    return [LNStockColor colorForKey:@"chartRSI6"];
}
+ (UIColor *)chartRSI12
{
    return [LNStockColor colorForKey:@"chartRSI12"];
}
+ (UIColor *)chartRSI24
{
    return [LNStockColor colorForKey:@"chartRSI24"];
}

//Chart OBV颜色
+ (UIColor *)chartOBV
{
    return [LNStockColor colorForKey:@"chartOBV"];
}

@end
