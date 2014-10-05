//
//  InputBarcodeController.m
//  GoldMine
//
//  Created by Dongfuming on 14-9-20.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "InputBarcodeController.h"

@interface InputBarcodeController ()

@property (weak, nonatomic) IBOutlet UITextField *barcodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *integrationButton;
@property (weak, nonatomic) IBOutlet UIButton *queryButton;

@property (nonatomic, strong) SoapRequest *barcodeRequest;

@end

@implementation InputBarcodeController

#pragma mark - Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _bNeedShowBackBarButtonItem = YES;
        self.title = @"扫一扫";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setup];
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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - Private methods
- (IBAction)closeKeyboard:(id)sender {
    [self.barcodeTextField resignFirstResponder];
}

- (void)setup
{
    self.view.backgroundColor = [Utils colorWithHexString:@"F2F3F0"];
}

#pragma mark - Button events
- (IBAction)buttonEvents:(UIButton *)sender {
    switch (sender.tag) {
        case 250: //确定
        {
            [self queryBarcodeInfo];
        }
            break;
        case 251: //切换扫描
        {
            [self.navigationController popViewControllerAnimated:NO];
            if (self.jumpToScanBlock) {
                self.jumpToScanBlock();
            }
        }
            break;
        case 252: //取消
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)queryBarcodeInfo
{
    if (self.barcodeTextField.text.length == 0) {
        [self.view makeToast:@"请输入条码"];
        return;
    }
    
    if ( ! [Utils isValidMobile:self.barcodeTextField.text]) {
        [self.view makeToast:@"请输入条码数字"];
        return;
    }
    
    [self requestDataOfBarcode];
}

#pragma mark - Request data
- (void)requestDataOfBarcode
{
    //TODO: 暂无查询条码信息接口
}


#pragma mark - Override
- (void)clickedBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
