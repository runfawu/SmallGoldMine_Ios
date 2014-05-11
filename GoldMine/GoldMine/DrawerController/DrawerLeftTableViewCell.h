//
//  DrawerLeftTableViewCell.h
//  iShow
//
//  Created by micheal on 14-5-23.
//  Copyright (c) 2014年 56.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawerLeftTableViewCell : UITableViewCell
{
    UIImageView *_goodsImageView;
    UILabel *_title;
    UIImageView *_accessoryImgaeView;
    UIImageView *_cellSeperateLine;
}

@property (nonatomic,strong) UIImageView *goodsImageView;
@property (nonatomic,strong) UILabel *tile;
@property (nonatomic,strong) UIImageView *accessoryImgaeView;
@property (nonatomic,strong) UIImageView *cellSeperateLine;

-(void)setTileValueWithString:(NSString *)titleStr andGoodsImageViewWithImageString:(NSString *)imageStr;

@end
