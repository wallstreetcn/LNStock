//
//  LNQuoteATitleView.h
//  Market
//
//  Created by ZhangBob on 5/5/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNStockModel.h"

typedef NS_ENUM(NSInteger, LNStockATitleViewAction) {
    LNStockATitleViewAction_Refresh = 0,
    LNStockATitleViewAction_Close
};

typedef void (^LNStockATitleViewActionBlock)(LNStockATitleViewAction);

@class LNStockHandler;
@interface LNStockATitleView : UIView

@property (weak, nonatomic) IBOutlet UILabel *stockName;
@property (weak, nonatomic) IBOutlet UILabel *lastPrice;
@property (weak, nonatomic) IBOutlet UILabel *businessAmount;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceChange;
@property (weak, nonatomic) IBOutlet UILabel *priceChangeRate;
@property (nonatomic, weak) LNStockHandler *stockInfo; 
@property (copy, nonatomic) LNStockATitleViewActionBlock block;

+ (id)createWithXib;
- (void)refreshTitleData:(LNStockModel *)model;
- (void)setAtitleViewWithDictionary:(NSDictionary *)dic;
@end
