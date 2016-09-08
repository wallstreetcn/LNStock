//
//  LNStockLodingView.m
//  LNStock
//
//  Created by vvusu on 6/3/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockLodingView.h"

@interface LNStockLodingView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@end

@implementation LNStockLodingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.color = [UIColor grayColor];
    _activityView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2);
    [_activityView startAnimating];
    [self addSubview:_activityView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_activityView.frame) + 10, self.frame.size.width, 20)];
    _titleLabel.text = @"正在加载数据...";
    _titleLabel.textColor = [UIColor grayColor];
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
}

@end
