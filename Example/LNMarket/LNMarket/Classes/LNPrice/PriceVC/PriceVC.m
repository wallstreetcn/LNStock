//
//  PriceVC.m
//  Market
//
//  Created by ZhangBob on 4/22/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "PriceVC.h"
#import "PriceNavView.h"
#import "PriceAStockHeaderView.h"
#import "PriceAStockHeaderDataModel.h"
#import "PriceBStockHeaderView.h"
#import "PriceDefine.h"
#import "PriceDataSource.h"
#import "PriceNetwork.h"
#import <LNStock/LNStockView.h>

#define kFStockViewH 300
#define kFQuoteViewH 173
#define kFBaseWidth [[UIScreen mainScreen]bounds].size.width
#define kFBaseHeight [[UIScreen mainScreen]bounds].size.height

@interface PriceVC ()
@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign) BOOL isAstock;
@property (nonatomic, assign) BOOL isNightMode;
@property (nonatomic, strong) UIView *tableHeadView;
@property (nonatomic, strong) UITableView *priceTableView;
@property (nonatomic, strong) LNStockView *stockView;
@property (nonatomic, strong) PriceNavView *navView;
@property (nonatomic, strong) PriceDataSource *priceDataSource;
@property (nonatomic, strong) PriceAStockHeaderView *aStockHeaderView;
@property (nonatomic, strong) PriceBStockHeaderView *bStockHeaderView;
@end

@implementation PriceVC

#pragma mark - Get Set
- (PriceNavView *)navView {
    if (!_navView) {
        _navView = [PriceNavView createWithXib];
        __weak typeof (self)weakSelf = self;
        _navView.block = ^{
            [weakSelf getStockData];
        };
        [self.view addSubview:_navView];
    }
    return _navView;
}

- (PriceDataSource *)priceDataSource {
    if (!_priceDataSource) {
        _priceDataSource = [[PriceDataSource alloc] init];
        _priceDataSource.code = self.code;
        _priceDataSource.navView = self.navView;
        _priceDataSource.isAstock = self.isAstock;
        _priceDataSource.isNightMode = self.isNightMode;
        _priceDataSource.priceTableView = self.priceTableView;
    }
    return _priceDataSource;
}

- (UIView *)tableHeadView {
    if (!_tableHeadView) {
         _tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFBaseWidth, kFQuoteViewH + kFStockViewH)];
        if (self.isAstock) {
            [self.aStockHeaderView addThemeChangedWithMode:self.isNightMode];
            [_tableHeadView addSubview:self.aStockHeaderView];
        }else {
            [self.bStockHeaderView addThemeChangedWithMode:self.isNightMode];
            [_tableHeadView addSubview:self.bStockHeaderView];
        }
        //添加K线图
        CGRect stockFrame = CGRectMake(0, kFQuoteViewH, kFBaseWidth, kFStockViewH);
        self.stockView = [LNStockView createViewWithFrame:stockFrame code:self.code isAstock:self.isAstock isNight:self.isNightMode];
        [_tableHeadView addSubview:self.stockView];
    }
    return  _tableHeadView;
}

- (UITableView *)priceTableView {
    if (!_priceTableView) {
        _priceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kFBaseWidth, kFBaseHeight - 64)];
        _priceTableView.tableHeaderView = self.tableHeadView;
        _priceTableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_priceTableView];
    }
    return _priceTableView;
}

- (PriceAStockHeaderView *)aStockHeaderView {
    if (!_aStockHeaderView) {
        _aStockHeaderView = [PriceAStockHeaderView createWithXib];
    }
    return _aStockHeaderView;
}

- (PriceBStockHeaderView *)bStockHeaderView {
    if (!_bStockHeaderView) {
        _bStockHeaderView = [PriceBStockHeaderView createWithXib];
    }
    return _bStockHeaderView;
}

#pragma mark - InIt
+ (instancetype)initWithTitle:(NSString *)navTitle
                     subtitle:(NSString *)subtitle
                       symbol:(NSString *)symbol
                  isNightMode:(BOOL)isNightMode
                     isAStock:(BOOL)isAStock {
    
    PriceVC *vc = [[PriceVC alloc]init];
    vc.code = symbol;
    vc.isAstock = isAStock;
    vc.isNightMode = isNightMode;
    [vc setupNavViewWithTitle:navTitle subtitle:subtitle];
    [vc getStockData];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)setupViews {
    if (self.isNightMode) {
        self.view.backgroundColor = [UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1];
    }else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    self.priceTableView.delegate = self.priceDataSource;
    self.priceTableView.dataSource = self.priceDataSource;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)setupNavViewWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    [self.navView addThemeChangeWithMode:self.isNightMode];
    self.navView.navTitleLabel.text = title;
    self.navView.stockStatusLabel.text = subtitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - HTTPRequest
- (void)getStockData {
    __weak typeof (self)weakSelf = self;
    [weakSelf.priceDataSource refreshDataSource];
    [PriceAStockHeaderDataModel getPriceHeaderWithSymbol:weakSelf.code
                                           PriceResponse:^(BOOL isSucceed, PriceAStockHeaderDataModel *data) {
                                               if (isSucceed) {
                                                   [weakSelf.aStockHeaderView setPriceHeaderLabelsWithData:data];
                                               }else {
                                                   NSLog(@"行情头部失败");
                                               }
                                               [weakSelf.navView stopRefreshButtonAnimation];
                                           }];
}

@end
