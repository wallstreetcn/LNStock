//
//  PriceVC.h
//  Market
//
//  Created by ZhangBob on 4/22/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceVC : UIViewController

+ (instancetype)createWithTitle:(NSString *)navTitle
                       subtitle:(NSString *)subtitle
                         symbol:(NSString *)symbol
                    isNightMode:(BOOL)isNightMode
                       isAStock:(BOOL)isAStock;

@end
