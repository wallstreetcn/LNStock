//
//  LNStockHeaderView.h
//  LNStock
//
//  Created by vvusu on 6/17/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LNStockModel;
@interface LNStockHeaderView : UIView
- (void)setupColor;
- (void)updateStockData:(LNStockModel *)model;
@end
