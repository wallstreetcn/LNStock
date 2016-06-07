//
//  TriangleMarkView.m
//  Quote
//
//  Created by ZhangBob on 4/19/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "TriangleMarkView.h"

@implementation TriangleMarkView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.triangleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 7.5, 4)];
        self.triangleView.image = [UIImage imageNamed:@"quote_triangle"];
        [self addSubview:self.triangleView];
    }
    return self;
}

@end
