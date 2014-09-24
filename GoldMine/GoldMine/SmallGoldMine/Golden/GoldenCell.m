//
//  GoldenCell.m
//  GoldMine
//
//  Created by Oliver on 14-9-24.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "GoldenCell.h"

@implementation GoldenCell

- (void)awakeFromNib
{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
    bottomBorder.backgroundColor = [Utils colorWithHexString:@"636666"].CGColor;
    
    [self.layer addSublayer:bottomBorder];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
