//
//  AddBrandViewController.h
//  GoldMine
//
//  Created by micheal on 14-10-5.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBrandViewController : SuperViewController
{
    NSMutableArray *brandArray;
}

@property (nonatomic,strong) UITableView *addBrandTableView;

@end
