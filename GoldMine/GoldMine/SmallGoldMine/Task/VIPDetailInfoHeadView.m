//
//  VIPDetailInfoHeadView.m
//  GoldMine
//
//  Created by micheal on 14-9-25.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "VIPDetailInfoHeadView.h"
#import "Utils.h"

#define VIPLEFTMARGIN 13.0

@implementation VIPDetailInfoHeadView

@synthesize userHearIV=_userHearIV;
@synthesize userName=_userName;
@synthesize telNo=_telNo;
@synthesize shareButton=_shareButton;
@synthesize transitView=_transitView;

@synthesize birthdayLabel=_birthdayLabel;
@synthesize goodsAddressLabel=_goodsAddressLabel;
@synthesize orderServerLabel=_orderServerLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _userHearIV=[[UIImageView alloc] initWithFrame:CGRectMake(VIPLEFTMARGIN, 13.0, 52.0, 52.0)];
        _userHearIV.image=[UIImage imageNamed:@"vip_ headBg"];
        [self addSubview:_userHearIV];;
        
        _userName=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHearIV.frame)+10.0, 15.0, 200.0, 25.0)];
        _userName.font=[UIFont systemFontOfSize:19.0];
        _userName.textColor=[Utils colorWithHexString:@"1E1E1E"];
        [self addSubview:_userName];
        
        _telNo=[[UILabel alloc] initWithFrame:CGRectMake(_userName.frame.origin.x, CGRectGetMaxY(_userName.frame), 250.0, 20.0)];
        _telNo.textColor=[Utils colorWithHexString:@"A5A5A5"];
        _telNo.font=[UIFont systemFontOfSize:13.0];
        [self addSubview:_telNo];
        
        _shareButton=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-52.0, 15.0, 22.0, 22.0)];
        [_shareButton setBackgroundImage:[UIImage imageNamed:@"vip_share"] forState:UIControlStateNormal];
        [self addSubview:_shareButton];
        
        _transitView=[[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(_userHearIV.frame)+20.0, self.frame.size.width, 20.0)];
        _transitView.backgroundColor=[Utils colorWithHexString:@"D1D1D1"];
        [self addSubview:_transitView];
        
        UILabel *babyBirthday=[[UILabel alloc] initWithFrame:CGRectMake(VIPLEFTMARGIN, CGRectGetMaxY(_transitView.frame)+10.0, 80.0, 20.0)];
        babyBirthday.text=@"宝宝生日:";
        babyBirthday.font=[UIFont systemFontOfSize:15.0];
        [self addSubview:babyBirthday];
        
        _birthdayLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(babyBirthday.frame), babyBirthday.frame.origin.y, 100.0, 20.0)];
        _birthdayLabel.textColor=[Utils colorWithHexString:@"979797"];
        _birthdayLabel.font=[UIFont systemFontOfSize:13.0];
        [self addSubview:_birthdayLabel];
        babyBirthday=nil;
        
        UIView *babySepView=[[UIView alloc] initWithFrame:CGRectMake(10.0, CGRectGetMaxY(_birthdayLabel.frame)+10, self.frame.size.width-20.0, 1)];
        babySepView.backgroundColor=[Utils colorWithHexString:@"D1D1D1"];
        [self addSubview:babySepView];
        
        UILabel *goodsAddress=[[UILabel alloc] initWithFrame:CGRectMake(VIPLEFTMARGIN, CGRectGetMaxY(babySepView.frame)+10.0, 80.0, 20.0)];
        goodsAddress.text=@"送货地址:";
        goodsAddress.font=[UIFont systemFontOfSize:15.0];
        [self addSubview:goodsAddress];
        
        _goodsAddressLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsAddress.frame), goodsAddress.frame.origin.y, 250.0, 20.0)];
        _goodsAddressLabel.textColor=[Utils colorWithHexString:@"979797"];
        _goodsAddressLabel.font=[UIFont systemFontOfSize:13.0];
        [self addSubview:_goodsAddressLabel];
        
        UIView *goodsAddressSepView=[[UIView alloc] initWithFrame:CGRectMake(10.0, CGRectGetMaxY(_goodsAddressLabel.frame)+10, self.frame.size.width-20.0, 1)];
        goodsAddressSepView.backgroundColor=[Utils colorWithHexString:@"D1D1D1"];
        [self addSubview:goodsAddressSepView];
        
        UILabel *orderServer=[[UILabel alloc] initWithFrame:CGRectMake(VIPLEFTMARGIN, CGRectGetMaxY(goodsAddressSepView.frame)+10.0, 80.0, 20.0)];
        orderServer.text=@"定制服务:";
        orderServer.font=[UIFont systemFontOfSize:15.0];
        [self addSubview:orderServer];
        
        _orderServerLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(orderServer.frame), orderServer.frame.origin.y, 250.0, 20.0)];
        
        NSLog(@"_orderServerLabel.frame origin=:%f height=:%f",_orderServerLabel.frame.origin.y,_orderServerLabel.frame.size.height);
        _orderServerLabel.textColor=[Utils colorWithHexString:@"979797"];
        _orderServerLabel.font=[UIFont systemFontOfSize:13.0];
        [self addSubview:_orderServerLabel];

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
