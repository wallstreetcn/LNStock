//
//  UIView+LNStock.h
//  LNStock
//
//  Created by vvusu on 6/6/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LNStock)
//根据Xib文件创建View
+ (id)createWithXib;

//根据Xib文件创建View
+ (id)createWithXibName:(NSString *)xibName;

//根据同一个Xib文件获取不同View
+ (id)creatXibWithIndex:(NSInteger)index;
@end
