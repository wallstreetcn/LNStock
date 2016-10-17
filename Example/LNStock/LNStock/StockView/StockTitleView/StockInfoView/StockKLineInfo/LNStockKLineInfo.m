//
//  LNQuoteKLineInfo.m
//  Market
//
//  Created by vvusu on 5/26/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockKLineInfo.h"
#import "LNStockHandler.h"
#import "LNRealModel.h"
#import "LNStockColor.h"
#import "LNStockFormatter.h"

@implementation LNStockKLineInfo
-  (void)awakeFromNib {
    [super awakeFromNib];
    [((UILabel *)self.contentLabels[5]) setAdjustsFontSizeToFitWidth:YES];
    self.backgroundColor = [LNStockColor infoViewBG];
    
    if ([LNStockHandler isNightMode]) {
        self.time.textColor = [UIColor whiteColor];
        ((UILabel *)self.contentLabels[5]).textColor = [UIColor whiteColor];
    } else {
        self.time.textColor = [UIColor blackColor];
        ((UILabel *)self.contentLabels[5]).textColor = [UIColor blackColor];
    }
}

+ (id)createXibWithIndex:(NSInteger)index {
    NSString *xibName = NSStringFromClass([self class]);
    if (!xibName) {
        id temp = [[[self class]alloc]init];
        return temp;
    }
    else {
        NSArray *nibView = [[NSBundle mainBundle]loadNibNamed:[NSString stringWithFormat:@"LNStock.bundle/%@",xibName] owner:nil options:nil];
        return [nibView objectAtIndex:index];
    }
}

- (void)setViewWithArray:(NSArray *)array Index:(NSInteger)index {
    
    LNRealModel *preData;
    if (index == 0) {
        preData = array.firstObject;
    }
    else {
        preData = array[index -1];
    }
    
    if (index > array.count - 1) {
        index = array.count - 1;
    }
    LNRealModel *data = array[index];
    NSDateFormatter *dateFormatter = [LNStockFormatter sharedInstanceFormatter];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    self.time.text = [dateFormatter stringFromDate:data.date];
    //高
    ((UILabel *)self.contentLabels[0]).text = [LNStockFormatter formatterDefaultType:[self.stockInfo pricePrecision] num:[data.high floatValue]];
    //开
    ((UILabel *)self.contentLabels[1]).text = [LNStockFormatter formatterDefaultType:[self.stockInfo pricePrecision] num:[data.open floatValue]];
    //低
    ((UILabel *)self.contentLabels[2]).text = [LNStockFormatter formatterDefaultType:[self.stockInfo pricePrecision] num:[data.low floatValue]];
    //收
    ((UILabel *)self.contentLabels[3]).text = [LNStockFormatter formatterDefaultType:[self.stockInfo pricePrecision] num:[data.close floatValue]];
    
    //设置涨跌幅
    CGFloat change = [data.close floatValue] - [preData.close floatValue];
    CGFloat changeRate = change/[preData.close floatValue];
    ((UILabel *)self.contentLabels[4]).text = [LNStockFormatter formatterChangeRateType:changeRate * 100];
    
    //成交量
    ((UILabel *)self.contentLabels[5]).text = [LNStockFormatter volumeFormatterWithNum:[data.volume doubleValue]];
    
    if (data.high.floatValue >= preData.close.floatValue) {
        ((UILabel *)self.contentLabels[0]).textColor = [LNStockColor priceUp];
    } else {
        ((UILabel *)self.contentLabels[0]).textColor = [LNStockColor priceDown];
    }
    
    if (data.open.floatValue >= preData.close.floatValue) {
        ((UILabel *)self.contentLabels[1]).textColor = [LNStockColor priceUp];
    }else {
        ((UILabel *)self.contentLabels[1]).textColor = [LNStockColor priceDown];
    }
    
    if (data.low.floatValue >= preData.close.floatValue) {
        ((UILabel *)self.contentLabels[2]).textColor = [LNStockColor priceUp];
    } else {
        ((UILabel *)self.contentLabels[2]).textColor = [LNStockColor priceDown];
    }
    
    if (data.close.floatValue >= preData.close.floatValue) {
        ((UILabel *)self.contentLabels[3]).textColor = [LNStockColor priceUp];
    }else {
        ((UILabel *)self.contentLabels[3]).textColor = [LNStockColor priceDown];
    }
    
    if (changeRate >=0) {
        ((UILabel *)self.contentLabels[4]).textColor = [LNStockColor priceUp];
    } else {
        ((UILabel *)self.contentLabels[4]).textColor = [LNStockColor priceDown];
    }
}

@end

@implementation LNStockKLineInfoH

- (void)setViewWithArray:(NSArray *)array Index:(NSInteger)index {
    LNRealModel *preData;
    if (index == 0) {
        preData = array.firstObject;
    }
    else {
        preData = array[index -1];
    }
    
    if (index > array.count - 1) {
        index = array.count - 1;
    }
    LNRealModel *data = array[index];
    NSDateFormatter *dateFormatter = [LNStockFormatter sharedInstanceFormatter];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
     self.timeLabel.text = [dateFormatter stringFromDate:data.date];
    //高
    ((UILabel *)self.contents[0]).text = [LNStockFormatter formatterDefaultType:[self.stockInfo pricePrecision] num:[data.high floatValue]];
    //开
    ((UILabel *)self.contents[1]).text = [LNStockFormatter formatterDefaultType:[self.stockInfo pricePrecision] num:[data.open floatValue]];
    //低
    ((UILabel *)self.contents[2]).text = [LNStockFormatter formatterDefaultType:[self.stockInfo pricePrecision] num:[data.low floatValue]];
    //收
    ((UILabel *)self.contents[3]).text = [LNStockFormatter formatterDefaultType:[self.stockInfo pricePrecision] num:[data.close floatValue]];
    
    //设置涨跌幅
    CGFloat change = [data.close floatValue] - [preData.close floatValue];
    CGFloat changeRate = change/[preData.close floatValue];
    ((UILabel *)self.contents[4]).text = [LNStockFormatter formatterChangeRateType:changeRate * 100];
    
    if (data.high.floatValue >= preData.close.floatValue) {
       ((UILabel *)self.contents[0]).textColor = [LNStockColor priceUp];
    } else {
        ((UILabel *)self.contents[0]).textColor = [LNStockColor priceDown];
    }
    
    if (data.open.floatValue >= preData.close.floatValue) {
        ((UILabel *)self.contents[1]).textColor = [LNStockColor priceUp];
    } else {
        ((UILabel *)self.contents[1]).textColor = [LNStockColor priceDown];
    }
    
    if (data.low.floatValue >= preData.close.floatValue) {
        ((UILabel *)self.contents[2]).textColor = [LNStockColor priceUp];
    } else {
        ((UILabel *)self.contents[2]).textColor = [LNStockColor priceDown];
    }
    
    if (data.close.floatValue >= preData.close.floatValue) {
        ((UILabel *)self.contents[3]).textColor = [LNStockColor priceUp];
    } else {
        ((UILabel *)self.contents[3]).textColor = [LNStockColor priceDown];
    }
    
    if (changeRate >=0) {
        ((UILabel *)self.contents[4]).textColor = [LNStockColor priceUp];
    } else {
        ((UILabel *)self.contents[4]).textColor = [LNStockColor priceDown];
    }
}

@end
