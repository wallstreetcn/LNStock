//
//  PriceNetwork.m
//  Market
//
//  Created by ZhangBob on 4/28/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "PriceNetwork.h"
#import "PriceCellModel.h"
#import "LNNetWorking.h"

#define KIWSCNPostAPI @"http://api.buzz.wallstreetcn.com/v2/posts?"

@implementation PriceNetwork

#pragma mark - requestStockNews
+ (void)getStockNewsWithParamter:(NSDictionary *)paramters block:(PriceNetworkBlock)block {
    LNRequest *request = [[LNRequest alloc] init];
    request.url = KIWSCNPostAPI;
    [request.parameters setValue:[paramters valueForKey:@"NewsIdentifier"] forKey:@"cid"];
    [request.parameters setValue:@"10" forKey:@"limit"];
    [request.parameters setValue:[self hsSymbolToWSCNSymbol:[paramters valueForKey:@"stockSymbol"]] forKey:@"tag"];

    [LNNetWorking getWithRequest:request success:^(LNResponse *response) {
        NSArray *array = [NSArray array];
        array = [response.resultDic valueForKey:@"results"];
        if (array.count) {
            NSMutableArray *stockNewsDataArr = [NSMutableArray array];
            for (NSInteger i = 0; i <array.count; i++) {
                PriceCellModel *postModel = [PriceCellModel mj_objectWithKeyValues:array[i]];
                [stockNewsDataArr addObject:postModel];
            }
            if (block) {
                block(YES,stockNewsDataArr);
            }
        }else {
            if (block) {
                block(NO,response.errorMsg);
            }
        }
    } fail:^(NSError *error) {
        if (block) {
            block(NO,error.localizedDescription);
        }
    }];
}

+(void)getMoreStockNewsWihtParamter:(NSDictionary *)paramters block:(PriceNetworkBlock)block {    
    LNRequest *request = [[LNRequest alloc] init];
    request.url = KIWSCNPostAPI;
    [request.parameters setValue:[paramters valueForKey:@"NewsIdentifier"] forKey:@"cid"];
    [request.parameters setObject:@"10" forKey:@"limit"];
    [request.parameters setValue:[self hsSymbolToWSCNSymbol:[paramters valueForKey:@"stockSymbol"]] forKey:@"tag"];
    [request.parameters setValue:[NSString stringWithFormat:@"%@",[paramters valueForKey:@"page"]] forKey:@"page"];
    
    [LNNetWorking getWithRequest:request success:^(LNResponse *response) {
        NSArray *array = [[NSArray alloc] init];
        array = [response.resultDic valueForKey:@"results"];
        if (array.count) {
            NSMutableArray *stockNewsDataArr = [NSMutableArray array];
            for (NSInteger i = 0; i <array.count; i++) {
                PriceCellModel *postModel = [PriceCellModel mj_objectWithKeyValues:array[i]];
                [stockNewsDataArr addObject:postModel];
            }
            if (block) {
                block(YES,stockNewsDataArr);
            }
        }else {
            if (block) {
                block(NO,response.errorMsg);
            }
        }
    } fail:^(NSError *error) {
        if (block) {
            block(NO,error.localizedDescription);
        }
    }];
}

#pragma mark - requestStockNews Utils
static NSDictionary *stFixedHSSymbols = nil;
+ (void) ensureFixedHSSymbols {
    if (stFixedHSSymbols == nil){
        stFixedHSSymbols = @{@"SH000001":@"SS1A0001", @"SH000002":@"SS1A0002", @"SH000003":@"SS1A0003", @"SZ399001":@"SZ2A01", @"SZ399002":@"SZ2A02", @"SZ399003":@"SZ2A03", @"SZ399106":@"SZ2C01", @"SZ399107":@"SZ2C02", @"SZ399108":@"SZ2C03"};
    }
}

static NSDictionary* stFixedWSCNSymbols = nil;
+ (void) ensureFixedWSCNSymbols {
    if (stFixedWSCNSymbols == nil){
        stFixedWSCNSymbols = @{@"1A0001.SS":@"000001.SH", @"1A0002.SS":@"000002.SH", @"1A0003.SS":@"000003.SH", @"2A01.SZ":@"399001.SZ", @"2A02.SZ":@"399002.SZ", @"2A03.SZ":@"399003.SZ", @"2C01.SZ":@"399106.SZ", @"2C02.SZ":@"399107.SZ", @"2C03.SZ":@"399108.SZ"};
    }
}

+ (NSString *)hsSymbolToWSCNSymbol:(NSString *)symbol {
    [self ensureFixedHSSymbols];
    
    NSString* wscnSymbol = symbol;
    if ([stFixedWSCNSymbols objectForKey:wscnSymbol]){
        wscnSymbol = [stFixedWSCNSymbols objectForKey:wscnSymbol];
    }
    else if ([wscnSymbol hasPrefix:@"000" ]&&[wscnSymbol hasSuffix:@"SH"]){
        wscnSymbol = [symbol stringByReplacingOccurrencesOfString:@"000" withString:@"1B0"];
        wscnSymbol = [symbol stringByReplacingOccurrencesOfString:@"SH" withString:@"SS"];
    }
    else{
        wscnSymbol = [symbol stringByReplacingOccurrencesOfString:@"SS" withString:@"SH"];
    }
    if (wscnSymbol.length > 3) {
        wscnSymbol = [NSString stringWithFormat:@"%@%@",[wscnSymbol substringFromIndex:wscnSymbol.length-2],[wscnSymbol substringToIndex:wscnSymbol.length-3]];
    }
    return wscnSymbol;
}

@end
