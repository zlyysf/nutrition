//
//  LZFoodListViewController.m
//  nutrition
//
//  Created by liu miao on 5/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFoodListViewController.h"
#import "LZAddFoodViewController.h"
#import "LZRecommendFood.h"
#import "LZRecommendFoodCell.h"
#import "LZFoodNutritionCell.h"
#import "LZConstants.h"
#import "LZFoodDetailController.h"
#import "LZUtility.h"
#import "LZRecommendEmptyCell.h"
#import "LZAddByNutrientController.h"
#import "GADMasterViewController.h"
#import "MobClick.h"
#import "LZAddFoodButtonCell.h"
#import <QuartzCore/QuartzCore.h>
@interface LZFoodListViewController ()

@end

@implementation LZFoodListViewController
@synthesize takenFoodArray,takenFoodDict,nutrientInfoArray,needRefresh;
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
    self.title = @"检测";
	// Do any additional setup after loading the view.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
    UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
    needRefresh = NO;
    takenFoodArray = [[NSMutableArray alloc]init];
    takenFoodDict = [[NSMutableDictionary alloc]init];
    nutrientInfoArray = [[NSMutableArray alloc]init];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0,0,
                                                             CGSizeFromGADAdSize(kGADAdSizeBanner).width,
                                                             CGSizeFromGADAdSize(kGADAdSizeBanner).height)];
    self.listView.tableFooterView = footerView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takenFoodChanged:) name:Notification_TakenFoodChangedKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsChanged:) name:Notification_SettingsChangedKey object:nil];
    [self displayTakenFoodResult];
}
-(void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"检测页面"];
    GADMasterViewController *shared = [GADMasterViewController singleton];
    UIView *footerView = self.listView.tableFooterView;
    [shared resetAdView:self andListView:footerView];
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

    NSNumber *planPerson = [[NSUserDefaults standardUserDefaults] objectForKey:LZPlanPersonsKey];
    NSNumber *planDays = [[NSUserDefaults standardUserDefaults]objectForKey:LZPlanDaysKey];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            planPerson,@"personCount",
                            planDays,@"dayCount", nil];
    
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf takenFoodSupplyNutrients_AbstractPerson:params withDecidedFoods:takenFoodAmountDict];
    NSMutableDictionary *retFmtDict = [rf formatTakenResultForUI:retDict];
    //NSLog(@"retFmtDict %@",retFmtDict);
    NSArray *takenArray = [retFmtDict objectForKey:Key_takenFoodInfoDictArray];
    [takenFoodArray removeAllObjects];
    if (takenArray != nil && [takenArray count]!=0) {
        
        [takenFoodArray addObjectsFromArray:takenArray];
    }
    //NSLog(@"takenArray %@",takenFoodArray);
    NSDictionary *takenDict = [retFmtDict objectForKey:Key_takenFoodNutrientInfoAryDictDict];
    [takenFoodDict removeAllObjects];
    if (takenDict != nil )
    {
        
        [takenFoodDict addEntriesFromDictionary:takenDict];
        //NSLog(@"takenFoodDict %@ ",takenFoodDict);
    }
    NSArray *nutrientArray = [retFmtDict objectForKey:Key_nutrientTakenRateInfoArray];
    [nutrientInfoArray removeAllObjects];
    if (nutrientArray != nil && [nutrientArray count]!=0) {
        
        [nutrientInfoArray addObjectsFromArray:nutrientArray];
        //NSLog(@"nutrientInfoArray %@",nutrientInfoArray);
    }
    

    [self.listView reloadData];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return (takenFoodArray ==nil || [takenFoodArray count]==0) ? 2 : [takenFoodArray count]+1;
    else
        return [nutrientInfoArray count];
//    if (section == 0)
//        return (recommendFoodArray ==nil || [recommendFoodArray count]==0) ? 1 : [recommendFoodArray count];
//    else
//        return [nutrientInfoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            LZAddFoodButtonCell  * cell = (LZAddFoodButtonCell*)[tableView dequeueReusableCellWithIdentifier:@"LZAddFoodButtonCell"];
            return cell;
        }
        else
        {
            if(takenFoodArray ==nil || [takenFoodArray count]==0)
            {
                LZRecommendEmptyCell * cell = (LZRecommendEmptyCell*)[tableView dequeueReusableCellWithIdentifier:@"LZRecommendEmptyCell"];
                [cell.contentLabel setTextColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8]];
                cell.contentLabel.text = @"请添加今日计划要购买的食物，我们会帮你分析今日摄入的营养量是否达到标准，并推荐相关的食物以达到标准，让菜买的顺当，吃的健康！";
                return cell;
            }
            else
            {
                LZRecommendFoodCell *cell = (LZRecommendFoodCell *)[tableView dequeueReusableCellWithIdentifier:@"LZRecommendFoodCell"];
                NSDictionary *aFood = [takenFoodArray objectAtIndex:indexPath.row-1];
                //NSLog(@"picture path %@",aFood);
                NSString *picturePath;
                NSString *picPath = [aFood objectForKey:@"PicturePath"];
                if (picPath == nil || [picPath isEqualToString:@""])
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
    }
    else
    {
        LZFoodNutritionCell *cell = (LZFoodNutritionCell *)[tableView dequeueReusableCellWithIdentifier:@"LZFoodNutritionCell"];
        NSDictionary *nutrient = [nutrientInfoArray objectAtIndex:indexPath.row];
        [cell.nutritionNameButton setTitle:[nutrient objectForKey:@"Name"] forState:UIControlStateNormal];
        NSString *nutrientId = [nutrient objectForKey:@"NutrientID"];
        cell.nutrientId = nutrientId;
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
        [cell.backView.layer setMasksToBounds:YES];
        [cell.backView.layer setCornerRadius:3.f];
        [cell.nutritionProgressView drawProgressForRect:CGRectMake(2,2,200,14) backgroundColor:[UIColor whiteColor] fillColor:fillColor progress:progress withBackRadius:7.f fillRadius:radius];
        [cell adjustLabelAccordingToProgress:progress forLabelWidth:200];
//        [cell.backView setBackgroundColor:[UIColor clearColor]];
//        if (KeyIsEnvironmentDebug)
//        {
            cell.supplyPercentlabel.text = [NSString stringWithFormat:@"%d%%",(int)([percent floatValue] *100)];
//        }
//        else
//        {
//            cell.supplyPercentlabel.text = [NSString stringWithFormat:@"%d%%",(int)(progress *100)];
//            
//        }
        cell.addFoodButton.tag = indexPath.row;
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
        sectionTitleLabel.text =  @"今日打算购买的食物";
    else
        sectionTitleLabel.text =  @"今日营养补充进度";
    
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
        if (indexPath.row == 0)
        {
            return;
        }
        if(takenFoodArray ==nil || [takenFoodArray count]==0)
        {
            return;
        }
        else
        {
            NSDictionary *aFood = [takenFoodArray objectAtIndex:indexPath.row-1];
            NSString *ndb_No = [aFood objectForKey:@"NDB_No"];
            NSArray *nutrientSupplyArr = [[takenFoodDict objectForKey:Key_foodSupplyNutrientInfoAryDict]objectForKey:ndb_No];
            NSArray *nutrientStandardArr = [[takenFoodDict objectForKey:Key_foodStandardNutrientInfoAryDict]objectForKey:ndb_No];
            NSString *foodName = [aFood objectForKey:@"Name"];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            LZFoodDetailController * foodDetailController = [storyboard instantiateViewControllerWithIdentifier:@"LZFoodDetailController"];
            foodDetailController.nutrientSupplyArray = nutrientSupplyArr;
            foodDetailController.nutrientStandardArray = nutrientStandardArr;
            foodDetailController.foodName = foodName;
            foodDetailController.isForRecomendFood = NO;
            UINavigationController *initialController = (UINavigationController*)[UIApplication
                                                                                  sharedApplication].keyWindow.rootViewController;
            [initialController pushViewController:foodDetailController animated:YES];
        }
    }
    else
    {
        NSDictionary *takenFoodAmountDict = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserDailyIntakeKey];
        
        NSNumber *planPerson = [[NSUserDefaults standardUserDefaults] objectForKey:LZPlanPersonsKey];
        NSNumber *planDays = [[NSUserDefaults standardUserDefaults]objectForKey:LZPlanDaysKey];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                planPerson,@"personCount",
                                planDays,@"dayCount", nil];
        
        
        LZRecommendFood *rf = [[LZRecommendFood alloc]init];
        NSMutableDictionary *retDict = [rf takenFoodSupplyNutrients_AbstractPerson:params withDecidedFoods:takenFoodAmountDict];
        NSDictionary *nutrient = [nutrientInfoArray objectAtIndex:indexPath.row];
        NSString *nutrientId = [nutrient objectForKey:@"NutrientID"];
        NSString *nutrientName = [nutrient objectForKey:@"Name"];
        NSDictionary *DRIsDict = [retDict objectForKey:@"DRI"];//nutrient name as key, also column name
        NSDictionary *nutrientInitialSupplyDict = [retDict objectForKey:@"nutrientInitialSupplyDict"];
        NSNumber *nmNutrientInitSupplyVal = [nutrientInitialSupplyDict objectForKey:nutrientId];
        double dNutrientNeedVal = [((NSNumber*)[DRIsDict objectForKey:nutrientId]) doubleValue]*[planPerson intValue]*[planDays intValue];
        double dNutrientLackVal = dNutrientNeedVal - [nmNutrientInitSupplyVal doubleValue];
        //    if (dNutrientLackVal <= 0)
        //    {
        //        return;
        //    }
        LZDataAccess *da = [LZDataAccess singleton];
        NSArray *recommendFoodArray = [da getRichNutritionFoodForNutrient:nutrientId andNutrientAmount:[NSNumber numberWithDouble:dNutrientLackVal]];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        LZAddByNutrientController *addByNutrientController = [storyboard instantiateViewControllerWithIdentifier:@"LZAddByNutrientController"];
        addByNutrientController.foodArray = recommendFoodArray;
        addByNutrientController.nutrientTitle = nutrientName;
         UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:addByNutrientController];
        [self presentModalViewController:navController animated:YES];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==1)
    {
        return NO;
    }
    else 
    {
        if(indexPath.row == 0)
        {
            return NO;
        }
        return !(takenFoodArray ==nil || [takenFoodArray count]==0);
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *takenFoodAmountDict = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserDailyIntakeKey];
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]initWithDictionary:takenFoodAmountDict];
    NSDictionary *aFood = [takenFoodArray objectAtIndex:indexPath.row-1];
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
    [MobClick endLogPageView:@"检测页面"];
    [self.listView reloadData];
//    if (self.listView.editing)
//    {
//        [self.editFoodItem setStyle:UIBarButtonItemStyleBordered];
//        [self.editFoodItem setTitle:@"编辑"];
//        self.listView.editing= !self.listView.editing;
//        [self displayTakenFoodResult];
//    }
}
- (void)addFood
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    LZAddFoodViewController *addFoodViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZAddFoodViewController"];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:addFoodViewController];
    [self presentModalViewController:navController animated:YES];
}
- (IBAction)addFoodAction:(id)sender {
    [self performSelector:@selector(addFood) withObject:nil afterDelay:0.f];
    
    
    //UINavigationController *initialController = (UINavigationController*)[UIApplication
                                                                          //sharedApplication].keyWindow.rootViewController;

    //UINavigationController* mainNavController = (UINavigationController*)storyboard.instantiateInitialViewController;
    //NSLog(@"%@",[mainNavController description]);
    //NSLog(@"%@",[initialController description]);
    //[initialController pushViewController:dailyIntakeController animated:YES];
    
}
- (void)addFoodForTag:(NSNumber *)tagNum
{
    int tag = [tagNum intValue];
    NSDictionary *takenFoodAmountDict = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserDailyIntakeKey];
    
    NSNumber *planPerson = [[NSUserDefaults standardUserDefaults] objectForKey:LZPlanPersonsKey];
    NSNumber *planDays = [[NSUserDefaults standardUserDefaults]objectForKey:LZPlanDaysKey];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            planPerson,@"personCount",
                            planDays,@"dayCount", nil];
    
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf takenFoodSupplyNutrients_AbstractPerson:params withDecidedFoods:takenFoodAmountDict];
    NSDictionary *nutrient = [nutrientInfoArray objectAtIndex:tag];
    NSString *nutrientId = [nutrient objectForKey:@"NutrientID"];
    NSString *nutrientName = [nutrient objectForKey:@"Name"];
    NSDictionary *DRIsDict = [retDict objectForKey:@"DRI"];//nutrient name as key, also column name
    NSDictionary *nutrientInitialSupplyDict = [retDict objectForKey:@"nutrientInitialSupplyDict"];
    NSNumber *nmNutrientInitSupplyVal = [nutrientInitialSupplyDict objectForKey:nutrientId];
    double dNutrientNeedVal = [((NSNumber*)[DRIsDict objectForKey:nutrientId]) doubleValue]*[planPerson intValue]*[planDays intValue];
    double dNutrientLackVal = dNutrientNeedVal - [nmNutrientInitSupplyVal doubleValue];
//    if (dNutrientLackVal <= 0)
//    {
//        return;
//    }
    LZDataAccess *da = [LZDataAccess singleton];
    NSArray *recommendFoodArray = [da getRichNutritionFoodForNutrient:nutrientId andNutrientAmount:[NSNumber numberWithDouble:dNutrientLackVal]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZAddByNutrientController *addByNutrientController = [storyboard instantiateViewControllerWithIdentifier:@"LZAddByNutrientController"];
    addByNutrientController.foodArray = recommendFoodArray;
    addByNutrientController.nutrientTitle = nutrientName;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:addByNutrientController];
    [self presentModalViewController:navController animated:YES];

}
- (IBAction)addFoodByNutrient:(UIButton *)sender {
    int tag = sender.tag;
    [self performSelector:@selector(addFoodForTag:) withObject:[NSNumber numberWithInt:tag] afterDelay:0.f];
        

}
- (IBAction)clearFoodAction:(id)sender {
    NSDictionary *dailyIntake = [[NSDictionary alloc]init];
    [[NSUserDefaults standardUserDefaults] setObject:dailyIntake forKey:LZUserDailyIntakeKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self displayTakenFoodResult];
    [[NSNotificationCenter defaultCenter]postNotificationName:Notification_TakenFoodDeletedKey object:nil userInfo:nil];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_TakenFoodChangedKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_SettingsChangedKey object:nil];
    [self setListView:nil];
    [super viewDidUnload];
}
@end
