//
//  IntegrationExchangeController.m
//  GoldMine
//
//  Created by Oliver on 14-10-7.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "IntegrationExchangeController.h"
#import "HotGiftsController.h"
#import "ExchangeDetailController.h"

@interface IntegrationExchangeController ()<UIScrollViewDelegate, HotGiftsDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) HotGiftsController *hotGitfsController;
@property (nonatomic, strong) HotGiftsController *totalGiftsController;

@end

@implementation IntegrationExchangeController

#pragma mark - Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _bNeedShowBackBarButtonItem = YES;
        self.title = @"积分换礼";
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

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    DLog(@"integrationExchange view frame = %@", NSStringFromCGRect(self.view.frame));
    self.scrollView.frame = CGRectMake(0, 40, self.view.frame.size.width, self.view.bounds.size.height - 40);
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, self.scrollView.frame.size.height);
    
    CGRect frame = self.hotGitfsController.view.frame;
    frame.size.height = self.scrollView.frame.size.height;
    self.hotGitfsController.view.frame = frame;
    
    frame = self.totalGiftsController.view.frame;
    frame.origin.x = self.scrollView.frame.size.width;
    frame.size.height = self.scrollView.frame.size.height;
    self.totalGiftsController.view.frame = frame;
}

- (void)setup
{
    self.view.backgroundColor = GRAY_COLOR;
    
    NSDictionary *attrDict = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
    [self.segmentedControl setTitleTextAttributes:attrDict forState:UIControlStateNormal];
    
    self.scrollView.pagingEnabled = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView.bounces = NO;
    
    if ( ! self.hotGitfsController) {
        self.hotGitfsController = [[HotGiftsController alloc] initWithNibName:@"HotGiftsController" bundle:nil];
        self.hotGitfsController.isHot = YES;
        self.hotGitfsController.delegate = self;
        
        [self.scrollView addSubview:self.hotGitfsController.view];
    }
    
    if ( ! self.totalGiftsController) {
        self.totalGiftsController = [[HotGiftsController alloc] initWithNibName:@"HotGiftsController" bundle:nil];
        self.totalGiftsController.isHot = NO;
        self.totalGiftsController.delegate = self;
        
        [self.scrollView addSubview:self.totalGiftsController.view];
    }
}

#pragma mark - HotGifts delegate
- (void)hotGiftsController:(HotGiftsController *)giftsController didSelectGiftWithCode:(NSString *)giftCode
{
    ExchangeDetailController *exchangeController = [[ExchangeDetailController alloc] initWithNibName:@"ExchangeDetailController" bundle:nil];
    exchangeController.giftCode = giftCode;
    
    [self.navigationController pushViewController:exchangeController animated:YES];
}

#pragma mark - Segment event
- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender {
    NSInteger index = sender.selectedSegmentIndex;
    [self.scrollView setContentOffset:CGPointMake(index * self.scrollView.frame.size.width, 0) animated:YES];
}

#pragma mark - ScrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = fabs(scrollView.contentOffset.x / scrollView.frame.size.width);
    self.segmentedControl.selectedSegmentIndex = index;
}

- (void)clickedBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
