//
//  VIPAddressBookDetailViewController.h
//  GoldMine
//
//  Created by micheal on 14/11/11.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIPAddressBookDetailViewController : SuperViewController{
    NSMutableArray *vipInfoArray;
    
    NSMutableArray *vipInfoSectionOneArray;
    NSMutableArray *vipInfoSectionTwoArray;
    
    NSMutableArray *jubaoListArray;
}

@property (nonatomic,strong) NSString *customID;
@property (nonatomic,weak) IBOutlet UITableView *VIPAddressTableView;

@end
