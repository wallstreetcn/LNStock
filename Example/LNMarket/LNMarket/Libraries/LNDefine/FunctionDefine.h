//
//  FunctionDefine.h
//  Market
//
//  Created by vvusu on 4/21/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#ifndef FunctionDefine_h
#define FunctionDefine_h

#define kWeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//AppDelegate
#define kAPPDELEGATE [[UIApplication sharedApplication]  delegate]

//UIApplication
#define kAPPD  [UIApplication sharedApplication]
#define kRootNavVC (UINavigationController*)[[[[UIApplication sharedApplication] delegate] window] rootViewController]

#endif /* FunctionDefine_h */
