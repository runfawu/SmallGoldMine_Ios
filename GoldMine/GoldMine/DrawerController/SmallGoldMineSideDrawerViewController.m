// Copyright (c) 2013 Mutual Mobile (http://mutualmobile.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "SmallGoldMineSideDrawerViewController.h"
#import "DrawerLeftTableViewCell.h"
#import "WealthViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "RankViewController.h"
#import "ProfileViewController.h"
#import "VIPAddressBookViewController.h"
#import "IntegrationExchangeController.h"
#import "UIImageView+WebCache.h"
#import "MoreViewController.h"
#import "BuddyViewController.h"


@implementation SmallGoldMineSideDrawerViewController

@synthesize titleArray=_titleArray;
@synthesize imageStringArray=_imageStringArray;
@synthesize shopSwitch;

-(id)init{
    self=[super init];
    if (self) {
        self.titleArray=[NSArray arrayWithObjects:@"VIP通讯录",@"V宝换礼",nil];

        self.imageStringArray=[NSArray arrayWithObjects:@"vip_phonebook",@"credit_git",nil];

        self.title = @"我的";
        
        UIButton* leftBarbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28.0, 27.0)];
        [leftBarbutton setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
        [leftBarbutton setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateHighlighted];
        [leftBarbutton addTarget:self action:@selector(JumpToMore) forControlEvents:UIControlEventTouchUpInside];
        if (IS_IOS7) {
            //            [leftBarbutton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        }
        UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarbutton];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        leftBarbutton=nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DLog(@"left tableView frame = %@", NSStringFromCGRect(self.view.frame));
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0, self.view.frame.size.width, self.view.frame.size.height - NAVI_HEIGHT) style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:51.0/255.0
                                                       green:51.0/255.0
                                                        blue:51.0/255.0
                                                       alpha:1.0]];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    
    if (_photoView == nil) {
        _photoView = [[MenuTopPhotoView alloc] initWithFrame:CGRectMake(0.0, 0.0, 277.0f, 220.0f)];
        [_photoView setBackgroundColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0]];
    }
    [_photoView setDelegate:self];
    _tableView.tableHeaderView=_photoView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSDictionary *userDict = [USERDEFAULT objectForKey:USERINFO];
    _photoView.numberLabel.text = [NSString stringWithFormat:@"编号: %@", userDict[kUserId]];
    [_photoView.photo setImageWithURL:[NSURL URLWithString:userDict[kPicture]]];
    //TODO: V宝数据
    //_photoView.creditLabel.text = userDict
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)JumpToMore
{
    MoreViewController *moreController = [[MoreViewController alloc] initWithNibName:@"MoreViewController" bundle:nil];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:moreController];
    
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier=@"CellIndentifier";
    DrawerLeftTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell==nil) {
        cell=[[DrawerLeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    UIView *selectedBgView=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320,59.0)];
    selectedBgView.backgroundColor=[UIColor colorWithRed:87.0/255 green:87.0/255 blue:87.0/255 alpha:1];
    cell.selectedBackgroundView=selectedBgView;
   
    [cell setTileValueWithString:[self.titleArray objectAtIndex:indexPath.row] andGoodsImageViewWithImageString:[self.imageStringArray objectAtIndex:indexPath.row]];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66.0;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    if (indexPath.row==0) {
        //VIP通讯录

        VIPAddressBookViewController *vipAddressBookVC=[[VIPAddressBookViewController alloc] initWithNibName:@"VIPAddressBookViewController" bundle:nil];
        UINavigationController *vipAddressBookNav=[[UINavigationController alloc] initWithRootViewController:vipAddressBookVC];
        
        [self.navigationController pushViewController:vipAddressBookNav animated:YES];
        
    }else if (indexPath.row==1){
        //V宝换礼
        IntegrationExchangeController *exchangeController = [[IntegrationExchangeController alloc] initWithNibName:@"IntegrationExchangeController" bundle:nil];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:exchangeController];
        
        [self presentViewController:navi animated:YES completion:nil];
    }
}

#pragma mar - MenuTopPhotoViewDelegate
- (void)tapPhotoView
{
    ProfileViewController *profileController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:profileController];
    
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)tapWealthImageView:(MenuTopPhotoView *)photoView
{
    WealthViewController *wealthController = [[WealthViewController alloc] initWithNibName:@"WealthViewController" bundle:nil];
    UINavigationController *wealthNavi = [[UINavigationController alloc] initWithRootViewController:wealthController];
    
    [self presentViewController:wealthNavi animated:YES completion:nil];
}

- (void)tapRankImageView:(MenuTopPhotoView *)photoView
{
    RankViewController *rankController = [[RankViewController alloc] initWithNibName:@"RankViewController" bundle:nil];
    UINavigationController *rankNavi = [[UINavigationController alloc] initWithRootViewController:rankController];
    
    [self presentViewController:rankNavi animated:YES completion:nil];
}

- (void)tapGuysImageView:(MenuTopPhotoView *)photoView
{
    BuddyViewController *buddyVC=[[BuddyViewController alloc] initWithNibName:@"BuddyViewController" bundle:nil];
    UINavigationController *buddyNav=[[UINavigationController alloc] initWithRootViewController:buddyVC];
    [self presentViewController:buddyNav animated:YES completion:nil];
}

@end
