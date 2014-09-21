//
//  IntegrationDetailController.m
//  GoldMine
//
//  Created by Dongfuming on 14-9-21.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "IntegrationDetailController.h"
#import "IntegrationDetailCell.h"

@interface IntegrationDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *integrationDetailArray;

@end

@implementation IntegrationDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _bNeedShowBackBarButtonItem = YES;
        self.title = @"积分明细";
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
    self.integrationDetailArray = [NSMutableArray array];
    
    for (int i = 0; i < 25; i ++) {
        NSString *text = @"hello world";
        [self.integrationDetailArray addObject:text];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"IntegrationDetailCell" bundle:nil] forCellReuseIdentifier:@"IntegrationDetailCell"];
}

#pragma mark - UITableView dataSource && delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.integrationDetailArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"IntegrationDetailCell";
    IntegrationDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    return cell;
}

@end
