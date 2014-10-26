//
//  WealthEntity.h
//  GoldMine
//
//  Created by Oliver on 14-10-7.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WealthEntity : NSObject

/*
 BardID	品牌ID
 BardName	品牌名称
 BardImg	品牌LOGO
 IdotCount	累计积分值
 IdotTrue	可用积分值
 Idot	单日下获得积分值累计
 如果返回值是{"BrandInvdot":""}，表示没有品牌积分信息
 */

@property (nonatomic, strong) NSString *BardID;
@property (nonatomic, strong) NSString *BardImg;
@property (nonatomic, strong) NSString *BardName;
@property (nonatomic, strong) NSString *Idot;
@property (nonatomic, strong) NSString *IdotCount;
@property (nonatomic, strong) NSString *IdotTrue;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
