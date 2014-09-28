//
//  IntegrationBarResultController.m
//  GoldMine
//
//  Created by Oliver on 14-9-28.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "IntegrationBarResultController.h"

@interface IntegrationBarResultController ()

@end

@implementation IntegrationBarResultController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _bNeedShowBackBarButtonItem = YES;
        self.title = @"扫描积分";
        
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





#pragma mark - Override
- (void)clickedBack:(id)sender
{
    [super clickedBack:sender];
}

@end
