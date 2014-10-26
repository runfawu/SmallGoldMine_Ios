//
//  IntegrationDetailCell.h
//  GoldMine
//
//  Created by Dongfuming on 14-9-21.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntegrationDetaiEntity.h"

@interface IntegrationDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *integrationLabel;

@property (nonatomic, strong) IntegrationDetaiEntity *integrationEntity;

@end
