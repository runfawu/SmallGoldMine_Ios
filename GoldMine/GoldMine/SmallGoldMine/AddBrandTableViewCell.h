//
//  AddBrandTableViewCell.h
//  GoldMine
//
//  Created by micheal on 14-10-6.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBrandTableViewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIView *leftView;
@property (nonatomic,weak) IBOutlet UIImageView *leftBrandImageView;
@property (nonatomic,weak) IBOutlet UILabel *leftGoodsNameLabel;
@property (nonatomic,weak) IBOutlet UILabel *leftBrandTypeLabel;
@property (nonatomic,weak) IBOutlet UIImageView *leftSelecteImageView;

@property (nonatomic,weak) IBOutlet UIView *rightView;
@property (nonatomic,weak) IBOutlet UIImageView *rightBrandImageView;
@property (nonatomic,weak) IBOutlet UILabel *rightGoodsNameLabel;
@property (nonatomic,weak) IBOutlet UILabel *rightBrandTypeLabel;
@property (nonatomic,weak) IBOutlet UIImageView *rightSelecteImageView;

@end
