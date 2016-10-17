//
//  LNStockOptionView.h
//  LNStock
//
//  Created by vvusu on 7/28/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LNOptionViewAction) {
    LNOptionViewAction_Adjust = 0,
    LNOptionViewAction_Factor
};

typedef void (^LNOptionViewBlock)(LNOptionViewAction type);
@class LNStockHandler;
@interface LNStockOptionView : UIView
@property (nonatomic, copy) LNOptionViewBlock block;
@property (nonatomic, weak) LNStockHandler *stockInfo;
- (void)setupColor;
- (void)updateOptionView;
- (instancetype)initWithFrame:(CGRect)frame stockInfo:(LNStockHandler *)stockInfo;
@end
