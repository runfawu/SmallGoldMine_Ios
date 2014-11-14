//
//  LoginController.m
//  GoldMine
//
//  Created by Oliver on 14-9-11.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "LoginController.h"
#import "RegisterController.h"

@interface LoginController ()

@property (nonatomic, strong) SoapRequest *loginReqeust;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginController

#pragma mark - Lifecycle
- (void)dealloc
{
    DLog(@"login dealloc");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    self.loginReqeust = [[SoapRequest alloc] init];
    
    [super viewDidLoad];
    DLog(@"0912 上午测试");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.userNameTextField.text = @"001";
    self.passwordTextField.text = @"123456";
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - TextField && Keyboard
- (IBAction)textFieldReturn:(UITextField *)sender {
    [self UIControlHideKeyboard:sender];
}

- (IBAction)UIControlHideKeyboard:(id)sender {
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}


#pragma mark - Button events
- (IBAction)login:(id)sender {
    [self theLoginCode];
}

- (IBAction)registerNewAccount:(id)sender {
    RegisterController *registerController = [[RegisterController alloc] initWithNibName:@"RegisterController" bundle:nil];
    
    [self.navigationController pushViewController:registerController animated:YES];
}

- (void)theLoginCode
{
    if (self.userNameTextField.text.length == 0) {
        [self.view makeToast:@"请输入手机号"];
        return;
    }
    
    if (self.passwordTextField.text.length == 0) {
        [self.view makeToast:@"请输入密码"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *userName = self.userNameTextField.text;
    NSString *password = self.passwordTextField.text;

    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userName forKey:@"uid"];
    [paramDict setObject:password forKey:@"pwd"];
    [paramDict setObject:[Tools getAppVersion] forKey:@"version"];
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self.loginReqeust postRequestWithSoapNamespace:@"UserLogin" params:paramDict successBlock:^(id result) {
        DLog(@"login success result = %@", result);
        weakSelf.loginReqeust = nil;
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf parseDataWithResult:result];
        
    } failureBlock:^(NSString *requestError) {
        weakSelf.loginReqeust = nil;
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        SHOW_BAD_NETWORK_TOAST(weakSelf.view);
        
    } errorBlock:^(NSMutableString *errorStr) {
        weakSelf.loginReqeust = nil;
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.view makeToast:errorStr];
    }];

}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Parse data
- (void)parseDataWithResult:(id)result
{
    if (result) {
        NSDictionary *resultDict = result;
        NSString *birthday = resultDict[@"Birthday"];
        NSString *picture = resultDict[@"Picture"];
        NSString *sex = resultDict[@"Sex"];
        NSString *signature = resultDict[@"Signature"];
        NSString *userId = resultDict[@"UserID"];
        NSString *userName = resultDict[@"UserName"];
        NSString *userPhone = resultDict[@"UserPhone"];
        NSString *userType = resultDict[@"UserType"];
        NSString *alipay = resultDict[@"Alipay"];
        NSString *isAuthenticate = resultDict[@"IsAuthenticate"];
        NSString *vBoon = resultDict[@"Vboon"];
        
        NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
        if (birthday) {
            [userDict setObject:birthday forKey:kBirthday];
        }
        if (picture) {
            [userDict setObject:picture forKey:kPicture];
        }
        if (sex) {
            [userDict setObject:sex forKey:kSex];
        }
        if (signature) {
            [userDict setObject:signature forKey:kSignature];
        }
        if (userId) {
            [userDict setObject:userId forKey:kUserId];
        }
        if (userName) {
            [userDict setObject:userName forKey:kUserName];
        }
        if (userPhone) {
            [userDict setObject:userPhone forKey:kUserPhone];
        }
        if (userType) {
            [userDict setObject:userType forKey:kUserType];
        }
        if (alipay) {
            [userDict setObject:alipay forKey:kAlipay];
        }
        if (isAuthenticate) {
            [userDict setObject:isAuthenticate forKey:kIsAuthenticate];
        }
        if (vBoon) {
            [userDict setObject:vBoon forKey:kVBoon];
        }
        [USERDEFAULT setObject:userDict forKey:USERINFO];
        [USERDEFAULT synchronize];
        
        [self dismiss];
    } else {
        [self.view makeToast:@"无用户数据"];
    }
}

@end
