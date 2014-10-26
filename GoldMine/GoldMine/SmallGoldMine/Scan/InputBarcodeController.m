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

@interface InputBarcodeController ()

@property (weak, nonatomic) IBOutlet UITextField *barcodeTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic, strong) SoapRequest *queryRequest;

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
- (IBAction)closeKeyboard:(id)sender {
    [self.barcodeTextField resignFirstResponder];
}

- (void)setup
{
    self.view.backgroundColor = [Utils colorWithHexString:@"F2F3F0"];
    
    self.queryRequest = [[SoapRequest alloc] init];
    
    NSDictionary *attrDict = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
    [self.segmentedControl setTitleTextAttributes:attrDict forState:UIControlStateNormal];
}

- (IBAction)segmentedControlValueChanged:(id)sender {
    
}


#pragma mark - Button events
- (IBAction)buttonEvents:(UIButton *)sender {
    switch (sender.tag) {
        case 250: //确定
        {
            if (self.barcodeTextField.text.length == 0) {
                [self.view makeToast:@"请输入条码"];
                return;
            }
            [self jumpToNextPage];
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

#pragma mark - Jump to next page
- (void)jumpToNextPage
{
    if (self.queryType == QueryBarCodeIntegrationType) { //积分，跳到积分结果
        IntegrationBarResultController *integrationController = [[IntegrationBarResultController alloc] initWithNibName:@"IntegrationBarResultController" bundle:nil];
        integrationController.barString = @"1010010010000005"; //self.barcodeTextField.text;
        
        [self.navigationController pushViewController:integrationController animated:YES];
    } else if (self.queryType == QueryBarCodeGoodType) { //查询，跳到商品结果
        GoodsBarResultController *goodsController = [[GoodsBarResultController alloc] initWithNibName:@"GoodsBarResultController" bundle:nil];
        goodsController.barString = @"1010010010000001"; //self.barcodeTextField.text;
        
        [self.navigationController pushViewController:goodsController animated:YES];
    }
}



#pragma mark - Override
- (void)clickedBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
