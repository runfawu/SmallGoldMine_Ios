//
//  SoapRequest.m
//  GoldMine
//
//  Created by Oliver on 14-9-11.
//  Copyright (c) 2014年 us. All rights reserved.
//

#define kWebServicesURL      @"http://202.91.242.228:7003/Service.asmx?"
#define kNamespaceURL        @"http://202.91.242.228:7003/BBIService/"

#import "SoapRequest.h"

@implementation SoapRequest

- (void)dealloc
{
    DLog(@"soap request dealloc");
    [asiRequest clearDelegatesAndCancel];
}

- (void)postRequestWithSoapNamespace:(NSString *)namespace
                              params:(NSMutableDictionary *)params
                        successBlock:(SuccessBlock)successblock
                        failureBlock:(FailureBlock)failureBlock
                          errorBlock:(ErrBlock)errBlock
{
    //FIXME: 无网络判断。。。。
    
    self.successBlock = successblock;
    self.failureBlock = failureBlock;
    self.errBlock = errBlock;
    xmlNamespace = namespace;
    
    NSString *soapParams = @"";
    NSString *soapMessage= @"";
    NSString *soapBody1 = [NSString stringWithFormat:
                           @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                           "<soap:Envelope\n"
                           "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" \n"
                           "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" \n"
                           "xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> \n"
                           "<soap:Body>\n"
                           "<%@ xmlns=\"%@\">\n", namespace, kNamespaceURL];
    
    NSString *soapBody2 = [NSString stringWithFormat:
                           @"</%@>\n"
                           "</soap:Body>\n"
                           "</soap:Envelope>", namespace];
    
    if (![params isEqual:nil]) {
        for (NSString *key in params.allKeys) {
            id value = [params objectForKey:key];
            
            if ([value isKindOfClass:[NSNumber class]]) {
                int valueOfInt = [value intValue];
                soapParams = [soapParams stringByAppendingFormat:@"<%@>%d</%@>\n", key, valueOfInt, key];
            } else {
                soapParams = [soapParams stringByAppendingFormat:@"<%@>%@</%@>\n", key, value, key];
            }
        }
    }
    soapMessage = [soapBody1 stringByAppendingFormat:@"%@%@", soapParams, soapBody2];
    
    DLog(@"soapMessage = %@",soapMessage);
    
    NSString *messageLength = [NSString stringWithFormat:@"%d", (int)soapMessage.length];
    NSURL *url = [NSURL URLWithString:kWebServicesURL];
    
    asiRequest = [ASIHTTPRequest requestWithURL:url];
    asiRequest.delegate = self;
    asiRequest.timeOutSeconds = 15;
    [asiRequest addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [asiRequest addRequestHeader:@"Content-Length" value:messageLength];
    [asiRequest setRequestMethod:@"POST"];
    [asiRequest appendPostData:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [asiRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
    
    [asiRequest startAsynchronous];
}

#pragma mark - ASIHTTPRequestDelegate methods
- (void)requestFinished:(ASIHTTPRequest *)request
{
    __weak typeof(self) weakSelf = self;
    
    xmlParser = [[XMLParser alloc] init];
    [xmlParser parseXMLWithData:request.responseData matchElement:xmlNamespace finishParseBlock:^(NSMutableString *result) {
        [weakSelf dealWithSuceessData:result];
    } errorBlock:^(NSMutableString *errorStr) {
        [weakSelf dealWithErrorData:errorStr];
    }];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"请求失败 = %@", request.error.description);
    if (self.failureBlock) {
        self.failureBlock(request.error.description);
    }
}


- (void)dealWithSuceessData:(id)result
{
    DLog(@"服务器返回json = %@", result);
    NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id jsonResult = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
#ifdef DEBUG
    if (error != nil) {
        DLog(@"json parse error = %@", error);
    }
#endif
    
    if (self.successBlock) {
        self.successBlock(jsonResult);
    }
    
}

- (void)dealWithErrorData:(NSMutableString *)errorStr
{
    DLog(@"服务器返回error = %@", errorStr);
    if (self.errBlock) {
        self.errBlock(errorStr);
    }
}

@end
