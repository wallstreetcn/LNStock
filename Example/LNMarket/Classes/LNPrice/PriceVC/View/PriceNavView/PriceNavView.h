//
//  PriceNavView.h
//  Market
//
//  Created by ZhangBob on 4/22/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Block)();
@interface PriceNavView : UIView

@property (weak, nonatomic) IBOutlet UILabel *navTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIView *navBorderView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (copy, nonatomic) Block block;
@property (assign, nonatomic) BOOL isNightMode;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)refreshButtonAction:(id)sender;

+ (id)createWithXib;
- (void)addThemeChangeWithMode:(BOOL)isNightMode;
- (void)startRefreshButtonAnimation;
- (void)stopRefreshButtonAnimation;

@end
