//
//  GoodsBarResultController.m
//  GoldMine
//
//  Created by Oliver on 14-9-28.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "GoodsBarResultController.h"

@interface GoodsBarResultController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *firstCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *secondCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *thirdCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *fourthCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *fifthCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *sixthCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *sevenCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *eighthCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *ninethCell;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopRewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *clerkRewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *integrationLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *standardLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *productDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *productorLabel;

@property (nonatomic, strong) SoapRequest *goodsInfoRequest;

@end

@implementation GoodsBarResultController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _bNeedShowBackBarButtonItem = YES;
        self.title = @"商品查询";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setup];
    [self requestDataOfGoodsInfo];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup
{

}

- (void)requestDataOfGoodsInfo
{
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:self.barString forKey:@"code"];
    [paramDict setObject:[Tools getAppVersion] forKey:@"version"];
    
    self.goodsInfoRequest = [[SoapRequest alloc] init];
    __weak typeof(&*self) weakSelf = self;
    [self.goodsInfoRequest postRequestWithSoapNamespace:@"getProInfo" params:paramDict successBlock:^(id result) {
        [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
        weakSelf.goodsInfoRequest = nil;
        DLog(@"goodsResultView.frame = %@", NSStringFromCGRect(weakSelf.view.superview.frame));
        DLog(@"扫描的商品详情 ＝ %@", result);
    } failureBlock:^(NSString *requestError) {
        [weakSelf.view makeToast:@"请求服务器失败"];
        [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
        weakSelf.goodsInfoRequest = nil;
    } errorBlock:^(NSMutableString *errorStr) {
        [weakSelf.view makeToast:errorStr];
        [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
        weakSelf.goodsInfoRequest = nil;
    }];
}

#pragma mark - UITableView dataSource && delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 3;
    } else if (section == 2) {
        return 5;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 93;
    }
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.firstCell;
        
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        return self.secondCell;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        return self.thirdCell;
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        return self.fourthCell;
        
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        return self.fifthCell;
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        return self.sixthCell;
    } else if (indexPath.section == 2 && indexPath.row == 2) {
        return self.sevenCell;
    } else if (indexPath.section == 2 && indexPath.row == 3) {
        return self.eighthCell;
    } else if (indexPath.section == 2 && indexPath.row == 4) {
        return self.ninethCell;
    }
    
    return self.firstCell;
}


#pragma mark - Override
- (void)clickedBack:(id)sender
{
    [super clickedBack:sender];
}

@end
