//
//  LNColumnarSet.h
//  LNChart
//
//  Created by vvusu on 6/30/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LNColumnarSet : NSObject
@property (nonatomic, assign) CGFloat volumeWidth;       //宽度
@property (nonatomic, strong) UIColor *volumeColor;      //颜色
@property (nonatomic, strong) NSMutableArray *points;    //点的坐标
@end
