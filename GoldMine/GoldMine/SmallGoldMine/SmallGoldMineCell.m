//
//  SmallGoldMineCell.m
//  GoldMine
//
//  Created by micheal on 14-5-11.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "SmallGoldMineCell.h"
#import "UIImageView+WebCache.h"

@implementation SmallGoldMineCell

@synthesize goodsImageView=_goodsImageView;
@synthesize titleLabel=_titleLabel;
@synthesize goodsDescribeLabel=_goodsDescribeLabel;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.goodsImageView=[[UIImageView alloc] initWithFrame:CGRectMake(9.0, 10.0, 84.0, 62.0)];
        self.goodsImageView.image=[UIImage imageNamed:@"vsquare_good"];
        [self addSubview:self.goodsImageView];
        
        _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.goodsImageView.frame)+8.0, 14.0, self.frame.size.width-121.0, 24.0)];
        _titleLabel.numberOfLines=1;
        _titleLabel.font=[UIFont systemFontOfSize:16.0];
        _titleLabel.textColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        [self addSubview:_titleLabel];
        
        _goodsDescribeLabel=[[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, CGRectGetMaxY(_titleLabel.frame), _titleLabel.frame.size.width, 40.0)];
        _goodsDescribeLabel.numberOfLines=2;
        _goodsDescribeLabel.font=[UIFont systemFontOfSize:16.0];
        _goodsDescribeLabel.textColor=[UIColor colorWithRed:115.0/255 green:115.0/255 blue:115.0/255 alpha:1.0];
        [self addSubview:_goodsDescribeLabel];
        
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0,81,self.frame.size.width, 1);
        bottomBorder.backgroundColor = [UIColor colorWithRed:208.0/255 green:208.0/255 blue:208.0/255 alpha:1].CGColor;
        
        [self.layer addSublayer:bottomBorder];
    }
    return self;
}

-(void)setSmallGoldMineCellWithDictionary:(NSDictionary *)brandDic{
//    NSString *imgStr=[NSString stringWithString:[brandDic objectForKey:@"BardImg"]];
    //    NSURL *imgUrl=[[NSURL alloc] initWithString:@"http://202.91.242.228:7003/Picture/img2/008.jpg"];
//    NSURL *imgUrl=[[NSURL alloc] initWithString:imgStr];
    
//    [self.goodsImageView setImageWithURL:imgUrl];
//    imgUrl=nil;
    
    _titleLabel.text=[brandDic objectForKey:@"BardName"];
    _goodsDescribeLabel.text=[brandDic objectForKey:@"BardAbout"];
}


@end
