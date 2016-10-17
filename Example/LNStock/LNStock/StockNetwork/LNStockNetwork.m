//
//  QuotesNetwork.m
//  Market
//
//  Created by vvusu on 5/10/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockNetwork.h"
#import "LNRealModel.h"
#import "LNStockModel.h"
#import "LNStockHandler.h"
#import "LNStockNetworking.h"
#import "LNStockFormatter.h"

@implementation LNStockNetwork

#pragma mark - 分时
+ (void)getStockMinuteDataWithStockCode:(NSString *)code block:(PriceNetworkBlock)block {
    LNStockRequest * request = [[LNStockRequest alloc] init];
    request.url = [NSString stringWithFormat:@"%@%@",KIAStockAPI,KIAStockTrendAPI];;
    request.url = [request.url stringByReplacingOccurrencesOfString:@"symbol" withString:code];
    request.headers = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json",@"Accept", nil];
    [LNStockNetWorking getWithRequest:request success:^(LNStockResponse *response) {
        if (response.dataDic) {
            if ([response.dataDic isKindOfClass:[NSNull class]]) {
                return;
            }
            NSDictionary *dataDic = [response.dataDic valueForKey:@"data"];
            NSDictionary* trendInfo = [dataDic valueForKey:@"trend"];
            NSArray* fields = [trendInfo valueForKey:@"fields"];
            NSInteger minTimeIndex = [fields indexOfObject:@"min_time"];
            NSInteger lastPriceIndex = [fields indexOfObject:@"last_px"];
            NSInteger averagePriceIndex = [fields indexOfObject:@"avg_px"];
            NSInteger businessCountIndex = [fields indexOfObject:@"business_amount"];
            NSDateFormatter* dateFormat = [LNStockFormatter sharedInstanceFormatter];
            dateFormat.dateFormat = @"yyyyMMddHHmm";
            NSArray* trendItems = [trendInfo valueForKey:code];
            NSUInteger previousBusinessCount = 0;
            NSMutableArray* dataModels = [NSMutableArray array];
            
            //昨收价格
            NSDictionary *real = [dataDic valueForKey:@"real"];
            NSNumber *preClosePx = [NSNumber numberWithFloat:[[real valueForKey:@"pre_close_px"] floatValue]];
            
            for (NSArray *trendItem in trendItems){
                LNRealModel* data = [[LNRealModel alloc] init];
                NSUInteger businessCount = [[trendItem objectAtIndex:businessCountIndex] unsignedIntegerValue];
                data.volume = [NSNumber numberWithFloat:(businessCount - previousBusinessCount)];
                data.averagePrice = [trendItem objectAtIndex:averagePriceIndex];
                data.price = [trendItem objectAtIndex:lastPriceIndex];
                data.preClosePx = preClosePx;
                
                NSString* dateString = [NSString stringWithFormat:@"%@",[trendItem objectAtIndex:minTimeIndex]];
                data.date = [dateFormat dateFromString:dateString];
                
                [dataModels addObject:data];
                previousBusinessCount = businessCount;
            }
            if (block){
                block(YES,dataModels);
            }
        }else {
            if (block) {
                block(NO,response.message);
            }
        }
    } fail:^(NSError *error) {
        if (block) {
            block(NO,error.localizedDescription);
        }
    }];
}

#pragma mark - A股分时交易数据（五档）
+ (void)getDealListDataWithStockCode:(NSString *)code block:(PriceNetworkBlock)block {
    if (!code) { return; }
    LNStockRequest *request = [[LNStockRequest alloc] init];
    request.url = [NSString stringWithFormat:@"%@%@fields=bid_grp,offer_grp,preclose_px",KIAStockAPI,KIAStockPriceAPI];
    request.url = [request.url stringByReplacingOccurrencesOfString:@"symbol" withString:code];
    [LNStockNetWorking getWithRequest:request success:^(LNStockResponse *response) {
        NSDictionary *dataDic = [response.dataDic valueForKey:@"data"];
        if (dataDic == 0) {
            if (block) {
                block(NO,response.message);
            }
        }else {
            NSDictionary *snapshotDic = [dataDic valueForKey:@"snapshot"];
            NSArray *fieldsArr = [snapshotDic valueForKey:@"fields"];
            NSArray *dataArr = [snapshotDic valueForKey:code];
            NSInteger buyGrpIndex = [fieldsArr indexOfObject:@"bid_grp"];
            NSInteger saleGrpIndex = [fieldsArr indexOfObject:@"offer_grp"];
            NSInteger preclosePxIndex = [fieldsArr indexOfObject:@"preclose_px"];
            NSNumber *preclosePx = [dataArr objectAtIndex:preclosePxIndex];
            
            NSString *buyString = [dataArr objectAtIndex:buyGrpIndex];
            NSString *saleString = [dataArr objectAtIndex:saleGrpIndex];
            
            NSMutableArray *buyArray = [NSMutableArray arrayWithArray:[buyString componentsSeparatedByString:@","]];
            [buyArray removeLastObject];
            NSMutableArray *SaleArray = [NSMutableArray arrayWithArray:[saleString componentsSeparatedByString:@","]];
            [SaleArray removeLastObject];
            NSMutableArray *requestedPriceArr = [NSMutableArray array];
            NSMutableArray *dealNumberArr = [NSMutableArray array];
            for (NSInteger j = SaleArray.count-1; j >= 0; j--) {
                if (j % 3 == 0) {
                    [requestedPriceArr addObject:SaleArray[j]];
                }
                if (j % 3 == 1) {
                    [dealNumberArr addObject:SaleArray[j]];
                }
            }
            for (int i = 0; i < buyArray.count; i++) {
                if (i % 3 == 0) {
                    [requestedPriceArr addObject:buyArray[i]];
                }
                if (i % 3 == 1) {
                    [dealNumberArr addObject:buyArray[i]];
                }
            }
            
            NSDictionary *dataDict = [NSDictionary dictionaryWithObjectsAndKeys:requestedPriceArr,@"RequestedPriceArr",dealNumberArr,@"DealNumberArr",preclosePx,@"preclose_px",nil];
            if (block) {
                block(YES,dataDict);
            }
        }
    } fail:^(NSError *error) {
        if (block) {
            block(NO,error.localizedDescription);
        }
    }];
}


#pragma mark - 五日
+ (void)getAstockFiveDaysDataWithStockCode:(NSString *)code block:(PriceNetworkBlock)block {
    LNStockRequest *request = [[LNStockRequest alloc] init];
    request.url = [NSString stringWithFormat:@"%@%@",KIAStockAPI,KIAStockTrend5DayAPI];
    request.url = [request.url stringByReplacingOccurrencesOfString:@"symbol" withString:code];
    request.headers = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json",@"Accept", nil];
    [LNStockNetWorking getWithRequest:request success:^(LNStockResponse *response) {
        if (response.dataDic) {
            if ([response.dataDic isKindOfClass:[NSNull class]]) {
                return;
            }
            NSDictionary *dataDic = [response.dataDic valueForKey:@"data"];
            NSDictionary* trendInfo = [dataDic valueForKey:@"trend"];
            NSArray* fields = [trendInfo valueForKey:@"fields"];
            
            NSInteger minTimeIndex = [fields indexOfObject:@"min_time"];
            NSInteger lastPriceIndex = [fields indexOfObject:@"last_px"];
            NSInteger averagePriceIndex = [fields indexOfObject:@"avg_px"];
            NSInteger businessCountIndex = [fields indexOfObject:@"business_amount"];
            //昨收价格
            NSDictionary *real = [dataDic valueForKey:@"real"];
            NSNumber *preClosePx = [NSNumber numberWithFloat:[[real valueForKey:@"pre_close_px"] floatValue]];
            
            NSDateFormatter* dateFormat = [LNStockFormatter sharedInstanceFormatter];
            dateFormat.dateFormat = @"yyyyMMddHHmm";
            NSUInteger previousBusinessCount = 0;
            
            NSMutableArray* kLineDataItems = [NSMutableArray array];
            NSArray* trendItems = [trendInfo valueForKey:code];
            NSInteger lastDate = 0;
            for (NSInteger i = 0; i < trendItems.count; i++) {
                NSArray *trendItem = trendItems[i];
                LNRealModel* data = [[LNRealModel alloc] init];
                data.preClosePx = preClosePx;
                data.averagePrice = [trendItem objectAtIndex:averagePriceIndex];
                data.price = [trendItem objectAtIndex:lastPriceIndex];
                if (data.price.floatValue == 0) {
                    data.price = [NSNumber numberWithFloat:-1];
                }
                
                //double 格式，iphone 日期格式转换有问题
                NSNumber *dateNum = [trendItem objectAtIndex:minTimeIndex];
                NSString *dataStr = [NSString stringWithFormat:@"%.f",dateNum.doubleValue];
                data.date = [dateFormat dateFromString:dataStr];
                NSInteger dayValue = [[dataStr substringWithRange:NSMakeRange(6, 2)]integerValue];
                NSUInteger businessCount = [[trendItem objectAtIndex:businessCountIndex] unsignedIntegerValue];
                if (i == 0) {
                    data.volume = [NSNumber numberWithFloat:businessCount];
                } else {
                    if (dayValue == lastDate) {
                        if (businessCount >= previousBusinessCount) {
                            data.volume = [NSNumber numberWithInteger:businessCount - previousBusinessCount];
                        }
                    } else {
                        data.volume = [NSNumber numberWithInteger:businessCount];
                    }
                }
                lastDate = dayValue;
                previousBusinessCount = businessCount;
                [kLineDataItems addObject:data];
            }
            if (block){
                block(YES,kLineDataItems);
            }
        } else {
            if (block) {
                block(NO,response.message);
            }
        }
    } fail:^(NSError *error) {
        if (block) {
            block(NO,error.localizedDescription);
        }
    }];
}

#pragma mark - K线
+ (void)getAstockDataWithStockCode:(NSString *)code
                            adjust:(NSString *)adjust
                              type:(NSString *)type
                               num:(NSString *)num
                           endTime:(NSString *)endTime
                             block:(PriceNetworkBlock)block {
    
    NSString *urlSting = [NSString stringWithFormat:@"%@%@",KIAStockAPI,KIAStockKLineAPI];
    urlSting = [urlSting stringByReplacingOccurrencesOfString:@"symbol" withString:code];
    urlSting = [urlSting stringByReplacingOccurrencesOfString:@"interval" withString:type];
    LNStockRequest * request = [[LNStockRequest alloc] init];
    request.url = urlSting;
    [request.parameters setValue:num forKey:@"data_count"];           //请求个数
    [request.parameters setValue:endTime forKey:@"end_time"];         //时间
    [request.parameters setValue:type forKey:@"candle_period"];       //K线类型
    [request.parameters setValue:adjust forKey:@"adjust_price_type"]; //复权类型
    NSString *fields = KIAStockKLineFields;
    //K线参数
    switch ([LNStockHandler factorType]) {
        case LNStockFactorType_Volume:
            fields = [NSString stringWithFormat:@"%@,%@",fields,KIAStockAmountFields];
            break;
        case LNStockFactorType_MACD:
            fields = [NSString stringWithFormat:@"%@,%@",fields,KIAStocMACDFields];
            break;
        case LNStockFactorType_BOLL:
            fields = [NSString stringWithFormat:@"%@,%@",fields,KIAStocBOLLFields];
            break;
        case LNStockFactorType_KDJ:
            fields = [NSString stringWithFormat:@"%@,%@",fields,KIAStocKDJFields];
            break;
        case LNStockFactorType_RSI:
            fields = [NSString stringWithFormat:@"%@,%@",fields,KIAStocRSIFields];
            break;
        case LNStockFactorType_OBV:
            fields = [NSString stringWithFormat:@"%@,%@",fields,KIAStocOBVFields];
            break;
        default:
            break;
    }
    [request.parameters setValue:fields forKey:@"fields"];
    request.headers = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json",@"Accept", nil];
    [LNStockNetWorking getWithRequest:request success:^(LNStockResponse *response) {
        if (response.dataDic) {
            NSMutableArray *dataArr = [NSMutableArray array];
            dataArr = [LNRealModel AnalyticalData:code Dic:response.dataDic];
            if (block){
                block(YES, dataArr);
            }
        }else {
            if (block) {
                block(NO,response.message);
            }
        }
    } fail:^(NSError *error) {
        if (block) {
            block(NO,error.localizedDescription);
        }
    }];
}

#pragma mark - RealAPI 行情API
+ (void)getStockRealDataWithCode:(NSString *)code isAstock:(BOOL)isAstock block:(PriceNetworkBlock)block {
    LNStockRequest * request = [[LNStockRequest alloc] init];
    request.url = [NSString stringWithFormat:@"%@%@",KIAStockAPI,KIStockRealAPI];
    request.headers = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json",@"Accept", nil];
    [request.parameters setValue:code forKey:@"en_prod_code"];
    [request.parameters setValue:@"" forKey:@"format"];
    [request.parameters setValue:KIAStockRealFields forKey:@"fields"];
    //是否是外汇
    if (!isAstock) {
        request.url = [NSString stringWithFormat:@"%@%@",KIBStockAPI,KIBStockPriceAPI];
        [request.parameters setValue:KIBStockRealFields forKey:@"fields"];
    }
    [LNStockNetWorking getWithRequest:request success:^(LNStockResponse *response) {
        if (response.dataDic) {
            LNStockModel *model = [[LNStockModel alloc]init];
            [model setupWithCode:code dataDic:response.dataDic];
            
            if (block) {
                block(YES,model);
            }
        } else {
            if (block) {
                block(NO,response.message);
            }
        }
    } fail:^(NSError *error) {
        if (block) {
            block(NO,error.localizedDescription);
        }
    }];
}
+ (void)getStockRealDataWithCode:(NSString *)code block:(PriceNetworkBlock)block {
}

#pragma mark - 外汇
+ (void)getBstockDataWithStockCode:(NSString *)code
                              type:(NSString *)type
                               num:(NSInteger)num
                           endTime:(NSString *)endTime
                             block:(PriceNetworkBlock)block {
    
    LNStockRequest * request = [[LNStockRequest alloc] init];
    request.url = [NSString stringWithFormat:@"%@%@",KIBStockAPI,KIBStockKLineAPI];
    [request.parameters setValue:endTime forKey:@"end_time"];
    [request.parameters setValue:code forKey:@"prod_code"];
    [request.parameters setValue:type forKey:@"candle_period"]; //K线类型
    [request.parameters setValue:[NSString stringWithFormat:@"%ld",(long)num] forKey:@"data_count"];  //请求个数
    [request.parameters setValue:@"open_px,close_px,high_px,low_px,business_amount,time_stamp" forKey:@"fields"];
    request.headers = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json",@"Accept", nil];
    [LNStockNetWorking getWithRequest:request success:^(LNStockResponse *response) {
        if (response.dataDic) {
            NSDictionary *dataDic = [response.dataDic valueForKey:@"data"];
            NSMutableArray *dataModels = [NSMutableArray array];
            NSDictionary* candleInfo = [dataDic valueForKey:@"candle"];
            NSArray *fields = [candleInfo valueForKey:@"fields"];
            NSInteger lowIndex = [fields indexOfObject:@"low_px"];
            NSInteger openIndex = [fields indexOfObject:@"open_px"];
            NSInteger highIndex = [fields indexOfObject:@"high_px"];
            NSInteger closeIndex = [fields indexOfObject:@"close_px"];
            NSInteger time_stampIndex = [fields indexOfObject:@"time_stamp"];
            NSInteger businessAmountIndex = [fields indexOfObject:@"business_amount"];
            
            NSArray* kLineItems = [candleInfo valueForKey:code];
            for (NSArray* kLineItem in kLineItems){
                LNRealModel* data = [[LNRealModel alloc] init];
                data.open = kLineItem[openIndex];
                data.close = kLineItem[closeIndex];
                data.high = kLineItem[highIndex];
                data.low = kLineItem[lowIndex];
                data.volume = kLineItem[businessAmountIndex];
                NSNumber *timeNum = kLineItem[time_stampIndex];
                data.date = [NSDate dateWithTimeIntervalSince1970:timeNum.doubleValue];
                [dataModels addObject:data];
            }
            if (block) {
                block(YES,dataModels);
            }
        } else {
            if (block) {
                block(NO,response.message);
            }
        }
    } fail:^(NSError *error) {
        if (block) {
            block(NO,error.localizedDescription);
        }
    }];
}

#pragma mark - 行情列表
/**
 *  行情列表（沪深)
 *
 *  @param type  排序方式
 *  @param num   数据个数: 该值为非负数。
 *  @param block Block返回数据
 */
+ (void)getAstockListDataWithSortType:(SortType)type
                                  num:(NSInteger)num
                                block:(PriceNetworkBlock)block {
    LNStockRequest * request = [[LNStockRequest alloc] init];
    request.url = [NSString stringWithFormat:@"%@%@",KIAStockAPI,KIAStockListAPI];
    request.headers = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json",@"Accept", nil];
    //是否按照升序排序
    BOOL ascending;
    //排序的key
    NSString *sortKey;
    switch (type) {
        case SortTypeAscending_pxChange:
            [request.parameters setValue:@"0" forKey:@"sort_type"];
            ascending = YES;
            sortKey = @"px_change";
            break;
        case SortTypeDescending_pxChange:
            [request.parameters setValue:@"1" forKey:@"sort_type"];
            ascending = NO;
            sortKey = @"px_change";
            break;
        case SortTypeAscending_pxChangeRate:
            [request.parameters setValue:@"0" forKey:@"sort_type"];
            ascending = YES;
            sortKey = @"px_change_rate";
            break;
        case SortTypeDescending_pxChangeRate:
            [request.parameters setValue:@"1" forKey:@"sort_type"];
            ascending = NO;
            sortKey = @"px_change_rate";
            break;
        default:
            break;
    }
    [request.parameters setValue:KIAStockListFields forKey:@"fields"];
    [request.parameters setValue:[NSString stringWithFormat:@"%ld",(long)num] forKey:@"data_count"];
    [LNStockNetWorking getWithRequest:request success:^(LNStockResponse *response) {
        if (response.dataDic) {
            //解析
            NSMutableArray *array = [NSMutableArray array];
            NSDictionary *data = [response.dataDic valueForKey:@"data"];
            NSDictionary *stockDic = [data valueForKey:@"sort"];
            array = [LNStockModel parseDataWithDataDic:stockDic];
            //对返回的数据做排序，按照sortKey做排序
            //ascending=YES,升序排列；ascending=NO，降序排列
            NSSortDescriptor *priceChangeRateDesc = [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:ascending];
            NSArray *descriptorArray = [NSArray arrayWithObjects:priceChangeRateDesc, nil];
            NSArray *sortedArray = [array sortedArrayUsingDescriptors:descriptorArray];
            if (block) {
                block(YES, sortedArray);
            }
        }else {
            if (block) {
                block(NO,response.message);
            }
        }
    } fail:^(NSError *error) {
        
    }];
}

/**
 *  行情列表(外汇、商品、债券、股指、股指期货行)
 *
 *  @param type  外汇数据的类型: forex(外汇)，commodity(商品)，bond(债券)，indice(股指)，cfdindice(股指期货)
 *  @param block Block返回数据
 */
+ (void)getBstockListDataWithType:(StockListType)type block:(PriceNetworkBlock)block {
    LNStockRequest * request = [[LNStockRequest alloc] init];
    request.url = [NSString stringWithFormat:@"%@%@",KIBStockAPI,KIBStockListAPI];
    request.headers = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json",@"Accept", nil];
    switch (type) {
        case StockListType_Forex:
            [request.parameters setValue:@"forex" forKey:@"type"];
            break;
        case StockListType_Commodity:
            [request.parameters setValue:@"commodity" forKey:@"type"];
            break;
        case StockListType_Bond:
            [request.parameters setValue:@"bond" forKey:@"type"];
            break;
        case StockListType_Indice:
            [request.parameters setValue:@"indice" forKey:@"type"];
            break;
        case StockListType_Cfdindice:
            [request.parameters setValue:@"cfdindice" forKey:@"type"];
            break;
        default:
            break;
    }
    [request.parameters setValue:KIBStockListFields forKey:@"fields"];
    [LNStockNetWorking getWithRequest:request success:^(LNStockResponse *response) {
        if (response.dataDic) {
            //解析
            NSMutableArray *array = [NSMutableArray array];
            NSDictionary *data = [response.dataDic valueForKey:@"data"];
            NSDictionary *stockDic = [data valueForKey:@"snapshot"];
            array = [LNStockModel parseForexDataWithDataDic:stockDic];
            if (block) {
                block(YES, array);
            }
        }else {
            if (block) {
                block(NO,response.message);
            }
        }
    } fail:^(NSError *error) {
        if (block) {
            block(NO,error.localizedDescription);
        }
    }];
}

/**
 *  行情列表(自选，上证指数、深证成指、创业板指)
 *
 *  @param prodCodeArr 存放股票代码的数组，该数组至少有一个元素，股票代码的格式:A股对应 xxxxx.SZ，外汇对应 xxxx
 *  @param block       Block返回数据
 */
+ (void)getStockListDataWithProdCodeArr:(NSArray *)prodCodeArr block:(PriceNetworkBlock)block {
    //将数组中的所有股票代码拼成一个字符串
    NSString *tempString = @"";
    for (int i = 0 ; i < prodCodeArr.count; i++) {
        if (i == prodCodeArr.count - 1) {
            NSString *prodCode = prodCodeArr[i];
            tempString = [NSString stringWithFormat:@"%@%@",tempString,prodCode];
        }else {
            NSString *prodCode = prodCodeArr[i];
            tempString = [NSString stringWithFormat:@"%@%@,",tempString,prodCode];
        }
    }
    LNStockRequest *request = [[LNStockRequest alloc] init];
    request.url = [NSString stringWithFormat:@"%@%@",KIBStockAPI,KIStockRealAPI];
    request.headers = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json",@"Accept", nil];
    [request.parameters setValue:tempString forKey:@"en_prod_code"];
    [request.parameters setValue:KIAStockListFields forKey:@"fields"];
    [LNStockNetWorking getWithRequest:request success:^(LNStockResponse *response) {
        if (response.dataDic) {
            //解析
            NSMutableArray *array = [NSMutableArray array];
            NSDictionary *data = [response.dataDic valueForKey:@"data"];
            array = [LNStockModel parseForexDataWithDataDic:data prodCodeArr:prodCodeArr];
            if (block) {
                block(YES, array);
            }
        }else {
            if (block) {
                block(NO,response.message);
            }
        }
    } fail:^(NSError *error) {
        if (block) {
            block(NO,error.localizedDescription);
        }
    }];
}

/**
 *  搜索列表
 *
 *  @param content 搜索的内容，NSString型
 *  @param num     返回结果的数量，NSInteger型
 *  @param block   Block返回数据
 */
+ (void)getStockSearchListWithContent:(NSString *)content
                                  num:(NSString *)num
                                block:(PriceNetworkBlock)block {
    LNStockRequest *request = [[LNStockRequest alloc] init];
    request.url = [NSString stringWithFormat:@"%@%@",KIAStockAPI,KIAStockSearchAPI];
    request.headers = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json",@"Accept", nil];
    content = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //中文转码
    [request.parameters setValue:num forKey:@"s"];
    [request.parameters setValue:content forKey:@"q"];
    [LNStockNetWorking getWithRequest:request success:^(LNStockResponse *response) {
        if (response.dataDic) {
            NSDictionary *data = [response.dataDic valueForKey:@"data"];
            NSArray *stockArr = [data valueForKey:@"finances"];
            NSMutableArray *array = [NSMutableArray array];
            if ([stockArr isKindOfClass:[NSArray class]]) {
                if (stockArr.count > 0) {
                    for (NSDictionary *item in stockArr) {
                        LNStockModel *model = [[LNStockModel alloc]init];
                        model.prod_code = [item valueForKey:@"Code"];
                        model.prod_name = [item valueForKey:@"ProdName"];
                        model.market_type = [item valueForKey:@"market_type"];
                        model.securities_type = [item valueForKey:@"securities_type"];
                        if ([model.market_type isEqualToString:@"forexdata"]) {
                            model.finance_type = model.securities_type;
                        }else if ([model.market_type isEqualToString:@"mdc"]) {
                            model.finance_type = @"stock";
                        }
                        model.stockUrl = [item valueForKey:@"url"];
                        model.htmlTag = [item valueForKey:@"htmlTag"];
                        [array addObject:model];
                    }
                }
            }
            if (block) {
                block(YES,array);
            }
        } else {
            if (block) {
                block(NO, response.message);
            }
        }
    } fail:^(NSError *error) {
        if (block) {
            block(NO, error.localizedDescription);
        }
    }];
}

#pragma mark - requestStockNews Utils
static NSDictionary *stFixedHSSymbols = nil;
+ (void)ensureFixedHSSymbols {
    if (stFixedHSSymbols == nil){
        stFixedHSSymbols = @{@"SH000001":@"SS1A0001", @"SH000002":@"SS1A0002", @"SH000003":@"SS1A0003", @"SZ399001":@"SZ2A01", @"SZ399002":@"SZ2A02", @"SZ399003":@"SZ2A03", @"SZ399106":@"SZ2C01", @"SZ399107":@"SZ2C02", @"SZ399108":@"SZ2C03"};
    }
}

static NSDictionary* stFixedWSCNSymbols = nil;
+ (void)ensureFixedWSCNSymbols {
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
    wscnSymbol = [NSString stringWithFormat:@"%@%@",[wscnSymbol substringFromIndex:wscnSymbol.length-2],[wscnSymbol substringToIndex:wscnSymbol.length-3]];
    return wscnSymbol;
}

@end
