//
//  LNQuoteMenuView.m
//  Market
//
//  Created by vvusu on 5/26/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockMenuView.h"
#import "UIControl+LNStock.h"

@interface LNStockMenuView()
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIImageView *triangleImageView;
@end

@implementation LNStockMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 4, 50, 100)];
    self.menuView.backgroundColor = [UIColor grayColor];
    self.menuView.layer.cornerRadius = 3.0;
    self.menuView.layer.masksToBounds = YES;
    NSArray *btnTitles = @[@"5分",@"15分",@"30分",@"60分"];
    for (int i = 0; i < btnTitles.count; i++) {
        UIButton *btn = [LNStockMenuBtn buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, i*25, 50, 25);
        btn.titleLabel.font = [UIFont systemFontOfSize:10.0];
        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
        __weak typeof (self)wSelf = self;
        [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (wSelf.block) {
                wSelf.block(i);
            }
        }];
        [self.menuView addSubview:btn];
    }
    [self addSubview:self.menuView];
    
    self.triangleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(21, 0, 8, 4)];
    self.triangleImageView.image = [UIImage imageNamed:@"LNStock.bundle/stock_menu"];
    [self addSubview:self.triangleImageView];
}

- (void)hiddenView {
    self.showing = NO;
    [self removeFromSuperview];
}

@end

@implementation LNStockMenuBtn
- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithRed:0.09 green:0.16  blue:0.21  alpha:1];
    }
    else {
        self.backgroundColor = [UIColor grayColor];
    }
}

@end
