//
//  LNQuotesVC.m
//  Market
//
//  Created by vvusu on 5/3/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockVC.h"
#import "LNStockView.h"
#import "LNStockHandler.h"

@interface LNStockVC ()
@property (nonatomic, strong) LNStockView *quotesView;
@end

@implementation LNStockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self.view addSubview:self.quotesView];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationFade];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

//因为想要手动旋转，所以先关闭自动旋转
- (BOOL)shouldAutorotate{
    return NO;
}

- (LNStockView *)quotesView {
    __weak typeof(self) wself= self;
    if (!_quotesView) {
        _quotesView = [[LNStockView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _quotesView.isGreenUp = [LNStockHandler isGreenUp];
        _quotesView.quotesViewBlock = ^(LNStockViewActionType type){
            if (type == LNStockViewActionTypeTapTwo) {
                [wself dismissViewControllerAnimated:YES completion:nil];
            }
        };
    }
    return _quotesView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
