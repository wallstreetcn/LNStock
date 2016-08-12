//
//  BlockDefine.h
//  AtourLiftAdmin
//
//  Created by vvusu on 3/21/16.
//  Copyright © 2016 atour. All rights reserved.
//

#ifndef BlockDefine_h
#define BlockDefine_h
#import <Foundation/Foundation.h>

typedef void(^LNBlock)();
typedef void(^LNClickBlock)(int index);
typedef void(^LNBoolBlock)(BOOL isSuccess);
typedef void(^LNArrayBlock)(NSArray *items);
typedef void(^LNNetworkBlcok)(NSError *error,id result);

#endif /* BlockDefine_h */
