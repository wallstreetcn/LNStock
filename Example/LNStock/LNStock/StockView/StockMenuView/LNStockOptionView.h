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

@interface LNStockOptionView : UIView
@property (nonatomic, copy) LNOptionViewBlock block;
- (void)setupColor;
@end
