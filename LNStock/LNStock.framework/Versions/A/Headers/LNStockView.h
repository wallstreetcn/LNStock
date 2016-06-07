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
@property (nonatomic, copy) LNStockViewBlock quotesViewBlock;
@property (nonatomic, copy) LNStockViewDataBlock quotesViewDataBlock;

+ (instancetype)createViewWithFrame:(CGRect)frame code:(NSString *)code isAstock:(BOOL)isAstock isNight:(BOOL)isNight;
@end
