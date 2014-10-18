//
//  AppDelegate.m
//  GoldMine
//
//  Created by micheal on 14-5-11.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "AppDelegate.h"
#import "SmallGoldMineSideDrawerViewController.h"
#import "MMDrawerVisualState.h"
#import "SmallGoldMineDrawerVisualStateManager.h"
#import "SmallGoldMineViewController.h"
#import "LoginController.h"

@implementation AppDelegate

@synthesize goldMineNav=_goldMineNav;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //左侧栏
    SmallGoldMineSideDrawerViewController *leftMenuVC=[[SmallGoldMineSideDrawerViewController alloc] init];
    UINavigationController *leftMenuNav=[[UINavigationController alloc] initWithRootViewController:leftMenuVC];
    
    SmallGoldMineViewController *smallGoldMineVC=[[SmallGoldMineViewController alloc] init];
    UINavigationController *goldMineNavGation=[[UINavigationController alloc] initWithRootViewController:smallGoldMineVC];
    
    MMDrawerController * tmpDrawerController = [[MMDrawerController alloc]initWithCenterViewController:goldMineNavGation leftDrawerViewController:leftMenuNav];
    self.drawerController = tmpDrawerController;
    tmpDrawerController=nil;
    
//    MMDrawerController * drawerController = [[MMDrawerController alloc]
//                                             initWithCenterViewController:goldMineNavGation leftDrawerViewController:leftMenuNav];
    [ self.drawerController setMaximumRightDrawerWidth:277.0];
    [ self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [ self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [ self.drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[SmallGoldMineDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController= self.drawerController;
    [self.window makeKeyAndVisible];
    
    [self presentLoginVC];
    smallGoldMineVC=nil;

    return YES;
}

- (void)presentLoginVC
{
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.3;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [self.view.window.layer addAnimation:transition forKey:nil];
    
    //
    //
    LoginController *loginController = [[LoginController alloc] initWithNibName:@"LoginController" bundle:nil];
    loginController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginController];
    loginController.navigationController.navigationBarHidden = YES;
    
    
    
    
    [self.window.rootViewController presentViewController:navi animated:NO completion:nil];
//    self.window.rootViewController=[[LoginController alloc] initWithNibName:@"LoginController" bundle:nil];;
//    loginController=nil;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
