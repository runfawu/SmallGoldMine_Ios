//
//  UIView+Addition.m
//  GoldMine
//
//  Created by Oliver on 14-9-28.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "UIView+Addition.h"

@implementation UIView (Addition)

- (void)customPushAnimation
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.window.layer addAnimation:transition forKey:nil];
}

- (void)customPopAnimation
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.window.layer addAnimation:transition forKey:nil];
}

@end
