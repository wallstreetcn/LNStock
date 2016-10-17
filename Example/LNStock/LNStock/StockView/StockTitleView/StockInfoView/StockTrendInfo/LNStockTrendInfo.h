//
//  LNQuoteTrendInfo.h
//  Market
//
//  Created by vvusu on 5/26/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LNStockHandler;
@interface LNStockTrendInfo : UIView
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titles;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *contents;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceConstraintW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avgConstraintW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chanteConstraintW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *volumeConstraintW;
@property (nonatomic, weak) LNStockHandler *stockInfo;

+ (id)createWithXib;
- (void)setViewWithArray:(NSArray *)array Index:(NSInteger)index;

@end
