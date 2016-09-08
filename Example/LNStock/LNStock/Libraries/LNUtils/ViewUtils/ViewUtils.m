//
//  ViewUtils.m
//  AtourLife
//
//  Created by vvusu on 3/12/16.
//  Copyright © 2016 Anasue. All rights reserved.
//

#import "ViewUtils.h"

@interface ViewUtils ()
@property (copy, nonatomic) void(^actionSheetBlock)(int index);
@property (assign, nonatomic) NSNumber *actionSheetShowing;
@end

@implementation ViewUtils

+ (instancetype)sharedInstance {
    static id instance = nil;
    if (!instance) {
        instance = [[ViewUtils alloc] init];
        [[UIView appearanceWhenContainedIn:[UIActionSheet class], nil] setTintColor:[UIColor blueColor]];
    }
    return instance;
}

#pragma mark - AlertView
+ (void)showPaymentAlertViewWith:(UIViewController *)viewController titles:(NSArray *)titles {
    UIView *mask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewController.view.frame.size.width, viewController.view.frame.size.height)];
    mask.backgroundColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1];
    [viewController.view addSubview:mask];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择支付方式" message:nil preferredStyle:UIAlertControllerStyleAlert];
    for (NSInteger i = 0; i<titles.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:titles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        
    }
    alert.view.tintColor = [UIColor redColor];
    [viewController presentViewController:alert animated:YES completion:nil];
}

+ (void)showCancelAlertView:(UIViewController *)viewController
                      title:(NSString *)title
              completeBlock:(void(^)())block {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block();
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [viewController presentViewController:alert animated:YES completion:nil];
}

+ (void)showAlertView:(UIViewController *)viewController
                 info:(NSString *)info
        completeBlock:(void(^)())block {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:info message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block();
        }
    }]];
    [alert.view setNeedsLayout];
    [viewController presentViewController:alert animated:YES completion:nil];
    [alert.view setTintColor:[UIColor blackColor]];
}

#pragma mark - ActionSheetView
+ (void)showActionSheetViewWithController:(UIViewController *)VC
                                   titles:(NSArray *)titles
                            completeBlock:(void(^)(int index))block {
    [self showActionSheetView:nil controller:VC titles:titles completeBlock:^(int index) {
        if (block) {
            block(index);
        }
    }];
}

+ (void)showActionSheetView:(NSString *)title
                 controller:(UIViewController *)VC
                     titles:(NSArray *)titles
              completeBlock:(void(^)(int index))block {
    
    if (!titles.count) {
        return;
    }
    NSNumber *actionSheetShowing = [[self sharedInstance] valueForKey:@"actionSheetShowing"];
    if (actionSheetShowing.boolValue) {
        return;
    }
    [[self sharedInstance] setValue:@(YES) forKey:@"actionSheetShowing"];
    [[self sharedInstance] setValue:block forKey:@"actionSheetBlock"];
    titles = [titles arrayByAddingObject:@"取消"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof([self sharedInstance]) wSelf = [self sharedInstance];
    for (NSInteger index = 0; index < titles.count; index++) {
        NSString *title = titles[index];
        UIAlertActionStyle actionStyle = ((index == titles.count - 1) ? UIAlertActionStyleCancel : UIAlertActionStyleDefault);
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:actionStyle handler:^(UIAlertAction * _Nonnull action) {
            [wSelf setValue:@(NO) forKey:@"actionSheetShowing"];
            if (block) {
                block((int)index);
            }
        }];
        [alert addAction:action];
    }
    //修改主题颜色
    [VC presentViewController:alert animated:YES completion:nil];
    [alert.view setTintColor:[UIColor blackColor]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.actionSheetBlock) {
        self.actionSheetBlock((int)buttonIndex);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.actionSheetShowing = @(NO);
    self.actionSheetBlock = nil;
}

@end
