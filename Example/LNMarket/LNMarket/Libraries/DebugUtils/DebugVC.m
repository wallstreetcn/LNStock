//
//  DebugVC.m
//  AtourLife
//
//  Created by vvusu on 3/4/16.
//  Copyright © 2016 Anasue. All rights reserved.
//

#import "DebugVC.h"
#import "DebugCell.h"
#import "UIView+LoadNib.h"

@interface DebugVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArr;
@end

@implementation DebugVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"测试页面";
    self.dataArr = @[@"Debug环境",@"测试服务器",@"测试web服务器",@"夜间模式",@"绿涨红跌"];
    [self.tableView reloadData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DebugCell";
    DebugCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [DebugCell createWithXib];
    }
    [cell createItem:self.dataArr[indexPath.row] With:indexPath];
    return cell;
}

@end
