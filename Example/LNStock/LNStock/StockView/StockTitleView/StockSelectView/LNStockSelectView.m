//
//  LNQuotesSelectView.m
//  Market
//
//  Created by vvusu on 5/26/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockSelectView.h"
#import "UIControl+LNStock.h"
#import "LNStockHandler.h"
#import "UIImage+Tint.h"
#import "LNStockColor.h"

#define KILineH 2.0
@interface LNStockSelectView()
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UIButton *typeBtn;
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation LNStockSelectView

- (instancetype)init {
    if (self = [super init]) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupColor {
    self.backgroundColor = [LNStockColor selectViewBG];
}

- (void)setupViews {
    [self setupColor];
    //scrollview
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    _itemH = 40;
    CGFloat btnW = 0;
    CGFloat edgeX = 5;
    NSArray *btnTitles;
    self.btns = [NSMutableArray array];
    
    //Button
    if ([LNStockHandler sharedManager].priceType == LNStockPriceTypeA) {
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width, self.bounds.size.height);
        btnTitles = @[@"分时",@"五日",@"日K",@"周K",@"月K"];
//        btnTitles = @[@"分时",@"五日",@"日K",@"周K",@"月K",@"分钟"];
        btnW = (self.frame.size.width - edgeX * 2) / btnTitles.count;
        UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 20, 18, 8, 4)];
        arrowView.image = [UIImage imageNamed:@"LNStock.bundle/sotck_arrow"];
//        [self.scrollView addSubview:arrowView];
    }
    else { //TypeBtn
        self.typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.typeBtn.frame = CGRectMake(0, 0, 50, _itemH);
        NSArray *imageArr = @[@"LNStock.bundle/stock_btntype_line",
                              @"LNStock.bundle/stock_btntype_candle",
                              @"LNStock.bundle/stock_btntype_hollowcandle",
                              @"LNStock.bundle/stock_btntype_bars"];
        [self.typeBtn setImage:[[UIImage imageNamed:imageArr[[LNStockHandler chartType]]] imageWithTintColor:[LNStockColor selectViewChartTypeBtn]] forState:UIControlStateNormal];
        __weak typeof(self) wself= self;
        [self.typeBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if ([LNStockHandler chartType] + 1 > LNStockChartType_Bars) {
                [LNStockHandler sharedManager].chartType = 0;
            } else {
                [LNStockHandler sharedManager].chartType++;
            }
            [wself.typeBtn setImage:[[UIImage imageNamed:imageArr[[LNStockHandler chartType]]] imageWithTintColor:[LNStockColor selectViewChartTypeBtn]] forState:UIControlStateNormal];
            if (wself.block) {
                wself.block(10);
            }
        }];
        [self addSubview:self.typeBtn];
        
        //buttons
        btnTitles = @[@"1m",@"5m",@"15m",@"30m",@"1H",@"2H",@"4H",@"1D",@"1W",@"1M"];
        btnW = 60.0f;
        if (![LNStockHandler isVerticalScreen]) {
            btnW = 75.0f;
        }
        self.scrollView.frame = CGRectMake(50, 0, self.frame.size.width - 50, self.frame.size.height);
        self.scrollView.contentSize = CGSizeMake(btnW * btnTitles.count, self.bounds.size.height);
    }
    
    //Buttons
    __weak typeof(self) wself= self;
    for (NSInteger i = 0; i < btnTitles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnW * i + edgeX,0,btnW, _itemH);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[LNStockColor selectViewBtnN] forState:UIControlStateNormal];
        [btn setTitleColor:[LNStockColor selectViewBtnS] forState:UIControlStateSelected];
        __weak UIButton *weakBtn = btn;
        [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            [self changeBtnStatusExceptIndex:i];
            [self changeLineLabelFrameWithIndex:i duration:0.3f];
            weakBtn.selected = YES;
            if (wself.block) {
                wself.block(i);
            }
        }];
        if (i == 0) {
            btn.selected = YES;
        }
        [self.scrollView addSubview:btn];
        [self.btns addObject:btn];
    }
    
    //Label
    self.line = [[UILabel alloc] init];
    self.line.backgroundColor = [LNStockColor selectViewLine];
    [self changeLineLabelFrameWithIndex:0 duration:0];
    [self.scrollView addSubview:self.line];
}

- (void)changeBtnStatusExceptIndex:(NSInteger)index {
    for (UIButton *btn in self.btns) {
        btn.selected = NO;
    }
    if (index < self.btns.count) {
        UIButton *btn = self.btns[index];
        btn.selected = YES;
    }
//    if ([LNStockHandler sharedManager].priceType == LNStockPriceTypeA) {
//        UIButton *lastBtn = self.btns.lastObject;
//        [lastBtn setTitle:@"分钟" forState:UIControlStateNormal];
//    }
}

- (void)changeLineLabelFrameWithIndex:(NSInteger)index duration:(CGFloat)duration {
    UIButton *btn = self.btns[index];
    [UIView animateWithDuration:duration animations:^{
        self.line.frame = CGRectMake(btn.frame.origin.x, CGRectGetMaxY(btn.frame) - KILineH, btn.frame.size.width, KILineH);
    }];
}

//菜单栏点击回调
- (void)setMinBtnTitleWithIndex:(NSInteger)index {
    NSArray *menuTitles = @[@"5分",@"15分",@"30分",@"60分"];
    UIButton *btn = self.btns.lastObject;
    [self changeBtnStatusExceptIndex:self.btns.count - 1];
    [btn setTitle:menuTitles[index] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        self.line.frame = CGRectMake(btn.frame.origin.x, CGRectGetMaxY(btn.frame) - KILineH, btn.frame.size.width, KILineH);
    }];
}

//修改菜单回调(保证横屏和竖屏保持一致)
- (void)changeBtnTitleWithType:(LNStockTitleType)type {
    if ([LNStockHandler sharedManager].priceType == LNStockPriceTypeA) {
        NSInteger i = 0;
        switch (type) {
            case LNChartTitleType_5D:
                i = 1;
                break;
            case LNChartTitleType_1D:
                i = 2;
                break;
            case LNChartTitleType_1W:
                i = 3;
                break;
            case LNChartTitleType_1M:
                i = 4;
                break;
            default:
                break;
        }
        [self changeBtnStatusExceptIndex:i];
        UIButton *btn = self.btns[i];
        self.line.frame = CGRectMake(btn.frame.origin.x, CGRectGetMaxY(btn.frame) - KILineH, btn.frame.size.width, KILineH);
        
        //分钟设置Button
//        if (type == LNChartTitleType_5m || type == LNChartTitleType_15m || type == LNChartTitleType_30m || type == LNChartTitleType_1H) {
//            i = type;
//            [self setMinBtnTitleWithIndex:i - 1];
//        }
    } else {
        if (type > LNChartTitleType_5D) {
            type--;
        }
        [self changeBtnStatusExceptIndex:type];
        if (type < self.btns.count) {
            UIButton *btn = self.btns[type];
            self.line.frame = CGRectMake(btn.frame.origin.x, CGRectGetMaxY(btn.frame) - KILineH, btn.frame.size.width, KILineH);
        }
    }
}

@end
