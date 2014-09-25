//
//  TaskViewController.m
//  GoldMine
//
//  Created by micheal on 14-9-24.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "TaskViewController.h"
#import "Task/TaskTableViewCell.h"
#import "Tools.h"

@interface TaskViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) SoapRequest *loginReqeust;

@end

@implementation TaskViewController

@synthesize taskTableView;

-(id)init{
    self=[super init];
    if (self) {
//        self.view.backgroundColor=[UIColor redColor];
    }
    return self;
}

-(void)viewDidLoad{
    if (!taskArray) {
        taskArray=[[NSMutableArray alloc] init];
    }
    taskOne=[[NSMutableArray alloc] init];
    taskTwo=[[NSMutableArray alloc] init];
    taskThree=[[NSMutableArray alloc] init];
    
    self.taskTableView=[[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.taskTableView.dataSource=self;
    self.taskTableView.delegate=self;
    self.taskTableView.showsHorizontalScrollIndicator = NO;
    self.taskTableView.showsVerticalScrollIndicator = NO;
    self.taskTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.taskTableView];
    
    [self getMyTaskDataRequestWithUId:@"001" andVersion:[Tools getAppVersion]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return (taskOne.count!=0)+(taskTwo.count!=0)+(taskThree.count!=0);
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
//        return [taskOne count];
        return 3;
    }else if (section==1){
//        return [taskTwo count];
        return 3;
    }else{
//        return [taskThree count];
        return 3;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"CellIndentifier";
    TaskTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[TaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section==0) {
        if (indexPath.row==0&&taskOne.count!=0) {
            cell.taskNameLabel.hidden=NO;
            [cell setTaskNameWithString:[[taskOne objectAtIndex:0] objectForKey:@"SerName"] andBackgroundColorWithColor:[UIColor colorWithRed:255.0/255 green:91.0/255 blue:84.0/255 alpha:1.0] ];
        }else{
            if (taskOne.count!=0) {
                cell.taskNameLabel.hidden=YES;
                
                NSMutableArray *vips=[[NSMutableArray alloc] init];
                for (NSDictionary *oneTask in [[taskOne objectAtIndex:0] objectForKey:@"Vips"]) {
                    [vips addObject:oneTask];
                }
                
                [cell setTaskTableViewCellWithDictionary:[vips objectAtIndex:indexPath.row-1]];
                vips=nil;
            }
        }
    }else if (indexPath.section==1&&taskTwo.count!=0){
        if (indexPath.row==0) {
            cell.taskNameLabel.hidden=NO;
            [cell setTaskNameWithString:[[taskTwo objectAtIndex:0] objectForKey:@"SerName"] andBackgroundColorWithColor:[UIColor colorWithRed:0.0 green:168.0/255 blue:98.0/255 alpha:1.0] ];
        }else{
            if (taskTwo.count!=0) {
                cell.taskNameLabel.hidden=YES;
                
                NSMutableArray *vips=[[NSMutableArray alloc] init];
                for (NSDictionary *oneTask in [[taskTwo objectAtIndex:0] objectForKey:@"Vips"]) {
                    [vips addObject:oneTask];
                }
                
                [cell setTaskTableViewCellWithDictionary:[vips objectAtIndex:indexPath.row-1]];
                vips=nil;

            }
        }
    }else if (indexPath.section==2&&taskThree.count!=0){
        if (indexPath.row==0) {
            cell.taskNameLabel.hidden=NO;
            [cell setTaskNameWithString:[[taskThree objectAtIndex:0] objectForKey:@"SerName"] andBackgroundColorWithColor:[UIColor colorWithRed:0.0 green:149.0/255 blue:229.0/255 alpha:1.0] ];
        }else{
            if (taskThree.count!=0) {
                cell.taskNameLabel.hidden=YES;
                
                NSMutableArray *vips=[[NSMutableArray alloc] init];
                for (NSDictionary *oneTask in [[taskThree objectAtIndex:0] objectForKey:@"Vips"]) {
                    [vips addObject:oneTask];
                }
                
                [cell setTaskTableViewCellWithDictionary:[vips objectAtIndex:indexPath.row-1]];
                vips=nil;
            }
        }
    }
    return cell;
}

//获取任务列表
-(void)getMyTaskDataRequestWithUId:(NSString *)uId andVersion:(NSString *)version{
        NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
        [paramDict setObject:uId forKey:@"uid"];
        [paramDict setObject:version forKey:@"version"];
    
        self.loginReqeust = [[SoapRequest alloc] init];
        [self.loginReqeust postRequestWithSoapNamespace:@"MyTask" params:paramDict successBlock:^(id result) {
         DLog(@"MyTask result=%@", result);
       
            NSArray *tasks=[result objectForKey:@"MyTasks"];
//             for (NSDictionary *taskDic in tasks) {
//                 [taskArray addObject:taskDic];
//             }
            [taskOne addObject:[tasks objectAtIndex:0]];
            [taskTwo addObject:[tasks objectAtIndex:1]];
            [taskThree addObject:[tasks objectAtIndex:2]];
            
            [self.taskTableView reloadData];
            
         } failureBlock:^(NSString *requestError) {
             NSLog(@"MyTask fail!!!");
         } errorBlock:^(NSMutableString *errorStr) {
             NSLog(@"mytask error!!!!");
         }];
         paramDict=nil;

}

@end
