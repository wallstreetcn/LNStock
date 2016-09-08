//
//  LNStockDealListCell.m
//  LNStock
//
//  Created by vvusu on 6/2/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockDealListCell.h"
#import "LNStockHandler.h"
#import "LNStockColor.h"
#import "LNStockFormatter.h"

@implementation LNStockDealListCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [LNStockColor stockViewBG];
    self.requestedPriceLabel.textColor = [LNStockColor priceUp];
    self.buyOrSaleLable.textColor = [LNStockColor detailListViewLabel];
    self.dealNumberLabel.textColor = [LNStockColor detailListViewLabel];
    if (![LNStockHandler isVerticalScreen]) {
        self.buyOrSaleLable.font = [UIFont systemFontOfSize:12];
        self.dealNumberLabel.font = [UIFont systemFontOfSize:12];
        self.requestedPriceLabel.font = [UIFont systemFontOfSize:12];
    }
}

+ (LNStockDealListCell *)createWithXib {
    NSString *className = NSStringFromClass([self class]);
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"LNStock.bundle/%@",className] owner:nil options:nil];
    return views[0];
}

- (void)setupCellWithDict:(NSDictionary *)dict {
    NSNumber *preClosePx = [dict valueForKey:@"preclose_px"];
    NSNumber *price = [dict valueForKey:@"RequestedPrice"];
    self.buyOrSaleLable.text = [dict valueForKey:@"BuyOrSale"];
    self.requestedPriceLabel.text = [LNStockFormatter formatterDefaultType:price.floatValue];
    self.dealNumberLabel.text = [NSString stringWithFormat:@"%.0f",[[dict valueForKey:@"DealNumber"] integerValue]/100.0];
    
    if (price.floatValue > preClosePx.floatValue) {
        self.requestedPriceLabel.textColor = [UIColor redColor];
    } else if (price.floatValue == preClosePx.floatValue) {
        if ([LNStockHandler isNightMode]) {
            self.requestedPriceLabel.textColor = [UIColor whiteColor];
        } else {
            self.requestedPriceLabel.textColor = [UIColor blackColor];
        }
    } else {
        self.requestedPriceLabel.textColor = [LNStockColor priceDown];
    }
    //判断如果停牌颜色设置
    if ([[LNStockHandler tradeStatus] isEqualToString:@"HALT"]) {
        self.requestedPriceLabel.textColor = [LNStockColor stockHALT];
    }
}

@end
