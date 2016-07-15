//
//  LNChartAnimator.h
//  Market
//
//  Created by vvusu on 5/12/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

typedef void (^LNChartAnimatorBlock)(BOOL isStop);

@class LNChartData;
@interface LNChartAnimator : NSObject
@property (nonatomic, strong) LNChartData *data;
@property (nonatomic, copy) LNChartAnimatorBlock animatorBlock;
@property (nonatomic, assign, getter = isScrolling) BOOL scrolling; //是否在滑动

+ (instancetype)setupWithData:(LNChartData *)data;
- (void)stopAnimation;
- (void)setupDefaultValue;
- (void)animationWithPanGestureRecognizer:(UIPanGestureRecognizer *)pan view:(UIView *)view;
@end
