//
//  LNStockOptionView.m
//  LNStock
//
//  Created by vvusu on 7/28/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockOptionView.h"
#import "UIControl+LNStock.h"
#import "LNStockHandler.h"
#import "LNStockColor.h"
#import "UIImage+Tint.h"

@interface LNStockOptionView()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *adjustBtns;
@property (nonatomic, strong) NSMutableArray *factorBtns;
@end
@implementation LNStockOptionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self setupColor];
    __weak typeof (self)wSelf = self;
    
    CGFloat adjustBtnH = 0;
    NSArray *btnTitles = @[@"不复权",@"前复权",@"后复权"];
    UIColor *btnNorColor = [LNStockColor optionViewBtnN];
    UIColor *btnSelColor = [LNStockColor optionViewBtnS];
    UIImage *btnSelImage = [[UIImage imageNamed:@"LNStock.bundle/stock_optionbtn"] imageWithTintColor:[LNStockColor optionViewBtnImage]];
    CGFloat adjustBtnW = self.frame.size.width;
    if (![LNStockHandler isIndexStock] && ![LNStockHandler isFundStock]) {
        adjustBtnH = 40;
        self.adjustBtns = [NSMutableArray array];
        for (int i = 0; i < btnTitles.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, i*adjustBtnH, adjustBtnW, adjustBtnH);
            btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
            [btn setTitleColor:btnNorColor forState:UIControlStateNormal];
            [btn setTitleColor:btnSelColor forState:UIControlStateSelected];
            [btn setImage:btnSelImage forState:UIControlStateSelected];
            [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
            [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                [wSelf updateAdjustBtns:wSelf.adjustBtns Index:i];
                [LNStockHandler sharedManager].adjustType = i;
                if (wSelf.block) {
                    wSelf.block(LNOptionViewAction_Adjust);
                }
            }];
            if (i == [LNStockHandler adjustType]) {
                btn.selected = YES;
            }
            [self addSubview:btn];
            [self.adjustBtns addObject:btn];
        }
    }
    //——————————————————————————————————
    CGFloat factorBtnH = 40;
    CGFloat factorBtnW = self.frame.size.width;
    CGFloat scrollViewW = self.frame.size.width;
    CGFloat scrollViewY = btnTitles.count * adjustBtnH;
    CGFloat scrollViewH = self.frame.size.height - scrollViewY;
    
    //指数A股没有前后复权
    if ([LNStockHandler isIndexStock] || [LNStockHandler isFundStock]) {
        scrollViewY = 0;
        scrollViewH = self.frame.size.height;
    }
    else {
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, scrollViewY, scrollViewW - 10, 2)];
        lineLabel.text = @"--------------------";
        lineLabel.textColor = [UIColor colorWithRed:182/255.0 green:184/255.0 blue:181/255.0 alpha:1];
        lineLabel.font = [UIFont systemFontOfSize:5];
        [self addSubview:lineLabel];
    }
    
    self.factorBtns = [NSMutableArray array];
    NSArray *factorTitles = @[@"交易量",@"MACD",@"BOLL",@"KDJ",@"RSI",@"OBV"]; //,@"MACD",@"BOLL",@"KDJ",@"RSI",@"OBV"
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, scrollViewY, self.frame.size.width, scrollViewH)];
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, factorTitles.count * factorBtnH);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    for (int i = 0; i < factorTitles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, i*factorBtnH, factorBtnW, factorBtnH);
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [btn setImage:btnSelImage forState:UIControlStateSelected];
        [btn setTitleColor:btnNorColor forState:UIControlStateNormal];
        [btn setTitleColor:btnSelColor forState:UIControlStateSelected];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
        [btn setTitle:factorTitles[i] forState:UIControlStateNormal];
        [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            [wSelf updateAdjustBtns:wSelf.factorBtns Index:i];
            [LNStockHandler sharedManager].factorType = i;
            if (wSelf.block) {
                wSelf.block(LNOptionViewAction_Factor);
            }
        }];
        if (i == [LNStockHandler factorType]) {
            btn.selected = YES;
        }
        [self.scrollView addSubview:btn];
        [self.factorBtns addObject:btn];
    }
}

- (void)updateAdjustBtns:(NSArray *)btns Index:(NSInteger)index {
    for (UIButton *btn in btns) {
        btn.selected = NO;
    }
    if (index < btns.count) {
        UIButton *btn = btns[index];
        btn.selected = YES;
    }
}

- (void)setupColor {
    self.backgroundColor = [LNStockColor chartBG];
}

@end
