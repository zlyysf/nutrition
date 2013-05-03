//
//  LZRecommendFood.m
//  nutrition
//
//  Created by Yasofon on 13-5-2.
//  Copyright (c) 2013年 lingzhi mobile. All rights reserved.
//

#import "LZRecommendFood.h"

@implementation LZRecommendFood

-(NSMutableDictionary *) recommendFoodForEnoughNuitrition:(int)sex age:(int)age weight:(float)weight height:(float)height activityLevel:(int )activityLevel
{
    NSDictionary *DRIsDict = [LZUtility getStandardDRIs:sex age:age weight:weight height:height activityLevel:activityLevel];
    int upperLimit = 1000; // 1000 g
    int topN = 20;
    NSString *colName_NO = @"NDB_No";
    double nearZero = 0.0000001;
    NSMutableDictionary *recommendFoodAmountDict = [NSMutableDictionary dictionaryWithCapacity:100];//key is NDB_No
    NSMutableDictionary *recommendFoodAttrDict = [NSMutableDictionary dictionaryWithCapacity:100];//key is NDB_No
    
    NSMutableDictionary *nutrientSupplyDict = [NSMutableDictionary dictionaryWithDictionary:DRIsDict];
    NSArray *nutrientNames1 = [nutrientSupplyDict allKeys];
    for (int i=0; i<nutrientNames1.count; i++) {//初始化supply集合
        [nutrientSupplyDict setObject:[NSNumber numberWithDouble:0.0] forKey:nutrientNames1[i]];
    }
    
    for (int i=0; i<nutrientNames1.count; i++) {
        NSString *nutrientName = nutrientNames1[i];
        NSNumber *totalNeed = DRIsDict[nutrientName];
        if ([totalNeed doubleValue]==0.0){//需求量为0的就不用计算了
            [nutrientSupplyDict removeObjectForKey:nutrientName];
        }
    }
    NSMutableDictionary *nutrientNameDictToCal = [NSMutableDictionary dictionaryWithDictionary:nutrientSupplyDict];
    while (nutrientNameDictToCal.allKeys.count>0) {
        double maxNutrientLackRatio = nearZero;
        NSString *maxLackNutrientName = nil;
        NSArray * nutrientNamesToCal = [nutrientNameDictToCal allKeys];
        for(int i=0; i<nutrientNamesToCal.count; i++){//先找出最需要补的营养素,即缺乏比例最大的
            NSString *nutrientName = nutrientNamesToCal[i];
            NSNumber *nmSupplied = nutrientSupplyDict[nutrientName];
            NSNumber *nmTotalNeed = DRIsDict[nutrientName];
            double toAdd = [nmTotalNeed doubleValue]-[nmSupplied doubleValue];
            if (toAdd <= nearZero){
                //可能由于在补一种或某些营养素时，选中的一些食物已经把其他的一些营养素的需要量给补够了。这样的营养素就可以跳过不计算了.
                [nutrientNameDictToCal removeObjectForKey:nutrientName];
            }
            double lackRatio = toAdd/[nmTotalNeed doubleValue];
            if (lackRatio > maxNutrientLackRatio){
                maxLackNutrientName = nutrientName;
                maxNutrientLackRatio = lackRatio;
            }
        }
        if (maxLackNutrientName == nil){//如果找不到最需要补的营养素，说明已经都补够了
            break;
        }
        //找到了一个营养素
        NSString *nutrientNameToCal = maxLackNutrientName;
        NSNumber *nmSupplied = nutrientSupplyDict[nutrientNameToCal];
        NSNumber *nmTotalNeed = DRIsDict[nutrientNameToCal];
        double toAddForNutrient = [nmTotalNeed doubleValue]-[nmSupplied doubleValue];
        LZDataAccess *da = [LZDataAccess singleton];
        NSArray * foods = [da getRichNutritionFood:nutrientNameToCal andTopN:topN];//找一些对于这种营养素含量最高的食物
        bool canNotSupplyEnough = FALSE;
        for(int i=0; i<foods.count; i++){
            NSDictionary *food = foods[i];
            NSString *foodNO = food[colName_NO];
            if ([recommendFoodAmountDict objectForKey:foodNO] != nil){//这种食物已经用到了，即已经在供给食物集合中出现。就不再使用它了。
                continue;
            }
            
            NSNumber* nmNutrientContentOfFood = [food objectForKey:nutrientNameToCal];
            if ([nmNutrientContentOfFood doubleValue]==0.0){
                //这个营养素的目前计算到的含其最多的食物的含量已经为0，没法补齐这个营养素了.计算下一个吧。
                canNotSupplyEnough = TRUE;
            }else{
                double toAddForFood = toAddForNutrient / [nmNutrientContentOfFood doubleValue] * 100.0;//单位是g
                if (toAddForFood - upperLimit > nearZero){//要补的食物的量过多，当食物所含该种营养素的量太少时发生。这时只取到上限值，再找其他食物来补充。应该要注意记录 TODO
                    toAddForFood = upperLimit;
                }
                toAddForNutrient = toAddForNutrient - toAddForFood / 100.0 * [nmNutrientContentOfFood doubleValue];
                NSArray *foodAttrs = [food allKeys];//虽然food中主要有各营养成分的量，也有ID，desc等字段
                //这个食物的各营养的量加到supply中
                for (int j=0; j<foodAttrs.count; j++) {
                    NSString *foodAttr = foodAttrs[j];
                    NSObject *foodAttrValue = [food objectForKey:foodAttr];
                    NSNumber *nmSupplyNutrient = [nutrientSupplyDict objectForKey:foodAttr];
                    if (nmSupplyNutrient != nil){//说明这个字段对应营养成分
                        NSNumber *nmNutrientContent2OfFood = (NSNumber *)foodAttrValue;
                        if ([nmNutrientContent2OfFood doubleValue] != 0.0){
                            double supplyNutrient2 = [nmSupplyNutrient doubleValue]+ [nmNutrientContent2OfFood doubleValue]*(toAddForFood/100.0);
                            [nutrientSupplyDict setObject:[NSNumber numberWithDouble:supplyNutrient2] forKey:foodAttr];
                        }
                    }
                }//for j
                [recommendFoodAmountDict setObject:[NSNumber numberWithDouble:toAddForFood] forKey:foodNO];
                [recommendFoodAttrDict setObject:food forKey:foodNO];
            }
            if (toAddForNutrient >= nearZero){
                //继续下一个循环取食物来补足
            }else{
                //这个营养素已经补足
                [nutrientNameDictToCal removeObjectForKey:nutrientNameToCal];//可以从待计算集合中去掉了
                break;
            }

        }//for i
    }//while (nutrientNameDictToCal.allKeys.count>0)
    
    NSLog(@"recommendFoodForEnoughNuitrition nutrientSupplyDict=\n%@, recommendFoodAmountDict=\n%@",nutrientSupplyDict,recommendFoodAmountDict);
    
    NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithCapacity:5];
    [retDict setObject:DRIsDict forKey:@"DRI"];
    [retDict setObject:nutrientSupplyDict forKey:@"NutrientSupply"];
    [retDict setObject:recommendFoodAmountDict forKey:@"FoodAmount"];
    [retDict setObject:recommendFoodAttrDict forKey:@"FoodAttr"];
    return retDict;
}

@end
























