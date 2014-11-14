//
//  EditVIPAddressBookDetailViewController.m
//  GoldMine
//
//  Created by micheal on 14/11/12.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "EditVIPAddressBookDetailViewController.h"
#import "EditVipAddressBookTableFootView.h"
#import "VIPAddressBookDetailCell.h"

@interface EditVIPAddressBookDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation EditVIPAddressBookDetailViewController

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
    
    EditVipAddressBookTableFootView *footView=[[EditVipAddressBookTableFootView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 140.0)];
    
    self.editInfoTableView.delegate=self;
    self.editInfoTableView.dataSource=self;
    self.editInfoTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.editInfoTableView.showsVerticalScrollIndicator=NO;
    self.editInfoTableView.tableFooterView=footView;
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -
#pragma mark UITBLEVIEW DELEGATE
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    return 45.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }else{
        return 4;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
        return 20.0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPat{
    static NSString *cellIdentifer=@"CellIdentifier";
    VIPAddressBookDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"VIPAddressBookDetailCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.infoLabel.userInteractionEnabled=YES;
    
    if (indexPat.section==0&&[self.infoSectionOneArray count]>0) {
        [cell setVIPAddressBookDetailCelWithInfoDictionary:[self.infoSectionOneArray objectAtIndex:indexPat.row]];
    }else if(indexPat.section==1&&[self.infosectionTwoArray count]>0){
        [cell setVIPAddressBookDetailCelWithInfoDictionary:[self.infosectionTwoArray objectAtIndex:indexPat.row]];
    }
    
    return cell;

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
