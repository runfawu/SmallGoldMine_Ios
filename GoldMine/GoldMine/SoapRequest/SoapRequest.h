//
//  SoapRequest.h
//  GoldMine
//
//  Created by Oliver on 14-9-11.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLParser.h"
#import "ASIHTTPRequest.h"

typedef void (^SuccessBlock)(id result);
typedef void (^FailureBlock)(NSString *requestError);
typedef void (^ErrBlock)(NSMutableString *serviceError);

@interface SoapRequest : NSObject
{
    NSString *xmlNamespace;
    XMLParser *xmlParser;
    ASIHTTPRequest *asiRequest;
}

@property (nonatomic, copy) SuccessBlock successBlock;
@property (nonatomic, copy) FailureBlock failureBlock;
@property (nonatomic, copy) ErrBlock errBlock;

- (void)postRequestWithSoapNamespace:(NSString *)namespace
                              params:(NSMutableDictionary *)params
                        successBlock:(SuccessBlock)successblock
                        failureBlock:(FailureBlock)failureBlock
                          errorBlock:(ErrorBlock)errBlock;

@end
