//
//  EditVIPAddressBookDetailViewController.h
//  GoldMine
//
//  Created by micheal on 14/11/12.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditVIPAddressBookDetailViewController : SuperViewController

@property (nonatomic,weak) NSMutableArray *infoSectionOneArray;
@property (nonatomic,weak) NSMutableArray *infosectionTwoArray;

@property (nonatomic,weak) IBOutlet UITableView *editInfoTableView;

@end
