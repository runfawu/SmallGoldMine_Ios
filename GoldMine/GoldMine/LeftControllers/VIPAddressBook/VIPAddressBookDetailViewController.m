//
//  VIPAddressBookDetailViewController.m
//  GoldMine
//
//  Created by micheal on 14/11/11.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "VIPAddressBookDetailViewController.h"
#import "VIPAddressBookDetailCell.h"
#import "JubaoListTableViewCell.h"
#import "EditVIPAddressBookDetailViewController.h"

@interface VIPAddressBookDetailViewController ()<UITableViewDataSource,UITableViewDelegate,VIPAddressBookDetailCellDelegate>

@property (nonatomic,strong) SoapRequest *vipInfoRequest;
@property (nonatomic,strong) SoapRequest *vipListRequest;

@end

@implementation VIPAddressBookDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _bNeedShowBackBarButtonItem = YES;
        [self configNaviTitle:@"详细信息"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];
    
    self.vipInfoRequest=[[SoapRequest alloc] init];
    self.vipListRequest=[[SoapRequest alloc] init];
    
    vipInfoArray=[NSMutableArray array];
    jubaoListArray=[NSMutableArray array];
    vipInfoSectionOneArray=[NSMutableArray array];
    vipInfoSectionTwoArray=[NSMutableArray array];
    
    UIButton *rightBarButton=[[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0,45.0,40.0)];
    [rightBarButton setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [rightBarButton addTarget:self action:@selector(editPersonInfomation:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarItem=[[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    self.navigationItem.rightBarButtonItem=rightBarItem;
    
    self.VIPAddressTableView.dataSource=self;
    self.VIPAddressTableView.delegate=self;
    self.VIPAddressTableView.backgroundColor=[UIColor clearColor];
    self.VIPAddressTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self getVipInfoRequestWithCustomID:self.customID];
    [self getVipListRequestWithCustomID:self.customID];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -
#pragma mark UITBLEVIEW DELEGATE
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
        return 106;
    }else
        return 45.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }else if (section==1){
        return 4;
    }else
        return [jubaoListArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
        return 20.0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPat{
    if (indexPat.section==0||indexPat.section==1) {
        static NSString *cellIdentifer=@"CellIdentifier";
        VIPAddressBookDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if (!cell) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"VIPAddressBookDetailCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.delegate=self;
        if (indexPat.section==0&&indexPat.row==0) {
            cell.shareImageView.hidden=NO;
        }
        
        if (indexPat.section==0&&[vipInfoSectionOneArray count]>0) {
            [cell setVIPAddressBookDetailCelWithInfoDictionary:[vipInfoSectionOneArray objectAtIndex:indexPat.row]];
        }else if(indexPat.section==1&&[vipInfoSectionTwoArray count]>0){
            [cell setVIPAddressBookDetailCelWithInfoDictionary:[vipInfoSectionTwoArray objectAtIndex:indexPat.row]];
        }
        
        return cell;
    }else {
        static NSString *identifier=@"Identifier";
        JubaoListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"JubaoListTableViewCell" owner:self options:nil] lastObject];
        }
        if ([jubaoListArray count]>0) {
            [cell setCellContentWithDictionary:[jubaoListArray objectAtIndex:indexPat.row]];
        }
        
        return cell;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==2){
        UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.0)];
        headerView.text = @"     聚宝清单";
        headerView.textColor = [Utils colorWithHexString:@"C3C6C5"];
        
        headerView.font = [UIFont systemFontOfSize:11];
        headerView.backgroundColor=[UIColor colorWithRed:242.0/255.0 green:243.0/255.0 blue:240.0/255.0 alpha:1.0];
        
        return headerView;
    }else
        return nil;
}

//获取VIP信息
-(void)getVipInfoRequestWithCustomID:(NSString *)customID{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:@"001" forKey:@"uid"];
    [paramDict setObject:customID forKey:@"vid"];
    [paramDict setObject:[Tools getAppVersion] forKey:@"version"];
    
    [self.vipInfoRequest postRequestWithSoapNamespace:@"getVipInfo" params:paramDict successBlock:^(id result) {
        DLog(@"getVipInfo result=%@", result);
        NSDictionary *vipName=[NSDictionary dictionaryWithObjectsAndKeys:@"VIP昵称:",@"title",[(NSDictionary *)result objectForKey:@"CusName"] ,@"info", nil];
        NSDictionary *vipPhone=[NSDictionary dictionaryWithObjectsAndKeys:@"联系方式:",@"title",[(NSDictionary *)result objectForKey:@"CusPhone"] ,@"info", nil];
        [vipInfoSectionOneArray addObject:vipName];
        [vipInfoSectionOneArray addObject:vipPhone];
        
        NSDictionary *bbBirthday=[NSDictionary dictionaryWithObjectsAndKeys:@"宝宝生日:",@"title",[(NSDictionary *)result objectForKey:@"BBBirthday"],@"info", nil];
        NSDictionary *address=[NSDictionary dictionaryWithObjectsAndKeys:@"送货地址:",@"title",[(NSDictionary *)result objectForKey:@"CusAddress"],@"info", nil];
        NSDictionary *server=[NSDictionary dictionaryWithObjectsAndKeys:@"定制服务:",@"title",[self orderServerNumberChangeToString:[(NSDictionary *)result objectForKey:@"Server"]],@"info", nil];
        
        NSDictionary *serverWay=[NSDictionary dictionaryWithObjectsAndKeys:@"服务方式:",@"title",[self ServerNumberChangeToString:[(NSDictionary *)result objectForKey:@"ServerWay"]],@"info", nil];
        [vipInfoSectionTwoArray addObject:bbBirthday];
        [vipInfoSectionTwoArray addObject:address];
        [vipInfoSectionTwoArray addObject:server];
        [vipInfoSectionTwoArray addObject:serverWay];
        
        [self.VIPAddressTableView reloadData];
        
    } failureBlock:^(NSString *requestError) {
        DLog(@"getVipInfo failure!!!");
    } errorBlock:^(NSMutableString *errorStr) {
        DLog(@"getVipInfo error!!!");
    }];
    paramDict=nil;
}

//我的VIP聚宝清单
-(void)getVipListRequestWithCustomID:(NSString *)customID{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:@"001" forKey:@"uid"];
    [paramDict setObject:customID forKey:@"vid"];
    [paramDict setObject:[Tools getAppVersion] forKey:@"version"];
    
    [self.vipListRequest postRequestWithSoapNamespace:@"getVipList" params:paramDict successBlock:^(id result) {
        DLog(@"get VipList result=%@", result);
        NSArray *vipListArray=[(NSDictionary *)result objectForKey:@"VipList"];
        for (NSDictionary *listItem in vipListArray) {
            [jubaoListArray addObject:listItem];
        }
        
        [self.VIPAddressTableView reloadData];
    } failureBlock:^(NSString *requestError) {
        DLog(@"get VipList failure!!!");
    } errorBlock:^(NSMutableString *errorStr) {
        DLog(@"get VipList error!!!");
    }];
    paramDict=nil;
}

//编辑个人信息
-(void)editPersonInfomation:(id)sender{
    EditVIPAddressBookDetailViewController *editVC=[[EditVIPAddressBookDetailViewController alloc] initWithNibName:@"EditVIPAddressBookDetailViewController" bundle:nil];
    editVC.infoSectionOneArray=vipInfoSectionOneArray;
    editVC.infosectionTwoArray=vipInfoSectionTwoArray;
    
    [self.navigationController pushViewController:editVC animated:YES];
    editVC=nil;
}

//分享个人信息
-(void)shareToBuddy:(VIPAddressBookDetailCell *)cell{
    NSLog(@"share!!!");
}


//定制服务转换为字符串
-(NSString *)orderServerNumberChangeToString:(NSString *)numberStr{
    NSArray *numbers=[numberStr componentsSeparatedByString:@","];
    
    NSMutableArray *orderServers=[NSMutableArray array];
    for (NSString *serverNum in numbers) {
        if ([serverNum isEqualToString:@"01"]) {
            [orderServers addObject:@"生日祝福"];
        }else if ([serverNum isEqualToString:@"02"]){
            [orderServers addObject:@"续购提示"];
         
        }else if ([serverNum isEqualToString:@"03"]){
            [orderServers addObject:@"使用提示"];
         
        }else if ([serverNum isEqualToString:@"04"]){
            [orderServers addObject:@"育儿指导"];
        
        }else if ([serverNum isEqualToString:@"05"]){
            [orderServers addObject:@"活动通知"];
        }else if ([serverNum isEqualToString:@"06"]){
            [orderServers addObject:@"积分提醒"];
            
        }else if ([serverNum isEqualToString:@"07"]){
            [orderServers addObject:@"到货通知"];
        }else if ([serverNum isEqualToString:@"08"]){
            [orderServers addObject:@"关联推荐"];
        }
    }
    return [orderServers componentsJoinedByString:@","];
}

//服务方式转化为字符串
-(NSString *)ServerNumberChangeToString:(NSString *)numberStr{
    NSArray *numbers=[numberStr componentsSeparatedByString:@","];
    
    NSMutableArray *servers=[NSMutableArray array];
    for (NSString *serverNum in numbers) {
        if ([serverNum isEqualToString:@"1"]) {
            [servers addObject:@"手机"];
        }else if ([serverNum isEqualToString:@"2"]){
            [servers addObject:@"短信"];
        }else if ([serverNum isEqualToString:@"3"]){
            [servers addObject:@"微信"];
        }
    }
    return [servers componentsJoinedByString:@","];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
