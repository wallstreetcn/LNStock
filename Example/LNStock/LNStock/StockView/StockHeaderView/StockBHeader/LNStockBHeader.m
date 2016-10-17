//
//  PriceBStockHeaderView.m
//  Market
//
//  Created by ZhangBob on 4/22/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockBHeader.h"
#import "LNStockHandler.h"
#import "LNStockModel.h"
#import "LNStockFormatter.h"
#import "LNStockColor.h"

@interface LNStockBHeader ()
@property (nonatomic, assign) CGFloat newPrice;
@property (nonatomic, assign) CGFloat lastPrice;
@end

@implementation LNStockBHeader

- (void)awakeFromNib {
    [super awakeFromNib];
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
    
    self.lastPx.text = [LNStockFormatter formatterDefaultType:[self.stockInfo pricePrecision] num:priceData.last_px.floatValue];
    self.pxChange.text = [LNStockFormatter formatterPriceType:[self.stockInfo pricePrecision] num:priceData.px_change.floatValue];
    self.pxChangeRate.text = [LNStockFormatter formatterChangeRateType:priceData.px_change_rate.floatValue];
    
    NSDateFormatter *dateFormatter = [LNStockFormatter sharedInstanceFormatter];
    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    self.self.time.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:priceData.update_time.integerValue]];
    self.trade_status.text = [self.stockInfo tradeStatusContents];
    
    self.openPx.text = [LNStockFormatter formatterDefaultType:[self.stockInfo pricePrecision] num:priceData.open_px.floatValue];
    self.closePx.text = [LNStockFormatter formatterDefaultType:[self.stockInfo pricePrecision] num:priceData.preclose_px.floatValue];
    self.buyPx.text = [LNStockFormatter formatterDefaultType:[self.stockInfo pricePrecision] num:priceData.buy_px.floatValue];
    self.sellPx.text = [LNStockFormatter formatterDefaultType:[self.stockInfo pricePrecision] num:priceData.sell_px.floatValue];
    self.highPx.text = [LNStockFormatter formatterDefaultType:[self.stockInfo pricePrecision] num:priceData.high_px.floatValue];
    self.lowPx.text = [LNStockFormatter formatterDefaultType:[self.stockInfo pricePrecision] num:priceData.low_px.floatValue];
    self.lowPx_52.text = [LNStockFormatter formatterDefaultType:[self.stockInfo pricePrecision] num:priceData.week_52_low.floatValue];
    self.highPx_52.text = [LNStockFormatter formatterDefaultType:[self.stockInfo pricePrecision] num:priceData.week_52_high.floatValue];
    
    //颜色
    self.lastPx.textColor = [LNStockFormatter priceColor:priceData.px_change.floatValue];
    self.pxChange.textColor = [LNStockFormatter priceColor:priceData.px_change.floatValue];
    self.pxChangeRate.textColor = [LNStockFormatter priceColor:priceData.px_change_rate.floatValue];
    
    //判断如果停牌颜色设置
    if ([priceData.trade_status isEqualToString:@"HALT"] || priceData.trade_status.length == 0) {
        self.lastPx.textColor = [LNStockColor stockHALT];
        self.pxChange.textColor = [LNStockColor stockHALT];
        self.pxChangeRate.textColor = [LNStockColor stockHALT];
    }
    [self startAnimation];
}

- (void)setupColors {
    self.backgroundColor = [LNStockColor stockViewBG];
    self.borderView.backgroundColor = [LNStockColor borderLine];
    self.trade_status.textColor = [LNStockColor headerLabelText];
    self.time.textColor = [LNStockColor headerLabelText];
    self.closePx.textColor = [LNStockColor headerLabelText];
    self.openPx.textColor = [LNStockColor headerLabelText];
    self.buyPx.textColor = [LNStockColor headerLabelText];
    self.sellPx.textColor = [LNStockColor headerLabelText];
    self.highPx.textColor = [LNStockColor headerLabelText];
    self.lowPx.textColor = [LNStockColor headerLabelText];
    self.highPx_52.textColor = [LNStockColor headerLabelText];
    self.lowPx_52.textColor = [LNStockColor headerLabelText];
    
    if ([LNStockHandler isNightMode]) {
        self.divideLineImageView.image = [UIImage imageNamed:@"LNStock.bundle/stock_line_n"];
    } else {
        self.divideLineImageView.image = [UIImage imageNamed:@"LNStock.bundle/stock_line_d"];
    }
}

#pragma mark - Animation

- (void)startAnimation {
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
