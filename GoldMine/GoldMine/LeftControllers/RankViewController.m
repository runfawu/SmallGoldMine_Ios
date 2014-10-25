//
//  RankViewController.m
//  GoldMine
//
//  Created by Dongfuming on 14-9-21.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "RankViewController.h"
#import "RankCell.h"
#import "RankEntity.h"

@interface RankViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) SoapRequest *rankRequest;
@property (nonatomic, strong) NSMutableArray *rankArray;

@end

@implementation RankViewController

- (void)dealloc
{
    DLog(@"rankViewController dealloc");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _bNeedShowBackBarButtonItem = YES;
        self.title = @"排名";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setup];
    [self requestRankData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup
{
    self.rankArray = [NSMutableArray array];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RankCell" bundle:nil] forCellReuseIdentifier:@"RankCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Request data
- (void)requestRankData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *userInfoDict = [USERDEFAULT objectForKey:USERINFO];
    NSString *uid = userInfoDict[kUserId] == nil ? @"001" : userInfoDict[kUserId];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:[Tools getAppVersion] forKey:@"version"];
    [paramDict setObject:uid forKey:@"uid"];
    
    self.rankRequest = [[SoapRequest alloc] init];
    __weak typeof(&*self) weakSelf = self;
    [self.rankRequest postRequestWithSoapNamespace:@"MyFriendsOrder" params:paramDict successBlock:^(id result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.rankRequest = nil;
        DLog(@"小伙伴排名列表 ＝ %@", result);
        [weakSelf parseRankData:result];
        
    } failureBlock:^(NSString *requestError) {
        SHOW_BAD_NETWORK_TOAST(weakSelf.view);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.rankRequest = nil;
        
    } errorBlock:^(NSMutableString *errorStr) {
        [weakSelf.view makeToast:errorStr];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.rankRequest = nil;
    }];
}

- (void)parseRankData:(id)result
{
    NSDictionary *resultDict= (NSDictionary *)result;
    NSArray *dataArray = resultDict[@"MyFriendsOrder"];
    if ( ! [dataArray isEqual:@""] && dataArray.count > 0) {
        for (NSDictionary *dict in dataArray) {
            RankEntity *entity = [[RankEntity alloc] initWithDict:dict];
            [self.rankArray addObject:entity];
        }
        [self.tableView reloadData];
    } else {
        [self.view makeToast:@"暂无小伙伴排名"];
    }
}


#pragma mark - UITableView dataSource && delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rankArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"RankCell";
    RankCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.rankEntity = self.rankArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Override
- (void)clickedBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
