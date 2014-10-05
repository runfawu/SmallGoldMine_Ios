//
//  ScanNaviView.h
//  GoldMine
//
//  Created by Oliver on 14-9-28.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoopButton.h"

@interface ScanNaviView : UIView

@property (weak, nonatomic) IBOutlet LoopButton *torchButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIButton *integrationScanButton;
@property (weak, nonatomic) IBOutlet UIButton *queryGoodsButton;
@property (weak, nonatomic) IBOutlet UIButton *manualInputButton;

+ (ScanNaviView *)loadNibInstance;

@end
