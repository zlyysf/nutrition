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

@implementation LZTest1

+(void)test1
{
    
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
    
    NSString *strHtml = [rf generateHtml_RecommendFoodForEnoughNuitrition:retDict];
    [strHtml writeToFile:@"recommend1.html" atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:@"recommend1.csv" withRecommendResult:retDict];

}


+(void)test2
{
    [self.class case1];
}

+(NSString*)getParamsDigestStr_withUserInfo:(NSDictionary *)userInfo andOptions:(NSDictionary *)options andTakenFoodAmountDict:(NSDictionary *)takenFoodAmountDict{
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
    
    BOOL notAllowSameFood = TRUE;//这是一个策略标志位，偏好食物的多样化的标志位，即当选取食物补充营养时，优先选取以前没有用过的食物。
    BOOL randomSelectFood = TRUE;
    int randomRangeSelectFood = 0;//配合randomSelectFood，用于限制随机范围，0表示不限制, >0表示优先选择其范围内的东西
    BOOL needLimitNutrients = TRUE;//是否要根据需求限制计算的营养素集合
    int limitRecommendFoodCount = 2;//0;//4;//只限制显示的
    
    assert(options != nil);
    
    NSNumber *nmFlag_notAllowSameFood = [options objectForKey:@"notAllowSameFood"];
    assert (nmFlag_notAllowSameFood != nil);
    notAllowSameFood = [nmFlag_notAllowSameFood boolValue];
        
    NSNumber *nmFlag_randomSelectFood = [options objectForKey:@"randomSelectFood"];
    assert(nmFlag_randomSelectFood != nil);
    randomSelectFood = [nmFlag_randomSelectFood boolValue];
        
    NSNumber *nm_randomRangeSelectFood = [options objectForKey:@"randomRangeSelectFood"];
    assert(nm_randomRangeSelectFood != nil);
    randomRangeSelectFood = [nm_randomRangeSelectFood intValue];
        
    NSNumber *nmFlag_needLimitNutrients = [options objectForKey:@"needLimitNutrients"];
    assert(nmFlag_needLimitNutrients != nil);
    needLimitNutrients = [nmFlag_needLimitNutrients boolValue];
    
    NSNumber *nm_limitRecommendFoodCount = [options objectForKey:@"limitRecommendFoodCount"];
    assert(nm_limitRecommendFoodCount != nil);
    limitRecommendFoodCount = [nm_limitRecommendFoodCount intValue];

    NSMutableString *str = [NSMutableString stringWithFormat:@"s%dY%dw%.0fh%.0fa%d_M%dr%drr%dLn%dLc%d"
                          ,sex,age,weight,height,activityLevel
                          ,notAllowSameFood,randomSelectFood,randomRangeSelectFood,needLimitNutrients,limitRecommendFoodCount];
    
    NSArray *keys = takenFoodAmountDict.allKeys;
    for(int i=0; i<keys.count; i++){
        NSString *key = keys[i];
        NSNumber *nmAmount = [takenFoodAmountDict objectForKey:key];
        NSString *s1 = [NSString stringWithFormat:@"_%@-%.0f",key,[nmAmount doubleValue]];
        [str appendString:s1];
    }
    return str;
}

+(void)case1
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
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:notAllowSameFood],@"notAllowSameFood",
                             [NSNumber numberWithBool:randomSelectFood],@"randomSelectFood",
                             [NSNumber numberWithInt:randomRangeSelectFood],@"randomRangeSelectFood",
                             [NSNumber numberWithBool:needLimitNutrients],@"needLimitNutrients",
                             [NSNumber numberWithInt:limitRecommendFoodCount],@"limitRecommendFoodCount",
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
    strHtml = [self.class getFullHtml_withPart:strHtml];
    [strHtml writeToFile:htmlFilePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    
    [rf formatCsv_RecommendFoodForEnoughNuitrition:csvFileName withRecommendResult:retDict];
    
}




+(NSString*)getFullHtml_withPart:(NSString*)htmlPart
{
    NSMutableString * str = [NSMutableString string];
    [str appendString:@"<html><head><meta charset=\"UTF-8\"></head><body>\n"];
    [str appendString:htmlPart];
    [str appendString:@"\n</body></html>"];
    return str;
}










@end
