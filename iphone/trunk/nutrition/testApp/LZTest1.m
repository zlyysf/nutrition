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
    [LZTest1 test1];
//    [LZTest1 test2];
//    [LZTest1 test3];
//    [LZTest1 test4];
//    [LZTest1 testRecommendFoodBySmallIncrement];
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
//    [self.class test_DiseaseNutrient1];
//    [self.class test_DiseaseNutrient2];
//    [self.class test_saveUserCheckDiseaseRecord_withDay];
//    [self.class test_TranslationItem1];
//    [self.class test_getFoodsByShowingPart];
//    [self.class test_getSymptom1];
//    [self.class test_inferIllnesses_withSymptoms1];
//    [self.class test_getIllnessSuggestionsDistinct1];
    [self.class test_dalUserRecordSymptom1];

    
//    [self.class testFormatResult1];
//    [self.class testFormatResult2_taken];
//    [self.class testFormatResult_foodStarndard];
//    [self.class test_calculateGiveFoodsSupplyNutrientAndFormatForUI];
//    [self.class test_calculateGiveFoodsSupplyNutrientAndFormatForUI_withRecommend];
//    [self.class test_calculateGiveStaticFoodsDynamicFoodSupplyNutrientAndFormatForUI];
//    [self.class test_calculateGiveFoodsSupplyNutrientAndFormatForUI_empty];
//    [self.class test_formatDRIForUI];
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
//    [self.class caseMiltipleUser1_preTaken_0_givenNutrients1];
    [self.class caseMiltipleUser1_preTaken_0_givenNutrients2];
//    [self.class caseMulAbstractUser1_pretakenNearFull_pd1];
//    [self.class caseAbstractUserWithRandToReproduce1];
}

+(void)testRecommendFoodBySmallIncrement
{
//    [self.class caseUser_recSI_preTaken_0];
    [self.class caseUser_recSI_preTaken_0_givenNutrients];
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
    BOOL needUseDefinedIncrementUnit = TRUE;
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
    
    NSNumber *nmFlag_needUseDefinedIncrementUnit = [options objectForKey:@"needUseDefinedIncrementUnit"];
    if(nmFlag_needUseDefinedIncrementUnit != nil)
        needUseDefinedIncrementUnit = [nmFlag_needUseDefinedIncrementUnit boolValue];
    
    [str appendFormat:@"_M%dr%drr%dLn%dLc%dFL%dNL%dLLU%d",
        notAllowSameFood,randomSelectFood,randomRangeSelectFood,needLimitNutrients,limitRecommendFoodCount, needUseFoodLimitTableWhenCal
        ,needConsiderNutrientLoss,needUseDefinedIncrementUnit];
    
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
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
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
    NSLog(@"htmlFilePath=%@",htmlFilePath);

    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
//    NSMutableDictionary *retDict = [rf recommendFood2WithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
//    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
//    strHtml = [LZUtility getFullHtml_withPart:strHtml];
//    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
//    
//    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    
    NSMutableDictionary *retDict = [rf recommendFood4SupplyAsPossibleWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFood4SupplyAsPossible:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
        
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
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
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
    NSLog(@"htmlFilePath=%@",htmlFilePath);
    
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
//    NSMutableDictionary *retDict = [rf recommendFood2WithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
//    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
//    strHtml = [LZUtility getFullHtml_withPart:strHtml];
//    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
//    
//    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    NSMutableDictionary *retDict = [rf recommendFood4SupplyAsPossibleWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFood4SupplyAsPossible:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
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
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
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
    NSLog(@"htmlFilePath=%@",htmlFilePath);
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
//    NSMutableDictionary *retDict = [rf recommendFood2WithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
//    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
//    strHtml = [LZUtility getFullHtml_withPart:strHtml];
//    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
//    
//    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    NSMutableDictionary *retDict = [rf recommendFood4SupplyAsPossibleWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFood4SupplyAsPossible:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
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
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
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
    NSLog(@"htmlFilePath=%@",htmlFilePath);
    
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
//    NSMutableDictionary *retDict = [rf recommendFood2WithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
//    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
//    strHtml = [LZUtility getFullHtml_withPart:strHtml];
//    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
//    
//    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    NSMutableDictionary *retDict = [rf recommendFood4SupplyAsPossibleWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFood4SupplyAsPossible:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
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
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
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
    NSLog(@"htmlFilePath=%@",htmlFilePath);
    
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
//    NSMutableDictionary *retDict = [rf recommendFood2WithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
//    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
//    strHtml = [LZUtility getFullHtml_withPart:strHtml];
//    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
//    
//    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    NSMutableDictionary *retDict = [rf recommendFood4SupplyAsPossibleWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFood4SupplyAsPossible:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
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
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
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
    NSLog(@"htmlFilePath=%@",htmlFilePath);
    
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
//    NSMutableDictionary *retDict = [rf recommendFood2WithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
//    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
//    strHtml = [LZUtility getFullHtml_withPart:strHtml];
//    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
//    
//    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    NSMutableDictionary *retDict = [rf recommendFood4SupplyAsPossibleWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFood4SupplyAsPossible:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    
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
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
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
    NSLog(@"htmlFilePath=%@",htmlFilePath);
    
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
//    NSMutableDictionary *retDict = [rf recommendFood2WithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
//    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
//    strHtml = [LZUtility getFullHtml_withPart:strHtml];
//    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
//    
//    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    NSMutableDictionary *retDict = [rf recommendFood4SupplyAsPossibleWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFood4SupplyAsPossible:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
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
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
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
    NSLog(@"htmlFilePath=%@",htmlFilePath);
    
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
//    NSMutableDictionary *retDict = [rf recommendFood2WithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
//    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
//    strHtml = [LZUtility getFullHtml_withPart:strHtml];
//    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
//    
//    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    NSMutableDictionary *retDict = [rf recommendFood4SupplyAsPossibleWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFood4SupplyAsPossible:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
}


+(void)caseMiltipleUser1_preTaken_0_givenNutrients1
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
    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = true;
    int randomRangeSelectFood = 0;
    BOOL needLimitNutrients = FALSE;
    int limitRecommendFoodCount = 0;
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    BOOL needUseLessAsPossibleFood = TRUE;
    NSString *upperLimitTypeForSupplyAsPossible = COLUMN_NAME_normal_value; //COLUMN_NAME_Upper_Limit;
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:notAllowSameFood],LZSettingKey_notAllowSameFood,
                                    [NSNumber numberWithBool:randomSelectFood],LZSettingKey_randomSelectFood,
                                    [NSNumber numberWithInt:randomRangeSelectFood],LZSettingKey_randomRangeSelectFood,
                                    [NSNumber numberWithBool:needLimitNutrients],LZSettingKey_needLimitNutrients,
                                    [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                                    [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],LZSettingKey_needUseFoodLimitTableWhenCal,
                                    upperLimitTypeForSupplyAsPossible,LZSettingKey_upperLimitTypeForSupplyAsPossible,
                                    [NSNumber numberWithBool:needUseLessAsPossibleFood],LZSettingKey_needUseLessAsPossibleFood,
                                    nil];

    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recBySI_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recBySI_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    NSLog(@"htmlFilePath=%@",htmlFilePath);
    
    // @"Vit_E_(mg)" 与 COLUMN_NAME_normal_value 的组合导致结果太少，只有一组合适的. @"Vit_E_(mg)" 与 COLUMN_NAME_Upper_Limit 的组合也只有8种，凑合。
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   //                                   [NSArray arrayWithObjects: @"Vit_A_RAE",@"Vit_C_(mg)",@"Vit_D_(µg)",@"Vit_E_(mg)",@"Vit_B6_(mg)",nil],Key_givenNutrients,
                                   //                                   [NSArray arrayWithObjects: @"Vit_A_RAE",nil],Key_givenNutrients,
                                   [NSArray arrayWithObjects: @"Vit_B6_(mg)",nil],Key_givenNutrients,
                                   nil];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFood4SupplyAsPossibleWithPreIntake:nil andUserInfo:userInfo andParams:params andOptions:options ];
    NSString *strHtml = [rf generateHtml_RecommendFood4SupplyAsPossible:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
}

+(void)caseMiltipleUser1_preTaken_0_givenNutrients2
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
    BOOL notAllowSameFood = TRUE;
    BOOL randomSelectFood = true;
    int randomRangeSelectFood = 0;
    BOOL needLimitNutrients = FALSE;
    int limitRecommendFoodCount = 0;
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    BOOL needUseLessAsPossibleFood = TRUE;
    NSString *upperLimitTypeForSupplyAsPossible = COLUMN_NAME_Upper_Limit;// COLUMN_NAME_normal_value; //COLUMN_NAME_Upper_Limit;
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:notAllowSameFood],LZSettingKey_notAllowSameFood,
                                    [NSNumber numberWithBool:randomSelectFood],LZSettingKey_randomSelectFood,
                                    [NSNumber numberWithInt:randomRangeSelectFood],LZSettingKey_randomRangeSelectFood,
                                    [NSNumber numberWithBool:needLimitNutrients],LZSettingKey_needLimitNutrients,
                                    [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
                                    [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],LZSettingKey_needUseFoodLimitTableWhenCal,
                                    upperLimitTypeForSupplyAsPossible,LZSettingKey_upperLimitTypeForSupplyAsPossible,
                                    [NSNumber numberWithBool:needUseLessAsPossibleFood],LZSettingKey_needUseLessAsPossibleFood,
                                    nil];
    
    
    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
    NSString *csvFileName = [NSString stringWithFormat:@"recBySI_%@.csv",paramsDigestStr ];
    NSString *htmlFileName = [NSString stringWithFormat:@"recBySI_%@.html",paramsDigestStr ];
    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
    NSLog(@"htmlFilePath=%@",htmlFilePath);
    
    // @"Vit_E_(mg)" 与 COLUMN_NAME_normal_value 的组合导致结果太少，只有一组合适的. @"Vit_E_(mg)" 与 COLUMN_NAME_Upper_Limit 的组合也只有8种，凑合。
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   //                                   [NSArray arrayWithObjects: @"Vit_A_RAE",@"Vit_C_(mg)",@"Vit_D_(µg)",@"Vit_E_(mg)",@"Vit_B6_(mg)",nil],Key_givenNutrients,
                                   //                                   [NSArray arrayWithObjects: @"Vit_A_RAE",nil],Key_givenNutrients,
                                   [NSArray arrayWithObjects:@"Vit_E_(mg)", @"Vit_B6_(mg)",nil],Key_givenNutrients,
                                   nil];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retDict = [rf recommendFood4SupplyAsPossibleWithPreIntake:nil andUserInfo:userInfo andParams:params andOptions:options ];
    NSString *strHtml = [rf generateHtml_RecommendFood4SupplyAsPossible:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
}


//
//+(void)caseMulAbstractUser1_pretakenNearFull_pd1
//{
//    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                         [NSNumber numberWithDouble:500.0],@"15020",//huanghuayu
//                                         [NSNumber numberWithDouble:500.0],@"20450",//rice
//                                         [NSNumber numberWithDouble:500.0],@"01152",//milk
//                                         [NSNumber numberWithDouble:500.0],@"16014",//heidou
//                                         [NSNumber numberWithDouble:500.0],@"11167",//yumi
//                                         [NSNumber numberWithDouble:300.0],@"15050",//qingyu
//                                         [NSNumber numberWithDouble:300.0],@"12036",//guazi
//                                         [NSNumber numberWithDouble:400.0],@"13047",//beef
//                                         [NSNumber numberWithDouble:400.0],@"09326",//xigua
//                                         nil];
//
//    BOOL notAllowSameFood = TRUE;
//    BOOL randomSelectFood = TRUE;
//    int randomRangeSelectFood = 4;
//    BOOL needLimitNutrients = TRUE;
//    int limitRecommendFoodCount = 4;
//    BOOL needUseFoodLimitTableWhenCal = TRUE;
////    uint randSeed = 1519860424;
//    uint randSeed = 0;
//    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
//                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
//                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
//                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
//                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
//                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
//                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
//                             [NSNumber numberWithUnsignedInt:randSeed],@"randSeed",
//                             nil];
//    
//    uint personCount = 1;
//    uint dayCount = 1;
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                            [NSNumber numberWithUnsignedInt:personCount],@"personCount",
//                            [NSNumber numberWithUnsignedInt:dayCount],@"dayCount",
//                            nil];
//
//    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:nil andParams:params andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
//    NSString *csvFileName = [NSString stringWithFormat:@"recommend_%@.csv",paramsDigestStr ];
//    NSString *htmlFileName = [NSString stringWithFormat:@"recommend_%@.html",paramsDigestStr ];
//    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
//    NSLog(@"htmlFilePath=%@",htmlFilePath);
//    
//    
//    
//    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
//    NSMutableDictionary *retDict = [rf recommendFood2_AbstractPerson:params withDecidedFoods:takenFoodAmountDict andOptions:options];
////    NSMutableDictionary *retDict = [rf recommendFood2WithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
//    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
//    strHtml = [LZUtility getFullHtml_withPart:strHtml];
//    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
//    
//    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
//    
//    NSMutableDictionary *uiDictionary = [rf formatRecommendResultForUI:retDict];
//    NSLog(@"uiDictionary %@",[uiDictionary allKeys]);
//
//    
//}





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
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
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
    NSLog(@"htmlFilePath=%@",htmlFilePath);
    
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
//    NSMutableDictionary *retDict = [rf recommendFood2WithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
//    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
//    strHtml = [LZUtility getFullHtml_withPart:strHtml];
//    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
//    
//    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    NSMutableDictionary *retDict = [rf recommendFood4SupplyAsPossibleWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFood4SupplyAsPossible:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
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
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
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
    NSLog(@"htmlFilePath=%@",htmlFilePath);
    
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
//    NSMutableDictionary *retDict = [rf recommendFood2WithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
//    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
//    strHtml = [LZUtility getFullHtml_withPart:strHtml];
//    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
//    
//    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    NSMutableDictionary *retDict = [rf recommendFood4SupplyAsPossibleWithPreIntake:takenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
    NSString *strHtml = [rf generateHtml_RecommendFood4SupplyAsPossible:retDict];
    strHtml = [LZUtility getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
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



//+(void)testFormatResult1
//{
//    NSDictionary *takenFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                         [NSNumber numberWithDouble:200.0],@"20450",//rice
//                                         [NSNumber numberWithDouble:100.0],@"16108",//huangdou
//                                         [NSNumber numberWithDouble:200.0],@"11116",//youcai
//                                         [NSNumber numberWithDouble:150.0],@"16022",//doujiao
//                                         nil];
//
//    BOOL notAllowSameFood = TRUE;
//    BOOL randomSelectFood = FALSE;
//    int randomRangeSelectFood = 0;
//    BOOL needLimitNutrients = FALSE;
//    int limitRecommendFoodCount = 0;
//    BOOL needUseFoodLimitTableWhenCal = TRUE;
//    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
//                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
//                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
//                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
//                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
//                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
//                             [NSNumber numberWithBool:needUseFoodLimitTableWhenCal],@"needUseFoodLimitTableWhenCal",
//                             nil];
//    
//    uint personCount = 1;
//    uint dayCount = 1;
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                            [NSNumber numberWithUnsignedInt:personCount],@"personCount",
//                            [NSNumber numberWithUnsignedInt:dayCount],@"dayCount",
//                            nil];
//    
//    
//    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
//    NSMutableDictionary *retDict = [rf recommendFood2_AbstractPerson:params withDecidedFoods:takenFoodAmountDict andOptions:options];
//    NSMutableDictionary *retFmtDict = [rf formatRecommendResultForUI:retDict];
//
//}


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
    [da getRichNutritionFoodForNutrient:nutrientName1 andNutrientAmount:[NSNumber numberWithDouble:dNutrientLackVal] andIfNeedCustomDefinedFoods:false];
    
    
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
    BOOL needUseDefinedIncrementUnit = TRUE;
    BOOL needUseNormalLimitWhenSmallIncrementLogic = TRUE;
    int randSeed = 0; //0; //0;
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:needConsiderNutrientLoss],LZSettingKey_needConsiderNutrientLoss,
                                    //                             [NSNumber numberWithBool:needLimitNutrients],LZSettingKey_needLimitNutrients,
                                    [NSNumber numberWithBool:needUseDefinedIncrementUnit],LZSettingKey_needUseDefinedIncrementUnit,
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

+(void)test_calculateGiveStaticFoodsDynamicFoodSupplyNutrientAndFormatForUI
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
    
    
    NSDictionary *staticFoodAmountDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithDouble:200.0],@"20450",//rice
                                         [NSNumber numberWithDouble:100.0],@"16108",//huangdou
                                         nil];
    //[NSNumber numberWithDouble:200.0],@"09003",//apple
    NSString *dynamicFoodId = @"09003";
    NSNumber *nm_dynamicFoodAmount = [NSNumber numberWithDouble:200.0];
    
    NSMutableArray *allFoodIds = [NSMutableArray arrayWithArray:[staticFoodAmountDict allKeys]];
    [allFoodIds addObject:dynamicFoodId];
    
    LZDataAccess *da = [LZDataAccess singleton];
    NSArray *allFoodAttrAry = [da getFoodAttributesByIds:allFoodIds];
    NSMutableDictionary *allFoodAttr2LevelDict = [LZUtility dictionaryArrayTo2LevelDictionary_withKeyName:COLUMN_NAME_NDB_No andDicArray:allFoodAttrAry];
    NSDictionary *dynamicFoodAttrs = [allFoodAttr2LevelDict objectForKey:dynamicFoodId];

    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            userInfo,Key_userInfo,
                            dynamicFoodAttrs,@"dynamicFoodAttrs",
                            nm_dynamicFoodAmount,@"dynamicFoodAmount",
                            allFoodAttr2LevelDict,@"staticFoodAttrsDict2Level",
                            staticFoodAmountDict,@"staticFoodAmountDict",
//                            staticFoodAmountDict,@"staticFoodAmountDict",

//                            nil,@"staticFoodSupplyNutrientDict",
//                            nil,@"allShowNutrients",
//                            nil,@"nutrientInfoDict2Level",
                            nil];
    [rf calculateGiveStaticFoodsDynamicFoodSupplyNutrientAndFormatForUI:params];
}



+(void)testFormatResult_foodStarndard
{
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *retFmtDict = [rf formatFoodsStandardContentForUI];

}

+(void)test_formatDRIForUI
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
    LZDataAccess *da = [LZDataAccess singleton];
    NSDictionary *DRIsDict = [da getStandardDRIs_withUserInfo:userInfo andOptions:nil];
    
    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   DRIsDict,Key_DRI,
                                   nil];
    [rf formatDRIForUI:params];
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
    BOOL needLimitNutrients = TRUE; //TRUE;  //FALSE;
    BOOL needUseDefinedIncrementUnit = TRUE;
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
                        [NSNumber numberWithBool:needUseDefinedIncrementUnit],LZSettingKey_needUseDefinedIncrementUnit,
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
    BOOL needUseDefinedIncrementUnit = TRUE;
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
                                    [NSNumber numberWithBool:needUseDefinedIncrementUnit],LZSettingKey_needUseDefinedIncrementUnit,
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
    BOOL needUseDefinedIncrementUnit = TRUE;
    BOOL needUseNormalLimitWhenSmallIncrementLogic = Config_needUseNormalLimitWhenSmallIncrementLogic;
    int randSeed = 0;
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:needConsiderNutrientLoss],LZSettingKey_needConsiderNutrientLoss,
                                    //                             [NSNumber numberWithBool:needLimitNutrients],LZSettingKey_needLimitNutrients,
                                    [NSNumber numberWithBool:needUseDefinedIncrementUnit],LZSettingKey_needUseDefinedIncrementUnit,
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


//+(void)test_DiseaseNutrient1
//{
//    LZDataAccess *da = [LZDataAccess singleton];
//    NSArray *diseaseGroupInfoArray = [da getDiseaseGroupInfo_byType:DiseaseGroupType_wizard];
//    NSArray *groupAry = [LZUtility getPropertyArrayFromDictionaryArray_withPropertyName:COLUMN_NAME_DiseaseGroup andDictionaryArray:diseaseGroupInfoArray];
//    NSArray *diseaseNames = [da getDiseaseNamesOfGroup:groupAry[0] andDepartment:nil andDiseaseType:nil andTimeType:nil];
////    NSDictionary * nutrientsByDiseaseDict = [da getDiseaseNutrients_ByDiseaseNames:diseaseNames];
////    
////    NSMutableSet * nutrientSet = [NSMutableSet setWithCapacity:100];
////    for ( NSString* key in nutrientsByDiseaseDict) {
////        NSArray *nutrients = nutrientsByDiseaseDict[key];
////        [nutrientSet addObjectsFromArray:nutrients];
////    }
////    NSArray *customNutrients = [LZRecommendFood getCustomNutrients:nil];
////    NSArray *orderedNutrientsInSet = [LZUtility arrayIntersectSet_withArray:[NSMutableArray arrayWithArray:customNutrients] andSet:nutrientSet];
////    NSLog(@"orderedNutrientsInSet=%@",[orderedNutrientsInSet debugDescription]);
//    
////    NSDictionary * nutrientInfo2LevelDict = [da getNutrientInfoAs2LevelDictionary_withNutrientIds:customNutrients];
////    NSLog(@"one nutrientInfo=%@",nutrientInfo2LevelDict[orderedNutrientsInSet[0]]);
//    
////    diseaseNames = [da getDiseaseNamesOfGroup:groupAry[1]];
//    
//}

//+(void)test_DiseaseNutrient2
//{
//    LZDataAccess *da = [LZDataAccess singleton];
//    NSArray *diseaseGroupInfoArray;
//    NSArray *groupAry;
//    NSString *illnessGroup;
//    
//    //预防与调理
////    diseaseGroupInfoArray= [da getDiseaseGroupInfo_byType:DiseaseGroupType_illness];
////    groupAry = [LZUtility getPropertyArrayFromDictionaryArray_withPropertyName:COLUMN_NAME_DiseaseGroup andDictionaryArray:diseaseGroupInfoArray];
////    illnessGroup = groupAry[0];
////    [da getDiseasesOrganizedByColumn:COLUMN_NAME_DiseaseDepartment andFilters_Group:illnessGroup andDepartment:nil andDiseaseType:nil andTimeType:nil];
//    
//    //不适症状
////    diseaseGroupInfoArray = [da getDiseaseGroupInfo_byType:DiseaseGroupType_discomfort];
////    groupAry = [LZUtility getPropertyArrayFromDictionaryArray_withPropertyName:COLUMN_NAME_DiseaseGroup andDictionaryArray:diseaseGroupInfoArray];
////    illnessGroup = groupAry[0];
////    [da getDiseasesOrganizedByColumn:COLUMN_NAME_DiseaseType andFilters_Group:illnessGroup andDepartment:nil andDiseaseType:nil andTimeType:nil];
//    
//    //分时间段诊断
//    diseaseGroupInfoArray= [da getDiseaseGroupInfo_byType:DiseaseGroupType_DailyDiseaseDiagnose];
//    groupAry = [LZUtility getPropertyArrayFromDictionaryArray_withPropertyName:COLUMN_NAME_DiseaseGroup andDictionaryArray:diseaseGroupInfoArray];
//    illnessGroup = groupAry[0];
////    [da getDiseasesOrganizedByColumn:COLUMN_NAME_DiseaseType andFilters_Group:illnessGroup andDepartment:nil andDiseaseType:nil andTimeType:@"下午"];
//    [da getDiseaseNamesOfGroup:illnessGroup andDepartment:nil andDiseaseType:nil andTimeType:@"下午"];
//
//    NSArray *diseaseNames = [NSArray arrayWithObjects:@"鼻塞，感冒",@"脑门热，发烧", nil];
//    NSDictionary * nutrientInfosByDiseaseDict = [da getDiseaseNutrientRows_ByDiseaseNames:diseaseNames andDiseaseGroup:illnessGroup];
//
//}


+(void)test_DiseaseNutrient2
{
    LZDataAccess *da = [LZDataAccess singleton];
    NSArray *diseaseGroupInfoArray;
    NSArray *groupAry;
    NSString *illnessGroup;
    
    //预防与调理
//    diseaseGroupInfoArray= [da getDiseaseGroupInfo_byType:DiseaseGroupType_illness];
//    groupAry = [LZUtility getPropertyArrayFromDictionaryArray_withPropertyName:COLUMN_NAME_DiseaseGroup andDictionaryArray:diseaseGroupInfoArray];
//    illnessGroup = groupAry[0];
//    [da getDiseaseInfosOrganizedByColumn:COLUMN_NAME_DiseaseDepartment andFilters_Group:illnessGroup andDepartment:nil andDiseaseType:nil andTimeType:nil];
    
    //不适症状
//    diseaseGroupInfoArray = [da getDiseaseGroupInfo_byType:DiseaseGroupType_discomfort];
//    groupAry = [LZUtility getPropertyArrayFromDictionaryArray_withPropertyName:COLUMN_NAME_DiseaseGroup andDictionaryArray:diseaseGroupInfoArray];
//    illnessGroup = groupAry[0];
//    [da getDiseaseInfosOrganizedByColumn:COLUMN_NAME_DiseaseType andFilters_Group:illnessGroup andDepartment:nil andDiseaseType:nil andTimeType:nil];
    
    //分时间段诊断
    diseaseGroupInfoArray= [da getDiseaseGroupInfo_byType:DiseaseGroupType_DailyDiseaseDiagnose];
    groupAry = [LZUtility getPropertyArrayFromDictionaryArray_withPropertyName:COLUMN_NAME_DiseaseGroup andDictionaryArray:diseaseGroupInfoArray];
    illnessGroup = groupAry[0];
//    [da getDiseaseInfosOrganizedByColumn:COLUMN_NAME_DiseaseType andFilters_Group:illnessGroup andDepartment:nil andDiseaseType:nil andTimeType:@"下午"];
    [da getDiseaseIdsOfGroup:illnessGroup andDepartment:nil andDiseaseType:nil andTimeType:@"下午"];
    
    NSArray *diseaseIds = [NSArray arrayWithObjects:@"鼻塞，感冒",@"脑门热，发烧", nil];
    NSDictionary * nutrientInfosByDiseaseDict = [da getDiseaseNutrientRows_ByDiseaseIds:diseaseIds andDiseaseGroup:illnessGroup];
    
    NSArray *diseaseInfoAry = [da getDiseaseInfosOfGroup:illnessGroup andDepartment:nil andDiseaseType:nil andTimeType:nil];
    NSDictionary *diseaseInfo2LevelDict = [LZUtility dictionaryArrayTo2LevelDictionary_withKeyName:COLUMN_NAME_Disease andDicArray:diseaseInfoAry];
    NSString *diseaseId = diseaseIds[0];
    NSDictionary *diseaseInfo = [diseaseInfo2LevelDict objectForKey:diseaseId];
    NSString *diseaseCnName = [diseaseInfo objectForKey:COLUMN_NAME_Disease];
    NSString *diseaseEnName = [diseaseInfo objectForKey:COLUMN_NAME_DiseaseEn];
    NSLog(@"diseaseCnName=%@, diseaseEnName=%@, diseaseInfo=%@",diseaseCnName,diseaseEnName, [LZUtility getObjectDescription:diseaseInfo andIndent:0]);
    
}

+(void)test_saveUserCheckDiseaseRecord_withDay
{
    LZDataAccess *da = [LZDataAccess singleton];
    int day = 20120304;
    int timeType = 1;
    NSDate * updateTime = [NSDate date];
    NSArray *diseaseNames = [NSArray arrayWithObjects:@"鼻塞，感冒",@"脑门热，发烧", nil];
    NSArray *LackNutrientIDs = [NSArray arrayWithObjects:NutrientId_VC,NutrientId_Magnesium, nil];
    int healthMark = 78;
    [da saveUserCheckDiseaseRecord_withDay:day andTimeType:timeType UpdateTime:updateTime andDiseases:diseaseNames andLackNutrientIDs:LackNutrientIDs andHealthMark:healthMark];
    healthMark = 79;
    [da saveUserCheckDiseaseRecord_withDay:day andTimeType:timeType UpdateTime:updateTime andDiseases:diseaseNames andLackNutrientIDs:LackNutrientIDs andHealthMark:healthMark];
    
    timeType = 2;
    healthMark = 81;
    [da saveUserCheckDiseaseRecord_withDay:day andTimeType:timeType UpdateTime:updateTime andDiseases:diseaseNames andLackNutrientIDs:LackNutrientIDs andHealthMark:healthMark];
    
    day = 20120305;
    timeType = 3;
    healthMark = 81;
    [da saveUserCheckDiseaseRecord_withDay:day andTimeType:timeType UpdateTime:updateTime andDiseases:diseaseNames andLackNutrientIDs:LackNutrientIDs andHealthMark:healthMark];
    
    day = 20120304;
    [da getUserCheckDiseaseRecord_withDay:day andTimeType:0];
    day = 20120305;
    [da getUserCheckDiseaseRecord_withDay:day andTimeType:0];
    
}


+(void)test_TranslationItem1
{
    LZDataAccess *da = [LZDataAccess singleton];
    NSDictionary *translationItemInfo2LevelDict = [da getTranslationItemsDictionaryByType:TranslationItemType_FoodCnType];
    
    translationItemInfo2LevelDict = [da getTranslationItemsDictionaryByType:TranslationItemType_SingleItemUnitName];
    
    
}

+(void)test_getFoodsByShowingPart
{
    LZDataAccess *da = [LZDataAccess singleton];
    [da getFoodCnTypes];
    
    NSArray *foods = [da getFoodsByShowingPart:@"果" andEnNamePart:nil andCnType:nil];
    
    foods = [da getFoodsByShowingPart:nil andEnNamePart:@"beef" andCnType:nil];
    
    foods = [da getFoodsByShowingPart:nil andEnNamePart:nil andCnType:@"奶制品"];
    
}



+(void)test_getSymptom1
{
    LZDataAccess *da = [LZDataAccess singleton];
    NSArray *symptomTypeRows = [da getSymptomTypeRows_withForSex:ForSex_female];
    NSArray *symptomTypeIds = [LZUtility getPropertyArrayFromDictionaryArray_withPropertyName:COLUMN_NAME_SymptomTypeId andDictionaryArray:symptomTypeRows];
    NSLog(@"symptomTypeIds=%@",[LZUtility getObjectDescription:symptomTypeIds andIndent:0] );
    
    [da getSymptomRowsByTypeDict_BySymptomTypeIds:symptomTypeIds];
    
    NSArray *symptomIds = [NSArray arrayWithObjects:@"头晕", @"头发脱落", @"易疲劳", @"易流泪", nil];
    [da getSymptomNutrientDistinctIds_BySymptomIds:symptomIds];
    
}

+(void)test_inferIllnesses_withSymptoms1
{
    NSMutableArray *symptomIds = [NSMutableArray arrayWithObjects:
                                  @"咽喉发痒",@"咽喉灼热",@"咳嗽",
                                  @"咳痰",@"喘息",
                                  @"食欲不振",@"恶心",@"呕吐",@"上腹痛", nil];
    NSMutableDictionary *measureData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:101],Key_HeartRate,
                                   [NSNumber numberWithInt:150],Key_BloodPressureHigh,[NSNumber numberWithInt:130],Key_BloodPressureLow,
                                   [NSNumber numberWithDouble:38.4],Key_BodyTemperature,
                                   nil];
    NSArray *illnessAry = [LZUtility inferIllnesses_withSymptoms:symptomIds andMeasureData:measureData];
    NSLog(@"illnessAry=%@",[LZUtility getObjectDescription:illnessAry andIndent:0] );
}

+(void)test_getIllnessSuggestionsDistinct1
{
    NSArray* illnessIds = [NSArray arrayWithObjects:@"感冒", @"急性病毒性咽炎", @"轻度高血压", @"骨关节炎", nil];
    LZDataAccess *da = [LZDataAccess singleton];
    [da getIllnessSuggestionsDistinct_ByIllnessIds:illnessIds];
    
}

+(void)test_dalUserRecordSymptom1
{
    LZDataAccess *da = [LZDataAccess singleton];
    int dayLocal = 20120304;
    NSDate *updateTime = [NSDate date];
    NSMutableDictionary * InputNameValuePairsData = [NSMutableDictionary dictionary];
    NSString *note = @"note1";
    NSMutableDictionary * CalculateNameValuePairsData = [NSMutableDictionary dictionary];
    
    [InputNameValuePairsData setObject:[NSArray arrayWithObjects:@"s11",@"s12", nil] forKey:Key_Symptoms];
    [InputNameValuePairsData setObject:[NSNumber numberWithDouble:36.7] forKey:Key_Temperature];
    [InputNameValuePairsData setObject:[NSNumber numberWithDouble:67.8] forKey:Key_Weight];
    [InputNameValuePairsData setObject:[NSNumber numberWithInt:61] forKey:Key_HeartRate];
    [InputNameValuePairsData setObject:[NSNumber numberWithInt:80] forKey:Key_BloodPressureLow];
    [InputNameValuePairsData setObject:[NSNumber numberWithInt:140] forKey:Key_BloodPressureHigh];
    
    [CalculateNameValuePairsData setObject:[NSNumber numberWithDouble:23.4] forKey:Key_BMI];
    [CalculateNameValuePairsData setObject:[NSNumber numberWithDouble:87.5] forKey:Key_HealthMark];
    [CalculateNameValuePairsData setObject:[NSArray arrayWithObjects:@"B1",@"VC", nil] forKey:@"LackNutrientIDs"];
    [CalculateNameValuePairsData setObject:[NSArray arrayWithObjects:@"ill11",@"ill12", nil] forKey:Key_InferIllnesses];
    [CalculateNameValuePairsData setObject:[NSArray arrayWithObjects:@"a11",@"a12", nil] forKey:Key_Suggestions];
    [CalculateNameValuePairsData setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:100],@"10001", [NSNumber numberWithInt:150],@"10002", nil] forKey:@"RecommendFoodAndAmounts"];
    
    [da deleteUserRecordSymptomByByDayLocal:dayLocal];
    
    [da insertUserRecordSymptom_withDayLocal:dayLocal andUpdateTimeUTC:updateTime andInputNameValuePairsData:InputNameValuePairsData andNote:note andCalculateNameValuePairsData:CalculateNameValuePairsData];
    [da getUserRecordSymptomDataByDayLocal:dayLocal];
    
    
    updateTime = [NSDate date];
    note = @"note1b";
    InputNameValuePairsData = [NSMutableDictionary dictionary];
    [InputNameValuePairsData setObject:[NSArray arrayWithObjects:@"s11b",@"s12b", nil] forKey:Key_Symptoms];
    [InputNameValuePairsData setObject:[NSNumber numberWithDouble:36.72] forKey:Key_Temperature];
    [InputNameValuePairsData setObject:[NSNumber numberWithDouble:67.82] forKey:Key_Weight];
    [InputNameValuePairsData setObject:[NSNumber numberWithInt:612] forKey:Key_HeartRate];
    [InputNameValuePairsData setObject:[NSNumber numberWithInt:802] forKey:Key_BloodPressureLow];
    [InputNameValuePairsData setObject:[NSNumber numberWithInt:1402] forKey:Key_BloodPressureHigh];
    CalculateNameValuePairsData = [NSMutableDictionary dictionary];
    [CalculateNameValuePairsData setObject:[NSNumber numberWithDouble:23.42] forKey:Key_BMI];
    [CalculateNameValuePairsData setObject:[NSNumber numberWithDouble:87.52] forKey:Key_HealthMark];
    [CalculateNameValuePairsData setObject:[NSArray arrayWithObjects:@"B2",@"VD", nil] forKey:@"LackNutrientIDs"];
    [CalculateNameValuePairsData setObject:[NSArray arrayWithObjects:@"ill11b",@"ill12b", nil] forKey:Key_InferIllnesses];
    [CalculateNameValuePairsData setObject:[NSArray arrayWithObjects:@"a11b",@"a12b", nil] forKey:Key_Suggestions];
    [CalculateNameValuePairsData setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1002],@"10001", [NSNumber numberWithInt:1502],@"10002", nil] forKey:@"RecommendFoodAndAmounts"];
    [da updateUserRecordSymptom_withDayLocal:dayLocal andUpdateTimeUTC:updateTime andInputNameValuePairsData:InputNameValuePairsData andNote:note andCalculateNameValuePairsData:CalculateNameValuePairsData];
    [da getUserRecordSymptomDataByDayLocal:dayLocal];
    
    
    
    dayLocal = 20120404;
    updateTime = [NSDate date];
    note = @"note1b";
    InputNameValuePairsData = [NSMutableDictionary dictionary];
    [InputNameValuePairsData setObject:[NSArray arrayWithObjects:@"s21",@"s22", nil] forKey:Key_Symptoms];
    [InputNameValuePairsData setObject:[NSNumber numberWithDouble:236.7] forKey:Key_Temperature];
    [InputNameValuePairsData setObject:[NSNumber numberWithDouble:267.8] forKey:Key_Weight];
    [InputNameValuePairsData setObject:[NSNumber numberWithInt:261] forKey:Key_HeartRate];
    [InputNameValuePairsData setObject:[NSNumber numberWithInt:280] forKey:Key_BloodPressureLow];
    [InputNameValuePairsData setObject:[NSNumber numberWithInt:2140] forKey:Key_BloodPressureHigh];
    CalculateNameValuePairsData = [NSMutableDictionary dictionary];
    [CalculateNameValuePairsData setObject:[NSNumber numberWithDouble:223.4] forKey:Key_BMI];
    [CalculateNameValuePairsData setObject:[NSNumber numberWithDouble:287.5] forKey:Key_HealthMark];
    [CalculateNameValuePairsData setObject:[NSArray arrayWithObjects:@"B3",@"VE", nil] forKey:@"LackNutrientIDs"];
    [CalculateNameValuePairsData setObject:[NSArray arrayWithObjects:@"ill21",@"ill22", nil] forKey:Key_InferIllnesses];
    [CalculateNameValuePairsData setObject:[NSArray arrayWithObjects:@"a21",@"a22", nil] forKey:Key_Suggestions];
    [CalculateNameValuePairsData setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2100],@"10001", [NSNumber numberWithInt:2150],@"10002", nil] forKey:@"RecommendFoodAndAmounts"];
    
    [da deleteUserRecordSymptomByByDayLocal:dayLocal];
    
    [da insertUserRecordSymptom_withDayLocal:dayLocal andUpdateTimeUTC:updateTime andInputNameValuePairsData:InputNameValuePairsData andNote:note andCalculateNameValuePairsData:CalculateNameValuePairsData];
    [da getUserRecordSymptomDataByRange_withStartDayLocal:0 andEndDayLocal:0 andStartMonthLocal:0 andEndMonthLocal:0];
    
    [da getUserRecordSymptom_DistinctMonth];

}

@end













