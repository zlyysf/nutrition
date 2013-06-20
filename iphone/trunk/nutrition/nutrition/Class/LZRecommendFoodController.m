//
//  LZViewController.m
//  progress
//
//  Created by liu miao on 5/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZRecommendFoodController.h"
#import "MBProgressHUD.h"
#import "LZRecommendFoodCell.h"
#import "LZNutritionCell.h"
#import "LZConstants.h"
#import "LZRecommendFood.h"
#import "LZFoodDetailController.h"
#import "LZUtility.h"
#import "LZRecommendEmptyCell.h"
#import "LZShareViewController.h"
#import "GADMasterViewController.h"
#import "LZReviewAppManager.h"
#import <ShareSDK/ShareSDK.h>
#import "MobClick.h"
@interface LZRecommendFoodController ()<MBProgressHUDDelegate,UIActionSheetDelegate>
{
    MBProgressHUD *HUD;
}

@end

@implementation LZRecommendFoodController
@synthesize recommendFoodArray,recommendFoodDict,nutrientInfoArray,needRefresh;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"推荐";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
    UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
    recommendFoodArray = [[NSMutableArray alloc]init];
    recommendFoodDict = [[NSMutableDictionary alloc]init];
    nutrientInfoArray = [[NSMutableArray alloc]init];
    needRefresh= YES;
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.hidden = YES;
    HUD.delegate = self;
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0,0,
                                                             CGSizeFromGADAdSize(kGADAdSizeBanner).width,
                                                             CGSizeFromGADAdSize(kGADAdSizeBanner).height)];
    self.listView.tableFooterView = footerView;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsChanged:) name:Notification_SettingsChangedKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takenFoodChanged:) name:Notification_TakenFoodChangedKey object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(takenFoodDeleted:) name:Notification_TakenFoodDeletedKey object:nil];
   
    //[self recommendOnePlan];
}
- (void)settingsChanged:(NSNotification *)notification
{
    needRefresh = YES;
}
- (void)takenFoodChanged:(NSNotification *)notification
{
    needRefresh = YES;
}
- (void)takenFoodDeleted:(NSNotification *)notification
{
    needRefresh = YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"推荐页面"];
    GADMasterViewController *shared = [GADMasterViewController singleton];
    UIView *footerView = self.listView.tableFooterView;
    [shared resetAdView:self andListView:footerView];
    if (needRefresh)
    {
        self.listView.hidden = YES;
        HUD.hidden = NO;
        HUD.labelText = @"";
        [HUD show:YES];

    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"推荐页面"];
}
-(void)viewDidAppear:(BOOL)animated
{
    if (needRefresh )
    {
        [self recommendOnePlan];
        needRefresh = NO;
    }
}
- (IBAction)changeOnePlan:(id)sender {
    HUD.hidden = NO;
    [HUD show:YES];
    //self.listView.hidden = YES;
    
    HUD.labelText = @"";
    
    [self performSelector:@selector(recommendOnePlan) withObject:nil afterDelay:0.5];
    //[self recommendOnePlan];
}
- (void)recommendOnePlan
{
    [self.changeOnePlanItem setEnabled:NO];
    [self.shareItem setEnabled:NO];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dailyIntake = [userDefaults objectForKey:LZUserDailyIntakeKey];
    
    BOOL notAllowSameFood = TRUE;//这是一个策略标志位，偏好食物的多样化的标志位，即当选取食物补充营养时，优先选取以前没有用过的食物。
    BOOL randomSelectFood = TRUE;
    int randomRangeSelectFood = 20;//配合randomSelectFood，用于限制随机范围，0表示不限制, >0表示优先选择其范围内的东西
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
    NSNumber *planPerson = [[NSUserDefaults standardUserDefaults] objectForKey:LZPlanPersonsKey];
    NSNumber *planDays = [[NSUserDefaults standardUserDefaults]objectForKey:LZPlanDaysKey];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            planPerson,@"personCount",
                            planDays,@"dayCount", nil];
    
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
    NSLog(@"uiDictionary %@",[uiDictionary allKeys]);
    NSArray *recommendArray = [uiDictionary objectForKey:Key_recommendFoodInfoDictArray];
    [recommendFoodArray removeAllObjects];
    if (recommendArray != nil && [recommendArray count]!=0) {
        
        [recommendFoodArray addObjectsFromArray:recommendArray];
    }
    NSDictionary *recommendDict = [uiDictionary objectForKey:Key_recommendFoodNutrientInfoAryDictDict];
    [recommendFoodDict removeAllObjects];
    if (recommendDict != nil )
    {
        
        [recommendFoodDict addEntriesFromDictionary:recommendDict];
    }
    NSArray *nutrientArray = [uiDictionary objectForKey:Key_nutrientTotalSupplyRateInfoArray];
    [nutrientInfoArray removeAllObjects];
    if (nutrientArray != nil && [nutrientArray count]!=0) {
        
        [nutrientInfoArray addObjectsFromArray:nutrientArray];
    }
    [self.changeOnePlanItem setEnabled:YES];
    [self.shareItem setEnabled:YES];
    [HUD hide:YES];
    self.listView.hidden = NO;
    [self.listView reloadData];
    [[LZReviewAppManager SharedInstance]popReviewOurAppAlertAccordingRules];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return (recommendFoodArray ==nil || [recommendFoodArray count]==0) ? 1 : [recommendFoodArray count];
    else
        return [nutrientInfoArray count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0)
//    {
//        if(takenFoodArray ==nil || [takenFoodArray count]==0)
//        {
//            UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EmptyCell"];
//            cell.textLabel.text = @"空";
//            return cell;
//        }
//        else
//        {
//            LZRecommendFoodCell *cell = (LZRecommendFoodCell *)[tableView dequeueReusableCellWithIdentifier:@"LZRecommendFoodCell"];
//            NSDictionary *aFood = [takenFoodArray objectAtIndex:indexPath.row];
//            cell.foodNameLabel.text = [aFood objectForKey:@"Name"];
//            NSNumber *weight = [aFood objectForKey:@"Amount"];
//            cell.foodWeightlabel.text = [NSString stringWithFormat:@"%dg",[weight intValue]];
//            NSString *foodPic = [aFood objectForKey:@"PicturePath"];
//            UIImage *iconImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/quizicons/%@",[[NSBundle mainBundle] bundlePath],foodPic]];
//            [cell.foodImageView setImage:iconImage];
//            return cell;
//        }
//    }
    if (indexPath.section == 0)
    {
        if(recommendFoodArray ==nil || [recommendFoodArray count]==0)
        {
            LZRecommendEmptyCell * cell = (LZRecommendEmptyCell*)[tableView dequeueReusableCellWithIdentifier:@"LZRecommendEmptyCell"];
            [cell.contentLabel setTextColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8f]];
            cell.contentLabel.text = @"您所需要的营养已经足够，不需要另行推荐，去购物吧。";
            return cell;
        }
        else
        {
            LZRecommendFoodCell *cell = (LZRecommendFoodCell *)[tableView dequeueReusableCellWithIdentifier:@"LZRecommendFoodCell"];
            NSDictionary *aFood = [recommendFoodArray objectAtIndex:indexPath.row];
            cell.foodNameLabel.text = [aFood objectForKey:@"Name"];
            NSLog(@"picture path %@",aFood);
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
        NSString *nutrientId = [nutrient objectForKey:@"NutrientID"];
        UIColor *fillColor = [LZUtility getNutrientColorForNutrientId:nutrientId];
        cell.nutrientId = nutrientId;
        [cell.nameButton setTitle:[nutrient objectForKey:@"Name"] forState:UIControlStateNormal];
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
        [cell.nutritionProgressView drawProgressForRect:kProgressBarRect backgroundColor:[UIColor whiteColor] fillColor:fillColor progress:progress withBackRadius:7.f fillRadius:radius];
        [cell adjustLabelAccordingToProgress:progress forLabelWidth:226];
        if (KeyIsEnvironmentDebug)
        {
            cell.supplyPercentlabel.text = [NSString stringWithFormat:@"%d%%",(int)([percent floatValue] *100)];
        }
        else
        {
            cell.supplyPercentlabel.text = [NSString stringWithFormat:@"%d%%",(int)(progress *100)];
            
        }
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
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
        sectionTitleLabel.text =  @"推荐的食物";
    else
        sectionTitleLabel.text =  @"提供的营养成分";

    return sectionView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}// Default is 1 if not implemented
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
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
            foodDetailController.foodName = foodName;
            UINavigationController *initialController = (UINavigationController*)[UIApplication
                                                                                  sharedApplication].keyWindow.rootViewController;
            
            [initialController pushViewController:foodDetailController animated:YES];
        }


    }
    else
        return;

}
- (IBAction)shareButtonTapped:(id)sender
{
    UIActionSheet *shareSheet = [[UIActionSheet alloc]initWithTitle:@"分享到" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博", nil];
    [shareSheet showInView:self.view.superview];
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == actionSheet.cancelButtonIndex)
    {
        return;
    }
    else
    {
        if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo])
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            LZShareViewController *shareViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZShareViewController"];
            NSString *contents = @"@买菜助手(http://t.cn/zHuwJxz )为您精心推荐:";
            for (NSDictionary *aFood in recommendFoodArray)
            {
                NSString *name = [aFood objectForKey:@"Name"];
                NSNumber *weight = [aFood objectForKey:@"Amount"];
                contents = [contents stringByAppendingFormat:@"\n%@ %dg",name,[weight intValue]];
            }
//            买菜助手(http://t.cn/zHuwJxz )为您精心推荐:
//                 食物1 123g
//                 食物1 123g
//                 食物1 123g
//                 食物1 123g
//
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
                                            SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                            //[ShareSDK userFieldWithType:SSUserFieldTypeName valeu:@"ShareSDK"],
                                            //SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                            nil]];
            [ShareSDK authWithType:ShareTypeSinaWeibo options:authOptions result:^(SSAuthState state, id<ICMErrorInfo> error) {
                if (state == SSAuthStateSuccess)
                {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                    LZShareViewController *shareViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZShareViewController"];
                    shareViewController.preInsertText = @"测试一下";
                    [self presentModalViewController:shareViewController animated:YES];
                }
                NSLog(@"ssauthState %d",state);
            }];
            
        }
    }

}
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
    HUD.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_SettingsChangedKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_TakenFoodChangedKey object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:Notification_TakenFoodDeletedKey object:nil];
    [self setChangeOnePlanItem:nil];
    [self setShareItem:nil];
    [super viewDidUnload];
}
@end
