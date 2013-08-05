//
//  LZTest1.m
//  nutrition
//
//  Created by Yasofon on 13-5-16.
//  Copyright (c) 2013年 lingzhi mobile. All rights reserved.
//

#import "LZTest1.h"
#import "LZDataAccess.h"
#import "LZRecommendFood.h"
#import "LZUtility.h"
#import "LZConstants.h"

@implementation LZTest1

+(void)testMain
{
//    [LZTest1 test1];
//    [LZTest1 test2];
//    [LZTest1 test3];
//    [LZTest1 test4];
    [LZTest1 testRecommendFoodBySmallIncrement];
}

+(void)test1
{

//    [self.class caseUser1_randseed_1];
//    [self.class caseUser1_preTaken_4full];
//    [self.class testDA1];
//    [self.class test_insertFoodCollocationData_withCollocationName];
//    [self.class test_getFoodCollocationData];
//    [self.class test_updateFoodCollocationData_withCollocationId];
//    [self.class test_deleteFoodCollocationData_withCollocationId];
    
//    [self.class testFormatResult1];
//    [self.class testFormatResult2_taken];
//    [self.class testFormatResult_foodStarndard];
//    [self.class test_calculateGiveFoodsSupplyNutrientAndFormatForUI];
    [self.class test_calculateGiveFoodsSupplyNutrientAndFormatForUI_withRecommend];
//    [self.class test_calculateGiveFoodsSupplyNutrientAndFormatForUI_empty];
}


+(void)test2
{
    [self.class caseUser1_simple];
    
    [self.class caseUser1_preTaken_1];
    [self.class caseUser1_preTaken_2];
    [self.class caseUser1_preTaken_3];
    
    [self.class caseUser1_reuse];
    
    [self.class caseUser1_rand_1];
    [self.class caseUser1_rand_2];
    

    [self.class caseUser1_req_1];
}

+(void)test3
{
//    [self.class caseAbstractUser1_simple];
//    [self.class caseAbstractUser1_req];
//    [self.class caseAbstractUser1_req_preTaken_1];

    
}

+(void)test4
{
//    [self.class caseMiltipleUser1_simple_pd1];
//    [self.class caseMiltipleUser1_simple_pd5];
//    [self.class caseMiltipleUser1_limitNut_pd1];
//    [self.class caseMiltipleUser1_limitNut_pd5];
//    [self.class caseMiltipleUser1_simple_pd1_r2];
//    [self.class caseMiltipleUser1_pretakenVegetable1_pd1];
//    [self.class caseMiltipleUser1_pretakenVegetable2_pd1];
//    [self.class caseMiltipleUser1_pretakenVegetable3_pd1];
//    [self.class caseMiltipleUser1_pretakenSemiMeat1_pd1];
//    [self.class caseMiltipleUser1_pretakenSemiMeat1_pd5];
//    [self.class caseMulAbstractUser1_pretakenNearFull_pd1];
    [self.class caseAbstractUserWithRandToReproduce1];
}

+(void)testRecommendFoodBySmallIncrement
{
    [self.class caseUser_recSI_preTaken_0];
//    [self.class caseUser_recSI_preTaken_0_givenNutrients];
//    [self.class caseUser_recSI_preTaken_0_sameOptionsAsAppForLinearSystemCompare];
}

+(NSString*)getParamsDigestStr_withUserInfo:(NSDictionary *)userInfo andOptions:(NSDictionary *)options andTakenFoodAmountDict:(NSDictionary *)takenFoodAmountDict
{
    return [self.class getParamsDigestStr_withUserInfo:userInfo andParams:nil andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
}
+(NSString*)getParamsDigestStr_withUserInfo:(NSDictionary *)userInfo andParams:(NSDictionary*)params andOptions:(NSDictionary *)options andTakenFoodAmountDict:(NSDictionary *)takenFoodAmountDict
{
    NSMutableString *str = [NSMutableString string];
    if (userInfo!=nil){
        NSNumber *nmSex = [userInfo objectForKey:@"sex"];
        NSNumber *nmAge = [userInfo objectForKey:@"age"];
        NSNumber *nmWeight = [userInfo objectForKey:@"weight"];
        NSNumber *nmHeight = [userInfo objectForKey:@"height"];
        NSNumber *nmActivityLevel = [userInfo objectForKey:@"activityLevel"];
        assert(nmSex != nil);
        assert(nmAge != nil);
        assert(nmWeight != nil);
        assert(nmHeight != nil);
        assert(nmActivityLevel != nil);
        int sex = [nmSex intValue];
        int age = [nmAge intValue];
        float weight = [nmWeight floatValue];
        float height = [nmHeight floatValue];
        int activityLevel = [nmActivityLevel intValue];
        [str appendFormat:@"s%dY%dw%.0fh%.0fa%d",sex,age,weight,height,activityLevel ];
    }
    
    if (params!=nil){
        NSNumber *nm_personDayCount = [params objectForKey:@"personDayCount"];
        int personDayCount = 1;
        if (nm_personDayCount != nil){
            personDayCount = [nm_personDayCount intValue];
        }
        [str appendFormat:@"_pd%d",personDayCount ];
    }
    
    BOOL notAllowSameFood = TRUE;//这是一个策略标志位，偏好食物的多样化的标志位，即当选取食物补充营养时，优先选取以前没有用过的食物。
    BOOL randomSelectFood = TRUE;
    int randomRangeSelectFood = 0;//配合randomSelectFood，用于限制随机范围，0表示不限制, >0表示优先选择其范围内的东西
    BOOL needLimitNutrients = TRUE;//是否要根据需求限制计算的营养素集合
    int limitRecommendFoodCount = 2;//0;//4;//只限制显示的
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    
    BOOL needConsiderNutrientLoss = FALSE;
    BOOL needUseLowLimitAsUnit = TRUE;
    assert(options != nil);
    
    NSNumber *nmFlag_notAllowSameFood = [options objectForKey:@"notAllowSameFood"];
    if (nmFlag_notAllowSameFood != nil)
        notAllowSameFood = [nmFlag_notAllowSameFood boolValue];
        
    NSNumber *nmFlag_randomSelectFood = [options objectForKey:@"randomSelectFood"];
    if(nmFlag_randomSelectFood != nil)
        randomSelectFood = [nmFlag_randomSelectFood boolValue];
        
    NSNumber *nm_randomRangeSelectFood = [options objectForKey:@"randomRangeSelectFood"];
    if(nm_randomRangeSelectFood != nil)
        randomRangeSelectFood = [nm_randomRangeSelectFood intValue];
        
    NSNumber *nmFlag_needLimitNutrients = [options objectForKey:@"needLimitNutrients"];
    if(nmFlag_needLimitNutrients != nil)
        needLimitNutrients = [nmFlag_needLimitNutrients boolValue];
    
    NSNumber *nm_limitRecommendFoodCount = [options objectForKey:@"limitRecommendFoodCount"];
    if(nm_limitRecommendFoodCount != nil)
        limitRecommendFoodCount = [nm_limitRecommendFoodCount intValue];
    
    NSNumber *nmFlag_needUseFoodLimitTableWhenCal = [options objectForKey:@"needUseFoodLimitTableWhenCal"];
    if(nmFlag_needUseFoodLimitTableWhenCal != nil)
        needUseFoodLimitTableWhenCal = [nmFlag_needUseFoodLimitTableWhenCal boolValue];
    
    NSNumber *nmFlag_needConsiderNutrientLoss = [options objectForKey:@"needConsiderNutrientLoss"];
    if(nmFlag_needConsiderNutrientLoss != nil)
        needConsiderNutrientLoss = [nmFlag_needConsiderNutrientLoss boolValue];
    
    NSNumber *nmFlag_needUseLowLimitAsUnit = [options objectForKey:@"needUseLowLimitAsUnit"];
    if(nmFlag_needUseLowLimitAsUnit != nil)
        needUseLowLimitAsUnit = [nmFlag_needUseLowLimitAsUnit boolValue];
    
    [str appendFormat:@"_M%dr%drr%dLn%dLc%dFL%dNL%dLLU%d",
        notAllowSameFood,randomSelectFood,randomRangeSelectFood,needLimitNutrients,limitRecommendFoodCount, needUseFoodLimitTableWhenCal
        ,needConsiderNutrientLoss,needUseLowLimitAsUnit];
    
    NSArray *keys = takenFoodAmountDict.allKeys;
    for(int i=0; i<keys.count; i++){
        NSString *key = keys[i];
        NSNumber *nmAmount = [takenFoodAmountDict objectForKey:key];
        NSString *s1 = [NSString stringWithFormat:@"_%@-%.0f",key,[nmAmount doubleValue]];
        [str appendString:s1];
    }
    return str;
}

+(void)caseUser1_simple
{
    NSDictionary *takenFoodAmountDict = nil;
    int sex = 0;//Male
    int age = 25;
    float weight=75;//kg
    float height = 172;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],@"sex", [NSNumber numberWithInt:age],@"age",
                              [NSNumber numberWithFloat:weight],@"weight", [NSNumber numberWithFloat:height],@"height",
                              [NSNumber numberWithInt:activityLevel],@"activityLevel", nil];
    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = FALSE;
    int randomRangeSelectFood = 0;
    BOOL needLimitNutrients = FALSE;
    int limitRecommendFoodCount = 0;
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];

    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    
}


+(void)caseUser1_req_1
{
    NSDictionary *takenFoodAmountDict = nil;
    int sex = 0;//Male
    int age = 25;
    float weight=75;//kg
    float height = 172;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],@"sex", [NSNumber numberWithInt:age],@"age",
                              [NSNumber numberWithFloat:weight],@"weight", [NSNumber numberWithFloat:height],@"height",
                              [NSNumber numberWithInt:activityLevel],@"activityLevel", nil];
    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = TRUE;
    int randomRangeSelectFood = 2;
    BOOL needLimitNutrients = TRUE;
    int limitRecommendFoodCount = 0;//4;
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    
}



//pre taken
+(void)caseUser1_preTaken_1
{
    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithDouble:100.0],@"20450",//rice
                                         nil];
    int sex = 0;//Male
    int age = 25;
    float weight=75;//kg
    float height = 172;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],@"sex", [NSNumber numberWithInt:age],@"age",
                              [NSNumber numberWithFloat:weight],@"weight", [NSNumber numberWithFloat:height],@"height",
                              [NSNumber numberWithInt:activityLevel],@"activityLevel", nil];
    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = FALSE;
    int randomRangeSelectFood = 0;
    BOOL needLimitNutrients = FALSE;
    int limitRecommendFoodCount = 0;
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    
}

//pre taken
+(void)caseUser1_preTaken_2
{
    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithDouble:50.0],@"01123",//egg
                                         [NSNumber numberWithDouble:100.0],@"20450",//rice
                                         nil];
    int sex = 0;//Male
    int age = 25;
    float weight=75;//kg
    float height = 172;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],@"sex", [NSNumber numberWithInt:age],@"age",
                              [NSNumber numberWithFloat:weight],@"weight", [NSNumber numberWithFloat:height],@"height",
                              [NSNumber numberWithInt:activityLevel],@"activityLevel", nil];
    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = FALSE;
    int randomRangeSelectFood = 0;
    BOOL needLimitNutrients = FALSE;
    int limitRecommendFoodCount = 0;
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    
}


//pre taken
+(void)caseUser1_preTaken_3
{
    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithDouble:50.0],@"01123",//egg
                                         [NSNumber numberWithDouble:100.0],@"10219",//pork
                                         [NSNumber numberWithDouble:100.0],@"20450",//rice
                                         nil];
    int sex = 0;//Male
    int age = 25;
    float weight=75;//kg
    float height = 172;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],@"sex", [NSNumber numberWithInt:age],@"age",
                              [NSNumber numberWithFloat:weight],@"weight", [NSNumber numberWithFloat:height],@"height",
                              [NSNumber numberWithInt:activityLevel],@"activityLevel", nil];
    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = FALSE;
    int randomRangeSelectFood = 0;
    BOOL needLimitNutrients = FALSE;
    int limitRecommendFoodCount = 0;
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    
}

+(void)caseUser1_preTaken_4full
{
    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithDouble:120.0],@"01123",//egg
                                         [NSNumber numberWithDouble:100.0],@"10219",//pork
                                         [NSNumber numberWithDouble:200.0],@"20450",//rice
                                         
                                         [NSNumber numberWithDouble:200.0],@"16014",//heidou
                                         [NSNumber numberWithDouble:100.0],@"09148",//mihoutao
                                         [NSNumber numberWithDouble:200.0],@"11457",//bocai
                                         [NSNumber numberWithDouble:50.0],@"12036",//guazi
                                         
                                         [NSNumber numberWithDouble:100.0],@"10110",//zhugan
                                         [NSNumber numberWithDouble:100.0],@"01005",//nailao
                                         [NSNumber numberWithDouble:100.0],@"15008",//liyu
                                         
                                         
                                         nil];
    int sex = 0;//Male
    int age = 25;
    float weight=75;//kg
    float height = 172;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],@"sex", [NSNumber numberWithInt:age],@"age",
                              [NSNumber numberWithFloat:weight],@"weight", [NSNumber numberWithFloat:height],@"height",
                              [NSNumber numberWithInt:activityLevel],@"activityLevel", nil];
    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = FALSE;
    int randomRangeSelectFood = 0;
    BOOL needLimitNutrients = FALSE;
    int limitRecommendFoodCount = 0;
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    
}

+(void)caseUser1_reuse
{
    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithDouble:1.0],@"15008",//CARP,RAW
                                         [NSNumber numberWithDouble:1.0],@"15261",//FISH,TILAPIA,RAW
                                         [NSNumber numberWithDouble:1.0],@"01123",//EGG,WHL,RAW,FRSH
                                         [NSNumber numberWithDouble:1.0],@"01138",//EGG,DUCK,WHOLE,FRESH,RAW
                                         nil];
    int sex = 0;//Male
    int age = 25;
    float weight=75;//kg
    float height = 172;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],@"sex", [NSNumber numberWithInt:age],@"age",
                              [NSNumber numberWithFloat:weight],@"weight", [NSNumber numberWithFloat:height],@"height",
                              [NSNumber numberWithInt:activityLevel],@"activityLevel", nil];
    BOOL notAllowSameFood = FALSE;
    BOOL randomSelectFood = FALSE;
    int randomRangeSelectFood = 0;
    BOOL needLimitNutrients = FALSE;
    int limitRecommendFoodCount = 0;
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    
}

//random select
+(void)caseUser1_rand_1
{
    NSDictionary *takenFoodAmountDict = nil;
    int sex = 0;//Male
    int age = 25;
    float weight=75;//kg
    float height = 172;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],@"sex", [NSNumber numberWithInt:age],@"age",
                              [NSNumber numberWithFloat:weight],@"weight", [NSNumber numberWithFloat:height],@"height",
                              [NSNumber numberWithInt:activityLevel],@"activityLevel", nil];
    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = TRUE;
    int randomRangeSelectFood = 2;
    BOOL needLimitNutrients = FALSE;
    int limitRecommendFoodCount = 0;
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    
}

//random select
+(void)caseUser1_rand_2
{
    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithDouble:50.0],@"01123",//egg
                                         [NSNumber numberWithDouble:100.0],@"20450",//rice
                                         nil];
    int sex = 0;//Male
    int age = 25;
    float weight=75;//kg
    float height = 172;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],@"sex", [NSNumber numberWithInt:age],@"age",
                              [NSNumber numberWithFloat:weight],@"weight", [NSNumber numberWithFloat:height],@"height",
                              [NSNumber numberWithInt:activityLevel],@"activityLevel", nil];
    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = TRUE;
    int randomRangeSelectFood = 2;
    BOOL needLimitNutrients = FALSE;
    int limitRecommendFoodCount = 0;
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    
}


+(void)caseUser1_randseed_1
{
    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithDouble:50.0],@"01123",//egg
                                         [NSNumber numberWithDouble:100.0],@"20450",//rice
                                         nil];
    int sex = 0;//Male
    int age = 25;
    float weight=75;//kg
    float height = 172;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],@"sex", [NSNumber numberWithInt:age],@"age",
                              [NSNumber numberWithFloat:weight],@"weight", [NSNumber numberWithFloat:height],@"height",
                              [NSNumber numberWithInt:activityLevel],@"activityLevel", nil];
    uint randSeed = 1234;
    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = TRUE;
    int randomRangeSelectFood = 2;
    BOOL needLimitNutrients = FALSE;
    int limitRecommendFoodCount = 0;
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithUnsignedInt:randSeed],@"randSeed",
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFoodForEnoughNuitritionWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    
}



+(void)caseAbstractUser1_simple
{
    NSDictionary *takenFoodAmountDict = nil;

    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = FALSE;
    int randomRangeSelectFood = 0;
    BOOL needLimitNutrients = FALSE;
    int limitRecommendFoodCount = 0;
    BOOL needUseFoodLimitTableWhenCal = FALSE;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:nil andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];

    uint personCount = 1;
    uint dayCount = 5;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithUnsignedInt:personCount],@"personCount",
                            [NSNumber numberWithUnsignedInt:dayCount],@"dayCount", nil];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFood_AbstractPerson:params withDecidedFoods:takenFoodAmountDict andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
}



+(void)caseAbstractUser1_req
{
    NSDictionary *takenFoodAmountDict = nil;
    
    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = TRUE;
    int randomRangeSelectFood = 2;
    BOOL needLimitNutrients = TRUE;
    int limitRecommendFoodCount = 0;
    BOOL needUseFoodLimitTableWhenCal = FALSE;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:nil andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    
    uint personCount = 1;
    uint dayCount = 5;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithUnsignedInt:personCount],@"personCount",
                            [NSNumber numberWithUnsignedInt:dayCount],@"dayCount", nil];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFood_AbstractPerson:params withDecidedFoods:takenFoodAmountDict andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
}



+(void)caseAbstractUser1_req_preTaken_1
{
    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithDouble:300.0],@"01123",//egg
                                         [NSNumber numberWithDouble:900.0],@"10219",//pork
                                         [NSNumber numberWithDouble:600.0],@"20450",//rice
                                         nil];
    
    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = TRUE;
    int randomRangeSelectFood = 2;
    BOOL needLimitNutrients = TRUE;
    int limitRecommendFoodCount = 0;
    BOOL needUseFoodLimitTableWhenCal = FALSE;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:nil andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    
    uint personCount = 1;
    uint dayCount = 5;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithUnsignedInt:personCount],@"personCount",
                            [NSNumber numberWithUnsignedInt:dayCount],@"dayCount", nil];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFood_AbstractPerson:params withDecidedFoods:takenFoodAmountDict andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
}





+(void)caseMiltipleUser1_simple_pd5
{
    NSDictionary *takenFoodAmountDict = nil;
    int sex = 0;//Male
    int age = 25;
    float weight=75;//kg
    float height = 172;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],@"sex", [NSNumber numberWithInt:age],@"age",
                              [NSNumber numberWithFloat:weight],@"weight", [NSNumber numberWithFloat:height],@"height",
                              [NSNumber numberWithInt:activityLevel],@"activityLevel", nil];
    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = FALSE;
    int randomRangeSelectFood = 0;
    BOOL needLimitNutrients = FALSE;
    int limitRecommendFoodCount = 0;
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             nil];
    
    uint personDayCount = 5;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithUnsignedInt:personDayCount],@"personDayCount",
                            nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andParams:params andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    

    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFood2WithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    
}



+(void)caseMiltipleUser1_simple_pd1
{
    NSDictionary *takenFoodAmountDict = nil;
    int sex = 0;//Male
    int age = 25;
    float weight=75;//kg
    float height = 172;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],@"sex", [NSNumber numberWithInt:age],@"age",
                              [NSNumber numberWithFloat:weight],@"weight", [NSNumber numberWithFloat:height],@"height",
                              [NSNumber numberWithInt:activityLevel],@"activityLevel", nil];
    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = FALSE;
    int randomRangeSelectFood = 0;
    BOOL needLimitNutrients = FALSE;
    int limitRecommendFoodCount = 0;
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             nil];
    
    uint personDayCount = 1;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithUnsignedInt:personDayCount],@"personDayCount",
                            nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andParams:params andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    
    
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFood2WithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    
}

+(void)caseMiltipleUser1_simple_pd1_r2
{
    NSDictionary *takenFoodAmountDict = nil;
    int sex = 0;//Male
    int age = 25;
    float weight=75;//kg
    float height = 172;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],@"sex", [NSNumber numberWithInt:age],@"age",
                              [NSNumber numberWithFloat:weight],@"weight", [NSNumber numberWithFloat:height],@"height",
                              [NSNumber numberWithInt:activityLevel],@"activityLevel", nil];
    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = TRUE;
    int randomRangeSelectFood = 2;
    BOOL needLimitNutrients = FALSE;
    int limitRecommendFoodCount = 0;
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             nil];
    
    uint personDayCount = 1;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithUnsignedInt:personDayCount],@"personDayCount",
                            nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andParams:params andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    
    
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFood2WithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    
}



+(void)caseMiltipleUser1_pretakenVegetable1_pd1
{

    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithDouble:200.0],@"20450",//rice
                                         [NSNumber numberWithDouble:100.0],@"16108",//huangdou
                                         [NSNumber numberWithDouble:200.0],@"09003",//apple
                                         nil];

    
    int sex = 0;//Male
    int age = 25;
    float weight=75;//kg
    float height = 172;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],@"sex", [NSNumber numberWithInt:age],@"age",
                              [NSNumber numberWithFloat:weight],@"weight", [NSNumber numberWithFloat:height],@"height",
                              [NSNumber numberWithInt:activityLevel],@"activityLevel", nil];
    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = FALSE;
    int randomRangeSelectFood = 0;
    BOOL needLimitNutrients = FALSE;
    int limitRecommendFoodCount = 0;
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             nil];
    
    uint personDayCount = 1;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithUnsignedInt:personDayCount],@"personDayCount",
                            nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andParams:params andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    
    
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFood2WithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    
}



+(void)caseMiltipleUser1_pretakenVegetable2_pd1
{
    
    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithDouble:200.0],@"20450",//rice
                                         [NSNumber numberWithDouble:100.0],@"16108",//huangdou
                                         [NSNumber numberWithDouble:200.0],@"11116",//youcai
                                         nil];
    
    
    int sex = 0;//Male
    int age = 25;
    float weight=75;//kg
    float height = 172;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],@"sex", [NSNumber numberWithInt:age],@"age",
                              [NSNumber numberWithFloat:weight],@"weight", [NSNumber numberWithFloat:height],@"height",
                              [NSNumber numberWithInt:activityLevel],@"activityLevel", nil];
    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = FALSE;
    int randomRangeSelectFood = 0;
    BOOL needLimitNutrients = FALSE;
    int limitRecommendFoodCount = 0;
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             nil];
    
    uint personDayCount = 1;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithUnsignedInt:personDayCount],@"personDayCount",
                            nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andParams:params andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    
    
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFood2WithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    
}




+(void)caseMiltipleUser1_pretakenVegetable3_pd1
{
    
    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithDouble:200.0],@"20450",//rice
                                         [NSNumber numberWithDouble:100.0],@"16108",//huangdou
                                         [NSNumber numberWithDouble:200.0],@"11116",//youcai
                                         [NSNumber numberWithDouble:150.0],@"16022",//doujiao
                                         nil];
    
    
    int sex = 0;//Male
    int age = 25;
    float weight=75;//kg
    float height = 172;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],@"sex", [NSNumber numberWithInt:age],@"age",
                              [NSNumber numberWithFloat:weight],@"weight", [NSNumber numberWithFloat:height],@"height",
                              [NSNumber numberWithInt:activityLevel],@"activityLevel", nil];
    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = FALSE;
    int randomRangeSelectFood = 0;
    BOOL needLimitNutrients = FALSE;
    int limitRecommendFoodCount = 0;
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             nil];
    
    uint personDayCount = 1;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithUnsignedInt:personDayCount],@"personDayCount",
                            nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andParams:params andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    
    
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFood2WithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    
}



+(void)caseMiltipleUser1_pretakenSemiMeat1_pd1
{
    
    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithDouble:200.0],@"20450",//rice
                                         [NSNumber numberWithDouble:100.0],@"16108",//huangdou
                                         [NSNumber numberWithDouble:200.0],@"11116",//youcai
                                         [NSNumber numberWithDouble:150.0],@"16022",//doujiao
                                         [NSNumber numberWithDouble:100.0],@"01123",//egg
                                         nil];
    
    
    int sex = 0;//Male
    int age = 25;
    float weight=75;//kg
    float height = 172;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],@"sex", [NSNumber numberWithInt:age],@"age",
                              [NSNumber numberWithFloat:weight],@"weight", [NSNumber numberWithFloat:height],@"height",
                              [NSNumber numberWithInt:activityLevel],@"activityLevel", nil];
    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = FALSE;
    int randomRangeSelectFood = 0;
    BOOL needLimitNutrients = FALSE;
    int limitRecommendFoodCount = 0;
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             nil];
    
    uint personDayCount = 1;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithUnsignedInt:personDayCount],@"personDayCount",
                            nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andParams:params andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    
    
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFood2WithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    
}



+(void)caseMiltipleUser1_pretakenSemiMeat1_pd5
{
    
    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithDouble:200.0],@"20450",//rice
                                         [NSNumber numberWithDouble:100.0],@"16108",//huangdou
                                         [NSNumber numberWithDouble:500.0],@"11116",//youcai
                                         [NSNumber numberWithDouble:1000.0],@"16022",//doujiao
                                         [NSNumber numberWithDouble:100.0],@"01123",//egg
                                         nil];
    
    
    int sex = 0;//Male
    int age = 25;
    float weight=75;//kg
    float height = 172;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],@"sex", [NSNumber numberWithInt:age],@"age",
                              [NSNumber numberWithFloat:weight],@"weight", [NSNumber numberWithFloat:height],@"height",
                              [NSNumber numberWithInt:activityLevel],@"activityLevel", nil];
    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = FALSE;
    int randomRangeSelectFood = 0;
    BOOL needLimitNutrients = FALSE;
    int limitRecommendFoodCount = 0;
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             nil];
    
    uint personDayCount = 5;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithUnsignedInt:personDayCount],@"personDayCount",
                            nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andParams:params andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    
    
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFood2WithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    
}



+(void)caseMulAbstractUser1_pretakenNearFull_pd1
{
    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithDouble:500.0],@"15020",//huanghuayu
                                         [NSNumber numberWithDouble:500.0],@"20450",//rice
                                         [NSNumber numberWithDouble:500.0],@"01152",//milk
                                         [NSNumber numberWithDouble:500.0],@"16014",//heidou
                                         [NSNumber numberWithDouble:500.0],@"11167",//yumi
                                         [NSNumber numberWithDouble:300.0],@"15050",//qingyu
                                         [NSNumber numberWithDouble:300.0],@"12036",//guazi
                                         [NSNumber numberWithDouble:400.0],@"13047",//beef
                                         [NSNumber numberWithDouble:400.0],@"09326",//xigua
                                         nil];

    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = TRUE;
    int randomRangeSelectFood = 4;
    BOOL needLimitNutrients = TRUE;
    int limitRecommendFoodCount = 4;
    BOOL needUseFoodLimitTableWhenCal = TRUE;
//    uint randSeed = 1519860424;
    uint randSeed = 0;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             [NSNumber numberWithUnsignedInt:randSeed],@"randSeed",
                             nil];
    
    uint personCount = 1;
    uint dayCount = 1;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithUnsignedInt:personCount],@"personCount",
                            [NSNumber numberWithUnsignedInt:dayCount],@"dayCount",
                            nil];

    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:nil andParams:params andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    NSLog(@"htmlFilePath=%@",htmlFilePath);
    
    
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFood2_AbstractPerson:params withDecidedFoods:takenFoodAmountDict andOptions:options];
//    NSMutableDictionary *retDict = [rf recommendFood2WithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    
    NSMutableDictionary *uiDictionary = [rf formatRecommendResultForUI:retDict];
    NSLog(@"uiDictionary %@",[uiDictionary allKeys]);

    
}





+(void)caseAbstractUserWithRandToReproduce1
{
    NSDictionary *takenFoodAmountDict = nil;
//    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                         [NSNumber numberWithDouble:250.0],@"11233",//jielan
//                                         nil];
    
    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = TRUE;
    int randomRangeSelectFood = 20;
    BOOL needLimitNutrients = TRUE;
    int limitRecommendFoodCount = 40;
    BOOL needUseFoodLimitTableWhenCal = TRUE;
//    uint randSeed = 57246344;
    uint randSeed =0 ;

    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             [NSNumber numberWithUnsignedInt:randSeed],@"randSeed",
                             nil];
    
    uint personCount = 1;
    uint dayCount = 1;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithUnsignedInt:personCount],@"personCount",
                            [NSNumber numberWithUnsignedInt:dayCount],@"dayCount",
                            nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:nil andParams:params andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    NSLog(@"htmlFilePath=%@",htmlFilePath);
    
    
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFood3_AbstractPerson:params withDecidedFoods:takenFoodAmountDict andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    
}




+(void)caseMiltipleUser1_limitNut_pd1
{
    NSDictionary *takenFoodAmountDict = nil;
    int sex = 0;//Male
    int age = 25;
    float weight=75;//kg
    float height = 172;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],@"sex", [NSNumber numberWithInt:age],@"age",
                              [NSNumber numberWithFloat:weight],@"weight", [NSNumber numberWithFloat:height],@"height",
                              [NSNumber numberWithInt:activityLevel],@"activityLevel", nil];
    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = FALSE;
    int randomRangeSelectFood = 0;
    BOOL needLimitNutrients = TRUE;
    int limitRecommendFoodCount = 0;
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             nil];
    
    uint personDayCount = 1;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithUnsignedInt:personDayCount],@"personDayCount",
                            nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andParams:params andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    
    
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFood2WithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    
}



+(void)caseMiltipleUser1_limitNut_pd5
{
    NSDictionary *takenFoodAmountDict = nil;
    int sex = 0;//Male
    int age = 25;
    float weight=75;//kg
    float height = 172;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],@"sex", [NSNumber numberWithInt:age],@"age",
                              [NSNumber numberWithFloat:weight],@"weight", [NSNumber numberWithFloat:height],@"height",
                              [NSNumber numberWithInt:activityLevel],@"activityLevel", nil];
    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = FALSE;
    int randomRangeSelectFood = 0;
    BOOL needLimitNutrients = TRUE;
    int limitRecommendFoodCount = 0;
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             nil];
    
    uint personDayCount = 5;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithUnsignedInt:personDayCount],@"personDayCount",
                            nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andParams:params andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    
    
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFood2WithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    
}








+(void)testDA1
{
    LZDataAccess *da = [LZDataAccess singleton];
//    NSArray *nutrientNames = [LZRecommendFood getCustomNutrients];
//    [da getNutrientInfoAs2LevelDictionary_withNutrientIds:nutrientNames];
    
//    NSArray * dataAry = [da getAllFood];
//    NSLog(@"getAllFood ret:\n%@",dataAry);
    
    NSDictionary *dict1 = [da getNutrientInfo:@"Vit_D_(µg)"];
}



+(void)testFormatResult1
{
    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithDouble:200.0],@"20450",//rice
                                         [NSNumber numberWithDouble:100.0],@"16108",//huangdou
                                         [NSNumber numberWithDouble:200.0],@"11116",//youcai
                                         [NSNumber numberWithDouble:150.0],@"16022",//doujiao
                                         nil];

    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = FALSE;
    int randomRangeSelectFood = 0;
    BOOL needLimitNutrients = FALSE;
    int limitRecommendFoodCount = 0;
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
                             nil];
    
    uint personCount = 1;
    uint dayCount = 1;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithUnsignedInt:personCount],@"personCount",
                            [NSNumber numberWithUnsignedInt:dayCount],@"dayCount",
                            nil];
    
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFood2_AbstractPerson:params withDecidedFoods:takenFoodAmountDict andOptions:options];
    NSMutableDictionary *retFmtDict = [rf formatRecommendResultForUI:retDict];

}


+(void)testFormatResult2_taken
{
    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithDouble:200.0],@"20450",//rice
                                         [NSNumber numberWithDouble:100.0],@"16108",//huangdou
                                         [NSNumber numberWithDouble:200.0],@"11116",//youcai
                                         [NSNumber numberWithDouble:150.0],@"16022",//doujiao
                                         nil];
    
        
    uint personCount = 1;
    uint dayCount = 1;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithUnsignedInt:personCount],@"personCount",
                            [NSNumber numberWithUnsignedInt:dayCount],@"dayCount",
                            nil];

        
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf takenFoodSupplyNutrients_AbstractPerson:params withDecidedFoods:takenFoodAmountDict];
    NSMutableDictionary *retFmtDict = [rf formatTakenResultForUI:retDict];
    
    NSString *nutrientName1 = @"Vit_A_RAE";
    NSDictionary *DRIsDict = [retDict objectForKey:@"DRI"];//nutrient name as key, also column name
    NSDictionary *nutrientInitialSupplyDict = [retDict objectForKey:@"nutrientInitialSupplyDict"];
    NSNumber *nmNutrientInitSupplyVal = [nutrientInitialSupplyDict objectForKey:nutrientName1];
    double dNutrientNeedVal = [((NSNumber*)[DRIsDict objectForKey:nutrientName1]) doubleValue]*personCount*dayCount;
    double dNutrientLackVal = dNutrientNeedVal - [nmNutrientInitSupplyVal doubleValue];
    LZDataAccess *da = [LZDataAccess singleton];
    [da getRichNutritionFoodForNutrient:nutrientName1 andNutrientAmount:[NSNumber numberWithDouble:dNutrientLackVal]];
    
    
}

+(void)test_calculateGiveFoodsSupplyNutrientAndFormatForUI
{
    int sex = 0;//Male
    int age = 25;
    float weight=75;//kg
    float height = 172;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],ParamKey_sex, [NSNumber numberWithInt:age],ParamKey_age,
                              [NSNumber numberWithFloat:weight],ParamKey_weight, [NSNumber numberWithFloat:height],ParamKey_height,
                              [NSNumber numberWithInt:activityLevel],ParamKey_activityLevel, nil];
    
    NSDictionary *givenFoodsAmount1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithDouble:200.0],@"20450",//rice
                                         [NSNumber numberWithDouble:100.0],@"16108",//huangdou
                                         nil];

    NSDictionary *givenFoodsAmount2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithDouble:200.0],@"11116",//youcai
                                         [NSNumber numberWithDouble:150.0],@"16022",//doujiao
                                         nil];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userInfo,@"userInfo",
                            givenFoodsAmount1,@"givenFoodsAmount1",
                            givenFoodsAmount2,@"givenFoodsAmount2",
                            nil];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    [rf calculateGiveFoodsSupplyNutrientAndFormatForUI:params];
}

+(void)test_calculateGiveFoodsSupplyNutrientAndFormatForUI_empty
{
    int sex = 0;//Male
    int age = 25;
    float weight=75;//kg
    float height = 172;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],ParamKey_sex, [NSNumber numberWithInt:age],ParamKey_age,
                              [NSNumber numberWithFloat:weight],ParamKey_weight, [NSNumber numberWithFloat:height],ParamKey_height,
                              [NSNumber numberWithInt:activityLevel],ParamKey_activityLevel, nil];
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userInfo,@"userInfo",
                            nil];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    [rf calculateGiveFoodsSupplyNutrientAndFormatForUI:params];
}


+(void)test_calculateGiveFoodsSupplyNutrientAndFormatForUI_withRecommend
{
    int sex = 0;//Male
    int age = 25;
    float weight=75;//kg
    float height = 172;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],ParamKey_sex, [NSNumber numberWithInt:age],ParamKey_age,
                              [NSNumber numberWithFloat:weight],ParamKey_weight, [NSNumber numberWithFloat:height],ParamKey_height,
                              [NSNumber numberWithInt:activityLevel],ParamKey_activityLevel, nil];
    
    
    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithDouble:200.0],@"20450",//rice
                                         [NSNumber numberWithDouble:100.0],@"16108",//huangdou
                                         nil];

    BOOL needConsiderNutrientLoss = FALSE;
    //    BOOL needLimitNutrients = FALSE;
    BOOL needUseLowLimitAsUnit = TRUE;
    BOOL needUseNormalLimitWhenSmallIncrementLogic = TRUE;
    int randSeed = 0; //0; //0;
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:needConsiderNutrientLoss],LZSettingKey_needConsiderNutrientLoss,
                                    //                             [NSNumber numberWithBool:needLimitNutrients],LZSettingKey_needLimitNutrients,
                                    [NSNumber numberWithBool:needUseLowLimitAsUnit],LZSettingKey_needUseLowLimitAsUnit,
                                    [NSNumber numberWithBool:needUseNormalLimitWhenSmallIncrementLogic],LZSettingKey_needUseNormalLimitWhenSmallIncrementLogic,
                                    [NSNumber numberWithInt:randSeed],LZSettingKey_randSeed,
                                    nil];
    
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recBySI_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recBySI_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    NSLog(@"htmlFilePath=%@",htmlFilePath);
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFoodBySmallIncrementWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andOptions:options andParams:nil];
    NSDictionary *recommendFoodAmountDict = [retDict objectForKey:Key_recommendFoodAmountDict];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userInfo,@"userInfo",
                            takenFoodAmountDict,@"givenFoodsAmount1",
                            recommendFoodAmountDict,@"givenFoodsAmount2",
                            nil];
    NSDictionary * formatResult = [rf calculateGiveFoodsSupplyNutrientAndFormatForUI:params];
}

+(void)testFormatResult_foodStarndard
{
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retFmtDict = [rf formatFoodsStandardContentForUI];

}



+(void)caseUser_recSI_preTaken_0
{
    NSDictionary *takenFoodAmountDict = nil;
    int sex = 0;//Male
    int age = 25;
    float weight=75;//kg
    float height = 172;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],ParamKey_sex, [NSNumber numberWithInt:age],ParamKey_age,
                              [NSNumber numberWithFloat:weight],ParamKey_weight, [NSNumber numberWithFloat:height],ParamKey_height,
                              [NSNumber numberWithInt:activityLevel],ParamKey_activityLevel, nil];

    BOOL needConsiderNutrientLoss = FALSE;
    BOOL needLimitNutrients = FALSE; //TRUE;  //FALSE;
    BOOL needUseLowLimitAsUnit = TRUE;
    BOOL needUseNormalLimitWhenSmallIncrementLogic = TRUE;
    BOOL needUseFirstRecommendWhenSmallIncrementLogic = TRUE;//FALSE;
    BOOL needSpecialForFirstBatchFoods = FALSE; //TRUE;
    BOOL needFirstSpecialForShucaiShuiguo = TRUE;
    BOOL alreadyChoosedFoodHavePriority = TRUE;
    BOOL needPriorityFoodToSpecialNutrient = TRUE;
    int randSeed = 0; //0;
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithBool:needConsiderNutrientLoss],LZSettingKey_needConsiderNutrientLoss,
                        [NSNumber numberWithBool:needLimitNutrients],LZSettingKey_needLimitNutrients,
                        [NSNumber numberWithBool:needUseLowLimitAsUnit],LZSettingKey_needUseLowLimitAsUnit,
                        [NSNumber numberWithBool:needUseNormalLimitWhenSmallIncrementLogic],LZSettingKey_needUseNormalLimitWhenSmallIncrementLogic,
                        [NSNumber numberWithBool:needUseFirstRecommendWhenSmallIncrementLogic],LZSettingKey_needUseFirstRecommendWhenSmallIncrementLogic,
                        [NSNumber numberWithBool:needSpecialForFirstBatchFoods],LZSettingKey_needSpecialForFirstBatchFoods,
                        [NSNumber numberWithBool:needFirstSpecialForShucaiShuiguo],LZSettingKey_needFirstSpecialForShucaiShuiguo,
                        [NSNumber numberWithBool:alreadyChoosedFoodHavePriority],LZSettingKey_alreadyChoosedFoodHavePriority,
                        [NSNumber numberWithBool:needPriorityFoodToSpecialNutrient],LZSettingKey_needPriorityFoodToSpecialNutrient,
                        [NSNumber numberWithInt:randSeed],LZSettingKey_randSeed,
                        nil];

    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recBySI_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recBySI_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    NSLog(@"htmlFilePath=%@",htmlFilePath);
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFoodBySmallIncrementWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andOptions:options andParams:nil];
    NSString *strHtml = [rf generateHtml_RecommendFoodBySmallIncrement:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
}


+(void)caseUser_recSI_preTaken_0_givenNutrients
{
    NSDictionary *takenFoodAmountDict = nil;
    int sex = 0;//Male
    int age = 25;
    float weight=75;//kg
    float height = 172;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],ParamKey_sex, [NSNumber numberWithInt:age],ParamKey_age,
                              [NSNumber numberWithFloat:weight],ParamKey_weight, [NSNumber numberWithFloat:height],ParamKey_height,
                              [NSNumber numberWithInt:activityLevel],ParamKey_activityLevel, nil];
    
    BOOL needConsiderNutrientLoss = FALSE;
BOOL needLimitNutrients = FALSE;
    BOOL needUseLowLimitAsUnit = TRUE;
    BOOL needUseNormalLimitWhenSmallIncrementLogic = TRUE;
    BOOL needUseFirstRecommendWhenSmallIncrementLogic = TRUE;//FALSE;
    BOOL needSpecialForFirstBatchFoods = FALSE; //TRUE;
    BOOL needFirstSpecialForShucaiShuiguo = TRUE;
    BOOL alreadyChoosedFoodHavePriority = TRUE;
    BOOL needPriorityFoodToSpecialNutrient = TRUE;
    int randSeed = 0; //0;
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:needConsiderNutrientLoss],LZSettingKey_needConsiderNutrientLoss,
                             [NSNumber numberWithBool:needLimitNutrients],LZSettingKey_needLimitNutrients,
                                    [NSNumber numberWithBool:needUseLowLimitAsUnit],LZSettingKey_needUseLowLimitAsUnit,
                                    [NSNumber numberWithBool:needUseNormalLimitWhenSmallIncrementLogic],LZSettingKey_needUseNormalLimitWhenSmallIncrementLogic,
                                    [NSNumber numberWithBool:needUseFirstRecommendWhenSmallIncrementLogic],LZSettingKey_needUseFirstRecommendWhenSmallIncrementLogic,
                                    [NSNumber numberWithBool:needSpecialForFirstBatchFoods],LZSettingKey_needSpecialForFirstBatchFoods,
                                    [NSNumber numberWithBool:needFirstSpecialForShucaiShuiguo],LZSettingKey_needFirstSpecialForShucaiShuiguo,
                                    [NSNumber numberWithBool:alreadyChoosedFoodHavePriority],LZSettingKey_alreadyChoosedFoodHavePriority,
                                    [NSNumber numberWithBool:needPriorityFoodToSpecialNutrient],LZSettingKey_needPriorityFoodToSpecialNutrient,
                                    [NSNumber numberWithInt:randSeed],LZSettingKey_randSeed,
                                    nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recBySI_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recBySI_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    NSLog(@"htmlFilePath=%@",htmlFilePath);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                   [NSArray arrayWithObjects: @"Vit_A_RAE",@"Vit_C_(mg)",@"Vit_D_(µg)",@"Vit_E_(mg)",@"Vit_B6_(mg)",nil],Key_givenNutrients,
//                                   [NSArray arrayWithObjects: @"Vit_A_RAE",nil],Key_givenNutrients,
                                   [NSArray arrayWithObjects: @"Vit_E_(mg)",nil],Key_givenNutrients,
                                    nil];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFoodBySmallIncrementWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andOptions:options andParams:params];
    NSString *strHtml = [rf generateHtml_RecommendFoodBySmallIncrement:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
}



+(void)caseUser_recSI_preTaken_0_sameOptionsAsAppForLinearSystemCompare
{
    NSDictionary *takenFoodAmountDict = nil;
    int sex = 0;//Male
    int age = 25;
    float weight=72;//kg
    float height = 180;//cm
    int activityLevel = 0;//0--3
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:sex],ParamKey_sex, [NSNumber numberWithInt:age],ParamKey_age,
                              [NSNumber numberWithFloat:weight],ParamKey_weight, [NSNumber numberWithFloat:height],ParamKey_height,
                              [NSNumber numberWithInt:activityLevel],ParamKey_activityLevel, nil];

    BOOL needConsiderNutrientLoss = FALSE;
    //    BOOL needLimitNutrients = FALSE;
    BOOL needUseLowLimitAsUnit = TRUE;
    BOOL needUseNormalLimitWhenSmallIncrementLogic = Config_needUseNormalLimitWhenSmallIncrementLogic;
    int randSeed = 0;
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:needConsiderNutrientLoss],LZSettingKey_needConsiderNutrientLoss,
                                    //                             [NSNumber numberWithBool:needLimitNutrients],LZSettingKey_needLimitNutrients,
                                    [NSNumber numberWithBool:needUseLowLimitAsUnit],LZSettingKey_needUseLowLimitAsUnit,
                                    [NSNumber numberWithBool:needUseNormalLimitWhenSmallIncrementLogic],LZSettingKey_needUseNormalLimitWhenSmallIncrementLogic,
                                    [NSNumber numberWithInt:randSeed],LZSettingKey_randSeed,
                                    nil];
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recBySI_Linear_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recBySI_Linear_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    NSLog(@"htmlFilePath=%@",htmlFilePath);
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFoodBySmallIncrementWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andOptions:options andParams:nil];
    NSString *strHtml = [rf generateHtml_RecommendFoodBySmallIncrement:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
}







+(void)test_insertFoodCollocationData_withCollocationName
{
    LZDataAccess *da = [LZDataAccess singleton];
    NSString *collocationName = @"collocationName";
    NSMutableArray * foodAndAmountArray = [NSMutableArray array];
    [foodAndAmountArray addObject:[NSArray arrayWithObjects:@"10010", [NSNumber numberWithDouble:123],nil]];
    [foodAndAmountArray addObject:[NSArray arrayWithObjects:@"10011", [NSNumber numberWithDouble:234],nil]];    
    NSNumber *nmCollocationId = [da insertFoodCollocationData_withCollocationName:collocationName andFoodAmount2LevelArray:foodAndAmountArray];
    assert(nmCollocationId!=nil);
    [da getFoodCollocationData_withCollocationId:nmCollocationId];
    
}

+(void)test_getFoodCollocationData
{
    LZDataAccess *da = [LZDataAccess singleton];
    
    NSString *collocationName = @"collocationName";
    NSMutableArray * foodAndAmountArray = [NSMutableArray array];
    [foodAndAmountArray addObject:[NSArray arrayWithObjects:@"01010", [NSNumber numberWithDouble:111],nil]];
    [foodAndAmountArray addObject:[NSArray arrayWithObjects:@"10011", [NSNumber numberWithDouble:112],nil]];
    NSNumber *nmCollocationId = [da insertFoodCollocationData_withCollocationName:collocationName andFoodAmount2LevelArray:foodAndAmountArray];
    assert(nmCollocationId!=nil);
    
    NSString *collocationName2 = @"collocationName2";
    NSMutableArray * foodAndAmountArray2 = [NSMutableArray array];
    [foodAndAmountArray2 addObject:[NSArray arrayWithObjects:@"02010", [NSNumber numberWithDouble:211],nil]];
    [foodAndAmountArray2 addObject:[NSArray arrayWithObjects:@"20011", [NSNumber numberWithDouble:212],nil]];
    NSNumber *nmCollocationId2 = [da insertFoodCollocationData_withCollocationName:collocationName2 andFoodAmount2LevelArray:foodAndAmountArray2];
    assert(nmCollocationId2!=nil);
   
    NSArray * fdClctAry = [da getAllFoodCollocation];
    NSLog(@"getAllFoodCollocation ret:%@",fdClctAry);
    for(int i=0; i<fdClctAry.count; i++){
        NSDictionary *fdClctDict = fdClctAry[i];
        NSNumber *nmCollocationId = [fdClctDict objectForKey:COLUMN_NAME_CollocationId];
        NSDictionary * fdClctData = [da getFoodCollocationData_withCollocationId:nmCollocationId];
        NSArray *foodAndAmountArray = [fdClctData objectForKey:@"foodAndAmountArray"];
        for(int j=0; j<foodAndAmountArray.count; j++){
            NSDictionary *foodAndAmount = foodAndAmountArray[j];
            NSObject *foodId = [foodAndAmount objectForKey:COLUMN_NAME_FoodId];
            assert([foodId isKindOfClass:NSString.class]);
        }
    }
    

    
}

+(void)test_updateFoodCollocationData_withCollocationId
{
    LZDataAccess *da = [LZDataAccess singleton];
    NSString *collocationName = @"collocationName";
    NSMutableArray * foodAndAmountArray = [NSMutableArray array];
    [foodAndAmountArray addObject:[NSArray arrayWithObjects:@"10010", [NSNumber numberWithDouble:111],nil]];
    [foodAndAmountArray addObject:[NSArray arrayWithObjects:@"10011", [NSNumber numberWithDouble:112],nil]];
    NSNumber *nmCollocationId = [da insertFoodCollocationData_withCollocationName:collocationName andFoodAmount2LevelArray:foodAndAmountArray];
    assert(nmCollocationId!=nil);
    
    NSString *collocationName2 = @"collocationName2";
    NSMutableArray * foodAndAmountArray2 = [NSMutableArray array];
    [foodAndAmountArray2 addObject:[NSArray arrayWithObjects:@"20010", [NSNumber numberWithDouble:211],nil]];
    [foodAndAmountArray2 addObject:[NSArray arrayWithObjects:@"20011", [NSNumber numberWithDouble:212],nil]];
    [da updateFoodCollocationData_withCollocationId:nmCollocationId andNewCollocationName:collocationName2 andFoodAmount2LevelArray:foodAndAmountArray2];
    
    [da getFoodCollocationData_withCollocationId:nmCollocationId];
    
}

+(void)test_deleteFoodCollocationData_withCollocationId
{
    LZDataAccess *da = [LZDataAccess singleton];
    NSString *collocationName = @"collocationName";
    NSMutableArray * foodAndAmountArray = [NSMutableArray array];
    [foodAndAmountArray addObject:[NSArray arrayWithObjects:@"10010", [NSNumber numberWithDouble:111],nil]];
    [foodAndAmountArray addObject:[NSArray arrayWithObjects:@"10011", [NSNumber numberWithDouble:112],nil]];
    NSNumber *nmCollocationId = [da insertFoodCollocationData_withCollocationName:collocationName andFoodAmount2LevelArray:foodAndAmountArray];
    assert(nmCollocationId!=nil);
    
    [da deleteFoodCollocationData_withCollocationId:nmCollocationId];
    
    [da getFoodCollocationData_withCollocationId:nmCollocationId];
    
}



@end













