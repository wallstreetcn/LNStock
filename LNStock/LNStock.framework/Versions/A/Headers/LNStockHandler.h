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

typedef NS_ENUM(NSUInteger, LNStockPriceType) {
    LNStockPriceTypeA = 0,
    LNStockPriceTypeB
};

@interface LNStockHandler : NSObject
@property (nonatomic, copy) NSString *code;                 //股票Code
@property (nonatomic, assign) LNStockTitleType chartType;
@property (nonatomic, assign) LNStockPriceType priceType;  //A B 股
@property (nonatomic, assign, getter=isNightMode) BOOL nightMode;
@property (nonatomic, assign, getter=isVerticalScreen) BOOL verticalScreen;

+(LNStockHandler *)sharedManager;
+ (NSString *)code;
+ (BOOL)isNightMode;
+ (BOOL)isVerticalScreen;
+ (LNStockTitleType)chartType;
+ (LNStockPriceType)priceType;
@end
