//
//  AppDelegate.h
//  GoldMine
//
//  Created by micheal on 14-5-11.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    NetworkStatus netWorkStatus;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) UINavigationController *goldMineNav;

@property(nonatomic,retain) MMDrawerController *drawerController;
@property (nonatomic,assign)NetworkStatus netWorkStatus;

@end
