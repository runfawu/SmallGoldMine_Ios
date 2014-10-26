//
//  IntegrationDetailController.m
//  GoldMine
//
//  Created by Dongfuming on 14-9-21.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "IntegrationDetailController.h"
#import "IntegrationDetailCell.h"
#import "IntegrationDetaiEntity.h"

@interface IntegrationDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *integrationDetailArray;
@property (nonatomic, strong) SoapRequest *integrationDetailRequest;

@end

@implementation IntegrationDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _bNeedShowBackBarButtonItem = YES;
        self.title = @"积分明细";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setup];
    [self requestDataOfIntegrationDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup
{
    self.integrationDetailArray = [NSMutableArray array];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"IntegrationDetailCell" bundle:nil] forCellReuseIdentifier:@"IntegrationDetailCell"];
    self.view.backgroundColor = [Utils colorWithHexString:@"F2F3F0"];
    self.tableView.backgroundColor = [Utils colorWithHexString:@"F2F3F0"];
}

- (void)requestDataOfIntegrationDetail
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *userInfoDict = [USERDEFAULT objectForKey:USERINFO];
    NSString *uid = userInfoDict[kUserId] == nil ? @"001" : userInfoDict[kUserId];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:[Tools getAppVersion] forKey:@"version"];
    [paramDict setObject:uid forKey:@"uid"];
    
    self.integrationDetailRequest = [[SoapRequest alloc] init];
    __weak typeof(&*self) weakSelf = self;
    [self.integrationDetailRequest postRequestWithSoapNamespace:@"getInvdotInfo" params:paramDict successBlock:^(id result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.integrationDetailRequest = nil;
        DLog(@"积分明细列表 ＝ %@", result);
        [weakSelf parseDataOfIntegrationDetail:result];
        
    } failureBlock:^(NSString *requestError) {
        SHOW_BAD_NETWORK_TOAST(weakSelf.view);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.integrationDetailRequest = nil;
        
    } errorBlock:^(NSMutableString *errorStr) {
        [weakSelf.view makeToast:errorStr];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.integrationDetailRequest = nil;
    }];
}

- (void)parseDataOfIntegrationDetail:(id)result
{
    NSDictionary *resultDict= (NSDictionary *)result;
    NSArray *dataArray = resultDict[@"InvInfo"];
    if ( ! [dataArray isEqual:@""] && dataArray.count > 0) {
        for (NSDictionary *dict in dataArray) {
            IntegrationDetaiEntity *entity = [[IntegrationDetaiEntity alloc] initWithDict:dict];
            [self.integrationDetailArray addObject:entity];
        }
        [self.tableView reloadData];
    } else {
        [self.view makeToast:@"暂无该品牌产品积分明细"];
    }
}

#pragma mark - UITableView dataSource && delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.integrationDetailArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"IntegrationDetailCell";
    IntegrationDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.integrationEntity = self.integrationDetailArray[indexPath.row];
    
    return cell;
}



@end
