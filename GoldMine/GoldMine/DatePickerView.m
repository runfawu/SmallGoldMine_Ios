//
//  DatePickerView.m
//  GoldMine
//
//  Created by Oliver on 14-10-27.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "DatePickerView.h"

@implementation DatePickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (DatePickerView *)loadNibInstance
{
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"DatePickerView" owner:self options:nil];
    DatePickerView *instance = nibArray[0];
    
    return instance;
}

- (IBAction)cancel:(id)sender {
    [self hide];
}

- (IBAction)confirm:(id)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *date = [formatter stringFromDate:self.datePicker.date];
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerView:didSelectDate:)]) {
        [self.delegate datePickerView:self didSelectDate:date];
    }
    [self hide];
}

- (void)showInView:(UIView *)aView
{
    [aView addSubview:self];
    
    self.frame = CGRectMake(0, aView.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, aView.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
