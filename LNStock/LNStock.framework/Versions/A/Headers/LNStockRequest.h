//
//  LNRequest.h
//  News
//
//  Created by vvusu on 3/29/16.
//  Copyright © 2016 wallstreetcn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , LNRequestMethod) {
    LNRequestMethodGet = 0, //查
    LNRequestMethodPost,    //改
};

@interface LNStockRequest : NSObject

@property (nonatomic, copy) NSString *url;                      //URL
@property (nonatomic, strong) NSDictionary *headers;            //请求头
@property (nonatomic, strong) NSMutableDictionary *parameters;  //参数
@property (nonatomic, assign) LNRequestMethod requestMethod;    //请求类型

+ (NSString*)encodeString:(NSString*)unencodedString;
+ (NSString *)decodeString:(NSString*)encodedString;

@end