//
//  LZViewController.m
//  nutrition
//
//  Created by liu miao on 4/26/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZViewController.h"

#import "LZRecommendFood.h"

@interface LZViewController ()

@end

@implementation LZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    [rf recommendFoodForEnoughNuitrition:0 age:30 weight:80 height:172 activityLevel:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
