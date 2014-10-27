//
//  BrandIntroduceViewController.m
//  GoldMine
//
//  Created by micheal on 14-10-5.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "BrandIntroduceViewController.h"f
#import "UIImageView+WebCache.h"

@interface BrandIntroduceViewController ()

@property (nonatomic, strong) SoapRequest *brandInfoReqeust;

@end

@implementation BrandIntroduceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"品牌介绍";
        
        _bNeedShowBackBarButtonItem = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.brandInfoReqeust=[[SoapRequest alloc] init];
    
    [self getBrandInfoRequestWithBId:@"001" andVersion:[Tools getAppVersion]];
    // Do any additional setup after loading the view from its nib.
}

//获取品牌信息
-(void)getBrandInfoRequestWithBId:(NSString *)bId andVersion:(NSString *)version{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:bId forKey:@"bid"];
    [paramDict setObject:version forKey:@"version"];
    
    [self.brandInfoReqeust postRequestWithSoapNamespace:@"BrandInfo" params:paramDict successBlock:^(id result) {
        DLog(@"BrandInfo result=%@", result);
        NSDictionary *brandInfo=(NSDictionary *)result;
        [self.bardImageView  setImageWithURL:[NSURL URLWithString:[brandInfo objectForKey:@"BardImg"]] placeholderImage:nil];
        
        
    } failureBlock:^(NSString *requestError) {
        NSLog(@"BrandInfo failure!!!");
    } errorBlock:^(NSMutableString *errorStr) {
        NSLog(@"BrandInfo error!!!");
    }];
    paramDict=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
