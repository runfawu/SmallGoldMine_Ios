//
//  TaskTableViewCell.h
//  GoldMine
//
//  Created by micheal on 14-9-15.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskTableViewCell;

@protocol TaskTabelViewCellDelegate <NSObject>

-(void)callTheTelephoneNum:(NSString *)telNum andTaskViewCell:(TaskTableViewCell *)cell;

-(void)seeVipDetailInfoWithCustomeId:(NSString *)customeId andTaskViewCell:(TaskTableViewCell *)cell;

@end

@interface TaskTableViewCell : UITableViewCell{
    __weak id <TaskTabelViewCellDelegate> _delegate;
}

@property (nonatomic,strong) UILabel *contactNameLabel;
@property (nonatomic,strong) UILabel *telNoLabel;
@property (nonatomic,strong) UIButton *telephoneButton;
@property (nonatomic,strong) UIButton *vipInfoButton;
@property (nonatomic,strong) UIView *cellSeperateView;

@property (nonatomic,strong) UILabel *taskNameLabel;

@property (nonatomic,strong) NSIndexPath *currentIndexPath;

@property (nonatomic,weak) id<TaskTabelViewCellDelegate> delegate;

-(void)setTaskTableViewCellWithDictionary:(NSDictionary *)taskDic;

-(void)setTaskNameWithString:(NSString *)taskString andBackgroundColorWithColor:(UIColor *)bgColor;

@end
