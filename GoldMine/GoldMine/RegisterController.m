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

- (void)requestDataOfRegister
{
//    self.registerRequest = [[SoapRequest alloc] init];
    //TODO: 暂未开放注册接口
}

//TODO: 注册成功跳到填写资料界面
- (void)jumpToCompletePersonalInfo
{
    PersonalInfoController *infoController = [[PersonalInfoController alloc] initWithNibName:@"PersonalInfoController" bundle:nil];
    [self.navigationController pushViewController:infoController animated:YES];
}

#pragma mark - Button events
- (IBAction)getVerifyCode:(UIButton *)sender {
    if ([self isValidMobile]) {
        [self countDown:sender];
        [self requestDataOfVerifyCode];
    }
}

- (IBAction)registerNewAccount:(id)sender {
//    if ([self isValidMobile]) {
//        if (self.passwordTextField.text.length == 0) {
//            [self.view makeToast:@"请填写密码"];
//            return;
//        } else if (self.confirmTextField.text.length == 0) {
//            [self.view makeToast:@"请再次填写密码"];
//            return;
//        } else if ( ! [self.confirmTextField.text isEqualToString:self.passwordTextField.text]) {
//            [self.view makeToast:@"两次输入的密码不一致"];
//            return;
//        }
//        
//        [self requestDataOfRegister];
//    }
    [self jumpToCompletePersonalInfo];
}


#pragma mark - Override
- (void)clickedBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
