//
//  PriceAStockHeaderView.h
//  Market
//
//  Created by ZhangBob on 4/22/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "PriceAStockHeaderDataModel.h"
@interface PriceAStockHeaderView : UIView

//行情数据的命名与恒生接口的Key相匹配，px即为price
//TopView
//TopLeftView
@property (weak, nonatomic) IBOutlet UILabel *lastPx;           //最新价
@property (weak, nonatomic) IBOutlet UILabel *pxChange;         //涨跌额
@property (weak, nonatomic) IBOutlet UILabel *pxChangeRate;     //涨跌幅

//TopRightView
@property (weak, nonatomic) IBOutlet UILabel *openPx;           //今开
@property (weak, nonatomic) IBOutlet UILabel *closePx;          //昨收
@property (weak, nonatomic) IBOutlet UILabel *businessAmount;   //成交量
@property (weak, nonatomic) IBOutlet UILabel *turnoverRatio;    //换手率

//BottomView
//BottomLeftView
@property (weak, nonatomic) IBOutlet UILabel *highPx;           //最高
@property (weak, nonatomic) IBOutlet UILabel *lowPx;            //最低
@property (weak, nonatomic) IBOutlet UILabel *peRate;           //市盈率
@property (weak, nonatomic) IBOutlet UILabel *amplitude;        //振幅

//BottomRightView
@property (weak, nonatomic) IBOutlet UILabel *businessAmountIn; //内盘
@property (weak, nonatomic) IBOutlet UILabel *businessAmountOut;//外盘
@property (weak, nonatomic) IBOutlet UILabel *marketValue;      //总市值
@property (weak, nonatomic) IBOutlet UILabel *circulationValue; //流通市值

@property (weak, nonatomic) IBOutlet UIView *borderView;
@property (weak, nonatomic) IBOutlet UIImageView *divideLineImageView;

@property (assign, nonatomic) BOOL isNightMode;

+ (id)createWithXib;

- (void)addThemeChangedWithMode:(BOOL)isNightMode;

- (void)setPriceHeaderLabelsWithData:(PriceAStockHeaderDataModel *)priceData;

@end
