//
//  NGFoodCombinationListViewController.m
//  nutrition
//
//  Created by Yasofon on 14-1-28.
//  Copyright (c) 2014年 lingzhi mobile. All rights reserved.
//

#import "NGFoodCombinationListViewController.h"
#import "NGFoodCombinationItemCell.h"

#import "NGFoodCombinationEditViewController.h"
//#import "LZDietListMakeViewController.h"

#import "NGDietCell.h"


#import "GADMasterViewController.h"
#import "MobClick.h"
//#import "LZEditProfileViewController.h"
#import "LZSettingsViewController.h"
#import "LZUtility.h"
#import "LZUtilityParse.h"
//#import "LZDietListMakeViewController.h"
#import "LZConstants.h"

#import "LZDataAccess.h"
#import "LZCustomDataButton.h"
#define KChangeDietAlertTag 99
@interface NGFoodCombinationListViewController ()<UIAlertViewDelegate>

@end

@implementation NGFoodCombinationListViewController
@synthesize dietArray,currentEditDietId,backWithNoAnimation;


//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//	// Do any additional setup after loading the view.
//    m_items = [NSMutableArray arrayWithObjects:@"aa",@"bb", nil];
//    
//    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"新增" style:UIBarButtonItemStyleBordered target:self action:@selector(addButtonTapped)];
//    self.navigationItem.rightBarButtonItem = addButtonItem;
//
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [m_items count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    tableView registerClass:<#(__unsafe_unretained Class)#> forCellReuseIdentifier:<#(NSString *)#>
////    tableView registerNib:<#(UINib *)#> forCellReuseIdentifier:<#(NSString *)#>
//    NGFoodCombinationItemCell * cell =(NGFoodCombinationItemCell*)[tableView dequeueReusableCellWithIdentifier:@"FoodCombinationItem"];
//    
//    [cell.label1 setText:m_items[indexPath.row]];
//    
//    
//    return cell;
//}
//
////to enable delete row
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"删除";
//}
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        [m_items removeObjectAtIndex:indexPath.row];
//        [self.mListView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
//}
//
//- (void)addButtonTapped
//{
//
////    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
////    LZDietListMakeViewController *editController1 = [storyboard instantiateViewControllerWithIdentifier:@"LZDietListMakeViewController"];
//    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FoodCombinationList" bundle:nil];
//    NGFoodCombinationEditViewController *editController1 = [storyboard instantiateViewControllerWithIdentifier:@"NGFoodCombinationEditViewController"];
//    
//    [self.navigationController pushViewController:editController1 animated:YES];
//}




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
    [LZGlobalService SetSubViewExternNone:self];
    
    if (needFee){
        [self.mobView removeFromSuperview];
        CGRect tvFrame = self.listView.frame;
//        NSLog(@"self.listView.frame be %f,%f, %f,%f",tvFrame.origin.x,tvFrame.origin.y,tvFrame.size.width,tvFrame.size.height);
        tvFrame.size.height = tvFrame.size.height+50;
        self.listView.frame = tvFrame;
    }
    
    if (ViewControllerUseBackImage) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
        UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
    }
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"xinjianbutton", @"新建") style:UIBarButtonItemStyleBordered target:self action:@selector(addListAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    if(backWithNoAnimation)
    {
        UIImage *buttonImage = [UIImage imageNamed:@"nav_back_button.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"fanhuibutton", @"  返回") forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 48, 30);
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
        [button addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = backItem;
    }
    
    self.title = NSLocalizedString(@"dietlist_viewtitle",@"膳食清单");
    self.dietArray = [[NSMutableArray alloc]init];
    currentEditDietId = nil;
    self.emptyTopLabel.text = NSLocalizedString(@"dietlist_topemptylabel_content",@"暂无膳食清单");
    self.emptyBottomLabel.text = NSLocalizedString(@"dietlist_bottomemptylabel_content",@"制定适合您的口味的每日膳食搭配，保证每日全面丰富的营养。");
    
}
-(void)backButtonTapped
{
    [self.navigationController popViewControllerAnimated:!backWithNoAnimation];
}
-(void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:UmengPathShanShiQingDan];
    
    if (!needFee){
        GADMasterViewController *shared = [GADMasterViewController singleton];
        [shared resetAdView:self andListView:self.mobView];
    }else{
        
    }
    
    [self displayLocalDietList];
}
- (void)viewDidAppear:(BOOL)animated
{
    //    if (![LZUtility isUserProfileComplete])
    //    {
    //        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    //        LZEditProfileViewController *editProfileViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZEditProfileViewController"];
    //        editProfileViewController.firstEnterEditView = YES;
    //        //addByNutrientController.foodArray = recommendFoodArray;
    //        //addByNutrientController.nutrientTitle = nutrientName;
    //        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:editProfileViewController];
    //        [self presentModalViewController:navController animated:YES];
    //    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:UmengPathShanShiQingDan];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)displayLocalDietList
{
    LZDataAccess *da = [LZDataAccess singleton];
    
    NSArray *localDietArray = [da getAllFoodCollocation];
    [self.dietArray removeAllObjects];
    [self.dietArray addObjectsFromArray:localDietArray];
    if (self.dietArray == nil || [self.dietArray count]==0)
    {
        [self showEmptyView:YES];
        return;
    }
    [self showEmptyView:NO];
    [self.listView reloadData];
}
-(void)showEmptyView:(BOOL)show
{
    self.listView.hidden = show;
    self.emptyImageView.hidden = !show;
    self.emptyTopLabel.hidden = !show;
    self.emptyBottomLabel.hidden = !show;
    
    
}
- (void)addListAction
{
    NSDictionary *emptyIntake = [[NSDictionary alloc]init];
    [[NSUserDefaults standardUserDefaults] setObject:emptyIntake forKey:LZUserDailyIntakeKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FoodCombinationList" bundle:nil];
    NGFoodCombinationEditViewController * foodListViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGFoodCombinationEditViewController"];
    [LZUtility initializePreferNutrient];
//    foodListViewController.listType = dietListTypeNew;
    [self.navigationController pushViewController:foodListViewController animated:YES];
    
    [MobClick event:UmengEvent_V2YingYangDaPei];
}
- (void)settingsAction
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZSettingsViewController * settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZSettingsViewController"];
    //UINavigationController *initialController = (UINavigationController*)[UIApplication
    //sharedApplication].keyWindow.rootViewController;
    [self.navigationController pushViewController:settingsViewController animated:YES];
}
-(void)changeNameButtonTapped:(LZCustomDataButton*)sender
{
    NSDictionary *dietInfo = (NSDictionary *)sender.customData;
    NSNumber *dietId = [dietInfo objectForKey:@"CollocationId"];
    currentEditDietId = dietId;
    NSString *dietName = [dietInfo objectForKey:@"CollocationName"];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"dietlist_alert0_title",@"更改名称") message:NSLocalizedString(@"dietlist_alert0_message",@"填一个你更喜欢的名称吧!") delegate:self cancelButtonTitle:NSLocalizedString(@"quxiaobutton",@"取消") otherButtonTitles:NSLocalizedString(@"quedingbutton",@"确定"), nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = KChangeDietAlertTag;
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.text = dietName;
    tf.clearButtonMode = UITextFieldViewModeAlways;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == KChangeDietAlertTag)
    {
        if (buttonIndex == alertView.cancelButtonIndex)
        {
            return;
        }
        else
        {
            if (self.currentEditDietId == nil)
            {
                return;
            }
            UITextField *textFiled = [alertView textFieldAtIndex:0];
            NSString *collocationName = textFiled.text;
            NSString *trimedName = [collocationName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([trimedName length] == 0)
            {
                UIAlertView *invalidNameAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alerttitle_wenxintishi",@"温馨提示") message:NSLocalizedString(@"dietlist_alert1_message",@"您输入的名称不规范，请重新输入") delegate:nil cancelButtonTitle:NSLocalizedString(@"zhidaolebutton",@"知道了") otherButtonTitles: nil];
                [invalidNameAlert show];
                return;
            }
            LZDataAccess *da = [LZDataAccess singleton];
            NSNumber *editId = self.currentEditDietId;
            self.currentEditDietId = nil;
            if([da updateFoodCollocationName:trimedName byId:editId])
            {
                [LZUtilityParse saveParseObject_FoodCollocationData_withCollocationId:editId];
                [self displayLocalDietList];
            }
            else{
                UIAlertView *saveFailedAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"dietlist_alert2_title",@"更改失败")message:NSLocalizedString(@"alertmessage_tryagain",@"出现了错误，请重试") delegate:nil cancelButtonTitle:NSLocalizedString(@"zhidaolebutton",@"知道了") otherButtonTitles:nil];
                [saveFailedAlert show];
            }
        }
    }
}
#pragma mark- TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dietArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NGDietCell * cell =(NGDietCell*)[tableView dequeueReusableCellWithIdentifier:@"NGDietCell"];
    NSDictionary *aDiet = [self.dietArray objectAtIndex:indexPath.row];
    NSString *dietName = [aDiet objectForKey:@"CollocationName"];
    [cell adjustLabelAccordingToDietName:dietName];
    
    cell.dietInfo = aDiet;
    
    cell.changeNameButton.customData = aDiet;
    [cell.changeNameButton addTarget:self action:@selector(changeNameButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 15)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NGDietCell * cell = (NGDietCell*)[tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *aDiet = cell.dietInfo;
    NSNumber *dietId = [aDiet objectForKey:@"CollocationId"];
    LZDataAccess *da = [LZDataAccess singleton];
    [LZUtilityParse deleteParseObject_FoodCollocationData_withCollocationId:dietId];//必须在 da deleteFoodCollocationData_withCollocationId 之前调用，因为有些数据需要从db中取
    if([da deleteFoodCollocationData_withCollocationId:dietId])
    {
        [self.dietArray removeObject:aDiet];
        NSArray *indexToDelete = [NSArray arrayWithObject:indexPath];
        [self.listView deleteRowsAtIndexPaths:indexToDelete withRowAnimation:UITableViewRowAnimationFade];
        if (self.dietArray == nil || [self.dietArray count]==0)
        {
            [self showEmptyView:YES];
            return;
        }
        [self showEmptyView:NO];
    }
    else
    {
        UIAlertView *deleteFailAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"dietlist_alert3_title",@"删除失败") message:NSLocalizedString(@"alertmessage_tryagain",@"出现了错误，请重试") delegate:nil cancelButtonTitle:NSLocalizedString(@"zhidaolebutton",@"知道了") otherButtonTitles:nil];
        [deleteFailAlert show];
    }
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
    return NSLocalizedString(@"shanchubutton",@"删除");
}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LZDataAccess *da = [LZDataAccess singleton];
    NSDictionary *aDiet = [self.dietArray objectAtIndex:indexPath.row];
    NSNumber *dietId = [aDiet objectForKey:@"CollocationId"];
//    NSArray *array = [da getCollocationFoodAmountRows_withCollocationId:dietId];
    //    NSLog(@"%@",array);
//    NSMutableDictionary *dietContentDict = [[NSMutableDictionary alloc]init];
//    for (NSDictionary *aFood in array)
//    {
//        NSNumber* foodAmount = [aFood objectForKey:@"FoodAmount"];
//        NSString* foodId = [aFood objectForKey:@"FoodId"];
//        
//        //[dietContentDict setObject:foodAmount forKey:[LZUtility convertNumberToFoodIdStr:foodId]];
//        [dietContentDict setObject:foodAmount forKey:foodId];
//    }
    NSString *dietTitle =  [aDiet objectForKey:@"CollocationName"];
//    NSDictionary *temp = [[NSDictionary alloc]initWithDictionary:dietContentDict];
//    [[NSUserDefaults standardUserDefaults]setObject:temp forKey:LZUserDailyIntakeKey];
//    [[NSUserDefaults  standardUserDefaults]synchronize];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FoodCombinationList" bundle:nil];
    NGFoodCombinationEditViewController * foodListViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGFoodCombinationEditViewController"];
    [LZUtility initializePreferNutrient];
//    foodListViewController.listType = dietListTypeOld;
    foodListViewController.title = dietTitle;
    foodListViewController.dietId = dietId;
    [self.navigationController pushViewController:foodListViewController animated:YES];
    
    [MobClick event:UmengEvent_V2YingYangDaPei];
}

- (void)viewDidUnload {
    [self setListView:nil];
    [self setMobView:nil];
    [self setEmptyImageView:nil];
    [self setEmptyTopLabel:nil];
    [self setEmptyBottomLabel:nil];
    [super viewDidUnload];
}
@end


