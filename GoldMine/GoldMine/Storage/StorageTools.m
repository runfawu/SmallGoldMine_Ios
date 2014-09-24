//
//  StorageTools.m
//  IShowProject
//
//  Created by liuxiangtao on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StorageTools.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"
#import "SDWebImageManager.h"

@implementation StorageTools


+(void)saveUserDefaultWithKeyValue:(NSString *)key Value:(id)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (value == nil) {
//       [defaults setObject:[NSNull null] forKey:key];
    }else{
        [defaults setObject:value forKey:key];
    }
    
    [defaults synchronize];
}

+(id)valueForUserDefaultWithKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:key];
}


+(void)cleanCurrentUserInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"userid"];
    [defaults removeObjectForKey:@"nickname"];
    [defaults removeObjectForKey:@"ufaceurl"];
    [defaults removeObjectForKey:@"photo"];
    [defaults removeObjectForKey:@"dou"];
    //[defaults removeObjectForKey:@"username"];//保存此值是为了显示上一次登录的用户名，简化用户输入
    [defaults removeObjectForKey:@"user_hex"];
    [defaults removeObjectForKey:@"login_type"];
    [defaults removeObjectForKey:@"sina"];
    [defaults removeObjectForKey:@"qzone"];
    [defaults removeObjectForKey:@"qqweibo"];
    [defaults removeObjectForKey:@"renren"];
    [defaults removeObjectForKey:@"access_Token"];
    [defaults removeObjectForKey:@"refresh_token"];
    [defaults removeObjectForKey:@"oauth_consumer_key"];
    [defaults removeObjectForKey:@"token"];
    [defaults removeObjectForKey:@"bHasBindToken"];
    [defaults removeObjectForKey:@"phone_vip"];

    //清除图片缓存
    [[SDImageCache sharedImageCache]clearDisk];
    [[SDImageCache sharedImageCache]cleanDisk];
    [[SDImageCache sharedImageCache]clearMemory];
    
    //删除第三方授权时的cookie
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage=[NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_User_Logout object:nil];
    [defaults synchronize];
}

+(void)saveRechargeDictionary:(NSDictionary *)dicRecharge{
    NSMutableDictionary *dica = [self valueForUserDefaultWithKey:@"recharge"];
    if (dica == nil) {
        dica = [NSMutableDictionary dictionary];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dica];
    [dic setObject:dicRecharge forKey:[dicRecharge valueForKey:@"orderid"]];
    [self saveUserDefaultWithKeyValue:@"recharge" Value:dic];
}

+(void)deleteRechargeDictionary:(NSString *)oderid{
    NSMutableDictionary *dica = [self valueForUserDefaultWithKey:@"recharge"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dica];
    if (dic != nil) {
        [dic removeObjectForKey:[NSString stringWithFormat:@"%@",oderid]];
    }else{
        dic = [NSMutableDictionary dictionary];
    }
    [self saveUserDefaultWithKeyValue:@"recharge" Value:dic];
}

+(void)deleteUserDefaultWithKeyValue:(NSString *)key{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    if (key!=nil) {
        [userDefaults removeObjectForKey:key];
    }else{
        return;
    }
    [userDefaults synchronize];

}


@end
