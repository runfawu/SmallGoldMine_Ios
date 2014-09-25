//
//  VSquareViewController.m
//  GoldMine
//
//  Created by micheal on 14-9-25.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "VSquareViewController.h"
#import "SmallGoldMineCell.h"

@interface VSquareViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) SoapRequest *loginReqeust;

@end

@implementation VSquareViewController

@synthesize vSquareTableView=_vSquareTableView;

-(void)viewDidLoad{
    [super viewDidLoad];
    
    brandArray=[[NSMutableArray alloc] init];
    
    UIImageView *bannerImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 150.0)];
    bannerImageView.userInteractionEnabled=YES;
    bannerImageView.image=[UIImage imageNamed:@"banner"];
    [self.view addSubview:bannerImageView];
    
    UIImageView *bannerSeperateLine=[[UIImageView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(bannerImageView.frame), self.view.frame.size.width, 3.0)];
    bannerSeperateLine.image=[UIImage imageNamed:@"banner_seperateLine"];
    [self.view addSubview:bannerSeperateLine];
    
    self.vSquareTableView=[[UITableView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(bannerSeperateLine.frame), self.view.frame.size.width, self.view.frame.size.height-190.0)];
    self.vSquareTableView.dataSource=self;
    self.vSquareTableView.delegate=self;
    self.vSquareTableView.showsHorizontalScrollIndicator = NO;
    self.vSquareTableView.showsVerticalScrollIndicator = NO;
    self.vSquareTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.vSquareTableView];
    
    bannerSeperateLine=nil;
    bannerImageView=nil;
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
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(tableView.bounds), 8.0)];
    [headerView setBackgroundColor:[UIColor colorWithRed:242.0/255.0
                                                   green:243.0/255.0
                                                    blue:240.0/255.0
                                                   alpha:1.0]];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8.0;
}

-(void)getSmallGoldMineDataRequest:(NSInteger)type{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:@"001" forKey:@"uid"];
    [paramDict setObject:[Tools getAppVersion] forKey:@"version"];
    
    self.loginReqeust = [[SoapRequest alloc] init];
    [self.loginReqeust postRequestWithSoapNamespace:@"getBrand" params:paramDict successBlock:^(id result) {
        DLog(@"login success result = %@", result);
        if (type==4) {
            if ([brandArray count]>0) {
                [brandArray removeAllObjects];
            }
            
            NSArray *brandInfo=[result objectForKey:@"BardInfo"];
            for (NSDictionary *brandDic in brandInfo) {
                [brandArray addObject:brandDic];
            }
            [self.vSquareTableView reloadData];
        }
    } failureBlock:^(NSString *requestError) {
        
    } errorBlock:^(NSMutableString *errorStr) {
        
    }];
    paramDict=nil;
}


@end
