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
#import "LNStockLayout.h"

@interface LNStockHeaderView ()
@property (nonatomic, strong) LNStockAHeader *AHeaderView;
@property (nonatomic, strong) LNStockBHeader *BHeaderView;
@end

@implementation LNStockHeaderView

- (instancetype)initWithStockInfo:(LNStockHandler *)stockInfo {
    if (self = [super init]) {
        self.stockInfo = stockInfo;
        if ([self.stockInfo isAStock]) {
            self.frame = CGRectMake(0, 0, kFBaseWidth, kFStockAHeaderH);
            self.AHeaderView = [LNStockAHeader createWithXib];
            self.AHeaderView.stockInfo = self.stockInfo;
            self.AHeaderView.frame = self.bounds;
            [self addSubview:self.AHeaderView];
        } else {
            self.frame = CGRectMake(0, 0, kFBaseWidth, kFStockBHeaderH);
            self.BHeaderView = [LNStockBHeader createWithXib];
            self.BHeaderView.frame = self.bounds;
            self.BHeaderView.stockInfo = self.stockInfo;
            [self addSubview:self.BHeaderView];
        }
    }
    return self;
}

- (void)updateStockData:(LNStockModel *)model {
    if ([self.stockInfo isAStock]) {
        [self.AHeaderView setupDataWith:model];
    } else {
        [self.BHeaderView setupDataWith:model];
    }
}

- (void)setupColor {
    if ([LNStockHandler isVerticalScreen]) {
        if ([self.stockInfo isAStock]) {
            [self.AHeaderView setupColors];
        } else {
            [self.BHeaderView setupColors];
        }        
    }
}

@end
