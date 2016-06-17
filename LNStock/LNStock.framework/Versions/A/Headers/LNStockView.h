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

@interface LNStockView : UIView
/*
    Stock的点击或双击手势回调
 */
@property (nonatomic, copy) LNStockViewBlock quotesViewBlock;
/*
    block会回调返回实时最新的数据
 */
@property (nonatomic, copy) LNStockViewDataBlock quotesViewDataBlock;
/*
    View的初始化方法
 */
+ (instancetype)createViewWithFrame:(CGRect)frame code:(NSString *)code isAstock:(BOOL)isAstock isNight:(BOOL)isNight;
/*
 View的初始化方法
 */
+ (instancetype)createViewWithCode:(NSString *)code isAstock:(BOOL)isAstock isNight:(BOOL)isNight;

@end
