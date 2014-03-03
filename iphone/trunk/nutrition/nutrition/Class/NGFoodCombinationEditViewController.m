//
//  NGFoodCombinationEditViewController.m
//  nutrition
//
//  Created by Yasofon on 14-2-7.
//  Copyright (c) 2014年 lingzhi mobile. All rights reserved.
//

#import "NGFoodCombinationEditViewController.h"


//#import "LZAddFoodViewController.h"
#import "LZRecommendFood.h"
#import "LZRecommendFoodCell.h"
//#import "LZFoodNutritionCell.h"
#import "NGNutritionSupplyCell.h"
#import "LZConstants.h"
#import "NGFoodDetailController.h"
#import "LZUtility.h"
#import "LZEmptyClassCell.h"
//#import "LZAddByNutrientController.h"
#import "NGFoodsByNutrientViewController.h"
#import "NGFoodsByClassSearchViewController.h"

#import "GADMasterViewController.h"
#import "MobClick.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "LZReviewAppManager.h"
//#import <ShareSDK/ShareSDK.h>
//#import "WXApi.h"
#import "LZShareViewController.h"
#import "LZRecommendFilterView.h"
#import "LZAppDelegate.h"

#import "LZNutrientionManager.h"
#import "LZGlobalService.h"
#import "LZGlobal.h"
#import "LZUtilityParse.h"


#define KChangeFoodAmountAlertTag 101
#define KSaveDietTitleAlertTag 102
#define KInstallWechatAlertTag 103


@interface NGFoodCombinationEditViewController ()<MBProgressHUDDelegate,UIActionSheetDelegate,UIAlertViewDelegate,LZRecommendFilterViewDelegate>//,NGSelectFoodAmountDelegate>
{
    MBProgressHUD *HUD;
    BOOL isCapturing;
    BOOL isChinese;
}

@property (assign,nonatomic)BOOL needRefresh;
//@property (strong,nonatomic)NSMutableArray *m_takenFoodIdsArray;
//@property (strong, nonatomic)NSMutableDictionary *m_foodAmountInfoDict;
//@property (strong,nonatomic)NSMutableArray *m_nutrientSupplyRateInfoArray;//nutrientInfoArray
//@property (strong,nonatomic)NSMutableDictionary *m_takenFoodNutrientInfoAryDictDict;//takenFoodNutrientInfoDict
//@property (strong,nonatomic)NSMutableDictionary *m_recommendFoodAmountDict_ForDisplay;
//@property (strong,nonatomic)NSMutableDictionary *m_allRelatedFoodAttrDict;

@end

@implementation NGFoodCombinationEditViewController{
    NSMutableDictionary * m_takenFoodAmountDict;
    
    NSMutableArray *m_allFoodIdsArray;
    NSMutableDictionary *m_foodAmountInfoDict;
    NSMutableArray *m_nutrientSupplyRateInfoArray;//nutrientInfoArray
    NSMutableDictionary *m_takenFoodNutrientInfoAryDictDict;//takenFoodNutrientInfoDict
    NSMutableDictionary *m_recommendFoodAmountDict_ForDisplay;
    NSMutableDictionary *m_allRelatedFoodAttrDict;
    
    NSDictionary *m_DRIsDict, *m_nutrientSupplyDict ;
    
}
@synthesize dietId, needRefresh, backWithNoAnimation;
//    m_takenFoodIdsArray,m_foodAmountInfoDict,m_nutrientSupplyRateInfoArray,m_takenFoodNutrientInfoAryDictDict,m_recommendFoodAmountDict_ForDisplay,m_allRelatedFoodAttrDict;//listType,useRecommendNutrient

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
    
    [LZGlobalService SetSubViewExternNone:self];
    
    self.title = NSLocalizedString(@"listmake_viewtitle2",@"营养搭配");
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.view addSubview:HUD];
    HUD.hidden = YES;
    HUD.delegate = self;
    
    isChinese = [LZUtility isCurrentLanguageChinese];

    //self.currentEditFoodId = nil;
	// Do any additional setup after loading the view.
//    if (ViewControllerUseBackImage) {
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
//        UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
//        [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
//        [self.listView setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
//    }
//    else
//    {
//        [self.listView setBackgroundColor:[UIColor whiteColor]];
//    }
    [self.listView setBackgroundColor:[UIColor whiteColor]];


    [self.shareButton setHidden:true];
    [self.ButtonsBackGroundImageView setHidden:true];
    CGRect frame1 = self.addFoodButton.frame;
    CGRect frame2 = self.recommendFoodButton.frame;
    frame1.origin.x = 10;
    frame1.size.width = 145;
    frame2.origin.x = 155;
    frame2.size.width = 145;
    [self.addFoodButton setFrame:frame1];
    [self.recommendFoodButton setFrame:frame2];
    
//    if (backWithNoAnimation)
//    {
//        UIImage *buttonImage = [UIImage imageNamed:@"nav_back_button.png"];
//        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//        [button setTitle:NSLocalizedString(@"fanhuibutton",@"  返回") forState:UIControlStateNormal];
//        
//        button.frame = CGRectMake(0, 0, 48, 30);
//        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
//        [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
//        [button addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
//        
//        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//        
//        self.navigationItem.leftBarButtonItem = cancelItem;
//        
//    }
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"baocunbutton",@"保存") style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonTapped)];
    self.navigationItem.rightBarButtonItem = saveItem;
    needRefresh = NO;
    
    m_takenFoodAmountDict = [[NSMutableDictionary alloc]init];
    m_allFoodIdsArray = [[NSMutableArray alloc]init];
    m_foodAmountInfoDict = [[NSMutableDictionary alloc]init];
    m_nutrientSupplyRateInfoArray = [[NSMutableArray alloc]init];
    m_takenFoodNutrientInfoAryDictDict = [[NSMutableDictionary alloc]init];
    m_recommendFoodAmountDict_ForDisplay = [[NSMutableDictionary alloc]init];
    m_allRelatedFoodAttrDict = [[NSMutableDictionary alloc]init];
    
    if (dietId != nil && [dietId intValue]>0){
        LZDataAccess *da = [LZDataAccess singleton];
        NSArray *foodAndAmountDictAry = [da getCollocationFoodAmountRows_withCollocationId:dietId];
        for (NSDictionary *foodAndAmountDict in foodAndAmountDictAry)
        {
            NSNumber* foodAmount = [foodAndAmountDict objectForKey:@"FoodAmount"];
            NSString* foodId = [foodAndAmountDict objectForKey:@"FoodId"];
            [m_takenFoodAmountDict setObject:foodAmount forKey:foodId];
        }
    }
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0,0,
                                                                 CGSizeFromGADAdSize(kGADAdSizeBanner).width,
                                                                 CGSizeFromGADAdSize(kGADAdSizeBanner).height)];
    self.listView.tableFooterView = footerView;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsChanged:) name:Notification_SettingsChangedKey object:nil];
    [self.addFoodButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    
    [self refreshFoodNureitentProcessForAll:YES];
    isCapturing = NO;
}
- (void)cancelButtonTapped
{
    NSDictionary *emptyIntake = [[NSDictionary alloc]init];
    [[NSUserDefaults standardUserDefaults] setObject:emptyIntake forKey:LZUserDailyIntakeKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController  popViewControllerAnimated:!backWithNoAnimation];
    
}
- (void)saveButtonTapped
{
    
    if([m_allFoodIdsArray count] == 0)
    {
        UIAlertView *foodEmptyAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alerttitle_wenxintishi",@"温馨提示") message:NSLocalizedString(@"listmake_alert0_message",@"食物列表还是空的呢，马上添加食物或点击推荐吧!") delegate:nil cancelButtonTitle:NSLocalizedString(@"zhidaolebutton",@"知道了") otherButtonTitles:nil];
        [foodEmptyAlert show];
        return;
    }
    else
    {
        [MobClick event:UmengEvent_V2YingYangDaPeiSave];
        if (dietId == nil || [dietId intValue]<=0)
        {
            //新建一个表单，用insert
            NSDate *now = [NSDate date];
            NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
            NSString *localeId = @"en";
            if ([LZUtility isCurrentLanguageChinese])
            {
                localeId = @"zh";
            }
            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:localeId]];
            [formatter setDateFormat:NSLocalizedString(@"listmake_savefoodalert_content1",@"MM月dd号")];
            NSString* time = [formatter stringFromDate:now];
            NSString *text = [NSString stringWithFormat:NSLocalizedString(@"listmake_savefoodalert_content2",@"%@的饮食计划"),time];
            //7月29号的饮食计划
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"listmake_alert1_title",@"保存食物清单") message:NSLocalizedString(@"listmake_alert1_message",@"给你的食物清单加个名称吧!") delegate:self cancelButtonTitle:NSLocalizedString(@"quxiaobutton",@"取消" )otherButtonTitles:NSLocalizedString(@"quedingbutton",@"确定"), nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            alert.tag = KSaveDietTitleAlertTag;
            UITextField *tf = [alert textFieldAtIndex:0];
            tf.clearButtonMode = UITextFieldViewModeAlways;
            tf.text = text;
            [alert show];
            
        }
        else
        {
            //编辑已有的表单，用update
            LZDataAccess *da = [LZDataAccess singleton];
            NSMutableArray * foodAndAmountArray = [NSMutableArray array];
            for (NSString *foodId in m_allFoodIdsArray)
            {
                NSDictionary *aFood = [m_foodAmountInfoDict objectForKey:foodId];
                NSNumber *weight = [aFood objectForKey:@"Amount"];
                [foodAndAmountArray addObject:[NSArray arrayWithObjects:foodId, weight,nil]];
            }
            if([da updateFoodCollocationData_withCollocationId:dietId andNewCollocationName:nil andFoodAmount2LevelArray:foodAndAmountArray])
            {
                [LZUtilityParse saveParseObject_FoodCollocationData_withCollocationId:dietId];

                
                [self.navigationController  popViewControllerAnimated:!backWithNoAnimation];
            }
            else
            {
                UIAlertView *saveFailedAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"listmake_alert2_title",@"保存失败") message:NSLocalizedString(@"alertmessage_tryagain",@"出现了错误，请重试") delegate:nil cancelButtonTitle:NSLocalizedString(@"zhidaolebutton",@"知道了") otherButtonTitles:nil];
                [saveFailedAlert show];
            }
        }
    }

}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nutrientShowNotification:) name:Notification_ShowNutrientInfoKey object:nil];
    [MobClick beginLogPageView:UmengPathYingYangDaPei];
    self.listView.tableFooterView.hidden = NO;
    GADMasterViewController *shared = [GADMasterViewController singleton];
    UIView *footerView = self.listView.tableFooterView;
    [shared resetAdView:self andListView:footerView];
    if(needRefresh)
    {
        [self refreshFoodNureitentProcessForAll:YES];
        needRefresh = NO;
    }
    
    [[LZReviewAppManager SharedInstance]popReviewOurAppAlertAccordingRules_withViewController:self];
}
- (void)viewDidAppear:(BOOL)animated
{
    //    if (useRecommendNutrient)
    //    {
    //        useRecommendNutrient = NO;
    //        HUD.hidden = NO;
    //        [HUD show:YES];
    //        //self.listView.hidden = YES;
    //
    //        HUD.labelText = @"智能推荐中...";
    //
    //        [self performSelector:@selector(recommendOnePlan) withObject:nil afterDelay:0.f];
    //    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_ShowNutrientInfoKey object:nil];
    [MobClick endLogPageView:UmengPathYingYangDaPei];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_TakenFoodChangedKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_SettingsChangedKey object:nil];
    [self setListView:nil];
    [self setAddFoodButton:nil];
    [self setRecommendFoodButton:nil];
    [self setShareButton:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mergeRecommendFoodsToTakenFoods{
    [LZUtility addDoubleDictionaryToDictionary_withSrcAmountDictionary:m_recommendFoodAmountDict_ForDisplay withDestDictionary:m_takenFoodAmountDict];
    [m_recommendFoodAmountDict_ForDisplay removeAllObjects];
}


//- (void)nutrientShowNotification:(NSNotification *)notification
//{
//}
- (void)settingsChanged:(NSNotification *)notification
{
    needRefresh = YES;
}

-(void)refreshFoodNureitentProcessForAll:(BOOL)needRefreshAll
{
//    NSDictionary *takenFoodAmountDict = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserDailyIntakeKey];
//    NSDictionary *takenFoodAmountDict = m_takenFoodAmountDict;

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            m_takenFoodAmountDict,@"givenFoodsAmount1",
                            m_recommendFoodAmountDict_ForDisplay,@"givenFoodsAmount2",
                            nil];
    if (m_DRIsDict==nil){
        NSDictionary *userInfo = [LZUtility getUserInfo];
        params[Key_userInfo] = userInfo;
    }else{
        params[Key_DRI] = m_DRIsDict;
    }
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retFmtDict = [rf calculateGiveFoodsSupplyNutrientAndFormatForUI:params];
    //    NSLog(@" allkeys  %@",[retFmtDict allKeys]);
    //    NSLog(@"calculateGiveFoodsSupplyNutrientAndFormatForUI %@",retFmtDict);
    if (m_DRIsDict==nil){
        m_DRIsDict = [retFmtDict objectForKey:Key_DRI];
    }
    m_nutrientSupplyDict = retFmtDict[Key_nutrientSupplyDict];
    
    NSArray *takenArray1 = [retFmtDict objectForKey:Key_orderedGivenFoodIds1];
    NSArray *takenArray2 = [retFmtDict objectForKey:Key_orderedGivenFoodIds2];
    [m_allFoodIdsArray removeAllObjects];
    if (takenArray1 != nil && [takenArray1 count]!=0) {
        
        [m_allFoodIdsArray addObjectsFromArray:takenArray1];
    }
    if (takenArray2 != nil && [takenArray2 count]!=0) {
        
        [m_allFoodIdsArray addObjectsFromArray:takenArray2];
    }
    NSDictionary *foodAttrDict = [retFmtDict objectForKey:Key_givenFoodAttrDict2Level];
    [m_allRelatedFoodAttrDict removeAllObjects];
    if (foodAttrDict != nil )
    {
        [m_allRelatedFoodAttrDict addEntriesFromDictionary:foodAttrDict];
    }
    
    NSDictionary *foodAmountInfoDict1 = [retFmtDict objectForKey:Key_givenFoodInfoDict2Level];
    [m_foodAmountInfoDict removeAllObjects];
    if (foodAmountInfoDict1 != nil )
    {
        [m_foodAmountInfoDict addEntriesFromDictionary:foodAmountInfoDict1];
    }
    
    NSDictionary *takenFoodNutrientInfoAryDictDict1 = [retFmtDict objectForKey:Key_takenFoodNutrientInfoAryDictDict];
    [m_takenFoodNutrientInfoAryDictDict removeAllObjects];
    if (takenFoodNutrientInfoAryDictDict1 != nil )
    {
        [m_takenFoodNutrientInfoAryDictDict addEntriesFromDictionary:takenFoodNutrientInfoAryDictDict1];
    }
    
    NSArray *nutrientSupplyRateInfoArray1 = [retFmtDict objectForKey:Key_nutrientSupplyRateInfoArray];
    [m_nutrientSupplyRateInfoArray removeAllObjects];
    if (nutrientSupplyRateInfoArray1 != nil && [nutrientSupplyRateInfoArray1 count]!=0)
    {
        [m_nutrientSupplyRateInfoArray addObjectsFromArray:nutrientSupplyRateInfoArray1];
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
    //[self.listView setContentOffset:CGPointMake(0, 0) animated:NO];
    
}
//-(void)refreshFoodNureitentProcessForTaken:(NSDictionary *)takenDict recommended:(NSDictionary*)recommendedDict
//{
////    NSDictionary *takenFoodAmountDict = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserDailyIntakeKey];
//
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSNumber *userSex = [userDefaults objectForKey:LZUserSexKey];
//    NSNumber *userAge = [userDefaults objectForKey:LZUserAgeKey];
//    NSNumber *userHeight = [userDefaults objectForKey:LZUserHeightKey];
//    NSNumber *userWeight = [userDefaults objectForKey:LZUserWeightKey];
//    NSNumber *userActivityLevel = [userDefaults objectForKey:LZUserActivityLevelKey];
//    if (!(userSex && userAge && userHeight && userWeight && userActivityLevel))
//    {
//        return;
//    }
//    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
//                              userSex,ParamKey_sex, userAge,ParamKey_age,
//                              userWeight,ParamKey_weight, userHeight,ParamKey_height,
//                              userActivityLevel,ParamKey_activityLevel, nil];
//
//
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                            userInfo,@"userInfo",
//                            takenDict,@"givenFoodsAmount1",
//                            recommendedDict,@"givenFoodsAmount2",
//                            nil];
//
//    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
//    NSMutableDictionary *retFmtDict = [rf calculateGiveFoodsSupplyNutrientAndFormatForUI:params];
//    NSLog(@" allkeys  %@",[retFmtDict allKeys]);
//    NSLog(@"calculateGiveFoodsSupplyNutrientAndFormatForUI %@",retFmtDict);
//
//    NSArray *takenArray1 = [retFmtDict objectForKey:Key_orderedGivenFoodIds1];
//    NSArray *takenArray2 = [retFmtDict objectForKey:Key_orderedGivenFoodIds2];
//    [m_takenFoodIdsArray removeAllObjects];
//    if (takenArray1 != nil && [takenArray1 count]!=0) {
//
//        [m_takenFoodIdsArray addObjectsFromArray:takenArray1];
//    }
//    if (takenArray2 != nil && [takenArray2 count]!=0) {
//
//        [m_takenFoodIdsArray addObjectsFromArray:takenArray2];
//    }
//    NSDictionary *foodUnitDict = [retFmtDict objectForKey:Key_givenFoodAttrDict2Level];
//    [m_allRelatedFoodAttrDict removeAllObjects];
//    if (foodUnitDict != nil )
//    {
//
//        [m_allRelatedFoodAttrDict addEntriesFromDictionary:foodUnitDict];
//    }
//
//
//    NSDictionary *takeDict = [retFmtDict objectForKey:Key_givenFoodInfoDict2Level];
//    [m_foodAmountInfoDict removeAllObjects];
//    if (takeDict != nil )
//    {
//
//        [m_foodAmountInfoDict addEntriesFromDictionary:takeDict];
//    }
//
//    NSDictionary *takenFoodNutrientDict = [retFmtDict objectForKey:Key_takenFoodNutrientInfoAryDictDict];
//    [m_takenFoodNutrientInfoAryDictDict removeAllObjects];
//    if (takenFoodNutrientDict != nil )
//    {
//
//        [m_takenFoodNutrientInfoAryDictDict addEntriesFromDictionary:takenFoodNutrientDict];
//    }
//
//    NSArray *nutrientArray = [retFmtDict objectForKey:Key_nutrientSupplyRateInfoArray];
//    [m_nutrientSupplyRateInfoArray removeAllObjects];
//    if (nutrientArray != nil && [nutrientArray count]!=0) {
//
//        [m_nutrientSupplyRateInfoArray addObjectsFromArray:nutrientArray];
//    }
//
//    [self.listView reloadData];
//
//}

//SHOULD BE DELETED
- (void)deleteOneCell:(NSString *)foodId
{
    //NSString *foodId = cell.cellFoodId;
    NSDictionary *cellInfoDict = [m_foodAmountInfoDict objectForKey:foodId];
    int index = [m_allFoodIdsArray indexOfObject:foodId];
    if (index >= 0 && index < [m_allFoodIdsArray count])
    {
        NSIndexPath *indexPathToDelete = [NSIndexPath indexPathForRow:index inSection:0];
        
        NSDictionary *takenFoodAmountDict = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserDailyIntakeKey];
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]initWithDictionary:takenFoodAmountDict];
        NSString *ndb_No = [cellInfoDict objectForKey:@"NDB_No"];
        [tempDict removeObjectForKey:ndb_No];
        [m_recommendFoodAmountDict_ForDisplay removeObjectForKey:ndb_No];
        [[NSUserDefaults standardUserDefaults] setObject:tempDict forKey:LZUserDailyIntakeKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
        //[self displayTakenFoodResult];
        [[NSNotificationCenter defaultCenter]postNotificationName:Notification_TakenFoodDeletedKey object:nil userInfo:nil];
        [m_allFoodIdsArray removeObjectAtIndex:index];
        NSArray *array = [[NSArray alloc]initWithObjects:indexPathToDelete, nil];
        self.listView.userInteractionEnabled = NO;
        if ([m_allFoodIdsArray count]== 0)
        {
            //            if(sender.direction == UISwipeGestureRecognizerDirectionLeft)
            //                [self.listView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationLeft];
            //            else
            [self.listView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationRight];
            
        }
        else
        {
            [self.listView beginUpdates];
            //            if(sender.direction == UISwipeGestureRecognizerDirectionLeft)
            //                [self.listView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationLeft];
            //            else
            [self.listView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationRight];
            [self.listView endUpdates];
        }
        self.listView.userInteractionEnabled = YES;
        [self refreshFoodNureitentProcessForAll:NO];
    }
    
}
- (void)foodCellSwiped:(UISwipeGestureRecognizer*)sender
{
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        //        NSLog(@"%d",sender.direction);
        LZRecommendFoodCell *cell = (LZRecommendFoodCell*)sender.view;
        NSString *foodId = cell.cellFoodId;
        
        [self mergeRecommendFoodsToTakenFoods];
        [m_takenFoodAmountDict removeObjectForKey:foodId];
        
        [self refreshFoodNureitentProcessForAll:TRUE];
        
//TODO TO BE DELETED
//        int index = [m_takenFoodIdsArray indexOfObject:foodId];
//        if (index >= 0 && index < [m_takenFoodIdsArray count])
//        {
//            NSIndexPath *indexPathToDelete = [NSIndexPath indexPathForRow:index inSection:0];
//            
////            NSDictionary *takenFoodAmountDict = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserDailyIntakeKey];
//            NSDictionary *takenFoodAmountDict = m_takenFoodAmountDict;
//            
//            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]initWithDictionary:takenFoodAmountDict];
//            NSString *ndb_No = [cellInfoDict objectForKey:@"NDB_No"];
//            [tempDict removeObjectForKey:ndb_No];
//            [m_recommendFoodAmountDict_ForDisplay removeObjectForKey:ndb_No];
//            [[NSUserDefaults standardUserDefaults] setObject:tempDict forKey:LZUserDailyIntakeKey];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//            
//            
//            //[self displayTakenFoodResult];
//
//            
//            [m_takenFoodIdsArray removeObjectAtIndex:index];
//            
//            NSArray *array = [[NSArray alloc]initWithObjects:indexPathToDelete, nil];
//            self.listView.userInteractionEnabled = NO;
//            if ([m_takenFoodIdsArray count]== 0)
//            {
//                if(sender.direction == UISwipeGestureRecognizerDirectionLeft)
//                    [self.listView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationLeft];
//                else
//                    [self.listView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationRight];
//                
//            }
//            else
//            {
//                [self.listView beginUpdates];
//                if(sender.direction == UISwipeGestureRecognizerDirectionLeft)
//                    [self.listView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationLeft];
//                else
//                    [self.listView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationRight];
//                [self.listView endUpdates];
//            }
//            self.listView.userInteractionEnabled = YES;
//            [self refreshFoodNureitentProcessForAll:NO];
//        }
    }
}
- (void)keyboardWillShow:(NSNotification *)notification {
	
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *boundsValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect keyboardRect = [boundsValue CGRectValue];
    
    CGFloat keyboardTop = self.view.frame.size.height - keyboardRect.size.height-44;
    CGRect tableviewFrame = self.listView.frame;
	tableviewFrame.size.height = keyboardTop;
    
	//bottomViewFrame.origin.y = keyboardTop - bottomViewFrame.size.height;
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.listView.frame = tableviewFrame;
    [UIView commitAnimations];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
	CGRect tableviewFrame = self.listView.frame;
	tableviewFrame.size.height = self.view.frame.size.height-44;
    
	//bottomViewFrame.origin.y = keyboardTop - bottomViewFrame.size.height;
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.listView.frame = tableviewFrame;
    [UIView commitAnimations];
    
}
//#pragma mark- LZRecommendFoodCell Delegate
//- (void)textFieldDidReturnForId:(NSString*)foodId andText:(NSString*)foodNumber
//{
//    int i = [m_takenFoodIdsArray indexOfObject:foodId];
//    NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
//
//    if ([foodNumber length]==0)
//    {
//        LZRecommendFoodCell* cell =(LZRecommendFoodCell*)[self.listView cellForRowAtIndexPath:index];
//        NSDictionary *aFood = [m_foodAmountInfoDict objectForKey:foodId];
//        NSNumber *weight = [aFood objectForKey:@"Amount"];
//        cell.foodUnitLabel.text = [NSString stringWithFormat:@"%dg",[weight intValue]];
//    }
//    else
//    {
//
//        int changed = [foodNumber intValue];
//        if (changed <=0)
//        {
//            [self deleteOneCell:foodId];
//            return;
//        }
//        NSDictionary* takenDict =  [[NSUserDefaults standardUserDefaults]objectForKey:LZUserDailyIntakeKey];
//        if ([takenDict objectForKey:foodId])
//        {
//            NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:takenDict];
//
//            if (changed <=0)
//            {
//                [tempDict removeObjectForKey:foodId];
//            }
//            else
//            {
//                [tempDict setObject:[NSNumber numberWithInt:changed] forKey:foodId];
//            }
//            [[NSUserDefaults standardUserDefaults]setObject:tempDict forKey:LZUserDailyIntakeKey];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//
//        }
//        else if ([m_recommendFoodAmountDict_ForDisplay objectForKey:foodId])
//        {
//            if (changed <=0)
//            {
//                [m_recommendFoodAmountDict_ForDisplay removeObjectForKey:foodId];
//            }
//            else
//            {
//                [m_recommendFoodAmountDict_ForDisplay setObject:[NSNumber numberWithInt:changed] forKey:foodId];
//            }
//
//        }
//        LZRecommendFoodCell* cell =(LZRecommendFoodCell*)[self.listView cellForRowAtIndexPath:index];
//        NSDictionary *aFood = [m_foodAmountInfoDict objectForKey:foodId];
//        NSNumber *weight = [NSNumber numberWithInt:changed];
//        cell.foodUnitLabel.text = [NSString stringWithFormat:@"%dg",[weight intValue]];
//        NSDictionary *foodAtr = [m_allRelatedFoodAttrDict objectForKey:foodId];
//        NSString *singleUnitName = [foodAtr objectForKey:COLUMN_NAME_SingleItemUnitName];
//        NSString *foodTotalUnit = @"";
//        if ([singleUnitName length]==0)
//        {
//            foodTotalUnit = @"";
//        }
//        else
//        {
//            NSNumber *singleUnitWeight = [foodAtr objectForKey:COLUMN_NAME_SingleItemUnitWeight];
//            int unitCount = (int)((float)([weight floatValue]/[singleUnitWeight floatValue])+0.5);
//            if (unitCount <= 0)
//            {
//                foodTotalUnit = @"";
//            }
//            else
//            {
//                foodTotalUnit = [NSString stringWithFormat:@"(%d%@)",unitCount,singleUnitName];
//            }
//        }
//        NSString *foodName = [aFood objectForKey:@"Name"];
//        cell.foodNameLabel.text = [NSString stringWithFormat:@"%@ %@",foodName,foodTotalUnit];
//
//        [self refreshFoodNureitentProcessForAll:NO];
//    }
//
//}
//- (void)textFieldDidBeginEditingForId:(NSString *)foodId textField:(UITextField*)currentTextField
//{
//    int i = [m_takenFoodIdsArray indexOfObject:foodId];
//    NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 50 * USEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//    [self.listView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//    });
//}

#pragma mark- NGFoodCombinationEditViewControllerDelegate
-(void)addToCombinationWithFoodId:(NSString *)foodId andAmount:(NSNumber*)amount
{
    [self mergeRecommendFoodsToTakenFoods];
    [LZUtility addDoubleToDictionaryItem:[amount intValue] withDictionary:m_takenFoodAmountDict andKey:foodId];
    needRefresh = TRUE;
}

-(void)changeToCombinationWithFoodId:(NSString *)foodId andAmount:(NSNumber*)amount
{
    [self mergeRecommendFoodsToTakenFoods];
    if ([amount intValue]==0){
        [m_takenFoodAmountDict removeObjectForKey:foodId];
    }else{
        m_takenFoodAmountDict[foodId] = [NSNumber numberWithInt: [amount intValue]];
    }
    needRefresh = TRUE;
}

-(NSDictionary*)getFoodAmountDict{
    return m_takenFoodAmountDict;
}

#pragma mark- TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return (m_allFoodIdsArray ==nil || [m_allFoodIdsArray count]==0) ? 1 : [m_allFoodIdsArray count];
    else
        return [m_nutrientSupplyRateInfoArray count];
    //    if (section == 0)
    //        return (recommendFoodArray ==nil || [recommendFoodArray count]==0) ? 1 : [recommendFoodArray count];
    //    else
    //        return [m_nutrientSupplyRateInfoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if(m_allFoodIdsArray ==nil || [m_allFoodIdsArray count]==0)
        {
            LZEmptyClassCell * cell = (LZEmptyClassCell*)[tableView dequeueReusableCellWithIdentifier:@"LZRecommendEmptyCell"];
            if (cell.hasLoaded)
            {
                return cell;
            }
            else
            {
                UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 4, 300, 68)];
                [contentLabel setTextColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8]];
                [contentLabel setBackgroundColor:[UIColor clearColor]];
                [cell.contentView addSubview:contentLabel];
                contentLabel.numberOfLines = 0;
                [contentLabel setFont:[UIFont systemFontOfSize:14]];
                contentLabel.text = NSLocalizedString(@"listmake_emptyfoodlabel_content",@"我们app的作用是帮您找到适合您一天的各营养需要量的食物搭配，您可以通过我们的推荐功能快速得到，也可以加入自己的选择以找到最适合您的方案。");
                cell.hasLoaded = YES;
                return cell;
            }
        }
        else
        {
            LZRecommendFoodCell *cell = (LZRecommendFoodCell *)[tableView dequeueReusableCellWithIdentifier:@"LZRecommendFoodCell"];
            NSString *foodId = [m_allFoodIdsArray objectAtIndex:indexPath.row];
            NSDictionary *foodAmountInfo = [m_foodAmountInfoDict objectForKey:foodId];
            //NSLog(@"picture path %@",aFood);
            if([m_recommendFoodAmountDict_ForDisplay objectForKey:foodId]) {
                cell.recommendSignImageView.hidden = NO;
            } else {
                cell.recommendSignImageView.hidden = YES;
            }
            NSString *picturePath;
            NSString *picPath = [foodAmountInfo objectForKey:@"PicturePath"];
            if (picPath == nil || [picPath isEqualToString:@""]) {
                picturePath = [[NSBundle mainBundle]pathForResource:@"defaulFoodPic" ofType:@"png"];
            } else {
                NSString * picFolderPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"foodDealed"];
                picturePath = [picFolderPath stringByAppendingPathComponent:picPath];
            }
            UIImage *foodImage = [UIImage imageWithContentsOfFile:picturePath];
            [cell.foodImageView setImage:foodImage];
            cell.cellFoodId = foodId;
            
            NSNumber *weight = [foodAmountInfo objectForKey:@"Amount"];
            cell.foodUnitLabel.text = [NSString stringWithFormat:@"%dg",[weight intValue]];
            NSDictionary *foodAttr = [m_allRelatedFoodAttrDict objectForKey:foodId];
            NSString *singleUnitName = [LZUtility getSingleItemUnitName:[foodAttr objectForKey:COLUMN_NAME_SingleItemUnitName]];
            NSString *foodTotalUnit = @"";
            if ([singleUnitName length]==0) {
                foodTotalUnit = @"";
            } else {
                NSNumber *singleUnitWeight = [foodAttr objectForKey:COLUMN_NAME_SingleItemUnitWeight];
                int maxCount = (int)(ceilf(([weight floatValue]*2)/[singleUnitWeight floatValue]));
                //int unitCount = (int)((float)([weight floatValue]/[singleUnitWeight floatValue])+0.5);
                if (maxCount <= 0) {
                    foodTotalUnit = @"";
                } else {
                    if (maxCount %2 == 0) {
                        foodTotalUnit = [NSString stringWithFormat:@"(%d%@)",(int)(maxCount*0.5f),singleUnitName];
                    } else {
                        foodTotalUnit = [NSString stringWithFormat:@"(%.1f%@)",maxCount*0.5f,singleUnitName];
                    }
                }
            }
            
            NSString *foodName = [LZUtility getLocalFoodName:foodAttr];
            cell.foodNameLabel.text = [NSString stringWithFormat:@"%@ %@",foodName,foodTotalUnit];
            UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(foodCellSwiped:)];
            swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
            UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(foodCellSwiped:)];
            swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
            [cell addGestureRecognizer:swipeLeftGesture];
            [cell addGestureRecognizer:swipeRightGesture];
            return cell;
        }
    }
    else
    {
//        LZFoodNutritionCell *cell = (LZFoodNutritionCell *)[tableView dequeueReusableCellWithIdentifier:@"LZFoodNutritionCell"];
//        NSDictionary *nutrient = [m_nutrientSupplyRateInfoArray objectAtIndex:indexPath.row];
//        
//        NSString *nutrientId = [nutrient objectForKey:@"NutrientID"];
//
//        LZNutrientionManager *nm = [LZNutrientionManager SharedInstance];
//        NSDictionary *dict = [nm getNutritionInfo:nutrientId];
//        NSString *nutritionName = [LZUtility getLocalNutrientName:dict];
//        
//        [cell.nutritionNameButton setTitle:nutritionName forState:UIControlStateNormal];
//        cell.nutrientId = nutrientId;
//        UIColor *fillColor = [LZUtility getNutrientColorForNutrientId:nutrientId];
//        NSNumber *percent = [nutrient objectForKey:@"nutrientSupplyRate"];
//        float progress = [percent floatValue]>1.f ? 1.f :[percent floatValue];
//        float radius;
//        if (progress >0.03 )
//        {
//            radius = 4;
//        }
//        else
//        {
//            radius = 2;
//        }
//        [cell.backView.layer setMasksToBounds:YES];
//        [cell.backView.layer setCornerRadius:3.f];
//        [cell.nutritionProgressView drawProgressForRect:CGRectMake(2,2,194,14) backgroundColor:[UIColor whiteColor] fillColor:fillColor progress:progress withBackRadius:7.f fillRadius:radius];
//        [cell adjustLabelAccordingToProgress:progress forLabelWidth:194];
//
//        cell.supplyPercentlabel.text = [NSString stringWithFormat:@"%d%%",(int)(floorf([percent floatValue] *100))];
//
//        cell.addFoodButton.tag = indexPath.row;
        
        NGNutritionSupplyCell *cell = (NGNutritionSupplyCell *)[tableView dequeueReusableCellWithIdentifier:@"NGNutritionSupplyCell"];
        
        //配合 UITableViewCell 的 - (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated 是可以但麻烦的
//        cell.enableHighlighted = true;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
//        //FAIL 只出现了一次效果，后来就没了.看来用selectedBackgroundView 的方式不行。
//        UIColor *selectedBgColor = [UIColor colorWithRed:61/255.f green:175/255.f blue:45/255.f alpha:1.0f];
////        if (cell.selectedBackgroundView ==nil)//如果判断nil再生成，根本就没有效果
//            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//        cell.selectedBackgroundView.backgroundColor = selectedBgColor;
        

//        cell.nutritionNameLabel.highlightedTextColor = [UIColor whiteColor];//no use here
        

        NSDictionary *nutrientSupplyInfo = [m_nutrientSupplyRateInfoArray objectAtIndex:indexPath.row];
        NSString *nutrientId = [nutrientSupplyInfo objectForKey:@"NutrientID"];
        
        NSDictionary * AllNutrient2LevelDict = [[LZGlobal SharedInstance] getAllNutrient2LevelDict];
        NSDictionary *nutrientDict = [AllNutrient2LevelDict objectForKey:nutrientId];
        NSString *nutritionNameShort = [LZUtility getLocalNutrientShortName:nutrientDict];

        cell.nutrientId = nutrientId;
        
        [cell.nutritionNameLabel setText:nutritionNameShort];
        
        NSNumber *percent = [nutrientSupplyInfo objectForKey:@"nutrientSupplyRate"];
        float progress = [percent floatValue]>1.f ? 1.f :[percent floatValue];
        NSNumber *nm_nutrientSupply = m_nutrientSupplyDict[nutrientId];
        NSNumber *nutrientDRI = [m_DRIsDict objectForKey:nutrientId];
        NSString *unit = [nutrientDict objectForKey:COLUMN_NAME_NutrientEnUnit];
        
        UIColor *fillColor = [LZUtility getNutrientColorForNutrientId:nutrientId];
        
        [cell.nutritionProgressView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [cell.nutritionProgressView.layer setBorderWidth:0.5f];
        [cell.nutritionProgressView drawProgress_with_backgroundColor:[UIColor whiteColor] fillColor:fillColor progress:progress withBackRadius:0.f fillRadius:0.f];
        
//        cell.nutrientSupplyLabel.text = [NSString stringWithFormat:@"%d%%",(int)(floorf([percent floatValue] *100))];
        if ([nutrientId isEqualToString:NutrientId_Cholesterol]){
            cell.nutrientSupplyLabel.text = [NSString stringWithFormat:@" (%.2f/%.2f%@)",[nm_nutrientSupply floatValue],[nutrientDRI floatValue ],unit];
        }else{
            cell.nutrientSupplyLabel.text = [NSString stringWithFormat:@"%d%% (%.2f/%.2f%@)",(int)([percent floatValue] *100),[nm_nutrientSupply floatValue],[nutrientDRI floatValue ],unit];
        }
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if(m_allFoodIdsArray ==nil || [m_allFoodIdsArray count]==0)
        {
            return 76;
        }
        return 60;
    }
    else
        return 42;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (isCapturing)
    {
        return 0;
    }
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (isCapturing) {
        return nil;
    }
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(isCapturing)
    {
        return 0;
    }
    return 32;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (isCapturing) {
        return nil;
    }
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
        sectionTitleLabel.text =  NSLocalizedString(@"listmake_tablesection0_title",@"一天的食物");
    else
        sectionTitleLabel.text =  NSLocalizedString(@"listmake_tablesection1_title",@"一天的营养比例");
    
    return sectionView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO CHECK THE FEATURE
    [self.listView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0)
    {
        if(m_allFoodIdsArray ==nil || [m_allFoodIdsArray count]==0)
        {
            return;
        }
        else
        {
            NSString *foodId  = [m_allFoodIdsArray objectAtIndex:indexPath.row];
            
            NSDictionary *foodAmountInfo = [m_foodAmountInfoDict objectForKey:foodId];
            NSNumber *foodAmount = [foodAmountInfo objectForKey:@"Amount"];
            
            NSDictionary * foodAttr = [m_allRelatedFoodAttrDict objectForKey:foodId];
            
//            [self mergeRecommendFoodsToTakenFoods];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FoodCombinationList" bundle:nil];
            NGFoodDetailController * foodDetailController = [storyboard instantiateViewControllerWithIdentifier:@"NGFoodDetailController"];
            foodDetailController.FoodId = foodId;
            foodDetailController.FoodAttr = foodAttr;
            foodDetailController.FoodAmount = foodAmount;
//            foodDetailController.delegate = self;
            foodDetailController.editDelegate = self;
            foodDetailController.BackToViewControllerWhenFinish = self;
            foodDetailController.isForEdit = true;
            NSMutableDictionary *staticFoodAmountDict2 = [NSMutableDictionary dictionaryWithDictionary:[self getFoodAmountDict]];
            [staticFoodAmountDict2 removeObjectForKey:foodId];
            foodDetailController.staticFoodAmountDict = staticFoodAmountDict2;
            foodDetailController.isCalForAll = true;
//            foodDetailController.editDelegate = self;
            [self.navigationController pushViewController:foodDetailController animated:YES];
            
        }
    }
    else
    {
        [self addFoodForNutrientGroup:indexPath.row];
        
    }
}
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    return NO;
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
//}
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary *takenFoodAmountDict = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserDailyIntakeKey];
//    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]initWithDictionary:takenFoodAmountDict];
//    NSDictionary *aFood = [m_takenFoodIdsArray objectAtIndex:indexPath.row-1];
//    NSString *ndb_No = [aFood objectForKey:@"NDB_No"];
//    [tempDict removeObjectForKey:ndb_No];
//    [[NSUserDefaults standardUserDefaults] setObject:tempDict forKey:LZUserDailyIntakeKey];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    [self refreshFoodNureitentProcessForAll:YES];
//    [[NSNotificationCenter defaultCenter]postNotificationName:Notification_TakenFoodDeletedKey object:nil userInfo:nil];
//}
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"删除";
//}
//- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewCellEditingStyleDelete;
//}


//#pragma mark- NGSelectFoodAmountDelegate
//-(void)didChangeFoodId:(NSString *)foodId toAmount:(NSNumber*)changedValue
//{
//    [self changeToCombinationWithFoodId:foodId andAmount:changedValue];
//}


#pragma mark- Recommend Function
- (IBAction)recommendAction:(id)sender {
//    //弹出选择元素框
//    float duration = 0.5;
//    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
//    NSArray *preferNutrient = [[NSUserDefaults standardUserDefaults]objectForKey:KeyUserRecommendPreferNutrientArray];
//    NSString *title = NSLocalizedString(@"listmake_filterview_title",@"哪些营养素是您重点关注且是不能缺少的，请选择：");
//    LZRecommendFilterView *viewtoAnimate = [[LZRecommendFilterView alloc]initWithFrame:CGRectMake(0, 20, screenSize.width, screenSize.height-20) backColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5] filterInfo:preferNutrient tipsStr:title delegate:self];
//    
//    //LZAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
//    //[appDelegate.window addSubview:viewtoAnimate];
//    [self.navigationController.view addSubview:viewtoAnimate];
//    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//    scale.duration = duration;
//    scale.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:.5f],
//                    [NSNumber numberWithFloat:1.05f],
//                    [NSNumber numberWithFloat:0.95f],
//                    [NSNumber numberWithFloat:1.f],
//                    nil];
//    CAAnimationGroup *group = [CAAnimationGroup animation];
//    group.animations = [NSArray arrayWithArray:[NSArray arrayWithObjects:scale, nil]];
//    group.delegate = nil;
//    group.duration = duration;
//    group.removedOnCompletion = YES;
//    
//    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    [viewtoAnimate.backView.layer addAnimation:group forKey:@"kFTAnimationPopIn"];
    
    HUD.hidden = NO;
    [HUD show:YES];
    //self.listView.hidden = YES;
    
    HUD.labelText = NSLocalizedString(@"listmake_HUDLabel_content",@"智能推荐中...");
    
    [MobClick event:UmengEvent_V2Recommend];
    [self performSelector:@selector(recommendOnePlan) withObject:nil afterDelay:0.01f];
    
}
- (void)recommendOnePlan
{
//    NSMutableDictionary *takenFoodAmountDict = [[NSMutableDictionary alloc]init];
//    for (NSString *foodId in m_allFoodIdsArray)
//    {
//        NSDictionary *aFood = [m_foodAmountInfoDict objectForKey:foodId];
//        NSNumber *weight = [aFood objectForKey:@"Amount"];
//        [takenFoodAmountDict setObject:weight forKey:foodId];
//    }
    [self mergeRecommendFoodsToTakenFoods];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [LZUtility getUserInfo];
    
    BOOL needConsiderNutrientLoss = FALSE;
    //    BOOL needLimitNutrients = FALSE;//not passed from here because here have priority
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
//    if (KeyIsEnvironmentDebug){
//        NSDictionary *flagsDict = [[NSUserDefaults standardUserDefaults]objectForKey:KeyDebugSettingsDict];
//        if (flagsDict.count > 0){
//            //            options = [NSMutableDictionary dictionaryWithDictionary:flagsDict];
//            [options setValuesForKeysWithDictionary:flagsDict];
//            assert([options objectForKey:LZSettingKey_randSeed]!=nil);
//        }
//    }
    
    NSArray *preferNutrient = [userDefaults objectForKey:KeyUserRecommendPreferNutrientArray];
    NSArray *paramArray = [LZUtility convertPreferNutrientArrayToParamArray:preferNutrient];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:paramArray,Key_givenNutrients,nil];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFoodBySmallIncrementWithPreIntake:m_takenFoodAmountDict andUserInfo:userInfo andOptions:options andParams:params];
    NSDictionary *recommendFoodAmountDict = [retDict objectForKey:Key_recommendFoodAmountDict];
    if (recommendFoodAmountDict == nil || [recommendFoodAmountDict count]==0)
    {
        UIAlertView *noRecommendAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alerttitle_wenxintishi",@"温馨提示") message:NSLocalizedString(@"listmake_alert3_message",@"已有的这组食物搭配已经能够满足您所关注的营养需要，如需另行推荐，您可以通过左右滑动来删掉一些食物再使用推荐功能。") delegate:nil cancelButtonTitle:NSLocalizedString(@"zhidaolebutton",@"知道了") otherButtonTitles: nil];
        [noRecommendAlert show];
        [HUD hide:YES];
        self.listView.hidden = NO;
        return;
    }
//    [m_recommendFoodAmountDict_ForDisplay removeAllObjects];//already removed all when merging
    [m_recommendFoodAmountDict_ForDisplay addEntriesFromDictionary:recommendFoodAmountDict];
//    [userDefaults setObject:takenFoodAmountDict forKey:LZUserDailyIntakeKey];
//    [userDefaults synchronize];

    [HUD hide:YES];
    self.listView.hidden = NO;
    [self refreshFoodNureitentProcessForAll:YES];
    [self.listView setContentOffset:CGPointMake(0, 0) animated:NO];
    
    
}

#pragma mark- LZRecommendFilterViewDelegate
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
- (void)filterViewSubmitted:(LZRecommendFilterView *)filterView
{
//    [MobClick event:UmengEventTuiJian];
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
    
    HUD.labelText = NSLocalizedString(@"listmake_HUDLabel_content",@"智能推荐中...");
    
    [self performSelector:@selector(recommendOnePlan) withObject:nil afterDelay:0.f];
    
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
//    [self mergeRecommendFoodsToTakenFoods];
    
    needRefresh = YES;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FoodCombinationList" bundle:nil];
    NGFoodsByClassSearchViewController *foodSearchViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGFoodsByClassSearchViewController"];
    foodSearchViewController.isFromOut = NO;
    foodSearchViewController.editDelegate = self;
    [self.navigationController pushViewController:foodSearchViewController animated:YES];
    
    [MobClick event:UmengEvent_V2AddByClassSearchButton];
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
- (void)addFoodForNutrientGroup:(int)indexInGroup
{
//    [self mergeRecommendFoodsToTakenFoods];
    
    needRefresh = YES;
    
    NSDictionary *nutrient = [m_nutrientSupplyRateInfoArray objectAtIndex:indexInGroup];
    NSString *nutrientId = [nutrient objectForKey:@"NutrientID"];
    if ([nutrientId isEqualToString:NutrientId_Water] || [nutrientId isEqualToString:NutrientId_Cholesterol]) {
        UIAlertView *infoAlert ;
        if ([nutrientId isEqualToString:NutrientId_Water]){
            infoAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alerttitle_wenxintishi",@"提示") message:NSLocalizedString(@"alertmessage_bestfoodbewater",@"最好的食物是水") delegate:nil cancelButtonTitle:NSLocalizedString(@"zhidaolebutton",@"知道了") otherButtonTitles:nil];
        }else{
            infoAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alerttitle_wenxintishi",@"提示") message:NSLocalizedString(@"alertmessage_take_as_small",@"摄入得越少越好") delegate:nil cancelButtonTitle:NSLocalizedString(@"zhidaolebutton",@"知道了") otherButtonTitles:nil];
        }
        
        [infoAlert show];
        
        return;
    }
    
    NSNumber *nmNutrientDRI = m_DRIsDict[nutrientId];
    NSNumber *nmNutrientSuppliedAmount = m_nutrientSupplyDict[nutrientId];
    double dNutrientLackVal = [nmNutrientDRI doubleValue] - [nmNutrientSuppliedAmount doubleValue];
    if (dNutrientLackVal<0)
        dNutrientLackVal = 0;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FoodCombinationList" bundle:nil];
    NGFoodsByNutrientViewController *addByNutrientController = [storyboard instantiateViewControllerWithIdentifier:@"NGFoodsByNutrientViewController"];
    addByNutrientController.NutrientId = nutrientId;
    addByNutrientController.NutrientAmount = [NSNumber numberWithDouble:dNutrientLackVal];
    addByNutrientController.editDelegate = self;
    [self.navigationController pushViewController:addByNutrientController animated:YES];
    
    [MobClick event:UmengEvent_V2AddByNutrientButton];
}
- (IBAction)addFoodByNutrient:(UIButton *)sender {
    int tag = sender.tag;
    [self performSelector:@selector(addFoodForNutrientGroup:) withObject:[NSNumber numberWithInt:tag] afterDelay:0.f];
    
    
}
//- (IBAction)clearFoodAction:(id)sender {
//    NSDictionary *nutrient = [m_nutrientSupplyRateInfoArray objectAtIndex:1];
//    [m_nutrientSupplyRateInfoArray removeObjectAtIndex:1];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
//
//    NSArray *deleteArray = [NSArray arrayWithObject:indexPath];
//    [self.listView beginUpdates];
//    [self.listView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationLeft];
//    [self.listView endUpdates];
//
//
//    [m_nutrientSupplyRateInfoArray insertObject:nutrient atIndex:0];
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
    if([m_allFoodIdsArray count] == 0)
    {
        UIAlertView *foodEmptyAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alerttitle_wenxintishi",@"温馨提示") message:NSLocalizedString(@"listmake_alert4_message",@"食物列表还是空的呢，马上添加食物或点击推荐吧!") delegate:nil cancelButtonTitle:NSLocalizedString(@"zhidaolebutton",@"知道了") otherButtonTitles:nil];
        [foodEmptyAlert show];
        return;
    }
    UIActionSheet *shareSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"listmake_actionsheet0_title",@"分享到") delegate:self cancelButtonTitle:NSLocalizedString(@"quxiaobutton",@"取消") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"listmake_actionsheet0_button1",@"新浪微博"),NSLocalizedString(@"listmake_actionsheet0_button2",@"微信好友"),NSLocalizedString(@"listmake_actionsheet0_button3",@"微信朋友圈"), nil];
    //[shareSheet showInView:self.view];
    [shareSheet showInView:[UIApplication sharedApplication].keyWindow];
}
//-(NSString *)getShareContentsForShareType:(ShareType)type
//{
//    if(type == ShareTypeSinaWeibo)
//    {
////        if ([m_takenFoodIdsArray count]!= 0)
////        {
////            NSString *contents = @"@买菜助手(http://t.cn/zHuwJxz )为我精心推荐:";
////            for (NSString *foodId in m_takenFoodIdsArray)
////            {
////                NSDictionary *aFood = [m_foodAmountInfoDict objectForKey:foodId];
////                NSString *name = [aFood objectForKey:@"Name"];
////                NSNumber *weight = [aFood objectForKey:@"Amount"];
////                contents = [contents stringByAppendingFormat:@"\n%@ %dg",name,[weight intValue]];
////            }
////            return contents;
////        }
////        else
////        {
//        NSString *contents = [NSString stringWithFormat:NSLocalizedString(@"listmake_weiboshare_content",@"我用@营养膳食指南%@挑选出了一组含全面丰富营养的食物搭配, 羡慕吧? 快来试试吧!"),@"(http://t.cn/zH1gxw5 )"];
//            return contents;
////        }
//    }
//    else //微信好友 或者微信朋友圈
//    {
////        if ([m_takenFoodIdsArray count]!= 0)
////        {
////            NSString *contents = @"买菜助手(http://t.cn/zHuwJxz )为我推荐了:";
////            for (NSString *foodId in m_takenFoodIdsArray)
////            {
////                NSDictionary *aFood = [m_foodAmountInfoDict objectForKey:foodId];
////                NSString *name = [aFood objectForKey:@"Name"];
////                NSNumber *weight = [aFood objectForKey:@"Amount"];
////                contents = [contents stringByAppendingFormat:@"\n%@ %dg",name,[weight intValue]];
////            }
////            contents = [contents stringByAppendingString:@"\n你也来试试吧!"];//:@"\n%@ %dg",name,[weight intValue]];
////            return contents;
////        }
////        else
////        {
//        NSString *contents = [NSString stringWithFormat:NSLocalizedString(@"listmake_wechatshare_content",@"我用 营养膳食指南%@ 挑选出了一组含全面丰富营养的食物搭配, 羡慕吧? 快来试试吧!"),@"(http://t.cn/zH1gxw5 )"];
//            return contents;
////        }
//
//    }
//}
-(NSData *)getShareData
{
    if (isCapturing)
    {
        return nil;
    }
    else
    {
        isCapturing = YES;
        self.listView.userInteractionEnabled = NO;
        self.listView.tableFooterView.hidden=YES;
        [self.listView reloadData];
        CGPoint offset = [self.listView contentOffset];
        self.listView.contentOffset = CGPointMake(0.0, 0.0);
        
        CGRect visibleRect = self.listView.bounds;
        
        UIGraphicsBeginImageContextWithOptions(self.listView.contentSize, self.listView.opaque, 0.0);
        
        [self.listView.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        while (self.listView.contentSize.height>= (visibleRect.origin.y+visibleRect.size.height)) {
            
            visibleRect.origin.y += visibleRect.size.height;
            
            [self.listView scrollRectToVisible:visibleRect animated:NO];
            [self.listView.layer renderInContext:UIGraphicsGetCurrentContext()];
        }
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *lowQualityData = UIImageJPEGRepresentation(image, 0.1);
        image =nil;
        //UIImage *lowImage = [UIImage imageWithData:lowQualityData scale:0.1]; scale do nothing
        self.listView.contentOffset = offset;
        isCapturing = NO;
        [self.listView reloadData];
        self.listView.tableFooterView.hidden=NO;
        self.listView.userInteractionEnabled = YES;
        if (lowQualityData)
        {
            return lowQualityData;
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"alertmessage_tryagain",@"出现了错误，请重试") delegate:nil cancelButtonTitle:NSLocalizedString(@"zhidaolebutton",@"知道了") otherButtonTitles: nil];
            [alert show];
            return nil;
        }
        //UIImageWriteToSavedPhotosAlbum(lowImage, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
        
    }
    
}
//- (void)shareRecommendContentForType:(ShareType)type
//{
//    if(type == ShareTypeWeixiSession || type == ShareTypeWeixiTimeline)
//    {
////        if ([WXApi isWXAppInstalled])
////        {
//            NSData *shareData = [self getShareData];
//            //isWXAppInstalled
//            //getWXAppInstallUrl
//            if(shareData)
//            {
//                NSString *contents = [self getShareContentsForShareType:type];
//                UIImage *shareImage = [UIImage imageWithData:shareData];
//                id<ISSContent> content = [ShareSDK content:contents
//                                            defaultContent:@"default"
//                                                     image:[ShareSDK jpegImageWithImage:shareImage quality:0.1]
//                                                     title:@"title"
//                                                       url:nil
//                                               description:@"description"
//                                                 mediaType:SSPublishContentMediaTypeImage];
//                shareImage = nil;
//                [content addWeixinSessionUnitWithType:INHERIT_VALUE
//                                              content:contents
//                                                title:@"title"
//                                                  url:INHERIT_VALUE
//                                                image:INHERIT_VALUE
//                                         musicFileUrl:nil
//                                              extInfo:nil
//                                             fileData:nil
//                                         emoticonData:nil];
//
//                id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
//                                                                     allowCallback:YES
//                                                                     authViewStyle:SSAuthViewStyleFullScreenPopup
//                                                                      viewDelegate:nil
//                                                           authManagerViewDelegate:nil];
//                [ShareSDK shareContent:content
//                                  type:type
//                           authOptions:authOptions
//                         statusBarTips:YES
//                                result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                    if (state == SSPublishContentStateSuccess)
//                                    {
////                                        NSLog(@"success");
//                                    }
//                                    else if (state == SSPublishContentStateFail)
//                                    {
//                                        if ([error errorCode] == -22003)
//                                        {
//                                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"listmake_alert6_title",@"分享失败")
//                                                                                                message:[error errorDescription]
//                                                                                               delegate:nil
//                                                                                      cancelButtonTitle:NSLocalizedString(@"zhidaolebutton",@"知道了")
//                                                                                      otherButtonTitles:nil];
//                                            [alertView show];
//
//                                        }
//                                    }
//                                }];
//                }
//
////        }
////        else
////        {
////            [self popWeiChatInstallAlert];
////        }
//    }
//    else if (type == ShareTypeSinaWeibo)
//    {
//       // UIImageJPEGRepresentation
//        NSData *shareData = [self getShareData];
//        if(shareData)
//        {
//            if ([ShareSDK hasAuthorizedWithType:type])
//            {
//                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//
//                LZShareViewController *shareViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZShareViewController"];
//                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:shareViewController];
//                NSString *contents = [self getShareContentsForShareType:type ];
//                shareViewController.preInsertText = contents;
//                shareViewController.shareImageData = shareData;
//                [self presentModalViewController:nav animated:YES];
//            }
//            else
//            {
//                id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
//                                                                     allowCallback:YES
//                                                                     authViewStyle:SSAuthViewStyleFullScreenPopup
//                                                                      viewDelegate:nil
//                                                           authManagerViewDelegate:nil];
////                [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
////                                                //[ShareSDK userFieldWithType:SSUserFieldTypeName valeu:@"营养膳食指南"],
////                                                SHARE_TYPE_NUMBER(type),
////                                                //[ShareSDK userFieldWithType:SSUserFieldTypeName valeu:@"ShareSDK"],
////                                                //SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
////                                                nil]];
//                [ShareSDK authWithType:type options:authOptions result:^(SSAuthState state, id<ICMErrorInfo> error) {
//                    if (state == SSAuthStateSuccess)
//                    {
//                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//                        LZShareViewController *shareViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZShareViewController"];
//                        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:shareViewController];
//                        NSString * contents = [self getShareContentsForShareType:type];
//                        shareViewController.preInsertText = contents;
//                        shareViewController.shareImageData = shareData;
//                        [self presentModalViewController:nav animated:YES];
//                    }
//                    //NSLog(@"ssauthState %d",state);
//                }];
//
//            }
//        }
//
//    }
//
//}
//- (void)popWeiChatInstallAlert
//{
//    UIAlertView *insallWeichatAlert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"还没有安装微信，立即下载?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    insallWeichatAlert.tag = KInstallWechatAlertTag;
//    [insallWeichatAlert show];
//}
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{

    if(alertView.tag == KSaveDietTitleAlertTag)
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
                UIAlertView *invalidNameAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alerttitle_wenxintishi",@"温馨提示") message:NSLocalizedString(@"listmake_alert7_message",@"您输入的名称不规范，请重新输入") delegate:nil cancelButtonTitle:NSLocalizedString(@"zhidaolebutton",@"知道了" )otherButtonTitles: nil];
                [invalidNameAlert show];
                return;
            }
            LZDataAccess *da = [LZDataAccess singleton];
            NSMutableArray * foodAndAmountArray = [NSMutableArray array];
            for (NSString *foodId in m_allFoodIdsArray)
            {
                NSDictionary *aFood = [m_foodAmountInfoDict objectForKey:foodId];
                NSNumber *weight = [aFood objectForKey:@"Amount"];
                [foodAndAmountArray addObject:[NSArray arrayWithObjects:foodId, weight,nil]];
            }
            NSNumber *nmCollocationId = [da insertFoodCollocationData_withCollocationName:collocationName andCreateTime:0 andCollocationId:nil andFoodAmount2LevelArray:foodAndAmountArray andFoodCollocationParamNameValueDict:nil];
            if(nmCollocationId)
            {
//                NSDictionary *emptyIntake = [[NSDictionary alloc]init];
//                [[NSUserDefaults standardUserDefaults] setObject:emptyIntake forKey:LZUserDailyIntakeKey];
//                [[NSUserDefaults standardUserDefaults]synchronize];
                [LZUtilityParse saveParseObject_FoodCollocationData_withCollocationId:nmCollocationId];
                
                [self.navigationController  popViewControllerAnimated:!backWithNoAnimation];
            }
            else
            {
                UIAlertView *saveFailedAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"listmake_alert8_title",@"保存失败") message:NSLocalizedString(@"alertmessage_tryagain",@"出现了错误，请重试") delegate:nil cancelButtonTitle:NSLocalizedString(@"zhidaolebutton",@"知道了") otherButtonTitles:nil];
                [saveFailedAlert show];
            }
        }
    }
    else if(alertView.tag == KInstallWechatAlertTag)
    {
//        if (buttonIndex == alertView.cancelButtonIndex)
//        {
//            return;
//        }
//        else
//        {
//            NSString *weichatURL =[WXApi getWXAppInstallUrl];
//            NSURL *ourAppUrl = [ [ NSURL alloc ] initWithString: weichatURL ];
//            [[UIApplication sharedApplication] openURL:ourAppUrl];
//        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //     if(buttonIndex == actionSheet.cancelButtonIndex)
    //    {
    //        return;
    //    }
    //    else if (buttonIndex == 0)//weibo
    //    {
    //        [self shareRecommendContentForType:ShareTypeSinaWeibo];
    //    }
    //    else if (buttonIndex == 1)//微信好友
    //    {
    //        [self shareRecommendContentForType:ShareTypeWeixiSession];
    //    }
    //    else//朋友圈
    //    {
    //        [self shareRecommendContentForType:ShareTypeWeixiTimeline];
    //    }
    
}
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
    HUD.hidden = YES;
}

@end

