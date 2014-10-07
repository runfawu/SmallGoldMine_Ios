//
//  VIPDetailedInformationTableViewCell.m
//  GoldMine
//
//  Created by micheal on 14-6-4.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "VIPDetailedInformationTableViewCell.h"

@implementation VIPDetailedInformationTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setVIPDetailedInformationTableViewCellWithDictionary:(NSDictionary *)goldenDic{
    self.proNameLabel.text=[goldenDic objectForKey:@"ProName"];
    self.buyAccountLabel.text=[NSString stringWithFormat:@"X %@",[goldenDic objectForKey:@"Acmounnt"]];
    self.totolMoney.text=[NSString stringWithFormat:@"合计:%@/元",[goldenDic objectForKey:@"Money"]];
    self.creditLabe.text=[NSString stringWithFormat:@"积分:%@/分",[goldenDic objectForKey:@"Invdot"]];
}

@end
