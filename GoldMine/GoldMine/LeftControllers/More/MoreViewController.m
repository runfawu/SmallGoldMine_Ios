//
//  MoreViewController.m
//  GoldMine
//
//  Created by Oliver on 14-10-18.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "MoreViewController.h"
#import "FeedbackController.h"
#import "AboutViewController.h"

@interface MoreViewController ()<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableViewCell *firstCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *secondCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *thirdCell;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _bNeedShowBackBarButtonItem = YES;
        self.title = @"更多";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.tableFooterView = self.footerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView dataSource && delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 20;
    }
    
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 2;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return self.firstCell;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            return self.secondCell;
        } else if (indexPath.row == 1) {
            
            return self.thirdCell;
        }
    }
    
    return self.firstCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0) { //意见反馈
        FeedbackController *feedbackController = [[FeedbackController alloc] initWithNibName:@"FeedbackController" bundle:nil];
        
        [self.navigationController pushViewController:feedbackController animated:YES];
        
    } else if (indexPath.section == 1 && indexPath.row == 1) { //关于
        AboutViewController *feedbackController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
        
        [self.navigationController pushViewController:feedbackController animated:YES];
    }
}

#pragma mark - Logout
- (IBAction)logoutTheAccount:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定退出当前账号?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DLog(@"alert = %d", buttonIndex);
    if (buttonIndex == 0) { //取消
        
    } else if (buttonIndex == 1) { //确定
        //TODO: logout
    }
}

- (void)clickedBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
