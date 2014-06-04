//
//  VIPDetailedInformationViewController.h
//  GoldMine
//
//  Created by micheal on 14-9-25.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIPDetailedInformationViewController : SuperViewController{
    NSString *customeID;
    
    NSMutableArray *goldenListArray;
}

@property (nonatomic,strong) UITableView *goldenListTableView;

-(id)initWithCustomeID:(NSString *)cusId;

@end
