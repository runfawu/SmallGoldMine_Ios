//
//  VIPAddressBookDetailViewController.h
//  GoldMine
//
//  Created by micheal on 14/11/5.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuddyViewDetailViewController:SuperViewController{
    NSDictionary *myFriendsInfoDic;
    NSMutableArray *myFriendsInfoArray;
}

@property (nonatomic,weak) IBOutlet UIImageView *headImageView;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *signatureLabel;
@property (nonatomic,weak) IBOutlet UITableView *detailInfoTableView;


@property (nonatomic,strong) NSString *friedId;

@end
