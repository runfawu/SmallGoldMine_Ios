//
//  ScanNaviView.m
//  GoldMine
//
//  Created by Oliver on 14-9-28.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "ScanNaviView.h"

@implementation ScanNaviView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (ScanNaviView *)loadNibInstance
{
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"ScanNaviView" owner:self options:nil];
    
    return nibArray[0];
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
