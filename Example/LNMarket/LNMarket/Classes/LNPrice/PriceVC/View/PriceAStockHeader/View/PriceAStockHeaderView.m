//
//  PriceAStockHeaderView.m
//  Market
//
//  Created by ZhangBob on 4/22/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "PriceAStockHeaderView.h"
#import "PListUtils.h"
#import "PriceDefine.h"

//行情Label字体颜色（夜晚N，白天D）
#define kSCNLabel kColorHex(0xcdcdcd)
#define kSCDLabel kColorHex(0x323232)

@implementation PriceAStockHeaderView

- (void)awakeFromNib {
    self.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 173);
}

+ (id)createWithXib {
    NSString *className = NSStringFromClass([self class]);
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil];
    return views[0];
}

- (void)addThemeChangedWithMode:(BOOL)isNightMode {
    if (!isNightMode) {
        self.backgroundColor = kSCDBG;
        self.borderView.backgroundColor = kSCDBorder;
        self.divideLineImageView.image = [UIImage imageNamed:@"price_line_day"];
        self.openPx.textColor = kSCDLabel;
        self.closePx.textColor = kSCDLabel;
        self.openPx.textColor = kSCDLabel;
        self.closePx.textColor = kSCDLabel;
        self.businessAmount.textColor = kSCDLabel;
        self.turnoverRatio.textColor = kSCDLabel;
        
        self.highPx.textColor = kSCDLabel;
        self.lowPx.textColor = kSCDLabel;
        self.peRate.textColor = kSCDLabel;
        self.amplitude.textColor = kSCDLabel;
        
        self.businessAmountIn.textColor = kSCDLabel;
        self.businessAmountOut.textColor = kSCDLabel;
        self.marketValue.textColor = kSCDLabel;
        self.circulationValue.textColor = kSCDLabel;
    }
    else {
        self.backgroundColor = kSCNBG;
        self.borderView.backgroundColor = kSCNBorder;
        self.divideLineImageView.image = [UIImage imageNamed:@"price_line_night"];
        self.openPx.textColor = kSCNLabel;
        self.closePx.textColor = kSCNLabel;
        self.openPx.textColor = kSCNLabel;
        self.closePx.textColor = kSCNLabel;
        self.businessAmount.textColor = kSCNLabel;
        self.turnoverRatio.textColor = kSCNLabel;
        
        self.highPx.textColor = kSCNLabel;
        self.lowPx.textColor = kSCNLabel;
        self.peRate.textColor = kSCNLabel;
        self.amplitude.textColor = kSCNLabel;
        
        self.businessAmountIn.textColor = kSCNLabel;
        self.businessAmountOut.textColor = kSCNLabel;
        self.marketValue.textColor = kSCNLabel;
        self.circulationValue.textColor = kSCNLabel;
    }
}

- (void)setPriceHeaderLabelsWithData:(PriceAStockHeaderDataModel *)priceData {
    self.pxChange.text = [self setPriceUpColorOrDownColor:priceData.pxChange].text;
    self.pxChange.textColor = [self setPriceUpColorOrDownColor:priceData.pxChange].textColor;
    self.pxChangeRate.text = [self setPriceUpColorOrDownColor:priceData.pxChangeRate].text;
    self.pxChangeRate.textColor = [self setPriceUpColorOrDownColor:priceData.pxChangeRate].textColor;
    self.lastPx.text = priceData.lastPx;
    self.lastPx.textColor = [self setPriceUpColorOrDownColor:priceData.pxChange].textColor;
    
    self.openPx.text = priceData.openPx;
    self.closePx.text = priceData.preClosePx;
    self.businessAmount.text = [self translateWithString:priceData.businessAmount];
    self.turnoverRatio.text = priceData.turnoverRatio;
    
    self.highPx.text = priceData.highPx;
    self.lowPx.text = priceData.lowPx;
    self.peRate.text = priceData.peRate;
    self.amplitude.text = priceData.amplitude;
    
    self.businessAmountIn.text = [self translateWithString:priceData.businessAmountIn];
    self.businessAmountOut.text = [self translateWithString:priceData.businessAmountOut];
    self.marketValue.text = [self translateWithString:priceData.marketValue];
    self.circulationValue.text = [self translateWithString:priceData.circulationValue];
}

- (NSString *)translateWithString:(NSString *)string {
    NSString * numStr = nil;
    double num = [string doubleValue];
    if (num >= (10000 * 10000000.0)) {
        numStr = [NSString stringWithFormat:@"%.0lf亿", num / (10000 * 10000)];
    } else if (num > 10000 * 1000000.0) {
        numStr = [NSString stringWithFormat:@"%.1lf亿", num / (10000 * 10000)];
    } else if (num > 10000 * 10000) {
        numStr = [NSString stringWithFormat:@"%.2lf亿", num / (10000 * 10000)];
    } else if (num > 10000) {
        numStr = [NSString stringWithFormat:@"%.2lf万", num / 10000];
    } else {
        numStr = [NSString stringWithFormat:@"%.2lf", num];
    }
    return numStr;
}

- (UILabel *)setPriceUpColorOrDownColor: (NSString *)string {
    UILabel *labelWithColor = [[UILabel alloc] init];
    if ([string hasPrefix:@"-"]) {
        labelWithColor.textColor = kSCDown;
        labelWithColor.text = string;
    }else {
        labelWithColor.text = [NSString stringWithFormat:@"+%@",string];
        labelWithColor.textColor = kSCUp;
    }
    
    return labelWithColor;
}

@end
