//
//  WealthViewController.m
//  GoldMine
//
//  Created by Dongfuming on 14-9-21.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "WealthViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "WealthCell.h"
#import "IntegrationDetailController.h"
#import "AppDelegate.h"

@interface WealthViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *wealthArray;

@end

@implementation WealthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _bNeedShowBackBarButtonItem = YES;
        self.title = @"财富";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup
{
    self.wealthArray = [NSMutableArray array];
    for (int i = 0; i < 15; i ++) {
        NSString *text = @"hello world";
        [self.wealthArray addObject:text];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WealthCell" bundle:nil] forCellReuseIdentifier:@"WealthCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableView dataSource && delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.wealthArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 127;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"WealthCell";
    WealthCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    [cell.listButton addTarget:self action:@selector(jumpToListView:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - Button events
- (void)jumpToListView:(UIButton *)button
{
    WealthCell *cell = (WealthCell *)button.superview.superview.superview;
    DLog(@"cell = %@", cell);
    
    IntegrationDetailController *detailController = [[IntegrationDetailController alloc] initWithNibName:@"IntegrationDetailController" bundle:nil];
    
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - Override
- (void)clickedBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
