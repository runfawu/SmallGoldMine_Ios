//
//  IntegrationDetaiEntity.m
//  GoldMine
//
//  Created by Oliver on 14-10-7.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "IntegrationDetaiEntity.h"

@implementation IntegrationDetaiEntity

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.GetTime = dict[@"GetTime"];
        self.ProImg = dict[@"ProImg"];
        self.ProName = dict[@"ProName"];
        self.Idot = dict[@"Idot"];
    }
    
    return self;
}

@end
