//
//  LNQuoteATitleView.m
//  Market
//
//  Created by ZhangBob on 5/5/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockATitleView.h"
#import "LNStockHandler.h"
#import "LNStockDefine.h"
#import "LNStockFormatter.h"
#import "LNStockModel.h"
#import "LNStockNetwork.h"
#import "UIImage+Tint.h"
#import "LNStockColor.h"

@implementation LNStockATitleView

- (void)awakeFromNib {
    [self addThemeChange];
    [self refreshTitleData];    
    [self.closeBtn setImage:[[UIImage imageNamed:@"LNStock.bundle/stock_closebtn"] imageWithTintColor:[LNStockColor headerViewCloseBtn]] forState:UIControlStateNormal];
    [self.refreshBtn setImage:[[UIImage imageNamed:@"LNStock.bundle/stock_refreshbtn"] imageWithTintColor:[LNStockColor headerViewRefreshBtn]] forState:UIControlStateNormal];
}

+ (id)createWithXib {
    NSString *className = NSStringFromClass([self class]);
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"LNStock.bundle/%@",className] owner:nil options:nil];
    return views[0];
}

- (void)addThemeChange {
    self.timeLabel.textColor = [LNStockColor titleLabelBG];
    self.stockName.textColor = [LNStockColor titleLabelBG];
    self.businessAmount.textColor = [LNStockColor titleLabelBG];
}

- (IBAction)refreshAction:(UIButton *)sender {
    if (self.block) {
        self.block(LNStockATitleViewAction_Refresh);
    }
}

- (IBAction)closeAction:(UIButton *)sender {
    if (self.block) {
        self.block(LNStockATitleViewAction_Close);
    }
}

- (void)setAtitleViewWithDictionary:(NSDictionary *)dic {
    self.timeLabel.text = [dic valueForKey:@"time"];
    self.stockName.text = [dic valueForKey:@"StockName"];
    self.lastPrice.text = [dic valueForKey:@"LastPrie"];
    self.priceChange.text = [dic valueForKey:@"PriceChange"];
    self.priceChangeRate.text = [dic valueForKey:@"PriceChangeRate"];
    self.businessAmount.text = [dic valueForKey:@"BusinessAmount"];
}

//刷新数据
- (void)refreshTitleData:(LNStockModel *)model {
    self.stockName.text = model.prod_name;

    self.lastPrice.text = [LNStockFormatter formatterDefaultType:model.last_px.floatValue];
    self.businessAmount.text = [LNStockFormatter volumeFormatterWithNum:model.business_amount.floatValue];
    self.priceChange.text = [LNStockFormatter formatterPriceType:model.px_change.floatValue];
    self.priceChangeRate.text = [LNStockFormatter formatterChangeRateType:model.px_change_rate.floatValue];
    
    NSDateFormatter *dateFormatter = [LNStockFormatter sharedInstanceFormatter];
    [dateFormatter setDateFormat:@"HH:mm"];
    self.timeLabel.text = [dateFormatter stringFromDate:[LNStockHandler currentlyDate]];
    
    //颜色
    self.lastPrice.textColor = [LNStockFormatter priceColor:model.px_change.floatValue];
    self.priceChange.textColor = [LNStockFormatter priceColor:model.px_change.floatValue];
    self.priceChangeRate.textColor = [LNStockFormatter priceColor:model.px_change_rate.floatValue];
    
    //判断如果停牌颜色设置
    if ([[LNStockHandler tradeStatus] isEqualToString:@"HALT"] || model.trade_status.length == 0) {
        self.lastPrice.text = @"- -";
        self.priceChange.text = @"- -";
        self.priceChangeRate.text = @"- -";
        self.lastPrice.textColor = [LNStockColor stockHALT];
        self.priceChange.textColor = [LNStockColor stockHALT];
        self.priceChangeRate.textColor = [LNStockColor stockHALT];
    }
}

//刷新数据
- (void)refreshTitleData {
    [LNStockNetwork getStockRealDataWithCode:[LNStockHandler code] block:^(BOOL isSuccess, LNStockModel *model) {
        if (isSuccess) {
            [self refreshTitleData:model];
        }
    }];
}

@end
