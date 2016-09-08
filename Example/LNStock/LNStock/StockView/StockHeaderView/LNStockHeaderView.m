//
//  LNStockHeaderView.m
//  LNStock
//
//  Created by vvusu on 6/17/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockHeaderView.h"
#import "LNStockHandler.h"
#import "LNStockAHeader.h"
#import "LNStockBHeader.h"
#import "LNStockModel.h"

@interface LNStockHeaderView ()
@property (nonatomic, strong) LNStockAHeader *AHeaderView;
@property (nonatomic, strong) LNStockBHeader *BHeaderView;
@end

@implementation LNStockHeaderView

- (instancetype)init {
    if (self = [super init]) {
        if ([LNStockHandler priceType] == LNStockPriceTypeA) {
            self.frame = CGRectMake(0, 0, kFBaseWidth, kFStockAHeaderH);
            self.AHeaderView = [LNStockAHeader createWithXib];
            self.AHeaderView.frame = self.bounds;
            [self addSubview:self.AHeaderView];
        } else {
            self.frame = CGRectMake(0, 0, kFBaseWidth, kFStockBHeaderH);
            self.BHeaderView = [LNStockBHeader createWithXib];
            self.BHeaderView.frame = self.bounds;
            [self addSubview:self.BHeaderView];
        }
    }
    return self;
}

- (void)updateStockData:(LNStockModel *)model {
    if ([LNStockHandler priceType] == LNStockPriceTypeA) {
        [self.AHeaderView setupDataWith:model];
    } else {
        [self.BHeaderView setupDataWith:model];
    }
}

- (void)setupColor {
    if ([LNStockHandler isVerticalScreen]) {
        if ([LNStockHandler priceType] == LNStockPriceTypeA) {
            [self.AHeaderView setupColors];
        } else {
            [self.BHeaderView setupColors];
        }        
    }
}

@end
