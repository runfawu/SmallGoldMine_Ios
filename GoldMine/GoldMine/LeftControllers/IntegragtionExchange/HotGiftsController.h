//
//  HotGiftsController.h
//  GoldMine
//
//  Created by Oliver on 14-10-7.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HotGiftsController;
@protocol HotGiftsDelegate <NSObject>

- (void)hotGiftsController:(HotGiftsController *)giftsController didSelectGiftWithCode:(NSString *)giftCode;

@end

@interface HotGiftsController : UIViewController

@property (nonatomic) BOOL isHot;
@property (nonatomic, weak) id<HotGiftsDelegate> delegate;

@end
