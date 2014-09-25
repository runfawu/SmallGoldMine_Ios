//
//  VIPDetailedInformationViewController.m
//  GoldMine
//
//  Created by micheal on 14-9-25.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "VIPDetailedInformationViewController.h"
#import "VIPDetailInfoHeadView.h"

@interface VIPDetailedInformationViewController ()

@property (nonatomic,strong) SoapRequest *soapRequest;
@property (nonatomic,strong) VIPDetailInfoHeadView *vipHeadView;

@end
@implementation VIPDetailedInformationViewController

-(id)initWithCustomeID:(NSString *)cusId{
    self=[super init];
    if (self) {
        self.title = @"详细信息";
        customeID=[NSString stringWithString:cusId];
        
        _bNeedShowBackBarButtonItem = YES;
        
        UIButton  *deleteVipButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22.0, 22.0)];
        [deleteVipButton setImage:[UIImage imageNamed:@"vip_delete"] forState:UIControlStateNormal];
        [deleteVipButton addTarget:self action:@selector(deleteVipInfomation:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:deleteVipButton];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        deleteVipButton=nil;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    _vipHeadView=[[VIPDetailInfoHeadView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 100.0)];
    [_vipHeadView.shareButton addTarget:self action:@selector(shareVipInfomation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_vipHeadView];
    
    self.soapRequest=[[SoapRequest alloc] init];
    [self getMyVipsDataRequestWithNum:@"1" andUID:@"001" andVID:customeID andVersion:[Tools getAppVersion]];
}

-(void)getMyVipsDataRequestWithNum:(NSString *)num andUID:(NSString *)uID andVID:(NSString *)vId andVersion:(NSString *)version{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:num forKey:@"num"];
    [paramDict setObject:uID forKey:@"uid"];
    [paramDict setObject:vId forKey:@"vid"];
    [paramDict setObject:version forKey:@"version"];
    
    self.soapRequest = [[SoapRequest alloc] init];
    [self.soapRequest postRequestWithSoapNamespace:@"MyVips" params:paramDict successBlock:^(id result) {
        DLog(@"MyVips result=%@", result);
        
        _vipHeadView.userName.text=[(NSDictionary *)result objectForKey:@"CusName"];
        _vipHeadView.telNo.text=[NSString stringWithFormat:@"联系方式 :%@",[(NSDictionary *)result objectForKey:@"CusPhone"]];
        _vipHeadView.birthdayLabel.text=[(NSDictionary *)result objectForKey:@"BBBirthday"];
        _vipHeadView.goodsAddressLabel.text=[(NSDictionary *)result objectForKey:@"CusAddress"];
        _vipHeadView.orderServerLabel.text=[(NSDictionary *)result objectForKey:@"Server"];
        
    } failureBlock:^(NSString *requestError) {
        
    } errorBlock:^(NSMutableString *errorStr) {
       
    }];
    paramDict=nil;
}

//删除VIP信息
-(void)deleteVipInfomation:(id)sender{
    
}

//分享VIP
-(void)shareVipInfomation:(id)sender{
    
}

@end
