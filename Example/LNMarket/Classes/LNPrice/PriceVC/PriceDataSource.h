//
//  PriceDataSource.h
//  Market
//
//  Created by ZhangBob on 4/25/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriceVC.h"
#import "SelectViewNew.h"
#import "PriceNavView.h"

@interface PriceDataSource : NSObject<UITableViewDataSource,UITableViewDelegate,SelectViewDelegate>
@property (nonatomic, assign) BOOL isAstock;
@property (nonatomic, assign) BOOL isNightMode;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *postDataSource;
@property (nonatomic, weak) UITableView *priceTableView;
@property (nonatomic, strong) NSMutableArray *postDataArray;
@property (nonatomic, weak) PriceNavView *navView;
@property (nonatomic, strong) SelectViewNew *postSelectView;

- (void)refreshDataSource;

@end
