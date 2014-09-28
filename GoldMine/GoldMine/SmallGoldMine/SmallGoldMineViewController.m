//
//  SmallGoldMineViewController.m
//  GoldMine
//
//  Created by micheal on 14-5-11.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "SmallGoldMineViewController.h"
#import "LoginController.h"
#import "UIViewController+MMDrawerController.h"
#import "InputBarcodeController.h"
#import "VIPDetailedInformationViewController.h"
#import "ZBarSDK.h"
@import AVFoundation;
#import "ScanNaviView.h"
#import "UIButton+Addition.h"
#import "InputBarcodeController.h"
#import "GoodsBarResultController.h"
#import "LoopButton.h"

typedef NS_ENUM(NSInteger, ScanBarType) {
    scanBarIntegrationType = 112,
    ScanBarQueryCodeType,
};

@interface SmallGoldMineViewController ()<UIScrollViewDelegate,TaskViewControllerDelegate, ZBarReaderDelegate>

@property (nonatomic, strong) ZBarReaderViewController *reader;
@property (nonatomic, assign) ScanBarType scanType;

@end


@implementation SmallGoldMineViewController

@synthesize segmentedControl;
@synthesize vSquareScrollView=_vSquareScrollView;

-(id)init{
    self=[super init];
    if (self) {
        self.title = @"小V聚宝";
        
        UIButton* leftBarbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28.0, 27.0)];
        [leftBarbutton setImage:[UIImage imageNamed:@"personal"] forState:UIControlStateNormal];
        [leftBarbutton setImage:[UIImage imageNamed:@"personal"] forState:UIControlStateHighlighted];

        if (IS_IOS7) {
//            [leftBarbutton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        }
        UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarbutton];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        leftBarbutton=nil;
        
        UIButton  *rightBarbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28.0, 27.0)];
        [rightBarbutton setImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
        [rightBarbutton setImage:[UIImage imageNamed:@"scan"] forState:UIControlStateHighlighted];
        [rightBarbutton addTarget:self action:@selector(beginScanBarcode) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarbutton];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        rightBarbutton=nil;
    }
    return self;
}

-(void)viewDidLoad{
    if (IS_IOS7) {
        self.segmentedControl = [[CustomSegmentedControl alloc] initWithFrame:CGRectMake(0.0, 60.0, 320.0, 40)];
        self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }else{
        self.segmentedControl = [[CustomSegmentedControl alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40)];
    }
    
    [self.segmentedControl.vSquareButton addTarget:self action:@selector(selectedVSquareButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.segmentedControl.taskButton addTarget:self action:@selector(selectedTaskButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.segmentedControl.goldMineButton addTarget:self action:@selector(selectedGoldMineButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:segmentedControl];
    
    self.vSquareScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0.0,CGRectGetMaxY(self.segmentedControl.frame)-65.0,self.view.frame.size.width,self.view.frame.size.height-65.0)];
    self.vSquareScrollView.showsHorizontalScrollIndicator=NO;
    self.vSquareScrollView.showsVerticalScrollIndicator=NO;
    self.vSquareScrollView.delegate=self;
    self.vSquareScrollView.pagingEnabled=YES;
    self.vSquareScrollView.bounces=NO;
    self.vSquareScrollView.contentSize=CGSizeMake(self.view.frame.size.width*3,self.vSquareScrollView.frame.size.height);
    [self.view addSubview:self.vSquareScrollView];
    
    vSquareViewController=[[VSquareViewController alloc] init];
    vSquareViewController.view.frame=CGRectMake(0.0,0.0, self.view.frame.size.width,self.vSquareScrollView.frame.size.height);
    [self.vSquareScrollView addSubview:vSquareViewController.view];
    
    taskViewController=[[TaskViewController alloc] init];
    taskViewController.delegate=self;
    taskViewController.view.frame = CGRectMake(self.view.frame.size.width,0.0, self.view.frame.size.width,self.vSquareScrollView.frame.size.height);
    [self.vSquareScrollView addSubview:taskViewController.view];
    
    goldenViewController=[[GoldenViewController alloc] init];
    goldenViewController.view.frame = CGRectMake(self.view.frame.size.width*2,0.0, self.view.frame.size.width,self.vSquareScrollView.frame.size.height);
    [self.vSquareScrollView addSubview:goldenViewController.view];

    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
   
    _bNeedShowRightBarButtonItem = YES;
    _bNeedShowLogoView = YES;
    
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

//V广场
-(void)selectedVSquareButton:(id)sender{
    [self.segmentedControl.vSquareButton setTitleColor:[UIColor colorWithRed:249.0/255 green:186.0/255 blue:8.0/255 alpha:1.0] forState:UIControlStateNormal];
    [self.segmentedControl.taskButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]  forState:UIControlStateNormal];
    [self.segmentedControl.goldMineButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]  forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        self.segmentedControl.flagView.frame=CGRectMake(0.0,CGRectGetMaxY(segmentedControl.vSquareButton.frame)-5.0, 106.0, 5.0);
        [self.vSquareScrollView setContentOffset:CGPointMake(0, 0)];
    }];
//    if (taskViewController) {
//        [self.view sendSubviewToBack:taskViewController.view];
//    }
//    if (goldenViewController) {
//        [self.view sendSubviewToBack:goldenViewController.view];
//    }
}

//任务
-(void)selectedTaskButton:(id)sender{
    [self.segmentedControl.vSquareButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
    [self.segmentedControl.taskButton setTitleColor:[UIColor colorWithRed:249.0/255 green:186.0/255 blue:8.0/255 alpha:1.0]  forState:UIControlStateNormal];
    [self.segmentedControl.goldMineButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]  forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
    self.segmentedControl.flagView.frame=CGRectMake(segmentedControl.taskButton.frame.origin.x,CGRectGetMaxY(segmentedControl.vSquareButton.frame)-5.0, 106.0, 5.0);
         }];
    [self.vSquareScrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
//    if (!taskViewController) {
//        taskViewController=[[TaskViewController alloc] init];
//        taskViewController.view.frame = CGRectMake(0, CGRectGetMaxY(self.segmentedControl.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(self.segmentedControl.frame));
//        [self.view addSubview:taskViewController.view];
//    }else{
//        [self.view bringSubviewToFront:taskViewController.view];
//    }
}

//聚宝
-(void)selectedGoldMineButton:(id)sender{
    [self.segmentedControl.vSquareButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
    [self.segmentedControl.taskButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]  forState:UIControlStateNormal];
    [self.segmentedControl.goldMineButton setTitleColor:[UIColor colorWithRed:249.0/255 green:186.0/255 blue:8.0/255 alpha:1.0]  forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
    self.segmentedControl.flagView.frame=CGRectMake(segmentedControl.goldMineButton.frame.origin.x,CGRectGetMaxY(segmentedControl.vSquareButton.frame)-5.0, 106.0, 5.0);
     }];
    [self.vSquareScrollView setContentOffset:CGPointMake(self.view.frame.size.width*2, 0) animated:YES];
//    if (!goldenViewController) {
//        goldenViewController=[[GoldenViewController alloc] initWithNibName:@"GoldenViewController" bundle:nil];
//        goldenViewController.view.frame = CGRectMake(0, CGRectGetMaxY(self.segmentedControl.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(self.segmentedControl.frame));
//        [self.view addSubview:goldenViewController.view];
//    }else{
//        [self.view bringSubviewToFront:goldenViewController.view];
//    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth=self.vSquareScrollView.frame.size.width;
    int page=floorf((self.vSquareScrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
 
    if (page==0) {
        [self selectedVSquareButton:nil];
    }else if (page==1){
        [self selectedTaskButton:nil];
    }else if (page==2){
        [self selectedGoldMineButton:nil];
    }
}

#pragma mark - Present to login
- (void)presentLoginVC
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    LoginController *loginController = [[LoginController alloc] initWithNibName:@"LoginController" bundle:nil];
    
    DLog(@"self.mmDrawer = %@", self.mm_drawerController);
    DLog(@"self = %@", self);
    UINavigationController *navi = (UINavigationController *)self.mm_drawerController.centerViewController;
    DLog(@"sefl.mmDrawer.centerVC = %@", navi.topViewController);

    [self.view.window.rootViewController presentViewController:loginController animated:NO completion:nil];
}

#pragma mark -
#pragma mark TaskViewController Delegate
-(void)seeVipDetailInfomationWithCustomeId:(NSString *)customeId{
    VIPDetailedInformationViewController *vipDetailInfomationVC=[[VIPDetailedInformationViewController alloc] initWithCustomeID:customeId];
    [self.navigationController pushViewController:vipDetailInfomationVC animated:YES];
    vipDetailInfomationVC=nil;
}

/******************** Scan Module ***************************/

#pragma mark -
#pragma mark Scan Module
- (void)beginScanBarcode
{
    /*
     扫描二维码部分：
     导入ZBarSDK文件并引入一下框架
     AVFoundation.framework
     CoreMedia.framework
     CoreVideo.framework
     QuartzCore.framework
     libiconv.dylib
     引入头文件#import “ZBarSDK.h” 即可使用
     当找到条形码时，会执行代理方法
     
     - (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
     最后读取并显示了条形码的图片和内容。
     */
 
    if (self.reader) {
        [self.reader removeFromParentViewController];
        self.reader = nil;
    }
    _reader = [[ZBarReaderViewController alloc] init];
    _reader.readerDelegate = self;
    _reader.showsZBarControls = NO;
    _reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = _reader.scanner;
    [scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    
    
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor clearColor];
    _reader.cameraOverlayView = view;
    //_reader.cameraViewTransform = CGAffineTransformMakeScale(0.5, 0.5);
    
    ScanNaviView *naviView = [ScanNaviView loadNibInstance];
    naviView.frame = CGRectMake(0, 0, naviView.frame.size.width, naviView.frame.size.height);
    [naviView.backButton addTarget:self action:@selector(scanBack:) forControlEvents:UIControlEventTouchUpInside];
    [naviView.backButton enlargeTouchWithTop:10 right:15 bottom:10 left:15];
    [naviView.torchButton addTarget:self action:@selector(changeTorchValue:) forControlEvents:UIControlEventTouchUpInside];
    [naviView.integrationScanButton addTarget:self action:@selector(integrationScanType:) forControlEvents:UIControlEventTouchUpInside];
    naviView.integrationScanButton.selected = YES;
    self.scanType = scanBarIntegrationType;
    [naviView.queryGoodsButton addTarget:self action:@selector(queryGoodsType:) forControlEvents:UIControlEventTouchUpInside];
    [naviView.manualInputButton addTarget:self action:@selector(manualInputType:) forControlEvents:UIControlEventTouchUpInside];

    [view addSubview:naviView];
    
    
    
    UIImageView *scanBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 289, 289)];
    scanBgImageView.center = CGPointMake(view.center.x, view.center.y + naviView.frame.size.height/2 - 10);
    scanBgImageView.image = [UIImage imageNamed:@"scan_bg"];
    [view addSubview:scanBgImageView];
    
    UIImageView *scanLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 291, 5)];
    scanLineImageView.center = scanBgImageView.center;
    scanLineImageView.image = [UIImage imageNamed:@"scan_line"];
    [view addSubview:scanLineImageView];
    
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:self.reader];
//    self.reader.navigationController.navigationBarHidden = YES;
    [self presentViewController:_reader animated:YES completion:nil];
}

#pragma mark - Reader callBack
- (void)imagePickerController: (UIImagePickerController*) reader
didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results) {
        break;
    }
    
    [reader dismissViewControllerAnimated:YES completion:nil];
    
    NSString *barString = symbol.data;
    
    NSString *regex = @"http+:[^\\s]*";
    NSPredicate *httpPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([httpPredicate evaluateWithObject:symbol.data]) {
        NSRange range = [symbol.data rangeOfString:@"="];
        if (range.length > 0) {
            barString = [symbol.data substringWithRange:NSMakeRange(range.location + 1, symbol.data.length - range.location - 1)];
        }
    }

    if (self.scanType == scanBarIntegrationType) { //跳到手动输入
        InputBarcodeController *inputController = [[InputBarcodeController alloc] initWithNibName:@"InputBarcodeController" bundle:nil];
        inputController.barString = barString;
        
        [self.navigationController pushViewController:inputController animated:YES];
        
    } else if (self.scanType == ScanBarQueryCodeType) { //跳到商品查询
        GoodsBarResultController *goodsController = [[GoodsBarResultController alloc] initWithNibName:@"GoodsBarResultController" bundle:nil];
        goodsController.barString = barString;
        
        [self.navigationController pushViewController:goodsController animated:YES];
        
    }
}

- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
                             withRetry: (BOOL) retry
{
    [self.view makeToast:@"扫描失败,请重试"];
}

#pragma mark - Scan button events
- (void)scanBack:(UIButton *)button
{
    [self.reader dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeTorchValue:(LoopButton *)button
{
    if (button.currentIndex == 0) {
    
    } else if (button.currentIndex == 1) {
        _reader.readerView.torchMode = 1;
    } else if (button.currentIndex == 2) {
        _reader.readerView.torchMode = 0;
    }
}

- (void)integrationScanType:(UIButton *)button
{
    if (button.selected) {
        return;
    }
    
    self.scanType = scanBarIntegrationType;
    
    button.selected = !button.selected;
    ScanNaviView *naviView = (ScanNaviView *)button.superview;
    naviView.queryGoodsButton.selected = NO;
    naviView.manualInputButton.selected = NO;
}

- (void)queryGoodsType:(UIButton *)button
{
    if (button.selected) {
        return;
    }
    
    self.scanType = ScanBarQueryCodeType;
    
    button.selected = !button.selected;
    ScanNaviView *naviView = (ScanNaviView *)button.superview;
    naviView.integrationScanButton.selected = NO;
    naviView.manualInputButton.selected = NO;
}

- (void)manualInputType:(UIButton *)button
{
    if (button.selected) {
        return;
    }
    
    button.selected = !button.selected;
    ScanNaviView *naviView = (ScanNaviView *)button.superview;
    naviView.queryGoodsButton.selected = NO;
    naviView.integrationScanButton.selected = NO;
    
    [_reader dismissViewControllerAnimated:YES completion:nil];
    
    __weak typeof(&*self) weakSelf = self;
    InputBarcodeController *inputController = [[InputBarcodeController alloc] initWithNibName:@"InputBarcodeController" bundle:nil];
    inputController.jumpToScanBlock = ^ {
        [weakSelf beginScanBarcode];
    };
    [self.navigationController pushViewController:inputController animated:YES];
    
}


@end
