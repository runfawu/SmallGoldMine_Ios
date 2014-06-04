//
//  VIPDetailedInformationViewController.m
//  GoldMine
//
//  Created by micheal on 14-9-25.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "VIPDetailedInformationViewController.h"
#import "VIPDetailInfoHeadView.h"
#import "VIPDetailedInformationTableViewCell.h"

@interface VIPDetailedInformationViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) SoapRequest *myVipsRequest;
@property (nonatomic,strong) SoapRequest *myVipsRequestWithNumTwo;
@property (nonatomic,strong) VIPDetailInfoHeadView *vipHeadView;

@end

@implementation VIPDetailedInformationViewController

@synthesize goldenListTableView=_goldenListTableView;

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
    
    _vipHeadView=[[VIPDetailInfoHeadView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 217.0)];
    [_vipHeadView.shareButton addTarget:self action:@selector(shareVipInfomation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_vipHeadView];
    
    _goldenListTableView=[[UITableView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(_vipHeadView.frame), self.view.frame.size.width, self.view.frame.size.height-190.0)];
    [_goldenListTableView registerNib:[UINib nibWithNibName:@"VIPDetailedInformationTableViewCell" bundle:nil] forCellReuseIdentifier:@"VIPDetailedInformationTableViewCell"];
    _goldenListTableView.dataSource=self;
    _goldenListTableView.delegate=self;
    _goldenListTableView.showsHorizontalScrollIndicator = NO;
    _goldenListTableView.showsVerticalScrollIndicator = NO;
    _goldenListTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//    _goldenListTableView.tableHeaderView=_vipHeadView;
    [self.view addSubview:_goldenListTableView];
    
    self.myVipsRequest=[[SoapRequest alloc] init];
    self.myVipsRequestWithNumTwo=[[SoapRequest alloc] init];
    [self getMyVipsDataRequestWithNum:@"1" andUID:@"001" andVID:customeID andVersion:[Tools getAppVersion]];
    [self getMyVipsDataRequestWithNumTwo:@"2" andUID:@"001" andVID:customeID andVersion:[Tools getAppVersion]];
}

#pragma mark -
#pragma mark UITABLEVIEW DELEGATE
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [goldenListArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"VIPDetailedInformationTableViewCell";
    VIPDetailedInformationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
   
    [cell setVIPDetailedInformationTableViewCellWithDictionary:[goldenListArray objectAtIndex:indexPath.row]];
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.0)];
    headerView.text = @"     聚宝清单";
    headerView.textColor = [Utils colorWithHexString:@"C3C6C5"];

    headerView.font = [UIFont systemFontOfSize:11];
    headerView.backgroundColor=[UIColor colorWithRed:242.0/255.0 green:243.0/255.0 blue:240.0/255.0 alpha:1.0];

    return headerView;
}


-(void)getMyVipsDataRequestWithNum:(NSString *)num andUID:(NSString *)uID andVID:(NSString *)vId andVersion:(NSString *)version{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:num forKey:@"num"];
    [paramDict setObject:uID forKey:@"uid"];
    [paramDict setObject:vId forKey:@"vid"];
    [paramDict setObject:version forKey:@"version"];
    
    [self.myVipsRequest postRequestWithSoapNamespace:@"MyVips" params:paramDict successBlock:^(id result) {
        DLog(@"MyVips result=%@", result);
        
        if ([num isEqualToString:@"1"]) {
            _vipHeadView.userName.text=[(NSDictionary *)result objectForKey:@"CusName"];
            _vipHeadView.telNo.text=[NSString stringWithFormat:@"联系方式 :%@",[(NSDictionary *)result objectForKey:@"CusPhone"]];
            _vipHeadView.birthdayLabel.text=[(NSDictionary *)result objectForKey:@"BBBirthday"];
            _vipHeadView.goodsAddressLabel.text=[(NSDictionary *)result objectForKey:@"CusAddress"];
            _vipHeadView.orderServerLabel.text=[(NSDictionary *)result objectForKey:@"Server"];
        }else{
            
        }
        
        
    } failureBlock:^(NSString *requestError) {
        
    } errorBlock:^(NSMutableString *errorStr) {
       
    }];
    paramDict=nil;
}

-(void)getMyVipsDataRequestWithNumTwo:(NSString *)num andUID:(NSString *)uID andVID:(NSString *)vId andVersion:(NSString *)version{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:num forKey:@"num"];
    [paramDict setObject:uID forKey:@"uid"];
    [paramDict setObject:vId forKey:@"vid"];
    [paramDict setObject:version forKey:@"version"];
    
    [self.myVipsRequestWithNumTwo postRequestWithSoapNamespace:@"MyVips" params:paramDict successBlock:^(id result) {
        DLog(@"MyVips result=%@", result);
        
        if ([num isEqualToString:@"2"]) {
            if(!goldenListArray){
                goldenListArray=[[NSMutableArray alloc] initWithArray:[(NSDictionary *)result objectForKey:@"VipList"]];
            }else{
                if ([goldenListArray count]>0) {
                    [goldenListArray removeAllObjects];
                }
            }
            [_goldenListTableView reloadData];
        }else{
            
        }
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
