//
//  LZMainPageViewController.m
//  nutrition
//
//  Created by liu miao on 8/21/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZMainPageViewController.h"
#import "LZUserDietListViewController.h"
#import "LZSettingsViewController.h"
#import "LZHealthCheckViewController.h"
#import "LZUtility.h"
#import "LZEditProfileViewController.h"
#import "LZFoodSearchViewController.h"
#import "LZNutritionListViewController.h"
#import "LZHealthCheckViewController.h"
#import "MobClick.h"
#import "GADMasterViewController.h"
#import "LZConstants.h"
#import "LZMainMenuButton.h"
@interface LZMainPageViewController ()
{
    BOOL isFirstLoad;
}

@end

@implementation LZMainPageViewController
@synthesize menuArray,admobView;
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

    [self.view addSubview:self.admobView];
    int totalFloor = [self.menuArray count]/2+ (([self.menuArray count]%2 == 0)?0:1);
    float scrollHeight = totalFloor *145 + 20+ (totalFloor-1)*10+50;
    self.admobView = [[UIView alloc]initWithFrame:CGRectMake(0, scrollHeight-50, 320, 50)];
    [self.listView addSubview:self.admobView];
    [self.admobView setBackgroundColor:[UIColor clearColor]];
    [self.listView setContentSize:CGSizeMake(320, scrollHeight)];
    isFirstLoad = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:UmengPathZhuYeMian];
//    CGRect mobFrame = CGRectMake(0, self.view.frame.size.height-50, 320, 50);
//    self.admobView.frame = mobFrame;
    GADMasterViewController *shared = [GADMasterViewController singleton];
    [shared resetAdView:self andListView:self.admobView];
    if (isFirstLoad)
    {
        isFirstLoad = NO;
        [self setButtons];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:UmengPathZhuYeMian];
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
-(void)setButtons
{
    float startY = 10;
    int floor = 1;
    int perRowCount = 2;
    float startX;
    for (int i=0; i< [self.menuArray count]; i++)
    {
        
        if (i>=floor *perRowCount)
        {
            floor+=1;
        }
        startX = 10+(i-(floor-1)*perRowCount)*155;
        NSDictionary *menuItem = [self.menuArray objectAtIndex:i];
        NSString *itemName = [menuItem objectForKey:@"menuName"];

        LZMainMenuButton *button = [[LZMainMenuButton alloc]initWithFrame:CGRectMake(startX, startY+(floor-1)*155, 145, 145)];
        
        [self.listView addSubview:button];
        //button.typeIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_small.png",typeName]];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"menu_item_%d.png",i]] forState:UIControlStateNormal];
        button.tag = i+100;
        [button addTarget:self action:@selector(menuButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [button.itemTitleLabel setText:itemName];
    }


}
//#pragma mark- TableViewDataSource
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [self.menuArray count];
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    LZMainMenuItemCell * cell =(LZMainMenuItemCell*)[tableView dequeueReusableCellWithIdentifier:@"LZMainMenuItemCell"];
//    //NSString *typeName = [self.foodTypeArray objectAtIndex:indexPath.row];
//    NSDictionary *menuItem = [self.menuArray objectAtIndex:indexPath.row];
//    NSString *itemName = [menuItem objectForKey:@"menuName"];
//    cell.foodTypeNameLabel.text = itemName;
//    cell.arrowImage.hidden = YES;
//    [cell.foodTypeImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"menu_item_%d.png",indexPath.row]]];
//    //cell.foodTypeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",typeName]];
//    return cell;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 60;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 15;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 15)];
//    [sectionView setBackgroundColor:[UIColor clearColor]];
//    return sectionView;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 5;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
//    [sectionView setBackgroundColor:[UIColor clearColor]];
//    return sectionView;
//}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
-(void)menuButtonTapped:(UIButton *)sender
{
    int tag = sender.tag -100;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    if(tag == 0)
    {
        LZHealthCheckViewController *healthCheckViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZHealthCheckViewController"];
        [self.navigationController pushViewController:healthCheckViewController animated:YES];
    }
    else if (tag == 1)
    {
        LZFoodSearchViewController *foodSearchViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZFoodSearchViewController"];
        foodSearchViewController.isFromOut = YES;
        [self.navigationController pushViewController:foodSearchViewController animated:YES];
    }
    else if (tag == 2)
    {
        LZNutritionListViewController *nutritionListViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZNutritionListViewController"];
        [self.navigationController pushViewController:nutritionListViewController animated:YES];
    }
    else if (tag == 3)
    {
        LZUserDietListViewController *userDietListViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZUserDietListViewController"];
        [self.navigationController pushViewController:userDietListViewController animated:YES];
    }

    else if(tag == 4)
    {
        LZEditProfileViewController *editProfileViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZEditProfileViewController"];
        [self.navigationController pushViewController:editProfileViewController animated:YES];
    }
    else if(tag == 5)
    {
        LZSettingsViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZSettingsViewController"];
        [self.navigationController pushViewController:settingsViewController animated:YES];
    }
}

@end
