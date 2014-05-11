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

- (id) init
{
	self = [super init];
	if (self != nil)
	{
        _bNeedShowRightBarButtonItem = NO;
        _bNeedShowLogoView = NO;
	}
	return self;
}

- (void)loadView
{
	[super loadView];
	self.view.backgroundColor = [UIColor whiteColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
	[self drawView];
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
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (IS_IOS7) {
        self.view.frame = self.view.superview.bounds;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
