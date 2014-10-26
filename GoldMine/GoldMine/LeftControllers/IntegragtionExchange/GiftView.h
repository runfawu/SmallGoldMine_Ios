//
//  GiftView.h
//  GoldMine
//
//  Created by Oliver on 14-10-12.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftEntity.h"

@interface GiftView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;
@property (weak, nonatomic) IBOutlet UILabel *integrationLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UIButton *touchButton;

@property (nonatomic, strong) GiftEntity *giftEntity;

+ (GiftView *)loadNibInstance;

@end
