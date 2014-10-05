//
//  VSquareViewController.h
//  GoldMine
//
//  Created by micheal on 14-9-25.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VSquareViewControllerDelegate <NSObject>

//品牌介绍
-(void)brandIntroduceWithIndexpath:(NSIndexPath *)currentIndexPath;

//添加品牌
-(void)addBrand;

@end


@interface VSquareViewController : UIViewController{
    NSMutableArray *brandArray;
    NSMutableArray *bannarArray;
    
    __weak id<VSquareViewControllerDelegate> _delegate;
}

@property (nonatomic,strong) UIButton *addBrandButton;
@property (nonatomic,strong) UITableView *vSquareTableView;

@property (nonatomic,weak) id <VSquareViewControllerDelegate> delegate;

@end
