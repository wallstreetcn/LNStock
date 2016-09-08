//
//  LNQuoteTrendInfo.m
//  Market
//
//  Created by vvusu on 5/26/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockTrendInfo.h"
#import "LNRealModel.h"
#import "LNStockHandler.h"
#import "LNStockColor.h"
#import "LNStockFormatter.h"

@implementation LNStockTrendInfo

-  (void)awakeFromNib {
    NSArray *titles = [NSArray array];
    if ([LNStockHandler isVerticalScreen]) {
        titles = @[@"现",@"均",@"幅",@"量"];
    }
    else {
        titles = @[@"现价",@"均价",@"涨跌幅",@"成交量"];
        self.priceConstraintW.constant = 25;
        self.avgConstraintW.constant = 25;
        self.chanteConstraintW.constant = 40;
        self.volumeConstraintW.constant = 40;
    }
    for (NSInteger i = 0; i < self.titles.count; i++) {
        UILabel *lable = self.titles[i];
        lable.text = titles[i];
    }
    
    //交易量
    [((UILabel *)self.contents[3]) setAdjustsFontSizeToFitWidth:YES];
    self.backgroundColor = [LNStockColor infoViewBG];
    if ([LNStockHandler isNightMode]) {
        ((UILabel *)self.contents[3]).textColor = [UIColor whiteColor];
    } else {
        ((UILabel *)self.contents[3]).textColor = [UIColor blackColor];
    }
}

+ (id)createWithXib {
    NSString *class = NSStringFromClass([self class]);
    return [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"LNStock.bundle/%@",class] owner:nil options:nil].firstObject;
}

- (void)setViewWithArray:(NSArray *)array Index:(NSInteger)index {
    LNRealModel *data = array[index];
    NSDateFormatter *dateFormatter = [LNStockFormatter sharedInstanceFormatter];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *createdAtString = [dateFormatter stringFromDate:data.date];
    self.timeLabel.text = createdAtString;
    
    CGFloat changeRate = ([data.price floatValue] - [data.preClosePx floatValue])/[data.preClosePx floatValue];
    ((UILabel *)self.contents[0]).text = [LNStockFormatter formatterDefaultType:[data.price floatValue]];
    ((UILabel *)self.contents[1]).text = [LNStockFormatter formatterDefaultType:[data.averagePrice floatValue]];
    ((UILabel *)self.contents[2]).text = [LNStockFormatter formatterChangeRateType:changeRate * 100];
    ((UILabel *)self.contents[3]).text = [LNStockFormatter volumeFormatterWithNum:[data.volume doubleValue]];
    
    if (changeRate > 0) {
        ((UILabel *)self.contents[0]).textColor = [LNStockColor priceUp];
        ((UILabel *)self.contents[1]).textColor = [LNStockColor priceUp];
        ((UILabel *)self.contents[2]).textColor = [LNStockColor priceUp];
    } else if (changeRate == 0) {
        ((UILabel *)self.contents[0]).textColor = [LNStockColor priceUp];
        ((UILabel *)self.contents[2]).textColor = [LNStockColor priceUp];
    } else {
        ((UILabel *)self.contents[0]).textColor = [LNStockColor priceDown];
        ((UILabel *)self.contents[2]).textColor = [LNStockColor priceDown];
    }
    
    //均价颜色比较
    if ([data.averagePrice floatValue] >= [data.preClosePx floatValue]) {
        ((UILabel *)self.contents[1]).textColor = [LNStockColor priceUp];
    } else {
        ((UILabel *)self.contents[1]).textColor = [LNStockColor priceDown];
    }
    
    //当指数有均价时删除
    if ([data.averagePrice floatValue] == -1) {
        ((UILabel *)self.contents[1]).text = @"--";
    }
}

@end
