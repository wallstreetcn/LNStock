//
//  PriceBStockHeaderView.m
//  Market
//
//  Created by ZhangBob on 4/22/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "PriceBStockHeaderView.h"
#import "PriceDefine.h"
@implementation PriceBStockHeaderView

- (void)awakeFromNib {
    self.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 172);
}

+ (id)createWithXib {
    NSString *className = NSStringFromClass([self class]);
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil];
    return views[0];
}

- (void)addThemeChangedWithMode:(BOOL)isNightMode {
    if (isNightMode) {
        self.borderView.backgroundColor = kSCNBorder;
        self.divideLineImageView.image = [UIImage imageNamed:@"quote_bordernight"];
    }else {
        self.borderView.backgroundColor = kSCDBorder;
        self.divideLineImageView.image = [UIImage imageNamed:@"quote_borderday"];
    }
}

@end
