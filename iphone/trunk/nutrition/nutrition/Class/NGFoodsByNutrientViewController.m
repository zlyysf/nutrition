//
//  NGFoodsByNutrientViewController.m
//  nutrition
//
//  Created by Yasofon on 14-2-7.
//  Copyright (c) 2014年 lingzhi mobile. All rights reserved.
//

#import "NGFoodsByNutrientViewController.h"
#import "LZGlobal.h"

#import "LZConstants.h"
#import <math.h>
#import "GADMasterViewController.h"
#import "MobClick.h"
#import "LZRecommendFood.h"
#import "MBProgressHUD.h"

#import "LZNutrientFoodAddCell.h"

#define AlertViewTag_InputFoodAmount 100

//#import "JWNavigationViewController.h"
@interface NGFoodsByNutrientViewController ()<MBProgressHUDDelegate,UIAlertViewDelegate>
{
    NSDictionary *m_nutrientDict;
    NSArray *m_foodArray;
    NSString *m_nutrientTitle;

    
    MBProgressHUD *HUD;
    BOOL isFirstLoad;
    BOOL isChinese;
}
@end

@implementation NGFoodsByNutrientViewController{
    NSString *m_foodId_tmpAsParam;
}
@synthesize editDelegate;
//@synthesize foodArray,nutrientTitle,nutrientDict;
@synthesize NutrientId,NutrientAmount;

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
    if (ViewControllerUseBackImage) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
        UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
    }
    NSDictionary * AllNutrient2LevelDict = [[LZGlobal SharedInstance] getAllNutrient2LevelDict];
    m_nutrientDict = [AllNutrient2LevelDict objectForKey:self.NutrientId];
    m_nutrientTitle = [LZUtility getLocalNutrientName:m_nutrientDict];
    
    isChinese = [LZUtility isCurrentLanguageChinese];
    
    NSString *tipsStr = [NSString stringWithFormat:NSLocalizedString(@"addbynutrient_headerlabel_content",@"下列是含%@的食物，克数代表一天的推荐量。"), m_nutrientTitle];
    CGSize tipSize = [tipsStr sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(300, 9999) lineBreakMode:UILineBreakModeWordWrap];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, tipSize.height+15)];
    UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, tipSize.height)];
    tipsLabel.numberOfLines = 0;
    [tipsLabel setFont:[UIFont systemFontOfSize:15]];
    [tipsLabel setTextColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8f]];
    tipsLabel.text = tipsStr;
    //tempIntakeDict = [[NSMutableDictionary alloc]init];
    [tipsLabel setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:tipsLabel];
    self.listView.tableHeaderView = headerView;
    self.title = m_nutrientTitle;
    
    //    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0,0,
    //                                                                 CGSizeFromGADAdSize(kGADAdSizeBanner).width,
    //                                                                 CGSizeFromGADAdSize(kGADAdSizeBanner).height)];
    //    self.listView.tableFooterView = footerView;

    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.hidden = YES;
    HUD.delegate = self;
    isFirstLoad = YES;
    m_foodArray = [[NSArray alloc]init];
    self.listView.hidden = YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    //self.pushToNextView = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [MobClick beginLogPageView:UmengPathYingYangSuTianJia];
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
    LZDataAccess *da = [LZDataAccess singleton];
    NSArray *recommendFoodArray = [da getRichNutritionFoodForNutrient:NutrientId andNutrientAmount:NutrientAmount andIfNeedCustomDefinedFoods:false];//显示时不用自定义的富含食物清单来限制
    isFirstLoad = NO;
    m_foodArray = [NSArray arrayWithArray:recommendFoodArray];
    [self.listView reloadData];
    [HUD hide:YES];
    self.listView.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    //    if (self.pushToNextView) {
    //        return;
    //    }
    
    [MobClick endLogPageView:UmengPathYingYangSuTianJia];
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
    return [m_foodArray count];
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
    NSDictionary *aFood = [m_foodArray objectAtIndex:indexPath.row];
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
    
    cell.foodNameLabel.text = [LZUtility getLocalFoodName:aFood];
    //NSString *NDB_No = [aFood objectForKey:@"NDB_No"];
    NSNumber *foodAmount = [aFood objectForKey:Key_FoodAmount];
    //NSNumber *intake= [self.tempIntakeDict objectForKey:NDB_No];
    int amount =(int)(ceilf([foodAmount floatValue]));
    if(amount <= 0)
    {
        cell.recommendAmountLabel.hidden = YES;
        //[cell centeredFoodNameButton:YES];
    }
    else
    {
        cell.recommendAmountLabel.hidden = NO;
        //[cell centeredFoodNameButton:NO];
    }
    cell.recommendAmountLabel.text = [NSString stringWithFormat:@"%dg",amount];
    //int num = [intake intValue];
    //cell.foodAmountLabel.text = [NSString stringWithFormat:@"%dg",num];
    
    [cell.backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"foodCellBack.png"]]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.listView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *foodAttr = [m_foodArray objectAtIndex:indexPath.row];
    NSString *foodId = foodAttr[COLUMN_NAME_NDB_No];
    NSNumber *foodAmount = [foodAttr objectForKey:Key_FoodAmount];
    int amount =(int)(ceilf([foodAmount floatValue]));
    if (amount <0)
        amount = 0;
    foodAmount = [NSNumber numberWithInt:amount];
    
    //1,just directly add amount and back
//    [editDelegate addToCombinationWithFoodId:foodId andAmount:foodAmount];
//    [self.navigationController popViewControllerAnimated:NO];
    
    //2,pop a alert dialog to ask
//    NSString *foodName = [LZUtility getLocalFoodName:foodAttr];
//    m_foodId_tmpAsParam = foodId;
//    UIAlertView *alert = [[UIAlertView alloc]
//                          initWithTitle:@"请输入食物重量(g)" message:foodName
//                          delegate:self
//                          cancelButtonTitle:NSLocalizedString(@"quxiaobutton",@"取消")
//                          otherButtonTitles:NSLocalizedString(@"quedingbutton",@"确定"), nil];
//    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//    alert.tag = AlertViewTag_InputFoodAmount;
//    UITextField *tf = [alert textFieldAtIndex:0];
//    tf.clearButtonMode = UITextFieldViewModeAlways;
//    tf.text = [NSString stringWithFormat:@"%@",foodAmount ] ;
//    [alert show];
    
    //3,go to detail page to select a amount
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FoodCombinationList" bundle:nil];
    NGFoodDetailController * foodDetailController = [storyboard instantiateViewControllerWithIdentifier:@"NGFoodDetailController"];
    
    foodDetailController.FoodId = foodId;
    foodDetailController.FoodAttr = foodAttr;
    foodDetailController.FoodAmount = foodAmount;
//    foodDetailController.delegate = self;
    foodDetailController.editDelegate = editDelegate;
    foodDetailController.BackToViewControllerWhenFinish = (UIViewController*)editDelegate;
    foodDetailController.staticFoodAmountDict = [editDelegate getFoodAmountDict];
    foodDetailController.isCalForAll = true;
//    foodDetailController.editDelegate = editDelegate;
    [self.navigationController pushViewController:foodDetailController animated:YES];


    //below to be deleted
//    //self.pushToNextView = YES;
//    //NSString *NDB_No = [foodAtr objectForKey:@"NDB_No"];
//    NSString *foodQueryKey;
//    if (isChinese)
//    {
//        foodQueryKey = @"CnCaption";
//    }
//    else
//    {
//        foodQueryKey = @"FoodNameEn";
//    }
//    NSString *foodName = [foodAtr objectForKey:foodQueryKey];
//
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FoodCombinationList" bundle:nil];
//    NGFoodDetailController * foodDetailController = [storyboard instantiateViewControllerWithIdentifier:@"NGFoodDetailController"];
//
//    NSString *singleUnitName = [LZUtility getSingleItemUnitName:[foodAttr objectForKey:COLUMN_NAME_SingleItemUnitName]];
//    NSNumber *upper = [NSNumber numberWithInt:1000];// [foodAtr objectForKey:COLUMN_NAME_Upper_Limit];
//    if ([weight intValue]>= [upper intValue])
//    {
//        upper = weight;
//    }
//    foodDetailController.gUnitMaxValue = upper;
//
//    if ([singleUnitName length]==0)
//    {
//        foodDetailController.isUnitDisplayAvailable = NO;
//    }
//    else
//    {
//        foodDetailController.isUnitDisplayAvailable = YES;
//        foodDetailController.unitName = singleUnitName;
//        NSNumber *singleUnitWeight = [foodAttr objectForKey:COLUMN_NAME_SingleItemUnitWeight];
////        if ([LZUtility isUseUnitDisplay:weight unitWeight:singleUnitWeight])
////        {
////            foodDetailController.isDefaultUnitDisplay = YES;
////        }
////        else
////        {
////            foodDetailController.isDefaultUnitDisplay = NO;
////        }
//
//        foodDetailController.isDefaultUnitDisplay = NO;
//        int maxCount = (int)(ceilf(([upper floatValue]*2)/[singleUnitWeight floatValue]));
////        if (maxCount <20)
////        {
////            foodDetailController.unitMaxValue = [NSNumber numberWithInt:20];
////        }
////        else
////        {
////            foodDetailController.unitMaxValue = [NSNumber numberWithInt:maxCount];
////        }
//        foodDetailController.unitMaxValue = [NSNumber numberWithInt:maxCount];
//    }
//
//    foodDetailController.currentSelectValue = weight;
//    foodDetailController.defaulSelectValue = weight;
//    foodDetailController.foodAttr = foodAttr;
//    foodDetailController.foodName = foodName;
//    foodDetailController.delegate = self;
//    foodDetailController.isCalForAll = NO;
//    foodDetailController.GUnitStartIndex = 0;
//    JWNavigationViewController *nav = [[JWNavigationViewController alloc]initWithRootViewController:foodDetailController];
//    [self presentModalViewController:nav animated:YES];
    

}

//#pragma mark- LZFoodCellDelegate
//- (void)foodButtonTappedForIndex:(NSIndexPath *)index
//{
//    self.pushToNextView = YES;
//    if(self.currentFoodInputTextField != nil)
//    {
//        [self.currentFoodInputTextField resignFirstResponder];
//    }
//    NSDictionary *aFood = [m_foodArray objectAtIndex:index.row];
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
//    NSDictionary *afood = [m_foodArray objectAtIndex:index.row];
//    NSString *NDB_No = [afood objectForKey:@"NDB_No"];
//    [self.tempIntakeDict setObject:[NSNumber numberWithInt:[foodNumber intValue]] forKey:NDB_No];
//    //NSLog(@"cell section %d , row %d food amount %@",index.section,index.row,foodNumber);
//}
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
    HUD.hidden = YES;
}


//#pragma mark- NGSelectFoodAmountDelegate
//-(void)didChangeFoodId:(NSString *)foodId toAmount:(NSNumber*)changedValue
//{
//    [self.editDelegate addToCombinationWithFoodId:foodId andAmount:changedValue];
//}

#pragma mark- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == AlertViewTag_InputFoodAmount)
    {
        if (buttonIndex == alertView.cancelButtonIndex)
        {
        }
        else
        {
            UITextField *textFiled = [alertView textFieldAtIndex:0];
            
            NSString *strAmount = textFiled.text;
            NSNumberFormatter *numFmt = [[NSNumberFormatter alloc] init];
            NSNumber *foodAmount;
            if ([numFmt numberFromString:strAmount])
            {
                foodAmount=[NSNumber numberWithInt:[strAmount intValue]];
                [editDelegate addToCombinationWithFoodId:m_foodId_tmpAsParam andAmount:foodAmount];
                [self.navigationController popViewControllerAnimated:NO];
                return;
            }
            else
            {
                UIAlertView *invalidInputAlert = [[UIAlertView alloc]initWithTitle:@"输入错误" message:@"请输入整数" delegate:nil cancelButtonTitle:NSLocalizedString(@"zhidaolebutton",@"知道了") otherButtonTitles:nil];
                [invalidInputAlert show];
                return;
            }
        }
    }
}








@end





















