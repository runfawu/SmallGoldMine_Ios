//
//  VIPAddressBookViewCell.m
//  GoldMine
//
//  Created by micheal on 14-10-19.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "VIPAddressBookViewCell.h"

@implementation VIPAddressBookViewCell

@synthesize headBgImageView;
@synthesize nameLabel;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headBgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(9.0, 6.0, 40.0, 40.0)];
        self.headBgImageView.image=[UIImage imageNamed:@"vip_headphotoBg"];
        [self addSubview:self.headBgImageView];
        
        self.nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headBgImageView.frame)+15, 0.0, 200.0, 52.0)];
        self.nameLabel.backgroundColor=[UIColor clearColor];
        self.nameLabel.font=[UIFont systemFontOfSize:13.0];
        [self addSubview:self.nameLabel];
    }
    return self;
}

@end
