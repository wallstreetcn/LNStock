//
//  LNLegendRender.m
//  Market
//
//  Created by vvusu on 5/21/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNLegendRender.h"
#import "LNChartData.h"

@implementation LNLegendRender

+ (instancetype)initWithHandler:(LNChartHandler *)handler legend:(LNChartLegend *)legend {
    LNLegendRender *render = [[LNLegendRender alloc]init];
    render.legend = legend;
    render.viewHandler = handler;
    return render;
}

- (void)renderLegend:(CGContextRef)context data:(LNChartData *)data {
    if (_legend.drawEnabled) {
        CGContextSaveGState(context);
        NSDictionary *attributes = @{NSFontAttributeName:_legend.textFont};
        
        //计算坐标
        CGFloat startX = 0;
        CGFloat startY = 0;
        switch (_legend.LegendPosition) {
            case ChartLegendPositionTopLeft: {
                startX = self.viewHandler.contentLeft + _legend.stackSpace;
                startY = self.viewHandler.contentTop;
            }
                break;
            case ChartLegendPositionTopRight: {
                startX = self.viewHandler.contentRight;
                startY = self.viewHandler.contentTop;
                CGFloat totleSize = 0;
                for (NSInteger i = 0; i < _legend.labels.count; i++) {
                    NSString *titleLabel = @"";
                    CGSize titleLabelSize = CGSizeZero;
                    if (i < _legend.contents.count) {
                        titleLabel = _legend.contents[i];
                        titleLabelSize = [titleLabel sizeWithAttributes:attributes];
                    }
                    
                    NSString *text = @"";
                    CGSize labelSize = CGSizeZero;
                    if (i < _legend.labels.count) {
                        text = _legend.labels[i];
                        labelSize = [text sizeWithAttributes:attributes];
                    }
                    
                    if (_legend.legendFormType == ChartLegendFormContent) {
                        totleSize += titleLabelSize.width + labelSize.width + _legend.stackSpace * 2;
                    } else {
                        totleSize += titleLabelSize.width + labelSize.width + _legend.formSize + _legend.stackSpace * 2;
                    }
                }
                startX = self.viewHandler.contentRight - totleSize;
            }
                break;
            case ChartLegendPositionBottomLeft: {
                startX = self.viewHandler.contentLeft + _legend.stackSpace;
                startY = self.viewHandler.contentBottom - _legend.heigth;
            }
                break;
            case ChartLegendPositionBottomRight: {
                startX = self.viewHandler.contentRight;
                startY = self.viewHandler.contentBottom - _legend.heigth;
                CGFloat totleSize = 0;
                
                for (NSInteger i = 0; i < _legend.labels.count; i++) {
                    NSString *titleLabel = @"";
                    CGSize titleLabelSize = CGSizeZero;
                    if (i < _legend.contents.count) {
                        titleLabel = _legend.contents[i];
                        titleLabelSize = [titleLabel sizeWithAttributes:attributes];
                    }
                    
                    NSString *text = @"";
                    CGSize labelSize = CGSizeZero;
                    if (i < _legend.labels.count) {
                        text = _legend.labels[i];
                        labelSize = [text sizeWithAttributes:attributes];
                    }
                    
                    if (_legend.legendFormType == ChartLegendFormContent) {
                        totleSize += titleLabelSize.width + labelSize.width + _legend.stackSpace * 2;
                    } else {
                        totleSize += titleLabelSize.width + labelSize.width + _legend.formSize + _legend.stackSpace * 2;
                    }
                }
                startX = self.viewHandler.contentRight - totleSize;
            }
                break;
        }
        
        //绘制
        CGFloat formSizeY = 0;
        for (NSInteger i = 0; i < _legend.labels.count; i++) {
            UIColor *color = _legend.colors[i];
            NSString *text = _legend.labels[i];
            
            switch (_legend.legendFormType) {
                case ChartLegendFormLine: {
                    //画线的是点,是中心点
                    formSizeY = startY + _legend.heigth/2;
                    CGContextSetLineWidth(context, _legend.formLineWidth);
                    CGContextSetStrokeColorWithColor(context, color.CGColor);
                    formLineSegmentsBuffer[0].x = startX;
                    formLineSegmentsBuffer[0].y = formSizeY;
                    formLineSegmentsBuffer[1].x = startX + _legend.formSize;
                    formLineSegmentsBuffer[1].y = formSizeY;
                    CGContextStrokeLineSegments(context, formLineSegmentsBuffer, 2);
                    startX += _legend.formSize + _legend.stackSpace;
                }
                    break;
                case ChartLegendFormCircle: {
                    formSizeY = startY + (_legend.heigth - _legend.formSize)/2;
                    CGContextSetFillColorWithColor(context, color.CGColor);
                    CGContextFillEllipseInRect(context, CGRectMake(startX, formSizeY, _legend.formSize, _legend.formSize));
                    startX += _legend.formSize + _legend.stackSpace;
                }
                    break;
                case ChartLegendFormSquare: {
                    formSizeY = startY + (_legend.heigth - _legend.formSize)/2;
                    CGContextSetFillColorWithColor(context, color.CGColor);
                    CGContextFillRect(context, CGRectMake(startX, formSizeY, _legend.formSize, _legend.formSize));
                    startX += _legend.formSize + _legend.stackSpace;
                }
                    break;
                case ChartLegendFormContent: {
                    CGSize titleLabelSize = [_legend.contents[i] sizeWithAttributes:attributes];
                    attributes = @{NSFontAttributeName:_legend.textFont,NSForegroundColorAttributeName:color};
                    [LNChartUtils drawText:context text:_legend.contents[i] point:CGPointMake(startX, startY + (_legend.heigth - titleLabelSize.height)/2) align:NSTextAlignmentLeft attributes:attributes];
                    startX += titleLabelSize.width + _legend.stackSpace;
                }
                    break;
                case ChartLegendFormNULL:
                     startX += _legend.stackSpace;
                    break;
            }
            
            CGSize labelSize = [text sizeWithAttributes:attributes];
            attributes = @{NSFontAttributeName:_legend.textFont,NSForegroundColorAttributeName:_legend.labelColors[i]};
            [LNChartUtils drawText:context text:text point:CGPointMake(startX, startY + (_legend.heigth - labelSize.height)/2) align:NSTextAlignmentLeft attributes:attributes];
            startX += labelSize.width + _legend.stackSpace;
        }
        CGContextRestoreGState(context);
    }
}

@end
