//
//  XMLParser.m
//  GoldMine
//
//  Created by Oliver on 14-9-11.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "XMLParser.h"

@implementation XMLParser

- (void)dealloc
{
    xmlParser.delegate=nil;
    DLog(@"xml parser dealloc");
}

- (void)parseXMLWithData:(NSData *)data
                matchElement:(NSString *)element
            finishParseBlock:(FinishBlock)finishblock
                  errorBlock:(ErrorBlock)errBlock
{
    matchElement = [NSString stringWithFormat:@"%@Result", element];
    self.finishBlock = finishblock;
    self.errorBlock = errBlock;
    
    xmlParser = [[NSXMLParser alloc] initWithData:data];
    xmlParser.delegate = self;
    [xmlParser parse];
    
}

#pragma mark - XML Parser Delegate Methods
- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:matchElement]) {
        if (!parseResult) {
            parseResult = [[NSMutableString alloc] init];
        }
        elementFound = YES;
        isNormal = YES;
    }
    
    if ([elementName isEqualToString:@"faultstring"]) {
        if (!errorString) {
            errorString = [[NSMutableString alloc] init];
        }
        elementFound = YES;
        isNormal = NO;
    }
}

- (void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
    if (elementFound && isNormal) {
        [parseResult appendString: string];
    }
    
    if (elementFound && !isNormal) {
        [errorString appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:matchElement]) {
        elementFound = NO;
        DLog(@"这里进几次啊");
        [xmlParser abortParsing];
        if (self.finishBlock) {
            self.finishBlock(parseResult == nil ? nil : parseResult);
        }
    }
    
    if ([elementName isEqualToString:@"faultstring"]) {
        elementFound = NO;
        [xmlParser abortParsing];
        
        if (self.errorBlock) {
            self.errorBlock(errorString == nil ? nil : errorString);
        }
        
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (parseResult) {
        parseResult = nil;
    }
}

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if (parseResult) {
        parseResult = nil;
    }
}


@end
