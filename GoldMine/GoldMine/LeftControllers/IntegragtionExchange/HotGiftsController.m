//
//  HotGiftsController.m
//  GoldMine
//
//  Created by Oliver on 14-10-7.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "HotGiftsController.h"
#import "GiftView.h"
#import "GiftEntity.h"

@interface HotGiftsController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *giftArray;
@property (nonatomic, strong) SoapRequest *giftsRequest;

@end

@implementation HotGiftsController

#pragma mark - Lifecycle
- (void)dealloc
{
    [self.giftArray removeAllObjects];
    self.giftArray = nil;
}

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
    [self requstAllHotGitfsData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup
{
    self.view.backgroundColor = GRAY_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.giftArray = [NSMutableArray array];
}

#pragma mark - Request data
- (void)requstAllHotGitfsData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *userInfoDict = [USERDEFAULT objectForKey:USERINFO];
    NSString *uid = userInfoDict[kUserId] == nil ? @"001" : userInfoDict[kUserId];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:[Tools getAppVersion] forKey:@"version"];
    [paramDict setObject:uid forKey:@"uid"];
    
    self.giftsRequest = [[SoapRequest alloc] init];
    __weak typeof(&*self) weakSelf = self;
    [self.giftsRequest postRequestWithSoapNamespace:@"getExchangeList" params:paramDict successBlock:^(id result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.giftsRequest = nil;
        DLog(@"积分兑换gifts ＝ %@", result);
        [weakSelf parseGiftsData:result];
        
    } failureBlock:^(NSString *requestError) {
        SHOW_BAD_NETWORK_TOAST(weakSelf.view);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.giftsRequest = nil;
        
    } errorBlock:^(NSMutableString *errorStr) {
        [weakSelf.view makeToast:errorStr];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.giftsRequest = nil;
    }];
}

- (void)parseGiftsData:(id)result
{
    NSDictionary *resultDict= (NSDictionary *)result;
    NSArray *dataArray = resultDict[@"ExchangeList"];
    if ( ! [dataArray isEqual:@""] && dataArray.count > 0) {
        for (NSDictionary *dict in dataArray) {
            GiftEntity *entity = [[GiftEntity alloc] initWithDict:dict];
            [self.giftArray addObject:entity];
        }
        [self.tableView reloadData];
    } else {
        [self.view makeToast:@"暂无积分兑换信息"];
    }
}


static const int column = 2;
static const int gridWith = 142;
static const int gridHeight = 146;
#pragma mark - UITableView dataSource && delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int value = self.giftArray.count % column > 0 ? 1 : 0;
    int line = (int)self.giftArray.count / column + value;
    
    return line * (gridHeight + 16);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"GiftCell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    CGFloat contextWidth = self.tableView.bounds.size.width;
    CGFloat contextHeight = ((self.giftArray.count-1)/column + 1 ) * (gridHeight + 16);
    CGFloat xGap = (contextWidth - column * gridWith) / (column + 1);
    CGFloat yGap = (contextHeight - ((self.giftArray.count-1)/column + 1) * gridHeight) / ((self.giftArray.count-1)/column + 2);
    
    for (int i = 0; i < self.giftArray.count; i ++) {
        CGFloat X = xGap + i % column * (gridWith + xGap);
        CGFloat Y = yGap + i / column * (gridHeight + yGap);
        
        GiftView *giftView = [GiftView loadNibInstance];
        giftView.giftEntity = self.giftArray[i];
        giftView.frame = CGRectMake(X, Y, gridWith, gridHeight);
        [giftView.touchButton addTarget:self action:@selector(clickedThisGift:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:giftView];
    }
    
    
    return cell;
}

- (void)clickedThisGift:(UIButton *)button
{
    GiftView *giftView = (GiftView *)button.superview;
    
    if ([self.delegate respondsToSelector:@selector(hotGiftsController:didSelectGiftWithCode:)]) {
        [self.delegate hotGiftsController:self didSelectGiftWithCode:giftView.giftEntity.IssueCode];
    }
}

@end
