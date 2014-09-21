//
//  RankCell.m
//  GoldMine
//
//  Created by Dongfuming on 14-9-21.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "RankCell.h"

@implementation RankCell

- (void)awakeFromNib
{
//    self.rankImageView.layer.cornerRadius = CGRectGetHeight(self.rankImageView.frame) / 2;
//    self.rankImageView.clipsToBounds = YES;
//    self.rankImageView.layer.masksToBounds = YES;
    
    self.thumbImageView.layer.cornerRadius = CGRectGetHeight(self.thumbImageView.frame) / 2;
    self.thumbImageView.clipsToBounds = YES;
    
    CALayer *separateLayer = [CALayer layer];
    separateLayer.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
    separateLayer.backgroundColor = [Utils colorWithHexString:@"A4A4A4"].CGColor;
    
    [self.layer addSublayer:separateLayer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
