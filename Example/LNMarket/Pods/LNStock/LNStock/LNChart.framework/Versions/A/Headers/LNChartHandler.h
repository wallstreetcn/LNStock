//
//  LNChartHandler.h
//  Market
//
//  Created by vvusu on 5/4/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LNChartHandler : NSObject

@property (nonatomic, assign) CGFloat chartWidth;
@property (nonatomic, assign) CGFloat chartHeight;

@property (nonatomic, assign) CGFloat minScaleX;
@property (nonatomic, assign) CGFloat maxScaleX;

@property (nonatomic, assign) CGFloat minScaleY;
@property (nonatomic, assign) CGFloat maxScaleY;

@property (nonatomic, assign) CGFloat scaleX;
@property (nonatomic, assign) CGFloat scaleY;

@property (nonatomic, assign) CGFloat transX;
@property (nonatomic, assign) CGFloat transY;

@property (nonatomic, assign) CGFloat transOffsetX;
@property (nonatomic, assign) CGFloat transOffsetY;
@property (nonatomic, assign) CGRect contentRect;
@property (nonatomic, assign) CGFloat emptyHeight;

- (CGFloat)offsetTop;
- (CGFloat)offsetLeft;
- (CGFloat)offsetRight;
- (CGFloat)offsetBottom;

- (CGFloat)contentTop;
- (CGFloat)contentLeft;
- (CGFloat)contentRight;
- (CGFloat)contentBottom;
- (CGFloat)contentWidth;
- (CGFloat)contentHeight;

+ (instancetype)initWith:(CGFloat)width
                  height:(CGFloat)height;

- (void)setChartDimens:(CGFloat)width
                height:(CGFloat)height;

- (void)restrainViewPort:(CGFloat)offsetLeft
               offsetTop:(CGFloat)offsetTop
             offsetRight:(CGFloat)offsetRight
            offsetBottom:(CGFloat)offsetBottom;

@end
