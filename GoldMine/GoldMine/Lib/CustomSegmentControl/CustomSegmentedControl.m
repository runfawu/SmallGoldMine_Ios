//
//  CustomSegmentedControl.m
//  iShow
//
//  Created by micheal on 14-5-11.
//  Copyright (c) 2014年 56.com. All rights reserved.
//

#import "CustomSegmentedControl.h"

@implementation CustomSegmentedControl

@synthesize vSquareButton=_vSquareButton;
@synthesize taskButton=_taskButton;
@synthesize goldMineButton=_goldMineButton;
@synthesize flagView=_flagView;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.vSquareButton=[[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 106.0, 40.0)];
        [self.vSquareButton setTitle:@"V广场" forState:UIControlStateNormal];
        [self.vSquareButton setTitleColor:[UIColor colorWithRed:249.0/255 green:186.0/255 blue:8.0/255 alpha:1.0] forState:UIControlStateNormal];
        self.vSquareButton.titleLabel.font=[UIFont systemFontOfSize:16.0];
        [self addSubview:self.vSquareButton];
        
        self.flagView=[[UIView alloc] initWithFrame:CGRectMake(0.0,CGRectGetMaxY(self.vSquareButton.frame)-5.0, 106.0, 5.0)];
        self.flagView.backgroundColor=[UIColor colorWithRed:249.0/255 green:186.0/255 blue:8.0/255 alpha:1.0];
        [self addSubview:self.flagView];
        
        UIView *oneSeperateView=[[UIView alloc] initWithFrame:CGRectMake(self.vSquareButton.frame.size.width, 10.0, 1.0, 20.0)];
        oneSeperateView.backgroundColor=[UIColor colorWithRed:161.0/255 green:161.0/255 blue:161.0/255 alpha:1.0];
        [self addSubview:oneSeperateView];
        oneSeperateView=nil;
        
        self.taskButton=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.vSquareButton.frame)+1, 0.0, 106.0, 40.0)];
        [self.taskButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
        [self.taskButton setTitle:@"任务" forState:UIControlStateNormal];
        self.taskButton.titleLabel.font=[UIFont systemFontOfSize:16.0];
        [self addSubview:self.taskButton];
        
        UIView *twoSeperateView=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.taskButton.frame), 10.0, 1.0, 20.0)];
        twoSeperateView.backgroundColor=[UIColor colorWithRed:161.0/255 green:161.0/255 blue:161.0/255 alpha:1.0];
        [self addSubview:twoSeperateView];
        oneSeperateView=nil;
        
        self.goldMineButton=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.taskButton.frame)+1, 0.0, 106.0, 40.0)];
         [self.goldMineButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
        [self.goldMineButton setTitle:@"聚宝" forState:UIControlStateNormal];
        self.goldMineButton.titleLabel.font=[UIFont systemFontOfSize:16.0];
        [self addSubview:self.goldMineButton];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
