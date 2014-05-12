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


@implementation SmallGoldMineSideDrawerViewController

@synthesize titleArray=_titleArray;
@synthesize imageStringArray=_imageStringArray;
@synthesize shopSwitch;

-(id)init{
    self=[super init];
    if (self) {
        self.titleArray=[NSArray arrayWithObjects:@"VIP通讯录",@"积分换礼",@"任务发布",@"主推产品",nil];
        self.imageStringArray=[NSArray arrayWithObjects:@"vip_phonebook",@"credit_git",@"task_release",@"hot_product",nil];
        
        UILabel *titleLable=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 44.0)];
        titleLable.text=@"我的";
        titleLable.font=[UIFont systemFontOfSize:24.0];
        titleLable.textAlignment=NSTextAlignmentCenter;
        titleLable.textColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];;
        self.navigationItem.titleView=titleLable;
        titleLable=nil;
        
        UIButton* leftBarbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28.0, 27.0)];
        [leftBarbutton setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
        [leftBarbutton setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateHighlighted];
        
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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(tableView.bounds), 150.0)];
//    [headerView setBackgroundColor:[UIColor colorWithRed:51.0/255.0
//                                                   green:51.0/255.0
//                                                    blue:51.0/255.0
//                                                   alpha:1.0]];
//  
////    if (_photoView == nil) {
////        _photoView = [[MenuTopPhotoView alloc] initWithFrame:CGRectMake(0.0, 0.0, 240.f, 200.0f)];
////        [_photoView setBackgroundColor:[UIColor colorWithRed:51.0/255.0
////                                                       green:51.0/255.0
////                                                        blue:51.0/255.0
////                                                       alpha:1.0]];
////    }
////    [headerView addSubview:_photoView];
////    [_photoView setDelegate:self];
//    return headerView;
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66.0;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    if (indexPath.row==0) {
        //VIP通讯录

//        [self.mm_drawerController setCenterViewController:appDelegateTabbar withCloseAnimation:YES completion:nil];
//        [self.mm_drawerController setRightDrawerViewController:nil];
        
    }else if (indexPath.row==1){
        //积分换礼
//            SearchSameCityViewController *searchSameCityVC=[[SearchSameCityViewController alloc] init];
//            MyNavigationViewController *searchAnchorPageNav=[[MyNavigationViewController alloc] initWithRootViewController:searchSameCityVC];
//            [self.mm_drawerController setCenterViewController:searchAnchorPageNav withCloseAnimation:YES completion:nil];
    }else if (indexPath.row==2) {
        //任务发布
//        SearchAnchorViewController *searchAnchorVC=[[SearchAnchorViewController alloc] init];
//        MyNavigationViewController *searchAnchorNav=[[MyNavigationViewController alloc] initWithRootViewController:searchAnchorVC];
//        [self.mm_drawerController setCenterViewController:searchAnchorNav withCloseAnimation:YES completion:nil];
//        [self.mm_drawerController setRightDrawerViewController:nil];
    }else if (indexPath.row==3){
        //主推产品
    }
}


@end
