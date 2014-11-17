//
//  InputBarcodeController.m
//  GoldMine
//
//  Created by Dongfuming on 14-9-20.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "InputBarcodeController.h"
#import "GoodsBarResultController.h"
#import "IntegrationBarResultController.h"
#import "PopListView.h"
#import "VIPAddressBookViewController.h"

@interface InputBarcodeController ()<UITextFieldDelegate, PopListViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *barcodeTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIView *mobileView;
@property (weak, nonatomic) IBOutlet UITextField *brandTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;

@property (nonatomic, strong) SoapRequest *brandRequest;
@property (nonatomic, strong) PopListView *popListView;
@property (nonatomic, strong) NSMutableArray *brandNameArray;
@property (nonatomic, strong) NSMutableArray *brandIdArray;
@property (nonatomic, assign) NSInteger brandIndex;
@property (nonatomic, strong) NSString *brandId;
@property (nonatomic, strong) SoapRequest *integrationRequest;

@end

@implementation InputBarcodeController

#pragma mark - Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _bNeedShowBackBarButtonItem = YES;
        self.title = @"扫一扫";
        self.queryType = QueryBarCodeIntegrationType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setup];
    [self requestBrandData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.barString.length > 0) {
        self.barcodeTextField.text = self.barString;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.queryType == QueryBarCodeIntegrationType) {
        self.segmentedControl.selectedSegmentIndex = 0;
    } else if (self.queryType == QueryBarCodeGoodType) {
        self.segmentedControl.selectedSegmentIndex = 1;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - Private methods
- (void)setup
{
    self.brandNameArray = [NSMutableArray array];
    self.brandIdArray = [NSMutableArray array];
    self.view.backgroundColor = [Utils colorWithHexString:@"F2F3F0"];
    
    NSDictionary *attrDict = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
    [self.segmentedControl setTitleTextAttributes:attrDict forState:UIControlStateNormal];
}

- (IBAction)segmentedControlValueChanged:(id)sender {
    UISegmentedControl *segmentControl = sender;
    DLog(@"segmentControl.selectedIndex = %d", (int)segmentControl.selectedSegmentIndex);
    if (segmentControl.selectedSegmentIndex == 0) { //积分
        self.mobileView.hidden = NO;
    } else if (segmentControl.selectedSegmentIndex == 1) { //查询
        self.mobileView.hidden = YES;
    }
}

#pragma mark - TextField
- (IBAction)closeKeyboard:(id)sender {
    [self.barcodeTextField resignFirstResponder];
    [self.mobileTextField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.brandTextField]) {
        
        return NO;
    }
    
    return YES;
}

#pragma mark - Button events
- (IBAction)buttonEvents:(UIButton *)sender {
    switch (sender.tag) {
        case 253: //确定
        {
            if (self.barcodeTextField.text.length == 0) {
                [self.view makeToast:@"请输入商品条码"];
                return;
            } else if (self.brandTextField.text.length == 0) {
                [self.view makeToast:@"请选择品牌"];
                return;
            }
            /* 积分情况下，在当前页面请求；查询情况下，跳转下一界面 */
            if (self.queryType == QueryBarCodeIntegrationType) {
                if (self.mobileTextField.text.length == 0) {
                    [self.view makeToast:@"请输入顾客电话"];
                    return;
                } else if ( ! [Utils isValidMobile:self.mobileTextField.text]) {
                    [self.view makeToast:@"请输入正确的电话号码"];
                    return;
                }
                [self requestDataOfIntegration];
                
            } else if (self.queryType == QueryBarCodeGoodType) {
                GoodsBarResultController *goodsController = [[GoodsBarResultController alloc] initWithNibName:@"GoodsBarResultController" bundle:nil];
                goodsController.barString = self.barcodeTextField.text;
                
                [self.navigationController pushViewController:goodsController animated:YES];
            }
        }
            break;
        case 252: //切换扫描
        {
            [self.navigationController popViewControllerAnimated:NO];
            if (self.jumpToScanBlock) {
                self.jumpToScanBlock();
            }
        }
            break;
        case 251: //顾客电话选择, 跳到VIP通讯录
        {
            VIPAddressBookViewController *vipAddressController = [[VIPAddressBookViewController alloc] initWithNibName:@"VIPAddressBookViewController" bundle:nil];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vipAddressController];
            vipAddressController.comeFromInputPage = YES;
            __weak typeof(&*self) weakSelf = self;
            vipAddressController.renderPhoneBlock = ^(NSString *phone) {
                weakSelf.mobileTextField.text = phone;
            };
            [self presentViewController:navi animated:YES completion:nil];
        }
            break;
        case 250: //品牌选择
        {
            [self createPopListView];
        }
            break;
        default:
            break;
    }
}

- (void)createPopListView
{
    if (self.brandNameArray.count > 0) {
        if (self.popListView == nil) {
            self.popListView = [[PopListView alloc] initWithTitle:@"品牌列表" listArray:self.brandNameArray];
            self.popListView.delegate = self;
            [self.popListView showInView:self.view animated:YES];
        } else {
            [self.popListView showInView:self.view animated:YES];
        }
    } else {
        [self.view makeToast:@"暂无品牌信息"];
    }
}
#pragma mark - Request data
- (void)requestBrandData
{
    NSDictionary *userInfoDict = [USERDEFAULT objectForKey:USERINFO];
    NSString *uid = userInfoDict[kUserId] == nil ? @"001" : userInfoDict[kUserId];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:uid forKey:@"uid"];
    [paramDict setObject:[NSNumber numberWithInt:0] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:1000] forKey:@"row"];
    [paramDict setObject:[Tools getAppVersion] forKey:@"version"];
    
    __weak __typeof(&*self)weakSelf = self;
   self.brandRequest = [[SoapRequest alloc] init];
    [self.brandRequest postRequestWithSoapNamespace:@"getBrandList" params:paramDict successBlock:^(id result) {
        DLog(@"getBrandList success result = %@", result);
        weakSelf.brandRequest = nil;
        NSDictionary *resultDict = result;
        NSArray *dataArray = resultDict[@"Brands"];
        if ( ! [dataArray isKindOfClass:[NSNull class]] && dataArray.count > 0) {
            for (NSDictionary *dict in dataArray) {
                NSString *brandName = dict[@"BardName"];
                NSString *brandId = dict[@"BardID"];
                [self.brandNameArray addObject:brandName];
                [self.brandIdArray addObject:brandId];
            }
        }
    } failureBlock:^(NSString *requestError) {
        weakSelf.brandRequest = nil;
        //SHOW_BAD_NETWORK_TOAST(weakSelf.view);
        
    } errorBlock:^(NSMutableString *errorStr) {
        weakSelf.brandRequest = nil;
        //[weakSelf.view makeToast:errorStr];
    }];
}

/*2、扫描一维或者手动输入积分码积分
 OneIntegrated(string uid, string code, string bid, string phone, string version)
 该方法用于扫描一维码或者手动输入积分码积分
 参数解释：
 参数名	参数类型	参数说明
 uid	字符串	用户ID
 code	字符串	单数字的积分码
 bid	字符串	品牌ID
 phone	字符串	VIP手机号码
 version	字符串	版本号
 
 返回值：
 {"Msg":"","Idot":"","IsVip":""}
 返回值参数说明
 参数名	参数说明
 Msg	返回结果标识：
 -3：表示积分失败，原因该积分码已被别的号码积过分；
 -2：表示积分失败，原因该积分码已经被该号码积过分；
 -1：表示积分失败，原因该积分码不存在或者销售记录中没有该积分码；
 0：表示积分失败；
 1：表示积分成功；
 2：表示新客积分成功；
 Idot	积分值：积分失败为0
 IsVip	是否为用户的VIP：0否，1是
*/
- (void)requestDataOfIntegration
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *userInfoDict = [USERDEFAULT objectForKey:USERINFO];
    NSString *uid = userInfoDict[kUserId] == nil ? @"001" : userInfoDict[kUserId];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:self.barcodeTextField.text forKey:@"code"];
    [paramDict setObject:[Tools getAppVersion] forKey:@"version"];
    [paramDict setObject:uid forKey:@"uid"];
    [paramDict setObject:self.brandIdArray[self.brandIndex] forKey:@"bid"];
    [paramDict setObject:self.mobileTextField.text forKey:@"phone"];
    
    self.integrationRequest = [[SoapRequest alloc] init];
    __weak typeof(&*self) weakSelf = self;
    [self.integrationRequest postRequestWithSoapNamespace:@"OneIntegrated" params:paramDict successBlock:^(id result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.integrationRequest = nil;
        DLog(@"积分详情 ＝ %@", result);
        [weakSelf parseDataOfIntegration:result];
        
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

- (void)parseDataOfIntegration:(id)result
{
    NSDictionary *resultDict = (NSDictionary *)result;
    if ([Utils isValidResult:resultDict]) {
        [self.view makeToast:@"积分成功"];
        //[self performSelector:@selector(clickedBack:) withObject:nil afterDelay:1.5];
        
    } else if ([resultDict[@"Msg"] isEqualToString:@"-1"]) {
        [self.view makeToast:@"积分失败,该积分码不存在或者销售记录中没有该积分码"];
        //self performSelector:@selector(clickedBack:) withObject:nil afterDelay:2];
        
    } else if ([resultDict[@"Msg"] isEqualToString:@"-2"]) {
        [self.view makeToast:@"积分失败,该积分码已经被积分"];
        //[self performSelector:@selector(clickedBack:) withObject:nil afterDelay:2];
        
    }  else if ([resultDict[@"Msg"] isEqualToString:@"-3"]) {
        [self.view makeToast:@"积分失败,该积分码的产品不是VIP号码购买的"];
        //[self performSelector:@selector(clickedBack:) withObject:nil afterDelay:2];
        
    } else if ([resultDict[@"Msg"] isEqualToString:@"0"]) {
        [self.view makeToast:@"积分失败,该VIP号码还未添加注册"];
        //[self performSelector:@selector(clickedBack:) withObject:nil afterDelay:2];
        
    } else if ([resultDict[@"Msg"] isEqualToString:@"2"]) {
        [self.view makeToast:@"新客积分成功"];

        if ([resultDict[@"IsVip"] isEqualToString:@"0"]) {
            double delayInSeconds = 1.2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"您还不是我的VIP, 是否愿意成为我的Vip。"
                                                               delegate:self
                                                      cancelButtonTitle:@"否"
                                                      otherButtonTitles:@"是", nil];
                [alert show];
            });
        }
    }
}

#pragma mark - UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { //否
        
    } else if (buttonIndex == 1) { //是
        //TODO:跳到添加VIP界面。
        [self.view makeToast:@"跳到添加VIP界面"];
    }
}

#pragma mark - PopListViewDelegate
- (void)popListView:(PopListView *)popListView didSelectedIndex:(NSInteger)index
{
    self.brandTextField.text = self.brandNameArray[index];
    self.brandIndex = index;
}

#pragma mark - Override
- (void)clickedBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
