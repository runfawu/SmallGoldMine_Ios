//
//  GoldenListTableViewCell.m
//  GoldMine
//
//  Created by micheal on 14-9-25.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "GoldenListTableViewCell.h"

@implementation GoldenListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
