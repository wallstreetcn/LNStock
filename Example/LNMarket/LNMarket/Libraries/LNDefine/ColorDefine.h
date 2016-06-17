//
//  ColorDefine.h
//  AtourLiftAdmin
//
//  Created by vvusu on 3/21/16.
//  Copyright © 2016 atour. All rights reserved.
//

#ifndef ColorDefine_h
#define ColorDefine_h
#import "UIColor+Tool.h"

#define kColorHex(a) [UIColor colorWithRGBHex:a]
#define RGB3(a) [UIColor colorWithRed:a/255.0 green:a/255.0 blue:a/255.0 alpha:1.0]
#define RGB(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1.0]
#define RGBA(a,b,c,p) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:p]
// 随机色
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
// 字体色
#define kFC1 RGB3(85)

#endif /* ColorDefine_h */
