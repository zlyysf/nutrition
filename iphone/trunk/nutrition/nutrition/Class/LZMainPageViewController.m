//
//  LZMainPageViewController.m
//  nutrition
//
//  Created by liu miao on 8/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZMainPageViewController.h"
#import "LZMainMenuItemCell.h"
#import "LZUserDietListViewController.h"
#import "LZSettingsViewController.h"
#import "LZHealthCheckViewController.h"
#import "LZUtility.h"
#import "LZEditProfileViewController.h"
#import "LZFoodSearchViewController.h"
#import "LZNutritionListViewController.h"
#import "LZHealthCheckViewController.h"
#import "MobClick.h"
@interface LZMainPageViewController ()

@end

@implementation LZMainPageViewController
@synthesize menuArray;
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
    self.title = @"营养膳食指南";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"background@2x" ofType:@"png"];
    UIImage * backGroundImage = [UIImage imageWithContentsOfFile:path];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:backGroundImage]];
    self.menuArray = [[NSArray alloc]initWithObjects:
                      [NSDictionary dictionaryWithObjectsAndKeys:@"健康诊断",@"menuName", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"食物查询",@"menuName", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"营养元素",@"menuName", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"膳食清单",@"menuName", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"个人信息",@"menuName", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"设置",@"menuName", nil],nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"主页面"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"主页面"];
}
-(void)viewDidAppear:(BOOL)animated
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setListView:nil];
    [super viewDidUnload];
}
#pragma mark- TableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LZMainMenuItemCell * cell =(LZMainMenuItemCell*)[tableView dequeueReusableCellWithIdentifier:@"LZMainMenuItemCell"];
    //NSString *typeName = [self.foodTypeArray objectAtIndex:indexPath.row];
    NSDictionary *menuItem = [self.menuArray objectAtIndex:indexPath.row];
    NSString *itemName = [menuItem objectForKey:@"menuName"];
    cell.foodTypeNameLabel.text = itemName;
    cell.arrowImage.hidden = YES;
    [cell.foodTypeImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"menu_item_%d.png",indexPath.row]]];
    //cell.foodTypeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",typeName]];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.listView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    if(indexPath.row == 0)
    {
        LZHealthCheckViewController *healthCheckViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZHealthCheckViewController"];
        [self.navigationController pushViewController:healthCheckViewController animated:YES];
    }
    else if (indexPath.row == 1)
    {
        LZFoodSearchViewController *foodSearchViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZFoodSearchViewController"];
        foodSearchViewController.isFromOut = YES;
        [self.navigationController pushViewController:foodSearchViewController animated:YES];
    }
    else if (indexPath.row == 2)
    {
        LZNutritionListViewController *nutritionListViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZNutritionListViewController"];
        [self.navigationController pushViewController:nutritionListViewController animated:YES];
    }
    else if (indexPath.row == 3)
    {
        LZUserDietListViewController *userDietListViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZUserDietListViewController"];
        [self.navigationController pushViewController:userDietListViewController animated:YES];
    }

    else if(indexPath.row == 4)
    {
        LZEditProfileViewController *editProfileViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZEditProfileViewController"];
        //editProfileViewController.firstEnterEditView = YES;
        //addByNutrientController.foodArray = recommendFoodArray;
        //addByNutrientController.nutrientTitle = nutrientName;
        [self.navigationController pushViewController:editProfileViewController animated:YES];
//        LZDiseasePreventViewController *diseasePreventViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZDiseasePreventViewController"];
//        [self.navigationController pushViewController:diseasePreventViewController animated:YES];
    }
    else if(indexPath.row == 5)
    {
        LZSettingsViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZSettingsViewController"];
        [self.navigationController pushViewController:settingsViewController animated:YES];
    }

//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//    LZDailyIntakeViewController *dailyIntakeViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZDailyIntakeViewController"];
//    dailyIntakeViewController.foodArray = [self.foodNameArray objectAtIndex:indexPath.row];
//    dailyIntakeViewController.foodIntakeDictionary = self.foodIntakeDictionary;
//    dailyIntakeViewController.titleString = [self.foodTypeArray objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:dailyIntakeViewController animated:YES];
}

@end
