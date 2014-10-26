//
//  RankCell.m
//  GoldMine
//
//  Created by Dongfuming on 14-9-21.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "RankCell.h"
#import "UIImageView+WebCache.h"

@implementation RankCell

- (void)awakeFromNib
{
    self.thumbImageView.layer.cornerRadius = CGRectGetHeight(self.thumbImageView.frame) / 2;
    self.thumbImageView.clipsToBounds = YES;
    
    CALayer *separateLayer = [CALayer layer];
    separateLayer.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
    separateLayer.backgroundColor = [Utils colorWithHexString:@"A4A4A4"].CGColor;
    
    [self.layer addSublayer:separateLayer];
}

/*@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
 @property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
 @property (weak, nonatomic) IBOutlet UILabel *nameLabel;
 @property (weak, nonatomic) IBOutlet UILabel *integrationLabel;
 @property (weak, nonatomic) IBOutlet UILabel *vMoneyLabel;
 @property (weak, nonatomic) IBOutlet UILabel *rankLabel;
 UserID	小伙伴ID
 UserName	小伙伴名称
 Picture	小伙伴头像
 Vboon	小伙伴拥有的V宝值
 Order	小伙伴V宝值排名情况*/
- (void)setRankEntity:(RankEntity *)rankEntity
{
    _rankEntity = rankEntity;
    
    self.nameLabel.text = rankEntity.UserName;
    [self.thumbImageView setImageWithURL:[NSURL URLWithString:rankEntity.Picture] placeholderImage:nil];
    self.vMoneyLabel.text = rankEntity.Vboon;
    if ([rankEntity.Order isEqualToString:@"1"]) {
        self.rankImageView.image = [UIImage imageNamed:@"rankCell_one"];
        self.rankLabel.hidden = YES;
    } else if ([rankEntity.Order isEqualToString:@"2"]) {
        self.rankImageView.image = [UIImage imageNamed:@"rankCell_two"];
        self.rankLabel.hidden = YES;
    } else if ([rankEntity.Order isEqualToString:@"3"]) {
        self.rankImageView.image = [UIImage imageNamed:@"rankCell_three"];
        self.rankLabel.hidden = YES;
    } else {
        self.rankLabel.text = rankEntity.Order;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
