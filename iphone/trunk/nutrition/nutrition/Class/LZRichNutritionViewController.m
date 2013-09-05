//
//  LZRichNutritionViewController.m
//  nutrition
//
//  Created by liu miao on 8/30/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZRichNutritionViewController.h"
#import "LZConstants.h"
#import <math.h>
#import "GADMasterViewController.h"
#import "MobClick.h"
#import "LZRecommendFood.h"
#import "MBProgressHUD.h"
#import "LZFoodDetailController.h"
#import "LZNutrientFoodAddCell.h"
#import "LZNutrientionManager.h"
#import "JWNavigationViewController.h"
@interface LZRichNutritionViewController ()<MBProgressHUDDelegate,LZFoodDetailViewControllerDelegate>
{
    MBProgressHUD *HUD;
    BOOL isFirstLoad;
}

@end

@implementation LZRichNutritionViewController
@synthesize foodArray,nutrientTitle,nutrientDict;
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
    
    NSString *tipsStr = [NSString stringWithFormat:@"下列是富含%@的食物，您可以根据我们提供的推荐量来挑选适合自己的食物。", nutrientTitle];
    CGSize tipSize = [tipsStr sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(300, 9999) lineBreakMode:UILineBreakModeWordWrap];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, tipSize.height+15)];
    UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, tipSize.height)];
    tipsLabel.numberOfLines = 0;
    [tipsLabel setFont:[UIFont systemFontOfSize:15]];
    [tipsLabel setTextColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8f]];
    tipsLabel.text = tipsStr;
    [tipsLabel setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:tipsLabel];
    self.listView.tableHeaderView = headerView;
    self.title = nutrientTitle;
    UIBarButtonItem *infoItem = [[UIBarButtonItem alloc]initWithTitle:@"简介" style:UIBarButtonItemStyleBordered target:self action:@selector(showNutritionInfo)];
    self.navigationItem.rightBarButtonItem = infoItem;

    //    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0,0,
    //                                                                 CGSizeFromGADAdSize(kGADAdSizeBanner).width,
    //                                                                 CGSizeFromGADAdSize(kGADAdSizeBanner).height)];
    //    self.listView.tableFooterView = footerView;
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.hidden = YES;
    HUD.delegate = self;
    isFirstLoad = YES;
    self.foodArray = [[NSArray alloc]init];
    self.listView.hidden = YES;
}
-(void)showNutritionInfo
{
   [[LZNutrientionManager SharedInstance]showNutrientInfo:[self.nutrientDict objectForKey:@"NutrientID"]];
}
- (void)viewWillAppear:(BOOL)animated
{
    //self.pushToNextView = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [MobClick beginLogPageView:UmengPathYingYangFuHan];
    //GADMasterViewController *shared = [GADMasterViewController singleton];
    //UIView *footerView = self.listView.tableFooterView;
    //[shared resetAdView:self andListView:footerView];
}
- (void)viewDidAppear:(BOOL)animated
{
    if (isFirstLoad) {
        HUD.hidden = NO;
        [HUD show:YES];
        //self.listView.hidden = YES;
        
        //HUD.labelText = @"智能推荐中...";
        
        [self performSelector:@selector(loadDataForDisplay) withObject:nil afterDelay:0.f];
    }
}
-(void)loadDataForDisplay
{
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
    NSDictionary *takenFoodAmountDict = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserDailyIntakeKey];
    //    NSMutableDictionary *retDict = [rf takenFoodSupplyNutrients_AbstractPerson:params withDecidedFoods:takenFoodAmountDict];
    NSMutableDictionary *retDict = [rf takenFoodSupplyNutrients_withUserInfo:userInfo andDecidedFoods:takenFoodAmountDict andOptions:options];
    
    //NSDictionary *nutrient = [nutrientInfoArray objectAtIndex:indexPath.row];
    NSString *nutrientId = [self.nutrientDict objectForKey:@"NutrientID"];
    NSDictionary *DRIsDict = [retDict objectForKey:@"DRI"];//nutrient name as key, also column name
    NSDictionary *nutrientInitialSupplyDict = [retDict objectForKey:@"nutrientInitialSupplyDict"];
    NSNumber *nmNutrientInitSupplyVal = [nutrientInitialSupplyDict objectForKey:nutrientId];
    double dNutrientNeedVal = [((NSNumber*)[DRIsDict objectForKey:nutrientId]) doubleValue]*[planPerson intValue]*[planDays intValue];
    double dNutrientLackVal = dNutrientNeedVal - [nmNutrientInitSupplyVal doubleValue];
    LZDataAccess *da = [LZDataAccess singleton];
    NSArray *recommendFoodArray = [da getRichNutritionFoodForNutrient:nutrientId andNutrientAmount:[NSNumber numberWithDouble:dNutrientLackVal] andIfNeedCustomDefinedFoods:false];//显示时不用自定义的富含食物清单来限制
    isFirstLoad = NO;
    self.foodArray = [NSArray arrayWithArray:recommendFoodArray];
    [self.listView reloadData];
    [HUD hide:YES];
    self.listView.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    //    if (self.pushToNextView) {
    //        return;
    //    }
    
    [MobClick endLogPageView:UmengPathYingYangFuHan];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setListView:nil];
    //[self setNavItem:nil];
    [super viewDidUnload];
}
//- (IBAction)cancelButtonTapped:(id)sender
//{
//    if(self.currentFoodInputTextField != nil)
//    {
//        [self.currentFoodInputTextField resignFirstResponder];
//    }
//    NSMutableDictionary *intakeDict = [[NSMutableDictionary alloc]init];
//    NSDictionary *dailyIntake = [[NSUserDefaults standardUserDefaults]objectForKey:LZUserDailyIntakeKey];
//    if(dailyIntake != nil)
//    {
//        [intakeDict addEntriesFromDictionary:dailyIntake];
//    }
//
//    BOOL needSaveData = NO;
//    for (NSString * NDB_No in [self.tempIntakeDict allKeys])
//    {
//        NSNumber *num = [self.tempIntakeDict objectForKey:NDB_No];
//        if ([num intValue]>0)
//        {
//            needSaveData = YES;
//            NSNumber *takenAmountNum = [intakeDict objectForKey:NDB_No];
//            if (takenAmountNum)
//                [intakeDict setObject:[NSNumber numberWithInt:[num intValue]+[takenAmountNum intValue]] forKey:NDB_No];
//            else
//                [intakeDict setObject:num forKey:NDB_No];
//        }
//    }
//    if (needSaveData) {
//        [[NSNotificationCenter defaultCenter]postNotificationName:Notification_TakenFoodChangedKey object:nil userInfo:nil];
//        [[NSUserDefaults standardUserDefaults]setObject:intakeDict forKey:LZUserDailyIntakeKey];
//        [[NSUserDefaults  standardUserDefaults]synchronize];
//    }
//
//    [self dismissModalViewControllerAnimated:YES];
//}
//- (IBAction)saveButtonTapped:(id)sender {
//    //储存摄入量
//    if(self.currentFoodInputTextField != nil)
//    {
//        [self.currentFoodInputTextField resignFirstResponder];
//    }
//    NSMutableDictionary *intakeDict = [[NSMutableDictionary alloc]init];
//    NSDictionary *dailyIntake = [[NSUserDefaults standardUserDefaults]objectForKey:LZUserDailyIntakeKey];
//    if(dailyIntake != nil)
//    {
//        [intakeDict addEntriesFromDictionary:dailyIntake];
//    }
//
//    BOOL needSaveData = NO;
//    for (NSString * NDB_No in [self.tempIntakeDict allKeys])
//    {
//        NSNumber *num = [self.tempIntakeDict objectForKey:NDB_No];
//        if ([num intValue]>0)
//        {
//            needSaveData = YES;
//            NSNumber *takenAmountNum = [intakeDict objectForKey:NDB_No];
//            if (takenAmountNum)
//                [intakeDict setObject:[NSNumber numberWithInt:[num intValue]+[takenAmountNum intValue]] forKey:NDB_No];
//            else
//                [intakeDict setObject:num forKey:NDB_No];
//        }
//    }
//    if (needSaveData) {
//        [[NSNotificationCenter defaultCenter]postNotificationName:Notification_TakenFoodChangedKey object:nil userInfo:nil];
//        [[NSUserDefaults standardUserDefaults]setObject:intakeDict forKey:LZUserDailyIntakeKey];
//        [[NSUserDefaults  standardUserDefaults]synchronize];
//    }
//    [self dismissModalViewControllerAnimated:YES];
//}

- (void)keyboardWillShow:(NSNotification *)notification {
	
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *boundsValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect keyboardRect = [boundsValue CGRectValue];
    
    CGFloat keyboardTop = self.view.frame.size.height - keyboardRect.size.height;
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
	tableviewFrame.size.height = self.view.frame.size.height;
    
	//bottomViewFrame.origin.y = keyboardTop - bottomViewFrame.size.height;
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.listView.frame = tableviewFrame;
    [UIView commitAnimations];
    
}

#pragma mark- TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.foodArray count];
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LZNutrientFoodAddCell* cell =(LZNutrientFoodAddCell*)[tableView dequeueReusableCellWithIdentifier:@"LZNutrientFoodAddCell"];
    //一个记录名称的数组 一个记录对应摄入量的数组
    NSDictionary *aFood = [self.foodArray objectAtIndex:indexPath.row];
    //NSLog(@"picture path food list %@",aFood);
    NSString *picturePath;
    NSString *picPath = [aFood objectForKey:@"PicPath"];
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
    [cell.foodPicView setImage:foodImage];
    
    cell.foodNameLabel.text = [aFood objectForKey:@"CnCaption"];
    //NSString *NDB_No = [aFood objectForKey:@"NDB_No"];
    NSNumber *foodAmount = [aFood objectForKey:Key_FoodAmount];
    //NSNumber *intake= [self.tempIntakeDict objectForKey:NDB_No];
    int amount =(int)(ceilf([foodAmount floatValue]));
    if(amount <= 0)
    {
        cell.recommendAmountLabel.hidden = YES;
        [cell centeredFoodNameButton:YES];
    }
    else
    {
        cell.recommendAmountLabel.hidden = NO;
        [cell centeredFoodNameButton:NO];
    }
    cell.recommendAmountLabel.text = [NSString stringWithFormat:@"推荐量:%dg",amount];
    //int num = [intake intValue];
    //cell.foodAmountLabel.text = [NSString stringWithFormat:@"%dg",num];
    
    [cell.backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"foodCellBack.png"]]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.listView deselectRowAtIndexPath:indexPath animated:YES];
    //self.pushToNextView = YES;
    NSDictionary *foodAtr = [self.foodArray objectAtIndex:indexPath.row];
    //NSString *NDB_No = [foodAtr objectForKey:@"NDB_No"];
    NSString *foodName = [foodAtr objectForKey:@"CnCaption"];
    NSNumber *weight ;//= [self.tempIntakeDict objectForKey:NDB_No];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZFoodDetailController * foodDetailController = [storyboard instantiateViewControllerWithIdentifier:@"LZFoodDetailController"];
    
    NSDictionary *aFood = [self.foodArray objectAtIndex:indexPath.row];
    NSNumber *foodAmount = [aFood objectForKey:Key_FoodAmount];
    int amount =(int)(ceilf([foodAmount floatValue]));
    //int weightAmount = (int)(ceilf([weight floatValue]));
    // if (weightAmount <=0 )
    //{
    if (amount>0)
    {
        weight = [NSNumber numberWithInt:amount];
    }
    else
    {
        weight = [NSNumber numberWithInt:0];
    }
    //}
    
    
    NSString *singleUnitName = [foodAtr objectForKey:COLUMN_NAME_SingleItemUnitName];
    NSNumber *upper = [NSNumber numberWithInt:1000];// [foodAtr objectForKey:COLUMN_NAME_Upper_Limit];
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
        //        if ([LZUtility isUseUnitDisplay:weight unitWeight:singleUnitWeight])
        //        {
        //            foodDetailController.isDefaultUnitDisplay = YES;
        //        }
        //        else
        //        {
        //            foodDetailController.isDefaultUnitDisplay = NO;
        //        }
        
        foodDetailController.isDefaultUnitDisplay = NO;
        int maxCount = (int)(ceilf(([upper floatValue]*2)/[singleUnitWeight floatValue]));
        //        if (maxCount <20)
        //        {
        //            foodDetailController.unitMaxValue = [NSNumber numberWithInt:20];
        //        }
        //        else
        //        {
        //            foodDetailController.unitMaxValue = [NSNumber numberWithInt:maxCount];
        //        }
        foodDetailController.unitMaxValue = [NSNumber numberWithInt:maxCount];
    }
    foodDetailController.isPushToDietPicker = YES;
    foodDetailController.currentSelectValue = weight;
    foodDetailController.defaulSelectValue = weight;
    foodDetailController.foodAttr = foodAtr;
    foodDetailController.foodName = foodName;
    foodDetailController.delegate = self;
    foodDetailController.isCalForAll = NO;
    foodDetailController.GUnitStartIndex = 0;
    JWNavigationViewController *nav = [[JWNavigationViewController alloc]initWithRootViewController:foodDetailController];
    [self presentModalViewController:nav animated:YES];
    
    
}

//#pragma mark- LZFoodCellDelegate
//- (void)foodButtonTappedForIndex:(NSIndexPath *)index
//{
//    self.pushToNextView = YES;
//    if(self.currentFoodInputTextField != nil)
//    {
//        [self.currentFoodInputTextField resignFirstResponder];
//    }
//    NSDictionary *aFood = [self.foodArray objectAtIndex:index.row];
//    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
//    NSArray *standardArray = [rf formatFoodStandardContentForFood:aFood];
//
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//    LZFoodInfoViewController *foodInfoViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZFoodInfoViewController"];
//    foodInfoViewController.nutrientStandardArray = standardArray;
//    foodInfoViewController.title = [aFood objectForKey:@"CnCaption"];
//    [self.navigationController pushViewController:foodInfoViewController animated:YES];
//}
//- (void)textFieldDidBeginEditingForIndex:(NSIndexPath*)index textField:(UITextField *)currentTextField
//{
//    self.currentFoodInputTextField = currentTextField;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 50 * USEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [self.listView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//    });
//}
//- (void)textFieldDidReturnForIndex:(NSIndexPath*)index andText:(NSString*)foodNumber
//{
//    //[self.foodIntakeAmountArray replaceObjectAtIndex:index.row withObject:foodNumber];
//    self.currentFoodInputTextField = nil;
//    NSDictionary *afood = [self.foodArray objectAtIndex:index.row];
//    NSString *NDB_No = [afood objectForKey:@"NDB_No"];
//    [self.tempIntakeDict setObject:[NSNumber numberWithInt:[foodNumber intValue]] forKey:NDB_No];
//    //NSLog(@"cell section %d , row %d food amount %@",index.section,index.row,foodNumber);
//}
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
    HUD.hidden = YES;
}
#pragma mark- LZFoodDetailViewControllerDelegate
-(void)didChangeFoodId:(NSString *)foodId toAmount:(NSNumber*)changedValue
{
    //[self.tempIntakeDict setObject:[NSNumber numberWithInt:[changedValue intValue]] forKey:foodId];
    [LZUtility addFood:foodId withFoodAmount:changedValue];
    [self.listView reloadData];
}

@end
