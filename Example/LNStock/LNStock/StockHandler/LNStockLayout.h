//
//  LNStockLayout.h
//  LNStock
//
//  Created by vvusu on 10/9/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

//默认StockView 高度
#define kFStockBGH 485.0
#define kFStockAHeaderH 185.0   //AStock 头部视图高度
#define kFStockBHeaderH 185.0   //BStock 头部视图高度
#define kFStockTitleViewH 50.0  //Stock  头部视图高度

@interface LNStockLayout : NSObject
@property (nonatomic, assign) CGRect stockFrame;              //Rect
@property (nonatomic, assign) CGFloat stockViewW;             //View的宽
@property (nonatomic, assign) CGFloat stockViewH;             //View的高
@property (nonatomic, assign) CGFloat listViewW;              //交易列表的宽
@property (nonatomic, assign) CGFloat titleViewH;             //头部视图的高
@property (nonatomic, assign) CGFloat headerViewH;            //头部视图的Y
@property (nonatomic, assign) CGFloat bottomChartViewH;       //bottomView的高

- (void)defaultSetWithIsAStock:(BOOL)isAStock;
@end
