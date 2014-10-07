//
//  AdvertisementView.m
//  iShow
//
//  Created by micheal on 14-6-26.
//  Copyright (c) 2014年 56.com. All rights reserved.
//

#import "AdvertisementView.h"
#import "UIImageView+WebCache.h"

@implementation AdvertisementView

@synthesize scrollView;
@synthesize pageControl;
//@synthesize delegate=_delegate;
@synthesize pictureArray=_pictureArray;

-(id)initWithFrame:(CGRect)frame andPictureArray:(NSArray *)picArray{
    self=[super initWithFrame:frame];
    if (self) {
        // 定时器 循环
       picTimer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
        timerNum=1;
        // 初始化 scrollview
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320.0, 150.0)];
        scrollView.bounces = YES;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.userInteractionEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        
        [self addSubview:scrollView];
        
        _pictureArray= [NSMutableArray arrayWithArray:picArray];
        picNumber=[_pictureArray count];
        
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(200,120.0,100,18)]; // 初始化mypagecontrol
        [self.pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
        [self.pageControl setPageIndicatorTintColor:[UIColor grayColor]];

        self.pageControl.numberOfPages = [_pictureArray count];
        self.pageControl.currentPage = 0;
        [self.pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
        [self addSubview:pageControl];
        // 创建四个图片 imageview
        for (int i = 0;i<picNumber;i++)
        {
            NSDictionary *subDic=[_pictureArray objectAtIndex:i];
            UIImageView *imageView =[[UIImageView alloc] init];
            imageView.tag=i;
            NSLog(@"subdic url = %@",[subDic objectForKey:@"ContentImg"]);
            [imageView setImageWithURL:[NSURL URLWithString:[subDic objectForKey:@"ContentImg"]] placeholderImage:nil options:SDWebImageHighPriority];
      
            imageView.frame = CGRectMake((320 * i) + 320, 0, 320, 150.0);
            [scrollView addSubview:imageView]; // 首页是第0页,默认从第1页开始的。所以+320。。。
        }
    
//        // 取数组最后一张图片 放在第0页
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setImageWithURL:[NSURL URLWithString:[[_pictureArray objectAtIndex:[_pictureArray count]-1] objectForKey:@"ContentImg"]] placeholderImage:nil options:SDWebImageHighPriority];
        imageView.frame = CGRectMake(0, 0, 320, 150.0); // 添加最后1页在首页 循环
        [scrollView addSubview:imageView];
        
//        // 取数组第一张图片 放在最后1页
        imageView = [[UIImageView alloc] init];
       
        [imageView setImageWithURL:[NSURL URLWithString:[[_pictureArray objectAtIndex:0] objectForKey:@"ContentImg"]] placeholderImage:nil options:SDWebImageHighPriority];
        imageView.frame = CGRectMake((320 * (picNumber + 1)) , 0, 320, 150.0); // 添加第1页在最后 循环
        [scrollView addSubview:imageView];
        
        [scrollView setContentSize:CGSizeMake(320 * (picNumber+2), 150.0)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
        [scrollView setContentOffset:CGPointMake(0, 0)];
        [self.scrollView scrollRectToVisible:CGRectMake(320,0,320,150.0) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
    }
    return self;
}


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pagewidth/(picNumber+2))/pagewidth)+1;
    page --;  // 默认从第二页开始
    pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = self.scrollView.frame.size.width;
    int currentPage = floor((self.scrollView.contentOffset.x - pagewidth/ (picNumber+2)) / pagewidth) + 1;
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    //    NSLog(@"currentPage_==%d",currentPage_);
    if (currentPage==0)
    {
        [self.scrollView scrollRectToVisible:CGRectMake(320 * picNumber,0,320,150.0) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==(picNumber+1))
    {
        [self.scrollView scrollRectToVisible:CGRectMake(320,0,320,150.0) animated:NO]; // 最后+1,循环第1页
    }
    
    if (timerNum>0) {
       [picTimer invalidate];
    }
    timerNum=timerNum-1;
    
    double delayInSeconds = 0.3;
    dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delayInNanoSeconds, dispatch_get_current_queue(), ^(void){
        [self fireTimer];
    });
}

// pagecontrol 选择器的方法
- (void)turnPage
{
    int page = pageControl.currentPage; // 获取当前的page
    [self.scrollView scrollRectToVisible:CGRectMake(320*(page+1),0,320,150.0) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
}

-(void)fireTimer{
    timerNum=timerNum+1;
    if (timerNum==1) {
        picTimer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    }
}

// 定时器 绑定的方法
- (void)runTimePage
{
    int page = pageControl.currentPage; // 获取当前的page
    page++;
    page = page > (picNumber-1) ? 0 : page ;
    pageControl.currentPage = page;
    [self turnPage];
}



@end
