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

@interface MenuTopPhotoView : UIView
@property (nonatomic,strong) UIImageView* photo;
@property (nonatomic,strong) UILabel* nameLabel;
@property (nonatomic,retain) id<MenuTopPhotoViewDelegate> delegate;

- (void)setUserInfo:(NSString *)nickname photo:(NSString*)photo hasLogin:(BOOL)login;
@end
