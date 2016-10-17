//
//  LNChartPointLayer.m
//  LNChart
//
//  Created by vvusu on 10/14/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNChartPointLayer.h"
#import "LNChartData.h"

@interface LNChartPointLayer ()
@property (nonatomic, assign) BOOL isAnimation;
@property (nonatomic, assign) CGPoint point;                  //Point
@property (nonatomic, assign) CGFloat edgeWidth;               //边框宽度
@property (nonatomic, assign) CGFloat pointWidth;              //点的宽度
@property (nonatomic, assign) CGFloat centerWidth;             //边框宽度
@property (nonatomic, assign) CGFloat twinkleWidth;            //闪烁的宽度
@property (nonatomic, strong) UIColor *edgeColor;              //边框颜色
@property (nonatomic, strong) UIColor *twinkleColor;           //闪烁的点颜色
@property (nonatomic, strong) CALayer *edgeLayer;              //边框Layer
@property (nonatomic, strong) CALayer *pointLayer;             //点的Layer
@property (nonatomic, strong) CALayer *twinkleLayer;           //闪动的Layer
@property (nonatomic, strong) CAAnimationGroup *pointCAGroups; //动画组
@end

@implementation LNChartPointLayer

- (CALayer *)twinkleLayer {
    if (!_twinkleLayer) {
        _twinkleWidth = 16.0f;
        _twinkleColor = [UIColor colorWithRed:0.08 green:0.47 blue:0.94 alpha:1.00];
        _twinkleLayer = [[CALayer alloc]init];
        _twinkleLayer.cornerRadius = _twinkleWidth * 0.5;
        _twinkleLayer.backgroundColor = _twinkleColor.CGColor;
        _twinkleLayer.bounds = CGRectMake(0, 0, _twinkleWidth, _twinkleWidth);
        _twinkleLayer.position = _point;
        [self addSublayer:_twinkleLayer];
    }
    return _twinkleLayer;
}

- (CALayer *)edgeLayer {
    if (!_edgeLayer) {
        _edgeWidth = 6.0f;
        _edgeColor = [UIColor colorWithRed:0.78 green:0.80 blue:0.78 alpha:1.00];
        _edgeLayer = [[CALayer alloc]init];
        _edgeLayer.cornerRadius = _edgeWidth * 0.5;
        _edgeLayer.backgroundColor = _edgeColor.CGColor;
        _edgeLayer.frame = CGRectMake(0, 0, _edgeWidth, _edgeWidth);
        _edgeLayer.position = _point;
        [self addSublayer:_edgeLayer];
    }
    return _edgeLayer;
}

- (CALayer *)pointLayer {
    if (!_pointLayer) {
        _pointWidth = 4.0f;
        _pointLayer = [[CALayer alloc]init];
        _pointLayer.cornerRadius = _pointWidth * 0.5;
        _pointLayer.backgroundColor = [UIColor greenColor].CGColor;
        _pointLayer.frame = CGRectMake(0, 0, _pointWidth, _pointWidth);
        _pointLayer.position = _point;
        [self addSublayer:_pointLayer];
    }
    return _pointLayer;
}


- (CAAnimationGroup *)pointCAGroups {
    if (!_pointCAGroups) {
        // 缩放动画
        CABasicAnimation * scaleAnim = [CABasicAnimation animation];
        scaleAnim.keyPath = @"transform.scale";
        scaleAnim.fromValue = @0.1;
        scaleAnim.toValue = @1;
        scaleAnim.duration = 2;
        // 透明度动画
        CABasicAnimation *opacityAnim=[CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim.fromValue= @1;
        opacityAnim.toValue= @0.1;
        opacityAnim.duration= 2;
        // 创建动画组
        _pointCAGroups =[CAAnimationGroup animation];
        _pointCAGroups.animations = @[scaleAnim,opacityAnim];
        _pointCAGroups.removedOnCompletion = NO;
        _pointCAGroups.fillMode = kCAFillModeForwards;
        _pointCAGroups.duration = 2;
        _pointCAGroups.repeatCount = FLT_MAX;
    }
    return _pointCAGroups;
}

//开始呼吸动画
- (void)startPointAnimation {
    if (self.isAnimation) {
        return;
    }
    self.hidden = NO;
    self.isAnimation = YES;
    [self.twinkleLayer addAnimation:self.pointCAGroups forKey:@"groups"];
}

//结束呼吸动画
- (void)stopPointAnimation {
    if (self.isAnimation) {
        self.hidden = YES;
        self.isAnimation = NO;
        [self.twinkleLayer removeAllAnimations];
    }
}

- (void)changeLayerStatus:(LNChartData *)chartData {
    if (chartData.lineSet.isDrawLastPoint) {
        if (chartData.lineSet.linePoints.count >= 1) {
            NSValue *value = ((NSArray *)chartData.lineSet.linePoints.firstObject).lastObject;
            if (value) {
                _point = [value CGPointValue];
                self.twinkleLayer.position = _point;
                self.edgeLayer.position = _point;
                self.pointLayer.position = _point;
                [self startPointAnimation];
            }
        }
    } else {
        [self stopPointAnimation];
    }
}

@end
