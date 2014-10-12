//
//  InputBarcodeController.h
//  GoldMine
//
//  Created by Dongfuming on 14-9-20.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "SuperViewController.h"

typedef NS_ENUM(NSInteger, QueryBarCodeType) {
    QueryBarCodeIntegrationType = 110,
    QueryBarCodeGoodType,
};

typedef void (^JumpToScanBlock)();


@interface InputBarcodeController : SuperViewController

@property (nonatomic, copy) JumpToScanBlock jumpToScanBlock;
@property (nonatomic, assign) QueryBarCodeType queryType;
@property (nonatomic, strong) NSString *barString;

@end
