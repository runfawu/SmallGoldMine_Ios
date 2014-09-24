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
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return goldenCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"GoldenCell";
    GoldenCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
