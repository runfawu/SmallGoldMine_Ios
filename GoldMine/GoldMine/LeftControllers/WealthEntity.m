//
//  WealthEntity.m
//  GoldMine
//
//  Created by Oliver on 14-10-7.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "WealthEntity.h"

@implementation WealthEntity

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.BardID = dict[@"BardID"];
        self.BardName = dict[@"BardName"];
        self.BardImg = dict[@"BardImg"];
        self.IdotCount = dict[@"IdotCount"];
        self.IdotTrue = dict[@"IdotTrue"];
        self.Idot = dict[@"Idot"];
    }
    
    return self;
}

@end
