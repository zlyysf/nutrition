//
//  LZFoodListViewController.m
//  nutrition
//
//  Created by liu miao on 5/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZDietListMakeViewController.h"
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
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "LZReviewAppManager.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "LZShareViewController.h"
#import "LZRecommendFilterView.h"
#import "LZAppDelegate.h"
@interface LZDietListMakeViewController ()<MBProgressHUDDelegate,UIActionSheetDelegate,UIAlertViewDelegate,LZRecommendFilterViewDelegate>
{
    MBProgressHUD *HUD;
}

@end

@implementation LZDietListMakeViewController
@synthesize takenFoodIdsArray,takenFoodDict,nutrientInfoArray,needRefresh,listType,takenFoodNutrientInfoDict;
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
    if (self.listType == dietListTypeNew)
    {
        self.title = @"我来做营养师";
    }
    else
    {
        self.title = @"主题名字";
    }
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.hidden = YES;
    HUD.delegate = self;
	// Do any additional setup after loading the view.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
    UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];

    UIImage *buttonImage = [UIImage imageNamed:@"nav_back_button.png"];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setTitle:@"  取消" forState:UIControlStateNormal];

    button.frame = CGRectMake(0, 0, 48, 30);
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [button addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    self.navigationItem.leftBarButtonItem = cancelItem;
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonTapped)];
    self.navigationItem.rightBarButtonItem = saveItem;
    needRefresh = NO;
    takenFoodIdsArray = [[NSMutableArray alloc]init];
    takenFoodDict = [[NSMutableDictionary alloc]init];
    nutrientInfoArray = [[NSMutableArray alloc]init];
    takenFoodNutrientInfoDict = [[NSMutableDictionary alloc]init];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0,0,
                                                             CGSizeFromGADAdSize(kGADAdSizeBanner).width,
                                                             CGSizeFromGADAdSize(kGADAdSizeBanner).height)];
    self.listView.tableFooterView = footerView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takenFoodChanged:) name:Notification_TakenFoodChangedKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsChanged:) name:Notification_SettingsChangedKey object:nil];
    [self refreshFoodNureitentProcessForAll:YES];
}
- (void)cancelButtonTapped
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LZUserDailyIntakeKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController  popViewControllerAnimated:YES];
}
- (void)saveButtonTapped
{
    [self.navigationController  popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"检测页面"];
    GADMasterViewController *shared = [GADMasterViewController singleton];
    UIView *footerView = self.listView.tableFooterView;
    [shared resetAdView:self andListView:footerView];
    if(needRefresh)
    {
        [self refreshFoodNureitentProcessForAll:YES];
        needRefresh = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"检测页面"];
    [self.listView reloadData];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_TakenFoodChangedKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_SettingsChangedKey object:nil];
    [self setListView:nil];
    [super viewDidUnload];
}

- (void)settingsChanged:(NSNotification *)notification
{
    needRefresh = YES;
}
- (void)takenFoodChanged:(NSNotification *)notification
{
    needRefresh = YES;
}
-(void)refreshFoodNureitentProcessForAll:(BOOL)needRefreshAll
{
    NSDictionary *takenFoodAmountDict = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserDailyIntakeKey];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *userSex = [userDefaults objectForKey:LZUserSexKey];
    NSNumber *userAge = [userDefaults objectForKey:LZUserAgeKey];
    NSNumber *userHeight = [userDefaults objectForKey:LZUserHeightKey];
    NSNumber *userWeight = [userDefaults objectForKey:LZUserWeightKey];
    NSNumber *userActivityLevel = [userDefaults objectForKey:LZUserActivityLevelKey];
    if (!(userSex && userAge && userHeight && userWeight && userActivityLevel))
    {
        return;
    }
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              userSex,ParamKey_sex, userAge,ParamKey_age,
                              userWeight,ParamKey_weight, userHeight,ParamKey_height,
                              userActivityLevel,ParamKey_activityLevel, nil];

    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userInfo,@"userInfo",
                            takenFoodAmountDict,@"givenFoodsAmount1",
                            nil,@"givenFoodsAmount2",
                            nil];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retFmtDict = [rf calculateGiveFoodsSupplyNutrientAndFormatForUI:params];
    NSLog(@" allkeys  %@",[retFmtDict allKeys]);
    NSLog(@"calculateGiveFoodsSupplyNutrientAndFormatForUI %@",retFmtDict);

    NSArray *takenArray1 = [retFmtDict objectForKey:Key_orderedGivenFoodIds1];
    NSArray *takenArray2 = [retFmtDict objectForKey:Key_orderedGivenFoodIds2];
    [takenFoodIdsArray removeAllObjects];
    if (takenArray1 != nil && [takenArray1 count]!=0) {
        
        [takenFoodIdsArray addObjectsFromArray:takenArray1];
    }
    if (takenArray2 != nil && [takenArray2 count]!=0) {
        
        [takenFoodIdsArray addObjectsFromArray:takenArray2];
    }

    NSDictionary *takenDict = [retFmtDict objectForKey:Key_givenFoodInfoDict2Level];
    [takenFoodDict removeAllObjects];
    if (takenDict != nil )
    {
        
        [takenFoodDict addEntriesFromDictionary:takenDict];
    }
    
    NSDictionary *takenFoodNutrientDict = [retFmtDict objectForKey:Key_takenFoodNutrientInfoAryDictDict];
    [takenFoodNutrientInfoDict removeAllObjects];
    if (takenFoodNutrientDict != nil )
    {
        
        [takenFoodNutrientInfoDict addEntriesFromDictionary:takenFoodNutrientDict];
    }

    NSArray *nutrientArray = [retFmtDict objectForKey:Key_nutrientSupplyRateInfoArray];
    [nutrientInfoArray removeAllObjects];
    if (nutrientArray != nil && [nutrientArray count]!=0) {
        
        [nutrientInfoArray addObjectsFromArray:nutrientArray];
    }
    if (needRefreshAll)
    {
         [self.listView reloadData];
    }
    else
    {
        NSIndexSet *reloadSet = [[NSIndexSet alloc]initWithIndex:1];
        [self.listView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
   

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return (takenFoodIdsArray ==nil || [takenFoodIdsArray count]==0) ? 1 : [takenFoodIdsArray count];
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
            if(takenFoodIdsArray ==nil || [takenFoodIdsArray count]==0)
            {
                LZRecommendEmptyCell * cell = (LZRecommendEmptyCell*)[tableView dequeueReusableCellWithIdentifier:@"LZRecommendEmptyCell"];
                [cell.contentLabel setTextColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8]];
                cell.contentLabel.text = @"请添加今日计划要购买的食物，我们会帮你分析今日摄入的营养量是否达到标准，并推荐相关的食物以达到标准，让菜买的顺当，吃的健康！";
                return cell;
            }
            else
            {
                LZRecommendFoodCell *cell = (LZRecommendFoodCell *)[tableView dequeueReusableCellWithIdentifier:@"LZRecommendFoodCell"];
                NSString *foodId = [takenFoodIdsArray objectAtIndex:indexPath.row];
                NSDictionary *aFood = [takenFoodDict objectForKey:foodId];
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
                cell.cellFoodId = foodId;
                cell.foodNameLabel.text = [aFood objectForKey:@"Name"];
                NSNumber *weight = [aFood objectForKey:@"Amount"];
                cell.foodWeightlabel.text = [NSString stringWithFormat:@"%dg",[weight intValue]];
                UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(foodCellSwiped:)];
                swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
                UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(foodCellSwiped:)];
                swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
                [cell addGestureRecognizer:swipeLeftGesture];
                [cell addGestureRecognizer:swipeRightGesture];
                //[cell.backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"foodCellBack.png"]]];
                return cell;
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
        NSNumber *percent = [nutrient objectForKey:@"nutrientSupplyRate"];
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
        //[cell.backView setBackgroundColor:[UIColor clearColor]];
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
- (void)foodCellSwiped:(UISwipeGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"%d",sender.direction);
        LZRecommendFoodCell *cell = (LZRecommendFoodCell*)sender.view;
        NSString *foodId = cell.cellFoodId;
        NSDictionary *cellInfoDict = [self.takenFoodDict objectForKey:foodId];
        int index = [self.takenFoodIdsArray indexOfObject:foodId];
         if (index >= 0 && index < [self.takenFoodIdsArray count])
        {
            NSIndexPath *indexPathToDelete = [NSIndexPath indexPathForRow:index inSection:0];
            
            NSDictionary *takenFoodAmountDict = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserDailyIntakeKey];
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]initWithDictionary:takenFoodAmountDict];
            NSString *ndb_No = [cellInfoDict objectForKey:@"NDB_No"];
            [tempDict removeObjectForKey:ndb_No];
            [[NSUserDefaults standardUserDefaults] setObject:tempDict forKey:LZUserDailyIntakeKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
            //[self displayTakenFoodResult];
            [[NSNotificationCenter defaultCenter]postNotificationName:Notification_TakenFoodDeletedKey object:nil userInfo:nil];
            [self.takenFoodIdsArray removeObjectAtIndex:index];
            NSArray *array = [[NSArray alloc]initWithObjects:indexPathToDelete, nil];
            if ([self.takenFoodIdsArray count]== 0)
            {
                if(sender.direction == UISwipeGestureRecognizerDirectionLeft)
                [self.listView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationLeft];
                else
                [self.listView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationRight];
                
            }
            else
            {
                [self.listView beginUpdates];
                if(sender.direction == UISwipeGestureRecognizerDirectionLeft)
                [self.listView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationLeft];
                else
                    [self.listView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationRight];
                [self.listView endUpdates];
            }
            [self refreshFoodNureitentProcessForAll:NO];
        }
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
        if(takenFoodIdsArray ==nil || [takenFoodIdsArray count]==0)
        {
            return;
        }
        else
        {
            NSString *foodId  = [takenFoodIdsArray objectAtIndex:indexPath.row];
            
            NSDictionary *aFood = [takenFoodDict objectForKey:foodId];//[takenFoodIdsArray objectAtIndex:indexPath.row];
            NSString *ndb_No = [aFood objectForKey:@"NDB_No"];
            NSArray *nutrientSupplyArr = [[takenFoodNutrientInfoDict objectForKey:Key_foodSupplyNutrientInfoAryDict]objectForKey:ndb_No];
            NSArray *nutrientStandardArr = [[takenFoodNutrientInfoDict objectForKey:Key_foodStandardNutrientInfoAryDict]objectForKey:ndb_No];
            NSString *foodName = [aFood objectForKey:@"Name"];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            LZFoodDetailController * foodDetailController = [storyboard instantiateViewControllerWithIdentifier:@"LZFoodDetailController"];
            foodDetailController.nutrientSupplyArray = nutrientSupplyArr;
            foodDetailController.nutrientStandardArray = nutrientStandardArr;
            foodDetailController.foodName = foodName;
            foodDetailController.isForRecomendFood = NO;
            //UINavigationController *initialController = (UINavigationController*)[UIApplication
                                                                                  //sharedApplication].keyWindow.rootViewController;
            [self.navigationController pushViewController:foodDetailController animated:YES];
        }
    }
    else
    {
        NSDictionary *takenFoodAmountDict = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserDailyIntakeKey];
        
//        NSNumber *planPerson = [[NSUserDefaults standardUserDefaults] objectForKey:LZPlanPersonsKey];
//        NSNumber *planDays = [[NSUserDefaults standardUserDefaults]objectForKey:LZPlanDaysKey];
        NSNumber *planPerson = [NSNumber numberWithInt:1];
        NSNumber *planDays = [NSNumber numberWithInt:1];
//        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                                planPerson,@"personCount",
//                                planDays,@"dayCount", nil];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSNumber *userSex = [userDefaults objectForKey:LZUserSexKey];
        NSNumber *userAge = [userDefaults objectForKey:LZUserAgeKey];
        NSNumber *userHeight = [userDefaults objectForKey:LZUserHeightKey];
        NSNumber *userWeight = [userDefaults objectForKey:LZUserWeightKey];
        NSNumber *userActivityLevel = [userDefaults objectForKey:LZUserActivityLevelKey];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  userSex,ParamKey_sex, userAge,ParamKey_age,
                                  userWeight,ParamKey_weight, userHeight,ParamKey_height,
                                  userActivityLevel,ParamKey_activityLevel, nil];
        
        BOOL needConsiderNutrientLoss = Config_needConsiderNutrientLoss;
        NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:needConsiderNutrientLoss],LZSettingKey_needConsiderNutrientLoss, nil];
        
        LZRecommendFood *rf = [[LZRecommendFood alloc]init];
        
        //    NSMutableDictionary *retDict = [rf takenFoodSupplyNutrients_AbstractPerson:params withDecidedFoods:takenFoodAmountDict];
        NSMutableDictionary *retDict = [rf takenFoodSupplyNutrients_withUserInfo:userInfo andDecidedFoods:takenFoodAmountDict andOptions:options];

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
        // UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:addByNutrientController];
        //[self presentModalViewController:navController animated:YES];
        [self.navigationController pushViewController:addByNutrientController animated:YES];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
//    if (indexPath.section ==1)
//    {
//        return NO;
//    }
//    else 
//    {
//        if(indexPath.row == 0)
//        {
//            return NO;
//        }
//        return !(takenFoodArray ==nil || [takenFoodArray count]==0);
//    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary *takenFoodAmountDict = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserDailyIntakeKey];
//    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]initWithDictionary:takenFoodAmountDict];
//    NSDictionary *aFood = [takenFoodIdsArray objectAtIndex:indexPath.row-1];
//    NSString *ndb_No = [aFood objectForKey:@"NDB_No"];
//    [tempDict removeObjectForKey:ndb_No];
//    [[NSUserDefaults standardUserDefaults] setObject:tempDict forKey:LZUserDailyIntakeKey];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    [self refreshFoodNureitentProcessForAll:YES];
//    [[NSNotificationCenter defaultCenter]postNotificationName:Notification_TakenFoodDeletedKey object:nil userInfo:nil];    
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
#pragma mark- Recommend Function
- (IBAction)recommendAction:(id)sender {
    //弹出选择元素框
    float duration = 0.5;
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    NSArray *preferNutrient = [[NSUserDefaults standardUserDefaults]objectForKey:KeyUserRecommendPreferNutrientArray];
    NSString *title = @"哪些营养素是您重点关注且是不能缺少的，请选择：";
    LZRecommendFilterView *viewtoAnimate = [[LZRecommendFilterView alloc]initWithFrame:CGRectMake(0, 20, screenSize.width, screenSize.height-20) backColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5] filterInfo:preferNutrient tipsStr:title delegate:self];
    
    LZAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate.window addSubview:viewtoAnimate];
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = duration;
    scale.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:.5f],
                    [NSNumber numberWithFloat:1.2f],
                    [NSNumber numberWithFloat:.85f],
                    [NSNumber numberWithFloat:1.f],
                    nil];
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithArray:[NSArray arrayWithObjects:scale, nil]];
    group.delegate = nil;
    group.duration = duration;
    group.removedOnCompletion = YES;
    
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [viewtoAnimate.backView.layer addAnimation:group forKey:@"kFTAnimationPopIn"];
    
}
- (void)recommendOnePlan:(NSArray *)preferNutrient
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *takenFoodAmountDict = [userDefaults objectForKey:LZUserDailyIntakeKey];
    
    NSNumber *userSex = [userDefaults objectForKey:LZUserSexKey];
    NSNumber *userAge = [userDefaults objectForKey:LZUserAgeKey];
    NSNumber *userHeight = [userDefaults objectForKey:LZUserHeightKey];
    NSNumber *userWeight = [userDefaults objectForKey:LZUserWeightKey];
    NSNumber *userActivityLevel = [userDefaults objectForKey:LZUserActivityLevelKey];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              userSex,ParamKey_sex, userAge,ParamKey_age,
                              userWeight,ParamKey_weight, userHeight,ParamKey_height,
                              userActivityLevel,ParamKey_activityLevel, nil];
    BOOL needConsiderNutrientLoss = FALSE;
    //    BOOL needLimitNutrients = FALSE;
    BOOL needUseLowLimitAsUnit = TRUE;
    BOOL needUseNormalLimitWhenSmallIncrementLogic = TRUE;
    int randSeed = 0; //0; //0;
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:needConsiderNutrientLoss],LZSettingKey_needConsiderNutrientLoss,
                                    //                             [NSNumber numberWithBool:needLimitNutrients],LZSettingKey_needLimitNutrients,
                                    [NSNumber numberWithBool:needUseLowLimitAsUnit],LZSettingKey_needUseLowLimitAsUnit,
                                    [NSNumber numberWithBool:needUseNormalLimitWhenSmallIncrementLogic],LZSettingKey_needUseNormalLimitWhenSmallIncrementLogic,
                                    [NSNumber numberWithInt:randSeed],LZSettingKey_randSeed,
                                    nil];
    NSArray *paramArray = [LZUtility convertPreferNutrientArrayToParamArray:preferNutrient];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:paramArray,Key_givenNutrients,nil];

    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFoodBySmallIncrementWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andOptions:options andParams:params];
    NSDictionary *recommendFoodAmountDict = [retDict objectForKey:Key_recommendFoodAmountDict];
    //    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
    //                            userInfo,@"userInfo",
    //                            takenFoodAmountDict,@"givenFoodsAmount1",
    //                            recommendFoodAmountDict,@"givenFoodsAmount2",
    //                            nil];
    NSMutableDictionary *newIntakeDict = [[NSMutableDictionary alloc]init];
    [newIntakeDict addEntriesFromDictionary:takenFoodAmountDict];
    [newIntakeDict addEntriesFromDictionary:recommendFoodAmountDict];
    //NSDictionary * formatResult = [rf calculateGiveFoodsSupplyNutrientAndFormatForUI:params];
    [userDefaults setObject:newIntakeDict forKey:LZUserDailyIntakeKey];
    [userDefaults setObject:preferNutrient forKey:KeyUserRecommendPreferNutrientArray];
    [userDefaults synchronize];
    [HUD hide:YES];
    self.listView.hidden = NO;
    [self refreshFoodNureitentProcessForAll:YES];
    [self.listView setContentOffset:CGPointMake(0, 0) animated:NO];
    [[LZReviewAppManager SharedInstance]popReviewOurAppAlertAccordingRules];
    
}

#pragma mark- LZRecommendFilterView Deleagte
- (void)filterViewCanceled:(LZRecommendFilterView *)filterView
{
    [filterView.layer removeAllAnimations];
    float duration = 0.3;
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = duration;
    scale.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.f],
                    [NSNumber numberWithFloat:1.2f],
                    [NSNumber numberWithFloat:.75f],
                    nil];
    
    CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOut.duration = duration; //* .4f;
    fadeOut.fromValue = [NSNumber numberWithFloat:1.f];
    fadeOut.toValue = [NSNumber numberWithFloat:0.f];
    fadeOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //fadeOut.beginTime = duration * .6f;
    //fadeOut.fillMode = kCAFillModeForwards;
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithArray:[NSArray arrayWithObjects:scale, fadeOut, nil]];
    group.delegate = self;
    group.duration = duration;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [group setValue:filterView.backView forKey:@"kViewToRemove"];
    [filterView.backView.layer addAnimation:group forKey:@"kFTAnimationPopOut"];

}
- (void)filterViewSubmitted:(LZRecommendFilterView *)filterView forFilterInfo:(NSArray *)filterInfo
{
    [filterView.layer removeAllAnimations];
    float duration = 0.3;
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = duration;
    scale.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.f],
                    [NSNumber numberWithFloat:1.2f],
                    [NSNumber numberWithFloat:.75f],
                    nil];
    
    CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOut.duration = duration; //* .4f;
    fadeOut.fromValue = [NSNumber numberWithFloat:1.f];
    fadeOut.toValue = [NSNumber numberWithFloat:0.f];
    fadeOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //fadeOut.beginTime = duration * .6f;
    //fadeOut.fillMode = kCAFillModeForwards;
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithArray:[NSArray arrayWithObjects:scale, fadeOut, nil]];
    group.delegate = self;
    group.duration = duration;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [group setValue:filterView.backView forKey:@"kViewToRemove"];
    [filterView.backView.layer addAnimation:group forKey:@"kFTAnimationPopOut"];
    HUD.hidden = NO;
    [HUD show:YES];
    //self.listView.hidden = YES;
    
    HUD.labelText = @"智能推荐中...";
    
    [self performSelector:@selector(recommendOnePlan:) withObject:filterInfo afterDelay:0.f];
    
}
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    if(flag)
    {
        LZRecommendFilterView *view = (LZRecommendFilterView*)((UIView*)[theAnimation valueForKey:@"kViewToRemove"]).superview;
        if(view)
        {
            [view removeFromSuperview];
        }
    }
}
#pragma mark- Add Food Function
- (void)addFood
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    LZAddFoodViewController *addFoodViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZAddFoodViewController"];
    //UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:addFoodViewController];
    [self.navigationController pushViewController:addFoodViewController animated:YES];
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
    
//    NSNumber *planPerson = [[NSUserDefaults standardUserDefaults] objectForKey:LZPlanPersonsKey];
//    NSNumber *planDays = [[NSUserDefaults standardUserDefaults]objectForKey:LZPlanDaysKey];
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                            planPerson,@"personCount",
//                            planDays,@"dayCount", nil];
    NSNumber *planPerson = [NSNumber numberWithInt:1];
    NSNumber *planDays = [NSNumber numberWithInt:1];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *userSex = [userDefaults objectForKey:LZUserSexKey];
    NSNumber *userAge = [userDefaults objectForKey:LZUserAgeKey];
    NSNumber *userHeight = [userDefaults objectForKey:LZUserHeightKey];
    NSNumber *userWeight = [userDefaults objectForKey:LZUserWeightKey];
    NSNumber *userActivityLevel = [userDefaults objectForKey:LZUserActivityLevelKey];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              userSex,ParamKey_sex, userAge,ParamKey_age,
                              userWeight,ParamKey_weight, userHeight,ParamKey_height,
                              userActivityLevel,ParamKey_activityLevel, nil];
    
    BOOL needConsiderNutrientLoss = Config_needConsiderNutrientLoss;
    NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:needConsiderNutrientLoss],LZSettingKey_needConsiderNutrientLoss, nil];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    
//    NSMutableDictionary *retDict = [rf takenFoodSupplyNutrients_AbstractPerson:params withDecidedFoods:takenFoodAmountDict];
    NSMutableDictionary *retDict = [rf takenFoodSupplyNutrients_withUserInfo:userInfo andDecidedFoods:takenFoodAmountDict andOptions:options];
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
    //UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:addByNutrientController];
    [self.navigationController pushViewController:addByNutrientController animated:YES];
    //[self presentModalViewController:navController animated:YES];

}
- (IBAction)addFoodByNutrient:(UIButton *)sender {
    int tag = sender.tag;
    [self performSelector:@selector(addFoodForTag:) withObject:[NSNumber numberWithInt:tag] afterDelay:0.f];
        

}
//- (IBAction)clearFoodAction:(id)sender {
//    NSDictionary *nutrient = [nutrientInfoArray objectAtIndex:1];
//    [nutrientInfoArray removeObjectAtIndex:1];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
//    
//    NSArray *deleteArray = [NSArray arrayWithObject:indexPath];
//    [self.listView beginUpdates];
//    [self.listView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationLeft];
//    [self.listView endUpdates];
//    
//    
//    [nutrientInfoArray insertObject:nutrient atIndex:0];
//    NSIndexPath *indexPathAdd = [NSIndexPath indexPathForRow:0 inSection:1];
//    NSArray *addArray = [NSArray arrayWithObject:indexPathAdd];
//    [self.listView beginUpdates];
//    [self.listView insertRowsAtIndexPaths:addArray withRowAnimation:UITableViewRowAnimationRight];
//    [self.listView endUpdates];
//}


//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"保存食物" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//    UITextField *tf = [alert textFieldAtIndex:0];
//    tf.keyboardType = UIKeyboardTypeNumberPad;
//    [alert show];
    
//    NSDictionary *dailyIntake = [[NSDictionary alloc]init];
//    [[NSUserDefaults standardUserDefaults] setObject:dailyIntake forKey:LZUserDailyIntakeKey];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    [self displayTakenFoodResult];
//    [[NSNotificationCenter defaultCenter]postNotificationName:Notification_TakenFoodDeletedKey object:nil userInfo:nil];


#pragma mark- Share Content Function
- (IBAction)shareButtonTapped:(id)sender
{
    UIActionSheet *shareSheet = [[UIActionSheet alloc]initWithTitle:@"分享到" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博",@"微信好友",@"微信朋友圈", nil];
    [shareSheet showInView:self.view];
}
-(NSString *)getShareContentsForShareType:(ShareType)type
{
    if(type == ShareTypeSinaWeibo)
    {
        if ([takenFoodIdsArray count]!= 0)
        {
            NSString *contents = @"@买菜助手(http://t.cn/zHuwJxz )为我精心推荐:";
            for (NSString *foodId in takenFoodIdsArray)
            {
                NSDictionary *aFood = [takenFoodDict objectForKey:foodId];
                NSString *name = [aFood objectForKey:@"Name"];
                NSNumber *weight = [aFood objectForKey:@"Amount"];
                contents = [contents stringByAppendingFormat:@"\n%@ %dg",name,[weight intValue]];
            }
            return contents;
        }
        else
        {
            NSString *contents = @"我用 @买菜助手(http://t.cn/zH1gxw5 ) 挑选出了一组含全面丰富营养的食物搭配, 羡慕吧? 快来试试吧!";
            return contents;
        }
    }
    else //微信好友 或者微信朋友圈
    {
        if ([takenFoodIdsArray count]!= 0)
        {
            NSString *contents = @"买菜助手(http://t.cn/zHuwJxz )为我推荐了:";
            for (NSString *foodId in takenFoodIdsArray)
            {
                NSDictionary *aFood = [takenFoodDict objectForKey:foodId];
                NSString *name = [aFood objectForKey:@"Name"];
                NSNumber *weight = [aFood objectForKey:@"Amount"];
                contents = [contents stringByAppendingFormat:@"\n%@ %dg",name,[weight intValue]];
            }
            contents = [contents stringByAppendingString:@"\n你也来试试吧!"];//:@"\n%@ %dg",name,[weight intValue]];
            return contents;
        }
        else
        {
            NSString *contents = @"我用 买菜助手(http://t.cn/zH1gxw5 ) 挑选出了一组含全面丰富营养的食物搭配, 羡慕吧? 快来试试吧!";
            return contents;
        }
        
    }
}
- (void)shareRecommendContentForType:(ShareType)type
{
    if(type == ShareTypeWeixiSession || type == ShareTypeWeixiTimeline)
    {
        if ([WXApi isWXAppInstalled])
        {
            //isWXAppInstalled
            //getWXAppInstallUrl
            NSString *contents = [self getShareContentsForShareType:type];
            id<ISSContent> content = [ShareSDK content:contents
                                        defaultContent:nil
                                                 image:nil
                                                 title:nil
                                                   url:nil
                                           description:nil
                                             mediaType:SSPublishContentMediaTypeText];
            
            id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                                 allowCallback:YES
                                                                 authViewStyle:SSAuthViewStyleFullScreenPopup
                                                                  viewDelegate:nil
                                                       authManagerViewDelegate:nil];
            [ShareSDK shareContent:content
                              type:type
                       authOptions:authOptions
                     statusBarTips:YES
                            result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(@"success");
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    if ([error errorCode] == -22003)
                                    {
                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                            message:[error errorDescription]
                                                                                           delegate:nil
                                                                                  cancelButtonTitle:@"知道了"
                                                                                  otherButtonTitles:nil];
                                        [alertView show];
                                        
                                    }
                                }
                            }];
        }
        else
        {
            [self popWeiChatInstallAlert];
        }
    }
    else if (type == ShareTypeSinaWeibo)
    {
        if ([ShareSDK hasAuthorizedWithType:type])
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            LZShareViewController *shareViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZShareViewController"];
            NSString *contents = [self getShareContentsForShareType:type ];
            shareViewController.preInsertText = contents;
            [self presentModalViewController:shareViewController animated:YES];
        }
        else
        {
            id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                                 allowCallback:YES
                                                                 authViewStyle:SSAuthViewStyleFullScreenPopup
                                                                  viewDelegate:nil
                                                       authManagerViewDelegate:nil];
            [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [ShareSDK userFieldWithType:SSUserFieldTypeName valeu:@"买菜助手"],
                                            SHARE_TYPE_NUMBER(type),
                                            //[ShareSDK userFieldWithType:SSUserFieldTypeName valeu:@"ShareSDK"],
                                            //SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                            nil]];
            [ShareSDK authWithType:type options:authOptions result:^(SSAuthState state, id<ICMErrorInfo> error) {
                if (state == SSAuthStateSuccess)
                {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                    LZShareViewController *shareViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZShareViewController"];
                    NSString * contents = [self getShareContentsForShareType:type];
                    shareViewController.preInsertText = contents;
                    [self presentModalViewController:shareViewController animated:YES];
                }
                //NSLog(@"ssauthState %d",state);
            }];
            
        }
        
    }
    
}
- (void)popWeiChatInstallAlert
{
    UIAlertView *insallWeichatAlert = [[UIAlertView alloc]initWithTitle:nil message:@"还没有安装微信 立即下载?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [insallWeichatAlert show];
}
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        return;
    }
    else
    {
        NSString *weichatURL =[WXApi getWXAppInstallUrl];
        NSURL *ourAppUrl = [ [ NSURL alloc ] initWithString: weichatURL ];
        [[UIApplication sharedApplication] openURL:ourAppUrl];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == actionSheet.cancelButtonIndex)
    {
        return;
    }
    else if (buttonIndex == 0)//weibo
    {
        [self shareRecommendContentForType:ShareTypeSinaWeibo];
    }
    else if (buttonIndex == 1)//微信好友
    {
        [self shareRecommendContentForType:ShareTypeWeixiSession];
    }
    else//朋友圈
    {
        [self shareRecommendContentForType:ShareTypeWeixiTimeline];
    }
    
}
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
    HUD.hidden = YES;
}

@end
