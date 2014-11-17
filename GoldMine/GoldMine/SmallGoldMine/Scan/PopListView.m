//
//  PopListView.m
//  SeniorManager
//
//  Created by dfm on 14-5-5.
//
//

#define X_MARGIN            50
#define HEADER_HEIGHT       50
#define RADIUS              5

#import "PopListView.h"

@implementation PopListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)title listArray:(NSMutableArray *)listArray
{
    CGRect rectOfApplication = [[UIScreen mainScreen] applicationFrame];
    rectOfApplication.origin.y -= NAVI_HEIGHT;
    CGRect rect = rectOfApplication;
    
    self = [super initWithFrame:rect];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.title = title;
        self.listArray = listArray;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(X_MARGIN, X_MARGIN+HEADER_HEIGHT, rect.size.width-2*X_MARGIN, rect.size.height-2*X_MARGIN-HEADER_HEIGHT-RADIUS)];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        [self addSubview:tableView];
    }
    return self;
}

#pragma mark - Private Methods
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)fadeOut
{
    [UIView animateWithDuration:.25 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)showInView:(UIView *)view animated:(BOOL)animated
{
    [view addSubview:self];
    if (animated) {
        [self fadeIn];
    }
}


#pragma mark - Tableview datasource & delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"PopListViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell ==  nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [self.listArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self fadeOut];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(popListView:didSelectedIndex:)]) {
        [self.delegate popListView:self didSelectedIndex:indexPath.row];
    }
}

#pragma mark -
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self fadeOut];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect bgRect = CGRectInset(rect, X_MARGIN, X_MARGIN);
    CGRect titleRect = CGRectMake(X_MARGIN + 10,
                                  X_MARGIN + 10 + 5,
                                  rect.size.width -  2 * (X_MARGIN + 10),
                                  30);
    CGRect separatorRect = CGRectMake(X_MARGIN,
                                      X_MARGIN + HEADER_HEIGHT - 2,
                                      rect.size.width - 2 * X_MARGIN,
                                      2);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Draw the background with shadow
    //所有绘图的像素点 都会按指定的偏移位置 置顶的宽度 指定颜色 形成投影效果
    CGContextSetShadowWithColor(ctx, CGSizeZero, 6., [UIColor colorWithWhite:0 alpha:0.75].CGColor);
    [[UIColor colorWithWhite:0 alpha:0.75] setFill];
    
    float x = X_MARGIN;
    float y = X_MARGIN;
    float width = bgRect.size.width;
    float height = bgRect.size.height;
    CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, x, y + RADIUS);
	CGPathAddArcToPoint(path, NULL, x, y, x + RADIUS, y, RADIUS);
	CGPathAddArcToPoint(path, NULL, x + width, y, x + width, y + RADIUS, RADIUS);
	CGPathAddArcToPoint(path, NULL, x + width, y + height, x + width - RADIUS, y + height, RADIUS);
	CGPathAddArcToPoint(path, NULL, x, y + height, x, y + height - RADIUS, RADIUS);
	CGPathCloseSubpath(path);
	CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    CGPathRelease(path);
    
    // 标题和分隔线
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 0.5f, [UIColor blackColor].CGColor);
    [[UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.] setFill];
    [_title drawInRect:titleRect withFont:[UIFont systemFontOfSize:18.] lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
    CGContextFillRect(ctx, separatorRect);
}


@end
