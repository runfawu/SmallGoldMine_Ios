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
#import "WealthEntity.h"

@interface WealthViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *wealthArray;
@property (nonatomic, strong) SoapRequest *wealthRequest;

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
    [self requestDataOfWealthList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup
{
    self.wealthArray = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"WealthCell" bundle:nil] forCellReuseIdentifier:@"WealthCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [Utils colorWithHexString:@"F2F3F0"];
}

#pragma mark - Request data
- (void)requestDataOfWealthList
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *userInfoDict = [USERDEFAULT objectForKey:USERINFO];
    NSString *uid = userInfoDict[kUserId] == nil ? @"001" : userInfoDict[kUserId];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:[Tools getAppVersion] forKey:@"version"];
    [paramDict setObject:uid forKey:@"uid"];
    
    self.wealthRequest = [[SoapRequest alloc] init];
    __weak typeof(&*self) weakSelf = self;
    [self.wealthRequest postRequestWithSoapNamespace:@"getWealth" params:paramDict successBlock:^(id result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.wealthRequest = nil;
        DLog(@"财富列表 ＝ %@", result);
        [weakSelf parseDataOfWealthList:result];
        
    } failureBlock:^(NSString *requestError) {
        SHOW_BAD_NETWORK_TOAST(weakSelf.view);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.wealthRequest = nil;
        
    } errorBlock:^(NSMutableString *errorStr) {
        [weakSelf.view makeToast:errorStr];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.wealthRequest = nil;
    }];
}

- (void)parseDataOfWealthList:(id)result
{
    NSDictionary *resultDict = (NSDictionary *)result;
    NSArray *dataArray = resultDict[@"BrandInvdot"];
    if ( ! [dataArray isEqual:@""] && dataArray.count > 0) {
        for (NSDictionary *dict in dataArray) {
            WealthEntity *entity = [[WealthEntity alloc] initWithDict:dict];
            [self.wealthArray addObject:entity];
        }
        [self.tableView reloadData];
    } else {
        [self.view makeToast:@"暂无品牌积分信息"];
    }
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
    cell.wealthEntity = self.wealthArray[indexPath.row];
    [cell.listButton addTarget:self action:@selector(jumpToListView:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - Button events
- (void)jumpToListView:(UIButton *)button
{
    WealthCell *cell = nil;
    if (IS_IOS8) {
        cell = (WealthCell *)button.superview.superview;
    } else {
        cell = (WealthCell *)button.superview.superview.superview;
    }
    
    IntegrationDetailController *detailController = [[IntegrationDetailController alloc] initWithNibName:@"IntegrationDetailController" bundle:nil];
    detailController.brandId = cell.wealthEntity.BardID;
    
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - Override
- (void)clickedBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
