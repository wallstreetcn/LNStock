//
//  LNQuoteListView.h
//  Market
//
//  Created by vvusu on 5/26/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LNStockHandler;
@interface LNStockListView : UIView
@property (nonatomic, weak) LNStockHandler *stockInfo;     
@property (nonatomic, strong) UITableView *tableView;
//数据请求
- (void)setupColor;
- (void)getBuyAndSaleGroupData;
@end
