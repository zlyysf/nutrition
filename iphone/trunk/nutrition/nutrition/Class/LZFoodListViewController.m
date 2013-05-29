//
//  LZFoodListViewController.m
//  nutrition
//
//  Created by liu miao on 5/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFoodListViewController.h"
#import "LZDailyIntakeViewController.h"
#import "LZRecommendFood.h"
#import "LZRecommendFoodCell.h"
#import "LZNutritionCell.h"
#import "LZConstants.h"
@interface LZFoodListViewController ()

@end

@implementation LZFoodListViewController
@synthesize showTableView,takenFoodArray,takenFoodDict,nutrientInfoArray;
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
    self.title = @"食物";
	// Do any additional setup after loading the view.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
    UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
    self.listView.hidden = NO;
    NSDictionary *takenFoodAmountDict = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserDailyIntakeKey];
    if (takenFoodAmountDict == NULL || [[takenFoodAmountDict allKeys]count]==0)
    {
        showTableView = NO;
    }
    else
    {
        NSNumber *planPerson = [[NSUserDefaults standardUserDefaults] objectForKey:LZPlanPersonsKey];
        NSNumber *planDays = [[NSUserDefaults standardUserDefaults]objectForKey:LZPlanDaysKey];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                planPerson,@"personCount",
                                planDays,@"dayCount", nil];
        
        
        LZRecommendFood *rf = [[LZRecommendFood alloc]init];
        NSMutableDictionary *retDict = [rf takenFoodSupplyNutrients_AbstractPerson:params withDecidedFoods:takenFoodAmountDict];
        NSMutableDictionary *retFmtDict = [rf formatTakenResultForUI:retDict];
        NSLog(@"retFmtDict %@",retFmtDict);
        NSArray *takenArray = [retFmtDict objectForKey:Key_takenFoodInfoDictArray];
        if (takenArray != nil && [takenArray count]!=0) {
            takenFoodArray = [[NSMutableArray alloc]initWithArray:takenArray];
        }
        NSLog(@"takenArray %@",takenFoodArray);
        NSDictionary *takenDict = [retFmtDict objectForKey:Key_takenFoodNutrientInfoAryDictDict];
        if (takenDict != nil )
        {
            takenFoodDict = [[NSMutableDictionary alloc]initWithDictionary:takenDict];
            NSLog(@"takenFoodDict %@ ",takenFoodDict);
        }
        NSArray *nutrientArray = [retFmtDict objectForKey:Key_nutrientTakenRateInfoArray];
        if (nutrientArray != nil && [nutrientArray count]!=0) {
            nutrientInfoArray = [[NSMutableArray alloc]initWithArray:nutrientArray];
        }

        showTableView = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (showTableView)
    {
        if (section == 0)
            return [takenFoodArray count];
        else
            return [nutrientInfoArray count];
    }
    return 0;
//    if (section == 0)
//        return (recommendFoodArray ==nil || [recommendFoodArray count]==0) ? 1 : [recommendFoodArray count];
//    else
//        return [nutrientInfoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if(takenFoodArray ==nil || [takenFoodArray count]==0)
        {
            UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EmptyCell"];
            cell.textLabel.text = @"空";
            return cell;
        }
        else
        {
            LZRecommendFoodCell *cell = (LZRecommendFoodCell *)[tableView dequeueReusableCellWithIdentifier:@"LZRecommendFoodCell"];
            NSDictionary *aFood = [takenFoodArray objectAtIndex:indexPath.row];
            cell.foodNameLabel.text = [aFood objectForKey:@"Name"];
            NSNumber *weight = [aFood objectForKey:@"Amount"];
            cell.foodWeightlabel.text = [NSString stringWithFormat:@"%dg",[weight intValue]];
            [cell.backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"foodCellBack.png"]]];
            return cell;
        }
    }
    else
    {
        LZNutritionCell *cell = (LZNutritionCell *)[tableView dequeueReusableCellWithIdentifier:@"LZNutritionCell"];
        NSDictionary *nutrient = [nutrientInfoArray objectAtIndex:indexPath.row];
        cell.nutritionNameLabel.text = [nutrient objectForKey:@"Name"];
        NSNumber *percent = [nutrient objectForKey:@"nutrientInitialSupplyRate"];
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
        [cell.nutritionProgressView drawProgressForRect:kProgressBarRect backgroundColor:[UIColor whiteColor] fillColor:[UIColor greenColor] progress:progress withBackRadius:8.f fillRadius:radius];
        [cell adjustLabelAccordingToProgress:0.5];
        cell.supplyPercentlabel.text = [NSString stringWithFormat:@"%d%%",(int)(progress *100)];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return 70;
    else
        return 50;
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
        sectionTitleLabel.text =  @"已经确定吃的食物";
    else
        sectionTitleLabel.text =  @"摄取的营养";
    
    return sectionView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (IBAction)editFoodAction:(id)sender {
    if(!self.listView.editing)
    {
        [self.editFoodItem setStyle:UIBarButtonItemStyleDone];
        [self.editFoodItem setTitle:@"完成"];
        
    }
    else
    {
        [self.editFoodItem setStyle:UIBarButtonItemStyleBordered];
        [self.editFoodItem setTitle:@"编辑"];
    }
    self.listView.editing= !self.listView.editing;
}

- (IBAction)addFoodAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZDailyIntakeViewController *dailyIntakeController = [storyboard instantiateViewControllerWithIdentifier:@"LZDailyIntakeViewController"];
    UINavigationController *initialController = (UINavigationController*)[UIApplication
                                                                          sharedApplication].keyWindow.rootViewController;

    //UINavigationController* mainNavController = (UINavigationController*)storyboard.instantiateInitialViewController;
    //NSLog(@"%@",[mainNavController description]);
    //NSLog(@"%@",[initialController description]);
    [initialController pushViewController:dailyIntakeController animated:YES];
    
}

- (void)viewDidUnload {
    [self setListView:nil];
    [self setEditFoodItem:nil];
    [super viewDidUnload];
}
@end
