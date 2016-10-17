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
@property (nonatomic, strong) NSArray *typeBtnImages;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation LNStockSelectView

- (instancetype)initWithFrame:(CGRect)frame stockInfo:(LNStockHandler *)stockInfo {
    if (self == [super initWithFrame:frame]) {
        self.stockInfo = stockInfo;
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
    CGFloat btnW = [LNStockHandler isVerticalScreen] ? 60 : 80;
    CGFloat edgeX = 5;
    NSArray *btnTitles;
    self.btns = [NSMutableArray array];
    //Button
    if ([self.stockInfo isAStock]) {
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width, self.bounds.size.height);
        btnTitles = @[@"分时",@"五日",@"日K",@"周K",@"月K",@"5分",@"15分",@"30分",@"60分"];
        self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.scrollView.contentSize = CGSizeMake(btnW * btnTitles.count, self.bounds.size.height);
    }
    else { //TypeBtn
        __weak typeof(self) wself= self;
        self.typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.typeBtn.frame = CGRectMake(0, 0, 50, _itemH);
        self.typeBtnImages = @[@"LNStock.bundle/stock_btntype_line",
                              @"LNStock.bundle/stock_btntype_candle",
                              @"LNStock.bundle/stock_btntype_hollowcandle",
                              @"LNStock.bundle/stock_btntype_bars"];
        [self.typeBtn setImage:[[UIImage imageNamed:self.typeBtnImages[[LNStockHandler chartType]]] imageWithTintColor:[LNStockColor selectViewChartTypeBtn]] forState:UIControlStateNormal];
        [self.typeBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if ([LNStockHandler chartType] + 1 > LNStockChartType_Bars) {
                [LNStockHandler sharedManager].chartType = 0;
            } else {
                [LNStockHandler sharedManager].chartType++;
            }
            [wself.typeBtn setImage:[[UIImage imageNamed:wself.typeBtnImages[[LNStockHandler chartType]]] imageWithTintColor:[LNStockColor selectViewChartTypeBtn]] forState:UIControlStateNormal];
            if (wself.block) {
                wself.block(10);
            }
        }];
        [self addSubview:self.typeBtn];
        
        //buttons
        btnTitles = @[@"1m",@"5m",@"15m",@"30m",@"1H",@"2H",@"4H",@"1D",@"1W",@"1M"];
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
        //滑动判断
        CGRect convertRect =  [self.scrollView convertRect:btn.frame toView:self];
        if (![self.stockInfo isAStock]) { //外汇有个按钮会有问题
            convertRect = CGRectMake(convertRect.origin.x - 50, convertRect.origin.y, convertRect.size.width, convertRect.size.height);
        }
        if (convertRect.origin.x < btn.frame.size.width) {
            CGFloat num = self.scrollView.contentOffset.x - btn.frame.size.width;
            if (num < 0) {
                num = 0;
            }
            [self setBgContentOffsetAnimation:num];
        }
        if (self.scrollView.frame.size.width <= self.btns.count * btn.frame.size.width) {
            if (convertRect.origin.x > (self.scrollView.frame.size.width - 2 * btn.frame.size.width)) {
                CGFloat num = self.scrollView.contentOffset.x + btn.frame.size.width;
                if (num > self.btns.count * btn.frame.size.width - self.scrollView.frame.size.width) {
                    num = self.btns.count * btn.frame.size.width - self.scrollView.frame.size.width;
                }
                [self setBgContentOffsetAnimation:num];
            }
        }
    }
}

//因为setContentOffset animation有时候卡顿所以写此方法 [self.scrollView setContentOffset:CGPointMake(num,0) animated:YES];

-(void)setBgContentOffsetAnimation:(CGFloat )OffsetY {
    [UIView animateWithDuration:.25 animations:^{
        self.scrollView.contentOffset = CGPointMake(OffsetY, 0);
    }]; 
}

- (void)changeLineLabelFrameWithIndex:(NSInteger)index duration:(CGFloat)duration {
    UIButton *btn = self.btns[index];
    [UIView animateWithDuration:duration animations:^{
        self.line.frame = CGRectMake(btn.frame.origin.x, CGRectGetMaxY(btn.frame) - KILineH, btn.frame.size.width, KILineH);
    }];
}

//修改菜单回调(保证横屏和竖屏保持一致)
- (void)changeBtnTitleWithType:(LNStockTitleType)type {
    if ([self.stockInfo isAStock]) {
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
        //分钟设置Button
        if (type == LNChartTitleType_5m || type == LNChartTitleType_15m || type == LNChartTitleType_30m || type == LNChartTitleType_1H) {
            i = type + 4;
        }
        [self changeBtnStatusExceptIndex:i];
        UIButton *btn = self.btns[i];
        self.line.frame = CGRectMake(btn.frame.origin.x, CGRectGetMaxY(btn.frame) - KILineH, btn.frame.size.width, KILineH);
    }
    else {
        if (type > LNChartTitleType_5D) {
            type--;
        }
        [self.typeBtn setImage:[[UIImage imageNamed:self.typeBtnImages[[LNStockHandler chartType]]] imageWithTintColor:[LNStockColor selectViewChartTypeBtn]] forState:UIControlStateNormal];
        [self changeBtnStatusExceptIndex:type];
        if (type < self.btns.count) {
            UIButton *btn = self.btns[type];
            self.line.frame = CGRectMake(btn.frame.origin.x, CGRectGetMaxY(btn.frame) - KILineH, btn.frame.size.width, KILineH);
        }
    }
}

@end
