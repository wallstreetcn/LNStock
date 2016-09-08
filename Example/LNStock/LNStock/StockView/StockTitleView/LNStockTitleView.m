//
//  LNQuoteTitleView.m
//  Market
//
//  Created by ZhangBob on 5/5/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockTitleView.h"
#import "LNStockSelectView.h"
#import "LNStockATitleView.h"
#import "LNStockBTitleView.h"
#import "LNStockTrendInfo.h"
#import "LNStockKLineInfo.h"
#import "LNStockDefine.h"
#import "LNStockColor.h"

@interface LNStockTitleView()
@property (nonatomic, strong) LNStockATitleView *ATitleView;
@property (nonatomic, strong) LNStockBTitleView *BTitleView;
@property (nonatomic, strong) LNStockSelectView *selectView;
@property (nonatomic, strong) LNStockTrendInfo *trendInfoView;
@property (nonatomic, strong) LNStockKLineInfo *kLineInfoView;
@end

@implementation LNStockTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self setupColor];
    //添加头部试图
    if (![LNStockHandler isVerticalScreen]) {
        if ([LNStockHandler priceType] == LNStockPriceTypeA) {
            [self addSubview:self.ATitleView];
        } else {
            [self addSubview:self.BTitleView];
        }
    }
    //添加选择试图
    [self addSubview:self.selectView];
}

- (LNStockATitleView *)ATitleView {
    __weak typeof (self)wself = self;
    if (!_ATitleView) {
        _ATitleView = [LNStockATitleView createWithXib];
        _ATitleView.frame = CGRectMake(0, 0, self.frame.size.width, 40);
        _ATitleView.backgroundColor = self.backgroundColor;
        _ATitleView.block = ^(LNStockATitleViewAction action) {
            switch (action) {
                case LNStockATitleViewAction_Refresh:
                    if (wself.actionBlock) {
                        wself.actionBlock(LNStockTitleViewAction_Refresh);
                    }
                    break;
                case LNStockATitleViewAction_Close:
                    if (wself.actionBlock) {
                        wself.actionBlock(LNStockTitleViewAction_Close);
                    }
                    break;
            }
        };
    }
    return _ATitleView;
}

- (LNStockBTitleView *)BTitleView {
    if (!_BTitleView) {
        __weak typeof (self)wself = self;
        _BTitleView = [LNStockBTitleView createWithXib];
        _BTitleView.frame = CGRectMake(0, 0, self.frame.size.width, 40);
        _BTitleView.block = ^(LNStockBTitleViewAction action) {
            switch (action) {
                case LNStockBTitleViewAction_Refresh:
                    if (wself.actionBlock) {
                        wself.actionBlock(LNStockTitleViewAction_Refresh);
                    }
                    break;
                case LNStockBTitleViewAction_Close:
                    if (wself.actionBlock) {
                        wself.actionBlock(LNStockTitleViewAction_Close);
                    }
                    break;
            }
        };
    }
    return _BTitleView;
}

- (LNStockTrendInfo *)trendInfoView {
    if (!_trendInfoView) {
        _trendInfoView = [LNStockTrendInfo createWithXib];
        if ([LNStockHandler isVerticalScreen]) {
            _trendInfoView.frame = CGRectMake(0,0, self.frame.size.width, 40);
        } else {
            _trendInfoView.frame = CGRectMake(0,40, self.frame.size.width, 40);
        }
    }
    return _trendInfoView;
}

- (LNStockKLineInfo *)kLineInfoView {
    if (!_kLineInfoView) {
        if ([LNStockHandler isVerticalScreen]) {
            _kLineInfoView = [LNStockKLineInfo createXibWithIndex:0];
            _kLineInfoView.frame = CGRectMake(0,0, self.frame.size.width, 45);
        } else {
            _kLineInfoView = [LNStockKLineInfo createXibWithIndex:1];
            _kLineInfoView.frame = CGRectMake(0,40, self.frame.size.width, 40);
        }
    }
    return _kLineInfoView;
}

- (LNStockSelectView *)selectView {
    if (!_selectView) {
        __weak typeof(self) wself= self;
        if ([LNStockHandler sharedManager].isVerticalScreen) {
            _selectView = [[LNStockSelectView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        } else {
            _selectView = [[LNStockSelectView alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, 40)];
        }
        __block LNStockTitleType titleType = LNChartTitleType_NULL;
        _selectView.block = ^(NSInteger type) {
            if ([LNStockHandler priceType] == LNStockPriceTypeA) {
                switch (type) {
                    case 0:
                        titleType = LNChartTitleType_1m;
                        break;
                    case 1:
                        titleType = LNChartTitleType_5D;
                        break;
                    case 2:
                        titleType = LNChartTitleType_1D;
                        break;
                    case 3:
                        titleType = LNChartTitleType_1W;
                        break;
                    case 4:
                        titleType = LNChartTitleType_1M;
                        break;
                    case 5:
                        titleType = LNChartTitleType_NULL;
                        break;
                    default:
                        break;
                }
            }
            else {
                switch (type) {
                    case 0:
                        titleType = LNChartTitleType_1m;
                        break;
                    case 1:
                        titleType = LNChartTitleType_5m;
                        break;
                    case 2:
                        titleType = LNChartTitleType_15m;
                        break;
                    case 3:
                        titleType = LNChartTitleType_30m;
                        break;
                    case 4:
                        titleType = LNChartTitleType_1H;
                        break;
                    case 5:
                        titleType = LNChartTitleType_2H;
                        break;
                    case 6:
                        titleType = LNChartTitleType_4H;
                        break;
                    case 7:
                        titleType = LNChartTitleType_1D;
                        break;
                    case 8:
                        titleType = LNChartTitleType_1W;
                        break;
                    case 9:
                        titleType = LNChartTitleType_1M;
                        break;
                    case 10:
                        titleType = LNChartTitleType_NULL;
                        break;
                    default:
                        break;
                }
            }
            if (titleType != LNChartTitleType_NULL) {
                [LNStockHandler sharedManager].titleType = titleType;
                if (wself.actionBlock) {
                    wself.actionBlock(LNStockTitleViewAction_UpDateTitleType);
                }
            } else {
                if (wself.actionBlock) {
                    wself.actionBlock(LNStockTitleViewAction_UpDateChartType);
                }
            }
        };
    }
    return _selectView;
}

- (void)setupColor {
    self.backgroundColor = [LNStockColor stockViewBG];
    [self.selectView setupColor];
}

#pragma mark - set aChartTitleView
- (void)setAChartTitleViewLastBtnWithType:(LNStockTitleType)type {
    NSInteger i = type;
    [self.selectView setMinBtnTitleWithIndex:i - 1];
}

- (void)changeChartTitleViewWithType:(LNStockTitleType)type {
    [self.selectView changeBtnTitleWithType:type];
}

#pragma mark - 显示不同的Info View
- (void)showInfoViewWithArray:(NSArray *)array Index:(NSInteger)index {
    if ([LNStockHandler priceType] == LNStockPriceTypeA) {
        switch ([LNStockHandler titleType]) {
            case LNChartTitleType_1m:
            case LNChartTitleType_5D: {
                [self addSubview:self.trendInfoView];
                [self.trendInfoView setViewWithArray:array Index:index];
            }
                break;
            default: {
                [self addSubview:self.kLineInfoView];
                [self.kLineInfoView setViewWithArray:array Index:index];
            }
                break;
        }
    } else {
        
    }
}

- (void)hiddenInfoView {
    [self.trendInfoView removeFromSuperview];
    [self.kLineInfoView removeFromSuperview];
}

//轮询刷新竖版的title
- (void)refreshTitleView:(LNStockModel *)model {
    if ([LNStockHandler priceType] == LNStockPriceTypeA){
        [self.ATitleView refreshTitleData:model];
    } else {
        [self.BTitleView refreshTitleData:model];
    }
}

@end
