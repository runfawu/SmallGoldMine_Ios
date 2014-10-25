//
//  RankEntity.m
//  GoldMine
//
//  Created by Oliver on 14-10-25.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "RankEntity.h"

@implementation RankEntity
/*UserID	小伙伴ID
 UserName	小伙伴名称
 Picture	小伙伴头像
 Vboon	小伙伴拥有的V宝值
 Order	小伙伴V宝值排名情况
 */
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.UserID = dict[@"UserID"];
        self.UserName = dict[@"UserName"];
        self.Picture = dict[@"Picture"];
        self.Vboon = dict[@"Vboon"];
        self.Order = dict[@"Order"];
    }
    
    return self;
}

@end
