//
//  AddBrandViewController.m
//  GoldMine
//
//  Created by micheal on 14-10-5.
//  Copyright (c) 2014年 us. All rights reserved.
//

#import "AddBrandViewController.h"
#import "AddBrandTableViewCell.h"
#import "BrandAssets.h"

#define  ImageViewNumber 2

@interface AddBrandViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) SoapRequest *addBrandRequest;

@end

@implementation AddBrandViewController

@synthesize addBrandTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(id)init{
    self=[super init];
    if (self) {
        self.title = @"添加品牌";
        
        _bNeedShowBackBarButtonItem = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    brandArray=[[NSMutableArray alloc] init];
    self.addBrandRequest=[[SoapRequest alloc] init];
    
    UIView *selectAllBg=[[UIView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height-113.0, self.view.frame.size.width, 49.0)];
    selectAllBg.backgroundColor=[Utils colorWithHexString:@"E6E6E6"];
    [self.view addSubview:selectAllBg];
    
    UIButton *selectAllButton=[[UIButton alloc] initWithFrame:CGRectMake(35.0, 15.5, 18.0, 18.0)];
    [selectAllButton setBackgroundImage:[UIImage imageNamed:@"select_allBrand"] forState:UIControlStateNormal];
    [selectAllButton addTarget:self action:@selector(selectedAllBrand:) forControlEvents:UIControlEventTouchUpInside];
    [selectAllBg addSubview:selectAllButton];
    
    UILabel *selectAllNotice=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(selectAllButton.frame)+14.0, 10.0, 50.0, 29.0)];
    selectAllNotice.font=[UIFont systemFontOfSize:15.0];
    selectAllNotice.text=@"全选";
    [selectAllBg addSubview:selectAllNotice];
    
    UIButton *confimeButton=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-115.0, 9.5, 80.0, 30.0)];
    [confimeButton setTitle:@"确 认" forState:UIControlStateNormal];
    [confimeButton setBackgroundImage:[UIImage imageNamed:@"confime_addBrand"] forState:UIControlStateNormal];
    confimeButton.titleLabel.font=[UIFont systemFontOfSize:15.0];
    [confimeButton addTarget:self action:@selector(addBrandRequest:) forControlEvents:UIControlEventTouchUpInside];
    [selectAllBg addSubview:confimeButton];
    selectAllBg=nil;
    selectAllButton=nil;
    selectAllNotice=nil;
    confimeButton=nil;
    
    self.addBrandTableView=[[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height-113.0)];
    self.addBrandTableView.dataSource=self;
    self.addBrandTableView.delegate=self;
    [self.view addSubview:self.addBrandTableView];
    
    
    // Do any additional setup after loading the view.
}

#pragma mark -
#pragma mark TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
	return 227.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if([brandArray count]<8){
        return 2;
//    }else{
//        return  ceil((float)[brandArray count]/ImageViewNumber) ;
//	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"cellIdentifier";
	AddBrandTableViewCell *cell = (AddBrandTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		//定义使用单元格使用的 nib 文件
		NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AddBrandTableViewCell" owner:self options:nil];
		cell = [array objectAtIndex:0];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		tableView.separatorStyle = UITableViewCellSelectionStyleNone;
	}
	
	//根据indexPath.row计算本行应显示mutableArray中的image
	NSInteger recordCount=[brandArray count];
	NSInteger startIndexInmutableArray=indexPath.row*ImageViewNumber;
	NSInteger recordInMutableArrayMemberList=recordCount;
	NSInteger positionInRow=1;
	for (NSInteger i=startIndexInmutableArray; i<startIndexInmutableArray+ImageViewNumber; i++) {
		if (i<recordInMutableArrayMemberList) {
			[self drawImageOfPosition:positionInRow inRowOfTable:indexPath.row cellToDraw:cell tableView:tableView];
			
		}
		positionInRow++;
	}
	return cell;
}

#pragma mark -
#pragma mark tap
- (void)drawImageOfPosition:(NSInteger)position inRowOfTable:(NSInteger)row cellToDraw:(AddBrandTableViewCell*)cell tableView:(UITableView*)tableView{
	
	NSInteger indexInMutableArrayAlbum=row*ImageViewNumber+position-1;//根据在tableview的位置计算在mutableArrayMemberList中的位置
	BrandAssets	 *brandAssets=[brandArray objectAtIndex:indexInMutableArrayAlbum];
//    UIImage *checkImage=brandAssets.selected?[UIImage imageNamed:@"noselect_brand"]:[UIImage imageNamed:@"selected_brand"];
	switch (position) {
		case 1:{
			[[cell leftBrandImageView] setTag:indexInMutableArrayAlbum];//将tag值改和brandArray的indexPath一致
            if(brandAssets.thumnail!=nil){
                [[cell leftBrandImageView] setImage:brandAssets.thumnail];
            }else{
                [[cell leftBrandImageView] setImage:[UIImage imageNamed:@"default_pic_offical"]];
            }
            
            [self chooseTapGestureForImageView:[cell leftSelecteImageView]];
        }
			break;
		case 2:{
			[[cell rightBrandImageView] setHidden:NO];
			[[cell rightBrandImageView] setTag:indexInMutableArrayAlbum];//将tag值改和brandArray的indexPath一致
            if(brandAssets.thumnail!=nil){
                [[cell rightBrandImageView] setImage:brandAssets.thumnail];
            }else{
                [[cell rightBrandImageView] setImage:[UIImage imageNamed:@"default_pic_offical"]];
            }
            [self chooseTapGestureForImageView:[cell rightSelecteImageView]];
        }
			break;
		default:
			break;
	}
}

//添加手势
-(void)chooseTapGestureForImageView:(UIImageView*) imageView{
	UITapGestureRecognizer *singleTap =
	[[UITapGestureRecognizer alloc] initWithTarget:self
											action:@selector(chosePhotoOrnot:)];
	singleTap.numberOfTapsRequired = 1;
	[imageView setUserInteractionEnabled:YES];
	[imageView addGestureRecognizer:singleTap];
}

//选择图片
-(void)chosePhotoOrnot:(id)sender{
    [self addSelectImage:(UIImageView *)[sender view]];
    NSInteger theTag=[[sender view] tag];
    
    BrandAssets *brandAssets=[brandArray objectAtIndex:theTag];
    NSLog(@"theTag is %d",theTag);
    if(brandAssets.selected==NO){
        brandAssets.selected=YES;
    }else{
        brandAssets.selected=NO;
    }
    NSInteger rowOfIndex=  ceil((float)(theTag+1)/ImageViewNumber)-1;//arrayIndex从0开始，实际image数为arrayindex+1
	NSInteger positionInTheRow=(theTag+1)-ImageViewNumber*(rowOfIndex);
    
	NSIndexPath *cellIndexPath= [NSIndexPath indexPathForRow:rowOfIndex inSection:0];//将所在行数还原成tableview的indexpath
	AddBrandTableViewCell *cell = (AddBrandTableViewCell*)[addBrandTableView cellForRowAtIndexPath:cellIndexPath];
    UIImage *checkImage=[UIImage imageNamed:@"selected_brand"];
    UIImage *checkSelectImage=[UIImage imageNamed:@"noselect_brand"];
	switch (positionInTheRow) {
		case 1:
		{
			if (brandAssets.selected==NO) {
				[[cell leftSelecteImageView] setImage:checkImage];
			}else {
				[[cell leftSelecteImageView] setImage:checkSelectImage];
			}
		}
			break;
		case 2:
		{
			if (brandAssets.selected==NO) {
				[cell rightSelecteImageView].image=checkImage;
			}else {
				[cell rightSelecteImageView].image=checkSelectImage;
			}
		}
			break;
            
		default:
			break;
	}
}

-(void)addSelectImage:(UIImageView *)imageView{
    UIImageView *selectImageView=[[UIImageView alloc]initWithFrame:imageView.bounds];
    selectImageView.image=[UIImage imageNamed:@"select_border.png"];
    selectImageView.center=imageView.center;;
    [[imageView superview] addSubview:selectImageView];
    [self performSelector:@selector(selectAnimation:) withObject:selectImageView afterDelay:0.4];
    selectImageView=nil;
}

-(void)selectAnimation:(UIImageView *)imageView{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [imageView removeFromSuperview];
    [UIView commitAnimations];
}

//添加品牌
-(void)addBrandWithUID:(NSString *)uID andBID:(NSString *)bID andVersion:(NSString *)version{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:uID forKey:@"uid"];
    [paramDict setObject:bID forKey:@"bid"];
    [paramDict setObject:version forKey:@"version"];
    
    [self.addBrandRequest postRequestWithSoapNamespace:@"AddBrand" params:paramDict successBlock:^(id result) {
        DLog(@"AddBrand result=%@", result);
        NSString *msg=[(NSDictionary *)result objectForKey:@"Msg"];
        if ([msg isEqualToString:@"1"]) {
            //添加成功
        }else{
            
        }
        
    } failureBlock:^(NSString *requestError) {
        DLog(@"add brand failure!!!");
    } errorBlock:^(NSMutableString *errorStr) {
        DLog(@"add brand error!!!");
    }];
    paramDict=nil;
}

//选中所有品牌
-(void)selectedAllBrand:(id)sender{
    for (int i=0; i<[brandArray count]; i++) {
        BrandAssets *brandAssets=[brandArray objectAtIndex:i];
        brandAssets.selected=YES;
    }
    [self.addBrandTableView reloadData];
}

//取消选择
-(void)cancelSelect{
    for (int i=0; i<[brandArray count]; i++) {
        BrandAssets *brandAssets=[brandArray objectAtIndex:i];
        brandAssets.selected=YES;
    }
    [self.addBrandTableView reloadData];
}

-(void)addBrandRequest:(id)sender{
    [self addBrandWithUID:@"001" andBID:@"012" andVersion:[Tools getAppVersion]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
