//
//  VIPAddressBookViewController.m
//  GoldMine
//
//  Created by micheal on 14-10-19.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "VIPAddressBookViewController.h"
#import "AppDelegate.h"

@interface VIPAddressBookViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) SoapRequest *vipRequest;

@end

@implementation VIPAddressBookViewController

@synthesize vipTableView;

-(id)init{
    self=[super init];
    if (self) {
        _bNeedShowBackBarButtonItem = YES;
        self.title=@"VIP通讯";
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.vipRequest=[[SoapRequest alloc] init];
    
    UIButton *backbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 28.0)];
    [backbutton setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    [backbutton setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateHighlighted];
    [backbutton addTarget:self action:@selector(showDrawerView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    backbutton=nil;
    
    UIButton  *rightBarbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 27.0, 26.0)];
    [rightBarbutton setImage:[UIImage imageNamed:@"add_vip_addr"] forState:UIControlStateNormal];
    [rightBarbutton setImage:[UIImage imageNamed:@"add_vip_addr"] forState:UIControlStateHighlighted];
    [rightBarbutton addTarget:self action:@selector(addVIP:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarbutton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    rightBarbutton=nil;
    
//    self.vipTableView=[[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height-64.0) style:UITableViewStyleGrouped];
//    self.vipTableView.delegate=self;
//    self.vipTableView.dataSource=self;
//    [self.view addSubview:self.vipTableView];
    
    [self getVipDataRequest];
}

#pragma mark -
#pragma mark UITBLEVIEW DELEGATE
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer=@"CellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    return cell;
}

-(void)getVipDataRequest{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:@"001" forKey:@"uid"];
    [paramDict setObject:[NSNumber  numberWithInt:1] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:10] forKey:@"row"];
    [paramDict setObject:[Tools getAppVersion] forKey:@"version"];
    
    [self.vipRequest postRequestWithSoapNamespace:@"MyVips" params:paramDict successBlock:^(id result) {
        DLog(@"My Vips result=%@", result);
//        NSString *msg=[(NSDictionary *)result objectForKey:@"Msg"];
       
    } failureBlock:^(NSString *requestError) {
        DLog(@"request vip failure!!!");
    } errorBlock:^(NSMutableString *errorStr) {
        DLog(@"request vip error!!!");
    }];
    paramDict=nil;
}

-(void)showDrawerView{
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)addVIP:(id)sender{
    
}

@end
