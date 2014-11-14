//
//  VIPAddressBookViewController.h
//  GoldMine
//
//  Created by micheal on 14/11/11.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIPAddressBookViewController : SuperViewController{
    NSString *sectionName;
}

@property (nonatomic,strong) NSMutableArray *contactLists;
@property (nonatomic,strong) NSMutableArray *sectionNames;

@property (nonatomic,weak) IBOutlet UISearchBar *vipSearchBar;
@property (nonatomic,weak) IBOutlet UITableView *vipTableView;

@end
