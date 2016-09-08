//
//  LNQuoteMenuView.h
//  Market
//
//  Created by vvusu on 5/26/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LNStockMenuBtn : UIButton
@end

typedef void (^LNStockMenuViewBlock)(NSInteger type);
@interface LNStockMenuView : UIView
@property (nonatomic, copy) LNStockMenuViewBlock block;
@property (nonatomic, assign, getter=isShowing) BOOL showing;
- (void)hiddenView;
@end
