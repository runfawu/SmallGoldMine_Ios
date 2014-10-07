//
//  WealthCell.h
//  GoldMine
//
//  Created by Dongfuming on 14-9-21.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WealthEntity.h"

@interface WealthCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalIntegrationLabel;
@property (weak, nonatomic) IBOutlet UILabel *plusIntegrationLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainIntegrationLabel;
@property (weak, nonatomic) IBOutlet UIButton *listButton;

@property (nonatomic, strong) WealthEntity *wealthEntity;

@end
