//
//  ViewController.m
//  Market
//
//  Created by vvusu on 4/20/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "ViewController.h"
#import "DebugVC.h"
#import "PriceVC.h"
#import "PListUtils.h"
#import "SearchCell.h"
#import "UIView+LoadNib.h"
#import <LNStock/LNStock.h>

#define KIStockCacheKey @"KIStockCacheKey"

@interface ViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
//    //测试获取外汇数据
//    [LNStockNetwork getBstockListDataWithType:StockListType_Forex block:^(BOOL isSuccess, id response) {
//        if (isSuccess) {
//            self.dataArr = response;
//            [self.tableView reloadData];
//        }
//    }];
    
    //获取沪深排行榜－涨幅榜
    [LNStockNetwork getAstockListDataWithSortType:SortTypeDescending_pxChangeRate num:10 block:^(BOOL isSuccess, id response) {
        if (isSuccess && ((NSArray *)response).count > 0) {
            self.dataArr = response;
            [self.tableView reloadData];
        }
    }];
    
//    //获取沪深排行榜－跌幅榜
//    [LNStockNetwork getAstockListDataWithSortType:SortTypeAscending_pxChangeRate num:10 block:^(BOOL isSuccess, id response) {
//        if (isSuccess) {
//            self.dataArr = response;
//            [self.tableView reloadData];
//        }
//    }];
    
//    //测试获取 自选
//    NSArray *prodCodeArr = @[@"000001.SS",@"EURUSD",@"000001.SZ",@"XAUUSD",@"399001.SZ",@"399006.SZ",@"NASINDEX"];
//    [LNStockNetwork getStockListDataWithProdCodeArr:prodCodeArr block:^(BOOL isSuccess, id response) {
//        if (isSuccess) {
//            self.dataArr = response;
//            [self.tableView reloadData];
//        }
//    }];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)setupView {
    self.dataArr = [NSMutableArray array];
    NSArray *stockArr = [self getStockListCache];
    if (stockArr.count == 0) {
        NSArray *tempArr = @[@{@"name":@"贵阳银行", @"code":@"601997.SS", @"type":@"mdc"},
                             @{@"name":@"沪深300", @"code":@"000300.SS", @"type":@"mdc"},
                             @{@"name":@"深证指数", @"code":@"399001.SZ", @"type":@"mdc"},
                             @{@"name":@"新西兰兑美元", @"code":@"NZDUSD", @"type":@"forexdata"}];
        
        stockArr = [self getModelFromeArray:tempArr];
        [self cacheStockList:stockArr];
    }
    self.dataArr = [NSMutableArray arrayWithArray:stockArr];
    
    self.stockTF.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.stockTF addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (NSArray *)getModelFromeArray:(NSArray *)array {
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        LNStockModel *model = [[LNStockModel alloc]init];
        model.prod_name = [dic valueForKey:@"name"];
        model.prod_code = [dic valueForKey:@"code"];
        model.market_type = [dic valueForKey:@"type"];
        [tempArr addObject:model];
    }
    return (NSArray *)tempArr;
}

- (NSArray *)getStockListCache {
    NSData *stockData = [[NSUserDefaults standardUserDefaults] valueForKey:KIStockCacheKey];
    NSArray *stockArr = [NSKeyedUnarchiver unarchiveObjectWithData:stockData];
    return stockArr;
}

- (void)cacheStockList:(NSArray *)dataArr {
    // save the person object as nsData
    NSData *stockEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:dataArr];
    [[NSUserDefaults standardUserDefaults]setValue:stockEncodedObject forKey:KIStockCacheKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)removeStockWithCode:(NSString *)code {
    NSMutableArray *stocks = [NSMutableArray arrayWithArray:[self getStockListCache]];
    for (LNStockModel *tempModel in stocks) {
        if ([tempModel.prod_code isEqualToString:code]) {
            [stocks removeObject:tempModel];
            break;
        }
    }
    self.dataArr = stocks;
    [self.tableView reloadData];
    [self cacheStockList:stocks];
}

#pragma mark - Anction
- (IBAction)debugAction:(id)sender {
    DebugVC *debugvc = [[DebugVC alloc]init];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:debugvc animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField.text.length > 0) {
        BOOL isAstock = YES;
        if ([textField.text rangeOfString:@"."].location == NSNotFound) {
            isAstock = NO;
        }
        BOOL isNightMode = [[PListUtils valueForKey:@"IsNigthMode"] intValue];
        PriceVC *bStockVC = [PriceVC createWithTitle:@""
                                            subtitle:textField.text
                                              symbol:textField.text
                                         isNightMode:isNightMode
                                            isAStock:isAstock];
        [self.navigationController pushViewController:bStockVC animated:YES];
    }
    return YES;
}

- (void)textFieldEditChanged:(UITextField *)textField {
    __weak typeof(self) wself= self;
    if (textField.text.length > 0) {
        NSString *content = textField.text;
        [LNStockNetwork getStockSearchListWithContent:content num:@"20" block:^(BOOL isSuccess, id response) {
            if (isSuccess) {
                if (![textField.text isEqualToString:content]) {
                    return;
                }
                wself.dataArr = response;
                [wself.tableView reloadData];
            }
        }];
    } else {
        self.dataArr = [NSMutableArray arrayWithArray:[self getStockListCache]];
        [self.tableView reloadData];
    }
}

#pragma mark - UITableView datasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SearchCell class])];
    if (!cell) {
        cell = [SearchCell createWithXib];
    }
    LNStockModel *model = self.dataArr[indexPath.row];
    [cell searchListItem:model.prod_name code:model.prod_code];
    cell.cellBlock = ^(){
        NSMutableArray *stockArr = [NSMutableArray arrayWithArray:[self getStockListCache]];
        for (LNPriceModel *tempModel in stockArr) {
            if ([tempModel.prod_code isEqualToString:model.prod_code]) {
                return;
            }
        }
        [stockArr insertObject:model atIndex:0];
        [self cacheStockList:stockArr];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LNStockModel *model = self.dataArr[indexPath.row];
    BOOL isAstock = YES;
    if ([model.market_type isEqualToString:@"forexdata"]) {
        isAstock = NO;
    }
    BOOL isNightMode = [[PListUtils valueForKey:@"IsNigthMode"] intValue];
    PriceVC *bStockVC = [PriceVC createWithTitle:model.prod_name
                                        subtitle:model.prod_code
                                          symbol:model.prod_code
                                     isNightMode:isNightMode
                                        isAStock:isAstock];
    [self.navigationController pushViewController:bStockVC animated:YES];
}

//iOS9 以前 添加删除按钮
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath  {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        LNStockModel *model = self.dataArr[indexPath.row];
        [self removeStockWithCode:model.prod_code];
    }
}

// IOS 9 以后
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.stockTF.text.length > 0) {
        return NO;
    } else {
        return YES;
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //取消收藏
        LNStockModel *model = self.dataArr[indexPath.row];
        [self removeStockWithCode:model.prod_code];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    return @[deleteAction];
}

@end
