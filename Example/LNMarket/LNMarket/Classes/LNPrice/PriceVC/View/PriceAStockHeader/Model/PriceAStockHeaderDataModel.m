//
//  PriceAStockHeaderDataModel.m
//  Market
//
//  Created by ZhangBob on 4/22/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "PriceAStockHeaderDataModel.h"
#import "LNNetWorking.h"
#import "LNNetworkAPI.h"
#import <LNStock/LNStockNetwork.h>

@implementation PriceAStockHeaderDataModel

+ (void)getPriceHeaderWithSymbol:(NSString *)symbol PriceResponse:(PriceResponse)priceResponse; {
    PriceAStockHeaderDataModel *priceData = [[PriceAStockHeaderDataModel alloc] init];
    [LNStockNetwork getStockRealDataWithCode:symbol block:^(BOOL isSuccess, id response) {
        if (isSuccess) {
            NSDictionary *snapshotDic = response;
            NSArray *fieldsArray = [snapshotDic valueForKey:@"fields"];
            
            NSInteger lastPxIndex = [fieldsArray indexOfObject:@"last_px"];
            NSInteger pxChangeIndex = [fieldsArray indexOfObject:@"px_change"];
            NSInteger pxChangeRateIndex = [fieldsArray indexOfObject:@"px_change_rate"];
            
            NSInteger openPxIndex = [fieldsArray indexOfObject:@"open_px"];
            NSInteger preClosePxIndex = [fieldsArray indexOfObject:@"preclose_px"];
            NSInteger businessAmountIndex = [fieldsArray indexOfObject:@"business_amount"];
            NSInteger turnoverRatioIndex = [fieldsArray indexOfObject:@"turnover_ratio"];
            
            NSInteger highPxIndex = [fieldsArray indexOfObject:@"high_px"];
            NSInteger lowPxIndex = [fieldsArray indexOfObject:@"low_px"];
            NSInteger peRateIndex = [fieldsArray indexOfObject:@"pe_rate"];
            NSInteger amplitudeIndex = [fieldsArray indexOfObject:@"amplitude"];
            
            NSInteger businessAmountInIndex = [fieldsArray indexOfObject:@"business_amount_in"];
            NSInteger businessAmountOutIndex = [fieldsArray indexOfObject:@"business_amount_out"];
            NSInteger marketValueIndex = [fieldsArray indexOfObject:@"market_value"];
            NSInteger circulationValueIndex = [fieldsArray indexOfObject:@"circulation_value"];
            
            NSArray *dataArray = [snapshotDic valueForKey:symbol];
            
            priceData.lastPx = [NSString stringWithFormat:@"%.2lf",[[dataArray objectAtIndex:lastPxIndex] floatValue]];
            priceData.pxChange = [NSString stringWithFormat:@"%.2lf",[[dataArray objectAtIndex:pxChangeIndex] floatValue]];
            priceData.pxChangeRate = [NSString stringWithFormat:@"%.2lf%%",[[dataArray objectAtIndex:pxChangeRateIndex] floatValue]];
            
            priceData.openPx = [NSString stringWithFormat:@"%.2lf",[[dataArray objectAtIndex:openPxIndex] floatValue]];
            priceData.preClosePx = [NSString stringWithFormat:@"%.2lf",[[dataArray objectAtIndex:preClosePxIndex] floatValue]];
            priceData.businessAmount = [NSString stringWithFormat:@"%.2lf",[[dataArray objectAtIndex:businessAmountIndex] floatValue]];
            priceData.turnoverRatio = [NSString stringWithFormat:@"%.2lf%%",[[dataArray objectAtIndex:turnoverRatioIndex] floatValue]];
            
            priceData.highPx = [NSString stringWithFormat:@"%.2lf",[[dataArray objectAtIndex:highPxIndex] floatValue]];
            priceData.lowPx = [NSString stringWithFormat:@"%.2lf",[[dataArray objectAtIndex:lowPxIndex] floatValue]];
            priceData.peRate = [NSString stringWithFormat:@"%.2lf",[[dataArray objectAtIndex:peRateIndex] floatValue]];
            priceData.amplitude = [NSString stringWithFormat:@"%.2lf%%",[[dataArray objectAtIndex:amplitudeIndex] floatValue]];
            
            priceData.businessAmountIn = [NSString stringWithFormat:@"%.2lf",[[dataArray objectAtIndex:businessAmountInIndex] floatValue]];
            priceData.businessAmountOut = [NSString stringWithFormat:@"%.2lf",[[dataArray objectAtIndex:businessAmountOutIndex] floatValue]];
            priceData.marketValue = [NSString stringWithFormat:@"%.2lf",[[dataArray objectAtIndex:marketValueIndex] floatValue]];
            priceData.circulationValue = [NSString stringWithFormat:@"%.2lf",[[dataArray objectAtIndex:circulationValueIndex] floatValue]];
            if (priceResponse) {
                priceResponse(YES,priceData);
            }
        } else {
            if (priceResponse) {
                priceResponse(NO,nil);
            }
        }
    }];
}
@end
