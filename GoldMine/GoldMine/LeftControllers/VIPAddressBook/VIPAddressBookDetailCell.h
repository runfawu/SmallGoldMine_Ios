//
//  VIPAddressBookDetailCell.h
//  GoldMine
//
//  Created by micheal on 14/11/5.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VIPAddressBookDetailCell;

@protocol VIPAddressBookDetailCellDelegate <NSObject>

-(void)shareToBuddy:(VIPAddressBookDetailCell *)cell;

@end

@interface VIPAddressBookDetailCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *titleLable;
@property (nonatomic,weak) IBOutlet UILabel *infoLabel;
@property (nonatomic,weak) IBOutlet UIView *seprateLineView;
@property (nonatomic,weak) IBOutlet UIImageView *shareImageView;

@property (nonatomic,weak) id <VIPAddressBookDetailCellDelegate>delegate;

-(void)setVIPAddressBookDetailCelWithInfoDictionary:(NSDictionary *)infoDic;


@end
