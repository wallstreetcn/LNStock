//
//  PriceDataSource.m
//  Market
//
//  Created by ZhangBob on 4/25/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "PriceDataSource.h"
#import "UIDefine.h"
#import "PriceCell.h"
#import "PriceDefine.h"
#import "PriceNetwork.h"
#import "PriceCellModel.h"
#import <MJRefresh/MJRefresh.h>

@interface PriceDataSource ()
@property (nonatomic, assign) NSInteger page;
@end

@implementation PriceDataSource

#pragma mark - setter

- (void)setPriceTableView:(UITableView *)priceTableView {
    _priceTableView = priceTableView;
    _priceTableView.showsVerticalScrollIndicator = NO;
    __weak typeof (self)weakSelf = self;
    self.priceTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getDataSource];
        [weakSelf.priceTableView.mj_header beginRefreshing];
        [weakSelf.navView startRefreshButtonAnimation];
        
    }];
    self.priceTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page = weakSelf.page + 1;
        NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
        [paramter setValue:weakSelf.postDataSource forKey:@"NewsIdentifier"];
        [paramter setValue:self.code forKey:@"stockSymbol"];
        [paramter setValue:[NSString stringWithFormat:@"%ld",weakSelf.page] forKey:@"page"];
        [weakSelf getMoreDataSourceWithParamter:paramter];
        [weakSelf.priceTableView.mj_footer beginRefreshing];
    }];
    if (_isNightMode) {
        self.priceTableView.backgroundColor = kSCNBG;
        self.priceTableView.separatorColor = kSCNCellSepara;
    }else {
        self.priceTableView.backgroundColor = kSCDBG;
        self.priceTableView.separatorColor = kSCDCellSepara;
    }
}

#pragma mark - getter

- (NSMutableArray *)postDataArray {
    if (!_postDataArray) {
        _postDataArray = [[NSMutableArray alloc] init];
        //第一次进入界面加载数据
        self.postDataSource = @"1000002";
        [self getDataSourceWithoutRefreshAction];
    }
    return _postDataArray;
}

- (SelectViewNew *)postSelectView {
    if (!_postSelectView) {
        if (self.isAstock) {
            NSArray *postTypeArray = [NSArray arrayWithObjects:@"新闻",@"公告",@"研报", nil];
            _postSelectView = [[SelectViewNew alloc] initWithFrame:CGRectMake(0, 0, kFBaseWidth, 40) withArray:postTypeArray selectItem:0];
        }else {
            NSArray *postTypeArray = [NSArray arrayWithObjects:@"相关新闻",@"财经日历", nil];
            _postSelectView = [[SelectViewNew alloc] initWithFrame:CGRectMake(0, 0, kFBaseWidth, 44) withArray:postTypeArray selectItem:0];
        }
        _postSelectView.markViewType = 1;
        _postSelectView.delegate = self;
        if (_isNightMode) {
            self.postSelectView.mainScrollView.backgroundColor = kSCNSVGB;
        }else {
            self.postSelectView.mainScrollView.backgroundColor = kSCDSVBG;
        }

        _postSelectView.backgroundColor = [UIColor whiteColor];

    }
    return _postSelectView;
}

#pragma mark - UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.postSelectView;
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PriceCell *cell = [PriceCell createWithXib];
    [cell addThemeChangedWithMode:self.isNightMode];
    if (self.postDataArray.count) {
        PriceCellModel *priceCellModel = [self.postDataArray objectAtIndex:indexPath.row];
        [cell setupCellWithModel:priceCellModel];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.priceTableView deselectRowAtIndexPath:indexPath animated:YES];
    PriceCellModel *quotePostModel = self.postDataArray[indexPath.row];
    //    NSString *urlString = [NSString stringWithFormat:@"http://api.buzz.wallstreetcn.com/v2/posts/%@",quotePostModel.cid];
//    NSString *urlString = [NSString stringWithFormat:@"%@/%@",KIAPostUrl,quotePostModel.cid];
//    LNRequest *request = [[LNRequest alloc] init];
//    request.url = urlString;
//    __weak typeof (self) weakSelf = self;
//    [LNNetWorking getWithRequest:request success:^(LNResponse *response) {
////        ArticleItem *articleItem = [ArticleItem mj_objectWithKeyValues:response.resultDic];
////        [weakSelf gotoWebViewControllerWithUrl:urlString ArticleItem:articleItem];
//    } fail:^(NSError *error) {
//        
//    }];
}

#pragma mark 跳转到网页

//- (void) gotoWebViewControllerWithUrl:(NSString *)url ArticleItem:(ArticleItem *)articleItem {
//    QuoteDetailWebVC *detail = [[QuoteDetailWebVC alloc]init];
//    detail.articleItem = articleItem;
//    detail.url = [NSURL URLWithString:url];
//    detail.pageType = NWWebPageResourceLiveNewsDetailVC;
//    detail.subDetailHeaderView.titleLabel.text = articleItem.title;
//        detail.hidesBottomBarWhenPushed = YES;
//    UINavigationController *navigationController = (id)[UIApplication sharedApplication].delegate.window.rootViewController;
//    [navigationController pushViewController:detail animated:YES];
//}

#pragma mark - SelecterViewDelegate methods

- (void)selecterView:(SelectViewNew *)selecterView didSelectedAtItem:(NSInteger)selectItem {
    if (self.isAstock) {
        switch (selectItem) {
            case 0:
                [self.postDataArray removeAllObjects];
                self.postDataSource = @"1000002";
                [self getDataSourceWithoutRefreshAction];
                break;
                
            case 1:
                [self.postDataArray removeAllObjects];
                self.postDataSource = @"1000003";
                [self getDataSourceWithoutRefreshAction];
                break;
                
            case 2:
                [self.postDataArray removeAllObjects];
                self.postDataSource = @"1000001";
                [self getDataSourceWithoutRefreshAction];
                break;
                
            default:
                break;
        }
    }else {
        switch (selectItem) {
            case 0:
                [self.postDataArray removeAllObjects];
                self.postDataSource = @"1000002";
                [self getDataSourceWithoutRefreshAction];
                break;
                
            case 1:
                [self.postDataArray removeAllObjects];
                self.postDataSource = @"1000003";
                [self getDataSourceWithoutRefreshAction];
                break;
            
            default:
                break;
        }
    }
}

#pragma mark - request DataSource

- (void)getDataSource {
    [self.postDataArray removeAllObjects];
    [self getDataSourceWithoutRefreshAction];
    [self.priceTableView.mj_header beginRefreshing];
}

- (void)getMoreDataSource {
    self.page = self.page + 1;
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setValue:self.postDataSource forKey:@"NewsIdentifier"];
    [paramter setValue:self.code forKey:@"stockSymbol"];
    [paramter setValue:[NSString stringWithFormat:@"%ld",self.page] forKey:@"page"];
    [self getMoreDataSourceWithParamter:paramter];
    [self.priceTableView.mj_footer beginRefreshing];
}

- (void)getDataSourceWithoutRefreshAction {
    self.page = 1;
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setValue:self.postDataSource forKey:@"NewsIdentifier"];
    [paramter setValue:self.code forKey:@"stockSymbol"];
    __weak typeof (self)weakSelf = self;
    [PriceNetwork getStockNewsWithParamter:paramter block:^(BOOL isSuccess, id response) {
        if (isSuccess) {
            [weakSelf.postDataArray addObjectsFromArray:response];
            [weakSelf.priceTableView reloadData];
            if (weakSelf.postDataArray.count < 10) {
                [weakSelf.priceTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else {
            NSLog(@"请求股票新闻数据失败%@",response);
        }
        [weakSelf.priceTableView.mj_header endRefreshing];
        [weakSelf.navView stopRefreshButtonAnimation];
    }];
}

- (void)getMoreDataSourceWithParamter:(NSDictionary *)paramter {
    __weak typeof (self)weakSelf = self;
    [PriceNetwork getMoreStockNewsWihtParamter:paramter block:^(BOOL isSuccess, id response) {
        if (isSuccess) {
            [weakSelf.postDataArray addObjectsFromArray:response];
            [weakSelf.priceTableView reloadData];
            if (weakSelf.postDataArray.count < 10) {
                [weakSelf.priceTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [weakSelf.priceTableView.mj_footer endRefreshing];
            }
        }else {
            NSLog(@"请求更多股票信息失败%@",response);
            [weakSelf.priceTableView.mj_footer endRefreshing];
        }
    }];
}

- (void)refreshDataSource {
    [self getDataSourceWithoutRefreshAction];
}

@end
