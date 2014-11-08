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
    DLog(@"segmentControl.selectedIndex = %d", segmentControl.selectedSegmentIndex);
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
            }
            /************ 未确定在当前界面积分，还是跳下一界面积分 ************/
            //[self jumpToNextPage];
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
        case 251: //顾客电话选择
        {
           //TODO: 跳到VIP通讯录
            [self.view makeToast:@"跳到VIP通讯录"];
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
    if ( ! [Utils isValidMobile:self.mobileTextField.text]) {
        [self.view makeToast:@"请输入正确的手机号"];
        return;
    }
    NSDictionary *userInfoDict = [USERDEFAULT objectForKey:USERINFO];
    NSString *uid = userInfoDict[kUserId] == nil ? @"001" : userInfoDict[kUserId];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:uid forKey:@"uid"];
    [paramDict setObject:[NSNumber numberWithInt:0] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:100] forKey:@"row"];
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

#pragma mark - PopListViewDelegate
- (void)popListView:(PopListView *)popListView didSelectedIndex:(NSInteger)index
{
    self.brandTextField.text = self.brandNameArray[index];
    self.brandIndex = index;
}

#pragma mark - Jump to next page
- (void)jumpToNextPage
{
    if (self.queryType == QueryBarCodeIntegrationType) { //积分，跳到积分结果
        IntegrationBarResultController *integrationController = [[IntegrationBarResultController alloc] initWithNibName:@"IntegrationBarResultController" bundle:nil];
        integrationController.barString = self.barcodeTextField.text;
        integrationController.brandId = self.brandIdArray[self.brandIndex];
        integrationController.isFromInput = YES;
        integrationController.phone = self.mobileTextField.text;
        
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
