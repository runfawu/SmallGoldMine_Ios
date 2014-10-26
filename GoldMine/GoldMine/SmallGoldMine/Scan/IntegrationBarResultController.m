//
//  IntegrationBarResultController.m
//  GoldMine
//
//  Created by Oliver on 14-9-28.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "IntegrationBarResultController.h"
#import "UIImageView+WebCache.h"

@interface IntegrationBarResultController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *integrationValueLabel;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;

@property (nonatomic, strong) SoapRequest *productInfoRequest;
@property (nonatomic, strong) SoapRequest *integrationRequest;

@end

@implementation IntegrationBarResultController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _bNeedShowBackBarButtonItem = YES;
        self.title = @"扫描积分";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self requestDataOfProductInfo];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:tapGesture];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 568);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)didTappedBackground:(UITapGestureRecognizer *)tapGesture
{
    [self.mobileTextField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (iPhone4) {
        [self.scrollView setContentOffset:CGPointMake(0, 150) animated:YES];
    }
    return YES;
}


#pragma mark - Request data
- (void)requestDataOfProductInfo
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:self.barString forKey:@"code"];
    [paramDict setObject:[Tools getAppVersion] forKey:@"version"];
    
    self.productInfoRequest = [[SoapRequest alloc] init];
    __weak typeof(&*self) weakSelf = self;
    [self.productInfoRequest postRequestWithSoapNamespace:@"getScanResult" params:paramDict successBlock:^(id result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.productInfoRequest = nil;
        DLog(@"积分详情 ＝ %@", result);
        [weakSelf updateUIWithResult:result];
        
    } failureBlock:^(NSString *requestError) {
        SHOW_BAD_NETWORK_TOAST(weakSelf.view);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.productInfoRequest = nil;
        
    } errorBlock:^(NSMutableString *errorStr) {
        [weakSelf.view makeToast:errorStr];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.productInfoRequest = nil;
    }];
}

- (void)parseDataOfIntegrationCode:(id)result
{
    NSDictionary *resultDict = (NSDictionary *)result;
    if ([Utils isValidResult:resultDict]) {
        [self.view makeToast:@"积分成功"];
        [self performSelector:@selector(clickedBack:) withObject:nil afterDelay:1.5];
        
    } else if ([resultDict[@"Msg"] isEqualToString:@"-1"]) {
        [self.view makeToast:@"积分失败,该积分码不存在或者销售记录中没有该积分码"];
        [self performSelector:@selector(clickedBack:) withObject:nil afterDelay:2];
        
    } else if ([resultDict[@"Msg"] isEqualToString:@"0"]) {
        [self.view makeToast:@"积分失败,该VIP号码还未添加注册"];
        [self performSelector:@selector(clickedBack:) withObject:nil afterDelay:2];
        
    } else if ([resultDict[@"Msg"] isEqualToString:@"-2"]) {
        [self.view makeToast:@"积分失败,该积分码已经被积分"];
        [self performSelector:@selector(clickedBack:) withObject:nil afterDelay:2];
        
    }  else if ([resultDict[@"Msg"] isEqualToString:@"-3"]) {
        [self.view makeToast:@"积分失败,该积分码的产品不是VIP号码购买的"];
        [self performSelector:@selector(clickedBack:) withObject:nil afterDelay:2];
    }
}

- (void)requestDataOfIntegrationCode
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *userInfoDict = [USERDEFAULT objectForKey:USERINFO];
    NSString *uid = userInfoDict[kUserId] == nil ? @"001" : userInfoDict[kUserId];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:self.barString forKey:@"code"];
    [paramDict setObject:[Tools getAppVersion] forKey:@"version"];
    [paramDict setObject:self.mobileTextField.text forKey:@"phone"];
    [paramDict setObject:uid forKey:@"uid"];
    
    self.integrationRequest = [[SoapRequest alloc] init];
    __weak typeof(&*self) weakSelf = self;
    [self.integrationRequest postRequestWithSoapNamespace:@"Integrated" params:paramDict successBlock:^(id result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.integrationRequest = nil;
        DLog(@"扫描的积分码详情 ＝ %@", result);
        [weakSelf parseDataOfIntegrationCode:result];
        
    } failureBlock:^(NSString *requestError) {
        SHOW_BAD_NETWORK_TOAST(weakSelf.view);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.integrationRequest = nil;
        
    } errorBlock:^(NSMutableString *errorStr) {
        [weakSelf.view makeToast:errorStr];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.integrationRequest = nil;
    }];
}

- (void)updateUIWithResult:(id)result
{
    NSDictionary *resultDict = (NSDictionary *)result;
    if ([Utils isValidResult:resultDict]) {
        self.productNameLabel.text = resultDict[@"ProName"];
        [self.productImageView setImageWithURL:[NSURL URLWithString:resultDict[@"ProImg"]] placeholderImage:[UIImage imageNamed:@"logo_icon"]];
        self.integrationValueLabel.text = [NSString stringWithFormat:@"积分值: %@分", resultDict[@"Idot"]];
        
    } else if ([resultDict[@"Msg"] isEqualToString:@"-1"]) {
        [self.view makeToast:@"此积分码已积过分"];
        [self performSelector:@selector(clickedBack:) withObject:nil afterDelay:1.5];
    } else {
        [self.view makeToast:@"积分码不存在"];
        [self performSelector:@selector(clickedBack:) withObject:nil afterDelay:1.5];
    }
}

#pragma mark - Button events
- (IBAction)selectCustomMobilePhone:(id)sender {
    //TODO: 跳到小伙伴(通讯录)界面,选择后填充textField
}

- (IBAction)confirmIntegration:(id)sender {
    if (self.mobileTextField.text.length == 0) {
        [self.view makeToast:@"请填写或选择顾客电话"];
        return;
    } else if ( ! [Utils isValidMobile:self.mobileTextField.text]) {
        [self.view makeToast:@"请填写或选择有效顾客电话"];
        return;
    }
    
    [self requestDataOfIntegrationCode];
}


#pragma mark - Override
- (void)clickedBack:(id)sender
{
    [super clickedBack:sender];
}

@end
