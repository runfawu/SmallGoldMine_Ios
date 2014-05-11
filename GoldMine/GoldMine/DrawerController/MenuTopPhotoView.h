//
//  MenuTopPhotoView.h
//  iShow
//
//  Created by kaicong.lin on 14-7-18.
//  Copyright (c) 2014年 56.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuTopPhotoViewDelegate <NSObject>

-(void)tapPhotoView;

@end



@interface MenuTopPhotoView : UIView{
    __weak id <MenuTopPhotoViewDelegate> _delegate;
    
}

@property (nonatomic,strong) UIImageView* photo;
@property (nonatomic,strong) UILabel *numberLabel;
@property (nonatomic,strong) UILabel *creditLabel;
@property (nonatomic,strong) UIImageView *wealthImageView;
@property (nonatomic,strong) UIImageView *guysImageView;
@property (nonatomic,strong) UIImageView *rankImageView;

@property (nonatomic,weak) id<MenuTopPhotoViewDelegate> delegate;

- (void)setUserInfo:(NSString *)nickname photo:(NSString*)photo hasLogin:(BOOL)login;
@end
