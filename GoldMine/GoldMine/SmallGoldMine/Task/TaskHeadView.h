//
//  TaskHeadView.h
//  GoldMine
//
//  Created by micheal on 14-9-15.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskHeadView : UITableViewCell

@property (nonatomic,strong) UILabel *taskNameLabel;

-(void)setTaskNameWithString:(NSString *)taskString andBackgroundColorWithColor:(UIColor *)bgColor;

@end
