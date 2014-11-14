//
//  VIPAddressBookDetailCell.m
//  GoldMine
//
//  Created by micheal on 14/11/5.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "VIPAddressBookDetailCell.h"

@implementation VIPAddressBookDetailCell

- (void)awakeFromNib {
    // Initialization code
    
    UITapGestureRecognizer *shareGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(share)];
    
    [self.shareImageView addGestureRecognizer:shareGesture];
}

-(void)setVIPAddressBookDetailCelWithInfoDictionary:(NSDictionary *)infoDic{
    self.titleLable.text=[infoDic objectForKey:@"title"];
    self.infoLabel.text=[infoDic objectForKey:@"info"];
}

-(void)share{
    if ([self.delegate respondsToSelector:@selector(shareToBuddy:)]) {
        [self.delegate shareToBuddy:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
