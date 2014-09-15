//
//  SmallGoldMineViewController.h
//  GoldMine
//
//  Created by micheal on 14-5-11.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSegmentedControl.h"

@interface SmallGoldMineViewController :SuperViewController{
     NSMutableArray *brandArray;
}

@property (nonatomic,strong) CustomSegmentedControl *segmentedControl;

@property (nonatomic,strong) UITableView *vSquareTableView;

- (void)presentLoginVC;

@end
