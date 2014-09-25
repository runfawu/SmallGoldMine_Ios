//
//  TaskViewController.h
//  GoldMine
//
//  Created by micheal on 14-9-24.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskViewController : UIViewController{
    NSMutableArray *taskArray;
    
    NSMutableArray *taskOne;
    NSMutableArray *taskTwo;
    NSMutableArray *taskThree;
}

@property (nonatomic,strong) UITableView *taskTableView;

-(void)getMyTaskDataRequestWithUId:(NSString *)uId andVersion:(NSString *)version;

@end
