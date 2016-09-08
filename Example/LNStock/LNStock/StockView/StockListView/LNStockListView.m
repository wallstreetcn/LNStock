//
//  LNQuoteListView.m
//  Market
//
//  Created by vvusu on 5/26/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockListView.h"
#import "LNStockNetwork.h"
#import "LNStockHandler.h"
#import "LNStockColor.h"
#import "LNStockDealListCell.h"

#define cellHeaderH 20.0
@interface LNStockListView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) CGFloat cellH;
@property (nonatomic, strong) NSNumber *preClosePx;
@property (nonatomic, strong) NSArray *buyOrSaleArr;
@property (nonatomic, strong) NSMutableArray *dealNumberArr;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *requestedPriceArr;
@end

@implementation LNStockListView

#pragma mark - Getter

- (NSArray *)buyOrSaleArr {
    if (!_buyOrSaleArr) {
        _buyOrSaleArr = @[@"卖5",@"卖4",@"卖3",@"卖2",@"卖1",@"买1",@"买2",@"买3",@"买4",@"买5"];
    }
    return _buyOrSaleArr;
}

- (NSMutableArray *)requestedPriceArr {
    if (!_requestedPriceArr) {
        _requestedPriceArr = [NSMutableArray array];
    }
    return  _requestedPriceArr;
}

- (NSMutableArray *)dealNumberArr {
    if (!_dealNumberArr) {
        _dealNumberArr = [NSMutableArray array];
    }
    return _dealNumberArr;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return  self;
}

- (void)setupViews {
    self.cellH = (self.bounds.size.height - cellHeaderH)/10;
    self.tableView = [[UITableView alloc]initWithFrame:self.bounds];
    [self setupColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    [self setupRefreshControl];
    [self getBuyAndSaleGroupData];
}

- (void)setupColor {
    self.tableView.backgroundColor = [LNStockColor stockViewBG];
    self.tableView.tableHeaderView = [self setupTableHeaderView];
    [self.tableView reloadData];
}

- (UIView *)setupTableHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, cellHeaderH)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:headerView.bounds];
    titleLabel.font = [UIFont systemFontOfSize:12.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"五档";
    [headerView addSubview:titleLabel];
    titleLabel.textColor = [UIColor blackColor];
    if ([LNStockHandler isNightMode]) {
        titleLabel.textColor = [UIColor whiteColor];
    }
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (void)setupRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getBuyAndSaleGroupData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

#pragma mark - UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 1.0;
    }else {
        return 0;
    }
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LNStockDealListCell *cell = [LNStockDealListCell createWithXib];
    if (indexPath.section == 0) {
        if (self.requestedPriceArr.count) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:self.buyOrSaleArr[indexPath.row] forKey:@"BuyOrSale"];
            [dict setValue:self.dealNumberArr[indexPath.row] forKey:@"DealNumber"];
            [dict setValue:self.requestedPriceArr[indexPath.row] forKey:@"RequestedPrice"];
            [dict setValue:self.preClosePx forKey:@"preclose_px"];
            [cell setupCellWithDict:dict];
        }
    }
    else {
        if (self.requestedPriceArr.count) {
            NSInteger index = indexPath.row + 5;
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:self.buyOrSaleArr[index] forKey:@"BuyOrSale"];
            [dict setValue:self.dealNumberArr[index] forKey:@"DealNumber"];
            [dict setValue:self.requestedPriceArr[index] forKey:@"RequestedPrice"];
            [dict setValue:self.preClosePx forKey:@"preclose_px"];
            [cell setupCellWithDict:dict];
        }
    }
    return cell;
}

#pragma mark - BuyAndSale data request

- (void)getBuyAndSaleGroupData {
    __weak typeof (self)wSelf = self;
    [LNStockNetwork getDealListDataWithStockCode:[LNStockHandler code] block:^(BOOL isSuccess, NSDictionary *response) {
        if (isSuccess) {
            self.preClosePx = [response valueForKey:@"preclose_px"];
            self.dealNumberArr = [response valueForKey:@"DealNumberArr"];
            self.requestedPriceArr = [response valueForKey:@"RequestedPriceArr"];
            [wSelf.tableView reloadData];
        }else {
            NSLog(@"LNChartDealListView 请求数据失败");
        }
        [wSelf.refreshControl endRefreshing];
    }];
}

@end
