//
//  LNQuoteKLineInfo.h
//  Market
//
//  Created by vvusu on 5/26/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LNStockKLineInfo : UIView
//竖屏
@property (weak, nonatomic) IBOutlet UILabel *time;
//高  开  低  收  幅  成交量
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *contentLabels;
+ (id)createXibWithIndex:(NSInteger)index;
- (void)setViewWithArray:(NSArray *)array Index:(NSInteger)index;
@end

//横屏的
@interface LNStockKLineInfoH : LNStockKLineInfo
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *contents;
@end
