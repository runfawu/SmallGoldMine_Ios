//
//  ResetPwdController.m
//  GoldMine
//
//  Created by Oliver on 14-10-18.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "ResetPwdController.h"

@interface ResetPwdController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *newerPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;

@property (nonatomic, strong) SoapRequest *commitRequest;

@end

@implementation ResetPwdController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _bNeedShowBackBarButtonItem = YES;
        self.title = @"修改密码";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = GRAY_COLOR;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (IBAction)closeKeyboard:(id)sender {
    [self.oldPwdTextField resignFirstResponder];
    [self.newerPwdTextField resignFirstResponder];
    [self.confirmTextField resignFirstResponder];
}


- (IBAction)commit:(id)sender {
    [self closeKeyboard:nil];
    
    if (self.oldPwdTextField.text.length == 0) {
        [self.view makeToast:@"请输入当前密码"];
        return;
    } else if (self.newerPwdTextField.text.length == 0) {
        [self.view makeToast:@"请输入新密码"];
        return;
    } else if (self.confirmTextField.text.length == 0) {
        [self.view makeToast:@"请输入确认密码"];
        return;
    } else if ( ! [self.confirmTextField.text isEqualToString:self.newerPwdTextField.text]) {
        [self.view makeToast:@"两次输入的密码不一致,请重新输入"];
        return;
    }
    
    //TODO:commit request
}


@end
