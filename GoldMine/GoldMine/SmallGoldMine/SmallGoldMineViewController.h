//
//  SmallGoldMineViewController.h
//  GoldMine
//
//  Created by micheal on 14-5-11.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSegmentedControl.h"
#import "VSquareViewController.h"
#import "TaskViewController.h"
#import "Golden/GoldenViewController.h"

@interface SmallGoldMineViewController :SuperViewController{
    VSquareViewController *vSquareViewController;
    TaskViewController *taskViewController;
    GoldenViewController *goldenViewController;
}

@property (nonatomic,strong) CustomSegmentedControl *segmentedControl;

@property (nonatomic,strong) UIScrollView *vSquareScrollView;

- (void)presentLoginVC;

@end
