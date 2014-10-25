//
//  RankCell.h
//  GoldMine
//
//  Created by Dongfuming on 14-9-21.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankEntity.h"

@interface RankCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *integrationLabel;
@property (weak, nonatomic) IBOutlet UILabel *vMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

@property (nonatomic, strong) RankEntity *rankEntity;

@end
