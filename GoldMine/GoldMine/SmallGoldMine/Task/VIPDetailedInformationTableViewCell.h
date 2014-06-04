//
//  VIPDetailedInformationTableViewCell.h
//  GoldMine
//
//  Created by micheal on 14-6-4.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIPDetailedInformationTableViewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView *proImageView;
@property (nonatomic,weak) IBOutlet UILabel *proNameLabel;

@property (nonatomic,weak) IBOutlet UILabel *buyAccountLabel;

@property (nonatomic,weak) IBOutlet UILabel *totolMoney;
@property (nonatomic,weak) IBOutlet UILabel *creditLabe;

-(void)setVIPDetailedInformationTableViewCellWithDictionary:(NSDictionary *)goldenDic;

@end
