//
//  LNXAxisRender.m
//  Market
//
//  Created by vvusu on 5/4/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNXAxisRender.h"

@implementation LNXAxisRender

+ (instancetype)initWithHandler:(LNChartHandler *)handler xAxis:(LNXAxis *)xAxis {
    LNXAxisRender *render = [[LNXAxisRender alloc]init];
    render.xAxis = xAxis;
    render.viewHandler = handler;
    return render;
}

#pragma mark - 绘制X轴线
- (void)renderXAxis:(CGContextRef)context {
    if (_xAxis.isDrawAxisLineEnabled) {
        CGContextSaveGState(context);
        CGContextSetStrokeColorWithColor(context, _xAxis.axisLineColor.CGColor);
        CGContextSetLineWidth(context, _xAxis.axisLineWidth);
        //绘制X轴
        CGPoint points[2] = { CGPointMake(self.viewHandler.contentLeft, self.viewHandler.contentBottom), CGPointMake(self.viewHandler.contentRight, self.viewHandler.contentBottom)};
        CGContextStrokeLineSegments(context, points, 2);
        CGContextRestoreGState(context);
    }
}

- (void)renderGridLines:(CGContextRef)context {
    if (_xAxis.isDrawGridLinesEnabled) {
        CGContextSaveGState(context);
        
        CGContextSetShouldAntialias(context, _xAxis.gridAntialiasEnabled);
        CGContextSetStrokeColorWithColor(context, _xAxis.gridColor.CGColor);
        CGContextSetLineWidth(context, _xAxis.gridLineWidth);
        CGContextSetLineCap(context, _xAxis.gridLineCap);
        CGContextSetLineDash(context, 0.0, nil, 0);
        CGPoint position = CGPointMake(0, self.viewHandler.contentTop);
        
        CGFloat xvalue = 0;
        NSInteger lineCount = _xAxis.values.count;
        switch (_xAxis.labelSite) {
            case XAxisLabelSiteCenter:
                xvalue = self.viewHandler.contentWidth / (_xAxis.values.count - 1);
                break;
            case XAxisLabelSiteLeft:
            case XAxisLabelSiteRight:
                 xvalue = self.viewHandler.contentWidth / (_xAxis.values.count);
                lineCount++;
                break;
        }

        for (NSInteger i = 0; i < lineCount; i++) {
            //顶端不画线
            if (i == 0 || i == lineCount - 1) {
                continue;
            }
            position.x = i * xvalue + self.viewHandler.contentLeft;
            gridLineSegmentsBuffer[0].x = position.x;
            gridLineSegmentsBuffer[0].y = self.viewHandler.contentTop;
            gridLineSegmentsBuffer[1].x = position.x;
            gridLineSegmentsBuffer[1].y = self.viewHandler.contentBottom;
            CGContextStrokeLineSegments(context, gridLineSegmentsBuffer, 2);
        }
        CGContextRestoreGState(context);
    }
}

- (void)renderAxisLabels:(CGContextRef)context {
    if (_xAxis.isDrawLabelsEnabled) {
        CGFloat yOffset = _xAxis.yOffset;
        
        switch (_xAxis.labelPosition) {
            case XAxisLabelPositionTop:
                [self drawLabels:context pointY:self.viewHandler.contentTop - yOffset];
                break;
            case XAxisLabelPositionTopInside:
                [self drawLabels:context pointY:self.viewHandler.contentTop + yOffset];
                break;
            case XAxisLabelPositionBottom:
                [self drawLabels:context pointY:self.viewHandler.contentBottom + yOffset];
                break;
            case XAxisLabelPositionBottomInside:
                [self drawLabels:context pointY:self.viewHandler.contentBottom - yOffset];
                break;
            case XAxisLabelPositionBothSided:
                break;
        }
    }
}

- (void)drawLabels:(CGContextRef)context pointY:(CGFloat)pointY {
    if (_xAxis.isDrawLabelsEnabled) {
        
        NSMutableParagraphStyle *paraStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paraStyle.alignment = NSTextAlignmentLeft;
        NSDictionary *labelAttrs = @{NSFontAttributeName:_xAxis.labelFont,
                                     NSForegroundColorAttributeName:_xAxis.labelTextColor,
                                     NSParagraphStyleAttributeName:paraStyle};
        
        CGPoint point = CGPointMake(0, pointY);
        switch (_xAxis.labelSite) {
            case XAxisLabelSiteCenter: {
                CGFloat emptyW = self.viewHandler.contentWidth/(_xAxis.values.count - 1);
                for (NSInteger i = 0; i < _xAxis.values.count; i++) {
                    point.x = self.viewHandler.contentLeft + i * emptyW;
                    if (i > 0) {
                        paraStyle.alignment = NSTextAlignmentCenter;
                    }
                    if (i == _xAxis.values.count - 1) {
                        paraStyle.alignment = NSTextAlignmentRight;
                    }
                    [LNChartUtils drawText:context text:_xAxis.values[i] point:point align:paraStyle.alignment attributes:labelAttrs];
                }
            }
                break;
            case XAxisLabelSiteRight: {
                CGFloat emptyW = self.viewHandler.contentWidth/(_xAxis.values.count);
                for (NSInteger i = 0; i < _xAxis.values.count; i++) {
                    point.x = self.viewHandler.contentLeft + i * emptyW + emptyW/2;
                    paraStyle.alignment = NSTextAlignmentCenter;
                    [LNChartUtils drawText:context text:_xAxis.values[i] point:point align:paraStyle.alignment attributes:labelAttrs];
                }
            }
                break;
            case XAxisLabelSiteLeft:
                break;
        }
    }
}

@end
