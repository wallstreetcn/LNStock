//
//  LNDataSet.h
//  Market
//
//  Created by vvusu on 5/20/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LNDataSet : NSObject
@property (nonatomic, assign) CGFloat volume;        //成交量
@property (nonatomic, assign) CGFloat preClosePx;    //昨收价格
@property (nonatomic, strong) NSDate *date;          //当前的时间
@property (nonatomic, strong) NSArray *values;       //点的数据
@property (nonatomic, strong) NSArray *MAValus;      //MA点的数据
@property (nonatomic, strong) NSArray *candleValus;  //K线数据 (开\高\低\收)
@end
