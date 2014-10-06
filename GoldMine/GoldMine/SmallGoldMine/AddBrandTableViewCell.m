//
//  AddBrandTableViewCell.m
//  GoldMine
//
//  Created by micheal on 14-10-6.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "AddBrandTableViewCell.h"

@implementation AddBrandTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.backgroundColor=[Utils colorWithHexString:@"F2F3F0"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
