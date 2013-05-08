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
//    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
//                              [NSNumber numberWithInt:0],@"sex", [NSNumber numberWithInt:30],@"age",
//                              [NSNumber numberWithFloat:75],@"weight", [NSNumber numberWithFloat:172],@"height",
//                              [NSNumber numberWithInt:0],@"activityLevel", nil];
//    NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:nil andUserInfo:userInfo andOptions:nil];
    
    //case 2
//    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
//                              [NSNumber numberWithInt:0],@"sex", [NSNumber numberWithInt:30],@"age",
//                              [NSNumber numberWithFloat:75],@"weight", [NSNumber numberWithFloat:172],@"height",
//                              [NSNumber numberWithInt:0],@"activityLevel", nil];
//    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:FALSE],@"notAllowSameFood", nil];
//    NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:nil andUserInfo:userInfo andOptions:options];
    
    //case 2-2
    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithDouble:50.0],@"01123",//egg
                                         nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:0],@"sex", [NSNumber numberWithInt:30],@"age",
                              [NSNumber numberWithFloat:75],@"weight", [NSNumber numberWithFloat:172],@"height",
                              [NSNumber numberWithInt:0],@"activityLevel", nil];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:FALSE],@"notAllowSameFood", nil];
    NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andOptions:options];

    //case 2-3
//    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                         [NSNumber numberWithDouble:50.0],@"01123",//egg
//                                         [NSNumber numberWithDouble:100.0],@"10219",//pork
//                                         nil];
//    NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:takenFoodAmountDict sex:0 age:30 weight:80 height:172 activityLevel:1];

    //case 3
//    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:100.0],@"20450",//rice
//                                         [NSNumber numberWithDouble:50.0],@"01123",//egg
//                                         [NSNumber numberWithDouble:100.0],@"10219",//pork
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
