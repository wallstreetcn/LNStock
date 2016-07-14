//
//  UIDefine.h
//  AtourLiftAdmin
//
//  Created by vvusu on 3/21/16.
//  Copyright © 2016 atour. All rights reserved.
//

#ifndef UIDefine_h
#define UIDefine_h

//导航栏的高度
#define kFBaseNavHeight 44
#define kFBaseItemWidth 40
//状态栏+导航栏高度
#define kFBaseSNHeight 64
//状态栏的高度
#define kFBaseStatusHeight 20
//界面的高
#define kFBaseWidth [[UIScreen mainScreen]bounds].size.width
#define kFBaseHeight [[UIScreen mainScreen]bounds].size.height


//iphone4
#define kIsIPhone4 ([[UIScreen mainScreen] bounds].size.height == 480)
//iphone5
#define kIsIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//iphone6
#define kIsIPhone6 ([[UIScreen mainScreen] bounds].size.height == 667)
//iphone6Plus
#define kIsIPhone6Plus ([[UIScreen mainScreen] bounds].size.height == 736)

//系统判断
#define kIOS7 [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0
#define kIOS8 [[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0
#define kIOS9 [[[UIDevice currentDevice]systemVersion] floatValue] >= 9.0

#endif /* UIDefine_h */
