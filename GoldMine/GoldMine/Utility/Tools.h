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

/**从列表中读取协议的名称，方便管理*/
+(NSString *)getProtocol:(NSString *)protocol;

+ (NSString *)md5:(NSString *)str;


+(NSString *) gen_secret:(int)seed;

//版本大小的比较
+(BOOL)goToUpdateWithVersion:(NSString *)netWorkVersion;

//是否登录
+(BOOL)isLogined;

+(NSString*)appVersion;

//根据vip json字符串判断是否是蓝钻vip；vip json如："{\"green\":\"2014-02-1\",\"red\":\"2014-02-1\",\"blue\":\"2014-02-1\"}";
+(BOOL)isBlueVipWithPhone_vip:(NSString*)phone_vip;

//
+(BOOL)isRedVipUser;

//根据vip json字符串获取vip图标的icon名字；vip json如："{\"green\":\"0\",\"red\":\"0\",\"blue\":\"0\"}";
+(NSString*)getVipIconWithPhoneVip:(NSString*)phoneVip;

+(NSMutableArray *)getGiftLocationsWithString:(NSString *)string;

+(NSString *)getWealthGradeImage:(NSInteger)grade;
+(NSInteger)getWealthGradeNumber:(NSInteger)grade;

+(NSString *)getAnchorGradeImage:(NSInteger)grade;
+(NSInteger)getAnchorGradeNumber:(NSInteger)grade;
+(UIColor *)getAnchorColor:(NSInteger)grade;

+(UIFont*)fontWithHeitiMediumSize:(float)size;
+(UIFont*)fontWithHeitiLightSize:(float)size;

+(int)lengthWithSpecialString:(NSString*)str;

/**字符串的unicode*/
+(NSString *)stringEncodeForUTF8:(NSString *)encodeStr;
//判断token是否为空
+(BOOL)isToken:(NSDictionary *)dic;
//弹出提示框
+(void)showAlert:(NSString *)message;
//计算等级
+(NSDictionary*)calGrade:(int)grade;

//应用程序打分
+(void)evaluateApp;
+(void)generateClientInfo;

+(NSString*)getClientInfo;

/**修改一下devicetoken格式*/
+(NSString *)getDevicetoken:(NSString *)deviceToken;

//+(NSString*)getClientInfo;
+(BOOL)isExistenceNetwork;

+ (NSString *)macaddress;

+(NSString *)getAppSource;

+(NSString*)urlEncode:(NSString *)unencodedString;

+(NSArray *)getProductArrayList:(NSArray *)set withArray:(NSArray *)array;

+(NSString *)getMoneyString:(NSString *)string;


+(NSString*)getADsig:(int)ad_type appType:(NSString*)app_type type:(NSString*)type;

+(NSString*)getADDatasig:(int)ADID appType:(NSString*)app_type type:(NSString*)type;

+ (NSMutableDictionary *)loadSnsCountDictionary;

+(void)saveSnsCountDictionary:(NSMutableDictionary*)dic;


+(NSString*)getClientProInfo;

//是否越狱
+ (BOOL)isJailBroken;


+ (BOOL)CollectTheNotExistPhotoWithName:(NSString * )name;
+(NSString*)devicePlatform;
+ (NSString *)encodeFacialEmoj:(NSString*)message;
+(NSString *)trimNULL:(NSObject*)obj;

+(UIView*)getGlobalKeyBoardView;
@end
