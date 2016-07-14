//
//  PriceCell.m
//  Market
//
//  Created by ZhangBob on 4/25/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "PriceCell.h"
#import "PriceDefine.h"

@implementation PriceCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (PriceCell *)createWithXib {
    NSString *className = NSStringFromClass([self class]);
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil];
    return views[0];
}

- (void)addThemeChangedWithMode:(BOOL)isNightMode {
    if (isNightMode) {
        self.newsTitleLabel.textColor = kSCNCellLabel;
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor blackColor];
    }else {
        self.newsTitleLabel.textColor = kSCDCellLabel;
        
    }
}

- (void)setupCellWithModel:(PriceCellModel *)priceCellModel {
    self.newsTitleLabel.text = priceCellModel.title;
    NSTimeInterval time = [priceCellModel.createdAt doubleValue];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *createdAtString = [dateFormatter stringFromDate:detaildate];
    self.newsDateLabel.text = createdAtString;
}

@end
