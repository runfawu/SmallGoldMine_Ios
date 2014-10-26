//
//  WealthCell.m
//  GoldMine
//
//  Created by Dongfuming on 14-9-21.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "WealthCell.h"
#import "UIImageView+WebCache.h"

@implementation WealthCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];


}

- (void)setWealthEntity:(WealthEntity *)wealthEntity
{
    _wealthEntity = wealthEntity;
    
    [self.thumbImageView setImageWithURL:[NSURL URLWithString:_wealthEntity.BardImg] placeholderImage:[UIImage imageNamed:@"logo_icon"]];
    self.titleLabel.text = _wealthEntity.BardName;
    self.totalIntegrationLabel.text = _wealthEntity.IdotCount;
    self.plusIntegrationLabel.text = [NSString stringWithFormat:@"+%@ 积分", _wealthEntity.Idot];
    self.remainIntegrationLabel.text = _wealthEntity.IdotTrue;
}

@end
