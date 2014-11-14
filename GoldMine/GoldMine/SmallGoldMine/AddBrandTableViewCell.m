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
    self.leftView.backgroundColor=[UIColor whiteColor];
    self.leftView.layer.cornerRadius=5.0;
    self.rightView.backgroundColor=[UIColor whiteColor];
    self.rightView.layer.cornerRadius=5.0;
    
//    self.backgroundColor=[Utils colorWithHexString:@"F2F3F0"];
    self.backgroundColor=[UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
