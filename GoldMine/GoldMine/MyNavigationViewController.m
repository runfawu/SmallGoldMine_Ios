//
//  MyNavigationViewController.m
//  MyNavigation
//
//  Created by 任海丽 on 13-8-16.
//  Copyright (c) 2013年 iHope. All rights reserved.
//
/*
 思路：
 首先要理解UIWindow，UIWindow对象是所有UIView的根，管理和协调的应用程序的显示
 UIWindow类是UIView的子类，可以看作是特殊的UIView。
 一般应用程序只有一个UIWindow对象，即使有多个UIWindow对象，也只有一个UIWindow可以接受到用户的触屏事件。
 
 第一步：要在UIView上添加一个pan拖动的手势，并添加处发方法handlePanGesture；
 第二步：handlePanGesture方法中首先判断是不是顶级视图，是return，如果不是需要返回上一层；
       那么如何实现拖动的过程中使上层的界面显示并缩大放还有黑色渐变颜色呢，请看第三步。
 第三步：要在UIWindow上放一个屏幕大小的UIView *backgroundView，
 并且这个UIView要插入到UIWindow视图里当前UIVIew的下面，
 这个方法是[WINDOW insertSubview:self.backgroundView belowSubview:self.view];
 然后在backgroundView上要两个view：一个是上一层的界面，一个是改变透明值的UIView；
 改变透明值的UIView,也就是普通的UIView,背景颜色为黑色，拖动的过程中不断的改变透明值颜色。
 上一层的界面，说白了也就是一个图片，就是当你push进去一个界面之前，先把当前的UIVIew转化成UIImage（另一种说法是截屏），放到一个NSMutableArray数组中，每次拖动时就从数组中取出最后一个图片并添加到backgroundView上，根据拖动大小缩放该图片大小。最后把他插入到backgroundView中并且在改变透明值UIView的下面。
 [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
ok！可能这样写，你会一头污水，那还是直接看代码吧。
 
 注意：截屏的方法，- (UIImage *)ViewRenderImage

 */
#import "MyNavigationViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>
//#import "Tools.h"
#import "SmallGoldMineViewController.h"

@interface MyNavigationViewController()
{
    CGPoint startTouch;
    
    UIImageView *lastScreenShotView;
    UIView *blackMask;
    
}

@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,strong) NSMutableArray *screenShotsList;

@property (nonatomic,assign) BOOL isMoving;

@end

@implementation MyNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
        self.canDragBack = YES;
        
    }
    return self;
}

- (void)dealloc
{
//    self.screenShotsList = nil;
//    [self.backgroundView removeFromSuperview];
//    self.backgroundView = nil;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    
//    UIImageView *shadowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftside_shadow_bg"]];
//    shadowImageView.frame = CGRectMake(-10, 0, 10, self.view.frame.size.height);
//    [self.view addSubview:shadowImageView];
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(paningGestureReceive:)];
    recognizer.delegate = self;
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.screenShotsList.count && self.viewControllers.count==self.screenShotsList.count) {
        [self.screenShotsList replaceObjectAtIndex:self.screenShotsList.count-1 withObject:[self capture]];
    }
    else
    {
        [self.screenShotsList addObject:[self capture]];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self.screenShotsList removeLastObject];
    UIViewController * viewController = [super popViewControllerAnimated:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:viewController];
    return viewController;
}

#pragma mark - Utility Methods -

- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    if (self.tabBarController!=nil) {
        [self.tabBarController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    else
    {
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)moveViewWithX:(float)x
{
    x = x>320?320:x;
    x = x<0?0:x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
//    UIView * keyBoard = [Tools getGlobalKeyBoardView];
    UIView * keyBoard=nil;
    frame = keyBoard.frame;
    frame.origin.x = x;
    keyBoard.frame = frame;
    
    float alpha = 0.4 - (x/800);
    
    blackMask.alpha = alpha;
    
    CGFloat aa = abs(startBackViewX)/kkBackViewWidth;
    CGFloat y = x*aa;
    
    CGFloat lastScreenShotViewHeight = kkBackViewHeight;
    
    //TODO: FIX self.edgesForExtendedLayout = UIRectEdgeNone  SHOW BUG
    /**
     *  if u use self.edgesForExtendedLayout = UIRectEdgeNone; pls add
     
     if (!iOS7) {
     lastScreenShotViewHeight = lastScreenShotViewHeight - 20;
     }
     *
     */
    [lastScreenShotView setFrame:CGRectMake(startBackViewX+y,
                                            0,
                                            kkBackViewWidth,
                                            lastScreenShotViewHeight)];
    
}



-(BOOL)isBlurryImg:(CGFloat)tmp
{
    return YES;
}

#pragma mark - Gesture Recognizer -
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
    
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        _isMoving = YES;
        startTouch = touchPoint;
        
        if (!self.backgroundView)
        {
            CGRect frame = self.view.frame;
            
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            
            
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            blackMask.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:blackMask];
        }
        if (self.backgroundView.superview == nil) {
            [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
        }
        self.backgroundView.hidden = NO;
        
        if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
        
        
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        
        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        
        startBackViewX = startX;
        [lastScreenShotView setFrame:CGRectMake(startBackViewX,
                                                lastScreenShotView.frame.origin.y,
                                                lastScreenShotView.frame.size.height,
                                                lastScreenShotView.frame.size.width)];
        
        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
        SmallGoldMineViewController *smallGoldMineVC = nil;
        int count = self.viewControllers.count;
        if (count>=2) {
            smallGoldMineVC = [self.viewControllers objectAtIndex:count-2];
        }
        if (smallGoldMineVC!=nil&&[smallGoldMineVC isKindOfClass:[SmallGoldMineViewController class]]) {
            [lastScreenShotView addSubview:smallGoldMineVC.view];
        }
        
        
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x - startTouch.x > 50)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:320];
            } completion:^(BOOL finished) {
                
                SmallGoldMineViewController * smallGoldMineVC = [self.viewControllers lastObject];
                if ([smallGoldMineVC isKindOfClass:[SmallGoldMineViewController class]]) {
                    
                }
                else
                {
                    [self popViewControllerAnimated:NO];
                }
                
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
//                UIView * keyBoard = [Tools getGlobalKeyBoardView];
                UIView * keyBoard=nil;
                frame = keyBoard.frame;
                frame.origin.x = 0;
                keyBoard.frame = frame;
                
                _isMoving = NO;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
            
        }
        return;
        
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backgroundView.hidden = YES;
        }];
        
        return;
    }
    
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - startTouch.x];
    }
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count <= 1) return NO;
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translationPoint = [(UIPanGestureRecognizer*)gestureRecognizer translationInView:gestureRecognizer.view];
        //iShowDebug(@"MyNavigation panGestureRecognizerBegin %@",[NSValue valueWithCGPoint:translationPoint]);
        if (fabs(translationPoint.x)<fabs(translationPoint.y)) {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return YES;
}
@end
