//
//  SuperViewController.h
//  iShow
//
//  Created by laurence on 13-11-21.
//  Copyright (c) 2013年 56.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuperViewController : UIViewController
{
    BOOL      _bNeedShowRightBarButtonItem;
    BOOL      _bNeedShowLogoView;
    BOOL      _bNeedShowBackBarButtonItem;
    UIImageView *_logoView;
}

//@property (nonatomic, assign) BOOL needBack;

- (void)drawView;
- (void)clickedBack:(id)sender;

@end
