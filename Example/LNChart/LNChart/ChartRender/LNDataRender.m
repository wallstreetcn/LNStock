//
//  LNDataRender.m
//  Market
//
//  Created by vvusu on 5/20/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNDataRender.h"
#import "LNChartData.h"
#import "LNDataSet.h"

@implementation LNDataRender

+ (instancetype)initWithHandler:(LNChartHandler *)handler {
    LNDataRender *dataRender = [[LNDataRender alloc]init];
    dataRender.viewHandler = handler;
    return dataRender;
}

#pragma mark - 绘制线
- (void)drawLineData:(CGContextRef)context data:(LNChartData *)data {
    if (!data.dataSets || data.lastEnd > data.dataSets.count) {
        return;
    }
    CGContextSaveGState(context);
    //开始画渐变色
    if (data.lineSet.isFillEnabled) {
        [LNChartUtils drawFilledPath:context startColor:data.lineSet.startFillColor endColor:data.lineSet.endFillColor points:data.lineSet.fillPoints alpha:0.5];
    }
    //画线
    for (NSInteger i = 0; i < data.lineSet.linePoints.count; i++) {
        [LNChartUtils drawLines:context points:data.lineSet.linePoints[i] color:data.lineSet.lineColors[i] width:data.lineSet.lineWidth];
    }
    //绘制点
    if (data.lineSet.isDrawPoint || data.dataSets.count == 1) {  //当数据为一个时避免图为空
        for (NSInteger i = 0; i < data.lineSet.linePoints.count; i++) {
            [LNChartUtils drawCircles:context fillColor:data.lineSet.pointColors[i] points:data.lineSet.linePoints[i] radius:data.lineSet.pointRadius];
        }
    }
    CGContextRestoreGState(context);
}

//绘制五日线
- (void)drawFiveDayLineData:(CGContextRef)context data:(LNChartData *)data {
    if (!data.dataSets || data.lastEnd > data.dataSets.count) {
        return;
    }
    CGContextSaveGState(context);
    //开始画渐变色
    if (data.lineSet.isFillEnabled) {
        [LNChartUtils drawFilledPath:context startColor:data.lineSet.startFillColor endColor:data.lineSet.endFillColor points:data.lineSet.fillPoints alpha:0.5];
    }
    
    for (NSInteger i = 0; i < data.lineSet.fiveDayPoints.count; i++) {
        NSNumber *num = data.lineSet.fiveDayPoints[i];
        NSRange range = NSMakeRange(0, 0);
        if (i == 0) {
            if (i + 1 > data.lineSet.fiveDayPoints.count - 1) {
                return;
            }
            num = data.lineSet.fiveDayPoints[i + 1];
            range = NSMakeRange(0, num.integerValue);
        } else if (i == data.lineSet.fiveDayPoints.count - 1) {
            num = data.lineSet.fiveDayPoints.lastObject;
            range = NSMakeRange(num.integerValue, (NSInteger)(((NSArray *)data.lineSet.linePoints.firstObject).count - num.integerValue));
        } else {
           NSNumber *endNum = data.lineSet.fiveDayPoints[i + 1];
            range = NSMakeRange(num.integerValue, endNum.integerValue - num.integerValue);
        }

        for (NSInteger j = 0; j < data.lineSet.linePoints.count; j++) {
            NSArray *pointArr = [data.lineSet.linePoints[j] subarrayWithRange:range];
            [LNChartUtils drawLines:context points:pointArr color:data.lineSet.lineColors[j] width:data.lineSet.lineWidth];
        }
    }
    CGContextRestoreGState(context);
}

#pragma mark - 绘制蜡烛图 K线
- (void)drawCandle:(CGContextRef)context data:(LNChartData *)data {
    if (!data.dataSets || data.lastEnd > data.dataSets.count) {
        return;
    }
    CGContextSaveGState(context);
    //等比刻度
    data.drawScale = self.viewHandler.contentHeight * data.sizeRatio / (data.yMax - data.yMin);
    CGFloat emptyHeight = data.viewHandler.emptyHeight;
    CGFloat candleWidth = data.candleSet.candleW - data.candleSet.candleW * data.gapRatio;
    UIColor *color = data.candleSet.candleRiseColor;
    
    for (NSInteger i = data.lastStart; i < data.lastEnd; i++) {
        LNDataSet *dataSet = data.dataSets[i];
        
        NSNumber *openNum = dataSet.candleValus[0];
        NSNumber *highNum = dataSet.candleValus[1];
        NSNumber *lowNum = dataSet.candleValus[2];
        NSNumber *closeNum = dataSet.candleValus[3];
        //解决有空蜡烛时，不画点和线
        if (!highNum || !lowNum || !openNum || !closeNum) {
            continue;
        }
        CGFloat high = (data.yMax - highNum.floatValue) * data.drawScale + self.viewHandler.contentTop + emptyHeight;
        CGFloat low = (data.yMax - lowNum.floatValue) * data.drawScale + self.viewHandler.contentTop + emptyHeight;
        CGFloat open = (data.yMax - openNum.floatValue) * data.drawScale + self.viewHandler.contentTop + emptyHeight;
        CGFloat close = (data.yMax - closeNum.floatValue) * data.drawScale + self.viewHandler.contentTop + emptyHeight;
        CGFloat left = (data.candleSet.candleW * (i - data.lastStart) + self.viewHandler.contentLeft) + data.candleSet.candleW * data.gapRatio;
        CGFloat startX = left + candleWidth/2.0;
        
        CGRect candleRect = CGRectZero;
        if (open < close) {
            color = data.candleSet.candleFallColor;
            candleRect = CGRectMake(left, open, candleWidth, close - open);
        }
        else if (open == close) {
            if (i > 1) {
                LNDataSet *lastDataSet = data.dataSets[i - 1];
                NSNumber *lastTempNum = lastDataSet.candleValus[3];
                if (lastTempNum.floatValue > closeNum.floatValue) {
                    color = data.candleSet.candleFallColor;
                }
                else {
                    color = data.candleSet.candleRiseColor;
                }
            }
            candleRect = CGRectMake(left, open, candleWidth, 1.0);
        }
        else {
            color = data.candleSet.candleRiseColor;
            candleRect = CGRectMake(left, close, candleWidth, open - close);
        }
        
        switch (data.chartType) {
            case ChartViewType_Candle: {
                [LNChartUtils drawRect:context lineColor:color fillColor:color lineWidth:0.5 rect:candleRect];
                [LNChartUtils drawLine:context color:color width:1.0 statPoint:CGPointMake(startX, high) endPoint:CGPointMake(startX, low)];
            }
                break;
            case ChartViewType_HollowCandle: {
                UIColor *fillColor = color;
                if ([color isEqual:data.candleSet.candleRiseColor]) {
                    fillColor = [UIColor clearColor];
                    //空蜡烛线分两段绘制
                    [LNChartUtils drawLine:context color:color width:1.0 statPoint:CGPointMake(startX, high) endPoint:CGPointMake(startX, close)];
                    [LNChartUtils drawLine:context color:color width:1.0 statPoint:CGPointMake(startX, open) endPoint:CGPointMake(startX, low)];
                }
                else {
                    [LNChartUtils drawLine:context color:color width:1.0 statPoint:CGPointMake(startX, high) endPoint:CGPointMake(startX, low)];
                }
                [LNChartUtils drawRect:context lineColor:color fillColor:fillColor lineWidth:1.0 rect:candleRect];
            }
                break;
            case ChartViewType_BOLL:
            case ChartViewType_Bars: {
                color = data.candleSet.candleColor;
                [LNChartUtils drawLine:context color:color width:1.0 statPoint:CGPointMake(startX, high) endPoint:CGPointMake(startX, low)];
                [LNChartUtils drawLine:context color:color width:1.0 statPoint:CGPointMake(left, open) endPoint:CGPointMake(left + candleWidth/2, open)];
                [LNChartUtils drawLine:context color:color width:1.0 statPoint:CGPointMake(left + candleWidth/2, close) endPoint:CGPointMake(left + candleWidth, close)];
            }
                break;
            default:
                break;
        }
        
        //画MA5 MA10 MA20 线 / BOLL 线
        if (i > data.lastStart) {
            LNDataSet *lastDataSet = data.dataSets[i - 1];
            //便利MA数组
            NSArray *valusArr = dataSet.MAValus;
            NSArray *lastValusArr = lastDataSet.MAValus;
            
            if (data.chartType == ChartViewType_BOLL) {
                valusArr = dataSet.values;
                lastValusArr = lastDataSet.values;
            }
            
            for (NSInteger j = 0; j < valusArr.count; j++) {
                CGFloat MAValue = ((NSNumber *)valusArr[j]).floatValue;
                CGFloat lastMAValue = ((NSNumber *)lastValusArr[j]).floatValue;
                if (lastMAValue > 0) {
                    CGFloat startMAX = startX - data.candleSet.candleW;
                    CGFloat startMAY = (data.yMax - lastMAValue) * data.drawScale + self.viewHandler.contentTop + emptyHeight;
                    CGFloat endMAY = (data.yMax - MAValue) * data.drawScale + self.viewHandler.contentTop + emptyHeight;
                    if (data.chartType == ChartViewType_BOLL) {
                        [LNChartUtils drawLine:context color:data.lineSet.lineColors[j] width:data.candleSet.MALineWidth statPoint:CGPointMake (startMAX, startMAY) endPoint:CGPointMake(startX, endMAY)];
                    } else {
                        [LNChartUtils drawLine:context color:data.candleSet.MAColors[j] width:data.candleSet.MALineWidth statPoint:CGPointMake(startMAX, startMAY) endPoint:CGPointMake(startX, endMAY)];
                    }
                }
            }
        }
        
        //绘制十字线
        if (data.highlighter.isHighlight) {
            if (i == data.highlighter.index) {
                data.highlighter.point = CGPointMake(startX, candleRect.origin.y);
            }
        }
    }
    CGContextRestoreGState(context);
}

#pragma mark - 美国线
- (void)drawBars:(CGContextRef)context data:(LNChartData *)data {
    [self drawCandle:context data:data];
}

#pragma mark - 绘制十字线
- (void)drawCrossLine:(CGContextRef)context data:(LNChartData *)data {
    if (!data.highlighter.isHighlight || !data.dataSets) {
        return;
    }
    NSDictionary *attributes = @{NSFontAttributeName:data.highlighter.labelFont,NSBackgroundColorAttributeName:data.highlighter.labelBGColor,NSForegroundColorAttributeName:data.highlighter.labelColor};
    
    if (data.highlighter.isDrawLevelLine) {
        if (data.highlighter.touchPoint.y > self.viewHandler.contentTop &&
            data.highlighter.touchPoint.y < self.viewHandler.contentBottom) {
            
            CGFloat emptyHeight = data.viewHandler.emptyHeight;
            CGFloat price = data.yMax - (data.highlighter.touchPoint.y - self.viewHandler.contentTop - emptyHeight) / data.drawScale;
            NSString *labelText = @"";
            labelText = [LNChartFormatter formatterWithPosition:data.precision num:price];            
            if (data.chartType == ChartViewType_Columnar) {
                //是交易量的计算显示不一样
                labelText = [LNChartFormatter volumeCutWithNum:price maxNum:data.yMax];
            }
            else if (data.chartType == ChartViewType_OBV){
                labelText = [LNChartFormatter longFormatterWithPosition:price maxNum:data.yMax];
            }
            
            //坐标点
            CGFloat labelX = data.highlighter.touchPoint.x;
            CGFloat labelY = data.highlighter.touchPoint.y;
            CGFloat levelLineY = data.highlighter.touchPoint.y;
            CGSize labelSize = [labelText sizeWithAttributes:attributes];
            labelY = levelLineY - labelSize.height / 2;
            
            if (labelY < (self.viewHandler.contentTop)) {
                labelY = self.viewHandler.contentTop;
            }
            else if (labelY + labelSize.height > self.viewHandler.contentBottom) {
                labelY = self.viewHandler.contentBottom - labelSize.height;
            }
            
            //要区分横轴显示一个Label 还是两个 Label
            //横屏状态显示不一样
            CGPoint labelPoint = CGPointZero;
            CGPoint endLevelLinePoint = CGPointZero;
            CGPoint startLevelLinePoint = CGPointZero;
            NSTextAlignment textAlignment = NSTextAlignmentLeft;
            //显示两个的做法
            if (data.highlighter.isDrawPriceRatio) {
                //如果是分时或者五日图会显示涨跌
                CGFloat ratio = data.highlighter.maxPriceRatio / (self.viewHandler.contentHeight/2);
                CGFloat priceRatio = data.highlighter.maxPriceRatio - (data.highlighter.touchPoint.y - self.viewHandler.contentTop - emptyHeight) * ratio;
                NSString *priceRatioText = [LNChartFormatter conversionWithFormatter:@"%" value:priceRatio];
                CGSize ratioLabelSize = [priceRatioText sizeWithAttributes:attributes];
                //--------------------------
                
                labelPoint = CGPointMake(self.viewHandler.contentLeft, labelY);
                CGPoint rightPoint = CGPointMake(self.viewHandler.contentRight, labelY);
                NSTextAlignment rightAlignment = NSTextAlignmentRight;
                //横屏状态显示不一样
                startLevelLinePoint = CGPointMake(self.viewHandler.contentLeft + labelSize.width, levelLineY);
                endLevelLinePoint = CGPointMake(self.viewHandler.contentRight - ratioLabelSize.width, levelLineY);
                
                switch (data.highlighter.positionType) {
                    case HighlightPositionLeftOut:
                    case HighlightPositionRightOut:
                        textAlignment = NSTextAlignmentRight;
                        rightAlignment = NSTextAlignmentLeft;
                        startLevelLinePoint = CGPointMake(self.viewHandler.contentLeft, levelLineY);
                        endLevelLinePoint = CGPointMake(self.viewHandler.contentRight, levelLineY);
                        break;
                    case HighlightPositionLeftInside:
                    case HighlightPositionRightInside:
                        break;
                }
                //绘制右边提示框
                [LNChartUtils drawText:context text:priceRatioText point:rightPoint align:rightAlignment attributes:attributes];
            }
            else {
                //坐标点
                CGFloat labelA = labelSize.width;
                CGFloat labelB = labelSize.width;
                if (labelX < self.viewHandler.contentLeft + self.viewHandler.contentWidth/2) {
                    labelX = self.viewHandler.contentRight;
                    labelA = 0;
                    textAlignment = NSTextAlignmentRight;
                } else {
                    labelX = self.viewHandler.contentLeft;
                    labelB = 0;
                }
                
                //横屏状态显示不一样
                labelPoint = CGPointMake(labelX, labelY);
                startLevelLinePoint = CGPointMake(self.viewHandler.contentLeft + labelA, levelLineY);
                endLevelLinePoint = CGPointMake(self.viewHandler.contentRight - labelB, levelLineY);
                
                switch (data.highlighter.positionType) {
                    case HighlightPositionLeftOut:
                        startLevelLinePoint = CGPointMake(self.viewHandler.contentLeft, levelLineY);
                        endLevelLinePoint = CGPointMake(self.viewHandler.contentRight, levelLineY);
                        labelPoint =  CGPointMake(self.viewHandler.contentLeft, labelY);
                        textAlignment = NSTextAlignmentRight;
                        break;
                    case HighlightPositionRightOut:
                        startLevelLinePoint = CGPointMake(self.viewHandler.contentLeft, levelLineY);
                        endLevelLinePoint = CGPointMake(self.viewHandler.contentRight, levelLineY);
                        labelPoint =  CGPointMake(self.viewHandler.contentRight, labelY);
                        textAlignment = NSTextAlignmentLeft;
                        break;
                    case HighlightPositionLeftInside:
                    case HighlightPositionRightInside:
                        break;
                }
            }
            
            //绘制提示框
            [LNChartUtils drawText:context text:labelText point:labelPoint align:textAlignment attributes:attributes];
            //绘制横线
            [LNChartUtils drawLine:context color:data.highlighter.levelLineColor width:data.highlighter.levelLineWidth statPoint:startLevelLinePoint endPoint:endLevelLinePoint];
        }
    }
    
    //绘制竖线
    if (data.highlighter.drawVerticalLine) {
        [LNChartUtils drawLine:context color:data.highlighter.verticalLineColor width:data.highlighter.verticalLineWidth statPoint:CGPointMake(data.highlighter.point.x, self.viewHandler.contentTop) endPoint:CGPointMake(data.highlighter.point.x, self.viewHandler.contentBottom)];
    }
    
    //画高亮的点
    if (data.highlighter.drawHighlightPoint) {
        for (NSInteger j = 0; j < data.lineSet.linePoints.count; j++) {
            CGPoint point = [data.lineSet.linePoints[j][data.highlighter.index] CGPointValue];
            [LNChartUtils drawCircle:context lineColor:data.highlighter.pointLineColor fillColor:data.highlighter.pointColor lineWidth:data.highlighter.pointLineWidth radius:data.highlighter.pointRadius point:point];
        }
    }
    
    //绘制X轴显示的日期Label
    if (data.highlighter.isDrawTimeLabel) {
        LNDataSet *dateSet = data.dataSets[data.highlighter.index];
        NSString *dateString = [LNChartFormatter dateWithFormatter:@"yyyy-MM-dd-HH:mm" date:dateSet.date];
        CGSize dateLabelSize = [dateString sizeWithAttributes:attributes];
        CGFloat dateX = data.highlighter.point.x;
        if (data.highlighter.point.x + dateLabelSize.width/2 > self.viewHandler.contentRight) {
            dateX = self.viewHandler.contentRight - dateLabelSize.width/2;
        }
        else if (data.highlighter.point.x - dateLabelSize.width/2 < self.viewHandler.contentLeft) {
            dateX = self.viewHandler.contentLeft + dateLabelSize.width/2;
        }
        CGPoint dateLabelPoint = CGPointMake(dateX, self.viewHandler.contentBottom);
        [LNChartUtils drawText:context text:dateString point:dateLabelPoint align:NSTextAlignmentCenter attributes:attributes];
    }
}

#pragma mark - MACD
- (void)drawMACD:(CGContextRef)context data:(LNChartData *)data {
    if (!data.dataSets || data.lastEnd > data.dataSets.count) {
        return;
    }
    //等比刻度
    data.drawScale = self.viewHandler.contentHeight * data.sizeRatio / (data.yMax - data.yMin);
    CGFloat volumeWidth = data.candleSet.candleW - data.candleSet.candleW * data.gapRatio;
    CGFloat emptyHeight = data.viewHandler.emptyHeight;
    CGFloat macdLineY = self.viewHandler.contentBottom - self.viewHandler.contentHeight/2;
    CGFloat DIFLineY = self.viewHandler.contentBottom - emptyHeight;
    
    for (NSInteger i = data.lastStart; i < data.lastEnd; i++) {
        LNDataSet *dataSet = data.dataSets[i];
        UIColor *color = data.candleSet.candleRiseColor;
        CGFloat DIFNum = ((NSNumber *)dataSet.values[0]).floatValue;
        CGFloat DEANum = ((NSNumber *)dataSet.values[1]).floatValue;
        CGFloat MACDNum = ((NSNumber *)dataSet.values[2]).floatValue;
        if (!(NSNumber *)dataSet.values[2]) {
            continue;
        }
        //绘制
        CGFloat volume = ((MACDNum - 0) * data.drawScale);
        volume = fabs(volume);
        CGFloat startX = (self.viewHandler.contentLeft + data.candleSet.candleW * (i - data.lastStart)) + data.candleSet.candleW * data.gapRatio;
        CGFloat startY = macdLineY - volume ;
        if (MACDNum < 0) {
            color = data.candleSet.candleFallColor;
            startY = macdLineY;
        }
        [LNChartUtils drawRect:context lineColor:color fillColor:color lineWidth:0 rect:CGRectMake(startX, startY, volumeWidth, volume)];
        //绘制DEA DIF线
        
        if (i > data.lastStart) {
            LNDataSet *lastDataSet = data.dataSets[i - 1];
            if (!(NSNumber *)lastDataSet.values[2]) {
                continue;
            }
            CGFloat lastDIFNum = ((NSNumber *)lastDataSet.values[0]).floatValue;
            CGFloat lastDEANum = ((NSNumber *)lastDataSet.values[1]).floatValue;
            
            CGFloat DIF_StartX = startX - data.candleSet.candleW + volumeWidth/2;
            CGFloat DIF_StartY = DIFLineY - ((lastDIFNum - data.yMin) * data.drawScale);
            CGFloat DIF_EndX = startX + volumeWidth/2;
            CGFloat DIF_EndY = DIFLineY - ((DIFNum - data.yMin) * data.drawScale);
            
            CGFloat DEA_StartY = DIFLineY - ((lastDEANum - data.yMin) * data.drawScale);
            CGFloat DEA_EndY = DIFLineY - ((DEANum - data.yMin) * data.drawScale);
         
            [LNChartUtils drawLine:context color:data.lineSet.lineColors[0] width:data.candleSet.MALineWidth statPoint:CGPointMake(DIF_StartX, DIF_StartY) endPoint:CGPointMake(DIF_EndX, DIF_EndY)];
            [LNChartUtils drawLine:context color:data.lineSet.lineColors[1] width:data.candleSet.MALineWidth statPoint:CGPointMake(DIF_StartX, DEA_StartY) endPoint:CGPointMake(DIF_EndX, DEA_EndY)];
        }
        
        //绘制十字线
        if (i == data.highlighter.index) {
            if (data.highlighter.isHighlight) {
                data.highlighter.point = CGPointMake(startX + volumeWidth/2, self.viewHandler.contentBottom - volume - emptyHeight);
            }
        }
    }
    
    if (data.highlighter.isHighlight) {
        [self drawCrossLine:context data:data];
    }
    CGContextRestoreGState(context);
}

#pragma mark - 绘制交易量

- (void)drawVolume:(CGContextRef)context data:(LNChartData *)data {
    if (!data.dataSets || data.lastEnd > data.dataSets.count) {
        return;
    }
    CGContextSaveGState(context);
    data.drawScale = self.viewHandler.contentHeight * data.sizeRatio / data.yMax;
    CGFloat emptyHeight = data.viewHandler.emptyHeight;
    UIColor *color = data.candleSet.candleRiseColor;
    CGFloat candleW = data.candleSet.candleW;
    
    //分时五日的交易量
    LNDataSet *firstDataSet = data.dataSets.firstObject;
    if (firstDataSet.preClosePx) {  //如果没有昨收价格 会显示错误，
        candleW = self.viewHandler.contentWidth / data.valCount;
    }
    
    CGFloat volumeWidth = candleW - candleW * data.gapRatio;
    //绘制成交量
    for (NSInteger i = data.lastStart; i < data.lastEnd; i++) {
        LNDataSet *dataSet = data.dataSets[i];
        
        if (firstDataSet.preClosePx) {
            NSNumber *tempNum = dataSet.values.firstObject;
            if (i == data.lastStart) {
                if (tempNum.floatValue >= dataSet.preClosePx) {
                    color = data.candleSet.candleRiseColor;
                }
                else {
                    color = data.candleSet.candleFallColor;
                }
            }
            if (i > data.lastStart) {
                LNDataSet *lastDataSet = data.dataSets[i - 1];
                NSNumber *lastTempNum = lastDataSet.values.firstObject;
                //交易量的颜色
                if (tempNum.floatValue >= lastTempNum.floatValue) {
                    color = data.candleSet.candleRiseColor;
                }
                else {
                    color = data.candleSet.candleFallColor;
                }
            }
        }
        else {
            NSNumber *open = dataSet.candleValus[0];
            NSNumber *close = dataSet.candleValus[3];
            if (open.floatValue < close.floatValue) {
                color = data.candleSet.candleRiseColor;
            }
            else if (open.floatValue == close.floatValue) {
                if (i > 1) {
                    LNDataSet *lastDataSet = data.dataSets[i - 1];
                    NSNumber *lasetCloseNum = lastDataSet.candleValus[3];
                    if (lasetCloseNum.floatValue > close.floatValue) {
                        color = data.candleSet.candleFallColor;
                    }
                    else {
                        color = data.candleSet.candleRiseColor;
                    }
                }
            }
            else {
                color = data.candleSet.candleFallColor;
            }
        }
        
        //绘制
        CGFloat startX = (self.viewHandler.contentLeft + candleW * (i - data.lastStart)) + candleW * data.gapRatio;
        CGFloat volume = ((dataSet.volume - 0) * data.drawScale);
        [LNChartUtils drawRect:context lineColor:color fillColor:color lineWidth:0 rect:CGRectMake(startX, self.viewHandler.contentBottom - volume - emptyHeight, volumeWidth, volume)];
        
        //绘制十字线
        if (i == data.highlighter.index) {
            if (data.highlighter.isHighlight) {
                data.highlighter.point = CGPointMake(startX + volumeWidth/2, self.viewHandler.contentBottom - volume - emptyHeight);
            }
        }
    }
    
    if (data.highlighter.isHighlight) {
        [self drawCrossLine:context data:data];
    }
    CGContextRestoreGState(context);
}

//绘制左拉加载更多文字
- (void)drawLoadMoreContent:(CGContextRef)context data:(LNChartData *)data {
    if (data.isDrawLoadMoreContent) {
        NSString *labelText = @"";
        BOOL isDrawLabelText = YES;
        switch (data.loadMoreType) {
            case ChartLoadMoreType_Normal:
                labelText = @"加载更多";
                break;
            case ChartLoadMoreType_Start:
            case ChartLoadMoreType_Loading:
                labelText = @"加载中...";
                break;
            default:
                isDrawLabelText = NO;
                break;
        }
        if (isDrawLabelText) {
            NSDictionary *attributes = @{NSFontAttributeName:data.highlighter.labelFont,NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:[UIColor grayColor]};
            CGSize labelSize = [labelText sizeWithAttributes:attributes];
            CGFloat labelX = data.viewHandler.contentLeft + data.emptyStartNum * data.candleSet.candleW - labelSize.width - 10;
            CGFloat labelW = labelSize.width;
            if (labelX < data.viewHandler.contentLeft) {
                labelX = data.viewHandler.contentLeft;
                labelW = data.viewHandler.contentLeft - labelX;
            }
            CGRect rect = CGRectMake(labelX, self.viewHandler.contentBottom/2 - labelSize.height/2, labelW, labelSize.height);
            [labelText drawInRect:rect withAttributes:attributes];
        }        
    }
}

@end
