//
//  FeedbackController.m
//  GoldMine
//
//  Created by Oliver on 14-10-18.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "FeedbackController.h"

@interface FeedbackController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong) SoapRequest *commitRequest;

@end

@implementation FeedbackController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _bNeedShowBackBarButtonItem = YES;
        self.title = @"意见反馈";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = GRAY_COLOR;
    self.textView.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.text = @"";

    return YES;
}

- (IBAction)closeKeyboard:(id)sender {
    [self.textView resignFirstResponder];
    [self.textField resignFirstResponder];
}

- (IBAction)commitSuggestion:(id)sender {
    if (self.textView.text.length == 0) {
        [self.view makeToast:@"请输入您的宝贵建议"];
        return;
    } else if (self.textField.text.length == 0) {
        [self.view makeToast:@"请输入您的手机号"];
        return;
    }
    
    //TODO: commit request
}


@end
