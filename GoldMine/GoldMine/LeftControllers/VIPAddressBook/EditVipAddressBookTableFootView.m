//
//  EditVipAddressBookTableFootView.m
//  GoldMine
//
//  Created by micheal on 14/11/12.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "EditVipAddressBookTableFootView.h"

@implementation EditVipAddressBookTableFootView

@synthesize deleteVipButton;
@synthesize modifyButton;


-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor grayColor];
        
        self.deleteVipButton=[[UIButton alloc] init];
        [self.deleteVipButton setTitle:@"删除VIP" forState:UIControlStateNormal];
        [self.deleteVipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.deleteVipButton.layer.cornerRadius=5.0;
        self.deleteVipButton.titleLabel.font=[UIFont boldSystemFontOfSize:15.0];
        self.deleteVipButton.backgroundColor=[Utils colorWithHexString:@"EE1c24"];
        self.deleteVipButton.translatesAutoresizingMaskIntoConstraints=NO;
        [self addSubview:self.deleteVipButton];
        
        self.modifyButton=[[UIButton alloc] init];
        [self.modifyButton setTitle:@"确认修改" forState:UIControlStateNormal];
        [self.modifyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.modifyButton.layer.cornerRadius=5.0;
        self.modifyButton.layer.borderWidth=1.0;
        self.modifyButton.titleLabel.font=[UIFont boldSystemFontOfSize:15.0];
        self.modifyButton.layer.borderColor=[Utils colorWithHexString:@"EE1c24"].CGColor;
        self.modifyButton.translatesAutoresizingMaskIntoConstraints=NO;
        [self addSubview:self.modifyButton];
        
        NSMutableArray *contraints=[NSMutableArray array];
        [contraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-9-[deleteVipButton]-9-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(deleteVipButton)]];
        [contraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-9-[modifyButton]-9-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(modifyButton)]];
        [contraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[deleteVipButton(==40)]-10-[modifyButton(40)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(deleteVipButton,modifyButton)]];
        [self addConstraints:contraints];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
