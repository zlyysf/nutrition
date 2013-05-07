//
//  LZRecommendFood.m
//  nutrition
//
//  Created by Yasofon on 13-5-2.
//  Copyright (c) 2013年 lingzhi mobile. All rights reserved.
//

#import "LZRecommendFood.h"

@implementation LZRecommendFood





-(NSMutableDictionary *) recommendFoodForEnoughNuitritionWithPreIntake:(NSDictionary*)takenFoodAmountDict sex:(int)sex age:(int)age weight:(float)weight height:(float)height activityLevel:(int )activityLevel
{
    int upperLimit = 1000; // 1000 g
    int topN = 20;
    NSString *colName_NO = @"NDB_No";
    double nearZero = 0.0000001;
    //这里列出的营养素有专门而简单的食物补充，通过我们预置的那些食物反而不好补充
    NSDictionary *nutrientsNotFromCustomFood =[ NSDictionary dictionaryWithObjectsAndKeys:@"1",@"Water_(g)", nil];
    LZDataAccess *da = [LZDataAccess singleton];
    
    NSArray *takenFoodIDs = nil;
    if (takenFoodAmountDict!=nil && takenFoodAmountDict.count>0)
        takenFoodIDs = [takenFoodAmountDict allKeys];
    NSArray *takenFoodAttrAry = [da getFoodByIds:takenFoodIDs];

    
    NSDictionary *DRIsDict = [LZUtility getStandardDRIs:sex age:age weight:weight height:height activityLevel:activityLevel];
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
    
    NSMutableDictionary *takenFoodAttrDict = [NSMutableDictionary dictionaryWithCapacity:100];//key is NDB_No
    if (takenFoodAttrAry != nil ){
        //已经吃了的各食物的各营养的量加到supply中
        for(int i=0; i<takenFoodAttrAry.count; i++){
            NSDictionary *takenFoodAttrs = takenFoodAttrAry[i];
            NSString *foodId = [takenFoodAttrs objectForKey:colName_NO];
            NSNumber *nmTakenFoodAmount = nil;
            if (takenFoodAmountDict != nil)
                nmTakenFoodAmount = [takenFoodAmountDict objectForKey:foodId];
            assert(foodId!=nil);
            [takenFoodAttrDict setObject:takenFoodAttrs forKey:foodId];

//            //这个食物的各营养的量加到supply中
//            NSArray *foodAttrs = [takenFoodAttrs allKeys];//虽然food的属性中主要有各营养成分的量，也有ID，desc等字段
//            for (int j=0; j<foodAttrs.count; j++) {
//                NSString *foodAttrName = foodAttrs[j];
//                NSObject *foodAttrValue = [takenFoodAttrs objectForKey:foodAttrName];
//                NSNumber *nmSupplyNutrient = [nutrientSupplyDict objectForKey:foodAttrName];
//                if (nmSupplyNutrient != nil){//说明这个字段对应营养成分
//                    NSNumber *nmNutrientContentOfFood = (NSNumber *)foodAttrValue;
//                    if ([nmNutrientContentOfFood doubleValue] != 0.0){
//                        double supplyNutrient2 = [nmSupplyNutrient doubleValue]+ [nmNutrientContentOfFood doubleValue]*([nmTakenFoodAmount doubleValue]/100.0);
//                        [nutrientSupplyDict setObject:[NSNumber numberWithDouble:supplyNutrient2] forKey:foodAttrName];
//                    }
//                }
//            }//for j
            
            //这个食物的各营养的量加到supply中
            NSArray *nutrientsToSupply = [nutrientSupplyDict allKeys];
            for(int j=0; j<nutrientsToSupply.count; j++){
                NSString *nutrient = nutrientsToSupply[j];
                id nutrientValueOfFood = [takenFoodAttrs objectForKey:nutrient];
                assert(nutrientValueOfFood != nil);
                if (nutrientValueOfFood != nil){
                    NSNumber *nmNutrientContentOfFood = (NSNumber *)nutrientValueOfFood;
                    assert(nmNutrientContentOfFood != nil);
                    if ([nmNutrientContentOfFood doubleValue] != 0.0){
                        NSNumber *nmSupplyNutrient = [nutrientSupplyDict objectForKey:nutrient];
                        double supplyNutrient2 = [nmSupplyNutrient doubleValue]+ [nmNutrientContentOfFood doubleValue]*([nmTakenFoodAmount doubleValue]/100.0);
                        [nutrientSupplyDict setObject:[NSNumber numberWithDouble:supplyNutrient2] forKey:nutrient];
                    }
                }
            }//for j
        }//for i
    }
    
    NSMutableArray* foodSupplyNutrientLogs = [NSMutableArray arrayWithCapacity:100];

    //对每个还需补足的营养素进行计算
    NSMutableDictionary *nutrientNameDictToCal = [NSMutableDictionary dictionaryWithDictionary:nutrientSupplyDict];
    while (nutrientNameDictToCal.allKeys.count>0) {
        double maxNutrientLackRatio = nearZero;
        NSString *maxLackNutrientName = nil;
        NSArray * nutrientNamesToCal = [nutrientNameDictToCal allKeys];
        for(int i=0; i<nutrientNamesToCal.count; i++){//先找出最需要补的营养素,即缺乏比例最大的
            NSString *nutrientName = nutrientNamesToCal[i];
            NSNumber *nmSupplied = nutrientSupplyDict[nutrientName];
            NSNumber *nmTotalNeed = DRIsDict[nutrientName];
            if ([nutrientsNotFromCustomFood objectForKey:nutrientName] != nil){
                //这种营养素使用这里的食物不好补充，就不计算了。
                [nutrientNameDictToCal removeObjectForKey:nutrientName];
                continue;
            }
            
            double toAdd = [nmTotalNeed doubleValue]-[nmSupplied doubleValue];
            if (toAdd <= nearZero){
                //可能由于在补一种或某些营养素时，选中的一些食物已经把其他的一些营养素的需要量给补够了。以及已经吃了的食物也把某些营养素摄取足了。这样的营养素就可以跳过不计算了.
                [nutrientNameDictToCal removeObjectForKey:nutrientName];
                continue;
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
        
        NSArray * foods = [da getRichNutritionFood:nutrientNameToCal andTopN:topN];//找一些对于这种营养素含量最高的食物
        bool canNotSupplyEnough = FALSE;
        for(int i=0; i<foods.count; i++){
            NSDictionary *food = foods[i];
            NSString *foodNO = food[colName_NO];
            if ([recommendFoodAmountDict objectForKey:foodNO] != nil || [takenFoodAttrDict objectForKey:foodNO] != nil){
                //这种食物已经用到了，即已经在供给食物集合中出现。就不再使用它了。或者在已吃食物清单中出现，也不再使用。
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
                //NSMutableDictionary *foodSupplyNutrientLog = [NSMutableDictionary dictionaryWithCapacity:5];
                NSMutableArray *foodSupplyNutrientLog = [NSMutableArray arrayWithCapacity:5];
                [foodSupplyNutrientLog addObject:maxLackNutrientName];
                [foodSupplyNutrientLog addObject:[NSNumber numberWithDouble:maxNutrientLackRatio]];
                [foodSupplyNutrientLog addObject:foodNO];
                [foodSupplyNutrientLog addObject:[NSNumber numberWithDouble:toAddForFood]];
                [foodSupplyNutrientLog addObject:[food objectForKey:@"Shrt_Desc"]];
                [foodSupplyNutrientLogs addObject:foodSupplyNutrientLog];
                
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
    
    NSLog(@"recommendFoodForEnoughNuitrition foodSupplyNutrientLogs=\n%@",foodSupplyNutrientLogs);
    NSLog(@"recommendFoodForEnoughNuitrition nutrientSupplyDict=\n%@, recommendFoodAmountDict=\n%@",nutrientSupplyDict,recommendFoodAmountDict);
    
    NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithCapacity:5];
    [retDict setObject:DRIsDict forKey:@"DRI"];//nutrient name as key, also column name
    [retDict setObject:nutrientSupplyDict forKey:@"NutrientSupply"];//nutrient name as key, also column name
    [retDict setObject:recommendFoodAmountDict forKey:@"FoodAmount"];//food NO as key
    [retDict setObject:recommendFoodAttrDict forKey:@"FoodAttr"];//food NO as key
    
    NSArray *userInfos = [NSArray arrayWithObjects:@"sex(0 for M)",[NSNumber numberWithInt:sex],@"age",[NSNumber numberWithInt:age],
        @"weight(kg)",[NSNumber numberWithFloat:weight],@"height(cm)",[NSNumber numberWithFloat:height],@"activityLevel",[NSNumber numberWithInt:activityLevel],nil];
    [retDict setObject:userInfos forKey:@"UserInfo"];//2D array
    [retDict setObject:foodSupplyNutrientLogs forKey:@"foodSupplyNutrientLogs"];//2D array
    
    if (takenFoodAmountDict != nil && takenFoodAmountDict.count>0){
        [retDict setObject:takenFoodAmountDict forKey:@"TakenFoodAmount"];//food NO as key
        [retDict setObject:takenFoodAttrDict forKey:@"TakenFoodAttr"];//food NO as key
    }
    return retDict;
}




/*
                            营养素1		营养素2		...
 食物ID1	食物名1	食物1质量	营养素1含量	营养素2含量	...
 食物ID2	食物名2	食物2质量
 
                            营养素1合计	营养素2合计
                            营养素1DRI	营养素2DRI
                            营养素1超量	营养素2超量
 
 对照表
                            营养素1		营养素2		...
 食物ID1	食物名1	100g		营养素1含量	营养素2含量	...
 食物ID2	食物名2	100g
 */
-(NSArray*) generateData2D_RecommendFoodForEnoughNuitrition:(NSDictionary*)recmdDict
{
    NSLog(@"formatCsv_RecommendFoodForEnoughNuitrition enter");
    
    NSDictionary *DRIsDict = [recmdDict objectForKey:@"DRI"];//nutrient name as key, also column name
    NSDictionary *nutrientSupplyDict = [recmdDict objectForKey:@"NutrientSupply"];//nutrient name as key, also column name
    NSDictionary *recommendFoodAmountDict = [recmdDict objectForKey:@"FoodAmount"];//food NO as key
    NSDictionary *recommendFoodAttrDict = [recmdDict objectForKey:@"FoodAttr"];//food NO as key
    
    NSArray *userInfos = [recmdDict objectForKey:@"UserInfo"];//2D array
    NSArray *foodSupplyNutrientLogs = [recmdDict objectForKey:@"foodSupplyNutrientLogs"];//2D array

    
    NSDictionary *takenFoodAmountDict = [recmdDict objectForKey:@"TakenFoodAmount"];//food NO as key
    NSDictionary *takenFoodAttrDict = [recmdDict objectForKey:@"TakenFoodAttr"];//food NO as key
    NSMutableArray *rows = [NSMutableArray arrayWithCapacity:1000];
    
    int colIdx_NutrientStart = 3;
    NSArray* nutrientNames = [DRIsDict allKeys];
    NSArray* nutrientNamesOrdered = [NSArray arrayWithObjects:@"Energ_Kcal",@"Carbohydrt_(g)",@"Lipid_Tot_(g)",@"Protein_(g)",
                   @"Vit_A_RAE",@"Vit_C_(mg)",@"Vit_D_(µg)",@"Vit_E_(mg)",@"Vit_K_(µg)",
                   @"Thiamin_(mg)",@"Riboflavin_(mg)",@"Niacin_(mg)",@"Vit_B6_(mg)",@"Folate_Tot_(µg)",
                   @"Vit_B12_(µg)",@"Panto_Acid_mg)",
                   @"Calcium_(mg)",@"Copper_(mg)",@"Iron_(mg)",@"Magnesium_(mg)",@"Manganese_(mg)",
                   @"Phosphorus_(mg)",@"Selenium_(µg)",@"Zinc_(mg)",@"Potassium_(mg)",@"Sodium_(mg)",
                   @"Water_(g)",@"Fiber_TD_(g)",@"Choline_Tot_ (mg)",@"Cholestrl_(mg)", nil];
    assert(nutrientNames.count==nutrientNamesOrdered.count);
    for(int i=0; i<nutrientNamesOrdered.count; i++){
        assert([DRIsDict objectForKey:nutrientNamesOrdered[i]]!=nil);
    }
    nutrientNames = nutrientNamesOrdered;
    
    
    int columnCount = colIdx_NutrientStart+nutrientNames.count;
    NSMutableArray *rowForInit = [NSMutableArray arrayWithCapacity:columnCount];
    for(int i=0; i<columnCount; i++){
        [rowForInit addObject:[NSNull null]];
    }
    
    NSMutableArray* row;
    //营养素列名集合的行
    row = [NSMutableArray arrayWithArray:rowForInit];
    //row = [NSMutableArray arrayWithCapacity:columnCount];
    //    for(int i=0; i<colIdx_NutrientStart; i++){
    //        row[i] = @"";
    //    }
    for(int i=0; i<nutrientNames.count; i++){
        NSString *nutrientName = nutrientNames[i];
        row[i+colIdx_NutrientStart] = nutrientName;
    }
    [rows addObject:row];
    
    int rowIdx_foodItemStart = 1;
    if (takenFoodAmountDict != nil){
        NSArray* takenFoodIDs = takenFoodAmountDict.allKeys;
        //各种食物具体的量和提供各种营养素的量
        for(int i=0; i<takenFoodIDs.count; i++){
            NSString *foodID = takenFoodIDs[i];
            NSNumber *nmFoodAmount = [takenFoodAmountDict objectForKey:foodID];
            NSDictionary *foodAttrs = [takenFoodAttrDict objectForKey:foodID];
            row = [NSMutableArray arrayWithArray:rowForInit];
            //row = [NSMutableArray arrayWithCapacity:(colIdx_NutrientStart+nutrientNames.count)];
            row[0] = foodID;
            row[1] = foodAttrs[@"CnCaption"];
            row[2] = nmFoodAmount;
            for(int j=0; j<nutrientNames.count;j++){
                NSString *nutrientName = nutrientNames[j];
                NSNumber *nmFoodAttrValue = [foodAttrs objectForKey:nutrientName];
                if (nmFoodAttrValue == nil || nmFoodAttrValue == [NSNull null]){//有warning没事，试过了没问题
                    //do nothing
                }else{
                    double foodSupplyNutrientAmount = [nmFoodAttrValue doubleValue]*[nmFoodAmount doubleValue]/100.0;
                    row[j+colIdx_NutrientStart] = [NSNumber numberWithDouble:foodSupplyNutrientAmount];
                }
            }//for j
            [rows addObject:row];
        }//for i
    }//if (takenFoodAmountDict != nil)
    
    NSArray* recommendFoodIDs = recommendFoodAmountDict.allKeys;
    //各种食物具体的量和提供各种营养素的量
    for(int i=0; i<recommendFoodIDs.count; i++){
        NSString *foodID = recommendFoodIDs[i];
        NSNumber *nmFoodAmount = [recommendFoodAmountDict objectForKey:foodID];
        NSDictionary *foodAttrs = [recommendFoodAttrDict objectForKey:foodID];
        row = [NSMutableArray arrayWithArray:rowForInit];
        //row = [NSMutableArray arrayWithCapacity:(colIdx_NutrientStart+nutrientNames.count)];
        row[0] = foodID;
        row[1] = foodAttrs[@"CnCaption"];
        row[2] = nmFoodAmount;
        for(int j=0; j<nutrientNames.count;j++){
            NSString *nutrientName = nutrientNames[j];
            NSNumber *nmFoodAttrValue = [foodAttrs objectForKey:nutrientName];
            if (nmFoodAttrValue == nil || nmFoodAttrValue == [NSNull null]){//有warning没事，试过了没问题
                //do nothing
            }else{
                double foodSupplyNutrientAmount = [nmFoodAttrValue doubleValue]*[nmFoodAmount doubleValue]/100.0;
                row[j+colIdx_NutrientStart] = [NSNumber numberWithDouble:foodSupplyNutrientAmount];
            }
        }//for j
        [rows addObject:row];
    }//for i
    
    //各种食物提供各种营养素的量的合计，手动算
    NSMutableArray* rowSum = [NSMutableArray arrayWithArray:rowForInit];
    //NSMutableArray* rowSum = [NSMutableArray arrayWithCapacity:(colIdx_NutrientStart+nutrientNames.count)];
    rowSum[0] = @"Sum";
    for(int j=0; j<nutrientNames.count;j++){
        double sumCol = 0.0;
        int foodRowCount = rows.count - rowIdx_foodItemStart;
        for(int i=0; i<foodRowCount; i++){
            NSNumber *nmCell = rows[i+rowIdx_foodItemStart][j+colIdx_NutrientStart] ;
            if (nmCell != [NSNull null])//有warning没事，试过了没问题
                sumCol += [nmCell doubleValue];
        }//for i
        rowSum[j+colIdx_NutrientStart] = [NSNumber numberWithDouble:sumCol];
    }//for j
    [rows addObject:rowSum];
    
    //各种食物提供各种营养素的量的合计，从supply中来
    row = [NSMutableArray arrayWithArray:rowForInit];
    //row = [NSMutableArray arrayWithCapacity:(colIdx_NutrientStart+nutrientNames.count)];
    row[0] = @"Supply";
    for(int i=0; i<nutrientNames.count; i++){
        NSString *nutrientName = nutrientNames[i];
        NSNumber *nmNutrientSupply = [nutrientSupplyDict objectForKey:nutrientName];
        if (nmNutrientSupply != nil || nmNutrientSupply == [NSNull null])
            row[i+colIdx_NutrientStart] = nmNutrientSupply;
        else
            row[i+colIdx_NutrientStart] = [NSNumber numberWithDouble:0.0];
    }
    [rows addObject:row];
    
    //各种营养素DRI
    row = [NSMutableArray arrayWithArray:rowForInit];
    //row = [NSMutableArray arrayWithCapacity:(colIdx_NutrientStart+nutrientNames.count)];
    row[0] = @"DRI";
    for(int i=0; i<nutrientNames.count; i++){
        NSString *nutrientName = nutrientNames[i];
        NSNumber *nmNutrientDRI = [DRIsDict objectForKey:nutrientName];
        if (nmNutrientDRI != nil && nmNutrientDRI != [NSNull null])
            row[i+colIdx_NutrientStart] = nmNutrientDRI;
        else
            row[i+colIdx_NutrientStart] = [NSNumber numberWithDouble:0.0];
    }
    [rows addObject:row];
    
    //各种营养素supply - DRI，超标部分和供应对于需要比例
    NSMutableArray *rowExceed = [NSMutableArray arrayWithArray:rowForInit];
    NSMutableArray *rowSupplyToNeedRatio = [NSMutableArray arrayWithArray:rowForInit];
    rowExceed[0] = @"Exceed=Supply-DRI";
    rowSupplyToNeedRatio[0] = @"Supply to DRI ratio";
    for(int j=0; j<nutrientNames.count; j++){
        NSNumber *nmSupply = rows[rows.count-2][j+colIdx_NutrientStart];
        NSNumber *nmNutrientDRI = rows[rows.count-1][j+colIdx_NutrientStart];
        rowExceed[j+colIdx_NutrientStart] = [NSNumber numberWithDouble:([nmSupply doubleValue]- [nmNutrientDRI doubleValue])] ;
        
        if ([nmNutrientDRI doubleValue] != 0.0){
            rowSupplyToNeedRatio[j+colIdx_NutrientStart] = [NSNumber numberWithDouble:([nmSupply doubleValue] / [nmNutrientDRI doubleValue])];
        }else{
            rowSupplyToNeedRatio[j+colIdx_NutrientStart] = @"N/A";
        }
    }
    [rows addObject:rowExceed];
    [rows addObject:rowSupplyToNeedRatio];
    
    row = [NSMutableArray arrayWithArray:rowForInit];
    row[0] = @"--------";
    [rows addObject:row];
    
    row = [NSMutableArray arrayWithArray:rowForInit];
    row[0] = @"Standard";
    [rows addObject:row];
    
    //各种食物含各种营养素的标准量
    if (takenFoodAmountDict != nil){
        NSArray* takenFoodIDs = takenFoodAmountDict.allKeys;
        for(int i=0; i<takenFoodIDs.count; i++){
            NSString *foodID = takenFoodIDs[i];
            NSDictionary *foodAttrs = [takenFoodAttrDict objectForKey:foodID];
            row = [NSMutableArray arrayWithArray:rowForInit];
            //row = [NSMutableArray arrayWithCapacity:(colIdx_NutrientStart+nutrientNames.count)];
            row[0] = foodID;
            row[1] = foodAttrs[@"CnCaption"];
            row[2] = @"100";
            for(int j=0; j<nutrientNames.count;j++){
                NSString *nutrientName = nutrientNames[j];
                NSNumber *nmFoodAttrValue = [foodAttrs objectForKey:nutrientName];
                if (nmFoodAttrValue == nil || nmFoodAttrValue == [NSNull null]){
                    //do nothing
                }else{
                    row[j+colIdx_NutrientStart] = nmFoodAttrValue;
                }
            }//for j
            [rows addObject:row];
        }//for i
    }
    for(int i=0; i<recommendFoodIDs.count; i++){
        NSString *foodID = recommendFoodIDs[i];
        NSDictionary *foodAttrs = [recommendFoodAttrDict objectForKey:foodID];
        row = [NSMutableArray arrayWithArray:rowForInit];
        //row = [NSMutableArray arrayWithCapacity:(colIdx_NutrientStart+nutrientNames.count)];
        row[0] = foodID;
        row[1] = foodAttrs[@"CnCaption"];
        row[2] = @"100";
        for(int j=0; j<nutrientNames.count;j++){
            NSString *nutrientName = nutrientNames[j];
            NSNumber *nmFoodAttrValue = [foodAttrs objectForKey:nutrientName];
            if (nmFoodAttrValue == nil || nmFoodAttrValue == [NSNull null]){
                //do nothing
            }else{
                row[j+colIdx_NutrientStart] = nmFoodAttrValue;
            }
        }//for j
        [rows addObject:row];
    }//for i
    
    row = [NSMutableArray arrayWithArray:rowForInit];
    row[0] = @"--------";
    [rows addObject:row];
    [rows addObject:userInfos];
    row = [NSMutableArray arrayWithArray:rowForInit];
    row[0] = @"--------";
    [rows addObject:row];

//    for(int i=0; i<foodSupplyNutrientLogs.count; i++){
//    }
    [rows addObjectsFromArray:foodSupplyNutrientLogs];

    
    return rows;
}

-(void) formatCsv_RecommendFoodForEnoughNuitrition: (NSString *)csvFileName withRecommendResult:(NSDictionary*)recmdDict
{
    NSArray * ary2D = [self generateData2D_RecommendFoodForEnoughNuitrition:recmdDict];
    [self convert2DArrayToCsv:csvFileName withData:ary2D];
    [self convert2DArrayToText:ary2D];
}



-(NSString *) convert2DArrayToCsv: (NSString *)csvFileName withData:(NSArray*)ary2D
{
    NSLog(@"convert2DArrayToCsv enter");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *csvFilePath = [documentsDirectory stringByAppendingPathComponent:csvFileName];
    NSLog(@"csvFilePath=%@",csvFilePath);
    
    NSMutableData *writer = [[NSMutableData alloc] init];
    for(int i=0; i<ary2D.count; i++){
        NSArray *ary1D = ary2D[i];
        NSMutableString *rowStr = [NSMutableString stringWithCapacity:10000];
        for(int j=0 ; j<ary1D.count; j++){
            NSObject *cell = ary1D[j];
            NSMutableString *cellStr = [NSMutableString stringWithCapacity:100];
            [cellStr appendString:@"\""];
            
            NSString *s1 = nil;
            if (cell == nil || cell == [NSNull null]){
                s1 = nil;
            }else if ([cell isKindOfClass:[NSString class]]){
                s1 = (NSString*)cell;
            }else if ([cell isKindOfClass:[NSNumber class]]){
                NSNumber *nm = (NSNumber *)cell;
                s1 = [nm stringValue];
            }else{
                s1 = [cell description];
            }
            if (s1 != nil){
                if ([s1 rangeOfString:@"\""].location == NSNotFound){
                    NSString *s2 = [s1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\"\""];
                    [cellStr appendString:s2];
                }else{
                    [cellStr appendString:s1];
                }
            }

            [cellStr appendString:@"\""];
            if (j<ary1D.count-1){
                [cellStr appendString:@","];
            }else{
                [cellStr appendString:@"\n"];
            }
            [rowStr appendString:cellStr];
        }//for j
        
        [writer appendData: [rowStr dataUsingEncoding:NSUTF8StringEncoding] ];
    }//for i
    
    [writer writeToFile:csvFilePath atomically:YES];
    return csvFilePath;
}



-(NSMutableString *) convert2DArrayToText:(NSArray*)ary2D
{
    NSLog(@"convert2DArrayToText enter");
    NSMutableString *rowsStr = [NSMutableString stringWithCapacity:1000*1000];
    for(int i=0; i<ary2D.count; i++){
        NSArray *ary1D = ary2D[i];
        NSMutableString *rowStr = [NSMutableString stringWithCapacity:10000];
        for(int j=0 ; j<ary1D.count; j++){
            NSObject *cell = ary1D[j];
            NSMutableString *cellStr = [NSMutableString stringWithCapacity:100];

            NSString *s1 = nil;
            if (cell == nil || cell == [NSNull null]){
                s1 = nil;
            }else if ([cell isKindOfClass:[NSString class]]){
                s1 = (NSString*)cell;
            }else if ([cell isKindOfClass:[NSNumber class]]){
                NSNumber *nm = (NSNumber *)cell;
                s1 = [nm stringValue];
            }else{
                s1 = [cell description];
            }
            if (s1 != nil){
                [cellStr appendString:s1];
            }
            
            if (j<ary1D.count-1){
                [cellStr appendString:@"\t"];
            }else{
                [cellStr appendString:@"\n"];
            }
            [rowStr appendString:cellStr];
        }//for j
        [rowsStr appendString:rowStr];
    }//for i
    NSLog(@"convert2DArrayToText ret:\n%@",rowsStr);
    return rowsStr;
}




@end
























