//
//  PriceBStockHeaderView.h
//  Market
//
//  Created by ZhangBob on 4/22/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceBStockHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIView *borderView;
@property (weak, nonatomic) IBOutlet UIImageView *divideLineImageView;

+ (id)createWithXib;
- (void)addThemeChangedWithMode:(BOOL)isNightMode;
@end
