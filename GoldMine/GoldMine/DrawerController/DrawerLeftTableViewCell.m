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
        
        _goodsImageView=[[UIImageView alloc] initWithFrame:CGRectMake(20.0, 20.0, 40.0, 40.0)];
        [self.contentView addSubview:_goodsImageView];
        
        _title=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_goodsImageView.frame), 20.0, 100.0, 40.0)];
        _title.backgroundColor=[UIColor clearColor];
        _title.font=[UIFont systemFontOfSize:14.0];
        _title.textColor=[UIColor colorWithRed:221.0/255.0 green:221.0/255 blue:221.0/255 alpha:1];
        [self.contentView addSubview:_title];
        
        _accessoryImgaeView=[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-40.0, 20.0, 25.0, 40.0)];
        _accessoryImgaeView.image=[UIImage imageNamed:@""];
        [self.contentView addSubview:_accessoryImgaeView];
        
        
        _cellSeperateLine=[[UIView alloc] initWithFrame:CGRectMake(0.0,80.0, self.frame.size.width, 1)];
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
