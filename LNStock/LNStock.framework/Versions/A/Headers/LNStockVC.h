//
//  LNQuotesVC.h
//  Market
//
//  Created by vvusu on 5/3/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNStockView.h"

@class LNStockHandler,LNStockModel;
@interface LNStockVC : UIViewController
@property (nonatomic, copy) NSString *code;  //股票Code
@property (nonatomic, assign) BOOL isAstock; //是否是A股
@property (nonatomic, strong) LNStockHandler *stockInfo;
@property (nonatomic, readonly) LNStockView *quotesView;

- (instancetype)initWithStockModel:(LNStockModel *)stockModel;
- (instancetype)initWithStockInfo:(LNStockHandler *)stockInfo;
+ (instancetype)initWithStockModel:(LNStockModel *)stockModel;
+ (instancetype)initWithStockInfo:(LNStockHandler *)stockInfo;
@end
