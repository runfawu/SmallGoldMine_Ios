//
//  MyNavigationViewController.h
//  MyNavigation
//
//  Created by 任海丽 on 13-8-16.
//  Copyright (c) 2013年 iHope. All rights reserved.
//
#import <UIKit/UIKit.h>

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]
#define kkBackViewHeight [UIScreen mainScreen].bounds.size.height
#define kkBackViewWidth [UIScreen mainScreen].bounds.size.width

#define iOS7  ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

// 背景视图起始frame.x
#define startX -200;

@interface MyNavigationViewController : UINavigationController<UIGestureRecognizerDelegate>
{
    CGFloat startBackViewX;
}

// 默认为特效开启
@property (nonatomic, assign) BOOL canDragBack;

@end
