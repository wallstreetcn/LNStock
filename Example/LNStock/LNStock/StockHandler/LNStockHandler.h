//
//  QuoteHandler.h
//  Market
//
//  Created by ZhangBob on 5/6/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNStockDefine.h"

typedef NS_ENUM(NSUInteger, LNStockViewSite) {
    LNStockViewSiteVertical = 0,
    LNStockViewSiteHorizontal
};

typedef NS_ENUM(NSInteger, LNStockChartType) {
    LNStockChartType_Line = 0,
    LNStockChartType_Candles,
    LNStockChartType_HollowCandle,
    LNStockChartType_Bars
};

//AB股
typedef NS_ENUM(NSUInteger, LNStockPriceType) {
    LNStockPriceTypeA = 0,
    LNStockPriceTypeB
};

@class LNStockModel;
@interface LNStockHandler : NSObject
//单例
@property (nonatomic, assign) LNStockTitleType titleType;                   //titelle
@property (nonatomic, assign) LNStockChartType chartType;                   //Chart类型
@property (nonatomic, assign) LNStockAdjustType adjustType;                 //复权类型
@property (nonatomic, assign) LNStockFactorType factorType;                 //股指类型
@property (nonatomic, assign, getter=isGreenUp) BOOL greenUp;               //是否是绿涨红跌
@property (nonatomic, assign, getter=isNightMode) BOOL nightMode;           //是否是夜晚模式
@property (nonatomic, assign, getter=isVerticalScreen) BOOL verticalScreen; //是否是竖屏
//实例
@property (nonatomic, copy) NSString *code;                                 //股票Code
@property (nonatomic, copy) NSString *stocktype;                            //股票类型
@property (nonatomic, copy) NSString *tradeStatus;                          //交易状态
@property (nonatomic, strong) NSDate *currentlyDate;                        //最后交易时间
@property (nonatomic, strong) NSNumber *price_precision;                    //价格保留位数
@property (nonatomic, assign) LNStockPriceType priceType;                   //A B 股
@property (nonatomic, assign, getter=isLongPress) BOOL longPress;           //是否是长按高亮

//重置设置
+ (void)resetData;
//是否是绿涨红跌
+ (BOOL)isGreenUp;
//是否是夜晚模式
+ (BOOL)isNightMode;
//是否是竖屏
+ (BOOL)isVerticalScreen;
//title类型
+ (LNStockTitleType)titleType;
//图的类型
+ (LNStockChartType)chartType;
//复权类型
+ (LNStockAdjustType)adjustType;
//因子类型
+ (LNStockFactorType)factorType;
//单例
+ (LNStockHandler *)sharedManager;
//通过model生成
+ (LNStockHandler *)setupWithStockModel:(LNStockModel *)model;

//默认设置
- (void)defaultSet;
//判断是否是A股股票
- (BOOL)isStock;
//判断是否是AStock
- (BOOL)isAStock;
//是否是A股指数
- (BOOL)isIndexStock;
//判断是否是基金
- (BOOL)isFundStock;
//判断是否在交易中
- (BOOL)isTRADE;
//价格保留位数
- (NSString *)pricePrecision;
//股票状态返回格式为显示信息
- (NSString *)tradeStatusContents;

@end
