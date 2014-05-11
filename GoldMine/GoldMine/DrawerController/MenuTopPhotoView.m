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
@synthesize nameLabel = _nameLabel;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    
        _photo = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-40.0f, 20.0f, 80.0f, 80.0f)];
        [_photo setImage:[UIImage imageNamed:@"default_portrait"]];
        
        
        _photo.layer.masksToBounds=YES;
        _photo.layer.cornerRadius=40.0;
        _photo.layer.borderWidth=3.0;
        _photo.layer.borderColor = [[UIColor colorWithRed:87.0/255 green:87.0/255 blue:87.0/255 alpha:1] CGColor];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20.0f+80.0f+10.0f, frame.size.width, 16.0f)];
        _nameLabel.text = @"登录／注册";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [_nameLabel setTextColor:[UIColor whiteColor]];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14.0f]];
        NSLog(@"Frame Width:%@",NSStringFromCGRect(_photo.frame));
        
        [self addSubview:_photo];
        [self addSubview:_nameLabel];
        
    }
    return self;
}


- (void)setUserInfo:(NSString *)nickname photo:(NSString*)photo hasLogin:(BOOL)login
{
    if (login) {
//        [_photo setImageWithURL:[NSURL URLWithString:photo] placeholderImage:nil];
        [_nameLabel setText:nickname];
    }
    else
    {
        [_photo setImage:[UIImage imageNamed:@"default_portrait"]];
        _nameLabel.text = @"登录／注册";
    }
    
}


-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(tapPhotoView)]) {
        [self.delegate performSelector:@selector(tapPhotoView) withObject:nil];
    }
}


-(void)dealloc
{

}

@end
