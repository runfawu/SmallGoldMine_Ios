//
//  TaskTableViewCell.m
//  GoldMine
//
//  Created by micheal on 14-9-15.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "TaskTableViewCell.h"

@implementation TaskTableViewCell

@synthesize contactNameLabel;
@synthesize telNoLabel;
@synthesize telephoneButton;
@synthesize vipInfoButton;
@synthesize cellSeperateView;

@synthesize delegate=_delegate;

//高度45
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contactNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(8.0, 10.0, 80.0, 25.0)];
        self.contactNameLabel.textColor=[UIColor colorWithRed:117.0/255 green:117.0/255 blue:117.0/255 alpha:1.0];
        [self addSubview:self.contactNameLabel];
        
        self.telNoLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contactNameLabel.frame)+20.0, self.contactNameLabel.frame.origin.y, 120.0, 25.0)];
        self.telNoLabel.textColor=[UIColor colorWithRed:117.0/255 green:117.0/255 blue:117.0/255 alpha:1.0];
        [self addSubview:self.telNoLabel];
        
        self.telephoneButton=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-93.0, 7.5, 31.0, 30.0)];
        [self.telephoneButton setBackgroundImage:[UIImage imageNamed:@"task_tel"] forState:UIControlStateNormal];
        [self.telephoneButton setBackgroundImage:[UIImage imageNamed:@"task_tel_down"] forState:UIControlStateHighlighted];
        [self.telephoneButton addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.telephoneButton];
        
        self.vipInfoButton=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.telephoneButton.frame)+25.0, self.telephoneButton.frame.origin.y, 31.0, 30.0)];
        [self.vipInfoButton setBackgroundImage:[UIImage imageNamed:@"task_vip"] forState:UIControlStateNormal];
        [self.vipInfoButton setBackgroundImage:[UIImage imageNamed:@"task_vip_down"] forState:UIControlStateHighlighted];
        [self.vipInfoButton addTarget:self action:@selector(seeVipInfomation:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.vipInfoButton];
        
        self.cellSeperateView=[[UIView alloc] initWithFrame:CGRectMake(0.0, 45.0, self.frame.size.width, 1)];
        self.cellSeperateView.backgroundColor=[UIColor colorWithRed:208.0/255 green:208.0/255 blue:208.0/255 alpha:1.0];
        [self addSubview:self.cellSeperateView];
        
        self.taskNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
        self.taskNameLabel.font=[UIFont systemFontOfSize:16.0];
        self.taskNameLabel.textColor=[UIColor colorWithRed:253.0/255 green:253.0/255 blue:253.0/255 alpha:1.0];
        self.taskNameLabel.hidden=YES;
        [self addSubview:self.taskNameLabel];
    }
    return self;
}

-(void)setTaskTableViewCellWithDictionary:(NSDictionary *)taskDic{
    self.contactNameLabel.text=[NSString stringWithFormat:@"%@",[taskDic objectForKey:@"CusName"]];
    self.telNoLabel.text=[taskDic objectForKey:@"CusPhone"];
}

-(void)setTaskNameWithString:(NSString *)taskString andBackgroundColorWithColor:(UIColor *)bgColor{
    self.taskNameLabel.backgroundColor=[UIColor colorWithCGColor:bgColor.CGColor];
    self.taskNameLabel.text=taskString;
}

//拨打电话
-(void)call:(id)sender{
    if ([_delegate respondsToSelector:@selector(callTheTelephoneNum:andTaskViewCell:)]) {
        [_delegate callTheTelephoneNum:self.telNoLabel.text andTaskViewCell:self];
    }
}

//查看VIP详细信息
-(void)seeVipInfomation:(id)sender{
    if ([_delegate respondsToSelector:@selector(seeVipDetailInfoWithCustomeId:andTaskViewCell:)]) {
        [_delegate seeVipDetailInfoWithCustomeId:nil andTaskViewCell:self];
    }
}

@end
