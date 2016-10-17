//
//  LNStockLayout.m
//  LNStock
//
//  Created by vvusu on 10/9/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockLayout.h"
#import "LNStockHandler.h"

@implementation LNStockLayout

- (instancetype)init {
    if (self = [super init]) {
        _listViewW = 0;
        _headerViewH = 0;
        _bottomChartViewH = 0;
        _titleViewH = kFStockTitleViewH;
    }
    return self;
}

- (void)defaultSetWithIsAStock:(BOOL)isAStock {
    _stockViewW = self.stockFrame.size.width;
    _stockViewH = self.stockFrame.size.height;
    if (isAStock) {
        _listViewW = [LNStockHandler isVerticalScreen] ? 100 : 140;
        _headerViewH = [LNStockHandler isVerticalScreen] ? kFStockAHeaderH : 0;
        _titleViewH = [LNStockHandler isVerticalScreen] ? kFStockTitleViewH : 90;
        _bottomChartViewH = (NSInteger)((_stockViewH - _titleViewH - _headerViewH) / 4);
    }
    else {
        _headerViewH = [LNStockHandler isVerticalScreen] ? kFStockBHeaderH : 0;
        _titleViewH = [LNStockHandler isVerticalScreen] ? kFStockTitleViewH : 90;
    }
}

@end
