//
//  SmallGoldMineViewController.m
//  GoldMine
//
//  Created by micheal on 14-5-11.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "SmallGoldMineViewController.h"

@implementation SmallGoldMineViewController

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
    
    [super viewDidLoad];
}


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
   
    _bNeedShowRightBarButtonItem = YES;
    _bNeedShowLogoView = YES;
    
    [super viewWillAppear:animated];

}

@end
