//
//  RankEntity.h
//  GoldMine
//
//  Created by Oliver on 14-10-25.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankEntity : NSObject
/*UserID	小伙伴ID
 UserName	小伙伴名称
 Picture	小伙伴头像
 Vboon	小伙伴拥有的V宝值
 Order	小伙伴V宝值排名情况
*/
@property (nonatomic, strong) NSString *UserID;
@property (nonatomic, strong) NSString *UserName;
@property (nonatomic, strong) NSString *Picture;
@property (nonatomic, strong) NSString *Vboon;
@property (nonatomic, strong) NSString *Order;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
