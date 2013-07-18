//
//  LZUserDietListViewController.m
//  nutrition
//
//  Created by liu miao on 7/15/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZUserDietListViewController.h"
#import "GADMasterViewController.h"
#import "MobClick.h"
#import "LZEditProfileViewController.h"
#import "LZSettingsViewController.h"
#import "LZUtility.h"
#import "LZDietListMakeViewController.h"
#import "LZConstants.h"
#import "LZDiteCell.h"
#import "LZDataAccess.h"
@interface LZUserDietListViewController ()

@end

@implementation LZUserDietListViewController
@synthesize dietArray;
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

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"制定清单" style:UIBarButtonItemStyleBordered target:self action:@selector(addListAction)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleBordered target:self action:@selector(settingsAction)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.title = @"精选膳食清单";
    self.dietArray = [[NSMutableArray alloc]init];

}
-(void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"精选膳食清单页面"];
    GADMasterViewController *shared = [GADMasterViewController singleton];
    [shared resetAdView:self andListView:self.mobView];
    [self displayLocalDietList];
}
- (void)viewDidAppear:(BOOL)animated
{
    if (![LZUtility isUserProfileComplete])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        LZEditProfileViewController *editProfileViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZEditProfileViewController"];
        editProfileViewController.firstEnterEditView = YES;
        //addByNutrientController.foodArray = recommendFoodArray;
        //addByNutrientController.nutrientTitle = nutrientName;
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:editProfileViewController];
        [self presentModalViewController:navController animated:YES];
    }

}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"精选膳食清单页面"];
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
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LZUserDailyIntakeKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZDietListMakeViewController * foodListViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZDietListMakeViewController"];
    foodListViewController.listType = dietListTypeNew;
    [self.navigationController pushViewController:foodListViewController animated:YES];
}
- (void)settingsAction
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZSettingsViewController * settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZSettingsViewController"];
    //UINavigationController *initialController = (UINavigationController*)[UIApplication
                                                                          //sharedApplication].keyWindow.rootViewController;
    [self.navigationController pushViewController:settingsViewController animated:YES];
}
#pragma mark- TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dietArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LZDiteCell * cell =(LZDiteCell*)[tableView dequeueReusableCellWithIdentifier:@"LZDiteCell"];
    NSDictionary *aDiet = [self.dietArray objectAtIndex:indexPath.row];
    cell.dietNameLabel.text = [aDiet objectForKey:@"CollocationName"];
    NSNumber *timeStamp = [aDiet objectForKey:@"CollocationCreateTime"];
    cell.timeStampLabel.text = [LZUtility stampFromInterval:timeStamp];
    cell.dietInfo = aDiet;
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
    return 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 15)];
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
    LZDiteCell * cell = (LZDiteCell*)[tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *aDiet = cell.dietInfo;
    NSNumber *dietId = [aDiet objectForKey:@"CollocationId"];
    LZDataAccess *da = [LZDataAccess singleton];
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
        UIAlertView *deleteFailAlert = [[UIAlertView alloc]initWithTitle:nil message:@"清单删除失败，请重试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
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
    return @"删除";
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
    LZDataAccess *da = [LZDataAccess singleton];
    NSDictionary *aDiet = [self.dietArray objectAtIndex:indexPath.row];
    NSNumber *dietId = [aDiet objectForKey:@"CollocationId"];
    NSArray *array = [da getCollocationFoodData_withCollocationId:dietId];
    NSLog(@"%@",array);
    NSMutableDictionary *dietContentDict = [[NSMutableDictionary alloc]init];
    for (NSDictionary *aFood in array)
    {
        NSNumber* foodAmount = [aFood objectForKey:@"FoodAmount"];
        NSString* foodId = [aFood objectForKey:@"FoodId"];
        
        //[dietContentDict setObject:foodAmount forKey:[LZUtility convertNumberToFoodIdStr:foodId]];
        [dietContentDict setObject:foodAmount forKey:foodId];
    }
    NSString *dietTitle =  [aDiet objectForKey:@"CollocationName"];
    NSDictionary *temp = [[NSDictionary alloc]initWithDictionary:dietContentDict];
    [[NSUserDefaults standardUserDefaults]setObject:temp forKey:LZUserDailyIntakeKey];
    [[NSUserDefaults  standardUserDefaults]synchronize];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZDietListMakeViewController * foodListViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZDietListMakeViewController"];
    foodListViewController.listType = dietListTypeOld;
    foodListViewController.title = dietTitle;
    foodListViewController.dietId = dietId;
    [self.navigationController pushViewController:foodListViewController animated:YES];
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
