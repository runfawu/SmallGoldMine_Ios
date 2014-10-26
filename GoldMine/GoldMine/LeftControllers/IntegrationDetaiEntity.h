//
//  IntegrationDetaiEntity.h
//  GoldMine
//
//  Created by Oliver on 14-10-7.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntegrationDetaiEntity : NSObject
/*
 GetTime	获得积分时间（*月*日*时*分 ）
 ProImg	产品图片
 ProName	产品名称
 Idot	获得积分值
 */
@property (nonatomic, strong) NSString *GetTime;
@property (nonatomic, strong) NSString *ProImg;
@property (nonatomic, strong) NSString *ProName;
@property (nonatomic, strong) NSString *Idot;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
