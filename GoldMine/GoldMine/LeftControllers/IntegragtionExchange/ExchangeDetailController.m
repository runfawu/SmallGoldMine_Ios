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
@property (strong, nonatomic) IBOutlet UITableViewCell *titleCell;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableViewCell *exchangeCell;
@property (weak, nonatomic) IBOutlet UILabel *integrationLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (strong, nonatomic) IBOutlet UITableViewCell *stateCell;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIView *embedView;
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;

@property (nonatomic, strong) SoapRequest *giftDetailRequest;
@property (nonatomic, strong) NSDictionary *giftDetailDict;

@end

@implementation ExchangeDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    self.giftDetailDict = [NSDictionary dictionaryWithObjectsAndKeys:@"http://202.91.242.228:7003/Picture/img2/008.jpg", @"Image",
                           @"纽瑞滋金装奶粉1段400g", @"Theme",
                           @"欢迎参加纽瑞滋奶粉兑换活动，本次活动特惠推出纽瑞滋金装奶粉1段400g兑换商品，您只需要花费200个V宝就可以兑换到该商品，数量有限，先抢先得，赶快行动吧！纽瑞滋金装奶粉1段400g", @"Introduce",
                           @"滋金装奶粉1段400g兑换商品，您只需要花费200个V宝就可以兑换到该商品，数量有限，先抢先得，赶快行动吧！纽瑞滋金装奶粉1段400g纽瑞滋金装奶粉1段400g", @"Activenotes",
                           @"您只需要花费200个V宝就可以兑换到该商品，数量有限，先抢先得，赶快行动吧！纽瑞滋金装奶粉1段400g纽瑞滋金装奶粉1段400g您只需要花费200个V宝就可以兑换到该商品，数量有限，先抢先得，赶快行动吧！纽瑞滋金装奶粉1段400g纽瑞滋金装奶粉1段400g纽瑞滋金装奶粉1段400g", @"Changenotes",
                           @"200", @"NeedIdot",
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
    
    
    
//    self.giftDetailDict = (NSDictionary *)result;
//    [self.tableView reloadData];
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
    NSString *Activenotes = self.giftDetailDict[@"Activenotes"];
    NSString *Changenotes = self.giftDetailDict[@"Changenotes"];
    if (Activenotes.length > 0 && Changenotes == nil) {
        return 2;
    }
    if (Activenotes.length > 0 && Changenotes.length > 0) {
        return 3;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 36;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        return [self getHeightByString:self.giftDetailDict[@"Introduce"] font:self.introduceLabel.font.pointSize width:self.introduceLabel.frame.size.width] + 80 + 163;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        return [self getHeightByString:self.giftDetailDict[@"Activenotes"] font:self.stateLabel.font.pointSize width:self.stateLabel.frame.size.width] + 10;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        return [self getHeightByString:self.giftDetailDict[@"Changenotes"] font:self.stateLabel.font.pointSize width:self.stateLabel.frame.size.width] + 10;
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        self.titleLabel.text = self.giftDetailDict[@"Theme"];
        return self.titleCell;
        
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        if (self.giftDetailDict[@"Image"]) {
            [self.giftImageView setImageWithURL:[NSURL URLWithString:self.giftDetailDict[@"Image"]]];
        }
        CGRect frame = self.embedView.frame;
        frame.size.height = [self getHeightByString:self.giftDetailDict[@"Introduce"] font:self.introduceLabel.font.pointSize width:self.introduceLabel.frame.size.width] + 80;
        self.embedView.frame = frame;
        self.integrationLabel.text = self.giftDetailDict[@"NeedIdot"];
        self.introduceLabel.text = self.giftDetailDict[@"Introduce"];
        
        return self.exchangeCell;
        
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        self.titleLabel.text = @"活动说明";
        return self.titleCell;
        
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        CGRect frame = self.stateLabel.frame;
        frame.size.height = [self getHeightByString:self.giftDetailDict[@"Activenotes"] font:self.stateLabel.font.pointSize width:self.stateLabel.frame.size.width];
        self.stateLabel.frame = frame;
        self.stateLabel.text = self.giftDetailDict[@"Activenotes"];
        
        return self.stateCell;
        
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        self.titleLabel.text = @"兑换说明";
        return self.titleCell;
        
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        CGRect frame = self.stateLabel.frame;
        frame.size.height = [self getHeightByString:self.giftDetailDict[@"Changenotes"] font:self.stateLabel.font.pointSize width:self.stateLabel.frame.size.width];
        self.stateLabel.frame = frame;
        self.stateLabel.text = self.giftDetailDict[@"Changenotes"];
        
        return self.stateCell;
    }
    
    
    return self.stateCell;
}

@end
