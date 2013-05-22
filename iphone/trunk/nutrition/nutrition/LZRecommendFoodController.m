//
//  LZViewController.m
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZRecommendFoodController.h"
#define kProgressBarRect CGRectMake(2,2,220,16)
#import "LZRecommendFoodCell.h"
#import "LZNutritionCell.h"
@interface LZRecommendFoodController ()

@end

@implementation LZRecommendFoodController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"推荐食物";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
    UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
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
        LZRecommendFoodCell *cell = (LZRecommendFoodCell *)[tableView dequeueReusableCellWithIdentifier:@"LZRecommendFoodCell"];
        return cell;
    }
    else if (indexPath.section == 1)
    {
        LZNutritionCell *cell = (LZNutritionCell *)[tableView dequeueReusableCellWithIdentifier:@"LZNutritionCell"];
        if (indexPath.row == 0)
        {
            [cell.nutritionProgressView drawProgressForRect:kProgressBarRect backgroundColor:[UIColor whiteColor] fillColor:[UIColor greenColor] progress:0.5 withRadius:8];
            [cell adjustLabelAccordingToProgress:0.5];
        }
        else if(indexPath.row == 1)
        {
           [cell.nutritionProgressView drawProgressForRect:kProgressBarRect backgroundColor:[UIColor whiteColor] fillColor:[UIColor blueColor] progress:0.8 withRadius:8];
            [cell adjustLabelAccordingToProgress:0.8];
        }
        else
        {
           [cell.nutritionProgressView drawProgressForRect:kProgressBarRect backgroundColor:[UIColor whiteColor] fillColor:[UIColor redColor] progress:0.3 withRadius:8];
            [cell adjustLabelAccordingToProgress:0.3];
        }
        
        return cell;
    }
    else
    {
        LZRecommendFoodCell *cell = (LZRecommendFoodCell *)[tableView dequeueReusableCellWithIdentifier:@"LZRecommendFoodCell"];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
        return 68;
    else
        return 84;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 27;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 27)];
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
        sectionTitleLabel.text =  @"已经决定了的食物";
    else if (section == 1)
        sectionTitleLabel.text =  @"摄取的营养够了么";
    else
        sectionTitleLabel.text =  @"推荐食物";

    return sectionView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}// Default is 1 if not implemented
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
