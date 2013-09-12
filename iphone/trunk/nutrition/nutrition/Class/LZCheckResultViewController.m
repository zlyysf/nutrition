//
//  LZCheckResultViewController.m
//  nutrition
//
//  Created by liu miao on 9/3/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZCheckResultViewController.h"
#import "LZEmptyClassCell.h"
#import "LZUtility.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "LZNutrientionManager.h"
#import "LZConstants.h"
#import "LZRecommendFood.h"
#import "LZReviewAppManager.h"
#import "LZRecommendFoodCell.h"
#import "LZCheckNutritionCell.h"
#import "MobClick.h"
#import "GADMasterViewController.h"
#import "LZUserDietListViewController.h"
#import "LZMainPageViewController.h"
@interface LZCheckResultViewController ()<MBProgressHUDDelegate,UIAlertViewDelegate>
{
    MBProgressHUD *HUD;
}
@property (assign,nonatomic)float diseaseCellHeight;
@property (assign,nonatomic)float nutritionCellHeight;
@property (assign,nonatomic)BOOL isFirstLoad;
@end

@implementation LZCheckResultViewController
@synthesize userPreferArray,userSelectedNames,diseaseCellHeight,nutritionCellHeight,isFirstLoad,recommendFoodDictForDisplay,takenFoodIdsArray,takenFoodDict,nutrientInfoArray,takenFoodNutrientInfoDict,allFoodUnitDict;
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
    if (ViewControllerUseBackImage) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
        UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
    }
  
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.view addSubview:HUD];
    HUD.hidden = YES;
    HUD.delegate = self;
    self.title = @"诊断结果";
    int totalFloor = [userPreferArray count]/4+ (([userPreferArray count]%4 == 0)?0:1);
    self.nutritionCellHeight = totalFloor *30 + 20+ (totalFloor-1)*8;
    CGSize labelSize = [userSelectedNames sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(300, 9999) lineBreakMode:UILineBreakModeWordWrap];
    self.diseaseCellHeight = labelSize.height + 20;
    takenFoodIdsArray = [[NSMutableArray alloc]init];
    takenFoodDict = [[NSMutableDictionary alloc]init];
    nutrientInfoArray = [[NSMutableArray alloc]init];
    takenFoodNutrientInfoDict = [[NSMutableDictionary alloc]init];
    recommendFoodDictForDisplay = [[NSMutableDictionary alloc]init];
    allFoodUnitDict = [[NSMutableDictionary alloc]init];
    isFirstLoad = YES;
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0,0,
                                                                 CGSizeFromGADAdSize(kGADAdSizeBanner).width,
                                                                 CGSizeFromGADAdSize(kGADAdSizeBanner).height)];
    self.listView.tableFooterView = footerView;

	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:UmengPathZhenDuanJieGuo];
    GADMasterViewController *shared = [GADMasterViewController singleton];
    UIView *footerView = self.listView.tableFooterView;
    [shared resetAdView:self andListView:footerView];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:UmengPathZhenDuanJieGuo];
}
-(void)viewDidAppear:(BOOL)animated
{
    if (isFirstLoad)
    {
        isFirstLoad = NO;
        HUD.hidden = NO;
        [HUD show:YES];
        self.listView.hidden = YES;

        HUD.labelText = @"智能推荐中...";

        [self performSelector:@selector(recommendOnePlan) withObject:nil afterDelay:0.f];
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
    {
        return 1;
    }
    else if (section == 1)
    {
        return 1;
    }
    else if (section == 2)
    {
        return [takenFoodIdsArray count];
    }
    else
    {
       return [nutrientInfoArray count];
    }
                    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        LZEmptyClassCell * cell =(LZEmptyClassCell*)[tableView dequeueReusableCellWithIdentifier:@"UserDiseaseCell"];
        if (cell.hasLoaded)
        {
            return cell;
        }
        else
        {
            UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, self.diseaseCellHeight -20)];
            [contentLabel setTextColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8]];
            [contentLabel setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:contentLabel];
            contentLabel.numberOfLines = 0;
            [contentLabel setFont:[UIFont systemFontOfSize:15]];
            contentLabel.text = userSelectedNames;
            cell.hasLoaded = YES;
            return cell;
        }
    }
    else if (indexPath.section == 1)
    {
        LZEmptyClassCell * cell =(LZEmptyClassCell*)[tableView dequeueReusableCellWithIdentifier:@"ResultNutritionCell"];
        if (cell.hasLoaded)
        {
            return cell;
        }
        else
        {
            int floor = 1;
            int countPerRow = 4;
            float startX;
            LZDataAccess *da =[LZDataAccess singleton];
            for (int i = 0; i< [self.userPreferArray count];i++)
            {
                if (i>=floor *countPerRow)
                {
                    floor+=1;
                }
                startX = 10+(i-(floor-1)*countPerRow)*77;
                UIButton *nutrientButton = [[UIButton alloc]initWithFrame:CGRectMake(startX, 10+(floor-1)*38, 69, 30)];
                [cell.contentView addSubview:nutrientButton];
                nutrientButton.tag = 101+i;
                [nutrientButton addTarget:self action:@selector(nutrientButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                NSString *key = [userPreferArray objectAtIndex:i];
                NSDictionary *dict = [da getNutrientInfo:key];
                NSString *name = [dict objectForKey:@"NutrientCnCaption"];
                [nutrientButton setTitle:name forState:UIControlStateNormal];
                [nutrientButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                UIColor *fillColor = [LZUtility getNutrientColorForNutrientId:key];
                [nutrientButton setBackgroundColor:fillColor];
                [nutrientButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [nutrientButton.layer setCornerRadius:3.0f];
                [nutrientButton.layer setMasksToBounds:YES];
            }
            cell.hasLoaded = YES;
            return cell;
        }

    }
    else if (indexPath.section == 2)
    {
        LZRecommendFoodCell *cell = (LZRecommendFoodCell *)[tableView dequeueReusableCellWithIdentifier:@"LZRecommendFoodCell"];
        NSString *foodId = [takenFoodIdsArray objectAtIndex:indexPath.row];
        NSDictionary *aFood = [takenFoodDict objectForKey:foodId];
        //NSLog(@"picture path %@",aFood);
        if([self.recommendFoodDictForDisplay objectForKey:foodId])
        {
            cell.recommendSignImageView.hidden = NO;
        }
        else
        {
            cell.recommendSignImageView.hidden = YES;
        }
        NSString *picturePath;
        NSString *picPath = [aFood objectForKey:@"PicturePath"];
        if (picPath == nil || [picPath isEqualToString:@""])
        {
            picturePath = [[NSBundle mainBundle]pathForResource:@"defaulFoodPic" ofType:@"png"];
        }
        else
        {
            NSString * picFolderPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"foodDealed"];
            picturePath = [picFolderPath stringByAppendingPathComponent:picPath];
        }
        UIImage *foodImage = [UIImage imageWithContentsOfFile:picturePath];
        [cell.foodImageView setImage:foodImage];
        cell.cellFoodId = foodId;
        
        NSNumber *weight = [aFood objectForKey:@"Amount"];
        cell.foodUnitLabel.text = [NSString stringWithFormat:@"%dg",[weight intValue]];
        NSDictionary *foodAtr = [allFoodUnitDict objectForKey:foodId];
        NSString *singleUnitName = [foodAtr objectForKey:COLUMN_NAME_SingleItemUnitName];
        NSString *foodTotalUnit = @"";
        if ([singleUnitName length]==0)
        {
            foodTotalUnit = @"";
        }
        else
        {
            NSNumber *singleUnitWeight = [foodAtr objectForKey:COLUMN_NAME_SingleItemUnitWeight];
            int maxCount = (int)(ceilf(([weight floatValue]*2)/[singleUnitWeight floatValue]));
            //int unitCount = (int)((float)([weight floatValue]/[singleUnitWeight floatValue])+0.5);
            if (maxCount <= 0)
            {
                foodTotalUnit = @"";
            }
            else
            {
                if (maxCount %2 == 0)
                {
                    foodTotalUnit = [NSString stringWithFormat:@"(%d%@)",(int)(maxCount*0.5f),singleUnitName];
                }
                else
                {
                    foodTotalUnit = [NSString stringWithFormat:@"(%.1f%@)",maxCount*0.5f,singleUnitName];
                }

            }
        }
        NSString *foodName = [aFood objectForKey:@"Name"];
        cell.foodNameLabel.text = [NSString stringWithFormat:@"%@ %@",foodName,foodTotalUnit];
        return cell;
    }
    else
    {
        LZCheckNutritionCell *cell = (LZCheckNutritionCell *)[tableView dequeueReusableCellWithIdentifier:@"LZCheckNutritionCell"];
        NSDictionary *nutrient = [nutrientInfoArray objectAtIndex:indexPath.row];
        //[cell.nutritionNameButton setTitle:[nutrient objectForKey:@"Name"] forState:UIControlStateNormal];
        NSString *nutrientId = [nutrient objectForKey:@"NutrientID"];
        
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
        //CGRectMake(2,2,196,14)
        [cell.nutritionProgressView drawProgressForRect:CGRectMake(2,2,216,14) backgroundColor:[UIColor whiteColor] fillColor:fillColor progress:progress withBackRadius:7.f fillRadius:radius];
        [cell adjustLabelAccordingToProgress:progress forLabelWidth:216];
        cell.supplyPercentlabel.text = [NSString stringWithFormat:@"%d%%",(int)(floorf([percent floatValue] *100))];
        NSSet *selectNutrient = [NSSet setWithArray:self.userPreferArray];

        cell.nameLabel.text =[nutrient objectForKey:@"Name"];
        if ([selectNutrient containsObject:nutrientId])
        {
            [cell.nameLabel setFont:[UIFont boldSystemFontOfSize:16]];
            [cell.nameLabel setTextColor:[UIColor blackColor]];
        }
        else
        {
            [cell.nameLabel setFont:[UIFont systemFontOfSize:14]];
            [cell.nameLabel setTextColor:[UIColor blackColor]];
        }
        //cell.addFoodButton.tag = indexPath.row;
        return cell;

    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return self.diseaseCellHeight;
    }
    else if(indexPath.section == 1)
    {
        return self.nutritionCellHeight;
    }
    else if (indexPath.section ==2)
    {
        return 60;
    }
    else
    {
        return 42;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == 1)
    {
        return 0;
    }
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == 1)
    {
        return nil;
    }
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section ==2)
    {
        return 72;
    }
    return 27;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 72)];
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
    
    if (section ==0)
    {
        sectionTitleLabel.text =  @"您所选的症状";
    }
    else if (section == 1)
    {
        sectionTitleLabel.text = @"您缺少的营养元素";
    }
    else if (section == 2)
    {
        sectionTitleLabel.text =  @"您可以考虑的食物";
        UIImage *button30 = [[UIImage imageNamed:@"button_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        UIButton *recommendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [recommendButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [recommendButton.titleLabel setShadowOffset:CGSizeMake(0, -1)];
        [recommendButton setFrame:CGRectMake(10, 37, 145, 30)];
        [recommendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [recommendButton setTitle:@"换一组" forState:UIControlStateNormal];
        [recommendButton addTarget:self action:@selector(changeRecommend) forControlEvents:UIControlEventTouchUpInside];
        [recommendButton setBackgroundImage:button30 forState:UIControlStateNormal];
        
        UIButton *saveDietButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveDietButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [saveDietButton.titleLabel setShadowOffset:CGSizeMake(0, -1)];
        [saveDietButton setFrame:CGRectMake(165, 37, 145, 30)];
        [saveDietButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveDietButton setTitle:@"保  存" forState:UIControlStateNormal];
        [saveDietButton addTarget:self action:@selector(saveToDiet) forControlEvents:UIControlEventTouchUpInside];
        [saveDietButton setBackgroundImage:button30 forState:UIControlStateNormal];
        [sectionView addSubview:recommendButton];
        [sectionView addSubview:saveDietButton];
        if (ViewControllerUseBackImage) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
            UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
            [sectionView setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];

        }
    }
    else
    {
        sectionTitleLabel.text =  @"以上食物一天的营养比例";
    }
    
    return sectionView;

}
-(void)saveToDiet
{
    if([self.takenFoodIdsArray count] == 0)
    {
        if([self.takenFoodIdsArray count] == 0)
        {
            UIAlertView *foodEmptyAlert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"食物列表还是空的呢!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [foodEmptyAlert show];
            return;
        }
    }
    else
    {
        //新建一个表单，用insert
        NSDate *now = [NSDate date];
        NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans"]];
        [formatter setDateFormat:@"MM月dd号"];
        NSString* time = [formatter stringFromDate:now];
        NSString *text = [NSString stringWithFormat:@"%@的饮食计划",time];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"保存到膳食清单" message:@"给你的食物清单加个名称吧!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.tag = 102;
        UITextField *tf = [alert textFieldAtIndex:0];
        tf.clearButtonMode = UITextFieldViewModeAlways;
        tf.text = text;
        [alert show];
        
    }

}
-(void)changeRecommend
{
    HUD.hidden = NO;
    [HUD show:YES];
    
    HUD.labelText = @"智能推荐中...";
    
    [self performSelector:@selector(recommendOnePlan) withObject:nil afterDelay:0.f];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(void)nutrientButtonTapped:(UIButton *)nutrientButton
{
    int tag = nutrientButton.tag-101;
    NSString *key = [self.userPreferArray objectAtIndex:tag];
    [[LZNutrientionManager SharedInstance]showNutrientInfo:key];
}
- (void)recommendOnePlan
{
    [MobClick event:UmengEventHuanYiZu];
    NSArray *preferNutrient = [[NSUserDefaults standardUserDefaults]objectForKey:KeyUserRecommendPreferNutrientArray];
    NSSet *selectNutrient = [NSSet setWithArray:self.userPreferArray];
    NSMutableArray *newPreferArray = [[NSMutableArray alloc]init];
    for (NSDictionary *aNutrient in preferNutrient)
    {
        NSString *nId = [[aNutrient allKeys]objectAtIndex:0];
        if ([selectNutrient containsObject:nId])
        {
            NSDictionary *newDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],nId, nil];
            [newPreferArray addObject:newDict];
        }
        else
        {
            NSDictionary *newDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],nId, nil];
            [newPreferArray addObject:newDict];
        }
    }
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
    
    
    BOOL needConsiderNutrientLoss = FALSE;
    BOOL needUseDefinedIncrementUnit = TRUE;
    BOOL needUseNormalLimitWhenSmallIncrementLogic = TRUE;
    BOOL needUseFirstRecommendWhenSmallIncrementLogic = TRUE;//FALSE;
    BOOL needSpecialForFirstBatchFoods = FALSE; //TRUE;
    BOOL needFirstSpecialForShucaiShuiguo = TRUE;
    BOOL alreadyChoosedFoodHavePriority = TRUE;
    BOOL needPriorityFoodToSpecialNutrient = TRUE;
    int randSeed = 0; //0;
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:needConsiderNutrientLoss],LZSettingKey_needConsiderNutrientLoss,
                                    //                    [NSNumber numberWithBool:needLimitNutrients],LZSettingKey_needLimitNutrients,
                                    [NSNumber numberWithBool:needUseDefinedIncrementUnit],LZSettingKey_needUseDefinedIncrementUnit,
                                    [NSNumber numberWithBool:needUseNormalLimitWhenSmallIncrementLogic],LZSettingKey_needUseNormalLimitWhenSmallIncrementLogic,
                                    [NSNumber numberWithBool:needUseFirstRecommendWhenSmallIncrementLogic],LZSettingKey_needUseFirstRecommendWhenSmallIncrementLogic,
                                    [NSNumber numberWithBool:needSpecialForFirstBatchFoods],LZSettingKey_needSpecialForFirstBatchFoods,
                                    [NSNumber numberWithBool:needFirstSpecialForShucaiShuiguo],LZSettingKey_needFirstSpecialForShucaiShuiguo,
                                    [NSNumber numberWithBool:alreadyChoosedFoodHavePriority],LZSettingKey_alreadyChoosedFoodHavePriority,
                                    [NSNumber numberWithBool:needPriorityFoodToSpecialNutrient],LZSettingKey_needPriorityFoodToSpecialNutrient,
                                    [NSNumber numberWithInt:randSeed],LZSettingKey_randSeed,
                                    nil];
    if (KeyIsEnvironmentDebug){
            NSDictionary *flagsDict = [[NSUserDefaults standardUserDefaults]objectForKey:KeyDebugSettingsDict];
            if (flagsDict.count > 0){
                    //            options = [NSMutableDictionary dictionaryWithDictionary:flagsDict];
                    [options setValuesForKeysWithDictionary:flagsDict];
                    assert([options objectForKey:LZSettingKey_randSeed]!=nil);
                }
        }
        
    NSArray *paramArray = [LZUtility convertPreferNutrientArrayToParamArray:newPreferArray];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:paramArray,Key_givenNutrients,nil];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFoodBySmallIncrementWithPreIntake:nil andUserInfo:userInfo andOptions:options andParams:params];
    NSDictionary *recommendFoodAmountDict = [retDict objectForKey:Key_recommendFoodAmountDict];
    [recommendFoodDictForDisplay removeAllObjects];
    [recommendFoodDictForDisplay addEntriesFromDictionary:recommendFoodAmountDict];
    [HUD hide:YES];
    self.listView.hidden = NO;
    [self refreshFoodNureitentProcessForAll:NO];
//    [self.listView setContentOffset:CGPointMake(0, 0) animated:NO];
    [[LZReviewAppManager SharedInstance]popReviewOurAppAlertAccordingRules];
    
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
                            self.recommendFoodDictForDisplay,@"givenFoodsAmount2",
                            nil];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retFmtDict = [rf calculateGiveFoodsSupplyNutrientAndFormatForUI:params];
//    NSLog(@" allkeys  %@",[retFmtDict allKeys]);
//    NSLog(@"calculateGiveFoodsSupplyNutrientAndFormatForUI %@",retFmtDict);
    
    NSArray *takenArray1 = [retFmtDict objectForKey:Key_orderedGivenFoodIds1];
    NSArray *takenArray2 = [retFmtDict objectForKey:Key_orderedGivenFoodIds2];
    [takenFoodIdsArray removeAllObjects];
    if (takenArray1 != nil && [takenArray1 count]!=0) {
        
        [takenFoodIdsArray addObjectsFromArray:takenArray1];
    }
    if (takenArray2 != nil && [takenArray2 count]!=0) {
        
        [takenFoodIdsArray addObjectsFromArray:takenArray2];
    }
    NSDictionary *foodUnitDict = [retFmtDict objectForKey:Key_givenFoodAttrDict2Level];
    [allFoodUnitDict removeAllObjects];
    if (foodUnitDict != nil )
    {
        
        [allFoodUnitDict addEntriesFromDictionary:foodUnitDict];
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
        NSRange range = NSMakeRange(2, 2);
        NSIndexSet *reloadSet = [[NSIndexSet alloc]initWithIndexesInRange:range];
        [self.listView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    //[self.listView setContentOffset:CGPointMake(0, 0) animated:NO];
    
}
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 102)
    {
        if (buttonIndex == alertView.cancelButtonIndex)
        {
            //            [[NSUserDefaults standardUserDefaults] removeObjectForKey:LZUserDailyIntakeKey];
            //            [[NSUserDefaults standardUserDefaults]synchronize];
            //            [self.navigationController  popViewControllerAnimated:!backWithNoAnimation];
        }
        else
        {
            
            UITextField *textFiled = [alertView textFieldAtIndex:0];
            
            NSString *collocationName = textFiled.text;
            NSString *trimedName = [collocationName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([trimedName length] == 0)
            {
                UIAlertView *invalidNameAlert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您输入的名称不规范，请重新输入" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [invalidNameAlert show];
                return;
            }
            LZDataAccess *da = [LZDataAccess singleton];
            NSMutableArray * foodAndAmountArray = [NSMutableArray array];
            for (NSString *foodId in self.takenFoodIdsArray)
            {
                NSDictionary *aFood = [takenFoodDict objectForKey:foodId];
                NSNumber *weight = [aFood objectForKey:@"Amount"];
                [foodAndAmountArray addObject:[NSArray arrayWithObjects:foodId, weight,nil]];
            }
            NSNumber *nmCollocationId = [da insertFoodCollocationData_withCollocationName:collocationName andFoodAmount2LevelArray:foodAndAmountArray];
            if(nmCollocationId)
            {
                UIAlertView *didSaveAlert = [[UIAlertView alloc]initWithTitle:@"保存成功" message:@"您可以进入膳食清单页面查看你的保存结果" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:@"去看看",nil];
                didSaveAlert.tag = 103;
                didSaveAlert.delegate = self;
                [didSaveAlert show];
            }
            else
            {
                UIAlertView *saveFailedAlert = [[UIAlertView alloc]initWithTitle:@"保存失败" message:@"出现了错误，请重试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [saveFailedAlert show];
            }
        }
    }

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 103)
    {
        if (buttonIndex == alertView.cancelButtonIndex)
        {
            //            [[NSUserDefaults standardUserDefaults] removeObjectForKey:LZUserDailyIntakeKey];
            //            [[NSUserDefaults standardUserDefaults]synchronize];
            //            [self.navigationController  popViewControllerAnimated:!backWithNoAnimation];
        }
        else
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            LZMainPageViewController *mainPageViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZMainPageViewController"];
            LZUserDietListViewController *userDietListViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZUserDietListViewController"];
            userDietListViewController.backWithNoAnimation = YES;
            NSArray *vcs = [NSArray arrayWithObjects:mainPageViewController,userDietListViewController, nil];
            UINavigationController *mainNav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            [mainNav setViewControllers:vcs animated:YES];
        }

    }
}
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
    HUD.hidden = YES;
}

- (void)viewDidUnload {
    [self setListView:nil];
    [super viewDidUnload];
}
@end
