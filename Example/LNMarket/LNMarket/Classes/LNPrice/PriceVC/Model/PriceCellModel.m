//
//  PriceCellModel.m
//  Market
//
//  Created by ZhangBob on 4/25/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "PriceCellModel.h"

NSString *const KNews_Cid= @"cid";
NSString *const KNews_Title= @"title";
NSString *const KNews_CreatedAt = @"createdAt";

@implementation PriceCellModel

- (id)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        self.title = [dic objectForKey:KNews_Title];
        self.createdAt = [dic objectForKey:KNews_CreatedAt];
        self.cid = [dic objectForKey:KNews_Cid];
    }
    return self;
}

//序列化
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        if (aDecoder == nil) {
            return self;
        }
        self.title = [aDecoder decodeObjectForKey:KNews_Title];
        self.createdAt = [aDecoder decodeObjectForKey:KNews_CreatedAt];
        self.cid = [aDecoder decodeObjectForKey:KNews_Cid];
    }
    return self;
}

//反序列化
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:KNews_Title];
    [aCoder encodeObject:self.createdAt forKey:KNews_CreatedAt];
    [aCoder encodeObject:self.cid forKey:KNews_Cid];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{KNews_Cid:@"id",
             KNews_Title:@"title",
             KNews_CreatedAt:@"createdAt"
             };
}

@end
