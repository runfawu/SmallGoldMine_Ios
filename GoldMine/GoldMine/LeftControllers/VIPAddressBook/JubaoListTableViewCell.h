//
//  JubaoListTableViewCell.h
//  GoldMine
//
//  Created by micheal on 14/11/12.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JubaoListTableViewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView *proImageView;
@property (nonatomic,weak) IBOutlet UILabel *proNameLabel;
@property (nonatomic,weak) IBOutlet UILabel *proSpecLabel;
@property (nonatomic,weak) IBOutlet UILabel *proMountLabel;
@property (nonatomic,weak) IBOutlet UILabel *moneyLabel;
@property (nonatomic,weak) IBOutlet UILabel *invdotLabel;

-(void)setCellContentWithDictionary:(NSDictionary *)jubaoDic;

@end
