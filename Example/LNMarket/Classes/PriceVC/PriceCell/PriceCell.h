//
//  PriceCell.h
//  Market
//
//  Created by ZhangBob on 4/25/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriceCellModel.h"
@interface PriceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsDateLabel;

+ (PriceCell *)createWithXib;
- (void)addThemeChangedWithMode:(BOOL)isNightMode;
- (void)setupCellWithModel:(PriceCellModel *)priceCellModel;
@end
