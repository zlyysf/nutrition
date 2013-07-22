//
//  LZFoodInfoViewController.m
//  nutrition
//
//  Created by liu miao on 7/2/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFoodInfoViewController.h"
#import "LZStandardContentCell.h"
#import "LZUtility.h"
#import "GADMasterViewController.h"
#import "MobClick.h"
@interface LZFoodInfoViewController ()

@end

@implementation LZFoodInfoViewController
@synthesize nutrientStandardArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
    UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
}
-(void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"食物营养介绍页面"];
    GADMasterViewController *shared = [GADMasterViewController singleton];
    [shared resetAdView:self andListView:self.admobView];
    //UIView *footerView = self.listView.tableFooterView;
    //[shared resetAdView:self andListView:footerView];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (nutrientStandardArray != nil && [nutrientStandardArray count]!=0)
    {
        return [nutrientStandardArray count];
    }
    else
        return 0;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    LZStandardContentCell *cell = (LZStandardContentCell *)[tableView dequeueReusableCellWithIdentifier:@"LZStandardContentCell"];
    NSDictionary *nutrientStandard = [nutrientStandardArray objectAtIndex:indexPath.row];
    NSString *nutrientName = [nutrientStandard objectForKey:@"Name"];
    NSNumber *foodNutrientContent = [nutrientStandard objectForKey:@"foodNutrientContent"];
    NSString *unit = [nutrientStandard objectForKey:@"Unit"];
    if (indexPath.row == 0)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cell_top@2x" ofType:@"png"];
        UIImage * cellTopImage = [UIImage imageWithContentsOfFile:path];
        
        [cell.cellBackgroundImageView setImage:cellTopImage];
    }
    else if (indexPath.row == [nutrientStandardArray count]-1)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cell_bottom@2x" ofType:@"png"];
        UIImage * cellBottomImage = [UIImage imageWithContentsOfFile:path];
        [cell.cellBackgroundImageView setImage:cellBottomImage];
    }
    else
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cell_middle@2x" ofType:@"png"];
        UIImage * cellMiddleImage = [UIImage imageWithContentsOfFile:path];
        [cell.cellBackgroundImageView setImage:cellMiddleImage];
    }
    cell.nutritionNameLabel.text = nutrientName;
    cell.nutritionSupplyLabel.text = [NSString stringWithFormat:@"%.2f%@",[foodNutrientContent floatValue],unit];
    
    return cell;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"食物营养介绍页面"];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 47;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 47)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *sectionBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 27)];
    [sectionView addSubview:sectionBarView];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"section_bar@2x" ofType:@"png"];
    UIImage * sectionBarImage = [UIImage imageWithContentsOfFile:path];
    [sectionBarView setImage:sectionBarImage];
    UILabel *sectionTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 310, 27)];
    [sectionTitleLabel setTextColor:[UIColor whiteColor]];
    [sectionTitleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [sectionTitleLabel setBackgroundColor:[UIColor clearColor]];
    [sectionView addSubview:sectionTitleLabel];
    
    sectionTitleLabel.text = [NSString stringWithFormat:@"%@的营养成分标准含量(100g)",self.title];
    return sectionView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}// Default is 1 if not implemented
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setListView:nil];
    [self setAdmobView:nil];
    [super viewDidUnload];
}
@end
