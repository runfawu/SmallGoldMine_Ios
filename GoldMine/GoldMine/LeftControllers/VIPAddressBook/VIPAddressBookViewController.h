//
//  VIPAddressBookViewController.h
//  GoldMine
//
//  Created by micheal on 14/11/11.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^RenderPhoneBlock)(NSString *phone);

@interface VIPAddressBookViewController : SuperViewController{
    NSString *sectionName;
}

@property (nonatomic,strong) NSMutableArray *contactLists;
@property (nonatomic,strong) NSMutableArray *sectionNames;

@property (nonatomic,weak) IBOutlet UISearchBar *vipSearchBar;
@property (nonatomic,weak) IBOutlet UITableView *vipTableView;

@property (nonatomic, assign) BOOL comeFromInputPage;  /**< 手动输码积分，选择电话号码后跳转到VIP通讯录 */
@property (nonatomic, copy) RenderPhoneBlock renderPhoneBlock; 

@end
