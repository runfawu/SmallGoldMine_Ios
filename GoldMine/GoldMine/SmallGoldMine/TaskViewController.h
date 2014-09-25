//
//  TaskViewController.h
//  GoldMine
//
//  Created by micheal on 14-9-24.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TaskViewControllerDelegate <NSObject>

-(void)seeVipDetailInfomationWithCustomeId:(NSString *)customeId;

@end

@interface TaskViewController : UIViewController{
    NSMutableArray *taskArray;
    
    NSMutableArray *taskOne;
    NSMutableArray *taskTwo;
    NSMutableArray *taskThree;
    
    __weak id<TaskViewControllerDelegate> _delegate;
}

@property (nonatomic,strong) UITableView *taskTableView;
@property (nonatomic,weak) id<TaskViewControllerDelegate> delegate;

-(void)getMyTaskDataRequestWithUId:(NSString *)uId andVersion:(NSString *)version;

@end
