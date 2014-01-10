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
    [self.class test_getSymptom1];
//    [self.class test_inferIllnesses_withSymptoms1];
//    [self.class test_getIllnessSuggestionsDistinct1];
//    [self.class test_dalUserRecordSymptom1];
//    [self.class test_getSingleNutrientRichFoodWithAmount_forNutrients];
//    [self.class test_getIllness2];
//    [self.class test_syncRemoteDataInParse];
//    [self.class test_syncRemoteDataInParse_2];

    
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
    NSArray *nutrientIdsWithOrder = [da getSymptomNutrientIdsWithOrder_BySymptomIds:symptomIds];
    NSArray *limitNutrientIds = [LZUtility getSubArray:nutrientIdsWithOrder andFrom:0 andLength:Config_getLackNutrientLimit];
    NSLog(@"nutrientIdsWithOrder=%@, \nlimitNutrientIds=%@", [LZUtility getObjectDescription:nutrientIdsWithOrder andIndent:0], [LZUtility getObjectDescription:limitNutrientIds andIndent:0]);
    
//    [da getSymptomHealthMarkSum_BySymptomIds:symptomIds];
//
//    [da getSymptomRows_BySymptomIds:symptomIds];
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
    
    [da getIllnessSuggestions_ByIllnessId:@"感冒"];
    
    [da getIllness_ByIllnessIds:illnessIds];
    
}

+(void)test_dalUserRecordSymptom1
{
    LZDataAccess *da = [LZDataAccess singleton];
    int dayLocal = 20120304;
    NSDate *updateTime = [NSDate date];
    NSMutableDictionary * InputNameValuePairsData = [NSMutableDictionary dictionary];
    NSString *note = @"note1";
    NSMutableDictionary * CalculateNameValuePairsData = [NSMutableDictionary dictionary];
    NSMutableDictionary * LackNutrientsAndFoods,*InferIllnessesAndSuggestions;
    
    [InputNameValuePairsData setObject:[NSArray arrayWithObjects:@"s11",@"s12", nil] forKey:Key_Symptoms];
    [InputNameValuePairsData setObject:[NSNumber numberWithDouble:36.7] forKey:Key_BodyTemperature];
    [InputNameValuePairsData setObject:[NSNumber numberWithDouble:67.8] forKey:Key_Weight];
    [InputNameValuePairsData setObject:[NSNumber numberWithInt:61] forKey:Key_HeartRate];
    [InputNameValuePairsData setObject:[NSNumber numberWithInt:80] forKey:Key_BloodPressureLow];
    [InputNameValuePairsData setObject:[NSNumber numberWithInt:140] forKey:Key_BloodPressureHigh];
    
    [CalculateNameValuePairsData setObject:[NSNumber numberWithDouble:23.4] forKey:Key_BMI];
    [CalculateNameValuePairsData setObject:[NSNumber numberWithDouble:87.5] forKey:Key_HealthMark];
//    [CalculateNameValuePairsData setObject:[NSArray arrayWithObjects:@"B1",@"VC", nil] forKey:@"LackNutrientIDs"];
//    [CalculateNameValuePairsData setObject:[NSArray arrayWithObjects:@"ill11",@"ill12", nil] forKey:@"InferIllnesses"];
//    [CalculateNameValuePairsData setObject:[NSArray arrayWithObjects:@"a11",@"a12", nil] forKey:@"Suggestions"];
//    [CalculateNameValuePairsData setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:100],@"10001", [NSNumber numberWithInt:150],@"10002", nil] forKey:@"RecommendFoodAndAmounts"];
    LackNutrientsAndFoods = [NSMutableDictionary dictionary];
    [LackNutrientsAndFoods setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:100],@"10001", [NSNumber numberWithInt:150],@"10002", nil] forKey:@"Vb1"];
    [LackNutrientsAndFoods setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:100],@"10011", [NSNumber numberWithInt:150],@"10012", nil] forKey:@"Vb2"];
    [CalculateNameValuePairsData setObject:LackNutrientsAndFoods forKey:Key_LackNutrientsAndFoods];
    InferIllnessesAndSuggestions = [NSMutableDictionary dictionary];
    [InferIllnessesAndSuggestions setObject:[NSArray arrayWithObjects:@"Suggestion11",@"Suggestion12", nil] forKey:@"illness1"];
    [InferIllnessesAndSuggestions setObject:[NSArray arrayWithObjects:@"Suggestion21",@"Suggestion22", nil] forKey:@"illness2"];
    [CalculateNameValuePairsData setObject:InferIllnessesAndSuggestions forKey:Key_InferIllnessesAndSuggestions];
    
    
    [da deleteUserRecordSymptomByByDayLocal:dayLocal];
    
    [da insertUserRecordSymptom_withDayLocal:dayLocal andUpdateTimeUTC:updateTime andInputNameValuePairsData:InputNameValuePairsData andNote:note andCalculateNameValuePairsData:CalculateNameValuePairsData];
    [da getUserRecordSymptomDataByDayLocal:dayLocal];
    
    
    updateTime = [NSDate date];
    note = @"note1b";
    InputNameValuePairsData = [NSMutableDictionary dictionary];
    [InputNameValuePairsData setObject:[NSArray arrayWithObjects:@"s11b",@"s12b", nil] forKey:Key_Symptoms];
    [InputNameValuePairsData setObject:[NSNumber numberWithDouble:36.72] forKey:Key_BodyTemperature];
    [InputNameValuePairsData setObject:[NSNumber numberWithDouble:67.82] forKey:Key_Weight];
    [InputNameValuePairsData setObject:[NSNumber numberWithInt:612] forKey:Key_HeartRate];
    [InputNameValuePairsData setObject:[NSNumber numberWithInt:802] forKey:Key_BloodPressureLow];
    [InputNameValuePairsData setObject:[NSNumber numberWithInt:1402] forKey:Key_BloodPressureHigh];
    CalculateNameValuePairsData = [NSMutableDictionary dictionary];
    [CalculateNameValuePairsData setObject:[NSNumber numberWithDouble:23.42] forKey:Key_BMI];
    [CalculateNameValuePairsData setObject:[NSNumber numberWithDouble:87.52] forKey:Key_HealthMark];
    [CalculateNameValuePairsData setObject:[NSArray arrayWithObjects:@"B2",@"VD", nil] forKey:@"LackNutrientIDs"];
    [CalculateNameValuePairsData setObject:[NSArray arrayWithObjects:@"ill11b",@"ill12b", nil] forKey:@"InferIllnesses"];
    [CalculateNameValuePairsData setObject:[NSArray arrayWithObjects:@"a11b",@"a12b", nil] forKey:@"Suggestions"];
    [CalculateNameValuePairsData setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1002],@"10001", [NSNumber numberWithInt:1502],@"10002", nil] forKey:@"RecommendFoodAndAmounts"];
    [da updateUserRecordSymptom_withDayLocal:dayLocal andUpdateTimeUTC:updateTime andInputNameValuePairsData:InputNameValuePairsData andNote:note andCalculateNameValuePairsData:CalculateNameValuePairsData];
    [da getUserRecordSymptomDataByDayLocal:dayLocal];
    
    
    
    dayLocal = 20120404;
    updateTime = [NSDate date];
    note = @"note1b";
    InputNameValuePairsData = [NSMutableDictionary dictionary];
    [InputNameValuePairsData setObject:[NSArray arrayWithObjects:@"s21",@"s22", nil] forKey:Key_Symptoms];
    [InputNameValuePairsData setObject:[NSNumber numberWithDouble:236.7] forKey:Key_BodyTemperature];
    [InputNameValuePairsData setObject:[NSNumber numberWithDouble:267.8] forKey:Key_Weight];
    [InputNameValuePairsData setObject:[NSNumber numberWithInt:261] forKey:Key_HeartRate];
    [InputNameValuePairsData setObject:[NSNumber numberWithInt:280] forKey:Key_BloodPressureLow];
    [InputNameValuePairsData setObject:[NSNumber numberWithInt:2140] forKey:Key_BloodPressureHigh];
    CalculateNameValuePairsData = [NSMutableDictionary dictionary];
    [CalculateNameValuePairsData setObject:[NSNumber numberWithDouble:223.4] forKey:Key_BMI];
    [CalculateNameValuePairsData setObject:[NSNumber numberWithDouble:287.5] forKey:Key_HealthMark];
    [CalculateNameValuePairsData setObject:[NSArray arrayWithObjects:@"B3",@"VE", nil] forKey:@"LackNutrientIDs"];
    [CalculateNameValuePairsData setObject:[NSArray arrayWithObjects:@"ill21",@"ill22", nil] forKey:@"InferIllnesses"];
    [CalculateNameValuePairsData setObject:[NSArray arrayWithObjects:@"a21",@"a22", nil] forKey:@"Suggestions"];
    [CalculateNameValuePairsData setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2100],@"10001", [NSNumber numberWithInt:2150],@"10002", nil] forKey:@"RecommendFoodAndAmounts"];
    
    [da deleteUserRecordSymptomByByDayLocal:dayLocal];
    
    [da insertUserRecordSymptom_withDayLocal:dayLocal andUpdateTimeUTC:updateTime andInputNameValuePairsData:InputNameValuePairsData andNote:note andCalculateNameValuePairsData:CalculateNameValuePairsData];
    [da getUserRecordSymptomDataByRange_withStartDayLocal:0 andEndDayLocal:0 andStartMonthLocal:0 andEndMonthLocal:0];
    
    [da getUserRecordSymptom_DistinctMonth];

}

+(void)test_genData_UserRecordSymptom1
{
    LZDataAccess *da = [LZDataAccess singleton];

    if (true){
        int dayLocal = 20131104;
        NSDate *updateTime = [NSDate date];
        NSString *note = @"note1";
        NSString *inputNameValuePairsStr=@"{\"BodyTemperature\":2.777777851363761,\"HeartRate\":65,\"SymptomsByType\":[[\"头面\",[\"头晕\",\"头痛\"]],[\"眼睛\",[\"视觉模糊\",\"暗光看不清\"]]],\"Symptoms\":[\"头晕\",\"头痛\",\"视觉模糊\",\"暗光看不清\"],\"weight\":81.64746439263358,\"BloodPressureLow\":90,\"BloodPressureHigh\":150}";
        NSString *calculateNameValuePairsStr=@"{\"InferIllnessesAndSuggestions\":{\"体温过低\":[\"避免出汗很多的活动。\",\"冬天穿戴羊毛，丝绸，和聚丙烯材质的衣物。\",\"覆盖保护好头，脸，脖子，和手。\",\"脱掉潮湿衣服，尤其要保持手和脚干燥。\"],\"轻度高血压\":[\"控制和减少自己的压力。\",\"健康饮食。减少盐的摄入。\",\"穿戴羊毛，丝绸，和聚丙烯材质的衣物。\",\"覆盖保护好头，脸，脖子，和手。\",\"脱掉潮湿衣服，尤其要保持手和脚干燥。\"],\"轻度高血压\":[\"控制和减少自己的压力。\",\"健康饮食。减少盐的摄入。\",\"保持适中的体重。增加锻炼。\",\"在家要监督自己的血压。\",\"充足的睡眠。\",\"限制饮酒。不要吸烟。\",\"坚持练习放松和深呼吸的方法。\"]},\"LackNutrientsAndFoods\":{\"Riboflavin_(mg)\":{\"35070\":138.2978723404256,\"11268\":102.3622047244095,\"11260\":323.3830845771144,\"01140\":164.5569620253164,\"11667\":35.42234332425068},\"Iron_(mg)\":{\"11988\":136.0544217687075,\"15012\":67.34006734006734,\"16128\":82.21993833504625,\"12147\":144.6654611211573,\"20109\":199.501246882793},\"Vit_A_RAE\":{\"11253\":243.2432432432433,\"13325\":18.11594202898551,\"05027\":27.30582524271844,\"11297\":213.7767220902613,\"11251\":206.4220183486239}},\"BMI\":28.2517177829182,\"HealthMark\":97.5,\"IllnessIds\":[\"轻度高血压\",\"体温过低\"]}";
        NSDictionary *row = [da getUserRecordSymptomDataByDayLocal:dayLocal];
        if (row == nil){
            [da insertUserRecordSymptom_withDayLocal:dayLocal andUpdateTimeUTC:updateTime andInputNameValuePairs:inputNameValuePairsStr andNote:note andCalculateNameValuePairs:calculateNameValuePairsStr];
        }else{
            [da updateUserRecordSymptom_withDayLocal:dayLocal andUpdateTimeUTC:updateTime andInputNameValuePairs:inputNameValuePairsStr andNote:note andCalculateNameValuePairs:calculateNameValuePairsStr];
        }
    }

    if (true){
        int dayLocal = 20131105;
        NSDate *updateTime = [NSDate date];
        NSString *note = @"note1";
        NSString *inputNameValuePairsStr=@"{\"BodyTemperature\":38.5,\"HeartRate\":68,\"SymptomsByType\":[[\"眼睛\",[\"视觉模糊\",\"眼睛易疲劳\"]],[\"耳鼻\",[\"耳鸣\",\"听力减退\"]]],\"Symptoms\":[\"视觉模糊\",\"眼睛易疲劳\",\"耳鸣\",\"听力减退\"],\"weight\":76,\"BloodPressureLow\":100,\"BloodPressureHigh\":159}";
        NSString *calculateNameValuePairsStr=@"{\"LackNutrientsAndFoods\":{\"Riboflavin_(mg)\":{\"17195\":58.03571428571428,\"10106\":76.60577489687684,\"15175\":315.5339805825243,\"01123\":284.4638949671773,\"11667\":35.42234332425068},\"Iron_(mg)\":{\"20581\":172.4137931034483,\"16108\":50.95541401273886,\"16128\":82.21993833504625,\"11231\":168.0672268907563,\"12120\":170.2127659574468},\"Vit_C_(mg)\":{\"09139\":39.42181340341656,\"11024\":107.1428571428571,\"11109\":245.9016393442623,\"11254\":204.5454545454545,\"11233\":75}},\"BMI\":26.29757785467128,\"HealthMark\":97.5,\"IllnessIds\":[\"轻度高血压\",\"中热\"]}";
        NSDictionary *row = [da getUserRecordSymptomDataByDayLocal:dayLocal];
        if (row == nil){
            [da insertUserRecordSymptom_withDayLocal:dayLocal andUpdateTimeUTC:updateTime andInputNameValuePairs:inputNameValuePairsStr andNote:note andCalculateNameValuePairs:calculateNameValuePairsStr];
        }else{
            [da updateUserRecordSymptom_withDayLocal:dayLocal andUpdateTimeUTC:updateTime andInputNameValuePairs:inputNameValuePairsStr andNote:note andCalculateNameValuePairs:calculateNameValuePairsStr];
        }
    }

    if (true){
        int dayLocal = 20131107;
        NSDate *updateTime = [NSDate date];
        NSString *note = @"note1";
        NSString *inputNameValuePairsStr=@"{\"BodyTemperature\":39,\"HeartRate\":96,\"SymptomsByType\":[[\"耳鼻\",[\"耳后出油\"]],[\"口腔\",[\"唇沟出油\",\"口唇干裂\",\"张口疼痛\"]]],\"Symptoms\":[\"耳后出油\",\"唇沟出油\",\"张口疼痛\",\"口唇干裂\"],\"weight\":77,\"BloodPressureLow\":85,\"BloodPressureHigh\":123}";
        NSString *calculateNameValuePairsStr=@"{\"InferIllnessesAndSuggestions\":{\"高热\":[\"用凉水擦皮肤降温。冷水淋浴，或冷水泡澡。\",\"持续喝凉水，和凉的运动饮料。\",\"穿宽松衣物，脱掉不必要的衣服。\",\"在凉爽的地方休息。仰卧，保持腿的位置高于心脏。\"]},\"LackNutrientsAndFoods\":{\"Riboflavin_(mg)\":{\"17195\":58.03571428571428,\"11268\":102.3622047244095,\"01140\":164.5569620253164,\"13323\":45.77464788732395,\"35016\":351.3513513513514},\"Iron_(mg)\":{\"02014\":12.05545509342978,\"12151\":204.0816326530612,\"11240\":65.68144499178982,\"02009\":46.24277456647399,\"12131\":216.8021680216802},\"Vit_B6_(mg)\":{\"09040\":354.2234332425069,\"15036\":237.2262773722628,\"11413\":169.0507152145643,\"02020\":78.59733978234583,\"05332\":253.90625}},\"BMI\":26.64359861591696,\"HealthMark\":98,\"IllnessIds\":[\"高热\"]}";
        NSDictionary *row = [da getUserRecordSymptomDataByDayLocal:dayLocal];
        if (row == nil){
            [da insertUserRecordSymptom_withDayLocal:dayLocal andUpdateTimeUTC:updateTime andInputNameValuePairs:inputNameValuePairsStr andNote:note andCalculateNameValuePairs:calculateNameValuePairsStr];
        }else{
            [da updateUserRecordSymptom_withDayLocal:dayLocal andUpdateTimeUTC:updateTime andInputNameValuePairs:inputNameValuePairsStr andNote:note andCalculateNameValuePairs:calculateNameValuePairsStr];
        }
    }

    if (true){
        int dayLocal = 20131111;
        NSDate *updateTime = [NSDate date];
        NSString *note = @"note1";
        NSString *inputNameValuePairsStr=@"{\"BodyTemperature\":36,\"HeartRate\":88,\"SymptomsByType\":[[\"口腔\",[\"唇红肿\"]],[\"牙齿\",[\"牙齿松动\",\"牙齿脱落\"]]],\"Symptoms\":[\"唇红肿\",\"牙齿松动\",\"牙齿脱落\"],\"weight\":59,\"BloodPressureLow\":69,\"BloodPressureHigh\":158}";
        NSString *calculateNameValuePairsStr=@"{\"InferIllnessesAndSuggestions\":{\"体温过低\":[\"避免出汗很多的活动。\",\"冬天穿戴羊毛，丝绸，和聚丙烯材质的衣物。\",\"覆盖保护好头，脸，脖子，和手。\",\"脱掉潮湿衣服，尤其要保持手和脚干燥。\"]},\"LackNutrientsAndFoods\":{\"Riboflavin_(mg)\":{\"35070\":138.2978723404256,\"17195\":58.03571428571428,\"01123\":284.4638949671773,\"11260\":323.3830845771144,\"15175\":315.5339805825243},\"Vit_C_(mg)\":{\"09139\":39.42181340341656,\"09181\":245.2316076294278,\"11951\":49.04632152588556,\"11503\":163.6363636363637,\"11254\":204.5454545454545}},\"BMI\":20.41522491349481,\"HealthMark\":97.5,\"IllnessIds\":[\"体温过低\"]}";
        NSDictionary *row = [da getUserRecordSymptomDataByDayLocal:dayLocal];
        if (row == nil){
            [da insertUserRecordSymptom_withDayLocal:dayLocal andUpdateTimeUTC:updateTime andInputNameValuePairs:inputNameValuePairsStr andNote:note andCalculateNameValuePairs:calculateNameValuePairsStr];
        }else{
            [da updateUserRecordSymptom_withDayLocal:dayLocal andUpdateTimeUTC:updateTime andInputNameValuePairs:inputNameValuePairsStr andNote:note andCalculateNameValuePairs:calculateNameValuePairsStr];
        }
    }
    
    if (true){
        int dayLocal = 20131001;
        NSDate *updateTime = [NSDate date];
        NSString *note = @"note1";
        NSString *inputNameValuePairsStr=@"{\"BodyTemperature\":39,\"Symptoms\":[\"牙龈增生\",\"咽喉发痒\",\"咽喉灼热\",\"咽喉疼痛\",\"咽干\",\"声嘶\",\"讲话困难\",\"吞咽困难\",\"甲状腺肿大\",\"扁桃体肿大\"],\"SymptomsByType\":[[\"牙齿\",[\"牙龈增生\"]],[\"咽喉\",[\"咽喉发痒\",\"咽喉灼热\",\"咽喉疼痛\",\"咽干\",\"声嘶\",\"讲话困难\",\"吞咽困难\",\"甲状腺肿大\",\"扁桃体肿大\"]]]}";
        NSString *calculateNameValuePairsStr=@"{\"InferIllnessesAndSuggestions\":{\"急性病毒性咽炎\":[\"面带口罩，避免吸入灰尘。\",\"饭前，便后，喷嚏或咳嗽后，注意洗手。\",\"擤鼻涕，咳嗽时，使用纸巾。\",\"不要与他人共用水杯和餐具。\",\"保持房间空气湿润。\",\"戒烟，避免二手烟。\",\"当空气污染严重时，尽量待在室内。\"],\"急性病毒性喉炎\":[\"饭前，便后，喷嚏或咳嗽后，注意洗手。\",\"避免与有上呼吸道疾病的人接触。\",\"限制酒精和咖啡。\",\"戒烟，避免二手烟。\",\"多喝流体，有助于痰液稀释。\",\"避免清咳嗓子。\"],\"高热\":[\"用凉水擦皮肤降温。冷水淋浴，或冷水泡澡。\",\"持续喝凉水，和凉的运动饮料。\",\"穿宽松衣物，脱掉不必要的衣服。\",\"在凉爽的地方休息。仰卧，保持腿的位置高于心脏。\"],\"急性扁桃体炎\":[\"饭前，便后，喷嚏或咳嗽后，注意洗手。\",\"不要与他人共用水杯和餐具。\",\"充足的睡眠，让嗓子休息。\",\"多喝水，保持嗓子湿凉爽的地方休息。仰卧，保持腿的位置高于心脏。\"],\"急性扁桃体炎\":[\"饭前，便后，喷嚏或咳嗽后，注意洗手。\",\"不要与他人共用水杯和餐具。\",\"充足的睡眠，让嗓子休息。\",\"多喝水，保持嗓子湿润，避免脱水。\",\"保持房间空气湿润。\"]},\"LackNutrientsAndFoods\":{\"Vit_A_RAE\":{\"11297\":213.7767220902613,\"10110\":13.84189480159951,\"11251\":206.4220183486239,\"11507\":126.9393511988716,\"17199\":12.17697199296442},\"Vit_C_(mg)\":{\"09190\":247.2527472527473,\"11270\":128.5714285714286,\"11156\":154.9053356282272,\"11503\":163.6363636363637,\"09148\":97.08737864077671},\"Vit_D_(µg)\":{\"15051\":205.4794520547945,\"15025\":64.37768240343348,\"15050\":164.8351648351648,\"15085\":136.3636363636363,\"11998\":133.9285714285714},\"Calcium_(mg)\":{\"42205\":145.1378809869376,\"16129\":268.8172043010753,\"01152\":699.3006993006993,\"16128\":274.7252747252747,\"16235\":813.0081300813009},\"Iron_(mg)\":{\"12023\":54.9828178694158,\"16014\":159.3625498007968,\"02014\":12.05545509342978,\"12151\":204.0816326530612,\"20109\":199.501246882793}},\"BMI\":20.41522491349481,\"HealthMark\":93.5,\"IllnessIds\":[\"高热\",\"急性病毒性咽炎\",\"急性病毒性喉炎\",\"急性扁桃体炎\"]}";
        NSDictionary *row = [da getUserRecordSymptomDataByDayLocal:dayLocal];
        if (row == nil){
            [da insertUserRecordSymptom_withDayLocal:dayLocal andUpdateTimeUTC:updateTime andInputNameValuePairs:inputNameValuePairsStr andNote:note andCalculateNameValuePairs:calculateNameValuePairsStr];
        }else{
            [da updateUserRecordSymptom_withDayLocal:dayLocal andUpdateTimeUTC:updateTime andInputNameValuePairs:inputNameValuePairsStr andNote:note andCalculateNameValuePairs:calculateNameValuePairsStr];
        }
    }
    
    if (true){
        int dayLocal = 20131028;
        NSDate *updateTime = [NSDate date];
        NSString *note = @"note1";
        NSString *inputNameValuePairsStr=@"{\"HeartRate\":99,\"Symptoms\":[\"呼吸不畅\",\"气短\",\"咳嗽\",\"咳痰\",\"哮鸣音\",\"喘息\",\"痰中带血\"],\"SymptomsByType\":[[\"呼吸\",[\"呼吸不畅\",\"气短\",\"咳嗽\",\"咳痰\",\"痰中带血\",\"喘息\",\"哮鸣音\"]]]}";
        NSString *calculateNameValuePairsStr=@"{\"InferIllnessesAndSuggestions\":{\"慢性支气管炎\":[\"饭前，便后，喷嚏或咳嗽后，注意洗手。\",\"保持房间温暖，湿度适中。\",\"充分休息。\",\"戒烟，避免二手烟。\"],\"支气管哮喘\":[\"制定和学会紧急自我处理方法。\",\"确定诱发因素和避免的方法。\",\"留意监督自己的呼吸。了解哮喘发生时的早期症状。\"]},\"LackNutrientsAndFoods\":{\"Vit_A_RAE\":{\"17199\":12.17697199296442,\"05143\":7.510013351134846,\"11124\":107.7844311377246,\"11507\":126.9393511988716,\"11233\":180},\"Iron_(mg)\":{\"12014\":90.70294784580499,\"12087\":119.7604790419162,\"16128\":82.21993833504625,\"15164\":202.5316455696202,\"15229\":73.80073800738008},\"Potassium_(mg)\":{\"16014\":316.9251517194875,\"16022\":357.1428571428572,\"16001\":374.8006379585327,\"16080\":377.207062600321,\"16032\":345.8425312729948}},\"BMI\":20.41522491349481,\"HealthMark\":95.5,\"IllnessIds\":[\"慢性支气管炎\",\"支气管哮喘\"]}";
        NSDictionary *row = [da getUserRecordSymptomDataByDayLocal:dayLocal];
        if (row == nil){
            [da insertUserRecordSymptom_withDayLocal:dayLocal andUpdateTimeUTC:updateTime andInputNameValuePairs:inputNameValuePairsStr andNote:note andCalculateNameValuePairs:calculateNameValuePairsStr];
        }else{
            [da updateUserRecordSymptom_withDayLocal:dayLocal andUpdateTimeUTC:updateTime andInputNameValuePairs:inputNameValuePairsStr andNote:note andCalculateNameValuePairs:calculateNameValuePairsStr];
        }
    }



    
    
    
    
    
}

+(void)test_getSingleNutrientRichFoodWithAmount_forNutrients
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
    
    NSArray *nutrientIds = [LZRecommendFood getCustomNutrients:nil];

    LZRecommendFood *rf = [[LZRecommendFood alloc]init];
    [rf getSingleNutrientRichFoodWithAmount_forNutrients:nutrientIds withUserInfo:userInfo andOptions:nil];
}


+(void)test_getIllness2
{
    
    LZDataAccess *da = [LZDataAccess singleton];
    [da getAllIllness];
    
    [da getFoodCnTypes];
    
}


+(void)test_syncRemoteDataInParse
{
    [self saveParseRowObj1];
}
+(void)test_syncRemoteDataInParse_2
{
    [LZUtility syncRemoteDataToLocal_withJustCallback:^(BOOL succeeded) {
        LZDataAccess *da = [LZDataAccess singleton];
        [da getUserRecordSymptomRawRowsByRange_withStartDayLocal:0 andEndDayLocal:0 andStartMonthLocal:0 andEndMonthLocal:0];
        
    }];//syncRemoteDataToLocal_withJustCallback
}

+(void)saveParseRowObj1
{
    if (true){
        int dayLocal = 20120304;
        NSDate *updateTime = [NSDate date];
        NSMutableDictionary * InputNameValuePairsData = [NSMutableDictionary dictionary];
        NSString *note = @"note1";
        NSMutableDictionary * CalculateNameValuePairsData = [NSMutableDictionary dictionary];
        NSMutableDictionary * LackNutrientsAndFoods,*InferIllnessesAndSuggestions;
        
        [InputNameValuePairsData setObject:[NSArray arrayWithObjects:@"症状a1",@"症状a2", nil] forKey:Key_Symptoms];
        [InputNameValuePairsData setObject:[NSNumber numberWithDouble:67.8] forKey:Key_Weight];
        
        [CalculateNameValuePairsData setObject:[NSNumber numberWithDouble:87.5] forKey:Key_HealthMark];
        LackNutrientsAndFoods = [NSMutableDictionary dictionary];
        [LackNutrientsAndFoods setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:100],@"20001", [NSNumber numberWithInt:150],@"20002", nil] forKey:@"Vb1"];
        [LackNutrientsAndFoods setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:100],@"10011", [NSNumber numberWithInt:150],@"10012", nil] forKey:@"Vb2"];
        [CalculateNameValuePairsData setObject:LackNutrientsAndFoods forKey:Key_LackNutrientsAndFoods];
        InferIllnessesAndSuggestions = [NSMutableDictionary dictionary];
        [InferIllnessesAndSuggestions setObject:[NSArray arrayWithObjects:@"建议a1",@"建议a2", nil] forKey:@"疾病a1"];
        [InferIllnessesAndSuggestions setObject:[NSArray arrayWithObjects:@"建议b1",@"建议b2", nil] forKey:@"疾病a2"];
        [CalculateNameValuePairsData setObject:InferIllnessesAndSuggestions forKey:Key_InferIllnessesAndSuggestions];
        
        PFObject *parseObjUserRecord = [LZUtility getToSaveParseObject_UserRecordSymptom_withDayLocal:dayLocal andUpdateTimeUTC:updateTime andInputNameValuePairsData:InputNameValuePairsData andNote:note andCalculateNameValuePairsData:CalculateNameValuePairsData];
                                                 
        [parseObjUserRecord saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSMutableString *msg = [NSMutableString string];
            if (succeeded){
                [msg appendFormat:@"PFObject.saveInBackgroundWithBlock OK"];
                [LZUtility saveParseObjectInfo_CurrentUserRecordSymptom_withParseObjectId:parseObjUserRecord.objectId andDayLocal:dayLocal];
            }else{
                [msg appendFormat:@"PFObject.saveInBackgroundWithBlock ERR:%@,\n err.userInfo:%@",error,[error userInfo]];
            }
            NSLog(@"saveParseRowObj1 %@",msg);
            
            [self saveParseRowObj2];
        }];
    }
}

+(void)saveParseRowObj2
{
    if (true){
        int dayLocal = 20120305;
        NSDate *updateTime = [NSDate date];
        NSMutableDictionary * InputNameValuePairsData = [NSMutableDictionary dictionary];
        NSString *note = @"note2";
        NSMutableDictionary * CalculateNameValuePairsData = [NSMutableDictionary dictionary];
        NSMutableDictionary * LackNutrientsAndFoods,*InferIllnessesAndSuggestions;
        
        [InputNameValuePairsData setObject:[NSArray arrayWithObjects:@"症状b1",@"症状b2", nil] forKey:Key_Symptoms];
        [InputNameValuePairsData setObject:[NSNumber numberWithDouble:67.8] forKey:Key_Weight];
        
        [CalculateNameValuePairsData setObject:[NSNumber numberWithDouble:87.5] forKey:Key_HealthMark];
        LackNutrientsAndFoods = [NSMutableDictionary dictionary];
        [LackNutrientsAndFoods setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:100],@"20201", [NSNumber numberWithInt:150],@"20202", nil] forKey:@"Vb1"];
        [LackNutrientsAndFoods setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:100],@"10211", [NSNumber numberWithInt:150],@"10212", nil] forKey:@"Vb2"];
        [CalculateNameValuePairsData setObject:LackNutrientsAndFoods forKey:Key_LackNutrientsAndFoods];
        InferIllnessesAndSuggestions = [NSMutableDictionary dictionary];
        [InferIllnessesAndSuggestions setObject:[NSArray arrayWithObjects:@"建议c1",@"建议c2", nil] forKey:@"疾病c1"];
        [InferIllnessesAndSuggestions setObject:[NSArray arrayWithObjects:@"建议d1",@"建议d2", nil] forKey:@"疾病d2"];
        [CalculateNameValuePairsData setObject:InferIllnessesAndSuggestions forKey:Key_InferIllnessesAndSuggestions];
        
        PFObject *parseObjUserRecord = [LZUtility getToSaveParseObject_UserRecordSymptom_withDayLocal:dayLocal andUpdateTimeUTC:updateTime andInputNameValuePairsData:InputNameValuePairsData andNote:note andCalculateNameValuePairsData:CalculateNameValuePairsData];
        
        [parseObjUserRecord saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSMutableString *msg = [NSMutableString string];
            if (succeeded){
                [msg appendFormat:@"PFObject.saveInBackgroundWithBlock OK"];
                [LZUtility saveParseObjectInfo_CurrentUserRecordSymptom_withParseObjectId:parseObjUserRecord.objectId andDayLocal:dayLocal];
            }else{
                [msg appendFormat:@"PFObject.saveInBackgroundWithBlock ERR:%@,\n err.userInfo:%@",error,[error userInfo]];
            }
            NSLog(@"saveParseRowObj2 %@",msg);
            
            [LZUtility syncRemoteDataToLocal_withJustCallback:^(BOOL succeeded) {
                LZDataAccess *da = [LZDataAccess singleton];
                [da getUserRecordSymptomRawRowsByRange_withStartDayLocal:0 andEndDayLocal:0 andStartMonthLocal:0 andEndMonthLocal:0];
                
                [LZUtility syncRemoteDataToLocal_withJustCallback:^(BOOL succeeded) {
                    [da getUserRecordSymptomRawRowsByRange_withStartDayLocal:0 andEndDayLocal:0 andStartMonthLocal:0 andEndMonthLocal:0];
                    
                }];//syncRemoteDataToLocal_withJustCallback
            }];//syncRemoteDataToLocal_withJustCallback
        }];//saveInBackgroundWithBlock
    }
}


@end













