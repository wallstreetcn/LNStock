//
//  LNLimitRender.m
//  LNChart
//
//  Created by vvusu on 6/30/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNLimitRender.h"
#import "LNChartData.h"

@implementation LNLimitRender
+ (instancetype)initWithHandler:(LNChartHandler *)handler limit:(LNLimitLine *)limit {
    LNLimitRender *render = [[LNLimitRender alloc]init];
    render.limit = limit;
    render.viewHandler = handler;
    return render;
}

- (void)renderLimit:(CGContextRef)context data:(LNChartData *)data {
    if (_limit.isDrawEnabled) {
        
        CGPoint startPoint = [_limit.points[0] CGPointValue];
        CGPoint endPoint = [_limit.points[1] CGPointValue];
        [LNChartUtils drawDottedLine:context color:_limit.lineColor width:_limit.lineWidth statPoint:startPoint endPoint:endPoint];
        
        if (_limit.isDrawTitle) {
            NSDictionary *attributes = @{NSFontAttributeName:_limit.textFont,NSBackgroundColorAttributeName:_limit.textBGColor,NSForegroundColorAttributeName:_limit.textColor};
            
            CGFloat levelLineY = startPoint.y;
            CGFloat labelY = levelLineY;
            CGSize labelSize = [_limit.content sizeWithAttributes:attributes];
            labelY = levelLineY - labelSize.height / 2;
            if (labelY < (self.viewHandler.contentTop)) {
                labelY = self.viewHandler.contentTop;
            }
            else if (labelY > self.viewHandler.contentBottom - labelSize.height) {
                labelY = self.viewHandler.contentBottom - labelSize.height;
            }
            
            if (startPoint.y >= self.viewHandler.contentTop &&
                startPoint.y <= self.viewHandler.contentBottom) {
                CGPoint labelPoint = CGPointMake(endPoint.x, labelY);
                [LNChartUtils drawText:context text:_limit.content point:labelPoint align:NSTextAlignmentLeft attributes:attributes];
            }
        }
    }
}

@end
