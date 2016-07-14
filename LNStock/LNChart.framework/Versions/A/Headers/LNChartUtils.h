//
//  LNChartUtils.h
//  Market
//
//  Created by vvusu on 4/27/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface LNChartUtils : NSObject

#pragma mark -  绘制圆
+ (void)drawCircle:(nullable CGContextRef)context
         fillColor:(nullable UIColor*)fillColor
            radius:(CGFloat)radius
             point:(CGPoint)point;

+ (void)drawCircles:(nullable CGContextRef)context
          fillColor:(nullable UIColor*)fillColor
             points:(nullable NSArray *)points
             radius:(CGFloat)radius;

+ (void)drawCircle:(nullable CGContextRef)context
         lineColor:(nullable UIColor *)color
         fillColor:(nullable UIColor*)fillColor
         lineWidth:(CGFloat)lineWidth
            radius:(CGFloat)radius
             point:(CGPoint)point;

#pragma mark -  绘制矩形
+ (void)drawRect:(nullable CGContextRef)context
           color:(nullable UIColor*)color
            rect:(CGRect)rect;

+ (void)drawRects:(nullable CGContextRef)context
           points:(nullable NSArray *)points;

//绘制矩形加线框 并填充颜色
+ (void)drawRect:(nullable CGContextRef)context
       lineColor:(nullable UIColor*)lineColor
       fillColor:(nullable UIColor*)fileColor
       lineWidth:(CGFloat)lineWidth
            rect:(CGRect)rect;

#pragma mark -  绘制单条线段
+ (void)drawLine:(nullable CGContextRef)context
           color:(nullable UIColor *)color
           width:(CGFloat)width
       statPoint:(CGPoint)statPoint
        endPoint:(CGPoint)endPoint;

#pragma mark -  画多条线段
+ (void)drawLines:(nullable CGContextRef)context
           points:(nullable NSArray *)points
            color:(nullable UIColor *)color
            width:(CGFloat)width;

#pragma mark -  画一条虚线
+ (void)drawDottedLine:(nullable CGContextRef)context
                 color:(nullable UIColor *)color
                 width:(CGFloat)width
             statPoint:(CGPoint)statPoint
              endPoint:(CGPoint)endPoint;

#pragma mark - 画一段文字
+ (void)drawText:(nullable CGContextRef)context
            text:(nullable NSString *)text
           point:(CGPoint)point
           align:(NSTextAlignment)align
      attributes:(nullable NSDictionary<NSString *, id> *)attributes;

#pragma mark - 画时间文字
+ (void)drawMultilineText:(nullable CGContextRef)context
                     text:(nullable NSString *)text
                    point:(CGPoint)point
               attributes:(nullable NSDictionary<NSString *, id> *)attributes;

#pragma mark - 根据路径填充颜色
//一个颜色
+ (void)drawFilledPath:(nullable CGContextRef)context
                  path:(nullable CGPathRef)path
             fillColor:(nullable UIColor *)fillColor
             fillAlpha:(CGFloat)fillAlpha;

//渐变色
+ (void)drawFilledPath:(nullable CGContextRef)context
                  path:(nullable CGPathRef)path
                 alpha:(CGFloat)alpha
            startColor:(nullable CGColorRef)startColor
              endColor:(nullable CGColorRef)endColor;

//通过一组点填充颜色
+ (void)drawFilledPath:(nullable CGContextRef)context
            startColor:(nullable UIColor *)startColor
              endColor:(nullable UIColor *)endColor
                points:(nullable NSArray *)points
                 alpha:(CGFloat)alpha;

#pragma mark - 获取两点的距离
+ (CGFloat)distanceFromPoint:(CGPoint)start toPoint:(CGPoint)end;

@end
