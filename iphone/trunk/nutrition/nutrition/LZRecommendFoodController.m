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
#import "LZConstants.h"
#import "LZRecommendFood.h"
#import "LZFoodDetailController.h"
@interface LZRecommendFoodController ()

@end

@implementation LZRecommendFoodController
@synthesize takenFoodArray,takenFoodDict,recommendFoodArray,recommendFoodDict,nutrientInfoArray;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"推荐";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
    UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dailyIntake = [userDefaults objectForKey:LZUserDailyIntakeKey];
    
    BOOL notAllowSameFood = TRUE;//这是一个策略标志位，偏好食物的多样化的标志位，即当选取食物补充营养时，优先选取以前没有用过的食物。
    BOOL randomSelectFood = TRUE;
    int randomRangeSelectFood = 2;//配合randomSelectFood，用于限制随机范围，0表示不限制, >0表示优先选择其范围内的东西
    BOOL needLimitNutrients = TRUE;//是否要根据需求限制计算的营养素集合
    int limitRecommendFoodCount = 4;//0;//4;//只限制显示的
    
    if ( [userDefaults objectForKey:LZSettingKey_randomSelectFood]!=nil ){
        randomSelectFood = [userDefaults boolForKey:LZSettingKey_randomSelectFood];
    }
    if ( [userDefaults objectForKey:LZSettingKey_randomRangeSelectFood]!=nil ){
        randomRangeSelectFood = [userDefaults integerForKey:LZSettingKey_randomRangeSelectFood];
    }
    if ( [userDefaults objectForKey:LZSettingKey_needLimitNutrients]!=nil ){
        needLimitNutrients = [userDefaults boolForKey:LZSettingKey_needLimitNutrients];
    }
    if ( [userDefaults objectForKey:LZSettingKey_notAllowSameFood]!=nil ){
        notAllowSameFood = [userDefaults boolForKey:LZSettingKey_notAllowSameFood];
    }
    if ( [userDefaults objectForKey:LZSettingKey_limitRecommendFoodCount]!=nil ){
        limitRecommendFoodCount = [userDefaults integerForKey:LZSettingKey_limitRecommendFoodCount];
    }
    
    uint personCount = 1;
    uint dayCount = 1;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithUnsignedInt:personCount],@"personCount",
                            [NSNumber numberWithUnsignedInt:dayCount],@"dayCount", nil];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             nil];
    //NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:dailyIntake andUserInfo:userInfo andOptions:options];
    NSMutableDictionary *retDict = [rf recommendFood2_AbstractPerson:params withDecidedFoods:dailyIntake andOptions:options];
    NSMutableDictionary *uiDictionary = [rf formatRecommendResultForUI:retDict];
    NSLog(@"uiDictionary %@",uiDictionary);
    NSArray *takenArray = [uiDictionary objectForKey:Key_takenFoodInfoDictArray];
    if (takenArray != nil && [takenArray count]!=0) {
        takenFoodArray = [[NSArray alloc]initWithArray:takenArray];
    }
    NSDictionary *takenDict = [uiDictionary objectForKey:Key_takenFoodNutrientInfoAryDictDict];
    if (takenDict != nil )
    {
        takenFoodDict = [[NSDictionary alloc]initWithDictionary:takenDict];
    }
    NSArray *recommendArray = [uiDictionary objectForKey:Key_recommendFoodInfoDictArray];
    if (recommendArray != nil && [recommendArray count]!=0) {
        recommendFoodArray = [[NSArray alloc]initWithArray:recommendArray];
    }
    NSDictionary *recommendDict = [uiDictionary objectForKey:Key_recommendFoodNutrientInfoAryDictDict];
    if (recommendDict != nil )
    {
        recommendFoodDict = [[NSDictionary alloc]initWithDictionary:recommendDict];
    }
    NSArray *nutrientArray = [uiDictionary objectForKey:Key_nutrientTakenRateInfoArray];
    if (nutrientArray != nil && [nutrientArray count]!=0) {
        nutrientInfoArray = [[NSArray alloc]initWithArray:nutrientArray];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return (takenFoodArray ==nil || [takenFoodArray count]==0) ? 1 : [takenFoodArray count];
    else if (section == 1)
        return [nutrientInfoArray count];
    else
        return (recommendFoodArray ==nil || [recommendFoodArray count]==0) ? 1 : [recommendFoodArray count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

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
//            NSString *foodPic = [aFood objectForKey:@"PicturePath"];
//            UIImage *iconImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/quizicons/%@",[[NSBundle mainBundle] bundlePath],foodPic]];
//            [cell.foodImageView setImage:iconImage];
            return cell;
        }
    }
    else if (indexPath.section == 1)
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
    else
    {
        if(recommendFoodArray ==nil || [recommendFoodArray count]==0)
        {
            UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EmptyCell"];
            cell.textLabel.text = @"空";
            return cell;
        }
        else
        {
            LZRecommendFoodCell *cell = (LZRecommendFoodCell *)[tableView dequeueReusableCellWithIdentifier:@"LZRecommendFoodCell"];
            NSDictionary *aFood = [recommendFoodArray objectAtIndex:indexPath.row];
            cell.foodNameLabel.text = [aFood objectForKey:@"Name"];
            NSNumber *weight = [aFood objectForKey:@"Amount"];
            cell.foodWeightlabel.text = [NSString stringWithFormat:@"%dg",[weight intValue]];

        return cell;
        }
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if(takenFoodArray ==nil || [takenFoodArray count]==0)
        {
            return;
        }
        else
        {
            NSDictionary *aFood = [takenFoodArray objectAtIndex:indexPath.row];
            NSString *ndb_No = [aFood objectForKey:@"NDB_No"];
            NSArray *nutrientSupplyArr = [[takenFoodDict objectForKey:Key_foodSupplyNutrientInfoAryDict]objectForKey:ndb_No];
            NSArray *nutrientStandardArr = [[takenFoodDict objectForKey:Key_foodStandardNutrientInfoAryDict]objectForKey:ndb_No];
            NSString *foodName = [aFood objectForKey:@"Name"];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            LZFoodDetailController * foodDetailController = [storyboard instantiateViewControllerWithIdentifier:@"LZFoodDetailController"];
            foodDetailController.nutrientSupplyArray = nutrientSupplyArr;
            foodDetailController.nutrientStandardArray = nutrientStandardArr;
            foodDetailController.title = foodName;
            [self.navigationController pushViewController:foodDetailController animated:YES];
        }

    }
    else if (indexPath.section == 1)
    {
        return;
    }
    else
    {
        if(recommendFoodArray ==nil || [recommendFoodArray count]==0)
        {
            return;
        }
        else
        {
            NSDictionary *aFood = [recommendFoodArray objectAtIndex:indexPath.row];
            NSString *ndb_No = [aFood objectForKey:@"NDB_No"];
            NSArray *nutrientSupplyArr = [[recommendFoodDict objectForKey:Key_foodSupplyNutrientInfoAryDict]objectForKey:ndb_No];
            NSArray *nutrientStandardArr = [[recommendFoodDict objectForKey:Key_foodStandardNutrientInfoAryDict]objectForKey:ndb_No];
            NSString *foodName = [aFood objectForKey:@"Name"];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            LZFoodDetailController * foodDetailController = [storyboard instantiateViewControllerWithIdentifier:@"LZFoodDetailController"];
            foodDetailController.nutrientSupplyArray = nutrientSupplyArr;
            foodDetailController.nutrientStandardArray = nutrientStandardArr;
            foodDetailController.title = foodName;
            [self.navigationController pushViewController:foodDetailController animated:YES];
        }

    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
