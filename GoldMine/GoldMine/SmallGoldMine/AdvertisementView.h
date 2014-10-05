//
//  AdvertisementView.h
//  iShow
//
//  Created by micheal on 14-6-26.
//  Copyright (c) 2014年 56.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@class AdvertisementView;

//@protocol LookAdvertisementDelegate <NSObject>
//
//-(void)lookAdvertisementWithTag:(NSInteger)advTag;
//
//@end

@interface AdvertisementView : UIView<UIScrollViewDelegate>
{
//    id<LookAdvertisementDelegate>_delegate;
    NSInteger picNumber;
    NSTimer *picTimer;
    NSInteger timerNum;
}

@property (strong,nonatomic)UIScrollView *scrollView;
@property (strong,nonatomic)UIPageControl *pageControl;
@property (strong,nonatomic) NSMutableArray *pictureArray;
//@property (nonatomic,assign) id<LookAdvertisementDelegate>delegate;

-(id)initWithFrame:(CGRect)frame andPictureArray:(NSArray *)picArray;

@end
