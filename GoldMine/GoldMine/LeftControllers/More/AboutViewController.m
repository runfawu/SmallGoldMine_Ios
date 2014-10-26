//
//  AboutViewController.m
//  GoldMine
//
//  Created by Oliver on 14-10-18.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _bNeedShowBackBarButtonItem = YES;
        self.title = @"关于";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = GRAY_COLOR;
    self.textView.editable = NO;
    self.textView.layer.cornerRadius = 6;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.textView.text = @"聚创网络科技有限公司（www.jc-cdm.com）经历了十五年的磨砺，由九十年代的国内第一批数码公司三元防伪科技公司到恒威数码网络科技有限公司,再到精诚网络，是一家有着行业历史和经验沉淀的信息网络科技公司，公司专注于国内品牌产品的营销、客服平台研究、开发、实施一体化的全程解决方案和系统平台。\r公司注重软件开发能力和系统实施集成能力。致力于网络应用技术、条码数字化应用、企业信息化系统、实施和软件开发、行业数字信息化应用、自动化控制信息集成技术、移动通信企业应用、精准搜索、数据挖掘、精准网络营销应用技术等领域的研发工作。";
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.textView.frame = CGRectMake(20, 20, self.view.frame.size.width - 20 * 2, self.view.frame.size.height - 20 * 2);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


@end
