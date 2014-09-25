//
//  RankViewController.m
//  GoldMine
//
//  Created by Dongfuming on 14-9-21.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "RankViewController.h"
#import "RankCell.h"

@interface RankViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *rankArray;

@end

@implementation RankViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _bNeedShowBackBarButtonItem = YES;
        self.title = @"排名";
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
    // Dispose of any resources that can be recreated.
}

- (void)setup
{
    self.rankArray = [NSMutableArray array];
    for (int i = 0; i < 55; i ++) {
        NSString *text = @"hello world";
        [self.rankArray addObject:text];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RankCell" bundle:nil] forCellReuseIdentifier:@"RankCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableView dataSource && delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rankArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"RankCell";
    RankCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (indexPath.row == 0) {
        cell.rankImageView.image = [UIImage imageNamed:@"rankCell_one"];
        cell.rankLabel.hidden = YES;
    } else if (indexPath.row == 1) {
        cell.rankImageView.image = [UIImage imageNamed:@"rankCell_two"];
        cell.rankLabel.hidden = YES;
    } else if (indexPath.row == 2) {
        cell.rankImageView.image = [UIImage imageNamed:@"rankCell_three"];
        cell.rankLabel.hidden = YES;
    } else {
        cell.rankLabel.text = [NSString stringWithFormat:@"%d", (int)indexPath.row];
    }
    
    return cell;
}

#pragma mark - Override
- (void)clickedBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
