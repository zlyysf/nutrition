//
//  LZFoodDetailController.m
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFoodDetailController.h"
#import "LZConstants.h"
#import "LZNutritionSupplyCell.h"
#import "LZStandardContentCell.h"
@interface LZFoodDetailController ()

@end

@implementation LZFoodDetailController
@synthesize nutrientSupplyArray,nutrientStandardArray,foodName;
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
    self.navItem.title = foodName;
    UIImage *buttonImage = [UIImage imageNamed:@"nav_back_button.png"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    
    button.frame = CGRectMake(0, 0, 48, 30);
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [button addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navItem.leftBarButtonItem= customBarItem;

}
- (void)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (nutrientSupplyArray != nil && [nutrientSupplyArray count]!=0)
        {
            return [nutrientSupplyArray count];
        }
        else
            return 0;
    }
    else
    {
        if (nutrientStandardArray != nil && [nutrientStandardArray count]!=0)
        {
            return [nutrientStandardArray count];
        }
        else
            return 0;
    }

}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        LZNutritionSupplyCell *cell = (LZNutritionSupplyCell *)[tableView dequeueReusableCellWithIdentifier:@"LZNutritionSupplyCell"];
        NSDictionary *aNutrient = [nutrientSupplyArray objectAtIndex:indexPath.row];
        NSString *nutrientName = [aNutrient objectForKey:@"Name"];
        cell.nutrientNameLabel.text = nutrientName;
        NSNumber *percent = [aNutrient objectForKey:@"1foodSupply1NutrientRate"];
        NSNumber *food1Supply1NutrientAmount = [aNutrient objectForKey:@"food1Supply1NutrientAmount"];
        NSNumber *nutrientTotalDRI = [aNutrient objectForKey:@"nutrientTotalDRI"];
        NSString *unit = [aNutrient objectForKey:@"Unit"];
        float progress = [percent floatValue]>1.f ? 1.f :[percent floatValue];
        float radius;
        if (progress >0.03 )
        {
            radius = 6;
        }
        else
        {
            radius = 2;
        }
        [cell.nutritionProgressView drawProgressForRect:kProgressBarRect backgroundColor:[UIColor whiteColor] fillColor:[UIColor blueColor] progress:progress withBackRadius:8.f fillRadius:radius];
        //[cell adjustLabelAccordingToProgress:0.5];
        cell.nutrientSupplyLabel.text = [NSString stringWithFormat:@"%d%%,%d/%d (%@)",(int)(progress *100),[food1Supply1NutrientAmount intValue],[nutrientTotalDRI intValue ],unit];

//        UIView *tempView = [[UIView alloc] init];
//        [cell setBackgroundView:tempView];
//        [cell setBackgroundColor:[UIColor clearColor]];

        //[cell.nutritionProgressView drawProgressForRect:kProgressBarRect backgroundColor:[UIColor whiteColor] fillColor:[UIColor greenColor] progress:0.5 withRadius:8];
        return cell;
    }
    else
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
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return 50;
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
        sectionTitleLabel.text =  @"营养成分";
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

- (void)viewDidUnload {
    [self setNavItem:nil];
    [super viewDidUnload];
}
@end
