//
//  PriceNavView.m
//  Market
//
//  Created by ZhangBob on 4/22/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "PriceNavView.h"
#import "PListUtils.h"
#import <LNStock/LNStock.h>

@implementation PriceNavView

- (void)awakeFromNib {
    self.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 64);
    [self.backBtn setImage:[UIImage imageNamed:@"price_nav_backbtn"] forState:UIControlStateNormal];
    [self.refreshButton setImage:[UIImage imageNamed:@"price_nav_refreshbtn"] forState:UIControlStateNormal];
}


- (void)addThemeChangeWithMode:(BOOL)isNightMode {
    if (isNightMode == 0) {
        self.backgroundColor = [UIColor whiteColor];
        self.navTitleLabel.textColor = [UIColor blackColor];
        self.navBorderView.backgroundColor = [UIColor whiteColor];
     } else {
        self.backgroundColor = kColorHex(0x172836);
        self.navTitleLabel.textColor = [UIColor whiteColor];
        self.navBorderView.backgroundColor = [UIColor blackColor];
    }
}

- (IBAction)backButtonAction:(id)sender {
    UINavigationController *navigationController = (id)[UIApplication sharedApplication].delegate.window.rootViewController;
    [navigationController popViewControllerAnimated:YES];
}

- (IBAction)refreshButtonAction:(id)sender {
    [self startRefreshButtonAnimation];
    if (self.block) {
        self.block();
    }
}

+ (id)createWithXib {
    NSString *className = NSStringFromClass([self class]);
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil];
    return views[0];
}

- (void)startRefreshButtonAnimation {
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:-M_PI * 2];
    rotationAnimation.duration = 1;
    rotationAnimation.repeatCount = FLT_MAX;
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO; //No Remove
    [self.refreshButton.layer addAnimation:rotationAnimation forKey:@"rotation"];
}
- (void)stopRefreshButtonAnimation {
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(stopAnimation) userInfo:nil repeats:NO];
}
- (void)stopAnimation {
    [self.refreshButton.layer removeAnimationForKey:@"rotation"];
}
@end
