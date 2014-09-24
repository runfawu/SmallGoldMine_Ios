//
//  StorageTools.h
//  IShowProject
//
//  Created by liuxiangtao on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StorageTools : NSObject
/**
 存储局部变量得集合
 
 1.fristStart 第一次启动记录得变量
 2.isLogined  是否已经登陆得变量
 3.checkLiveStudioCategory 检测是否已直播大厅列表的更新
 4.checkCityCategory 检测到是否有城市列表的更新
 
 5.checkGiftCategory 检测到是否有礼物列表的更新
 
 
 6.protocol_channel_gategory 直播大厅列表
 7.last_city 上次所选城市
 8.isUpdateGategoryList 是否更新直播大厅列表
 9.isUpdateCityList 是否更新城市列表
 
 10.userid 用户的id
 11.nickname 用户的昵称
 12.username 用户名
 dou 56豆
 13.psw 密码
 14.ufaceurl 用户的icon
 15.user_hex 用户的key
 
 16.login_type 用户登录的类型（sina,qzone,qqweibo,56,renren）
 17.sina_access_token 新浪微博授权返回的参数
 18.qzone_access_token qq空间的授权返回参数
 19.qzone_openid qq空间分享所需的
 
 20.checkGiftPattern 检测是否有图案的更新 该数据须依次递增
 
 21.qzone qzone账户是否登陆 login:已登录
 22.qqweibo 账户是否登陆 login:已登录
 23.sina 账户是否登陆 login:已登录
 
 24.deviceToken 硬件信息
 25.photo 侧边栏头像地址
 26.fristToPlayer 第一次进入播放器
 
 27.isactived 是否激活
 28.recharge 判断是否有充值未返回结果的数据
 */


+(void)saveUserDefaultWithKeyValue:(NSString *)key Value:(id)value;
+(id)valueForUserDefaultWithKey:(NSString *)key;
+(void)cleanCurrentUserInfo;
+(void)saveRechargeDictionary:(NSDictionary *)dicRecharge;
+(void)deleteRechargeDictionary:(NSString *)oderid;
+(void)deleteUserDefaultWithKeyValue:(NSString *)key;
@end
