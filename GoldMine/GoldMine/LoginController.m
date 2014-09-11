//
//  LoginController.m
//  GoldMine
//
//  Created by Oliver on 14-9-11.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()

@property (nonatomic, strong) SoapRequest *loginReqeust;

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
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CFIndex selfRetainCount = CFGetRetainCount((__bridge typeof(CFTypeRef))self);
    DLog(@"login retainCount = %lu", selfRetainCount);
}

#pragma mark - Button events
- (IBAction)login:(id)sender {
    
    NSString *userName = @"001";
    NSString *password = @"123456";
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userName forKey:@"uid"];
    [paramDict setObject:password forKey:@"pwd"];
    
    self.loginReqeust = [[SoapRequest alloc] init];
    [self.loginReqeust postRequestWithSoapNamespace:@"UserLogin" params:paramDict successBlock:^(id result) {
        DLog(@"login success result = %@", result);
        __weak typeof(self) weakSelf = self; // 我擦这两行代码怎么没效果？？？
        [weakSelf doTheSuccessJobWithReuslt:result];
        //[weakSelf hideHUD];
        
    } failureBlock:^(NSString *requestError) {
        //[weakSelf hideHUD];
        //[weakSelf.view showToast:........
        
    } errorBlock:^(NSMutableString *errorStr) {
        //[weakSelf hideHUD];
        //[weakSelf.view showToast:........
    }];
    
}

- (IBAction)back:(id)sender {
    CFIndex selfRetainCount = CFGetRetainCount((__bridge typeof(CFTypeRef))self);
    DLog(@"login retainCount = %lu", selfRetainCount); //本来要 ＝ 3的
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)doTheSuccessJobWithReuslt:(id)result
{
    NSDictionary *resultDict = (NSDictionary *)result;
    DLog(@"丧心病狂");
}

@end
