//
//  XMLParser.h
//  GoldMine
//
//  Created by Oliver on 14-9-11.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^FinishBlock)(NSMutableString *result);
typedef void (^ErrorBlock) (NSMutableString *errorStr);

@interface XMLParser : NSObject<NSXMLParserDelegate>
{
    NSXMLParser *xmlParser;
    BOOL elementFound;
    BOOL isNormal;
    NSMutableString *parseResult;
    NSMutableString *errorString;
    NSString *matchElement;
}

@property (nonatomic, copy) FinishBlock finishBlock;
@property (nonatomic, copy) ErrorBlock errorBlock;

- (void)parseXMLWithData:(NSData *)data
                matchElement:(NSString *)element
            finishParseBlock:(FinishBlock)finishblock
                  errorBlock:(ErrorBlock)errBlock;
@end
