//
//  LNQuotesSelectView.h
//  Market
//
//  Created by vvusu on 5/26/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNStockHandler.h"

typedef void (^LNStockSelectViewBlock)(NSInteger type);

@class LNStockHandler;
@interface LNStockSelectView : UIView
@property (nonatomic, assign) CGFloat itemW;
@property (nonatomic, assign) CGFloat itemH;
@property (nonatomic, weak) LNStockHandler *stockInfo;
@property (nonatomic, copy) LNStockSelectViewBlock block;

- (void)setupColor;
- (void)changeBtnTitleWithType:(LNStockTitleType)type;
- (instancetype)initWithFrame:(CGRect)frame stockInfo:(LNStockHandler *)stockInfo;
@end
