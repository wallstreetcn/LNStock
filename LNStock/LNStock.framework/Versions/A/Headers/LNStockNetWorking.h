//
//  LNNetWorking.h
//  News
//
//  Created by vvusu on 3/29/16.
//  Copyright © 2016 wallstreetcn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNStockRequest.h"
#import "LNStockAPI.h"
#import "LNStockResponse.h"

typedef void(^LNResponseSuccess)(id response);
typedef void(^LNResponseFail)(NSError *error);

typedef void (^LNDownloadProgress)(int64_t bytesRead, int64_t totalBytesRead);
typedef LNDownloadProgress LNGetProgress;
typedef LNDownloadProgress LNPostProgress;

@class NSURLSessionTask;
typedef NSURLSessionTask LNURLSessionTask;

@interface LNStockNetWorking : NSObject

+ (void)cancelAllTasks;

+ (LNURLSessionTask *)getWithRequest:(LNStockRequest *)request
                             success:(LNResponseSuccess)success
                                fail:(LNResponseFail)fail;

+ (LNURLSessionTask *)postWithRequest:(LNStockRequest *)request
                              success:(LNResponseSuccess)success
                                 fail:(LNResponseFail)fail;
@end