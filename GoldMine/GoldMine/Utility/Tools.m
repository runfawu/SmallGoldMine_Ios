//
//  Tools.m
//  IShowProject
//
//  Created by liuxiangtao on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Tools.h"
#import "StorageTools.h"
#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "JSONKit.h"

#include <sys/socket.h> // Per msqr
#include <sys/types.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <CommonCrypto/CommonDigest.h>
#import "W6StoreProduct.h"
#import <AdSupport/AdSupport.h>
#import "OpenUDID.h"
#import "AppDelegate.h"

#define	CTL_UNSPEC	0		/* unused */
#define	CTL_KERN	1		/* "high kernel": proc, limits */
#define	CTL_VM		2		/* virtual memory */
#define	CTL_VFS		3		/* file system, mount type is next */
#define	CTL_NET		4		/* network, see socket.h */
#define	CTL_DEBUG	5		/* debugging parameters */
#define	CTL_HW		6		/* generic cpu/io */
#define	CTL_MACHDEP	7		/* machine dependent */
#define	CTL_USER	8		/* user-level */
#define	CTL_MAXID	9		/* number of valid top-level ids */

#define	AF_ROUTE	17		/* Internal Routing Protocol */
#define	AF_LINK		18		/* Link layer interface */

#define NET_RT_IFLIST		3	/* survey interface list */

@implementation Tools

+ (NSString *)encodeFacialEmoj:(NSString*)aString
{
    NSMutableString * message = [[NSMutableString alloc] initWithString:aString];
    NSDictionary * emojDic = [[NSDictionary alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"emoj" withExtension:@"plist"]];
    NSDictionary * vipEmojDic = [[NSDictionary alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"vipEmoj" withExtension:@"plist"]];
    NSRegularExpression* regex = [[NSRegularExpression alloc]
                                  initWithPattern:@"\\[`(.*?)`\\]"
                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                  error:nil]; //2
    NSArray* chunks = [regex matchesInString:message options:0
                                       range:NSMakeRange(0, [message length])];
    [regex release];
    iShowDebug(@" message ＝ %@ ,chunks = %@",chunks,message);
    if ([chunks count]) {
        NSMutableArray * emojNameArr = [[NSMutableArray alloc] init];//存储内容为：[`傻笑`]; [`呵呵`]; [`哈哈`]
        for (NSTextCheckingResult * result in chunks) {//获取所有表情数组
            NSRange range = [result rangeAtIndex:0];
            NSString * emojString = [message substringWithRange:range];
            if (![emojNameArr containsObject:emojString]) {//表情互斥，我们在替换的时候采用的是全部替换，所以不需要考虑一个表情出现多次的情况；
                [emojNameArr addObject:emojString];
            }
        }
        for (NSString * emojString in emojNameArr) {//将message中所有的如：［`傻笑`］替换为［`x_laugh`］;
            NSArray * emojKeys = [emojDic allKeysForObject:[emojString substringWithRange:NSMakeRange(2, emojString.length-4)]];
            if ([emojKeys count]) {//替换普通表情
                NSString * key = [emojKeys objectAtIndex:0];
                NSString * imageString = [NSString stringWithFormat:@"[`x_%@`]",[key substringWithRange:NSMakeRange(0, key.length-4)]];
                [message replaceOccurrencesOfString:emojString withString:imageString options:NSCaseInsensitiveSearch range:NSMakeRange(0, message.length)];
                iShowDebug(@"emojString = %@ imageString = %@",emojString,imageString);
            }
            else
            {//替换vip表情,将message中所有的如：［`饥饿`］替换为［`v_hungry`］
                NSArray * vipEmojKeys = [vipEmojDic allKeysForObject:[emojString substringWithRange:NSMakeRange(2, emojString.length-4)]];
                if ([vipEmojKeys count]) {
                    NSString * key = [vipEmojKeys objectAtIndex:0];
                    NSString * imageString = [NSString stringWithFormat:@"[`v_%@`]",[key substringWithRange:NSMakeRange(5, key.length-9)]];
                    [message replaceOccurrencesOfString:emojString withString:imageString options:NSCaseInsensitiveSearch range:NSMakeRange(0, message.length)];
                    iShowDebug(@"emojString = %@ imageString = %@",emojString,imageString);
                }
            }
        }
        [emojNameArr release];
    }
    return [message autorelease];
}

+(BOOL)isExistenceNetwork{
    
    BOOL result = YES;
    struct sockaddr_in addr;
    bzero(&addr, sizeof(addr));
    addr.sin_family=AF_INET;
    SCNetworkReachabilityRef target=SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&addr);
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityGetFlags(target, &flags);
    if (flags & kSCNetworkFlagsReachable) {
        iShowDebug(@"network state CONNECT");
        result = YES;
    }else{
        iShowDebug(@"Disconnect");
        result = NO;
    }
    if (flags & kSCNetworkReachabilityFlagsIsWWAN) {
        iShowDebug(@"WWan  connect ");
        result = YES;
    }else{
        iShowDebug(@"DisConnect");
        result = NO;
    }
    
    return  result;
}

+(BOOL)checkCurrentNetwordStatus_protocol{
    
    BOOL result =  [self reachabilityStatus] == NotReachable ? NO : YES;

    return result;
}

+(NetworkStatus)reachabilityStatus{
    AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return appDelegate.netWorkStatus;
//    if ([Reachability reachabilityWithHostName:@"www.baidu.com"] == nil) {
//        return kNotReachable;
//    }else {
//        return [[Reachability reachabilityWithHostName:@"www.baidu.com"]currentReachabilityStatus];
//    }
    
}

+(NSString *)getProtocol:(NSString *)protocol{
    
    NSString *errorDesc = nil;
	NSPropertyListFormat format;
	NSString *plistPath;
	NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
															  NSUserDomainMask, YES) objectAtIndex:0];
    
    plistPath = [rootPath stringByAppendingPathComponent:@"protocol_woxiu.plist"];
    
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"protocol_woxiu" ofType:@"plist"];
	}
    
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
										  propertyListFromData:plistXML
										  mutabilityOption:NSPropertyListMutableContainersAndLeaves
										  format:&format
										  errorDescription:&errorDesc];
	if (!temp) {
	}
	
    NSString *object=[temp objectForKey:protocol];    
    if (object==nil || object.length==0) {  
        object=@"0";  
    } 
    return object; 
}

+(int)lengthWithSpecialString:(NSString *)str {
    
    if (str == nil || [str isEqualToString:@""]) {
        return 0;
    }
    
    int strlength = 0;
    char* p = (char*)[str cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[str lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}

+ (NSString *)md5:(NSString *)str
{
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}
#define LEN 8
+(NSString *) gen_secret:(int)seed
{
    int mod[LEN] = {9888, 9866, 6546, 4354, 6788, 5456, 5675, 3445};
    int i;
    char tmp[20];
    for ( i=0; i < LEN; i++ )  {
        tmp[i] = abs(seed*(i+1)>>i)/mod[i]%94+33; // ascii 33~126
    }
    tmp[i] = '\0';
    char s_seed[12];
    sprintf(s_seed, "%d", seed);
    strcat(tmp, s_seed);
    return [[self class] md5:[NSString stringWithFormat:@"%s",tmp]];
}

+(BOOL)isToken:(NSDictionary *)dic{
    NSString *token=[dic objectForKey:@"token"];
    
    if ([[dic objectForKey:@"hifi"] isKindOfClass:[NSNull class]]) {
        return NO;
    }
    
    int hifi=[[dic objectForKey:@"hifi"]intValue];
    if (token!=nil&&hifi!=0) {
        return YES;
    } else {
        return NO;
    }
}

+(void)showAlert:(NSString *)message{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];
}

/**
 version的格式是x.x.x
 */
+(BOOL)goToUpdateWithVersion:(NSString *)netWorkVersion{

    BOOL  bNeedUpdate = NO;
    
    if ([netWorkVersion length]<5) {
        return bNeedUpdate;
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    
    int netVersion = [[netWorkVersion stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
    int buildVersion = [[build stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
    
    if (netVersion>buildVersion) {
        bNeedUpdate = YES;
    }
    
    return bNeedUpdate;
    
//    if ([netWorkVersion characterAtIndex:0]>[build characterAtIndex:0]) {
//        return YES;
//    }
//    if ([netWorkVersion characterAtIndex:2]>[build characterAtIndex:2]) {
//        return YES;
//    }
//    if ([netWorkVersion characterAtIndex:4]>[build characterAtIndex:4]) {
//        return YES;
//    }
//    
//    return NO;
}

//是否登录
+(BOOL)isLogined
{
    NSString* userHex = [StorageTools valueForUserDefaultWithKey:@"user_hex"];
    return userHex != nil;
}


+(NSString*)appVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleVersion"];
}

/**
 获取礼物的坐标
 */
+(NSMutableArray *)getGiftLocationsWithString:(NSString *)string{
    NSMutableArray *locations;
    
    locations = [NSMutableArray array];
    NSArray *locationPoint = [string componentsSeparatedByString:@" "];
    
    for (NSString *s in locationPoint) {
        NSArray *xAndY = [s componentsSeparatedByString:@","];
        CGPoint point = CGPointMake([[xAndY objectAtIndex:0] floatValue], [[xAndY objectAtIndex:1] floatValue]);
        [locations addObject:[NSValue valueWithCGPoint:point]];
    }
    
    return locations;
}

+(BOOL)isBlueVipWithPhone_vip:(NSString*)phone_vip
{
    if ([phone_vip isKindOfClass:[NSString class]]) {
        if ([phone_vip hasPrefix:@"\""]) {
            phone_vip = [phone_vip stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
        }
        if ([phone_vip hasSuffix:@"\""]) {
            phone_vip = [phone_vip stringByReplacingCharactersInRange:NSMakeRange(phone_vip.length-1, 1) withString:@""];
        }
        NSDictionary * dic = [phone_vip objectFromJSONString];
        if ([dic isKindOfClass:[NSDictionary class]]&&[[dic objectForKey:@"blue"] intValue]) {
            return YES;
        }
    }
    else if ([phone_vip isKindOfClass:[NSDictionary class]])
    {
        NSString * expireDateString = [phone_vip valueForKey:@"blue"];
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate * expireDate = [formatter dateFromString:expireDateString];
        [formatter release];
        if (expireDate != nil &&[expireDate timeIntervalSinceDate:[NSDate date]]>=0) {
            return YES;
        }
        return NO;
    }
    return NO;
}

+(BOOL)isRedVipUser
{
    NSString * phone_vip = [StorageTools valueForUserDefaultWithKey:@"phone_vip"];
    if ([phone_vip isKindOfClass:[NSString class]]) {
        if ([phone_vip hasPrefix:@"\""]) {
            phone_vip = [phone_vip stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
        }
        if ([phone_vip hasSuffix:@"\""]) {
            phone_vip = [phone_vip stringByReplacingCharactersInRange:NSMakeRange(phone_vip.length-1, 1) withString:@""];
        }
        NSDictionary * dic = [phone_vip objectFromJSONString];
        if ([dic isKindOfClass:[NSDictionary class]]&&[[dic objectForKey:@"red"] intValue]) {
            return YES;
        }
    }
    else if ([phone_vip isKindOfClass:[NSDictionary class]])
    {
        NSString * expireDateString = [phone_vip valueForKey:@"red"];
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate * expireDate = [formatter dateFromString:expireDateString];
        [formatter release];
        if (expireDate != nil && [expireDate timeIntervalSinceDate:[NSDate date]]>=0) {
            return YES;
        }
        return NO;
    }
    return NO;
}



+(NSString*)getVipIconWithPhoneVip:(NSString*)phoneVip
{
    if ([phoneVip isKindOfClass:[NSString class]]) {
        if ([phoneVip hasPrefix:@"\""]) {
            phoneVip = [phoneVip stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
        }
        if ([phoneVip hasSuffix:@"\""]) {
            phoneVip = [phoneVip stringByReplacingCharactersInRange:NSMakeRange(phoneVip.length-1, 1) withString:@""];
        }
        NSDictionary * dic = [phoneVip objectFromJSONString];
        int isGreen = 0;
        int isRed = 0;
        int isBlue = 0;
        if ([dic isKindOfClass:[NSDictionary class]]&&[[dic objectForKey:@"green"] respondsToSelector:@selector(intValue)]&&[[dic valueForKey:@"green"] intValue]) {
            isGreen = 1;
        }
        if ([dic isKindOfClass:[NSDictionary class]]&&[[dic objectForKey:@"red"] respondsToSelector:@selector(intValue)]&&[[dic objectForKey:@"red"] intValue]) {
            isRed = 1;
        }
        if ([dic isKindOfClass:[NSDictionary class]]&&[[dic objectForKey:@"blue"] respondsToSelector:@selector(intValue)]&&[[dic objectForKey:@"blue"] intValue]) {
            isBlue = 1;
        }
        if (isGreen&&isRed&&isBlue) {
            return @"main_vip_rgb";
        }
        else if (isGreen&&isRed)
        {
            return @"main_vip_rg";
        }
        else if (isGreen&&isBlue)
        {
            return @"main_vip_gb";//缺失该vip图标
        }
        else if (isRed&&isBlue)
        {
            return @"main_vip_rb";
        }
        else if (isGreen)
        {
            return @"main_vip_g";
        }
        else if (isRed)
        {
            return @"main_vip_r";
        }
        else if (isBlue)
        {
            return @"main_vip_b";
        }
    }
    return nil;
}

+(NSString *)getWealthGradeImage:(NSInteger)grade{

    if (grade < 4) {
        return @"grade_wealth_1.png";
    }else if(grade >= 4 && grade < 7){
        return @"grade_wealth_2.png";
    }else if(grade >= 7 && grade < 10){
        return @"grade_wealth_3.png";
    }
    return [NSString stringWithFormat:@"grade_wealth_%d.png",grade];
}

+(NSInteger)getWealthGradeNumber:(NSInteger)grade{
    if (grade < 4) {
        return grade;
    }else if(grade >= 4 && grade < 7){
        return grade - 3;
    }else if(grade >= 7 && grade < 10){
        return grade - 6;
    }
    return -1;
}

+(NSString *)getAnchorGradeImage:(NSInteger)grade{
    if (grade < 6 ) {
        return @"grade_anchor_1.png";
    }else if(grade >= 6 && grade < 11){
        return @"grade_anchor_2.png";
    }else if(grade >=11 && grade < 16){
        return @"grade_anchor_3.png";
    }else if(grade >=16 && grade < 25){
        return @"grade_anchor_4.png";
    }else if(grade >= 25 && grade <35){
        return @"grade_anchor_5.png";
    }else if(grade >= 35){
        return @"grade_anchor_6.png";
    }
    return @"";
}

+(NSInteger)getAnchorGradeNumber:(NSInteger)grade{
    NSInteger i = 1;
    
    if (grade <= 15) {
        return grade%5 != 0 ? grade%5 : 5;
    }
    else{
        return grade - 15;
    }
    
    return  i;
}

//计算等级
+(NSDictionary*)calGrade:(int)grade{
    //NSDictionary *result=[[[NSDictionary alloc]init]autorelease];
    iShowDebug(@"grade = %d",grade);
    NSString *pic;//图片名字
    int gradeNum;//图片旁的等级数字
    UIColor *color;//等级数字的颜色
    if (grade>=0&&grade<6) {
        //红心
        pic= [NSString stringWithFormat:@"grade_anchor_%d", 1];
//        gradeNum=grade%6;
        color=[UIColor colorWithRed:0.8196 green:0.012 blue:0.071 alpha:1];
    }else if (grade>5&&grade<11){
        //蓝钻
        pic= [NSString stringWithFormat:@"grade_anchor_%d", 2];
//        gradeNum=(grade+1)%6;
        color=[UIColor colorWithRed:0.075 green:0.749 blue:0.925 alpha:1];
    }else if (grade>10&&grade<16){
        //黄钻
        pic= [NSString stringWithFormat:@"grade_anchor_%d", 3];
//        gradeNum=(grade+2)%6;
        color=[UIColor colorWithRed:0.867 green:0.435 blue:0.090 alpha:1];
    }else if (grade>15&&grade<25){
        //皇冠
        pic= [NSString stringWithFormat:@"grade_anchor_%d", 4];
//        gradeNum=(grade+5)%10;
        color=[UIColor colorWithRed:0.843 green:0.239 blue:0.675 alpha:1];
    }else if (grade>24&&grade<35){
        //金冠
        pic= [NSString stringWithFormat:@"grade_anchor_%d", 5];
//        gradeNum=9+(grade+9)%11;
        color=[UIColor colorWithRed:0.992 green:0.624 blue:0.114 alpha:1];
    }else{
        //红金冠
        pic= [NSString stringWithFormat:@"grade_anchor_%d", 6];
//        gradeNum=grade-34;
        color=[UIColor colorWithRed:0.949 green:0.114 blue:0.004 alpha:1];
    }
    
    gradeNum = (int)[self getAnchorGradeNumber:grade];
    
    
    NSDictionary * result=[NSDictionary dictionaryWithObjectsAndKeys:(id)pic,@"pic",[NSNumber numberWithInt:gradeNum],@"gradeNum",color,@"color", nil];
    return result;
    
}

+(UIColor *)getAnchorColor:(NSInteger)grade{
    if (grade < 6 ) {
       return  [UIColor colorWithRed:0.8196 green:0.0117 blue:0.0705 alpha:1];
    }else if(grade >= 6 && grade < 11){
       return [UIColor colorWithRed:0.0745 green:0.7490 blue:0.9254 alpha:1];
    }else if(grade >=11 && grade < 16){
       return [UIColor colorWithRed:0.8431 green:0.2392 blue:0.6745 alpha:1];
    }else if(grade >=16 && grade < 25){
       return [UIColor colorWithRed:0.9921 green:0.6235 blue:0.0039 alpha:1];
    }else if(grade >= 25 && grade <35){
       return [UIColor colorWithRed:0.8667 green:0.4353 blue:0.0901 alpha:1];
    }else if(grade >= 35){
       return [UIColor colorWithRed:0.9490 green:0.1137 blue:0.0039 alpha:1];
    }
    return [UIColor whiteColor];
}

+(NSString *)stringEncodeForUTF8:(NSString *)encodeStr {
    if (encodeStr != nil) {
        NSString *afterEncodeStr = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                       (CFStringRef)encodeStr,
                                                                                       NULL,
                                                                                       (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                       kCFStringEncodingUTF8 );
        return [afterEncodeStr autorelease];
    }
    
    return encodeStr;
}

+ (void)evaluateApp
{
    iShowDebug(@"应用程序打分");
    NSString* app_id = [StorageTools valueForUserDefaultWithKey:@"app_id"];
    NSString *url = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", app_id];
    //itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=431582558
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+(NSString *)getDevicetoken:(NSString *)deviceToken{
    /**去掉'<>' ' '*/
    NSString *string;
    
    string = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    string = [string stringByReplacingOccurrencesOfString:@"<" withString:@""];
    
    string = [string stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    return string;
}

+(UIFont*)fontWithHeitiMediumSize:(float)size {
    return [UIFont fontWithName:@"STHeitiJ-Medium" size:size];
}

+(UIFont*)fontWithHeitiLightSize:(float)size {
    return [UIFont fontWithName:@"STHeitiJ-Light" size:size];
}

//============

#pragma mark -
#pragma mark - ClientInfo

+(void)generateClientInfo
{
    NSString *client_info = [NSString stringWithFormat:@"{\"model\":\"%@\",\"os\":\"%@\",\"screen\":\"%@\",\"from\":%@,\"version\":\"%@\",\"uniqid\":\"%@\",\"product\":\"%@\",\"mac\":\"%@\",\"net_type\":\"%@\",\"os_info\":\"%@\",\"op\":\"%@\",\"IDFV\":\"%@\",\"IDFA\":\"%@\",\"OpenUDID\":\"%@\",\"isJailBroken\":\"%d\"}", [self getDeviceModel], [self getDeviceOS], [self getScreenSize], [self getFrom], [self getAppVersion], [self macaddress], [self getProduct], [self macaddress], [self getNetType], [self getOSInfo], [self getOP],[self getIDFV],[self getIDFA],[OpenUDID value],[self isJailBroken]];
    [[NSUserDefaults standardUserDefaults] setObject:client_info forKey:@"client_info"];
    
}

+(NSString*)getClientInfo {    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"client_info"]==nil) {
        [self generateClientInfo];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"client_info"];
}

+(NSString*)getClientProInfo {
    //NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *client_info = [NSString stringWithFormat:@"{\"model\":\"%@\",\"os\":\"%@\",\"screen\":\"%@\",\"from\":%@,\"version\":\"%@\",\"uniqid\":\"%@\",\"product\":\"%@\",\"mac\":\"%@\",\"net_type\":\"%@\",\"os_info\":\"%@\",\"op\":\"%@\"}", [self getDeviceModel], [self getDeviceOS], [self getScreenSize], [self getFrom], [self getAppVersion], [self macaddress], [self getProductPro], [self macaddress], [self getNetType], [self getOSInfo], [self getOP]];
    //iShowDebug(@"client_info:%@",client_info);
    return client_info;
}


+(NSString*)getAppVersion {
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    return [infoDict objectForKey:@"CFBundleVersion"];
}

+(NSString*)getDeviceModel {
    return [[UIDevice currentDevice] model];
}

+(NSString*)getDeviceOS {
    return @"ios";
}

+(NSString*)getScreenSize {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    float scale = [UIScreen mainScreen].scale;
    return [NSString stringWithFormat:@"%dx%d",(int)(screenSize.height*scale),(int)(screenSize.width*scale)];
}

+(NSString*)getFrom {
    return @"2000505";
}

+(NSString*)getProduct {
    return @"woxiu_phone";
}

+(NSString*)getProductPro {
    return @"woxiuPro_phone";
}


+(NSString*)getOSInfo {
    return [NSString stringWithFormat:@"%@%@", [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]];
}

+(NSString*)getNetType {
    
    AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (ReachableViaWiFi == appDelegate.netWorkStatus) {
        return @"wifi";
    }
    return @"cellular";
}


+(NSString*)getOP {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
    [networkInfo release];
    NSString *mobileCountryCode = carrier.mobileCountryCode;
    NSString *mobileNetworkCode = carrier.mobileNetworkCode;
//    if ([StringUtil isStringNil:mobileCountryCode] || [StringUtil isStringNil:mobileNetworkCode]) return @"op";
    if (mobileCountryCode==nil||mobileNetworkCode==nil) {
        return @"op";
    }
    return [NSString stringWithFormat:@"%@%@", mobileCountryCode, mobileNetworkCode];
}

+ (NSString *)macaddress{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    iShowDebug(@"outString = %@",outstring);
    return outstring;
}

+(NSString *)getAppSource{
#ifdef DEBUG
    return @"developer";
#else
    return @"distribution";
#endif
}

+(NSArray *)getProductArrayList:(NSArray *)set withArray:(NSArray *)array{
    NSMutableArray *arrayList = [NSMutableArray array];
    
    for (NSString *string in set) {
        iShowDebug(@"%@",string);
        for (W6StoreProduct *product in array) {
            if ([string isEqualToString:product.productIdentifier]) {
                [arrayList addObject:product];
                break;
            }
        }
    }
    return arrayList;
    
}

+(NSString *)getMoneyString:(NSString *)string{
    if ([[string substringToIndex:2]isEqualToString:@"CN"]) {
        return [string substringFromIndex:2];
    }
    return string;
}

+(NSString*)urlEncode:(NSString *)unencodedString{
    NSString *afterEncodeStr = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                   (CFStringRef)unencodedString,
                                                                                   NULL,
                                                                                   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                   kCFStringEncodingUTF8 );
    
    return afterEncodeStr;
}

+(NSString*)getADsig:(int)ad_type appType:(NSString*)app_type type:(NSString*)type{
    
    int timestamp=[[NSDate date]timeIntervalSince1970];
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:timestamp],@"timestamp",type,@"type", [NSNumber numberWithInt:ad_type],@"ad_type",app_type,@"app_type",nil];
    NSMutableString* sig=[NSMutableString stringWithFormat:@"%d%@%d%@",ad_type,app_type,timestamp,type];
    [sig appendString:@"%^&DFgerGF&"];
    NSString* signature=[Tools md5:sig];
    [dic addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:signature,@"signature", nil]];
    NSString *result=[dic JSONString];
    result=[Tools urlEncode:result];
    return result;
}

+(NSString*)getADDatasig:(int)ADID appType:(NSString*)app_type type:(NSString*)type{
    
    int timestamp=[[NSDate date]timeIntervalSince1970];
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:timestamp],@"timestamp",type,@"type", [NSNumber numberWithInt:ADID],@"id",app_type,@"app_type",nil];
    NSMutableString* sig=[NSMutableString stringWithFormat:@"%@%d%d%@",app_type,ADID,timestamp,type];
    [sig appendString:@"%^&DFgerGF&"];
    NSString* signature=[Tools md5:sig];
    [dic addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:signature,@"signature", nil]];
    NSString *result=[dic JSONString];
    result=[Tools urlEncode:result];
    return result;
}



static NSString *achiverFilePath = @"AnchorSnsCount.plist";
static NSString *kSaveKeyMarkerLines = @"AnchorSnsCount";

+ (NSMutableDictionary *)loadSnsCountDictionary {
    
    NSString *userName = [StorageTools valueForUserDefaultWithKey:@"username"];
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
															  NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *plistPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", userName, achiverFilePath]];
    
	
    NSMutableDictionary *markers = nil;
    if (plistPath == nil || [plistPath length] == 0 ||
        [[NSFileManager defaultManager] fileExistsAtPath:plistPath] == NO) {
        markers = [NSMutableDictionary dictionary];
    } else {
        NSData *data = [[NSData alloc] initWithContentsOfFile:plistPath];
        NSKeyedUnarchiver *vdUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        markers = [vdUnarchiver decodeObjectForKey:kSaveKeyMarkerLines];
        [vdUnarchiver finishDecoding];
        [vdUnarchiver release];
        [data release];
    }
    return markers;
    
}


+(void)saveSnsCountDictionary:(NSMutableDictionary*)dic {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
															  NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *userName = [StorageTools valueForUserDefaultWithKey:@"username"];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", userName, achiverFilePath]];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dic forKey:kSaveKeyMarkerLines];
    [archiver finishEncoding];
    [data writeToFile:plistPath atomically:YES];
    [data release];
    [archiver release];
}

+ (BOOL)CollectTheNotExistPhotoWithName:(NSString * )name
{
    NSString * collectFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"notExistFaceFile.xml"];
    iShowDebug(@"collectFilePath = %@",collectFilePath);
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:ss"];
    NSString * dateString = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    if (![[NSFileManager defaultManager] fileExistsAtPath:collectFilePath]) {
        [[[name stringByAppendingString:[NSString stringWithFormat:@"%@\n",dateString]] dataUsingEncoding:NSUTF8StringEncoding] writeToFile:collectFilePath atomically:YES];
    }
    else
    {
        NSFileHandle * fileHandle = [NSFileHandle fileHandleForWritingAtPath:collectFilePath];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[[name stringByAppendingString:[NSString stringWithFormat:@"%@\n",dateString]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return YES;
}



+ (BOOL)isJailBroken
{
    static const char * __jb_apps[] =
    {
        "/Application/Cydia.app",
        "/Application/limera1n.app",
        "/Application/greenpois0n.app",
        "/Application/blackra1n.app",
        "/Application/blacksn0w.app",
        "/Application/redsn0w.app",
        NULL
    };
    
    
    // method 1
    for ( int i = 0; __jb_apps[i]; ++i )
    {
        if ( [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:__jb_apps[i]]] )
        {
            return YES;
        }
    }
    
    // method 2
    if ( [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] )
    {
        return YES;
    }
    
    // method 3
    if ( 0 == system("ls") )
    {
        return YES;
    }
    
    return NO;
}

//+(NSString *)getUDID
//{
//    NSString *udid = [[UIDevice currentDevice] uniqueIdentifier];
//    return udid;
//}

+ (NSString*)getIDFV
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSLog(@"idfv = %@",idfv);
        return idfv;
    }
    return nil;
    
}

+(NSString*)getIDFA
{
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSLog(@"adId = %@",adId);
    return adId;
}



+(NSString*)devicePlatform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    return platform;
}


+(NSString *)trimNULL:(NSObject*)obj
{
    if (obj && ![obj isKindOfClass:[NSNull class]]) {
        return [obj description];
    }
    return @"";
}

#define KEYBOARD_TAG 1234567

+(UIView*)getGlobalKeyBoardView
{
    NSArray *windowsArray = [UIApplication sharedApplication].windows;
    for (UIView *tmpWindow in windowsArray) {
        if (tmpWindow.tag == KEYBOARD_TAG) {
            return tmpWindow;
        }
        NSArray *viewArray = [tmpWindow subviews];
        for (UIView *tmpView  in viewArray) {
            if ([[NSString stringWithUTF8String:object_getClassName(tmpView)] isEqualToString:@"UIPeripheralHostView"]) {
                iShowDebug(@"tmpView = %@",tmpView);
                tmpWindow.tag = KEYBOARD_TAG;
                return tmpWindow;
            }
        }
    }
    return nil;
}
@end
