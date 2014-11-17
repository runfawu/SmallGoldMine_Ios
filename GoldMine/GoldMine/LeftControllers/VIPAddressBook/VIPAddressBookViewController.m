//
//  VIPAddressBookViewController.m
//  GoldMine
//
//  Created by micheal on 14/11/11.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "VIPAddressBookViewController.h"
#import "AppDelegate.h"
#import "Tools.h"
#import "pinyin.h"
#import "VIPAddressBookViewCell.h"
#import "VIPAddressBookDetailViewController.h"

@interface VIPAddressBookViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic,strong) SoapRequest *vipRequest;

@end

@implementation VIPAddressBookViewController

@synthesize vipTableView;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _bNeedShowBackBarButtonItem = YES;
        [self configNaviTitle:@"VIP通讯"];
    }
    return self;
}

-(id)init{
    self=[super init];
    if (self) {
        _bNeedShowBackBarButtonItem = YES;
        [self configNaviTitle:@"VIP通讯"];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
        self.contactLists=[NSMutableArray array];
        for (int i=0; i<27; i++) {
            [self.contactLists addObject:[NSMutableArray array]];
        }
    
        self.sectionNames=[[NSMutableArray alloc] init];
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
    
        self.vipSearchBar.delegate=self;
//        self.vipSearchBar.tintColor=[UIColor grayColor];
//        self.vipSearchBar.barTintColor=[UIColor colorWithRed:239.0/255 green:163.0/255 blue:167.0/255 alpha:1.0];
    
        self.vipSearchBar.translatesAutoresizingMaskIntoConstraints=NO;
        self.vipSearchBar.backgroundColor=[UIColor colorWithRed:239.0/255 green:163.0/255 blue:167.0/255 alpha:1.0];
        [self.vipSearchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"search_bg"] forState:UIControlStateNormal];
        [[[[self.vipSearchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
    
        self.vipTableView.delegate=self;
        self.vipTableView.dataSource=self;
        self.vipTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
        [self getVipDataRequest];
}

#pragma mark -
#pragma mark UITBLEVIEW DELEGATE
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.sectionNames count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUInteger letterIndex=[ALPHA rangeOfString:[self.sectionNames objectAtIndex:section]].location;
    return [[self.contactLists objectAtIndex:letterIndex] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer=@"CellIdentifier";
    VIPAddressBookViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell) {
        cell=[[VIPAddressBookViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if ([self.contactLists count]>0) {
        NSUInteger letterIndex=[ALPHA rangeOfString:[self.sectionNames objectAtIndex:indexPath.section]].location;
        [cell setVIPAddressBookViewCellWithDictionary:[[self.contactLists objectAtIndex:letterIndex] objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *headerText;
    if ([self.sectionNames count]>0) {
        headerText = self.sectionNames[section];
        UILabel *textLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0, [UIScreen mainScreen].bounds.size.height, 25.0)];
        textLabel.text = [NSString stringWithFormat:@"   %@",(NSString *) headerText];
        textLabel.font=[UIFont systemFontOfSize:14.0];
        textLabel.backgroundColor=[UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0];
        return textLabel;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34.0;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    NSInteger count=0;
    for (NSString *character in self.sectionNames) {
        if ([character isEqualToString:title]) {
            return  count;
        }
        
        count++;
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([self.sectionNames count]==0) {
        return @"";
    }
    return [self.sectionNames objectAtIndex:section];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.comeFromInputPage) {
        NSUInteger letterIndex=[ALPHA rangeOfString:[self.sectionNames objectAtIndex:indexPath.section]].location;
        NSString *phone = [[[self.contactLists objectAtIndex:letterIndex] objectAtIndex:indexPath.row] objectForKey:@"CusPhone"];
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.renderPhoneBlock) {
                self.renderPhoneBlock(phone);
            }
        }];
    } else {
        VIPAddressBookDetailViewController *detailVC=[[VIPAddressBookDetailViewController alloc] initWithNibName:@"VIPAddressBookDetailViewController" bundle:nil];
        NSUInteger letterIndex=[ALPHA rangeOfString:[self.sectionNames objectAtIndex:indexPath.section]].location;
        detailVC.customID=[[[self.contactLists objectAtIndex:letterIndex] objectAtIndex:indexPath.row] objectForKey:@"CusID"];
        [self.navigationController pushViewController:detailVC animated:YES];
        detailVC=nil;
    }
}

-(void)getVipDataRequest{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:@"001" forKey:@"uid"];
    [paramDict setObject:[NSNumber  numberWithInt:1] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:10] forKey:@"row"];
    [paramDict setObject:@"" forKey:@"keyword"];
    [paramDict setObject:[Tools getAppVersion] forKey:@"version"];
    
    [self.vipRequest postRequestWithSoapNamespace:@"MyVips" params:paramDict successBlock:^(id result) {
        DLog(@"My Vips result=%@", result);
        NSMutableArray *myVipsArray=[(NSDictionary *)result objectForKey:@"MyVips"];
        
        for (NSDictionary *dic in myVipsArray) {
            if ([Tools searchResult:[dic objectForKey:@"CusName"] searchText:@"曾"]) {
                sectionName=@"Z";
            }else if ([Tools searchResult:[dic objectForKey:@"CusName"] searchText:@"解"]){
                sectionName=@"X";
            }else if ([Tools searchResult:[dic objectForKey:@"CusName"] searchText:@"仇"]){
                sectionName=@"Q";
            }else if ([Tools searchResult:[dic objectForKey:@"CusName"] searchText:@"朴"]){
                sectionName=@"P";
            }else if ([Tools searchResult:[dic objectForKey:@"CusName"] searchText:@"查"]){
                sectionName=@"Z";
            }else if ([Tools searchResult:[dic objectForKey:@"CusName"] searchText:@"能"]){
                sectionName=@"N";
            }else if ([Tools searchResult:[dic objectForKey:@"CusName"] searchText:@"乐"]){
                sectionName=@"Y";
            }else if ([Tools searchResult:[dic objectForKey:@"CusName"] searchText:@"单"]){
                sectionName=@"S";
            }else{
                sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([[dic objectForKey:@"CusName"]  characterAtIndex:0])] uppercaseString];
            }
            NSUInteger firstLetter=[ALPHA rangeOfString:[sectionName substringToIndex:1]].location;
            if(firstLetter!=NSNotFound){
                //去掉重复的
                if (![self.sectionNames containsObject:sectionName]) {
                    [self.sectionNames addObject:sectionName];
                }
                [[self.contactLists objectAtIndex:firstLetter] addObject:dic];
            }
        }
        //sectionName 排序
        [self.sectionNames sortUsingComparator:^(id obj1,id obj2){
            return [obj1 compare:obj2 options:NSLiteralSearch];
        }];
        [self.vipTableView reloadData];
        
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

#pragma mark -
#pragma mark -UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length>0) {
        NSLog(@"good!!!!");
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.vipSearchBar resignFirstResponder];
    NSLog(@"ts ts!!");
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
