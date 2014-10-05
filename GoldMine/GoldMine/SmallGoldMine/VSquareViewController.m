//
//  VSquareViewController.m
//  GoldMine
//
//  Created by micheal on 14-9-25.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "VSquareViewController.h"
#import "SmallGoldMineCell.h"
#import "AdvertisementView.h"
#import "BrandIntroduceViewController.h"

@interface VSquareViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) AdvertisementView *advertisementView;

@property (nonatomic, strong) SoapRequest *getBrandReqeust;
@property (nonatomic,strong) SoapRequest *getBannarRequest;

@end

@implementation VSquareViewController

@synthesize vSquareTableView=_vSquareTableView;
@synthesize delegate=_delegate;

-(void)viewDidLoad{
    [super viewDidLoad];
    
    brandArray=[[NSMutableArray alloc] init];
    bannarArray=[[NSMutableArray alloc] init];
    
    self.getBrandReqeust = [[SoapRequest alloc] init];
    self.getBannarRequest=[[SoapRequest alloc] init];
    
    self.vSquareTableView=[[UITableView alloc] initWithFrame:CGRectMake(0.0, 150.0, self.view.frame.size.width, self.view.frame.size.height-257.0)];
    self.vSquareTableView.dataSource=self;
    self.vSquareTableView.delegate=self;
    self.vSquareTableView.showsHorizontalScrollIndicator = NO;
    self.vSquareTableView.showsVerticalScrollIndicator = NO;
    self.vSquareTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.vSquareTableView];
    
    self.addBrandButton=[[UIButton alloc] initWithFrame:CGRectMake(self.vSquareTableView.frame.size.width-61.0, self.view.frame.size.height-165.0, 51.0, 51.0)];
    NSLog(@"heigth:%f",self.view.frame.size.height-61.0);
    [self.addBrandButton setBackgroundImage:[UIImage imageNamed:@"add_ brand"] forState:UIControlStateNormal];
    [self.addBrandButton addTarget:self action:@selector(addBrand:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addBrandButton];
    
    [self getSmallGoldMineDataRequest:1];
    [self getBannarDataRequestWithUID:@"001" andVersion:[Tools getAppVersion]];
}

#pragma mark -
#pragma mark UITABLEVIEW DELEGATE
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [brandArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 82.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"CellIndentifier";
    SmallGoldMineCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[SmallGoldMineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell setSmallGoldMineCellWithDictionary:[brandArray objectAtIndex:indexPath.row]];
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(tableView.bounds), 3.0)];
    [headerView setBackgroundColor:[UIColor colorWithRed:242.0/255.0
                                                   green:243.0/255.0
                                                    blue:240.0/255.0
                                                   alpha:1.0]];
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_delegate respondsToSelector:@selector(brandIntroduceWithIndexpath:)]) {
        [_delegate brandIntroduceWithIndexpath:indexPath];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 3.0;
}

-(void)getSmallGoldMineDataRequest:(NSInteger)type{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:@"001" forKey:@"uid"];
    [paramDict setObject:[Tools getAppVersion] forKey:@"version"];
    
    [self.getBrandReqeust postRequestWithSoapNamespace:@"getBrand" params:paramDict successBlock:^(id result) {
        
        if ([brandArray count]>0) {
            [brandArray removeAllObjects];
        }
        NSArray *brandInfo=[result objectForKey:@"Brands"];
        for (NSDictionary *brandDic in brandInfo) {
            [brandArray addObject:brandDic];
        }
        [self.vSquareTableView reloadData];
    } failureBlock:^(NSString *requestError) {
        
    } errorBlock:^(NSMutableString *errorStr) {
        
    }];
    paramDict=nil;
}

//获取广告图片
-(void)getBannarDataRequestWithUID:(NSString *)uID andVersion:(NSString *)version{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:@"001" forKey:@"uid"];
    [paramDict setObject:[Tools getAppVersion] forKey:@"version"];
    
    [self.getBannarRequest postRequestWithSoapNamespace:@"getBannar" params:paramDict successBlock:^(id result) {
        NSLog(@"bannar array=%@",result);
        if ([bannarArray count]>0) {
            [bannarArray removeAllObjects];
        }
        NSArray *banners=[(NSDictionary *)result objectForKey:@"Banners"];
        for (NSDictionary *bannersItem in banners) {
            [bannarArray addObject:bannersItem];
        }
        
        if ([bannarArray count]>0) {
            if (!self.advertisementView) {
                self.advertisementView=[[AdvertisementView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 150.0) andPictureArray:bannarArray];
                [self.view addSubview:self.advertisementView];
            }else{
                self.advertisementView=nil;
                self.advertisementView=[[AdvertisementView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 150.0) andPictureArray:bannarArray];
                [self.view addSubview:self.advertisementView];
            }
        }
    } failureBlock:^(NSString *requestError) {
        
    } errorBlock:^(NSMutableString *errorStr) {
        
    }];
    paramDict=nil;
}

//添加品牌
-(void)addBrand:(id)sender{
    if ([_delegate respondsToSelector:@selector(addBrand)]) {
        [_delegate addBrand];
    }
}

@end
