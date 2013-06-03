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
#import "LZFoodDetailController.h"
#import "LZUtility.h"
@interface LZFoodListViewController ()

@end

@implementation LZFoodListViewController
@synthesize showTableView,takenFoodArray,takenFoodDict,nutrientInfoArray,needRefresh;
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
    needRefresh = NO;
    takenFoodArray = [[NSMutableArray alloc]init];
    takenFoodDict = [[NSMutableDictionary alloc]init];
    nutrientInfoArray = [[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takenFoodChanged:) name:Notification_TakenFoodChangedKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsChanged:) name:Notification_SettingsChangedKey object:nil];
    [self displayTakenFoodResult];
}
-(void)viewWillAppear:(BOOL)animated
{
    if(needRefresh)
    {
        [self displayTakenFoodResult];
        needRefresh = NO;
    }
}
- (void)settingsChanged:(NSNotification *)notification
{
    needRefresh = YES;
}
- (void)takenFoodChanged:(NSNotification *)notification
{
    needRefresh = YES;
}
-(void)displayTakenFoodResult
{
    NSDictionary *takenFoodAmountDict = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserDailyIntakeKey];
    if (takenFoodAmountDict == NULL || [[takenFoodAmountDict allKeys]count]==0)
    {
        showTableView = NO;
        self.listView.hidden = YES;
        //[self.editFoodItem setEnabled:NO];
        self.emptyFoodShowLabel.hidden= NO;
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
            [takenFoodArray removeAllObjects];
            [takenFoodArray addObjectsFromArray:takenArray];
        }
        NSLog(@"takenArray %@",takenFoodArray);
        NSDictionary *takenDict = [retFmtDict objectForKey:Key_takenFoodNutrientInfoAryDictDict];
        if (takenDict != nil )
        {
            [takenFoodDict removeAllObjects];
            [takenFoodDict addEntriesFromDictionary:takenDict];
            NSLog(@"takenFoodDict %@ ",takenFoodDict);
        }
        NSArray *nutrientArray = [retFmtDict objectForKey:Key_nutrientTakenRateInfoArray];
        if (nutrientArray != nil && [nutrientArray count]!=0) {
            [nutrientInfoArray removeAllObjects];
            [nutrientInfoArray addObjectsFromArray:nutrientArray];
            NSLog(@"nutrientInfoArray %@",nutrientInfoArray);
        }
        
        showTableView = YES;
        self.listView.hidden = NO;
        self.emptyFoodShowLabel.hidden= YES;
        [self.listView reloadData];
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
            NSLog(@"picture path %@",aFood);
            NSString *picturePath;
            NSString *picPath = [aFood objectForKey:@"PicturePath"];
            if (picPath == NULL || [picPath isEqualToString:@""])
            {
                picturePath = [[NSBundle mainBundle]pathForResource:@"defaulFoodPic" ofType:@"png"];
            }
            else
            {
                picturePath = [NSString stringWithFormat:@"%@/foodDealed/%@",[[NSBundle mainBundle] bundlePath],picPath];
            }
            UIImage *foodImage = [UIImage imageWithContentsOfFile:picturePath];
            [cell.foodImageView setImage:foodImage];

            cell.foodNameLabel.text = [aFood objectForKey:@"Name"];
            NSNumber *weight = [aFood objectForKey:@"Amount"];
            cell.foodWeightlabel.text = [NSString stringWithFormat:@"%dg",[weight intValue]];
            //[cell.backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"foodCellBack.png"]]];
            return cell;
        }
    }
    else
    {
        LZNutritionCell *cell = (LZNutritionCell *)[tableView dequeueReusableCellWithIdentifier:@"LZNutritionCell"];
        NSDictionary *nutrient = [nutrientInfoArray objectAtIndex:indexPath.row];
        cell.nutritionNameLabel.text = [nutrient objectForKey:@"Name"];
        NSString *nutrientId = [nutrient objectForKey:@"NutrientID"];
        UIColor *fillColor = [LZUtility getNutrientColorForNutrientId:nutrientId];
        NSNumber *percent = [nutrient objectForKey:@"nutrientInitialSupplyRate"];
        float progress = [percent floatValue]>1.f ? 1.f :[percent floatValue];
        float radius;
        if (progress >0.03 )
        {
            radius = 4;
        }
        else
        {
            radius = 2;
        }
        [cell.nutritionProgressView drawProgressForRect:CGRectMake(2,2,226,14) backgroundColor:[UIColor whiteColor] fillColor:fillColor progress:progress withBackRadius:7.f fillRadius:radius];
        [cell adjustLabelAccordingToProgress:progress forLabelWidth:226];
        cell.supplyPercentlabel.text = [NSString stringWithFormat:@"%d%%",(int)(progress *100)];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return 60;
    else
        return 42;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 32)];
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
    [self.listView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0)
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
            foodDetailController.foodName = foodName;
            UINavigationController *initialController = (UINavigationController*)[UIApplication
                                                                                  sharedApplication].keyWindow.rootViewController;
            [initialController pushViewController:foodDetailController animated:YES];
        }
    }
    else
        return;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==1)
    {
        return NO;
    }
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *takenFoodAmountDict = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserDailyIntakeKey];
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]initWithDictionary:takenFoodAmountDict];
    NSDictionary *aFood = [takenFoodArray objectAtIndex:indexPath.row];
    NSString *ndb_No = [aFood objectForKey:@"NDB_No"];
    [tempDict removeObjectForKey:ndb_No];
    [[NSUserDefaults standardUserDefaults] setObject:tempDict forKey:LZUserDailyIntakeKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self displayTakenFoodResult];
    [[NSNotificationCenter defaultCenter]postNotificationName:Notification_TakenFoodDeletedKey object:nil userInfo:nil];
//    [self.takenFoodArray removeObjectAtIndex:indexPath.row];
//    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
//    [self.listView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
//- (IBAction)editFoodAction:(id)sender {
//    
//    if(!self.listView.editing)
//    {
//        [self.editFoodItem setStyle:UIBarButtonItemStyleDone];
//        [self.editFoodItem setTitle:@"完成"];
//        self.listView.editing= !self.listView.editing;
//    }
//    else
//    {
//        [self.editFoodItem setStyle:UIBarButtonItemStyleBordered];
//        [self.editFoodItem setTitle:@"编辑"];
//        self.listView.editing= !self.listView.editing;
//        [self displayTakenFoodResult];
//    }
//
//}
- (void)viewWillDisappear:(BOOL)animated
{
//    if (self.listView.editing)
//    {
//        [self.editFoodItem setStyle:UIBarButtonItemStyleBordered];
//        [self.editFoodItem setTitle:@"编辑"];
//        self.listView.editing= !self.listView.editing;
//        [self displayTakenFoodResult];
//    }
}
- (IBAction)addFoodAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZDailyIntakeViewController *dailyIntakeController = [storyboard instantiateViewControllerWithIdentifier:@"LZDailyIntakeViewController"];
    [self presentModalViewController:dailyIntakeController animated:YES];
    //UINavigationController *initialController = (UINavigationController*)[UIApplication
                                                                          //sharedApplication].keyWindow.rootViewController;

    //UINavigationController* mainNavController = (UINavigationController*)storyboard.instantiateInitialViewController;
    //NSLog(@"%@",[mainNavController description]);
    //NSLog(@"%@",[initialController description]);
    //[initialController pushViewController:dailyIntakeController animated:YES];
    
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_TakenFoodChangedKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_SettingsChangedKey object:nil];
    [self setListView:nil];
    [self setEmptyFoodShowLabel:nil];
    [super viewDidUnload];
}
@end
