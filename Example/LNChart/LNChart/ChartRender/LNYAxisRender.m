//
//  LNYAxisRender.m
//  Market
//
//  Created by vvusu on 5/4/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNYAxisRender.h"

@implementation LNYAxisRender

+ (instancetype)initWithHandler:(LNChartHandler *)handler yAxis:(LNYAxis *)yAxis {
    LNYAxisRender *render = [[LNYAxisRender alloc]init];
    render.yAxis = yAxis;
    render.viewHandler = handler;
    return render;
}

#pragma mark - 绘制横线
- (void)renderGridLines:(CGContextRef)context {
    if (_yAxis.isDrawGridLinesEnabled) {
        CGContextSaveGState(context);
        //是否抗锯齿
        CGContextSetShouldAntialias(context, _yAxis.gridAntialiasEnabled);
        CGContextSetStrokeColorWithColor(context, _yAxis.gridColor.CGColor);
        CGContextSetLineWidth(context, _yAxis.gridLineWidth);
        CGContextSetLineCap(context, _yAxis.gridLineCap);
        
        CGContextSetLineDash(context, 0.0, nil, 0);
        CGPoint position = CGPointZero;
        CGFloat value = self.viewHandler.contentHeight / (_yAxis.values.count - 1);
        for (NSInteger i = 0; i < _yAxis.values.count; i++) {
            //顶端不画线
            if (i == 0 || i == _yAxis.values.count - 1) {
                continue;
            }
            position.x = self.viewHandler.contentLeft;
            position.y = i * value + self.viewHandler.contentTop ;
            gridLineBuffer[0].x = self.viewHandler.contentLeft;
            gridLineBuffer[0].y = position.y;
            gridLineBuffer[1].x = self.viewHandler.contentRight;
            gridLineBuffer[1].y = position.y;
            CGContextStrokeLineSegments(context, gridLineBuffer, 2);
        }
        CGContextRestoreGState(context);
    }
}

#pragma mark - 绘制Y轴线
- (void)renderYAxis:(CGContextRef)context {
    if (_yAxis.isDrawAxisLineEnabled) {
        CGContextSaveGState(context);
        CGContextSetStrokeColorWithColor(context, _yAxis.axisLineColor.CGColor);
        CGContextSetLineWidth(context, _yAxis.axisLineWidth);
        
        //绘制y轴
        if (_yAxis.yPosition == AxisDependencyLeft) {
            CGPoint points[2] = { CGPointMake(self.viewHandler.contentLeft, self.viewHandler.contentTop), CGPointMake(self.viewHandler.contentLeft, self.viewHandler.contentBottom)};
            CGContextStrokeLineSegments(context, points, 2);
            
        } else {
            CGPoint points[2] = { CGPointMake(self.viewHandler.contentRight, self.viewHandler.contentTop), CGPointMake(self.viewHandler.contentRight, self.viewHandler.contentBottom)};
            CGContextStrokeLineSegments(context, points, 2);
        }
        CGContextRestoreGState(context);
    }
}

#pragma mark - 绘制Y轴文字
- (void)renderYAxisLabels:(CGContextRef)context {
    
    if (_yAxis.isDrawLabelsEnabled) {
        CGFloat xoffset = _yAxis.xOffset;
        CGFloat yoffset = _yAxis.yOffset;
        CGFloat xPosition = 0.f;
        NSTextAlignment textAlign = NSTextAlignmentRight;
        if (_yAxis.yPosition == AxisDependencyLeft) {
            if (_yAxis.labelPosition == YAxisLabelPositionOutsideChart) {
                textAlign = NSTextAlignmentRight;
                xPosition = self.viewHandler.contentLeft - xoffset;
            } else {
                textAlign = NSTextAlignmentLeft;
                xPosition = self.viewHandler.contentLeft + xoffset;
            }
            
        } else {
            if (_yAxis.labelPosition == YAxisLabelPositionOutsideChart) {
                textAlign = NSTextAlignmentLeft;
                xPosition = self.viewHandler.contentRight + xoffset;
            } else {
                textAlign = NSTextAlignmentRight;
                xPosition = self.viewHandler.contentRight - xoffset;
            }
        }
        
        yoffset = (self.viewHandler.contentHeight) / (_yAxis.values.count - 1);
        [self drawYLabels:context position:xPosition offset:yoffset textAlign:textAlign]; 
    }
}

- (void)drawYLabels:(CGContextRef)context
           position:(CGFloat)fixedPosition
             offset:(CGFloat)offset
          textAlign:(NSTextAlignment)textAlign {
    
    CGPoint point = CGPointZero;
    for (NSInteger i = 0; i < _yAxis.values.count; i++) {
        NSString *labelText = _yAxis.values[i];
        NSDictionary *attributes = @{NSFontAttributeName:_yAxis.labelFont,NSForegroundColorAttributeName:_yAxis.labelTextColor};
        CGSize labelSize = [labelText sizeWithAttributes:attributes];
        
        point.x = fixedPosition;
        point.y = self.viewHandler.contentTop + offset * i;
        if (i > 0) {
            point.y -= labelSize.height/2;
        }
        if (i == _yAxis.values.count - 1) {
            point.y -= labelSize.height/2;
        }
        [LNChartUtils drawText:context text:labelText point:point align:textAlign attributes:attributes];
    }
}

@end
