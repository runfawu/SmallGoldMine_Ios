//
//  GiftEntity.h
//  GoldMine
//
//  Created by Oliver on 14-10-12.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftEntity : NSObject
/*IssueCode	兑换码
 Image	兑换图片
 Theme	兑换主题
 Introduce	文字介绍
 NeedIdot	兑换所需积分值
 */
@property (nonatomic, strong) NSString *IssueCode;
@property (nonatomic, strong) NSString *Image;
@property (nonatomic, strong) NSString *Theme;
@property (nonatomic, strong) NSString *Introduce;
@property (nonatomic, strong) NSString *NeedIdot;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
