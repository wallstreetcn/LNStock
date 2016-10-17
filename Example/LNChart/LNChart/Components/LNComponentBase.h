//
//  LNComponentBase.h
//  Market
//
//  Created by vvusu on 5/3/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LNComponentBase : NSObject
@property (nonatomic, assign) CGFloat xOffset;
@property (nonatomic, assign) CGFloat yOffset;
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;
@end
