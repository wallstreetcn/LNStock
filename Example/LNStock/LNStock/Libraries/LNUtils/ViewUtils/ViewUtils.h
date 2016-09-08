//
//  ViewUtils.h
//  AtourLife
//
//  Created by vvusu on 3/12/16.
//  Copyright © 2016 Anasue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewUtils : NSObject

//AlertView
+ (void)showCancelAlertView:(UIViewController *)viewController
                      title:(NSString *)title
              completeBlock:(void(^)())block;

+ (void)showActionSheetView:(NSString *)title
                 controller:(UIViewController *)VC
                     titles:(NSArray *)titles
              completeBlock:(void(^)(int index))block;

+ (void)showAlertView:(UIViewController *)viewController
                 info:(NSString *)info
        completeBlock:(void(^)())block;
@end
