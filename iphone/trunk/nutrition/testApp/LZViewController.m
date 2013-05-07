//
//  LZViewController.m
//  testApp
//
//  Created by Yasofon on 13-5-3.
//  Copyright (c) 2013年 lingzhi mobile. All rights reserved.
//

#import "LZViewController.h"
#import "LZDataAccess.h"
#import "LZRecommendFood.h"



@interface LZViewController ()

@end

@implementation LZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    LZDataAccess *da = [LZDataAccess singleton];
//    [da getAllFood];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];

    //case 1
    NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:nil sex:0 age:30 weight:75 height:172 activityLevel:0];
    
    //case 1-2
//    NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:nil sex:0 age:30 weight:75 height:172 activityLevel:3];

    //case 2
//    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:200.0],@"20450",
//                                         [NSNumber numberWithDouble:50.0],@"01123",
//                                         [NSNumber numberWithDouble:100.0],@"10219",
//                                         nil];
//    NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:takenFoodAmountDict sex:0 age:30 weight:80 height:172 activityLevel:1];
    
//    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:100.0],@"20450",
//                                         [NSNumber numberWithDouble:50.0],@"01123",
//                                         [NSNumber numberWithDouble:100.0],@"10219",
//                                         nil];
//    NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:takenFoodAmountDict sex:0 age:25 weight:55 height:172 activityLevel:1];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:@"recommend1.csv" withRecommendResult:retDict];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
