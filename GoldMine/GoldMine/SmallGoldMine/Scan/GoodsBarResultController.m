//
//  GoodsBarResultController.m
//  GoldMine
//
//  Created by Oliver on 14-9-28.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "GoodsBarResultController.h"

@interface GoodsBarResultController ()<UITableViewDataSource, UITableViewDelegate>

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.goodsNameLabel.text = @"--";
    self.shopRewardLabel.text = @"--";
    self.clerkRewardLabel.text = @"--";
    self.integrationLabel.text = @"--";
    self.brandLabel.text = @"--";
    self.standardLabel.text = @"--";
    self.productNumberLabel.text = @"--";
    self.productDateLabel.text = @"--";
    self.productorLabel.text = @"--";
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
        DLog(@"扫描的商品详情 ＝ %@", result);
        [weakSelf updateUIWithResult:result];
        
    } failureBlock:^(NSString *requestError) {
        SHOW_BAD_NETWORK_TOAST(weakSelf.view);
        [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
        weakSelf.goodsInfoRequest = nil;
        
    } errorBlock:^(NSMutableString *errorStr) {
        [weakSelf.view makeToast:errorStr];
        [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
        weakSelf.goodsInfoRequest = nil;
    }];
}

- (void)updateUIWithResult:(id)result
{
    NSDictionary *resultDict = (NSDictionary *)result;
    if ([Utils isValidResult:resultDict]) {
        self.goodsImageView.image = resultDict[@"ProImg"];
        self.goodsNameLabel.text = [NSString stringWithFormat:@"%@分", resultDict[@"ProName"]];
        self.shopRewardLabel.text = [NSString stringWithFormat:@"%@分", resultDict[@"ShopIdot"]];
        self.clerkRewardLabel.text = [NSString stringWithFormat:@"%@分", resultDict[@"ClerkIdot"]];
        self.integrationLabel.text = [NSString stringWithFormat:@"%@分", resultDict[@"Idot"]];
        self.brandLabel.text = resultDict[@"ProName"];
        self.standardLabel.text = resultDict[@"Spec"];
        self.productNumberLabel.text = resultDict[@"Code"];
        self.productDateLabel.text = resultDict[@"MadeDate"];
        self.productorLabel.text = resultDict[@"EnterPrise"];
    } else {
        [self.view makeToast:@"物流码不存在"];
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }
}

#pragma mark - UITableView dataSource && delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return 18;
    }
    
    return 18;
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
