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
    
    
    
    NGDiagnoseViewController *diagnoseViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGDiagnoseViewController"];
    UINavigationController *nav = [[ UINavigationController alloc] initWithRootViewController:diagnoseViewController];
    nav.navigationBar.translucent = NO;
    UITabBarItem *diagnoseItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"jiankangjilu_c_title", @"页面标题：养生") image:[UIImage imageNamed:@"clinic-50.png"] tag:0];
    nav.tabBarItem = diagnoseItem;
    
    NGRecordHistoryViewController *recordHistoryViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGRecordHistoryViewController"];
    UINavigationController *nav1 = [[ UINavigationController alloc] initWithRootViewController:recordHistoryViewController];
    nav1.navigationBar.translucent = NO;
    UITabBarItem *recordItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"lishi_c_title", @"页面标题：历史") image:[UIImage imageNamed:@"month_view-50.png"] tag:1];
    nav1.tabBarItem = recordItem;
    
    NGChartViewController *chartViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGChartViewController"];
    UINavigationController *nav2 = [[ UINavigationController alloc] initWithRootViewController:chartViewController];
    nav2.navigationBar.translucent = NO;
    UITabBarItem *chartItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"tubiao_c_title", @"页面标题：曲线") image:[UIImage imageNamed:@"line_chart-50.png"] tag:2];
    nav2.tabBarItem = chartItem;
    
    NGCyclopediaViewController *cyclopediaViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGCyclopediaViewController"];
    UINavigationController *nav3 = [[ UINavigationController alloc] initWithRootViewController:cyclopediaViewController];
    nav3.navigationBar.translucent = NO;
    UITabBarItem *recentItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"baike_c_title", @"页面标题：百科") image:[UIImage imageNamed:@"physics-50.png"] tag:3];
    nav3.tabBarItem = recentItem;
    
    NGUerInfoViewController *uerInfoViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGUerInfoViewController"];
    UINavigationController *nav4 = [[ UINavigationController alloc] initWithRootViewController:uerInfoViewController];
    nav4.navigationBar.translucent = NO;
    UITabBarItem *infoItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"xinxi_c_title", @"页面标题：信息") image:[UIImage imageNamed:@"info-50.png"] tag:4];
    nav4.tabBarItem = infoItem;
    
    NGFoodCombinationListViewController *controllFcl = [storyboardModFCL instantiateViewControllerWithIdentifier:@"NGFoodCombinationListViewController"];
    UINavigationController *nav5 = [[ UINavigationController alloc] initWithRootViewController:controllFcl];
    nav5.navigationBar.translucent = NO;
    UITabBarItem *fclItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"qingdan_c_title", @"页面标题：清单") image:[UIImage imageNamed:@"info-50.png"] tag:5];
    nav5.tabBarItem = fclItem;
    
    
    NSMutableArray *controllers = [NSMutableArray arrayWithObjects: nav,nav1,nav2,nav3,nav4,nav5,nil];
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
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewMainStoryboard" bundle:nil];
        NGUerInfoViewController *uerInfoViewController = [storyboard instantiateViewControllerWithIdentifier:@"NGUerInfoViewController"];
        uerInfoViewController.isPresented = YES;
        //addByNutrientController.foodArray = recommendFoodArray;
        //addByNutrientController.nutrientTitle = nutrientName;
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:uerInfoViewController];
        [self presentModalViewController:navController animated:YES];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
