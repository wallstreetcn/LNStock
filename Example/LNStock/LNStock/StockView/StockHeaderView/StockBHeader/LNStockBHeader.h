//
//  PriceBStockHeaderView.h
//  Market
//
//  Created by ZhangBob on 4/22/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LNStockModel;
@interface LNStockBHeader : UIView

@property (weak, nonatomic) IBOutlet UILabel *lastPx;           //最新价
@property (weak, nonatomic) IBOutlet UILabel *trade_status;     //交易状态
@property (weak, nonatomic) IBOutlet UILabel *time;             //时间

@property (weak, nonatomic) IBOutlet UILabel *pxChange;         //涨跌额
@property (weak, nonatomic) IBOutlet UILabel *pxChangeRate;     //涨跌幅

@property (weak, nonatomic) IBOutlet UILabel *closePx;          //昨收
@property (weak, nonatomic) IBOutlet UILabel *openPx;           //今开
@property (weak, nonatomic) IBOutlet UILabel *buyPx;            //买价
@property (weak, nonatomic) IBOutlet UILabel *sellPx;           //卖价

@property (weak, nonatomic) IBOutlet UILabel *highPx;           //最高
@property (weak, nonatomic) IBOutlet UILabel *lowPx;            //最低
@property (weak, nonatomic) IBOutlet UILabel *lowPx_52;         //52周最低
@property (weak, nonatomic) IBOutlet UILabel *highPx_52;        //52周最高

@property (weak, nonatomic) IBOutlet UIView *borderView;
@property (weak, nonatomic) IBOutlet UIImageView *divideLineImageView;

+ (id)createWithXib;
- (void)setupColors;
- (void)setupDataWith:(LNStockModel *)priceData;
@end
