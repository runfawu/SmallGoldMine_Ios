//
//  DrawerLeftTableViewCell.m
//  iShow
//
//  Created by micheal on 14-5-23.
//  Copyright (c) 2014年 56.com. All rights reserved.
//

#import "DrawerLeftTableViewCell.h"

@implementation DrawerLeftTableViewCell

@synthesize goodsImageView=_goodsImageView;
@synthesize tile=_title;
@synthesize accessoryImgaeView=_accessoryImgaeView;
@synthesize cellSeperateLine=_cellSeperateLine;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        
        _goodsImageView=[[UIImageView alloc] initWithFrame:CGRectMake(20.0, 13.5, 35.0, 35.0)];
        [self.contentView addSubview:_goodsImageView];
        
        _title=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_goodsImageView.frame)+10.0, 13.5, 100.0, 35.0)];
        _title.backgroundColor=[UIColor clearColor];
        _title.font=[UIFont systemFontOfSize:16.0];
        _title.textColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
        [self.contentView addSubview:_title];
        
        _accessoryImgaeView=[[UIImageView alloc] initWithFrame:CGRectMake(277.0-40.0, 25.5, 13.0, 15.0)];
        _accessoryImgaeView.image=[UIImage imageNamed:@"more"];
        [self.contentView addSubview:_accessoryImgaeView];
        
        _cellSeperateLine=[[UIImageView alloc] initWithFrame:CGRectMake(0.0,65.0,277.0, 1)];
//        _cellSeperateLine.image=[UIImage imageNamed:@"cell_seperate_line"];
        _cellSeperateLine.backgroundColor=[UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1];
        [self.contentView addSubview:_cellSeperateLine];
        
    }
    return self;
}

-(void)setTileValueWithString:(NSString *)titleStr andGoodsImageViewWithImageString:(NSString *)imageStr{
    _title.text=titleStr;
    _goodsImageView.image=[UIImage imageNamed:imageStr];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
//    if (selected) {
//        _title.textColor=[UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1];
//    }else{
//        _title.textColor=[UIColor colorWithRed:221.0/255.0 green:221.0/255 blue:221.0/255 alpha:1];
//    }
   

    // Configure the view for the selected state
}


@end
