//
//  TaskHeadView.m
//  GoldMine
//
//  Created by micheal on 14-9-15.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "TaskHeadView.h"

@implementation TaskHeadView

@synthesize taskNameLabel;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.taskNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
        self.taskNameLabel.font=[UIFont systemFontOfSize:16.0];
        self.taskNameLabel.textColor=[UIColor colorWithRed:253.0/255 green:253.0/255 blue:253.0/255 alpha:1.0];
        [self addSubview:self.taskNameLabel];
    }
    return self;
}

-(void)setTaskNameWithString:(NSString *)taskString andBackgroundColorWithColor:(UIColor *)bgColor{
    self.taskNameLabel.backgroundColor=[UIColor colorWithCGColor:bgColor.CGColor];
    self.taskNameLabel.text=taskString;
}

@end
