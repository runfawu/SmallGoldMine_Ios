//
//  VIPAddressBookViewCell.m
//  GoldMine
//
//  Created by micheal on 14-10-19.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "VIPAddressBookViewCell.h"
#import "UIImageView+WebCache.h"

@implementation VIPAddressBookViewCell

@synthesize headBgImageView;
@synthesize nameLabel;
@synthesize seprateLine;

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
        
        self.seprateLine=[[UIView alloc] initWithFrame:CGRectMake(8.0, 51.0, self.frame.size.width, 1)];
        self.seprateLine.backgroundColor=[UIColor colorWithRed:227.0/255 green:227.0/255 blue:227.0/255 alpha:1.0];
        [self addSubview:self.seprateLine];
    }
    return self;
}

-(void)setVIPAddressBookViewCellWithDictionary:(NSDictionary *)contactDic{
    if ([contactDic objectForKey:@"CusName"]==nil ) {
        [self.headBgImageView setImageWithURL:[NSURL URLWithString:[contactDic objectForKey:@"Picture"]] placeholderImage:nil];
        self.nameLabel.text=[contactDic objectForKey:@"UserName"];
    }else{
        [self.headBgImageView setImageWithURL:[NSURL URLWithString:[contactDic objectForKey:@"CusImg"]] placeholderImage:nil];
        self.nameLabel.text=[contactDic objectForKey:@"CusName"];
    }
}

@end
