//
//  LNRequest.h
//  News
//
//  Created by vvusu on 3/29/16.
//  Copyright © 2016 wallstreetcn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNNetworkAPI.h"

typedef NS_ENUM(NSInteger , LNRequestMethod) {
    LNRequestMethodGet = 0, //查
    LNRequestMethodPost,    //改
};

@interface LNRequest : NSObject
//基本接口类型
@property (nonatomic, assign) LNBaseUrlType baseUrlType;
@property (nonatomic, assign) LNRequestMethod requestMethod;

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *urlType;
@property (nonatomic, strong) NSDictionary *httpHeaders;
@property (nonatomic, strong) NSMutableDictionary *parameters;

+ (NSString*)encodeString:(NSString*)unencodedString;
+ (NSString *)decodeString:(NSString*)encodedString;
@end