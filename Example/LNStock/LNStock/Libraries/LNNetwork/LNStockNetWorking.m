//
//  LNStockNetWorking.m
//  LNStock
//
//  Created by vvusu on 6/2/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNStockNetWorking.h"

@implementation LNStockNetWorking
+ (NSURLSession *)sharedEphemeralSession {
    static dispatch_once_t onceToken;
    static NSURLSession *session;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        config.HTTPMaximumConnectionsPerHost = 5;
        session = [NSURLSession sessionWithConfiguration:config];
    });
    return session;
}

+ (void)cancelAllTasks {
    NSURLSession *session = [self sharedEphemeralSession];
    [session getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
        for (NSURLSessionDataTask *task in dataTasks) {
            [task cancel];
        }
    }];
}

#pragma mark - HTTPRequest
+ (LNURLSessionTask *)getWithRequest:(LNStockRequest *)request
                             success:(LNResponseSuccess)success
                                fail:(LNResponseFail)fail {
    
    request.requestMethod = LNRequestMethodGet;
    return [self request:request progress:nil success:success fail:fail];
    
}

+ (LNURLSessionTask *)postWithRequest:(LNStockRequest *)request
                              success:(LNResponseSuccess)success
                                 fail:(LNResponseFail)fail {
    
    request.requestMethod = LNRequestMethodPost;
    return [self request:request progress:nil success:success fail:fail];
}

+ (LNURLSessionTask *)request:(LNStockRequest *)request
                     progress:(LNDownloadProgress)progress
                      success:(LNResponseSuccess)success
                         fail:(LNResponseFail)fail {
    
    if ([NSURL URLWithString:request.url] == nil) {
        return nil;
    }
    
    if (request.requestMethod == LNRequestMethodGet) {
        request.url = [NSString stringWithFormat:@"%@%@",request.url,[LNStockNetWorking parseParams:request.parameters]];
    }
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:request.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    
    if (urlRequest == nil) {
        return nil;
    }
    if (request.headers) {
        [urlRequest setAllHTTPHeaderFields:request.headers];
    }
    
    NSURLSession * session = [self sharedEphemeralSession];
    switch (request.requestMethod) {
        case LNRequestMethodGet: {
            [urlRequest setHTTPMethod:@"GET"];
        }
            break;
        case LNRequestMethodPost: {
            [urlRequest setHTTPMethod:@"POST"];
            [urlRequest setHTTPBody:[self praseParamsPostData:request.parameters]];
        }
            break;
    }
    
    NSURLSessionDataTask *task = nil;
    __block NSURLSessionTask *wtask = task;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        wtask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error) {
                    if (success) {
                        success([self parseData:data]);
                    }
                } else {
                    if (fail) {
                        fail(error);
                    }
                }
            });
        }];
        [wtask resume];
    });
    return task;
}

#pragma mark - OTher
+ (NSString *)parseParams:(NSDictionary *)params{
    NSString *keyValueFormat;
    NSMutableString *result = [NSMutableString string];
    NSMutableArray *array = [NSMutableArray new];
    NSEnumerator *keyEnum = [params keyEnumerator];
    id key;
    while (key = [keyEnum nextObject]) {
        keyValueFormat = [NSString stringWithFormat:@"&%@=%@",key,[params valueForKey:key]];
        [result appendString:keyValueFormat];
        [array addObject:keyValueFormat];
    }
    return result;
}

+ (NSData *)praseParamsPostData:(NSDictionary *)params {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonSring = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSData *data = [jsonSring dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

+ (id)parseData:(id)responseData {
    LNStockResponse *reponseModel = [[LNStockResponse alloc]init];
    reponseModel.succeed = NO;
    if ([responseData isKindOfClass:[NSData class]]) {
        reponseModel.data = responseData;
        if (responseData == nil) {
            reponseModel.message = @"返回数据Data为空";
            return reponseModel;
        } else {
            NSError *error = nil;
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseData
                                                                    options:NSJSONReadingAllowFragments
                                                                      error:&error];
            if (error) {
                reponseModel.message = @"utf8解析错误";
                return reponseModel;
            } else {
                //如果解析为NSArray，转化为字典
                if ([jsonDic isKindOfClass:[NSArray class]]) {
                    NSDictionary *resultDic = @{@"data":jsonDic};
                    reponseModel.dataDic = resultDic;
                } else {
                    reponseModel.dataDic = jsonDic;
                }
                return reponseModel;
            }
        }
    } else {
        return reponseModel;
    }
}

//暂时不用
+ (LNStockResponse *)parserJSON:(NSDictionary *)resultDic with:(LNStockResponse *)reponseModel{
    reponseModel.dataDic = resultDic;
    NSString *rs = [resultDic valueForKey:@"retcode"];
    if (rs.integerValue == 0) {
        reponseModel.succeed = YES;
    } else {
        reponseModel.code = rs;
        reponseModel.message = [resultDic valueForKey:@"retmsg"];
    }
    return reponseModel;
}

@end
