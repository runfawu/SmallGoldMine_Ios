//
//  InputBarcodeController.h
//  GoldMine
//
//  Created by Dongfuming on 14-9-20.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "SuperViewController.h"

typedef void (^JumpToScanBlock)();

@interface InputBarcodeController : SuperViewController

@property (nonatomic, copy) JumpToScanBlock jumpToScanBlock;

@property (nonatomic, strong) NSString *barString;

@end
