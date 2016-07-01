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
@property (nonatomic, assign) CGFloat price;         //价格
@property (nonatomic, assign) CGFloat volume;        //成交量
@property (nonatomic, assign) CGFloat totalVolume;   //总交易量
@property (nonatomic, strong) NSDate *date;          //当前的时间

//KLine
@property (nonatomic, assign) CGFloat open;
@property (nonatomic, assign) CGFloat close;
@property (nonatomic, assign) CGFloat high;
@property (nonatomic, assign) CGFloat low;

@property (nonatomic, assign) CGFloat MA1;
@property (nonatomic, assign) CGFloat MA2;
@property (nonatomic, assign) CGFloat MA3;
@property (nonatomic, assign) CGFloat MA4;
@property (nonatomic, assign) CGFloat MA5;

//分时五日
@property (nonatomic, assign) CGFloat preClosePx;    //昨收价格
@property (nonatomic, assign) CGFloat averagePrice;  //平均交易价格

@end
