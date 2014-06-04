//
//  GoldenCell.h
//  GoldMine
//
//  Created by Oliver on 14-9-24.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoldenCell : UITableViewCell

@property (nonatomic,weak) IBOutlet  UILabel *ProName;
@property (nonatomic,weak) IBOutlet UILabel *targetCount;
@property (nonatomic,weak) IBOutlet UILabel *completeCount;


-(void)setGoldenCellContentWithDictionary:(NSDictionary *)goodsDic;




@end
