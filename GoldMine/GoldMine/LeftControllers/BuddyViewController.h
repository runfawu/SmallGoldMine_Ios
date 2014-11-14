//
//  BuddyViewController.h
//  GoldMine
//
//  Created by micheal on 14/11/11.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuddyViewController : SuperViewController{
    NSString *sectionName;
    
    NSInteger currentPage;
    
    BOOL isSelectedFriend;
    
    UILabel *noDataNoticeLabel;
}

@property (nonatomic,strong) NSMutableArray *sectionNames;
@property (nonatomic,strong) NSMutableArray *friendsLists;

@property (nonatomic,weak) IBOutlet UIView *segementBackgroundView;
@property (nonatomic,weak) IBOutlet UIButton *answerButton;
@property (nonatomic,weak) IBOutlet UIButton *buddyButton;

@property (nonatomic,weak) IBOutlet UITableView *buddyTableView;

@end
