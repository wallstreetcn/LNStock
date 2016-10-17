//
//  PriceCellModel.h
//  Market
//
//  Created by ZhangBob on 4/25/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface PriceCellModel :  NSObject <NSCoding>

@property (nonatomic,strong) NSString *cid;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *createdAt;

- (id)initWithDic:(NSDictionary *)dic;

@end
