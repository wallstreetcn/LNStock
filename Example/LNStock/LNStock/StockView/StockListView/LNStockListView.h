//
//  LNQuoteListView.h
//  Market
//
//  Created by vvusu on 5/26/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LNStockListView : UIView
@property (nonatomic, strong) UITableView *tableView;
//数据请求
- (void)setupColor;
- (void)getBuyAndSaleGroupData;
@end
