//
//  DatePickerView.h
//  GoldMine
//
//  Created by Oliver on 14-10-27.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DatePickerView;
@protocol DatePickerViewDelegate <NSObject>

- (void)datePickerView:(DatePickerView *)datePickerView didSelectDate:(NSString *)dateString;

@end


@interface DatePickerView : UIView

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, weak) id<DatePickerViewDelegate> delegate;

+ (DatePickerView *)loadNibInstance;
- (void)showInView:(UIView *)aView;

@end
