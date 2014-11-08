//
//  PopListView.h
//  SeniorManager
//
//  Created by dfm on 14-5-5.
//
//

#import <UIKit/UIKit.h>

@class PopListView;
@protocol PopListViewDelegate <NSObject>

@optional
- (void)popListView:(PopListView *)popListView didSelectedIndex:(NSInteger)index;

@end

@interface PopListView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSMutableArray *listArray;
@property (nonatomic, assign) id<PopListViewDelegate> delegate;


- (id)initWithTitle:(NSString *)title listArray:(NSMutableArray *)listArray;
- (void)showInView:(UIView *)view animated:(BOOL)animated;

@end
