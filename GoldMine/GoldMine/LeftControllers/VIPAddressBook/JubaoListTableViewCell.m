//
//  JubaoListTableViewCell.m
//  GoldMine
//
//  Created by micheal on 14/11/12.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "JubaoListTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation JubaoListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setCellContentWithDictionary:(NSDictionary *)jubaoDic{
    [self.proImageView setImageWithURL:[NSURL URLWithString:[jubaoDic objectForKey:@"ProImg"]] placeholderImage:nil];
    self.proNameLabel.text=[jubaoDic objectForKey:@"ProName"];
    self.proSpecLabel.text=[jubaoDic objectForKey:@"Spec"];
    self.proMountLabel.text=[NSString stringWithFormat:@"X %@",[jubaoDic objectForKey:@"Acmounnt"]];
    self.moneyLabel.text=[NSString stringWithFormat:@"合计: %@",[jubaoDic objectForKey:@"Money"]];
    self.invdotLabel.text=[NSString stringWithFormat:@"积分: %@",[jubaoDic objectForKey:@"Invdot"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
