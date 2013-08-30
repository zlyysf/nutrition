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
#import "LZFoodSearchViewController.h"
#define KChangeFoodAmountAlertTag 101
#define KSaveDietTitleAlertTag 102
#define KInstallWechatAlertTag 103
@interface LZDietListMakeViewController ()<MBProgressHUDDelegate,UIActionSheetDelegate,UIAlertViewDelegate,LZRecommendFilterViewDelegate,LZFoodDetailViewControllerDelegate>
{
    MBProgressHUD *HUD;
    BOOL isCapturing;
}

@end

@implementation LZDietListMakeViewController
@synthesize takenFoodIdsArray,takenFoodDict,nutrientInfoArray,needRefresh,listType,takenFoodNutrientInfoDict,recommendFoodDictForDisplay,dietId,allFoodUnitDict,backWithNoAnimation,useRecommendNutrient;
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
    if (useRecommendNutrient)
    {
        self.title = @"推荐的食物";
    }
    else if (self.listType == dietListTypeNew)
    {
        self.title = @"营养搭配";
    }
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.view addSubview:HUD];
    HUD.hidden = YES;
    HUD.delegate = self;
    //self.currentEditFoodId = nil;
	// Do any additional setup after loading the view.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
    UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
    [self.listView setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
    UIImage *buttonImage = [UIImage imageNamed:@"nav_back_button.png"];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setTitle:@"  返回" forState:UIControlStateNormal];

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
    recommendFoodDictForDisplay = [[NSMutableDictionary alloc]init];
    allFoodUnitDict = [[NSMutableDictionary alloc]init];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0,0,
                                                             CGSizeFromGADAdSize(kGADAdSizeBanner).width,
                                                             CGSizeFromGADAdSize(kGADAdSizeBanner).height)];
    self.listView.tableFooterView = footerView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takenFoodChanged:) name:Notification_TakenFoodChangedKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsChanged:) name:Notification_SettingsChangedKey object:nil];
    [self refreshFoodNureitentProcessForAll:YES];
    isCapturing = NO;
}
- (void)cancelButtonTapped
{

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LZUserDailyIntakeKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController  popViewControllerAnimated:!backWithNoAnimation];

}
- (void)saveButtonTapped
{

    if([self.takenFoodIdsArray count] == 0)
    {
        if([self.takenFoodIdsArray count] == 0)
        {
            UIAlertView *foodEmptyAlert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"食物列表还是空的呢，马上添加食物或点击推荐吧!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [foodEmptyAlert show];
            return;
        }
    }
    else
    {
        if (self.listType == dietListTypeNew)
        {
            //新建一个表单，用insert
            NSDate *now = [NSDate date];
            NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans"]];
            [formatter setDateFormat:@"MM月dd号"];
            NSString* time = [formatter stringFromDate:now];
            NSString *text = [NSString stringWithFormat:@"%@的饮食计划",time];
            //7月29号的饮食计划
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"保存食物清单" message:@"给你的食物清单加个名称吧" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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
            for (NSString *foodId in self.takenFoodIdsArray)
            {
                NSDictionary *aFood = [takenFoodDict objectForKey:foodId];
                NSNumber *weight = [aFood objectForKey:@"Amount"];
                [foodAndAmountArray addObject:[NSArray arrayWithObjects:foodId, weight,nil]];
            }
            if([da updateFoodCollocationData_withCollocationId:dietId andNewCollocationName:nil andFoodAmount2LevelArray:foodAndAmountArray])
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:LZUserDailyIntakeKey];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [self.navigationController  popViewControllerAnimated:!backWithNoAnimation];
            }
            else
            {
                UIAlertView *saveFailedAlert = [[UIAlertView alloc]initWithTitle:@"保存失败" message:@"出现了错误，请重试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [saveFailedAlert show];
            }
        }
    }
    //[self.navigationController  popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nutrientShowNotification:) name:Notification_ShowNutrientInfoKey object:nil];
    [MobClick beginLogPageView:@"营养搭配页面"];
    self.listView.tableFooterView.hidden = NO;
    GADMasterViewController *shared = [GADMasterViewController singleton];
    UIView *footerView = self.listView.tableFooterView;
    [shared resetAdView:self andListView:footerView];
    if(needRefresh)
    {
        [self refreshFoodNureitentProcessForAll:YES];
        needRefresh = NO;
    }
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_ShowNutrientInfoKey object:nil];
    [MobClick endLogPageView:@"营养搭配页面"];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_TakenFoodChangedKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_SettingsChangedKey object:nil];
    [self setListView:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)nutrientShowNotification:(NSNotification *)notification
{
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
                            self.recommendFoodDictForDisplay,@"givenFoodsAmount2",
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
//    [takenFoodIdsArray removeAllObjects];
//    if (takenArray1 != nil && [takenArray1 count]!=0) {
//        
//        [takenFoodIdsArray addObjectsFromArray:takenArray1];
//    }
//    if (takenArray2 != nil && [takenArray2 count]!=0) {
//        
//        [takenFoodIdsArray addObjectsFromArray:takenArray2];
//    }
//    NSDictionary *foodUnitDict = [retFmtDict objectForKey:Key_givenFoodAttrDict2Level];
//    [allFoodUnitDict removeAllObjects];
//    if (foodUnitDict != nil )
//    {
//        
//        [allFoodUnitDict addEntriesFromDictionary:foodUnitDict];
//    }
//    
//    
//    NSDictionary *takeDict = [retFmtDict objectForKey:Key_givenFoodInfoDict2Level];
//    [takenFoodDict removeAllObjects];
//    if (takeDict != nil )
//    {
//        
//        [takenFoodDict addEntriesFromDictionary:takeDict];
//    }
//    
//    NSDictionary *takenFoodNutrientDict = [retFmtDict objectForKey:Key_takenFoodNutrientInfoAryDictDict];
//    [takenFoodNutrientInfoDict removeAllObjects];
//    if (takenFoodNutrientDict != nil )
//    {
//        
//        [takenFoodNutrientInfoDict addEntriesFromDictionary:takenFoodNutrientDict];
//    }
//    
//    NSArray *nutrientArray = [retFmtDict objectForKey:Key_nutrientSupplyRateInfoArray];
//    [nutrientInfoArray removeAllObjects];
//    if (nutrientArray != nil && [nutrientArray count]!=0) {
//        
//        [nutrientInfoArray addObjectsFromArray:nutrientArray];
//    }
//    
//    [self.listView reloadData];
//    
//}
- (void)deleteOneCell:(NSString *)foodId
{
    //NSString *foodId = cell.cellFoodId;
    NSDictionary *cellInfoDict = [self.takenFoodDict objectForKey:foodId];
    int index = [self.takenFoodIdsArray indexOfObject:foodId];
    if (index >= 0 && index < [self.takenFoodIdsArray count])
    {
        NSIndexPath *indexPathToDelete = [NSIndexPath indexPathForRow:index inSection:0];
        
        NSDictionary *takenFoodAmountDict = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserDailyIntakeKey];
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]initWithDictionary:takenFoodAmountDict];
        NSString *ndb_No = [cellInfoDict objectForKey:@"NDB_No"];
        [tempDict removeObjectForKey:ndb_No];
        [self.recommendFoodDictForDisplay removeObjectForKey:ndb_No];
        [[NSUserDefaults standardUserDefaults] setObject:tempDict forKey:LZUserDailyIntakeKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
        //[self displayTakenFoodResult];
        [[NSNotificationCenter defaultCenter]postNotificationName:Notification_TakenFoodDeletedKey object:nil userInfo:nil];
        [self.takenFoodIdsArray removeObjectAtIndex:index];
        NSArray *array = [[NSArray alloc]initWithObjects:indexPathToDelete, nil];
        self.listView.userInteractionEnabled = NO;
        if ([self.takenFoodIdsArray count]== 0)
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
            [self.recommendFoodDictForDisplay removeObjectForKey:ndb_No];
            [[NSUserDefaults standardUserDefaults] setObject:tempDict forKey:LZUserDailyIntakeKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
            //[self displayTakenFoodResult];
            [[NSNotificationCenter defaultCenter]postNotificationName:Notification_TakenFoodDeletedKey object:nil userInfo:nil];
            [self.takenFoodIdsArray removeObjectAtIndex:index];
            NSArray *array = [[NSArray alloc]initWithObjects:indexPathToDelete, nil];
            self.listView.userInteractionEnabled = NO;
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
            self.listView.userInteractionEnabled = YES;
            [self refreshFoodNureitentProcessForAll:NO];
        }
    }
}
//-(void)editFoodButtonTapped:(LZEditFoodAmountButton*)sender
//{
//    NSString *foodId = sender.foodId;
//    //NSDictionary *cellInfoDict = [self.takenFoodDict objectForKey:foodId];
//    currentEditFoodId = foodId;
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"更改食物量" message:@"请输入更适合你的食物量" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//    alert.tag = KChangeFoodAmountAlertTag;
//    UITextField *tf = [alert textFieldAtIndex:0];
//    tf.keyboardType = UIKeyboardTypeNumberPad;
//    [alert show];
//}
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
//    int i = [self.takenFoodIdsArray indexOfObject:foodId];
//    NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
//
//    if ([foodNumber length]==0)
//    {
//        LZRecommendFoodCell* cell =(LZRecommendFoodCell*)[self.listView cellForRowAtIndexPath:index];
//        NSDictionary *aFood = [takenFoodDict objectForKey:foodId];
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
//        else if ([self.recommendFoodDictForDisplay objectForKey:foodId])
//        {
//            if (changed <=0)
//            {
//                [self.recommendFoodDictForDisplay removeObjectForKey:foodId];
//            }
//            else
//            {
//                [self.recommendFoodDictForDisplay setObject:[NSNumber numberWithInt:changed] forKey:foodId];
//            }
//            
//        }
//        LZRecommendFoodCell* cell =(LZRecommendFoodCell*)[self.listView cellForRowAtIndexPath:index];
//        NSDictionary *aFood = [takenFoodDict objectForKey:foodId];
//        NSNumber *weight = [NSNumber numberWithInt:changed];
//        cell.foodUnitLabel.text = [NSString stringWithFormat:@"%dg",[weight intValue]];
//        NSDictionary *foodAtr = [allFoodUnitDict objectForKey:foodId];
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
//    int i = [self.takenFoodIdsArray indexOfObject:foodId];
//    NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 50 * USEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//    [self.listView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//    });
//}
#pragma mark- TableView Delegate
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
                cell.contentLabel.text = @"我们app的作用是帮您找到适合您一天的各营养需要量的食物搭配，您可以通过我们的推荐功能快速得到，也可以加入自己的选择以找到最适合您的方案。";
                return cell;
            }
            else
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
                    int unitCount = (int)((float)([weight floatValue]/[singleUnitWeight floatValue])+0.5);
                    if (unitCount <= 0)
                    {
                        foodTotalUnit = @"";
                    }
                    else
                    {
                        foodTotalUnit = [NSString stringWithFormat:@"(%d%@)",unitCount,singleUnitName];
                    }
                }
                NSString *foodName = [aFood objectForKey:@"Name"];
                cell.foodNameLabel.text = [NSString stringWithFormat:@"%@ %@",foodName,foodTotalUnit];
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
        [cell.nutritionProgressView drawProgressForRect:CGRectMake(2,2,196,14) backgroundColor:[UIColor whiteColor] fillColor:fillColor progress:progress withBackRadius:7.f fillRadius:radius];
        [cell adjustLabelAccordingToProgress:progress forLabelWidth:196];
        //[cell.backView setBackgroundColor:[UIColor clearColor]];
//        if (KeyIsEnvironmentDebug)
//        {
            cell.supplyPercentlabel.text = [NSString stringWithFormat:@"%d%%",(int)(floorf([percent floatValue] *100))];
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
    {
        if(takenFoodIdsArray ==nil || [takenFoodIdsArray count]==0)
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
        sectionTitleLabel.text =  @"一天的食物";
    else
        sectionTitleLabel.text =  @"一天的营养比例";
    
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
            NSDictionary * foodAtr = [allFoodUnitDict objectForKey:ndb_No];
            //NSArray *nutrientSupplyArr = [[takenFoodNutrientInfoDict objectForKey:Key_foodSupplyNutrientInfoAryDict]objectForKey:ndb_No];
            //NSArray *nutrientStandardArr = [[takenFoodNutrientInfoDict objectForKey:Key_foodStandardNutrientInfoAryDict]objectForKey:ndb_No];
            NSString *foodName = [aFood objectForKey:@"Name"];
            NSNumber *weight = [aFood objectForKey:@"Amount"];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            LZFoodDetailController * foodDetailController = [storyboard instantiateViewControllerWithIdentifier:@"LZFoodDetailController"];

            NSString *singleUnitName = [foodAtr objectForKey:COLUMN_NAME_SingleItemUnitName];
            NSNumber *upper = [NSNumber numberWithInt:1000];//[foodAtr objectForKey:COLUMN_NAME_Upper_Limit];
            if ([weight intValue]>= [upper intValue])
            {
                upper = weight;
            }
            foodDetailController.gUnitMaxValue = upper;
            
            if ([singleUnitName length]==0)
            {
                foodDetailController.isUnitDisplayAvailable = NO;
            }
            else
            {
                foodDetailController.isUnitDisplayAvailable = YES;
                foodDetailController.unitName = singleUnitName;
                NSNumber *singleUnitWeight = [foodAtr objectForKey:COLUMN_NAME_SingleItemUnitWeight];
//                if ([LZUtility isUseUnitDisplay:weight unitWeight:singleUnitWeight])
//                {
//                    foodDetailController.isDefaultUnitDisplay = YES;
//                }
//                else
//                {
//                    foodDetailController.isDefaultUnitDisplay = NO;
//                }
                foodDetailController.isDefaultUnitDisplay = NO;
                int maxCount = (int)(ceilf(([upper floatValue]*2)/[singleUnitWeight floatValue]));
//                if (maxCount <20)
//                {
//                    foodDetailController.unitMaxValue = [NSNumber numberWithInt:20];
//                }
//                else
//                {
                    foodDetailController.unitMaxValue = [NSNumber numberWithInt:maxCount];
                //}
            }
            NSMutableDictionary *takenFoodAmountDict = [[NSMutableDictionary alloc]init];
            for (NSString *foodId in self.takenFoodIdsArray)
            {
                NSDictionary *aaFood = [takenFoodDict objectForKey:foodId];
                NSNumber *aWeight = [aaFood objectForKey:@"Amount"];
                [takenFoodAmountDict setObject:aWeight forKey:foodId];
            }
            [takenFoodAmountDict removeObjectForKey:ndb_No];
            foodDetailController.currentSelectValue = weight;
            foodDetailController.defaulSelectValue = weight;
            foodDetailController.foodAttr = foodAtr;
            foodDetailController.foodName = foodName;
            foodDetailController.delegate = self;
            foodDetailController.isForEdit = YES;
            foodDetailController.isCalForAll = YES;
            foodDetailController.staticFoodAmountDict = takenFoodAmountDict;
            foodDetailController.GUnitStartIndex = 100;
            //UINavigationController *initialController = (UINavigationController*)[UIApplication
                                                                                  //sharedApplication].keyWindow.rootViewController;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:foodDetailController];
            [self presentModalViewController:nav animated:YES];
        }
    }
    else
    {
        NSMutableDictionary *takenFoodAmountDict = [[NSMutableDictionary alloc]init];
        for (NSString *foodId in self.takenFoodIdsArray)
        {
            NSDictionary *aFood = [takenFoodDict objectForKey:foodId];
            NSNumber *weight = [aFood objectForKey:@"Amount"];
            [takenFoodAmountDict setObject:weight forKey:foodId];
        }
        [recommendFoodDictForDisplay removeAllObjects];
        [[NSUserDefaults standardUserDefaults] setObject:takenFoodAmountDict forKey:LZUserDailyIntakeKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
        needRefresh = YES;
        
        NSDictionary *nutrient = [nutrientInfoArray objectAtIndex:indexPath.row];
        NSString *nutrientName = [nutrient objectForKey:@"Name"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        LZAddByNutrientController *addByNutrientController = [storyboard instantiateViewControllerWithIdentifier:@"LZAddByNutrientController"];
        addByNutrientController.nutrientDict = nutrient;
        addByNutrientController.nutrientTitle = nutrientName;
        [self.navigationController pushViewController:addByNutrientController animated:YES];
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
//    NSDictionary *aFood = [takenFoodIdsArray objectAtIndex:indexPath.row-1];
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
#pragma mark- LZFoodDetailViewControllerDelegate
-(void)didChangeFoodId:(NSString *)foodId toAmount:(NSNumber*)changedValue
{
    int i = [self.takenFoodIdsArray indexOfObject:foodId];
    NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
    
    if (changedValue == nil)
    {
        LZRecommendFoodCell* cell =(LZRecommendFoodCell*)[self.listView cellForRowAtIndexPath:index];
        NSDictionary *aFood = [takenFoodDict objectForKey:foodId];
        NSNumber *weight = [aFood objectForKey:@"Amount"];
        cell.foodUnitLabel.text = [NSString stringWithFormat:@"%dg",[weight intValue]];
    }
    else
    {
        
        int changed = [changedValue intValue];
        if (changed <=0)
        {
            [self deleteOneCell:foodId];
            return;
        }
        NSDictionary* takenDict =  [[NSUserDefaults standardUserDefaults]objectForKey:LZUserDailyIntakeKey];
        if ([takenDict objectForKey:foodId])
        {
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:takenDict];
            
            if (changed <=0)
            {
                [tempDict removeObjectForKey:foodId];
            }
            else
            {
                [tempDict setObject:[NSNumber numberWithInt:changed] forKey:foodId];
            }
            [[NSUserDefaults standardUserDefaults]setObject:tempDict forKey:LZUserDailyIntakeKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }
        else if ([self.recommendFoodDictForDisplay objectForKey:foodId])
        {
            if (changed <=0)
            {
                [self.recommendFoodDictForDisplay removeObjectForKey:foodId];
            }
            else
            {
                [self.recommendFoodDictForDisplay setObject:[NSNumber numberWithInt:changed] forKey:foodId];
            }
            
        }
        LZRecommendFoodCell* cell =(LZRecommendFoodCell*)[self.listView cellForRowAtIndexPath:index];
        NSDictionary *aFood = [takenFoodDict objectForKey:foodId];
        NSNumber *weight = [NSNumber numberWithInt:changed];
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
            int unitCount = (int)((float)([weight floatValue]/[singleUnitWeight floatValue])+0.5);
            if (unitCount <= 0)
            {
                foodTotalUnit = @"";
            }
            else
            {
                foodTotalUnit = [NSString stringWithFormat:@"(%d%@)",unitCount,singleUnitName];
            }
        }
        NSString *foodName = [aFood objectForKey:@"Name"];
        cell.foodNameLabel.text = [NSString stringWithFormat:@"%@ %@",foodName,foodTotalUnit];
        
        [self refreshFoodNureitentProcessForAll:NO];
    }

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
- (void)recommendOnePlan
{
    NSMutableDictionary *takenFoodAmountDict = [[NSMutableDictionary alloc]init];
    for (NSString *foodId in self.takenFoodIdsArray)
    {
        NSDictionary *aFood = [takenFoodDict objectForKey:foodId];
        NSNumber *weight = [aFood objectForKey:@"Amount"];
        [takenFoodAmountDict setObject:weight forKey:foodId];
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
    if (KeyIsEnvironmentDebug){
        NSDictionary *flagsDict = [[NSUserDefaults standardUserDefaults]objectForKey:KeyDebugSettingsDict];
        if (flagsDict.count > 0){
//            options = [NSMutableDictionary dictionaryWithDictionary:flagsDict];
            [options setValuesForKeysWithDictionary:flagsDict];
            assert([options objectForKey:LZSettingKey_randSeed]!=nil);
        }
    }
    
    NSArray *preferNutrient = [userDefaults objectForKey:KeyUserRecommendPreferNutrientArray];
    NSArray *paramArray = [LZUtility convertPreferNutrientArrayToParamArray:preferNutrient];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:paramArray,Key_givenNutrients,nil];

    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFoodBySmallIncrementWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andOptions:options andParams:params];
    NSDictionary *recommendFoodAmountDict = [retDict objectForKey:Key_recommendFoodAmountDict];
    if (recommendFoodAmountDict == nil || [recommendFoodAmountDict count]==0)
    {
        UIAlertView *noRecommendAlert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"已有的这组食物搭配已经能够满足您所关注的营养需要，如需另行推荐，您可以通过左右滑动来删掉一些食物再使用推荐功能。" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [noRecommendAlert show];
        [HUD hide:YES];
        self.listView.hidden = NO;
        return;
    }
    [recommendFoodDictForDisplay removeAllObjects];
    [recommendFoodDictForDisplay addEntriesFromDictionary:recommendFoodAmountDict];
    [userDefaults setObject:takenFoodAmountDict forKey:LZUserDailyIntakeKey];
    
    [userDefaults synchronize];
    //    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
    //                            userInfo,@"userInfo",
    //                            takenFoodAmountDict,@"givenFoodsAmount1",
    //                            recommendFoodAmountDict,@"givenFoodsAmount2",
    //                            nil];
    //NSDictionary * formatResult = [rf calculateGiveFoodsSupplyNutrientAndFormatForUI:params];
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
- (void)filterViewSubmitted:(LZRecommendFilterView *)filterView
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
    
    NSMutableDictionary *takenFoodAmountDict = [[NSMutableDictionary alloc]init];
    for (NSString *foodId in self.takenFoodIdsArray)
    {
        NSDictionary *aFood = [takenFoodDict objectForKey:foodId];
        NSNumber *weight = [aFood objectForKey:@"Amount"];
        [takenFoodAmountDict setObject:weight forKey:foodId];
    }
    [recommendFoodDictForDisplay removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:takenFoodAmountDict forKey:LZUserDailyIntakeKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    needRefresh = YES;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    
//    LZAddFoodViewController *addFoodViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZAddFoodViewController"];
    //UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:addFoodViewController];
//    [self.navigationController pushViewController:addFoodViewController animated:YES];
    
    
    LZFoodSearchViewController *foodSearchViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZFoodSearchViewController"];
    foodSearchViewController.isFromOut = NO;
    [self.navigationController pushViewController:foodSearchViewController animated:YES];
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
    NSMutableDictionary *takenFoodAmountDict = [[NSMutableDictionary alloc]init];
    for (NSString *foodId in self.takenFoodIdsArray)
    {
        NSDictionary *aFood = [takenFoodDict objectForKey:foodId];
        NSNumber *weight = [aFood objectForKey:@"Amount"];
        [takenFoodAmountDict setObject:weight forKey:foodId];
    }
    [recommendFoodDictForDisplay removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:takenFoodAmountDict forKey:LZUserDailyIntakeKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    needRefresh = YES;
        
    NSDictionary *nutrient = [nutrientInfoArray objectAtIndex:tag];
    NSString *nutrientName = [nutrient objectForKey:@"Name"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZAddByNutrientController *addByNutrientController = [storyboard instantiateViewControllerWithIdentifier:@"LZAddByNutrientController"];
    addByNutrientController.nutrientDict = nutrient;
    addByNutrientController.nutrientTitle = nutrientName;
    [self.navigationController pushViewController:addByNutrientController animated:YES];
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
    if([self.takenFoodIdsArray count] == 0)
    {
        UIAlertView *foodEmptyAlert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"食物列表还是空的呢，马上添加食物或点击推荐吧!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [foodEmptyAlert show];
        return;
    }
    UIActionSheet *shareSheet = [[UIActionSheet alloc]initWithTitle:@"分享到" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博",@"微信好友",@"微信朋友圈", nil];
    [shareSheet showInView:self.view];
}
//- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
//    NSString *message;
//    NSString *title;
//    if (!error) {
//        title = NSLocalizedString(@"储存成功", @"");
//        message = NSLocalizedString(@"您的图片已正确的储存至照片数据", @"");
//    }
//    else {
//        title = NSLocalizedString(@"储存失败", @"");
//        message = [error description];
//    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                    message:message
//                                                   delegate:nil
//                                          cancelButtonTitle:NSLocalizedString(@"好", @"")
//                                          otherButtonTitles:nil];
//    [alert show];
//}
-(NSString *)getShareContentsForShareType:(ShareType)type
{
    if(type == ShareTypeSinaWeibo)
    {
//        if ([takenFoodIdsArray count]!= 0)
//        {
//            NSString *contents = @"@买菜助手(http://t.cn/zHuwJxz )为我精心推荐:";
//            for (NSString *foodId in takenFoodIdsArray)
//            {
//                NSDictionary *aFood = [takenFoodDict objectForKey:foodId];
//                NSString *name = [aFood objectForKey:@"Name"];
//                NSNumber *weight = [aFood objectForKey:@"Amount"];
//                contents = [contents stringByAppendingFormat:@"\n%@ %dg",name,[weight intValue]];
//            }
//            return contents;
//        }
//        else
//        {
            NSString *contents = @"我用@营养膳食指南(http://t.cn/zH1gxw5 )挑选出了一组含全面丰富营养的食物搭配, 羡慕吧? 快来试试吧!";
            return contents;
//        }
    }
    else //微信好友 或者微信朋友圈
    {
//        if ([takenFoodIdsArray count]!= 0)
//        {
//            NSString *contents = @"买菜助手(http://t.cn/zHuwJxz )为我推荐了:";
//            for (NSString *foodId in takenFoodIdsArray)
//            {
//                NSDictionary *aFood = [takenFoodDict objectForKey:foodId];
//                NSString *name = [aFood objectForKey:@"Name"];
//                NSNumber *weight = [aFood objectForKey:@"Amount"];
//                contents = [contents stringByAppendingFormat:@"\n%@ %dg",name,[weight intValue]];
//            }
//            contents = [contents stringByAppendingString:@"\n你也来试试吧!"];//:@"\n%@ %dg",name,[weight intValue]];
//            return contents;
//        }
//        else
//        {
            NSString *contents = @"我用 营养膳食指南(http://t.cn/zH1gxw5 ) 挑选出了一组含全面丰富营养的食物搭配, 羡慕吧? 快来试试吧!";
            return contents;
//        }
        
    }
}
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
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"出现了错误，请重试" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
            [alert show];
            return nil;
        }
        //UIImageWriteToSavedPhotosAlbum(lowImage, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
        
    }

}
- (void)shareRecommendContentForType:(ShareType)type
{
    if(type == ShareTypeWeixiSession || type == ShareTypeWeixiTimeline)
    {
        if ([WXApi isWXAppInstalled])
        {
            NSData *shareData = [self getShareData];
            //isWXAppInstalled
            //getWXAppInstallUrl
            if(shareData)
            {
                NSString *contents = [self getShareContentsForShareType:type];
                UIImage *shareImage = [UIImage imageWithData:shareData];
                id<ISSContent> content = [ShareSDK content:contents
                                            defaultContent:@"default"
                                                     image:[ShareSDK jpegImageWithImage:shareImage quality:0.1]
                                                     title:@"title"
                                                       url:nil
                                               description:@"description"
                                                 mediaType:SSPublishContentMediaTypeImage];
                shareImage = nil;
                [content addWeixinSessionUnitWithType:INHERIT_VALUE
                                              content:contents
                                                title:@"title"
                                                  url:INHERIT_VALUE
                                                image:INHERIT_VALUE
                                         musicFileUrl:nil
                                              extInfo:nil
                                             fileData:nil
                                         emoticonData:nil];

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

        }
        else
        {
            [self popWeiChatInstallAlert];
        }
    }
    else if (type == ShareTypeSinaWeibo)
    {
       // UIImageJPEGRepresentation
        NSData *shareData = [self getShareData];
        if(shareData)
        {
            if ([ShareSDK hasAuthorizedWithType:type])
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                LZShareViewController *shareViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZShareViewController"];
                NSString *contents = [self getShareContentsForShareType:type ];
                shareViewController.preInsertText = contents;
                shareViewController.shareImageData = shareData;
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
                                                [ShareSDK userFieldWithType:SSUserFieldTypeName valeu:@"营养膳食指南"],
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
                        shareViewController.shareImageData = shareData;
                        [self presentModalViewController:shareViewController animated:YES];
                    }
                    //NSLog(@"ssauthState %d",state);
                }];
                
            }
        }
        
    }
    
}
- (void)popWeiChatInstallAlert
{
    UIAlertView *insallWeichatAlert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"还没有安装微信，立即下载?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    insallWeichatAlert.tag = KInstallWechatAlertTag;
    [insallWeichatAlert show];
}
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
//    if (alertView.tag == KChangeFoodAmountAlertTag)
//    {
//        if (buttonIndex == alertView.cancelButtonIndex)
//        {
//            return;
//        }
//        else
//        {
//            if (self.currentEditFoodId == nil)
//            {
//                return;
//            }
//            UITextField *textFiled = [alertView textFieldAtIndex:0];
//            int changed = [textFiled.text intValue];
//            NSDictionary* takenDict =  [[NSUserDefaults standardUserDefaults]objectForKey:LZUserDailyIntakeKey];
//            if ([takenDict objectForKey:currentEditFoodId])
//            {
//                NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:takenDict];
//                
//                if (changed <=0)
//                {
//                    [tempDict removeObjectForKey:self.currentEditFoodId];
//                }
//                else
//                {
//                    [tempDict setObject:[NSNumber numberWithInt:changed] forKey:self.currentEditFoodId];
//                }
//                self.currentEditFoodId = nil;
//                [[NSUserDefaults standardUserDefaults]setObject:tempDict forKey:LZUserDailyIntakeKey];
//                [[NSUserDefaults standardUserDefaults]synchronize];
//                
//            }
//            else if ([self.recommendFoodDictForDisplay objectForKey:currentEditFoodId])
//            {
//                if (changed <=0)
//                {
//                    [self.recommendFoodDictForDisplay removeObjectForKey:self.currentEditFoodId];
//                }
//                else
//                {
//                    [self.recommendFoodDictForDisplay setObject:[NSNumber numberWithInt:changed] forKey:self.currentEditFoodId];
//                }
//                self.currentEditFoodId = nil;
//
//            }
//            [self refreshFoodNureitentProcessForAll:YES];
//
//        }
//    }
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
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:LZUserDailyIntakeKey];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [self.navigationController  popViewControllerAnimated:!backWithNoAnimation];
            }
            else
            {
                UIAlertView *saveFailedAlert = [[UIAlertView alloc]initWithTitle:@"保存失败" message:@"出现了错误，请重试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [saveFailedAlert show];
            }
        }
    }
    else if(alertView.tag == KInstallWechatAlertTag)
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
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
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
