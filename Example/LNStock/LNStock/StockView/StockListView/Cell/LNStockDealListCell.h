//
//  LNStockDealListCell.h
//  LNStock
//
//  Created by vvusu on 6/2/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LNStockDealListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *buyOrSaleLable;
@property (weak, nonatomic) IBOutlet UILabel *dealNumberLabel;     //购买数量
@property (weak, nonatomic) IBOutlet UILabel *requestedPriceLabel; //价格

+ (LNStockDealListCell *)createWithXib;
- (void)setupCellWithDict:(NSDictionary *)dict;
@end
