//
//  LNResponse.h
//  News
//
//  Created by vvusu on 3/29/16.
//  Copyright © 2016 wallstreetcn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNStockResponse : NSObject
//返回转换后的Model
@property (nonatomic, strong) id model;
//返回状态码
@property (nonatomic, copy) NSString *code;
//返回状态信息
@property (nonatomic, copy) NSString *message;
//返回数据Data
@property (nonatomic, strong) NSData *data;
//返回结果字典格式
@property (nonatomic, strong) NSDictionary *dataDic;
//返回状态是否成功
@property (nonatomic, assign, getter=isSucceed) BOOL succeed;

@end
