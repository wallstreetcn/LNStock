//
//  LNQuoteTitleView.h
//  Market
//
//  Created by ZhangBob on 5/5/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNStockHandler.h"
#import "LNStockDefine.h"
#import "LNRealModel.h"
#import "LNStockModel.h"

typedef NS_ENUM(NSInteger, LNStockTitleViewAction) {
    LNStockTitleViewAction_Refresh = 0,
    LNStockTitleViewAction_Close,
    LNStockTitleViewAction_UpDateTitleType,
    LNStockTitleViewAction_UpDateChartType
};

typedef void (^LNStockTitleActionBlock)(LNStockTitleViewAction titleActionType);

@interface LNStockTitleView : UIView
@property (nonatomic, strong) NSDictionary *Titledic;
@property (nonatomic, copy) LNStockTitleActionBlock actionBlock;
- (instancetype)initWithFrame:(CGRect)frame;

//轮询刷新竖版的title
- (void)setupColor;
- (void)hiddenInfoView;
- (void)refreshTitleView:(LNStockModel *)model;
- (void)changeChartTitleViewWithType:(LNStockTitleType)type;
- (void)setAChartTitleViewLastBtnWithType:(LNStockTitleType)type;
- (void)showInfoViewWithArray:(NSArray *)array Index:(NSInteger)index;

@end
