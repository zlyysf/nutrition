//
//  NGMainTabbarViewController.m
//  nutrition
//
//  Created by liu miao on 12/2/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGMainTabbarViewController.h"
#import "LZUtility.h"
#import "NGDiagnoseViewController.h"
#import "NGRecordHistoryViewController.h"
#import "NGChartViewController.h"
#import "NGCyclopediaViewController.h"
#import "NGUerInfoViewController.h"

#import "NGFoodCombinationListViewController.h"

@interface NGMainTabbarViewController ()

@end

@implementation NGMainTabbarViewController

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
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewMainStoryboard" bundle:nil];
    UIStoryboard *storyboardModFCL = [UIStoryboard storyboardWithName:@"FoodCombinationList" bundle:nil];
    
    NSMutableArray *controllers = [NSMutableArray array];
    UINavigationController *nav;
    NGDiagnoseViewController *diagnoseViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGDiagnoseViewController"];
    nav = [[ UINavigationController alloc] initWithRootViewController:diagnoseViewController];
    nav.navigationBar.translucent = NO;
    UITabBarItem *diagnoseItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"jiankangjilu_c_title", @"页面标题：养生") image:[UIImage imageNamed:@"clinic-50.png"] tag:0];
    nav.tabBarItem = diagnoseItem;
    [controllers addObject:nav];
    
    NGRecordHistoryViewController *recordHistoryViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGRecordHistoryViewController"];
    nav = [[ UINavigationController alloc] initWithRootViewController:recordHistoryViewController];
    nav.navigationBar.translucent = NO;
    UITabBarItem *recordItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"lishi_c_title", @"页面标题：历史") image:[UIImage imageNamed:@"month_view-50.png"] tag:1];
    nav.tabBarItem = recordItem;
    [controllers addObject:nav];
    
    NGChartViewController *chartViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGChartViewController"];
    nav = [[ UINavigationController alloc] initWithRootViewController:chartViewController];
    nav.navigationBar.translucent = NO;
    UITabBarItem *chartItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"tubiao_c_title", @"页面标题：曲线") image:[UIImage imageNamed:@"line_chart-50.png"] tag:2];
    nav.tabBarItem = chartItem;
    [controllers addObject:nav];
    
    NGFoodCombinationListViewController *controllFcl = [storyboardModFCL instantiateViewControllerWithIdentifier:@"NGFoodCombinationListViewController"];
    nav = [[ UINavigationController alloc] initWithRootViewController:controllFcl];
    nav.navigationBar.translucent = NO;
    UITabBarItem *fclItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"qingdan_c_title", @"页面标题：清单") image:[UIImage imageNamed:@"diet_list-50.png"] tag:3];
    nav.tabBarItem = fclItem;
    [controllers addObject:nav];
    
    NGCyclopediaViewController *cyclopediaViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGCyclopediaViewController"];
    nav = [[ UINavigationController alloc] initWithRootViewController:cyclopediaViewController];
    nav.navigationBar.translucent = NO;
    UITabBarItem *recentItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"baike_c_title", @"页面标题：百科") image:[UIImage imageNamed:@"physics-50.png"] tag:4];
    nav.tabBarItem = recentItem;
    [controllers addObject:nav];
    
    NGUerInfoViewController *uerInfoViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGUerInfoViewController"];
    nav = [[ UINavigationController alloc] initWithRootViewController:uerInfoViewController];
    nav.navigationBar.translucent = NO;
    UITabBarItem *infoItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"xinxi_c_title", @"页面标题：信息") image:[UIImage imageNamed:@"info-50.png"] tag:5];
    nav.tabBarItem = infoItem;
    [controllers addObject:nav];
    
    self.viewControllers = controllers;
    if (IOS7_OR_LATER)
    {
        self.tabBar.translucent = NO;
    }
    
	// Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    if (![LZUtility isUserProfileComplete])
    {
        [LZUtility storeUserInfoWithDefault];

//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewMainStoryboard" bundle:nil];
//        NGUerInfoViewController *uerInfoViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGUerInfoViewController"];
//        uerInfoViewController.isPresented = YES;
//        //addByNutrientController.foodArray = recommendFoodArray;
//        //addByNutrientController.nutrientTitle = nutrientName;
//        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:uerInfoViewController];
//        [self presentModalViewController:navController animated:YES];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
