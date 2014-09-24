//
//  AppDelegate.h
//  GoldMine
//
//  Created by micheal on 14-5-11.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) UINavigationController *goldMineNav;

@property(nonatomic,retain) MMDrawerController *drawerController;

@end
