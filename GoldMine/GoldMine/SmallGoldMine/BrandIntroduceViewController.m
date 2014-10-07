//
//  BrandIntroduceViewController.m
//  GoldMine
//
//  Created by micheal on 14-10-5.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "BrandIntroduceViewController.h"

@interface BrandIntroduceViewController ()

@end

@implementation BrandIntroduceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"品牌介绍";
        
        _bNeedShowBackBarButtonItem = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
