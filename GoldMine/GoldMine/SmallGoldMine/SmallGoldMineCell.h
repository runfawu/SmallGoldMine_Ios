//
//  SmallGoldMineCell.h
//  GoldMine
//
//  Created by micheal on 14-5-11.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmallGoldMineCell : UITableViewCell

@property (nonatomic,strong) UIImageView *goodsImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *goodsDescribeLabel;
@property (nonatomic,strong) UIView *cellSeperateView;

-(void)setSmallGoldMineCellWithDictionary:(NSDictionary *)brandDic;


@end
