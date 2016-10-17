//
//  LNChartBase.m
//  Market
//
//  Created by vvusu on 4/27/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNChartBase.h"

@interface LNChartBase ()
@end

@implementation LNChartBase

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"frame"];
    [self removeObserver:self forKeyPath:@"bounds"];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupChart];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupChart];
    }
    return self;
}

- (void)setupChart {
    _borderLineWidth = 0.5f;
    _borderColor = [UIColor blackColor];
    _gridBackgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];

    _drawInfoEnabled = YES;
    _noDataText = @"暂无数据";
    _infoTextColor = [UIColor grayColor];
    _infoFont = [UIFont systemFontOfSize:14];
    
    _descriptionTextColor = [UIColor blackColor];
    _descriptionFont = [UIFont systemFontOfSize:9.0];
    
    _xAxis = [[LNXAxis alloc]init];
    _viewHandler = [LNChartHandler initWith:self.frame.size.width height:self.frame.size.height];
    [_viewHandler restrainViewPort:45 offsetTop:0 offsetRight:45 offsetBottom:15];
    _data = [LNChartData initWithHandler:_viewHandler];
    
    self.backgroundColor = _gridBackgroundColor;
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:nil];
    
    [[UIDevice currentDevice]beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

#pragma mark - Notifation

- (void)deviceOrientationDidChange:(NSNotification *) notification {
    if([UIDevice currentDevice].orientation != UIDeviceOrientationUnknown) {
        [self notifyDeviceOrientationChanged];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"bounds"] || [keyPath isEqualToString:@"frame"]) {
        CGRect bounds = self.bounds;
        if (_viewHandler != nil && (bounds.size.width != _viewHandler.chartWidth || bounds.size.height != _viewHandler.chartHeight)) {
            [_viewHandler setChartDimens:bounds.size.width height:bounds.size.height];
            [self notifyDataSetChanged];
        }
    }
}

- (void)notifyDataSetChanged {
}

- (void)notifyDeviceOrientationChanged {
}

#pragma mark - Method

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.data.dataSets.count == 0) {
        //绘制没有数据的状态
        if (_drawInfoEnabled) {
            CGContextRef context = UIGraphicsGetCurrentContext();
            [LNChartUtils drawText:context text:_noDataText point:CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2.0) align:NSTextAlignmentCenter attributes:@{NSFontAttributeName:_infoFont,NSForegroundColorAttributeName:_infoTextColor}];
        }
    }
}

- (void)setExtraOffsetsLeft:(CGFloat)left
                        top:(CGFloat)top
                      right:(CGFloat)right
                     bottom:(CGFloat)bottom {
    
    [_viewHandler restrainViewPort:left offsetTop:top offsetRight:right offsetBottom:bottom];
}

@end
