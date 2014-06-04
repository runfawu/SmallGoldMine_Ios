//
//  GoldenViewController.m
//  GoldMine
//
//  Created by Oliver on 14-9-24.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "GoldenViewController.h"
#import "GoldenCell.h"

@interface GoldenViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak,nonatomic) IBOutlet UILabel *vBoon;
@property (weak,nonatomic) IBOutlet UILabel *vOrder;
@property (weak,nonatomic) IBOutlet UILabel *vips;
@property (weak,nonatomic) IBOutlet UILabel *services;
@property (weak,nonatomic) IBOutlet UILabel *money;
@property (weak,nonatomic) IBOutlet UILabel *dOrder;

@property (nonatomic, strong) SoapRequest *myMarkReqeust;
@property (nonatomic,strong) SoapRequest *myVipsRequest;
@property (nonatomic,strong) SoapRequest *myMarkCountRequest;

@end

@implementation GoldenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    
//    goodsCount=[[NSMutableArray alloc] init];
    
    self.myMarkReqeust = [[SoapRequest alloc] init];
    self.myVipsRequest=[[SoapRequest alloc] init];
    self.myMarkCountRequest=[[SoapRequest alloc] init];
    
    [self getMyMarkDataWithUId:@"001" andVersion:[Tools getAppVersion]];
    [self getMyMarkCountWithUID:@"001" andVersion:[Tools getAppVersion]];
}

-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setup
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.tableHeaderView;
    [self.tableView registerNib:[UINib nibWithNibName:@"GoldenCell" bundle:nil] forCellReuseIdentifier:@"GoldenCell"];
}

static const float goldenCellHeight = 55.0;
#pragma mark - UITableView dataSource && delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return goldenCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] init];
    sectionHeaderView.backgroundColor = [Utils colorWithHexString:@"353838"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, goldenCellHeight)];
    titleLabel.text = @"主推产品累计";
    titleLabel.textColor = [Utils colorWithHexString:@"C3C6C5"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, goldenCellHeight - 1, SCREEN_WIDTH, 1);
    bottomBorder.backgroundColor = [Utils colorWithHexString:@"636666"].CGColor;
    
    [sectionHeaderView.layer addSublayer:bottomBorder];
    
    [sectionHeaderView addSubview:titleLabel];
    
    return sectionHeaderView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [goodsCount count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return goldenCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"GoldenCell";
    GoldenCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    [cell setGoldenCellContentWithDictionary:[goodsCount objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

//获取我的成绩
-(void)getMyMarkDataWithUId:(NSString *)uid andVersion:(NSString *)version{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:uid forKey:@"uid"];
    [paramDict setObject:version forKey:@"version"];

    [self.myMarkReqeust postRequestWithSoapNamespace:@"MyMark" params:paramDict successBlock:^(id result) {
        DLog(@"MyMark result=%@", result);
        
        self.vBoon.text=[(NSDictionary *)result objectForKey:@"Vboon"];
        self.vOrder.text=[(NSDictionary *)result objectForKey:@"VOrder"];
        self.vips.text=[(NSDictionary *)result objectForKey:@"Vips"];
        self.services.text=[(NSDictionary *)result objectForKey:@"Services"];
        self.money.text=[(NSDictionary *)result objectForKey:@"Money"];
        self.dOrder.text=[(NSDictionary *)result objectForKey:@"DOrder"];
        
    } failureBlock:^(NSString *requestError) {
        NSLog(@"MyMark fail!!!");
    } errorBlock:^(NSMutableString *errorStr) {
        NSLog(@"MyMark error!!!!");
    }];
    paramDict=nil;
}

//获取我的VIP
-(void)getMyVipsDataWithNum:(NSString *)num andUId:(NSString *)uId andVID:(NSString *)vId andVersion:(NSString *)version{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:num forKey:@"num"];
    [paramDict setObject:vId forKey:@"vid"];
    [paramDict setObject:uId forKey:@"uid"];
    [paramDict setObject:version forKey:@"version"];
    [self.myVipsRequest postRequestWithSoapNamespace:@"MyVips" params:paramDict successBlock:^(id result) {
        DLog(@"MyMark result=%@", result);
        
    } failureBlock:^(NSString *requestError) {
        
    } errorBlock:^(NSMutableString *errorStr) {
        
    }];
    paramDict=nil;
}

//获取主推产品累计
-(void)getMyMarkCountWithUID:(NSString *)uid andVersion:(NSString *)version{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:uid forKey:@"uid"];
    [paramDict setObject:version forKey:@"version"];
    
    [self.myMarkCountRequest postRequestWithSoapNamespace:@"MyMarkCount" params:paramDict successBlock:^(id result) {
        DLog(@"MyMarkCount result=%@", result);
        NSArray *ProFeatured=[(NSDictionary *)result objectForKey:@"ProFeatured"];
        if (!goodsCount) {
            goodsCount=[[NSMutableArray alloc] initWithArray:ProFeatured];
        }
        [self.tableView reloadData];
        
    } failureBlock:^(NSString *requestError) {
        
    } errorBlock:^(NSMutableString *errorStr) {
        
    }];
    paramDict=nil;
}

@end
