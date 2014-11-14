//
//  SuperViewController.m
//  iShow
//
//  Created by laurence on 13-11-21.
//  Copyright (c) 2013年 56.com. All rights reserved.
//

#import "SuperViewController.h"

@interface SuperViewController ()

@end

@implementation SuperViewController

#pragma mark - Lifecycle
- (id) init
{
	self = [super init];
	if (self != nil)
	{
        _bNeedShowRightBarButtonItem = NO;
        _bNeedShowBackBarButtonItem = NO;
	}
	return self;
}

- (void)loadView
{
	[super loadView];
    
	self.view.backgroundColor = [UIColor whiteColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    
    self.navigationController.navigationBar.barTintColor=[Utils colorWithHexString:@"EE1c24"];
    self.navigationController.navigationBar.translucent=NO;

//	[self drawView];
}

- (void)drawView
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:238.f/255 green:28.f/255 blue:36.f/255 alpha:1] CGColor]);

    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setShadowImage:)]){
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc ] init]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    [self configNaviTitle];
    [self configLeftBarButtonItem];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (IS_IOS7) {
        self.view.frame = self.view.superview.bounds;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NaviBar configuration
- (void)configLeftBarButtonItem
{
    if (_bNeedShowBackBarButtonItem) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 20, 28);
        [backButton setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(clickedBack:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        backButton = nil;
    }
}

- (void)configNaviTitle:(NSString *)titleStr
{
//    NSShadow *shadow = [[NSShadow alloc] init];
//    shadow.shadowOffset = CGSizeMake(-1, 0);
//    shadow.shadowBlurRadius = 5;
//    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:18],
//                                                                    NSForegroundColorAttributeName : [UIColor whiteColor],
//                                                                    NSShadowAttributeName : shadow
//                                                                    };
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 400, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = titleStr;
    self.navigationItem.titleView = titleLabel;
    titleLabel=nil;
}

#pragma mark - Button events
- (void)clickedBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
