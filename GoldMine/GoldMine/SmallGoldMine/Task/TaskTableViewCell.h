//
//  TaskTableViewCell.h
//  GoldMine
//
//  Created by micheal on 14-9-15.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *contactNameLabel;
@property (nonatomic,strong) UILabel *telNoLabel;
@property (nonatomic,strong) UIButton *telephoneButton;
@property (nonatomic,strong) UIButton *vipInfoButton;
@property (nonatomic,strong) UIView *cellSeperateView;

@property (nonatomic,strong) UILabel *taskNameLabel;

-(void)setTaskTableViewCellWithDictionary:(NSDictionary *)taskDic;

-(void)setTaskNameWithString:(NSString *)taskString andBackgroundColorWithColor:(UIColor *)bgColor;

@end
