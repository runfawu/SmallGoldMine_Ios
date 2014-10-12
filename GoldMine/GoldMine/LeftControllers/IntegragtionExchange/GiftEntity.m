//
//  GiftEntity.m
//  GoldMine
//
//  Created by Oliver on 14-10-12.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "GiftEntity.h"

@implementation GiftEntity

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.IssueCode = dict[@"IssueCode"];
        self.Image = dict[@"Image"];
        self.Theme = dict[@"Theme"];
        self.Introduce = dict[@"Introduce"];
        self.NeedIdot = dict[@"NeedIdot"];
    }
    
    return self;
}

@end
