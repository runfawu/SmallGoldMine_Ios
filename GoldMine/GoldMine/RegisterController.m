//
//  RegisterController.m
//  GoldMine
//
//  Created by Dongfuming on 14-9-20.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "RegisterController.h"
#import "PersonalInfoController.h"

@interface RegisterController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;
@property (weak, nonatomic) IBOutlet UIButton *verifyCodeButton;
@property (weak, nonatomic) IBOutlet UIView *verifyView;

@property (nonatomic, strong) SoapRequest *verifyCodeRequest;
@property (nonatomic, strong) SoapRequest *registerRequest;

@end

@implementation RegisterController

#pragma mark -Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _bNeedShowBackBarButtonItem = YES;
        self.title = @"欢迎注册";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [Utils colorWithHexString:@"F2F3F0"];
    self.verifyCodeButton.hidden = YES;
    self.verifyView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - Private methods
- (IBAction)UIControlHideKeyboard:(id)sender {
    [self.mobileTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.confirmTextField resignFirstResponder];
    [self.verifyTextField resignFirstResponder];
    
    CGRect frame = self.view.frame;
    frame.origin.y = 64;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = frame;
    }];
}

- (IBAction)textFieldReturn:(UITextField *)sender {
    [self UIControlHideKeyboard:sender];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.verifyTextField == textField) {
        if (iPhone4) {
            CGRect frame = self.view.frame;
            frame.origin.y = -20;
            [UIView animateWithDuration:0.25 animations:^{
                self.view.frame = frame;
            }];
        }
    }
    
    return YES;
}

- (BOOL)isValidMobile
{
    if (self.mobileTextField.text.length == 0) {
        [self.view makeToast:@"请填写手机号"];
        return NO;
    } else if ( ! [Utils isValidMobile:self.mobileTextField.text]) {
        [self.view makeToast:@"请填写正确的手机号"];
        return NO;
    }
    
    return YES;
}

- (void)countDown:(UIButton *)button
{
    __block int timeout = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(timer, ^{
        if(timeout <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               [button setTitle:@"点击获取" forState:UIControlStateNormal];
                               button.userInteractionEnabled = YES;
                           });
        } else {
            int seconds = timeout % 61;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                NSString *title = [NSString stringWithFormat:@"%@秒",strTime];
                [button setTitle:title forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(timer);
}

#pragma mark - Request data
- (void)requestDataOfVerifyCode
{
//    self.verifyCodeRequest = [[SoapRequest alloc] init];
    //TODO: 暂未开放获取验证码接口
}

/*
 33、用户注册
 Register(string phone, string pwd, string version)
 该方法用于用户手机号码注册
 参数解释：
 参数名	参数类型	参数说明
 phone	字符串	手机号码
 pwd	字符串	密码
 version	字符串	版本号
 
 返回值：
 {"Msg":""}
 返回值参数说明
 参数名	参数说明
 Msg	返回结果标识：
 0：表示注册失败，原因该手机号码已经被注册过；
 1：表示注册成功；

*/
- (void)requestDataOfRegister
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *userName = self.mobileTextField.text;
    NSString *password = self.confirmTextField.text;
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userName forKey:@"phone"];
    [paramDict setObject:password forKey:@"pwd"];
    [paramDict setObject:[Tools getAppVersion] forKey:@"version"];
    
    __weak __typeof(&*self)weakSelf = self;
    self.registerRequest = [[SoapRequest alloc] init];
    [self.registerRequest postRequestWithSoapNamespace:@"Register" params:paramDict successBlock:^(id result) {
        DLog(@"register success result = %@", result);
        weakSelf.registerRequest = nil;
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        NSDictionary *resultDict = result;
        if ([resultDict[@"Msg"] isEqualToString:@"0"]) {
            [weakSelf.view makeToast:@"注册失败，该手机号码已经被注册过."];
            
        } else if ([resultDict[@"Msg"] isEqualToString:@"1"]) {
            [weakSelf.view makeToast:@"注册成功"];
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    PersonalInfoController *infoController = [[PersonalInfoController alloc] initWithNibName:@"PersonalInfoController" bundle:nil];
                    infoController.userId = resultDict[@"UserID"];
                    [weakSelf.navigationController pushViewController:infoController animated:YES];
                });
            
        } else {
            [weakSelf.view makeToast:@"注册失败"];
        }
        
    } failureBlock:^(NSString *requestError) {
        weakSelf.registerRequest = nil;
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        SHOW_BAD_NETWORK_TOAST(weakSelf.view);
        
    } errorBlock:^(NSMutableString *errorStr) {
        weakSelf.registerRequest = nil;
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.view makeToast:errorStr];
    }];
}

//TODO: 注册成功跳到填写资料界面
- (void)jumpToCompletePersonalInfo
{
    PersonalInfoController *infoController = [[PersonalInfoController alloc] initWithNibName:@"PersonalInfoController" bundle:nil];
    [self.navigationController pushViewController:infoController animated:YES];
}

#pragma mark - Button events
- (IBAction)getVerifyCode:(UIButton *)sender {
//    if ([self isValidMobile]) {
//        [self countDown:sender];
//        [self requestDataOfVerifyCode];
//    }
}

- (IBAction)registerNewAccount:(id)sender {
    if ([self isValidMobile]) {
        if (self.passwordTextField.text.length == 0) {
            [self.view makeToast:@"请填写密码"];
            return;
        } else if (self.confirmTextField.text.length == 0) {
            [self.view makeToast:@"请再次填写密码"];
            return;
        } else if ( ! [self.confirmTextField.text isEqualToString:self.passwordTextField.text]) {
            [self.view makeToast:@"两次输入的密码不一致"];
            return;
        }
//        else if ( self.verifyTextField.text.length == 0) {
//            [self.view makeToast:@"请填写短信验证码"];
//            return;
//        }
        
        [self requestDataOfRegister];
    }
}


#pragma mark - Override
- (void)clickedBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
