//
//  LNChartAction.m
//  LNChart
//
//  Created by vvusu on 10/13/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNChartAction.h"
#import "LNChartData.h"

#define MIN_TOGGLE_DURATION 0.2
#define MAX_TOGGLE_DURATION 0.4

#define SCROLL_DURATION 0.4             //回弹滑动时间
#define SCROLL_SPEED_THRESHOLD 2.0      //速度的最小值
#define SCROLL_DISTANCE_THRESHOLD 0.1   //滑动减速的最小值
#define DECELERATION_MULTIPLIER 30.0    //滑动减速的乘数
#define DECELERATE_THRESHOLD 0.1        //开始减速的距离
#define FLOAT_ERROR_MARGIN 0.000001     //差额

@interface LNChartAction()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger numberOfItems;
@property (nonatomic, assign) NSInteger currentItemIndex;                   //当前item的下标
@property (nonatomic, assign) NSInteger previousItemIndex;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, assign) NSTimeInterval toggleTime;                    //切换时间
@property (nonatomic, assign) NSTimeInterval scrollDuration;                //持续的时间
@property (nonatomic, assign) CGFloat toggle;                               //切换
@property (nonatomic, assign) CGFloat startOffset;                          //开始的
@property (nonatomic, assign) CGFloat endOffset;                            //结束的偏移量
@property (nonatomic, assign) CGFloat scrollSpeed;                          //滑动的速度
@property (nonatomic, assign) CGFloat startVelocity;                        //开始的速率
@property (nonatomic, assign) CGFloat decelerationRate;                     //减速的速率
@property (nonatomic, assign) CGFloat bounceDistance;                       //回弹的距离
@property (nonatomic, assign) CGFloat scrollOffset;                         //滑动的偏移量
@property (nonatomic, assign) CGFloat previousTranslation;                  //位置信息
@end

@implementation LNChartAction

+ (instancetype)setupWithData:(LNChartData *)data {
    LNChartAction *animator = [[LNChartAction alloc]init];
    animator.data = data;
    return animator;
}
//动画参数
- (void)setupDefaultValue {
    _scrollSpeed = 1.0;
    _decelerationRate = 0.95;
    _numberOfItems = self.data.dataSets.count;
    _bounceDistance = self.data.valCount / 4;   //弹跳的距离
}

#pragma mark UIPinchGestureRecognizer

- (void)animationWithLongPressGestureRecognizer:(UILongPressGestureRecognizer *)longPress
                                           view:(UIView *)view
                                      chartTyoe:(NSInteger)type {
    
    CGPoint point = [longPress locationInView:view];
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
            self.data.highlighter.highlight = YES;
            [self computeHighlightPoint:point type:type];
            break;
        case UIGestureRecognizerStateChanged:
            [self computeHighlightPoint:point type:type];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            self.data.highlighter.highlight = NO;
            self.data.highlighter.touchPoint = point;
            break;
        default:
            break;
    }
    
    if (self.animatorBlock) {
        self.animatorBlock(LNChartActionType_LongPress, longPress, NO);
    }
}

- (void)computeHighlightPoint:(CGPoint)point type:(NSInteger)type {
    if (point.x < self.data.viewHandler.contentLeft ||
        point.x > self.data.viewHandler.contentRight) {
        return;
    }
    CGFloat volumeWidth = self.data.candleSet.candleW;
    switch (type) {
        case 0:
            volumeWidth = self.data.viewHandler.contentWidth / self.data.valCount;
            break;
        case 1:
            if (((LNDataSet *)self.data.dataSets.firstObject).preClosePx > 0) {
                volumeWidth = self.data.viewHandler.contentWidth / self.data.valCount;
            }
            break;
        default:
            break;
    }
    self.data.highlighter.index = (NSInteger)((point.x - self.data.viewHandler.contentLeft) / volumeWidth);
    self.data.highlighter.touchPoint = point;
    self.data.highlighter.index += self.data.lastStart;
    if (self.data.highlighter.index > self.data.dataSets.count - 1) {
        self.data.highlighter.index = self.data.dataSets.count - 1;
    }
}

#pragma mark UIPinchGestureRecognizer

static NSInteger temp;
static NSInteger lastYValCount;
- (void)animationWithPinchGestureRecognizer:(UIPinchGestureRecognizer *)pinch view:(UIView *)view {
    if (pinch.state == UIGestureRecognizerStateBegan) {
        lastYValCount = self.data.valCount;
        temp = 0;
    }
    CGFloat candleW = self.data.candleSet.candleW * pinch.scale;
    if (candleW > self.data.candleSet.candleMaxW ||
        candleW < self.data.candleSet.candleMinW) {
        return;
    }
    self.data.candleSet.candleW = candleW;
    CGFloat valCount = self.data.viewHandler.contentWidth / self.data.candleSet.candleW;
    NSInteger offset = floor(valCount) - lastYValCount;
    self.data.valCount = floor(valCount);
    
    if (offset % 2 != 0) {
        //左右各加一次
        if (temp % 2 == 0) {
            NSInteger num = 1;
            if (offset < 0) {
                num = -1;
            }
            self.data.lastStart -= num;
        }
        temp++;
    }
    
    if (self.data.valCount < self.data.dataSets.count) {
        self.data.lastStart -= offset/2;
        self.data.lastEnd = self.data.lastStart + self.data.valCount;
    }
    else {
        self.data.lastStart = 0;
        self.data.lastEnd = self.data.dataSets.count;
    }
    lastYValCount = self.data.valCount;
    if (self.animatorBlock) {
        self.animatorBlock(LNChartActionType_Pinch, nil, NO);
    }
    pinch.scale = 1.0f;
    [self setupDefaultValue];  //重新设置回弹距离
}

#pragma mark UIPanGestureRecognizer

- (void)animationWithPanGestureRecognizer:(UIPanGestureRecognizer *)pan view:(UIView *)view {
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            _dragging = YES;
            _scrolling = NO;
            _decelerating = NO;
            _scrollOffset = self.data.lastStart;
            _previousTranslation = [pan translationInView:view].x;
        }
            break;
        case UIGestureRecognizerStateChanged: {
            //坐标系中X的值 向左 为 负 向右为 正
            CGFloat velocity = [pan velocityInView:view].x;
            //坐标系中的像素/秒的速度
            CGFloat translation = [pan translationInView:view].x;
            //因子 滑动的速度
            CGFloat factor = 0.5;
            //开始的速率
            _startVelocity = -velocity * factor * _scrollSpeed / self.data.candleSet.candleW;
            //偏移量
            _scrollOffset -= (translation - _previousTranslation) / self.data.candleSet.candleW;
            _previousTranslation = translation;
            [self didScroll];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            _dragging = NO;
            //判断是否可以减速
            if ([self shouldDecelerate]) {
                [self startDecelerating];
            }
            //如果不在减速过程中
            if (!_decelerating) {
                if ((fabs(_scrollOffset - [self clampedOffset:_scrollOffset]) > FLOAT_ERROR_MARGIN)) {
                    if (fabs(_scrollOffset - self.currentItemIndex) < FLOAT_ERROR_MARGIN) {
                        [self scrollToItemAtIndex:self.currentItemIndex duration:0.01];
                    }
                    else if ([self shouldScroll]) {
                        NSInteger direction = (int)(_startVelocity / fabs(_startVelocity));
                        [self scrollToItemAtIndex:self.currentItemIndex + direction animated:YES];
                    }
                    else {
                        [self scrollToItemAtIndex:self.currentItemIndex animated:YES];
                    }
                }
            }
            
            //请求加载更多数据
            if (self.data.loadMoreType == ChartLoadMoreType_Start) {
                self.data.loadMoreType = ChartLoadMoreType_Loading;
                if (self.animatorBlock) {
                    self.animatorBlock(LNChartActionType_LeftAction,nil,NO);
                }
            }
        }
            break;
        case UIGestureRecognizerStatePossible:
            break;
    }
}


#pragma mark - Animation

- (void)startAnimation {
    if (!_timer) {
        self.timer = [NSTimer timerWithTimeInterval:1.0/60.0
                                             target:self
                                           selector:@selector(step:)
                                           userInfo:nil
                                            repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
    }
}

- (void)stopAnimation {
    [_timer invalidate];
    _timer = nil;
    _dragging = NO;
    _scrolling = NO;
    _decelerating = NO;
    if (self.animatorBlock) {
        self.animatorBlock(LNChartActionType_Pan, nil, YES);
    }
}

- (void)step:(NSTimer *)step {
    //可能系统会跳过帧数，时间差值会有变化 这里进行判断
    NSTimeInterval currentTime = CACurrentMediaTime();
    double delta = currentTime - _lastTime;
    _lastTime = currentTime;
    
    //正在滑动中 -- 加速回弹
    if (_scrolling && !_dragging) {
        NSTimeInterval time = MIN(1.0, (currentTime - _startTime) / _scrollDuration);
        //按一定公式计算得到速率
        delta = [self easeInOut:time];
        //最后滑动的偏移量
        _scrollOffset = _startOffset + (_endOffset - _startOffset) * delta;
        
        [self didScroll];
        if (time >= 1.0) {
            _scrolling = NO;
        }
    } //正在减速中 -- 减速
    else if (_decelerating) {
        //持续时间
        CGFloat time = MIN(_scrollDuration, currentTime - _startTime);
        //加速度
        CGFloat acceleration = -_startVelocity/_scrollDuration;
        //距离  pow 的2次方
        CGFloat distance = _startVelocity * time + 0.5 * acceleration * pow(time, 2.0);
        //最后滑动的偏移量
        _scrollOffset = _startOffset + distance;
        [self didScroll];
        
        //动画时间超过最大，设置已停止减速
        if (fabs(time - _scrollDuration) < FLOAT_ERROR_MARGIN) {
            _decelerating = NO;
            if ((fabs(_scrollOffset - [self clampedOffset:_scrollOffset]) > FLOAT_ERROR_MARGIN)) {
                if (fabs(_scrollOffset - self.currentItemIndex) < FLOAT_ERROR_MARGIN) {
                    [self scrollToItemAtIndex:self.currentItemIndex duration:0.01];
                }
                else {
                    [self scrollToItemAtIndex:self.currentItemIndex animated:YES];
                }
            }
            else { //四舍五入整数值  round
                CGFloat difference = round(_scrollOffset) - _scrollOffset;
                if (difference > 0.5) {
                    difference = difference - 1.0;
                }
                else if (difference < -0.5) {
                    difference = 1.0 + difference;
                }
                _toggleTime = currentTime - MAX_TOGGLE_DURATION * fabs(difference);
                _toggle = MAX(-1.0, MIN(1.0, -difference));
            }
        }
    } //时间间隔的问题
    else if (fabs(_toggle) > FLOAT_ERROR_MARGIN) {
        //持续的时间
        NSTimeInterval toggleDuration = _startVelocity? MIN(1.0, MAX(0.0, 1.0 / fabs(_startVelocity))): 1.0;
        toggleDuration = MIN_TOGGLE_DURATION + (MAX_TOGGLE_DURATION - MIN_TOGGLE_DURATION) * toggleDuration;
        NSTimeInterval time = MIN(1.0, (currentTime - _toggleTime) / toggleDuration);
        delta = [self easeInOut:time];
        _toggle = (_toggle < 0.0)? (delta - 1.0): (1.0 - delta);
        [self didScroll];
    }
    else {
        [self stopAnimation];
    }
    //floor() 向下取整 ceil() 向上取整
}

//开始减速
- (void)startDecelerating {
    CGFloat distance = [self decelerationDistance];
    _startOffset = _scrollOffset;
    _endOffset = _startOffset + distance;
    
    if (_numberOfItems > self.data.valCount) {
        _endOffset = MAX(-_bounceDistance, MIN(_numberOfItems - self.data.valCount + _bounceDistance, _endOffset));
    } else {
        //最大显示数比数据量大时
        _endOffset = MAX(-_bounceDistance, MIN(_bounceDistance, _endOffset));
    }
    
    distance = _endOffset - _startOffset;
    
    _startTime = CACurrentMediaTime();
    _scrollDuration = fabs(distance) / fabs(0.5 * _startVelocity);
    
    if (distance != 0.0) {
        _decelerating = YES;
        [self startAnimation];
    }
}

//开始滑动，加减速运动
- (void)didScroll {
    CGFloat min = -_bounceDistance;
    CGFloat max = 0;
    if (_numberOfItems > self.data.valCount) {
        max = MAX(_numberOfItems - self.data.valCount, 0.0) + _bounceDistance;
    } else {
        max = MAX(0, 0.0) + _bounceDistance;
    }
    
    if (_scrollOffset < min) {
        _scrollOffset = min;
        _startVelocity = 0.0;
        //左拉加載更多数据Block回調
        if (self.data.loadMoreType == ChartLoadMoreType_Normal) {
            self.data.loadMoreType = ChartLoadMoreType_Start;
        }
    }
    else if (_scrollOffset > max) {
        _scrollOffset = max;
        _startVelocity = 0.0;
    }
    
    //check if index has changed
    NSInteger difference = [self minScrollDistanceFromIndex:self.currentItemIndex toIndex:self.previousItemIndex];
    if (difference) {
        //节点时间
        _toggleTime = CACurrentMediaTime();
        //节点距离
        _toggle = MAX(-1, MIN(1, difference));
        [self startAnimation];
    }
    if ([self.data hasEmptyNum]) {
        [self.data resetDataSetsAfterAnimation];
    }
    NSInteger offset = 0;
    if (_scrollOffset < 0) {
        offset = _scrollOffset;
        self.data.emptyStartNum = labs(offset);
        [self.data addEmptyCandleWhenAnimation:labs(offset)];
    }
    else if (_scrollOffset > self.data.dataSets.count - self.data.valCount){
        offset = _scrollOffset - (self.data.dataSets.count - self.data.valCount);
        self.data.emptyEndNum = labs(offset);
    }
    
    self.data.lastStart = _scrollOffset;
    self.data.lastEnd = self.data.lastStart + self.data.valCount;
    _previousItemIndex = self.currentItemIndex;
    
    if (self.animatorBlock) {
        self.animatorBlock(LNChartActionType_Pan, nil, NO);
    }
}

- (void)setScrollOffset:(CGFloat)scrollOffset {
    _scrolling = NO;
    _decelerating = NO;
    _startOffset = scrollOffset;
    _endOffset = scrollOffset;
    if (fabs(_scrollOffset - scrollOffset) > 0.0) {
        _scrollOffset = scrollOffset;
        [self didScroll];
    }
}

- (void)setCurrentItemIndex:(NSInteger)currentItemIndex {
    [self setScrollOffset:currentItemIndex];
}

- (NSInteger)currentItemIndex {
    return [self clampedIndex:round(_scrollOffset)];
}

- (NSInteger)clampedIndex:(NSInteger)index {
    if (_numberOfItems == 0) {
        return -1;
    } else {
        if (_numberOfItems > self.data.valCount) {
            return MIN(MAX(0, index), MAX(0, _numberOfItems - self.data.valCount));
        } else {
            return MIN(MAX(0, index), MAX(0, 0));
        }
    }
}

- (void)scrollByOffset:(CGFloat)offset duration:(NSTimeInterval)duration {
    if (duration > 0.0) {
        _decelerating = NO;
        _scrolling = YES;
        _startTime = CACurrentMediaTime();
        _startOffset = _scrollOffset;
        _scrollDuration = duration;
        _endOffset = _startOffset + offset;
        _endOffset = [self clampedOffset:_endOffset];
        [self startAnimation];
    } else {
        self.scrollOffset += offset;
    }
}

- (void)scrollToOffset:(CGFloat)offset duration:(NSTimeInterval)duration {
    [self scrollByOffset:[self minScrollDistanceFromOffset:_scrollOffset toOffset:offset] duration:duration];
}

- (CGFloat)minScrollDistanceFromOffset:(CGFloat)fromOffset toOffset:(CGFloat)toOffset {
    CGFloat directDistance = toOffset - fromOffset;
    return directDistance;
}

- (NSInteger)minScrollDistanceFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    NSInteger directDistance = toIndex - fromIndex;
    return directDistance;
}

- (void)scrollToItemAtIndex:(NSInteger)index duration:(NSTimeInterval)duration {
    [self scrollToOffset:index duration:duration];
}

- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated {
    [self scrollToItemAtIndex:index duration:animated? SCROLL_DURATION: 0];
}

//计算偏移量
- (CGFloat)clampedOffset:(CGFloat)offset {
    if (_numberOfItems == 0) {
        return -1.0;
    } else {
        if (_numberOfItems > self.data.valCount) {
            //最大lastStart 的最大值
            return MIN(MAX(0.0, offset), MAX(0.0, (CGFloat)_numberOfItems - self.data.valCount));
        } else {
            return MIN(MAX(0.0, offset), MAX(0.0, 0));
        }
    }
}

//是否开始减速
- (BOOL)shouldDecelerate {
    return (fabs(_startVelocity) > SCROLL_SPEED_THRESHOLD) &&
    (fabs([self decelerationDistance]) > DECELERATE_THRESHOLD);
}

//衰减的距离
- (CGFloat)decelerationDistance {
    //加速度
    CGFloat acceleration = -_startVelocity * DECELERATION_MULTIPLIER * (1.0 - _decelerationRate);
    return -pow(_startVelocity, 2.0) / (2.0 * acceleration);
}

//是否开始滑动
- (BOOL)shouldScroll {
    return (fabs(_startVelocity) > SCROLL_SPEED_THRESHOLD) &&
    (fabs(_scrollOffset - self.currentItemIndex) > SCROLL_DISTANCE_THRESHOLD);
}

//减缓时间
- (CGFloat)easeInOut:(CGFloat)time {
    return (time < 0.5)? 0.5 * pow(time * 2.0, 3.0): 0.5 * pow(time * 2.0 - 2.0, 3.0) + 1.0;
}

//减缓时间
- (CGFloat)circularEaseOut:(CGFloat)time {
    return sqrt((2 - time) * time);
}

@end
