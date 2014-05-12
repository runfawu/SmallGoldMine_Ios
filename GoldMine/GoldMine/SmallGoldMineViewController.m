//
//  SmallGoldMineViewController.m
//  GoldMine
//
//  Created by micheal on 14-5-11.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "SmallGoldMineViewController.h"
#import "LoginController.h"

@implementation SmallGoldMineViewController

@synthesize segmentedControl;

-(id)init{
    self=[super init];
    if (self) {
        UILabel *titleLable=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 44.0)];
        titleLable.text=@"小V聚宝";
        titleLable.font=[UIFont systemFontOfSize:24.0];
        titleLable.textAlignment=NSTextAlignmentCenter;
        titleLable.textColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];;
        self.navigationItem.titleView=titleLable;
        titleLable=nil;
        
        UIButton* leftBarbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28.0, 27.0)];
        [leftBarbutton setImage:[UIImage imageNamed:@"personal"] forState:UIControlStateNormal];
        [leftBarbutton setImage:[UIImage imageNamed:@"personal"] forState:UIControlStateHighlighted];
        
        //FIXME: Test test test
        [leftBarbutton addTarget:self action:@selector(testLogin:) forControlEvents:UIControlEventTouchUpInside];
        
        if (IS_IOS7) {
//            [leftBarbutton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        }
        UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarbutton];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        leftBarbutton=nil;
        
        UIButton  *rightBarbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28.0, 27.0)];
        [rightBarbutton setImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
        [rightBarbutton setImage:[UIImage imageNamed:@"scan"] forState:UIControlStateHighlighted];
        UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarbutton];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        rightBarbutton=nil;
    }
    return self;
}

-(void)viewDidLoad{
    self.segmentedControl = [[CustomSegmentedControl alloc] initWithFrame:CGRectMake(0.0, 60.0, 320.0, 40)];
    if (IS_IOS7) {
        self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    [self.segmentedControl.vSquareButton addTarget:self action:@selector(selectedVSquareButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.segmentedControl.taskButton addTarget:self action:@selector(selectedTaskButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.segmentedControl.goldMineButton addTarget:self action:@selector(selectedGoldMineButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:segmentedControl];
//    segmentedControl=nil;
    
    UIImageView *bannerImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.segmentedControl.frame)-65.0, self.view.frame.size.width, 150.0)];
    bannerImageView.userInteractionEnabled=YES;
    bannerImageView.image=[UIImage imageNamed:@"banner"];
    [self.view addSubview:bannerImageView];
    
    [super viewDidLoad];
}


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
   
    _bNeedShowRightBarButtonItem = YES;
    _bNeedShowLogoView = YES;
    
    [super viewWillAppear:animated];
}


-(void)selectedVSquareButton:(id)sender{
    [self.segmentedControl.vSquareButton setTitleColor:[UIColor colorWithRed:249.0/255 green:186.0/255 blue:8.0/255 alpha:1.0] forState:UIControlStateNormal];
    [self.segmentedControl.taskButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]  forState:UIControlStateNormal];
    [self.segmentedControl.goldMineButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]  forState:UIControlStateNormal];
    self.segmentedControl.flagView.frame=CGRectMake(0.0,CGRectGetMaxY(segmentedControl.vSquareButton.frame)-5.0, 106.0, 5.0);
}

-(void)selectedTaskButton:(id)sender{
    [self.segmentedControl.vSquareButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
    [self.segmentedControl.taskButton setTitleColor:[UIColor colorWithRed:249.0/255 green:186.0/255 blue:8.0/255 alpha:1.0]  forState:UIControlStateNormal];
    [self.segmentedControl.goldMineButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]  forState:UIControlStateNormal];
    self.segmentedControl.flagView.frame=CGRectMake(segmentedControl.taskButton.frame.origin.x,CGRectGetMaxY(segmentedControl.vSquareButton.frame)-5.0, 106.0, 5.0);
}

-(void)selectedGoldMineButton:(id)sender{
    [self.segmentedControl.vSquareButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
    [self.segmentedControl.taskButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]  forState:UIControlStateNormal];
    [self.segmentedControl.goldMineButton setTitleColor:[UIColor colorWithRed:249.0/255 green:186.0/255 blue:8.0/255 alpha:1.0]  forState:UIControlStateNormal];
    self.segmentedControl.flagView.frame=CGRectMake(segmentedControl.goldMineButton.frame.origin.x,CGRectGetMaxY(segmentedControl.vSquareButton.frame)-5.0, 106.0, 5.0);
}

#pragma mark - Test
- (void)testLogin:(id)sender
{
    LoginController *loginController = [[LoginController alloc] initWithNibName:@"LoginController" bundle:nil];
    [self presentViewController:loginController animated:YES completion:nil];
}

@end