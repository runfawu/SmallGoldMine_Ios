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
#include <sys/socket.h> // Per msqr
#include <sys/types.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <CommonCrypto/CommonDigest.h>
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


+(BOOL)isExistenceNetwork{
    BOOL result = YES;
    struct sockaddr_in addr;
    bzero(&addr, sizeof(addr));
    addr.sin_family=AF_INET;
    SCNetworkReachabilityRef target=SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&addr);
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityGetFlags(target, &flags);
    if (flags & kSCNetworkFlagsReachable) {
        result = YES;
    }else{
        result = NO;
    }
    if (flags & kSCNetworkReachabilityFlagsIsWWAN) {
        result = YES;
    }else{
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


//+(NSString *)stringEncodeForUTF8:(NSString *)encodeStr {
//    if (encodeStr != nil) {
//        NSString *afterEncodeStr = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
//                                                                                       (CFStringRef)encodeStr,
//                                                                                       NULL,
//                                                                                       (CFStringRef)@"!*'();:@&=+$,/?%#[]",
//                                                                                       kCFStringEncodingUTF8 );
//        return afterEncodeStr;
//    }
//    
//    return encodeStr;
//}


+(NSString*)getAppVersion {
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    return [infoDict objectForKey:@"CFBundleVersion"];
}


+(NSString*)getScreenSize {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    float scale = [UIScreen mainScreen].scale;
    return [NSString stringWithFormat:@"%dx%d",(int)(screenSize.height*scale),(int)(screenSize.width*scale)];
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

    return outstring;
}

+(NSString *)getAppSource{
#ifdef DEBUG
    return @"developer";
#else
    return @"distribution";
#endif
}


+(BOOL)searchResult:(NSString *)contactName searchText:(NSString *)searchT{
    NSComparisonResult result = [contactName compare:searchT options:NSCaseInsensitiveSearch
                                               range:NSMakeRange(0, searchT.length)];
    if (result == NSOrderedSame)
        return YES;
    else
        return NO;
}

+(NSString *)buddyNumberChangeToStringWithNumber:(NSString *)userType{
    if ([userType isEqualToString:@"1"]) {
        return @"店员";
    }else if ([userType isEqualToString:@"2"]){
        return @"店长";
    }else if ([userType isEqualToString:@"3"]){
        return @"店老板";
    }else if ([userType isEqualToString:@"4"]){
        return @"业务员";
    }else if ([userType isEqualToString:@"5"]){
        return @"经销商";
    }else
        return @"品牌商";
}

+(NSAttributedString *)setBuddyNameContectFormat:(NSString *)nameStr{
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc] initWithString:nameStr];
    NSRange prefixStrRange=NSMakeRange(0, [nameStr length]-3);
    NSRange laterStrRange=NSMakeRange([nameStr length]-3,3);
    [str addAttribute:NSForegroundColorAttributeName value:[Utils colorWithHexString:@"202020"] range:prefixStrRange];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25.0] range:prefixStrRange];
    
    [str addAttribute:NSForegroundColorAttributeName value:[Utils colorWithHexString:@"F8BB08"] range:laterStrRange];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:laterStrRange];
    
    return str;
}


//+(NSString*)urlEncode:(NSString *)unencodedString{
//    NSString *afterEncodeStr = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
//                                                                                   (CFStringRef)unencodedString,
//                                                                                   NULL,
//                                                                                   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
//                                                                                   kCFStringEncodingUTF8 );
//    return afterEncodeStr;
//}

@end
