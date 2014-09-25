//
//  Tools.h
//  IShowProject
//
//  Created by liuxiangtao on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <CommonCrypto/CommonDigest.h>

@interface Tools : NSObject

/**是否连接到网络*/
+(BOOL)checkCurrentNetwordStatus_protocol;

/**当前的网络状态1无网络 2wifi 3 2g/3g*/
+(NetworkStatus)reachabilityStatus;

+ (NSString *)md5:(NSString *)str;

+(NSString *) gen_secret:(int)seed;

//版本大小的比较
+(BOOL)goToUpdateWithVersion:(NSString *)netWorkVersion;

//是否登录
+(BOOL)isLogined;

+(NSString*)appVersion;

/**字符串的unicode*/
+(NSString *)stringEncodeForUTF8:(NSString *)encodeStr;

+ (NSString *)macaddress;

+(NSString *)getAppSource;

+(NSString*)urlEncode:(NSString *)unencodedString;

+(NSString*)getAppVersion;


@end
