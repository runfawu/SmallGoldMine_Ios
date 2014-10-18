//
//  ExchangeDetailController.m
//  GoldMine
//
//  Created by Oliver on 14-10-12.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "ExchangeDetailController.h"
#import "UIImageView+WebCache.h"

@interface ExchangeDetailController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *firstCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *secondCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *thirdCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *fourthCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *fifthCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *sixthCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *seventhCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *eighthCell;

@property (weak, nonatomic) IBOutlet UILabel *first_Label;
@property (weak, nonatomic) IBOutlet UIImageView *second_imageView;
@property (weak, nonatomic) IBOutlet UILabel *third_label;
@property (weak, nonatomic) IBOutlet UILabel *fourth_label;
@property (weak, nonatomic) IBOutlet UILabel *sixth_label;
@property (weak, nonatomic) IBOutlet UILabel *eigth_label;


@property (nonatomic, strong) SoapRequest *giftDetailRequest;
@property (nonatomic, strong) NSDictionary *giftDetailDict;
@property (nonatomic, strong) SoapRequest *exchangeRequest;

@end

@implementation ExchangeDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _bNeedShowBackBarButtonItem = YES;
        self.title = @"积分换礼详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setup];
    [self requestGiftDetailData];
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = GRAY_COLOR;
    self.giftDetailDict = [NSDictionary dictionaryWithObjectsAndKeys:@"http://202.91.242.228:7003/Picture/img2/008.jpg", @"Image",
                           @"纽瑞滋金装奶粉1段400g", @"Theme",
                           @"欢迎参加纽瑞滋奶粉兑换活动，本次活动特惠推出纽瑞滋金装奶粉1段400g兑换商品，您只需要花费200个V宝就可以兑换到该商品，数量有限，先抢先得，赶快行动吧！纽瑞滋金装奶粉1段400g", @"Introduce",
                           @"滋金装奶粉1段400g兑换商品，您只需要花费200个V宝就可以兑换到该商品，数量有限，先抢先得，赶快行动吧！纽瑞滋金装奶粉1段400g纽瑞滋金装奶粉1段400g", @"Activenotes",
                           @"您只需要花费200个V宝就可以兑换到该商品，数量有限，先抢先得，赶快行动吧！纽瑞滋金装奶粉1段400g纽瑞滋金装奶粉1段400g您只需要花费200个V宝就可以兑换到该商品，数量有限，先抢先得，赶快行动吧！纽瑞滋金装奶粉1段400g纽瑞滋金装奶粉1段400g纽瑞滋金装奶粉1段400g", @"Changenotes", 
                           @"1660", @"NeedIdot",
                           @"100", @"Number",
                           @"35", @"Idot",
                           nil];
}

#pragma mark - Request data
- (void)requestGiftDetailData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *userInfoDict = [USERDEFAULT objectForKey:USERINFO];
    NSString *uid = userInfoDict[kUserId] == nil ? @"001" : userInfoDict[kUserId];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:[Tools getAppVersion] forKey:@"version"];
    [paramDict setObject:uid forKey:@"uid"];
    [paramDict setObject:self.giftCode forKey:@"code"];
    
    self.giftDetailRequest = [[SoapRequest alloc] init];
    __weak typeof(&*self) weakSelf = self;
    [self.giftDetailRequest postRequestWithSoapNamespace:@"getExchangeInfo" params:paramDict successBlock:^(id result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.giftDetailRequest = nil;
        DLog(@"gift detail ＝ %@", result);
        [weakSelf parseGiftDetailData:result];
        
    } failureBlock:^(NSString *requestError) {
        SHOW_BAD_NETWORK_TOAST(weakSelf.view);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.giftDetailRequest = nil;
        
    } errorBlock:^(NSMutableString *errorStr) {
        [weakSelf.view makeToast:errorStr];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.giftDetailRequest = nil;
    }];
}

- (void)parseGiftDetailData:(id)result
{
    /*{"Image":"adfa","Theme":"纽瑞滋金装奶粉1段400g","Introduce":"欢迎参加纽瑞滋奶粉兑换活动，本次活动特惠推出纽瑞滋金装奶粉1段400g兑换商品，您只需要花费200个V宝就可以兑换到该商品，数量有限，先抢先得，赶快行动吧！","Activenotes":"","Changenotes":"","NeedIdot":"200","Number":"100","Idot":"35"}*/
    
    
    
    self.giftDetailDict = (NSDictionary *)result;
    [self.tableView reloadData];
}

- (CGFloat)getHeightByString:(NSString *)string font:(CGFloat)font width:(CGFloat)width
{
    CGSize size = CGSizeZero;
    if (string && string.length > 0) {
        NSDictionary *attributeDict = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
        size = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributeDict context:nil].size;
    }
    
    return size.height;
}

#pragma mark - UITableView dataSource && delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return self.firstCell.frame.size.height;
    } else if (indexPath.row == 1) {
        return self.secondCell.frame.size.height;
    } else if (indexPath.row == 2) {
        return self.thirdCell.frame.size.height;
    } else if (indexPath.row == 3) {
        NSString *text = self.giftDetailDict[@"Introduce"];
        CGFloat height = [self getHeightByString:text font:14 width:self.fourth_label.frame.size.width];
        
        return height + 20;
    } else if (indexPath.row == 4) {
        return self.fifthCell.frame.size.height;
    } else if (indexPath.row == 5) {
        NSString *text = self.giftDetailDict[@"Activenotes"];
        CGFloat height = [self getHeightByString:text font:14 width:self.fourth_label.frame.size.width];
        return height + 20;
    } else if (indexPath.row == 6) {
        return self.seventhCell.frame.size.height;
    } else if (indexPath.row == 7) {
        NSString *text = self.giftDetailDict[@"Changenotes"];
        CGFloat height = [self getHeightByString:text font:14 width:self.fourth_label.frame.size.width];
        
        return height + 20;
    }

    return 44;
}

/*Image	兑换图片
 Theme	兑换主题
 Introduce	文字介绍
 Activenotes	活动说明
 Changenotes	兑换说明
 NeedIdot	所需积分值
 Number	兑换礼品库存数量
 Idot	可用积分值
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        self.first_Label.text = self.giftDetailDict[@"Theme"];
        return self.firstCell;
        
    } else if (indexPath.row == 1) {
        [self.second_imageView setImageWithURL:[NSURL URLWithString:self.giftDetailDict[@"Image"]]];
        return self.secondCell;
        
    } else if (indexPath.row == 2) {
        self.third_label.text = self.giftDetailDict[@"NeedIdot"];
        return self.thirdCell;
        
    } else if (indexPath.row == 3) {
        NSString *text = self.giftDetailDict[@"Introduce"];
        CGFloat height = [self getHeightByString:text font:14 width:self.fourth_label.frame.size.width];
        
        CGRect frame = self.fourth_label.frame;
        frame.size.height = height;
        self.fourth_label.frame = frame;
        
        self.fourth_label.text = text;
        return self.fourthCell;
        
    } else if (indexPath.row == 4) {
        return self.fifthCell;
    } else if (indexPath.row == 5) {
        NSString *text = self.giftDetailDict[@"Activenotes"];
        CGFloat height = [self getHeightByString:text font:14 width:self.sixth_label.frame.size.width];
        CGRect frame = self.sixth_label.frame;
        frame.size.height = height;
        self.sixth_label.frame = frame;
        
        self.sixth_label.text = text;
        return self.sixthCell;
        
    } else if (indexPath.row == 6) {
        return self.seventhCell;
    } else if (indexPath.row == 7) {
        NSString *text = self.giftDetailDict[@"Changenotes"];
        CGFloat height = [self getHeightByString:text font:14 width:self.eigth_label.frame.size.width];
        CGRect frame = self.eigth_label.frame;
        frame.size.height = height;
        self.eigth_label.frame = frame;
        
        self.eigth_label.text = text;
        return self.eighthCell;
    }
    
    return self.fifthCell;
}

- (IBAction)exchangeCommit:(id)sender {
    /*uid	字符串	用户ID
     code	字符串	兑换码
     numbers	整型	兑换数量
     version	字符串	版本号*/
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *userInfoDict = [USERDEFAULT objectForKey:USERINFO];
    NSString *uid = userInfoDict[kUserId] == nil ? @"001" : userInfoDict[kUserId];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:[Tools getAppVersion] forKey:@"version"];
    [paramDict setObject:uid forKey:@"uid"];
    [paramDict setObject:self.giftCode forKey:@"code"];
    [paramDict setObject:[NSNumber numberWithInt:1] forKey:@"numbers"];
    
    self.giftDetailRequest = [[SoapRequest alloc] init];
    __weak typeof(&*self) weakSelf = self;
    [self.giftDetailRequest postRequestWithSoapNamespace:@"Exchange" params:paramDict successBlock:^(id result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.giftDetailRequest = nil;
        DLog(@"exchange result ＝ %@", result);
        [weakSelf parseExchangeData:result];
        
    } failureBlock:^(NSString *requestError) {
        SHOW_BAD_NETWORK_TOAST(weakSelf.view);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.giftDetailRequest = nil;
        
    } errorBlock:^(NSMutableString *errorStr) {
        [weakSelf.view makeToast:errorStr];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.giftDetailRequest = nil;
    }];
}

- (void)parseExchangeData:(id)result
{/*Msg	返回结果标识：
  -1：表示兑换失败，原因积分不够；
  0：表示兑换失败，原因兑换码错误；
  1：兑换成功
  Name	兑换主题
  Number	兑换数量
  Idot	消耗积分值
*/
    NSDictionary *resultDict = result;
    if ([resultDict[@"Msg"] isEqualToString:@"-1"]) {
        [self.view makeToast:@"积分不够, 兑换失败" duration:2.5 position:@"center"];
    } else if ([resultDict[@"Msg"] isEqualToString:@"0"]) {
        [self.view makeToast:@"兑换码错误, 兑换失败" duration:2.5 position:@"center"];
    } else if ([resultDict[@"Msg"] isEqualToString:@"1"]) {
        [self.view makeToast:@"兑换成功" duration:1.8 position:@"center"];
        [self performSelector:@selector(clickedBack:) withObject:nil afterDelay:1.2];
    }
}

- (void)clickedBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
