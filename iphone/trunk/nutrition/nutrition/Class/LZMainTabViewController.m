//
//  LZMainTabViewController.m
//  nutrition
//
//  Created by liu miao on 7/2/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZMainTabViewController.h"
#import "LZEditProfileViewController.h"
#import "LZUtility.h"
@interface LZMainTabViewController ()

@end

@implementation LZMainTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (void)viewWillAppear:(BOOL)animated
//{
 
//}
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
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
