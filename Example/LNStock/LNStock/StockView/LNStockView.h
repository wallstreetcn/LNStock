//
//  LNQuotesView.h
//  Market
//
//  Created by vvusu on 4/28/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LNStockViewActionType) {
    LNStockViewActionTypeTapOne = 0,
    LNStockViewActionTypeTapTwo,
};

typedef void (^LNStockViewDataBlock)(id model);
typedef void (^LNStockViewBlock)(LNStockViewActionType type);

@class LNStockHandler;
@interface LNStockView : UIView
@property (nonatomic, assign) BOOL isGreenUp;   //是否是绿涨红跌
@property (nonatomic, assign) BOOL isNightMode; //是否是夜晚模式
@property (nonatomic, copy) LNStockViewBlock quotesViewBlock;         //Stock的点击或双击手势回调
@property (nonatomic, copy) LNStockViewDataBlock quotesViewDataBlock; //block会回调返回实时最新的数据

/*
    View的初始化方法 LNStock横版专用
 */
+ (instancetype)createWithStockInfo:(LNStockHandler *)stockInfo frame:(CGRect)frame;

/*
    View的初始化方法(默认大小)
 */
+ (instancetype)createViewWithCode:(NSString *)code isAstock:(BOOL)isAstock isNight:(BOOL)isNight;

/*
    View的初始化方法 自定义大小 - 头部的高度不变
 */
+ (instancetype)createViewWithFrame:(CGRect)frame code:(NSString *)code isAstock:(BOOL)isAstock isNight:(BOOL)isNight;

/*
    刷新行情数据
 */
- (void)refreshStockData;

/*
    停止轮询
 */
- (void)stopPollRequest;

/*
    开始轮询
 */
- (void)startPollRequest;
@end
