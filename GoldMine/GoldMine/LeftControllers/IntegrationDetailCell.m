//
//  IntegrationDetailCell.m
//  GoldMine
//
//  Created by Dongfuming on 14-9-21.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "IntegrationDetailCell.h"
#import "UIImageView+WebCache.h"

@implementation IntegrationDetailCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIntegrationEntity:(IntegrationDetaiEntity *)integrationEntity
{
    _integrationEntity = integrationEntity;
    
    self.timeLabel.text = _integrationEntity.GetTime;
    self.contentLabel.text = _integrationEntity.ProName;
    self.integrationLabel.text = [NSString stringWithFormat:@"+%@ 积分", _integrationEntity.Idot];
    [self.thumbImageView setImageWithURL:[NSURL URLWithString:_integrationEntity.ProImg] placeholderImage:[UIImage imageNamed:@"logo_icon"]];
}

@end
