//
//  LZFoodDetailController.m
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFoodDetailController.h"
#define kProgressBarRect CGRectMake(2,2,220,16)
#import "LZNutritionSupplyCell.h"
#import "LZStandardContentCell.h"
@interface LZFoodDetailController ()

@end

@implementation LZFoodDetailController

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
    self.title = @"黄豆";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        LZNutritionSupplyCell *cell = (LZNutritionSupplyCell *)[tableView dequeueReusableCellWithIdentifier:@"LZNutritionSupplyCell"];
//        UIView *tempView = [[UIView alloc] init];
//        [cell setBackgroundView:tempView];
//        [cell setBackgroundColor:[UIColor clearColor]];

        [cell.nutritionProgressView drawProgressForRect:kProgressBarRect backgroundColor:[UIColor whiteColor] fillColor:[UIColor greenColor] progress:0.5 withRadius:8];
        return cell;
    }
    else
    {
        LZStandardContentCell *cell = (LZStandardContentCell *)[tableView dequeueReusableCellWithIdentifier:@"LZStandardContentCell"];
        if (indexPath.row == 0)
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"cell_top@2x" ofType:@"png"];
            UIImage * cellTopImage = [UIImage imageWithContentsOfFile:path];

            [cell.cellBackgroundImageView setImage:cellTopImage];
        }
        else if (indexPath.row == 2)
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
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return 84;
    else
        return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if( section == 0)
        return 27;
    else
        return 47;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if( section == 0)
        return 0;
    else
        return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float height = (section ==0 ? 27 :47);
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, height)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *sectionBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 27)];
    [sectionView addSubview:sectionBarView];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"section_bar@2x" ofType:@"png"];
    UIImage * sectionBarImage = [UIImage imageWithContentsOfFile:path];
    [sectionBarView setImage:sectionBarImage];
    UILabel *sectionTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 310, 27)];
    [sectionTitleLabel setTextColor:[UIColor whiteColor]];
    [sectionTitleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [sectionTitleLabel setBackgroundColor:[UIColor clearColor]];
    [sectionView addSubview:sectionTitleLabel];
    
    if (section == 0)
        sectionTitleLabel.text =  @"供给比例=供给量/标准需求量";
    else
        sectionTitleLabel.text =  @"标准含量(100g)";
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
    return 2;
}// Default is 1 if not implemented

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
