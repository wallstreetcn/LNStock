//
//  LNQuoteBTitleView.h
//  Market
//
//  Created by ZhangBob on 5/5/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, LNStockBTitleViewAction) {
    LNStockBTitleViewAction_Refresh = 0,
    LNStockBTitleViewAction_Close
};

typedef void (^LNStockBTitleViewActionBlock)(LNStockBTitleViewAction);

@class LNStockModel,LNStockHandler;
@interface LNStockBTitleView : UIView

@property (weak, nonatomic) IBOutlet UILabel *stockName;
@property (weak, nonatomic) IBOutlet UILabel *lastPrice;
@property (weak, nonatomic) IBOutlet UILabel *priceChange;
@property (weak, nonatomic) IBOutlet UILabel *priceChangeRate;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (nonatomic, weak) LNStockHandler *stockInfo;
@property (copy, nonatomic) LNStockBTitleViewActionBlock block;

+ (id)createWithXib;
- (void)refreshTitleData:(LNStockModel *)model;
@end
