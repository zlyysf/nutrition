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
//    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                         [NSNumber numberWithDouble:50.0],@"01123",//egg
//                                         nil];
//    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
//                              [NSNumber numberWithInt:0],@"sex", [NSNumber numberWithInt:30],@"age",
//                              [NSNumber numberWithFloat:75],@"weight", [NSNumber numberWithFloat:172],@"height",
//                              [NSNumber numberWithInt:0],@"activityLevel", nil];
//    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:FALSE],@"notAllowSameFood", nil];
//    NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andOptions:options];

    //case 2-3
//    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                         [NSNumber numberWithDouble:50.0],@"01123",//egg
//                                         [NSNumber numberWithDouble:100.0],@"10219",//pork
//                                         nil];
//    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
//                              [NSNumber numberWithInt:0],@"sex", [NSNumber numberWithInt:30],@"age",
//                              [NSNumber numberWithFloat:75],@"weight", [NSNumber numberWithFloat:172],@"height",
//                              [NSNumber numberWithInt:0],@"activityLevel", nil];
//    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:FALSE],@"notAllowSameFood", nil];
//    NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andOptions:options];
    

    //case 3
//    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                         [NSNumber numberWithDouble:50.0],@"01123",//egg
//                                         [NSNumber numberWithDouble:100.0],@"10219",//pork
//                                         [NSNumber numberWithDouble:100.0],@"20450",//rice
//                                         nil];
//    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
//                              [NSNumber numberWithInt:0],@"sex", [NSNumber numberWithInt:30],@"age",
//                              [NSNumber numberWithFloat:75],@"weight", [NSNumber numberWithFloat:172],@"height",
//                              [NSNumber numberWithInt:0],@"activityLevel", nil];
//    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:TRUE],@"notAllowSameFood", nil];
//    NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andOptions:options];
    //case 3-2
    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithDouble:50.0],@"01123",//egg
                                         [NSNumber numberWithDouble:100.0],@"10219",//pork
                                         [NSNumber numberWithDouble:100.0],@"20450",//rice
                                         nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:0],@"sex", [NSNumber numberWithInt:30],@"age",
                              [NSNumber numberWithFloat:75],@"weight", [NSNumber numberWithFloat:172],@"height",
                              [NSNumber numberWithInt:0],@"activityLevel", nil];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:TRUE],@"notAllowSameFood", [NSNumber numberWithInt:2],@"randomRangeSelectFood", nil];
    NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andOptions:options];
    
    
    //test about reuse
//    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                         [NSNumber numberWithDouble:1.0],@"15008",//CARP,RAW
//                                         [NSNumber numberWithDouble:1.0],@"15261",//FISH,TILAPIA,RAW
//                                         [NSNumber numberWithDouble:1.0],@"01123",//EGG,WHL,RAW,FRSH
//                                         [NSNumber numberWithDouble:1.0],@"01138",//EGG,DUCK,WHOLE,FRESH,RAW
//                                         nil];
//    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
//                              [NSNumber numberWithInt:0],@"sex", [NSNumber numberWithInt:30],@"age",
//                              [NSNumber numberWithFloat:75],@"weight", [NSNumber numberWithFloat:172],@"height",
//                              [NSNumber numberWithInt:0],@"activityLevel", nil];
//    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:TRUE],@"notAllowSameFood", nil];
//    NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andOptions:options];
    
    
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:@"recommend1.csv" withRecommendResult:retDict];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
