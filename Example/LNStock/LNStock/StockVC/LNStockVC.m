//
//  LNQuotesVC.m
//  Market
//
//  Created by vvusu on 5/3/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockVC.h"
#import "LNStockHandler.h"
#import "LNStockModel.h"

@interface LNStockVC ()
@property (nonatomic, strong) LNStockView *quotesView;
@end

@implementation LNStockVC

- (instancetype)initWithStockInfo:(LNStockHandler *)stockInfo {
    if (self == [super init]) {
        self.stockInfo = stockInfo;
    }
    return self;
}

- (instancetype)initWithStockModel:(LNStockModel *)stockModel {
    if (self == [super init]) {
        self.stockInfo = [LNStockHandler setupWithStockModel:stockModel];
    }
    return self;
}

+ (instancetype)initWithStockModel:(LNStockModel *)stockModel {
    return [LNStockVC initWithStockInfo:[LNStockHandler setupWithStockModel:stockModel]];
}

+ (instancetype)initWithStockInfo:(LNStockHandler *)stockInfo {
    LNStockVC *stockVC = [[LNStockVC alloc]init];
    stockVC.stockInfo = stockInfo;
    return stockVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
    [LNStockHandler sharedManager].verticalScreen = NO;
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
    [LNStockHandler sharedManager].verticalScreen = YES;
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
        CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _quotesView = [LNStockView createWithStockInfo:self.stockInfo frame:rect];
        _quotesView.quotesViewBlock = ^(LNStockViewActionType type){
            if (type == LNStockViewActionTypeTapTwo) {
                if (wself.navigationController == nil && wself.presentingViewController != nil) {
                    [wself dismissViewControllerAnimated:YES completion:^{}];
                    return;
                }
                if ([wself.navigationController.viewControllers firstObject] == wself) {
                    if (wself.navigationController.presentingViewController != nil) {
                        [wself.navigationController dismissViewControllerAnimated:YES completion:^{}];
                    }
                } else {
                    [wself.navigationController popViewControllerAnimated:YES];
                }
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
