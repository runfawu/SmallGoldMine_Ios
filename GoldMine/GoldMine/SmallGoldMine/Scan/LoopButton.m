//
//  LoopButton.m
//  GoldMine
//
//  Created by Dongfuming on 14-9-28.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "LoopButton.h"

@implementation LoopButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    [self addTarget:self action:@selector(changeImage) forControlEvents:UIControlEventTouchUpInside];
}
- (void)changeImage
{
    NSUInteger index = self.currentIndex;
    index ++;
    index %= self.images.count;
    self.currentIndex = index;
}

- (void)setImages:(NSArray *)images
{
    _images = images;
    self.currentIndex = 0;
}

- (void)setCurrentIndex:(NSUInteger)currentIndex
{
    _currentIndex = currentIndex;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setImage:self.images[self.currentIndex] forState:UIControlStateNormal];
}

@end
