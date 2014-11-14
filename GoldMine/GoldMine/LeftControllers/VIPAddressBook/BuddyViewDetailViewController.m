//
//  VIPAddressBookDetailViewController.m
//  GoldMine
//
//  Created by micheal on 14/11/5.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "BuddyViewDetailViewController.h"
#import "VIPAddressBookDetailCell.h"
#import "VipPopView.h"
#import "UIImageView+WebCache.h"

#define remarkTag 10001
#define deleteTag 10002
#define reportTag 10003

@interface BuddyViewDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) VipPopView *popView;

@property (nonatomic,strong) SoapRequest *detailInfoRequest;
@property (nonatomic,strong) SoapRequest *buddyRequest;

@end

@implementation BuddyViewDetailViewController

@synthesize popView;

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
    
    self.view.backgroundColor=[Utils colorWithHexString:@"F2F3F0"];
    
    self.detailInfoRequest=[[SoapRequest alloc] init];
    
    myFriendsInfoArray=[NSMutableArray array];
    
    UIButton *rightBarButton=[[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0,31.0,31.0)];
    [rightBarButton setImage:[UIImage imageNamed:@"vip_more"] forState:UIControlStateNormal];
    [rightBarButton addTarget:self action:@selector(popView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarItem=[[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    self.navigationItem.rightBarButtonItem=rightBarItem;
    
    self.headImageView.layer.masksToBounds=YES;
    self.headImageView.layer.cornerRadius=26;
    
    self.detailInfoTableView.dataSource=self;
    self.detailInfoTableView.delegate=self;
    self.detailInfoTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.detailInfoTableView.scrollEnabled=NO;
    self.detailInfoTableView.backgroundColor=[UIColor clearColor];
    
    [self getMyFriendsInfoRequestWithUID:self.friedId];
    
    // Do any additional setup after loading the view from its nib.
}


#pragma mark -
#pragma mark UITBLEVIEW DELEGATE
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPat{
    static NSString *cellIdentifer=@"CellIdentifier";
    VIPAddressBookDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"VIPAddressBookDetailCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPat.row==2) {
        cell.seprateLineView.hidden=YES;
    }
    if ([myFriendsInfoArray count]>0) {
        [cell setVIPAddressBookDetailCelWithInfoDictionary:[myFriendsInfoArray objectAtIndex:indexPat.row]];
    }
    
    return cell;
}


-(void)getMyFriendsInfoRequestWithUID:(NSString *)uId{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:uId forKey:@"fid"];
    [paramDict setObject:[Tools getAppVersion] forKey:@"version"];
    
    [self.detailInfoRequest postRequestWithSoapNamespace:@"MyFriendsInfo" params:paramDict successBlock:^(id result) {
        DLog(@"MyFriendsInfo result=%@", result);
        
        NSString *pictureUrl=[(NSDictionary *)result objectForKey:@"Picture"];
        
        if (pictureUrl.length>0) {
             [self.headImageView setImageWithURL:[NSURL URLWithString:pictureUrl] placeholderImage:nil];
        }else{
            
        }
        NSString *nameStr=[NSString stringWithFormat:@"%@ %@",[(NSDictionary *)result objectForKey:@"UserName"],[Tools buddyNumberChangeToStringWithNumber:[(NSDictionary *)result objectForKey:@"UserType"]]];
        self.nameLabel.attributedText=[Tools setBuddyNameContectFormat:nameStr];
        
        self.signatureLabel.text=[NSString stringWithFormat:@"%@",[(NSDictionary *)result objectForKey:@"UserName"]];
        
        NSDictionary *shopNameDic=[NSDictionary dictionaryWithObjectsAndKeys:@"商铺:",@"title",[(NSDictionary *)result objectForKey:@"ShopName"],@"info", nil];
        NSDictionary *brandDic=[NSDictionary dictionaryWithObjectsAndKeys:@"所属城市:",@"title",[(NSDictionary *)result objectForKey:@"ShopName"],@"info", nil];
        NSDictionary *addressDic=[NSDictionary dictionaryWithObjectsAndKeys:@"详细地址:",@"title",[(NSDictionary *)result objectForKey:@"Address"],@"info", nil];
        
        [myFriendsInfoArray addObject:shopNameDic];
        [myFriendsInfoArray addObject: brandDic];
        [myFriendsInfoArray addObject:addressDic];
        
//        myFriendsInfoDic=[NSDictionary dictionaryWithDictionary:(NSDictionary *)result];
        
        [self.detailInfoTableView reloadData];
        
    } failureBlock:^(NSString *requestError) {
        DLog(@"MyFriendsInfo failure!!!");
        
    } errorBlock:^(NSMutableString *errorStr) {
        DLog(@"request MyFriendsInfo error!!!");
        
    }];
    paramDict=nil;
}

-(void)popView:(id)sender{
    if (!self.popView) {
        self.popView=[[[NSBundle mainBundle] loadNibNamed:@"VipPopView" owner:self options:nil] lastObject];
        [self.popView.remarkButton addTarget:self action:@selector(remarkBuddy) forControlEvents:UIControlEventTouchUpInside];
        [self.popView.recommendButton addTarget:self action:@selector(recommendBuddy) forControlEvents:UIControlEventTouchUpInside];
        [self.popView.deleteButton addTarget:self action:@selector(deleteBuddy) forControlEvents:UIControlEventTouchUpInside];
        [self.popView.reportButton addTarget:self action:@selector(reportBuddy) forControlEvents:UIControlEventTouchUpInside];
        
        self.popView.hidden=NO;
        self.popView.frame=CGRectMake(220.0, 0.0, 100.0, 125.0);
        [self.view addSubview:self.popView];
        
//        NSMutableArray *contraints=[NSMutableArray array];
//        [contraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-220-[popView(==100)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(popView)]];
//        [contraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[popView(==125)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(popView)]];
//        
//        [self.view addConstraints:contraints];
    }else{
        if (self.popView.hidden) {
            self.popView.hidden=NO;
        }else{
            self.popView.hidden=YES;
        }
    }
}

//备注
-(void)remarkBuddy{
    UIAlertView *remarkAlertView=[[UIAlertView alloc] initWithTitle:@"请输入" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    remarkAlertView.alertViewStyle=UIAlertViewStylePlainTextInput;
    remarkAlertView.delegate=self;
    remarkAlertView.tag=remarkTag;
    [remarkAlertView show];
}

//推荐VIP会员
-(void)recommendBuddy{
    
}

//删除
-(void)deleteBuddy{
    
}

//举报
-(void)reportBuddy{
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //备注
    if(alertView.tag==remarkTag&&buttonIndex==1){
        //得到输入框
        UITextField *remarkTextField=[alertView textFieldAtIndex:0];

    }
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
