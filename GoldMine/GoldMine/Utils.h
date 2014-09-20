//
//  Utils.h
//  GoldMine
//
//  Created by Dongfuming on 14-9-20.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (UIColor *)colorWithHexString: (NSString *)color;
+ (BOOL)isValidMobile:(NSString *)mobile;
+ (BOOL)isValidNumber:(NSString *)number;

@end
