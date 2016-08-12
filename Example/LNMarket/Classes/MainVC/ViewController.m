//
//  ViewController.m
//  Market
//
//  Created by vvusu on 4/20/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "ViewController.h"
#import "DebugVC.h"
#import "PriceVC.h"
#import "PListUtils.h"

@interface ViewController ()<UITextFieldDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stockTF.delegate = self;
}

- (BOOL)shouldAutorotate {
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)AButtonAction:(id)sender {
    //300264.SZ
    //新股 @"603737.SS"
    if (self.stockTF.text.length == 0) {
        self.stockTF.text = @"300264.SZ";
    }
    BOOL isNightMode = [[PListUtils valueForKey:@"IsNigthMode"] intValue];
    PriceVC *bStockVC = [PriceVC createWithTitle:@"西部黄金(601069)" subtitle:@"已收盘 03-01 15:04:49" symbol:self.stockTF.text isNightMode:isNightMode isAStock:YES];
    [self.navigationController pushViewController:bStockVC animated:YES];
}

- (IBAction)BButtonAction:(id)sender {
    //@"JPN225"
    if (self.stockTF.text.length == 0) {
        self.stockTF.text = @"JPN225";
    }
    BOOL isNightMode = [[PListUtils valueForKey:@"IsNigthMode"] intValue];
    PriceVC *bStockVC = [PriceVC createWithTitle:@"日经225指数期货" subtitle:@"JPN225" symbol:self.stockTF.text isNightMode:isNightMode isAStock:NO];
    [self.navigationController pushViewController:bStockVC animated:YES];
}

- (IBAction)debugAction:(id)sender {
    DebugVC *debugvc = [[DebugVC alloc]init];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:debugvc animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
