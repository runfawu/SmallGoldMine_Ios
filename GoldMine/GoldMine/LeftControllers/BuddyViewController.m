//
//  BuddyViewController.m
//  GoldMine
//
//  Created by micheal on 14/11/11.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "BuddyViewController.h"
#import "pinyin.h"
#import "VIPAddressBookViewCell.h"
#import "BuddyViewDetailViewController.h"

@interface BuddyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) SoapRequest *sessionRequest;
@property (nonatomic,strong) SoapRequest *friendsRequest;

@end

@implementation BuddyViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _bNeedShowBackBarButtonItem=YES;
        [self configNaviTitle:@"小伙伴"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentPage=1;
    isSelectedFriend=NO;
    
    self.friendsLists=[NSMutableArray array];
    for (int i=0; i<27; i++) {
        [self.friendsLists addObject:[NSMutableArray array]];
    }
    
    self.sessionRequest=[[SoapRequest alloc] init];
    self.friendsRequest=[[SoapRequest alloc] init];
    
    self.sectionNames=[[NSMutableArray alloc] init];
    
//    self.segementBackgroundView.backgroundColor=[UIColor redColor];
    self.segementBackgroundView.layer.cornerRadius=5.0;
    self.segementBackgroundView.layer.borderWidth=1.0;
    self.segementBackgroundView.clipsToBounds = YES;
    self.segementBackgroundView.layer.borderColor=[Utils colorWithHexString:@"EE1c24"].CGColor;

    [self.answerButton setBackgroundColor:[Utils colorWithHexString:@"EE1c24"]];
    [self.answerButton setTintColor:[UIColor whiteColor]];
    [self.answerButton addTarget:self action:@selector(answerButtonDidDown:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.buddyButton setTintColor:[Utils colorWithHexString:@"EE1c24"]];
    [self.buddyButton addTarget:self action:@selector(buddyButtonDidDown:) forControlEvents:UIControlEventTouchUpInside];
    
    self.buddyTableView.dataSource=self;
    self.buddyTableView.delegate=self;
    self.buddyTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
//    noDataNoticeLabel=[[UILabel alloc] init];
//    noDataNoticeLabel.center=self.view.center;
//    noDataNoticeLabel.textAlignment=NSTextAlignmentCenter;
//    noDataNoticeLabel.text=@"暂无数据";
//    noDataNoticeLabel.font=[UIFont systemFontOfSize:13.0];
//    noDataNoticeLabel.translatesAutoresizingMaskIntoConstraints=NO;
//    [self.buddyTableView addSubview:noDataNoticeLabel];
//   
//    NSMutableArray *contraits=[NSMutableArray array];
//    [contraits addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-100-[noDataNoticeLabel(==120)]-100-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(noDataNoticeLabel)]];
//    [contraits addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[noDataNoticeLabel(==60)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(noDataNoticeLabel)]];
//    [self.buddyTableView addConstraints:contraits];
//    noDataNoticeLabel=nil;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)answerButtonDidDown:(id)sender{
    isSelectedFriend=NO;
    
    [self.answerButton setBackgroundColor:[Utils colorWithHexString:@"EE1c24"]];
    [self.answerButton setTintColor:[UIColor whiteColor]];
    
    [self.buddyButton setBackgroundColor:[UIColor whiteColor]];
    [self.buddyButton setTintColor:[Utils colorWithHexString:@"EE1c24"]];
    
//    noDataNoticeLabel.hidden=NO;
    
    [self.buddyTableView reloadData];
    
    
}

-(void)buddyButtonDidDown:(id)sender{
    isSelectedFriend=YES;
    
    for (int i=0; i<27; i++) {
        [self.friendsLists[i] removeAllObjects];
    }
    
    [self.sectionNames removeAllObjects];
    
    [self.answerButton setBackgroundColor:[UIColor whiteColor]];
    [self.answerButton setTintColor:[Utils colorWithHexString:@"EE1c24"]];
    
    [self.buddyButton setBackgroundColor:[Utils colorWithHexString:@"EE1c24"]];
    [self.buddyButton setTintColor:[UIColor whiteColor]];
    
    [self buddyFriendsDataRequest];
}

#pragma mark -
#pragma mark UITBLEVIEW DELEGATE
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isSelectedFriend) {
         return 52.0;
    }else
        return 0.0;
   
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (isSelectedFriend) {
        return [self.sectionNames count];
    }else
        return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isSelectedFriend) {
        NSUInteger letterIndex=[ALPHA rangeOfString:[self.sectionNames objectAtIndex:section]].location;
        return [[self.friendsLists objectAtIndex:letterIndex] count];
    }else
        return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer=@"CellIdentifier";
    VIPAddressBookViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell) {
        cell=[[VIPAddressBookViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (isSelectedFriend) {
        if ([self.friendsLists count]>0) {
            NSUInteger letterIndex=[ALPHA rangeOfString:[self.sectionNames objectAtIndex:indexPath.section]].location;
            [cell setVIPAddressBookViewCellWithDictionary:[[self.friendsLists objectAtIndex:letterIndex] objectAtIndex:indexPath.row]];
        }
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
    BuddyViewDetailViewController *detailVC=[[BuddyViewDetailViewController alloc] initWithNibName:@"BuddyViewDetailViewController" bundle:nil];
    NSUInteger letterIndex=[ALPHA rangeOfString:[self.sectionNames objectAtIndex:indexPath.section]].location;
    detailVC.friedId=[[[self.friendsLists objectAtIndex:letterIndex] objectAtIndex:indexPath.row] objectForKey:@"UserID"];
    [self.navigationController pushViewController:detailVC animated:YES];
    detailVC=nil;
}

-(void)buddyFriendsDataRequest{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:@"001" forKey:@"uid"];
    [paramDict setObject:[NSNumber  numberWithInt:1] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:10] forKey:@"row"];
    [paramDict setObject:@"" forKey:@"keyword"];
    [paramDict setObject:[Tools getAppVersion] forKey:@"version"];
    
    [self.friendsRequest postRequestWithSoapNamespace:@"MyFriends" params:paramDict successBlock:^(id result) {
        DLog(@"MyFriends result=%@", result);
        NSMutableArray *myVipsArray=[(NSDictionary *)result objectForKey:@"MyFriends"];
        
        for (NSDictionary *dic in myVipsArray) {
            if ([Tools searchResult:[dic objectForKey:@"UserName"] searchText:@"曾"]) {
                sectionName=@"Z";
            }else if ([Tools searchResult:[dic objectForKey:@"UserName"] searchText:@"解"]){
                sectionName=@"X";
            }else if ([Tools searchResult:[dic objectForKey:@"UserName"] searchText:@"仇"]){
                sectionName=@"Q";
            }else if ([Tools searchResult:[dic objectForKey:@"UserName"] searchText:@"朴"]){
                sectionName=@"P";
            }else if ([Tools searchResult:[dic objectForKey:@"UserName"] searchText:@"查"]){
                sectionName=@"Z";
            }else if ([Tools searchResult:[dic objectForKey:@"UserName"] searchText:@"能"]){
                sectionName=@"N";
            }else if ([Tools searchResult:[dic objectForKey:@"UserName"] searchText:@"乐"]){
                sectionName=@"Y";
            }else if ([Tools searchResult:[dic objectForKey:@"UserName"] searchText:@"单"]){
                sectionName=@"S";
            }else{
                sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([[dic objectForKey:@"UserName"]  characterAtIndex:0])] uppercaseString];
            }
            NSUInteger firstLetter=[ALPHA rangeOfString:[sectionName substringToIndex:1]].location;
            if(firstLetter!=NSNotFound){
                //去掉重复的
                if (![self.sectionNames containsObject:sectionName]) {
                    [self.sectionNames addObject:sectionName];
                }
                [[self.friendsLists objectAtIndex:firstLetter] addObject:dic];
            }
        }
        //sectionName 排序
        [self.sectionNames sortUsingComparator:^(id obj1,id obj2){
            return [obj1 compare:obj2 options:NSLiteralSearch];
        }];
        
        [self.buddyTableView reloadData];
        
//        if ([self.sectionNames count]>0) {
//            noDataNoticeLabel.hidden=YES;
//        }else{
//            noDataNoticeLabel.hidden=NO;
//        }
        
    } failureBlock:^(NSString *requestError) {
        DLog(@"MyFriends  failure!!!");
    } errorBlock:^(NSMutableString *errorStr) {
        DLog(@"MyFriends error!!!");
    }];
    paramDict=nil;

}

- (void)clickedBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
