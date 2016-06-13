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

@interface PriceAStockHeaderView ()
@property (nonatomic, assign) CGFloat newPrice;
@property (nonatomic, assign) CGFloat lastPrice;
@property (weak, nonatomic) IBOutlet UIView *priceBgVew;
@end
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
    self.isNightMode = isNightMode;
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

- (void)setPriceHeaderLabelsWithData:(LNPriceModel *)priceData {
    self.lastPrice = self.lastPx.text.floatValue;
    self.newPrice = priceData.last_px.floatValue;
    self.lastPx.text = [self setPriceText:priceData.last_px.floatValue];
    if (priceData.px_change_rate.floatValue < 0) {
        self.lastPx.textColor = [UIColor greenColor];
    } else {
        self.lastPx.textColor = [UIColor redColor];
    }
    
    self.pxChange.text = [self setFormatterPriceText:priceData.px_change.floatValue];
    self.pxChange.textColor = [self setPriceColor:priceData.px_change.floatValue];
    self.pxChangeRate.text = [NSString stringWithFormat:@"%@%%",[self setFormatterPriceText:priceData.px_change_rate.floatValue]];
    self.pxChangeRate.textColor = [self setPriceColor:priceData.px_change_rate.floatValue];

    
    self.openPx.text = [self setPriceText:priceData.open_px.floatValue];;
    self.closePx.text = [self setPriceText:priceData.preclose_px.floatValue];;
    self.businessAmount.text = [self volumeFormatterWithNum:priceData.business_amount.floatValue];
    self.turnoverRatio.text = [NSString stringWithFormat:@"%@%%",[self setPriceText:priceData.turnover_ratio.floatValue]];
    
    self.highPx.text = [self setPriceText:priceData.high_px.floatValue];;
    self.lowPx.text = [self setPriceText:priceData.low_px.floatValue];;
    self.peRate.text = [self setPriceText:priceData.pe_rate.floatValue];;
    self.amplitude.text = [NSString stringWithFormat:@"%@%%",[self setPriceText:priceData.amplitude.floatValue]];
    
    self.businessAmountIn.text = [self businessAmountFormatterWithNum:priceData.business_amount_in.doubleValue/100];
    self.businessAmountOut.text = [self businessAmountFormatterWithNum:priceData.business_amount_out.doubleValue/100];
    self.marketValue.text = [self businessAmountFormatterWithNum:priceData.market_value.doubleValue];
    self.circulationValue.text = [self businessAmountFormatterWithNum:priceData.circulation_value.doubleValue];
    
    //涨跌额为0 的话颜色设置为白色
    if (priceData.px_change.floatValue == 0) {
        if (self.isNightMode) {
            self.lastPx.textColor = [UIColor whiteColor];
            self.pxChange.textColor = [UIColor whiteColor];
            self.pxChangeRate.textColor = [UIColor whiteColor];
        } else {
            self.lastPx.textColor = [UIColor blackColor];
            self.pxChange.textColor = [UIColor blackColor];
            self.pxChangeRate.textColor = [UIColor blackColor];
        }
    }
    
    //判断如果停牌颜色设置
    if ([priceData.trade_status isEqualToString:@"HALT"]) {
        if (self.isNightMode) {
            self.lastPx.textColor = [UIColor whiteColor];
            self.pxChange.textColor = [UIColor whiteColor];
            self.pxChangeRate.textColor = [UIColor whiteColor];
        } else {
            self.lastPx.textColor = [UIColor blackColor];
            self.pxChange.textColor = [UIColor blackColor];
            self.pxChangeRate.textColor = [UIColor blackColor];
        }
    }
    [self startAnimation];
}

- (NSString *)setPriceText:(CGFloat)num {
    return [NSString stringWithFormat:@"%.2lf",num];
}

- (NSString *)setFormatterPriceText:(CGFloat)num {
    if (num >= 0) {
        return [NSString stringWithFormat:@"+%.2lf",num];
    } else {
        return [NSString stringWithFormat:@"%.2lf",num];
    }
}

- (UIColor *)setPriceColor:(CGFloat)num {
    if (num > 0 ) {
        return [UIColor redColor];
    } else if (num == 0) {
        return [UIColor whiteColor];
    } else {
        return [UIColor greenColor];
    }
}

- (NSString *)volumeFormatterWithNum:(CGFloat)num {
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

- (NSString *)businessAmountFormatterWithNum:(CGFloat)num {
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

- (void)startAnimation {
    if (self.newPrice == self.lastPrice) {
        return;
    } else {
        UIColor *color = [UIColor colorWithRed:0.91 green:0.28 blue:0.25 alpha:1];
        if (self.newPrice < self.lastPrice) {
            color = [UIColor colorWithRed:0.35 green:0.94 blue:0.35 alpha:1];
        }
        
        [UIView animateWithDuration:0.5f animations:^{
            self.priceBgVew.backgroundColor = color;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5f animations:^{
                self.priceBgVew.backgroundColor = [UIColor clearColor];
            }];
        }];
    }
}

@end
