//
//  BrandAssets.h
//  GoldMine
//
//  Created by micheal on 14-10-6.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrandAssets : NSObject

@property(nonatomic,strong)  UIImage  *thumnail;
@property(nonatomic,strong)  NSURL	  *imageURL; //图片url
@property (nonatomic,strong) NSString *brandName; //产品名称
@property (nonatomic,strong) NSString *brandType; //产品类别
@property(nonatomic) Boolean selected; //是否选中

@end
