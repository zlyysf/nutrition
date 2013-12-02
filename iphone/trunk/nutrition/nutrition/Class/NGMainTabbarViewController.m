//
//  NGMainTabbarViewController.m
//  nutrition
//
//  Created by liu miao on 12/2/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "NGMainTabbarViewController.h"
#import "LZUtility.h"
#import "NGUerInfoViewController.h"
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
