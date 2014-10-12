//
//  GiftView.m
//  GoldMine
//
//  Created by Oliver on 14-10-12.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "GiftView.h"
#import "UIImageView+WebCache.h"

@implementation GiftView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (GiftView *)loadNibInstance
{
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"GiftView" owner:self options:nil];
    GiftView *giftView = nibArray[0];
    giftView.layer.cornerRadius = 6;
    
    return giftView;
}

- (void)setGiftEntity:(GiftEntity *)giftEntity
{
    _giftEntity = giftEntity;
    
    [self.imageView setImageWithURL:[NSURL URLWithString:_giftEntity.Image] placeholderImage:[UIImage imageNamed:@"gift_defaultImage"]];
    self.themeLabel.text = _giftEntity.Theme;
    self.integrationLabel.text = _giftEntity.NeedIdot;
    self.introduceLabel.text = _giftEntity.Introduce;
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
