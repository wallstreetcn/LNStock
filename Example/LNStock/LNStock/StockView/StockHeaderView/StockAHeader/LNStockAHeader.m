//
//  PriceAStockHeaderView.m
//  Market
//
//  Created by ZhangBob on 4/22/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockAHeader.h"
#import "LNStockHandler.h"
#import "LNStockModel.h"
#import "LNStockFormatter.h"
#import "LNStockColor.h"

@interface LNStockAHeader ()
@property (nonatomic, assign) CGFloat newPrice;
@property (nonatomic, assign) CGFloat lastPrice;
@end

@implementation LNStockAHeader

- (void)awakeFromNib {
    [self setupColors];
}

+ (id)createWithXib {
    NSString *className = NSStringFromClass([self class]);
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"LNStock.bundle/%@",className] owner:nil options:nil];
    return views[0];
}

- (void)setupDataWith:(LNStockModel *)priceData {
    self.lastPrice = self.newPrice;
    self.newPrice = priceData.last_px.floatValue;
    
    self.lastPx.text = [LNStockFormatter formatterDefaultType:priceData.last_px.floatValue];
    self.pxChange.text = [LNStockFormatter formatterPriceType:priceData.px_change.floatValue];
    self.pxChangeRate.text = [LNStockFormatter formatterChangeRateType:priceData.px_change_rate.floatValue];
    
    self.openPx.text = [LNStockFormatter formatterDefaultType:priceData.open_px.floatValue];
    self.closePx.text = [LNStockFormatter formatterDefaultType:priceData.preclose_px.floatValue];
    self.businessAmount.text = [LNStockFormatter volumeFormatterWithNum:priceData.business_amount.floatValue];
    self.turnoverRatio.text = [LNStockFormatter formatterChangeRateTwoType:priceData.turnover_ratio.floatValue];
    
    self.lowPx.text = [LNStockFormatter formatterDefaultType:priceData.low_px.floatValue];
    self.highPx.text = [LNStockFormatter formatterDefaultType:priceData.high_px.floatValue];
    self.peRate.text = [LNStockFormatter formatterDefaultType:priceData.pe_rate.floatValue];
    self.amplitude.text = [LNStockFormatter formatterChangeRateTwoType:priceData.amplitude.floatValue];
    
    self.marketValue.text = [LNStockFormatter businessAmountFormatterWithNum:priceData.market_value.doubleValue];
    self.circulationValue.text = [LNStockFormatter businessAmountFormatterWithNum:priceData.circulation_value.doubleValue];
    self.businessAmountIn.text = [LNStockFormatter businessAmountFormatterWithNum:priceData.business_amount_in.doubleValue/100];
    self.businessAmountOut.text = [LNStockFormatter businessAmountFormatterWithNum:priceData.business_amount_out.doubleValue/100];
    
    //颜色
    self.lastPx.textColor = [LNStockFormatter priceColor:priceData.px_change.floatValue];
    self.pxChange.textColor = [LNStockFormatter priceColor:priceData.px_change.floatValue];
    self.pxChangeRate.textColor = [LNStockFormatter priceColor:priceData.px_change_rate.floatValue];
    
    //判断如果停牌颜色设置
    if ([priceData.trade_status isEqualToString:@"HALT"] || priceData.trade_status.length == 0) {
        self.lastPx.text = @"- -";
        self.pxChange.text = @"- -";
        self.pxChangeRate.text = @"- -";
        self.lastPx.textColor = [LNStockColor stockHALT];
        self.pxChange.textColor = [LNStockColor stockHALT];
        self.pxChangeRate.textColor = [LNStockColor stockHALT];
    }
    //如果是指数有些值是不要的
    if ([LNStockHandler isIndexStock]) {
        self.peRate.text = @"--";
        self.marketValue.text = @"--";
        self.turnoverRatio.text = @"--";
        self.circulationValue.text = @"--";
        self.businessAmountIn.text = @"--";
        self.businessAmountOut.text = @"--";
    }
    [self startAnimation];
}

- (void)setupColors {
    self.backgroundColor = [LNStockColor stockViewBG];
    self.borderView.backgroundColor = [LNStockColor borderLine];
    self.openPx.textColor = [LNStockColor headerLabelText];
    self.closePx.textColor = [LNStockColor headerLabelText];
    self.openPx.textColor = [LNStockColor headerLabelText];
    self.closePx.textColor = [LNStockColor headerLabelText];
    self.businessAmount.textColor = [LNStockColor headerLabelText];
    self.turnoverRatio.textColor = [LNStockColor headerLabelText];
    
    self.highPx.textColor = [LNStockColor headerLabelText];
    self.lowPx.textColor = [LNStockColor headerLabelText];
    self.peRate.textColor = [LNStockColor headerLabelText];
    self.amplitude.textColor = [LNStockColor headerLabelText];
    
    self.businessAmountIn.textColor = [LNStockColor headerLabelText];
    self.businessAmountOut.textColor = [LNStockColor headerLabelText];
    self.marketValue.textColor = [LNStockColor headerLabelText];
    self.circulationValue.textColor = [LNStockColor headerLabelText];
    
    if ([LNStockHandler isNightMode]) {
        self.divideLineImageView.image = [UIImage imageNamed:@"LNStock.bundle/stock_line_n"];
    } else {
        self.divideLineImageView.image = [UIImage imageNamed:@"LNStock.bundle/stock_line_d"];
    }
}

#pragma mark - Animation

- (void)startAnimation {
    self.newPrice = ceil(self.newPrice*1000)/1000;
    self.lastPrice = ceil(self.lastPrice*1000)/1000;
    
    if (self.newPrice == self.lastPrice) {
        return;
    }
    else {
        UIColor *color = [LNStockColor priceLastUp];
        if (self.newPrice < self.lastPrice) {
            color = [LNStockColor priceLastDown];
        }
        
        [UIView animateWithDuration:0.5f animations:^{
            self.lastPx.layer.backgroundColor = color.CGColor;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5f animations:^{
                self.lastPx.layer.backgroundColor = [UIColor clearColor].CGColor;
            }];
        }];
    }
}

@end
