//
//  MenuTopPhotoView.m
//  iShow
//
//  Created by kaicong.lin on 14-7-18.
//  Copyright (c) 2014年 56.com. All rights reserved.
//

#import "MenuTopPhotoView.h"

@implementation MenuTopPhotoView

@synthesize photo = _photo;
@synthesize numberLabel=_numberLabel;
@synthesize creditLabel=_creditLabel;

@synthesize wealthImageView=_wealthImageView;
@synthesize guysImageView=_guysImageView;
@synthesize rankImageView=_rankImageView;
@synthesize wealthBgIV;

@synthesize delegate=_delegate;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _photo = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-32.5f, 20.0f, 65.0f, 65.0f)];
        [_photo setImage:[UIImage imageNamed:@"logo_icon"]];
        _photo.layer.masksToBounds=YES;
        _photo.layer.cornerRadius=32.5;
        _photo.layer.borderWidth=1.0;
        _photo.layer.borderColor = [[UIColor colorWithRed:87.0/255 green:87.0/255 blue:87.0/255 alpha:1] CGColor];
        [self addSubview:_photo];
        
        self.numberLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(_photo.frame)+10, self.frame.size.width, 20.0)];
        self.numberLabel.textAlignment=NSTextAlignmentCenter;
        self.numberLabel.textColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.numberLabel.font=[UIFont systemFontOfSize:13.0];
        self.numberLabel.text=@"编号: 34150412211";
        [self addSubview:self.numberLabel];
        
        wealthBgIV=[[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-158.0)/2.0, CGRectGetMaxY(self.numberLabel.frame)+5, 158.0, 21.0)];
        wealthBgIV.image=[UIImage imageNamed:@"wealth_bg"];
        [self addSubview:wealthBgIV];
        
        UIImageView *creditIV=[[UIImageView alloc] initWithFrame:CGRectMake(40.0, 3.0, 17.0, 15.0)];
        creditIV.image=[UIImage imageNamed:@"credit"];
        [wealthBgIV addSubview:creditIV];
        
        self.creditLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(creditIV.frame)+10.0, 3.0, 100.0, 15.0)];
        self.creditLabel.font=[UIFont systemFontOfSize:13.0];
        self.creditLabel.text=@"hello world";
        [wealthBgIV addSubview:self.creditLabel];
        
        _wealthImageView=[[UIImageView alloc] initWithFrame:CGRectMake(25.0, CGRectGetMaxY(wealthBgIV.frame)+10.0, 35.0, 35.0)];
        _wealthImageView.userInteractionEnabled=YES;
        _wealthImageView.image=[UIImage imageNamed:@"wealth"];
        [self addSubview:_wealthImageView];
        
        UILabel *wealthLabel=[[UILabel alloc] initWithFrame:CGRectMake(_wealthImageView.frame.origin.x, CGRectGetMaxY(_wealthImageView.frame), 35.0, 20.0)];
        wealthLabel.textColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        wealthLabel.font=[UIFont systemFontOfSize:13.0];
        wealthLabel.text=@"财富";
        wealthLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:wealthLabel];
        wealthLabel=nil;
        
        _guysImageView=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_wealthImageView.frame)+61.0, _wealthImageView.frame.origin.y, 35.0, 35.0)];
        _guysImageView.userInteractionEnabled=YES;
        _guysImageView.image=[UIImage imageNamed:@"guys"];
        [self addSubview:_guysImageView];
        
        UILabel *guysLabel=[[UILabel alloc] initWithFrame:CGRectMake(_guysImageView.frame.origin.x-15.0, CGRectGetMaxY(_guysImageView.frame), 65.0, 20.0)];
        guysLabel.textColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        guysLabel.font=[UIFont systemFontOfSize:13.0];
        guysLabel.text=@"小伙伴";
        guysLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:guysLabel];
        guysLabel=nil;
        
        _rankImageView=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_guysImageView.frame)+61.0, _wealthImageView.frame.origin.y, 35.0, 35.0)];
        _rankImageView.userInteractionEnabled=YES;
        _rankImageView.image=[UIImage imageNamed:@"rank"];
        [self addSubview:_rankImageView];
        
        UILabel *rankLabel=[[UILabel alloc] initWithFrame:CGRectMake(_rankImageView.frame.origin.x, CGRectGetMaxY(_rankImageView.frame),35.0, 20.0)];
        rankLabel.textColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        rankLabel.font=[UIFont systemFontOfSize:13.0];
        rankLabel.text=@"排名";
        rankLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:rankLabel];
        rankLabel=nil;
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)setUserInfo:(NSString *)nickname photo:(NSString*)photo hasLogin:(BOOL)login
{

    
}


-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.photo.frame, point) ||
        CGRectContainsPoint(self.numberLabel.frame, point) ||
        CGRectContainsPoint(self.wealthBgIV.frame, point)) {  //点击头像、编号、昵称
        if ([self.delegate respondsToSelector:@selector(tapPhotoView)]) {
            [self.delegate performSelector:@selector(tapPhotoView) withObject:nil];
        }
    } else if (CGRectContainsPoint(self.wealthImageView.frame, point)) {  //点击财富
        if ([self.delegate respondsToSelector:@selector(tapWealthImageView:)]) {
            [self.delegate tapWealthImageView:self];
        }
    } else if (CGRectContainsPoint(self.rankImageView.frame, point)) {  //点击排名
        if ([self.delegate respondsToSelector:@selector(tapRankImageView:)]) {
            [self.delegate tapRankImageView:self];
        }
    } else if (CGRectContainsPoint(self.guysImageView.frame, point)) {  //点击小伙伴
        if ([self.delegate respondsToSelector:@selector(tapGuysImageView:)]) {
            [self.delegate tapGuysImageView:self];
        }
    }
}


-(void)dealloc
{

}

@end
