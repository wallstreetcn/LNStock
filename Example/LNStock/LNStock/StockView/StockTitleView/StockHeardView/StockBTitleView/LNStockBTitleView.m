//
//  LNQuoteBTitleView.m
//  Market
//
//  Created by ZhangBob on 5/5/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockBTitleView.h"
#import "LNStockHandler.h"
#import "LNStockModel.h"
#import "LNStockNetwork.h"
#import "LNStockFormatter.h"
#import "UIImage+Tint.h"
#import "LNStockColor.h"

@implementation LNStockBTitleView

+ (id)createWithXib {
    NSString *className = NSStringFromClass([self class]);
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"LNStock.bundle/%@",className] owner:nil options:nil];
    return views.firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.stockName.textColor = [LNStockColor titleLabelBG];
    [self.closeBtn setImage:[[UIImage imageNamed:@"LNStock.bundle/stock_closebtn"] imageWithTintColor:[LNStockColor headerViewCloseBtn]] forState:UIControlStateNormal];
    [self.refreshBtn setImage:[[UIImage imageNamed:@"LNStock.bundle/stock_refreshbtn"] imageWithTintColor:[LNStockColor headerViewRefreshBtn]] forState:UIControlStateNormal];
}

- (IBAction)refreshAction:(UIButton *)sender {
    if (self.block) {
        self.block(LNStockBTitleViewAction_Refresh);
    }
}

- (IBAction)closeAction:(UIButton *)sender {
    if (self.block) {
        self.block(LNStockBTitleViewAction_Close);
    }
}

- (void)refreshTitleData:(LNStockModel *)model {
    self.stockName.text = model.prod_name;
    self.lastPrice.text = [LNStockFormatter formatterDefaultType:[self.stockInfo pricePrecision] num:model.last_px.floatValue];
    self.priceChange.text = [LNStockFormatter formatterPriceType:[self.stockInfo pricePrecision] num:model.px_change.floatValue];
    self.priceChangeRate.text = [LNStockFormatter formatterChangeRateType:model.px_change_rate.floatValue];
    
    //颜色
    self.lastPrice.textColor = [LNStockFormatter priceColor:model.px_change.floatValue];
    self.priceChange.textColor = [LNStockFormatter priceColor:model.px_change.floatValue];
    self.priceChangeRate.textColor = [LNStockFormatter priceColor:model.px_change_rate.floatValue];
    
    //判断如果停牌颜色设置
    if ([self.stockInfo.tradeStatus isEqualToString:@"HALT"] || model.trade_status.length == 0) {
        self.lastPrice.text = @"- -";
        self.priceChange.text = @"- -";
        self.priceChangeRate.text = @"- -";
        self.lastPrice.textColor = [LNStockColor stockHALT];
        self.priceChange.textColor = [LNStockColor stockHALT];
        self.priceChangeRate.textColor = [LNStockColor stockHALT];
    }
}

@end
