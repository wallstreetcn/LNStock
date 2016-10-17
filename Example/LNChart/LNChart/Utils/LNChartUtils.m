//
//  LNChartUtils.m
//  Market
//
//  Created by vvusu on 4/27/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNChartUtils.h"

@implementation LNChartUtils

+ (void)drawCircle:(nullable CGContextRef)context
         fillColor:(nullable UIColor*)fillColor
            radius:(CGFloat)radius
             point:(CGPoint)point {
    
    CGContextSetFillColorWithColor(context, fillColor.CGColor); //填充颜色
    CGContextAddArc (context, point.x, point.y, radius, 0, M_PI* 2 , 0);
    CGContextDrawPath(context, kCGPathFill);  //绘制填充
    //kCGPathFill填充非零绕数规则,kCGPathEOFill表示用奇偶规则,kCGPathStroke路径,kCGPathFillStroke路径填充,kCGPathEOFillStroke表示描线，不是填充
    //CGContextDrawPath(context, kCGPathFillStroke);
}

+ (void)drawCircles:(nullable CGContextRef)context
          fillColor:(nullable UIColor*)fillColor
             points:(nullable NSArray *)points
             radius:(CGFloat)radius {
    
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    for (NSInteger i = 0; i < points.count; i++) {
        NSValue *value = points[i];
        CGPoint point = [value CGPointValue];
        CGContextAddArc (context, point.x, point.y, radius, 0, M_PI* 2 , 0);
        CGContextDrawPath(context, kCGPathFill);  //绘制填充
    }
}

//画圆
+ (void)drawCircle:(nullable CGContextRef)context
         lineColor:(nullable UIColor *)lineColor
         fillColor:(nullable UIColor*)fillColor
         lineWidth:(CGFloat)lineWidth
            radius:(CGFloat)radius
             point:(CGPoint)point {
    
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    //绘制填充
    CGContextAddArc (context, point.x, point.y, radius, 0, M_PI* 2 , 0);
    CGContextDrawPath(context, kCGPathFill);
    //绘制路径
    CGContextAddArc (context, point.x, point.y, radius, 0, M_PI* 2 , 0);
    CGContextDrawPath(context, kCGPathStroke);
}

//绘制矩形
+ (void)drawRect:(nullable CGContextRef)context
           color:(nullable UIColor*)color
            rect:(CGRect)rect {
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
}

+ (void)drawRects:(nullable CGContextRef)context
           points:(nullable NSArray *)points {
    
    for (NSInteger i = 0; i < points.count; i++) {
        
//        [LNChartUtils drawRect:context color:nil rect:nil];
    }
}

//绘制矩形加线框 并填充颜色
+ (void)drawRect:(nullable CGContextRef)context
       lineColor:(nullable UIColor*)lineColor
       fillColor:(nullable UIColor*)fileColor
       lineWidth:(CGFloat)lineWidth
            rect:(CGRect)rect {
    //线的宽度
    CGContextSetLineWidth(context, lineWidth);
    //填充颜色
    CGContextSetFillColorWithColor(context, fileColor.CGColor);
    //线框颜色
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    //画方框
    CGContextAddRect(context,rect);
    //绘画路径
    CGContextDrawPath(context, kCGPathFillStroke);
}

+ (void)drawMultilineText:(nullable CGContextRef)context
                     text:(nullable NSString *)text
                    point:(CGPoint)point
               attributes:(nullable NSDictionary<NSString *, id> *)attributes {
    
    UIGraphicsPushContext(context);
    

}

//画直线
+ (void)drawLine:(nullable CGContextRef)context
           color:(nullable UIColor *)color
           width:(CGFloat)width
       statPoint:(CGPoint)statPoint
        endPoint:(CGPoint)endPoint {
    
    CGContextSetShouldAntialias(context, YES);
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextMoveToPoint(context, statPoint.x, statPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
}

//画折线
+ (void)drawLines:(nullable CGContextRef)context
           points:(nullable NSArray *)points
            color:(nullable UIColor *)color
            width:(CGFloat)width {
    
    CGContextSetShouldAntialias(context, YES);
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    for (NSInteger i = 0; i < points.count; i++) {
        NSValue *value = points[i];
        CGPoint point = [value CGPointValue];
        if (i == 0) {
            CGContextMoveToPoint(context, point.x, point.y);
        } else {
            CGContextAddLineToPoint(context, point.x, point.y);
        }
    }
    CGContextStrokePath(context);
}

//绘制虚线
+ (void)drawDottedLine:(nullable CGContextRef)context
                 color:(nullable UIColor *)color
                 width:(CGFloat)width
             statPoint:(CGPoint)statPoint
              endPoint:(CGPoint)endPoint {
    
    CGPoint points[2] = {statPoint, endPoint};
    CGFloat lengths[] = {5,2};
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextStrokeLineSegments(context, points, 2);
    CGContextRestoreGState(context);
}

//绘制文本
+ (void)drawText:(nullable CGContextRef)context
            text:(nullable NSString *)text
           point:(CGPoint)point
           align:(NSTextAlignment)align
      attributes:(nullable NSDictionary<NSString *, id> *)attributes {

    if (align == NSTextAlignmentCenter) {
        point.x -= [text sizeWithAttributes:attributes].width / 2.0;
    }
    else if (align == NSTextAlignmentRight) {
        point.x -= [text sizeWithAttributes:attributes].width;
    }
    
    UIGraphicsPushContext(context);
    [text drawAtPoint:point withAttributes:attributes];
    UIGraphicsPopContext();
}

//根据路径填充颜色
+ (void)drawFilledPath:(nullable CGContextRef)context
                  path:(nullable CGPathRef)path
             fillColor:(nullable UIColor *)fillColor
             fillAlpha:(CGFloat)fillAlpha {
    
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    CGContextAddPath(context, path);
    
    CGContextSetAlpha(context, fillAlpha);
    
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextFillPath(context);
    
    CGContextRestoreGState(context);
}

+ (void)drawFilledPath:(nullable CGContextRef)context
                  path:(nullable CGPathRef)path
                 alpha:(CGFloat)alpha
            startColor:(nullable CGColorRef)startColor
              endColor:(nullable CGColorRef)endColor {
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGRect pathRect = CGPathGetBoundingBox(path);
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextSetAlpha(context, alpha);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

+ (void)drawFilledPath:(nullable CGContextRef)context
            startColor:(nullable UIColor *)startColor
              endColor:(nullable UIColor *)endColor
                points:(nullable NSArray *)points
                 alpha:(CGFloat)alpha {
    
    
    CGMutablePathRef fillPath = CGPathCreateMutable();
    for (NSInteger i = 0; i < points.count; i++) {
        NSValue *value = points[i];
        CGPoint point = [value CGPointValue];
        if (0 == i) {
            CGPathMoveToPoint(fillPath, NULL, point.x,point.y);
        }
        else {
            CGPathAddLineToPoint(fillPath, NULL, point.x, point.y);
        }
        if (i == points.count - 1) {
            CGPathCloseSubpath(fillPath);
        }
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = @[(__bridge id) startColor.CGColor, (__bridge id) endColor.CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGRect pathRect = CGPathGetBoundingBox(fillPath);
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, fillPath);
    CGContextClip(context);
    CGContextSetAlpha(context, alpha);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    CGPathRelease(fillPath);
}

//一个点到另一个点的距离
+ (CGFloat)distanceFromPoint:(CGPoint)start toPoint:(CGPoint)end {
    CGFloat distance;
    CGFloat xDist = end.x - start.x;
    CGFloat yDist = end.y - start.y;
    distance = sqrtf((xDist * xDist) +(yDist * yDist));
    return  distance;
}

@end
