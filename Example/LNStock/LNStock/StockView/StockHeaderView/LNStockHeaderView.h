//
//  LNStockHeaderView.h
//  LNStock
//
//  Created by vvusu on 6/17/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LNStockModel,LNStockHandler;
@interface LNStockHeaderView : UIView
@property (nonatomic, weak) LNStockHandler *stockInfo;
- (void)setupColor;
- (void)updateStockData:(LNStockModel *)model;
- (instancetype)initWithStockInfo:(LNStockHandler *)stockInfo;
@end
