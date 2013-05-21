//
//  LZRecommendFood.m
//  nutrition
//
//  Created by Yasofon on 13-5-2.
//  Copyright (c) 2013年 lingzhi mobile. All rights reserved.
//

#import "LZRecommendFood.h"

@implementation LZRecommendFood

/*
 自定义要计算的营养素的清单
 */
+(NSArray*)getCustomNutrients
{
    NSArray *limitedNutrientsCanBeCal = [NSArray arrayWithObjects: @"Vit_A_RAE",@"Vit_C_(mg)",@"Vit_D_(µg)",@"Vit_E_(mg)",@"Vit_B6_(mg)",
                                         @"Calcium_(mg)",@"Iron_(mg)",@"Zinc_(mg)",@"Fiber_TD_(g)",@"Folate_Tot_(µg)", nil];
    return limitedNutrientsCanBeCal;
}



-(NSMutableDictionary *) recommendFoodForEnoughNuitritionWithPreIntake:(NSDictionary*)takenFoodAmountDict andUserInfo:(NSDictionary*)userInfo andOptions:(NSDictionary*)options
{
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
    
    LZDataAccess *da = [LZDataAccess singleton];
    NSDictionary *DRIsDict = [da getStandardDRIs:sex age:age weight:weight height:height activityLevel:activityLevel];
    
    NSMutableDictionary *retDict = [self recommendFoodForEnoughNuitritionWithPreIntake:takenFoodAmountDict andDRIs:DRIsDict andOptions:options];
    NSArray *userInfos = [NSArray arrayWithObjects:@"sex(0 for M)",[NSNumber numberWithInt:sex],@"age",[NSNumber numberWithInt:age],
                          @"weight(kg)",[NSNumber numberWithFloat:weight],@"height(cm)",[NSNumber numberWithFloat:height],@"activityLevel",[NSNumber numberWithInt:activityLevel],nil];
    [retDict setObject:userInfos forKey:@"UserInfo"];
    return retDict;
}

-(NSMutableDictionary *) recommendFood_AbstractPerson:(NSDictionary*)params withDecidedFoods:(NSDictionary*)decidedFoodAmountDict andOptions:(NSDictionary*)options
{
    NSNumber *nm_personCount = [params objectForKey:@"personCount"];
    uint personCount = [nm_personCount unsignedIntValue];
    assert(personCount>0);
    NSNumber *nm_dayCount = [params objectForKey:@"dayCount"];
    uint dayCount = [nm_dayCount unsignedIntValue];
    assert(dayCount>0);
    
    uint multiCount = personCount*dayCount;
    
    LZDataAccess *da = [LZDataAccess singleton];
    NSDictionary *DRIsDict = [da getAbstractPersonDRIs];
    NSArray * nutrientsInDRI = [DRIsDict allKeys];
    for(int i=0; i<nutrientsInDRI.count; i++){
        NSString * nutrient = nutrientsInDRI[i];
        NSNumber * oneDRIval = [DRIsDict objectForKey:nutrient];
        double dval2 = [oneDRIval doubleValue]*multiCount;
        [DRIsDict setValue:[NSNumber numberWithDouble:dval2]  forKey:nutrient];
    }
    
    NSMutableDictionary *retDict = [self recommendFoodForEnoughNuitritionWithPreIntake:decidedFoodAmountDict andDRIs:DRIsDict andOptions:options];
    return retDict;

}

/*
 返回值是一个Dictionary，包含key有：
     "DRI"，对应当前用户的DRI清单，虽然也可以调用方法计算出来。
     "NutrientSupply"，
     "FoodAmount",推荐的食物数量的清单，是一个Dictionary，食物的NDB_No的值是key。
     "FoodAttr"，推荐的食物的详细信息的清单，与"FoodAmount"的食物相同，是一个Dictionary，食物的NDB_No的值是key。
     "TakenFoodAmount"，已经吃了的食物数量的清单，与参数takenFoodAmountDict完全相同。
     "TakenFoodAttr"，已经吃了的食物的详细信息的清单，与"TakenFoodAmount"的食物相同，是一个Dictionary，食物的NDB_No的值是key。
     "NutrientLackWhenInitialTaken"，其数据是记录初始摄入食物后还缺哪些营养素，key是营养素名，value是缺乏的值。不缺乏或超标时为0值。与DRI相除后可以得到缺乏比例。
         至于mockup上是供给比例，可以再改再提供。
     "limitedNutrientDictCanBeCal",是一个自定义的营养素清单，目前是一个dict，key和value都是营养素名。必要时可以再给出一个数组。
 */
-(NSMutableDictionary *) recommendFoodForEnoughNuitritionWithPreIntake:(NSDictionary*)takenFoodAmountDict andDRIs:(NSDictionary*)DRIsDict andOptions:(NSDictionary*)options
{

    BOOL notAllowSameFood = TRUE;//这是一个策略标志位，偏好食物的多样化的标志位，即当选取食物补充营养时，优先选取以前没有用过的食物。
    BOOL randomSelectFood = TRUE;
    int randomRangeSelectFood = 0;//配合randomSelectFood，用于限制随机范围，0表示不限制, >0表示优先选择其范围内的东西
    BOOL needLimitNutrients = TRUE;//是否要根据需求限制计算的营养素集合
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    
    uint randSeed = arc4random();
    NSLog(@"in recommendFoodForEnoughNuitritionWithPreIntake, randSeed=%d",randSeed);//如果某次情况需要调试，通过这个seed的设置应该可以重复当时情况
    
    if(options != nil){
        NSNumber *nmFlag_notAllowSameFood = [options objectForKey:@"notAllowSameFood"];
        if (nmFlag_notAllowSameFood != nil)
            notAllowSameFood = [nmFlag_notAllowSameFood boolValue];
        
        NSNumber *nmFlag_randomSelectFood = [options objectForKey:@"randomSelectFood"];
        if (nmFlag_randomSelectFood != nil)
            randomSelectFood = [nmFlag_randomSelectFood boolValue];
        
        NSNumber *nm_randomRangeSelectFood = [options objectForKey:@"randomRangeSelectFood"];
        if (nm_randomRangeSelectFood != nil)
            randomRangeSelectFood = [nm_randomRangeSelectFood intValue];
        
        NSNumber *nm_randSeed = [options objectForKey:@"randSeed"];
        if (nm_randSeed != nil)
            randSeed = [nm_randSeed unsignedIntValue];
        
        NSNumber *nmFlag_needLimitNutrients = [options objectForKey:@"needLimitNutrients"];
        if (nmFlag_needLimitNutrients != nil)
            needLimitNutrients = [nmFlag_needLimitNutrients boolValue];
        
        NSNumber *nmFlag_needUseFoodLimitTableWhenCal = [options objectForKey:@"needUseFoodLimitTableWhenCal"];
        if (nmFlag_needUseFoodLimitTableWhenCal != nil)
            needUseFoodLimitTableWhenCal = [nmFlag_needUseFoodLimitTableWhenCal boolValue];
    }
    
    srandom(randSeed);
    
    int upperLimit = 1000; // 1000 g
    int topN = 20;
    NSString *colName_NO = @"NDB_No";
    double nearZero = 0.0000001;
    
    
    //这里列出的营养素有专门而简单的食物补充，通过我们预置的那些食物反而不好补充
    NSDictionary *nutrientsNotFromCustomFood =[ NSDictionary dictionaryWithObjectsAndKeys:@"1",@"Water_(g)",@"1",@"Sodium_(mg)", nil];
    //这里的营养素最后再计算补充
    //    Choline_Tot_ (mg) 胆碱 最少需要187g的蛋来补充
    //    Vit_D_(µg) 只有鲤鱼等才有效补充
    NSMutableArray *lastSupplyCalNutrients = [NSMutableArray arrayWithObjects:@"Vit_D_(µg)",@"Choline_Tot_ (mg)", @"Carbohydrt_(g)",@"Energ_Kcal", nil];
    //这是需求中规定只计算哪些营养素
//    NSArray *limitedNutrientsCanBeCal = [NSArray arrayWithObjects: @"Vit_A_RAE",@"Vit_C_(mg)",@"Vit_D_(µg)",@"Vit_E_(mg)",@"Vit_B6_(mg)",
//                                         @"Calcium_(mg)",@"Iron_(mg)",@"Zinc_(mg)",@"Fiber_TD_(g)",@"Folate_Tot_(µg)", nil];
    NSArray *limitedNutrientsCanBeCal = [self.class getCustomNutrients];
    NSDictionary *limitedNutrientDictCanBeCal = [NSDictionary dictionaryWithObjects:limitedNutrientsCanBeCal forKeys:limitedNutrientsCanBeCal];
    
    LZDataAccess *da = [LZDataAccess singleton];
    
    NSArray *takenFoodIDs = nil;
    if (takenFoodAmountDict!=nil && takenFoodAmountDict.count>0)
        takenFoodIDs = [takenFoodAmountDict allKeys];
    //NSArray *takenFoodAttrAry = [da getFoodByIds:takenFoodIDs];
    NSArray *takenFoodAttrAry = [da getFoodAttributesByIds:takenFoodIDs];
    
    NSMutableDictionary *recommendFoodAmountDict = [NSMutableDictionary dictionaryWithCapacity:100];//key is NDB_No
    NSMutableDictionary *recommendFoodAttrDict = [NSMutableDictionary dictionaryWithCapacity:100];//key is NDB_No
    NSMutableDictionary *foodSupplyAmountDict = [NSMutableDictionary dictionaryWithDictionary:takenFoodAmountDict];//包括takenFoodAmountDict 和 recommendFoodAmountDict。与nutrientSupplyDict对应。
    NSMutableDictionary *nutrientSupplyDict = [NSMutableDictionary dictionaryWithDictionary:DRIsDict];
    NSArray *nutrientNames1 = [nutrientSupplyDict allKeys];
    for (int i=0; i<nutrientNames1.count; i++) {//初始化supply集合
        [nutrientSupplyDict setObject:[NSNumber numberWithDouble:0.0] forKey:nutrientNames1[i]];
    }
    NSMutableDictionary *nutrientNameDictToCal = [NSMutableDictionary dictionaryWithDictionary:nutrientSupplyDict];
    for (int i=0; i<nutrientNames1.count; i++) {
        NSString *nutrientName = nutrientNames1[i];
        NSNumber *totalNeed = DRIsDict[nutrientName];
        if ([totalNeed doubleValue]==0.0){//需求量为0的就不用计算了
            //[nutrientSupplyDict removeObjectForKey:nutrientName];
            [nutrientNameDictToCal removeObjectForKey:nutrientName];
        }
    }
    for(int i=0; i<lastSupplyCalNutrients.count; i++){//lastSupplyCalNutrients中的营养素在算完nutrientNameDictToCal所含的那些营养素之后再算
        NSString *nutrientName = lastSupplyCalNutrients[i];
        [nutrientNameDictToCal removeObjectForKey:nutrientName];
    }
    
    NSMutableDictionary *dictNutrientLackWhenInitialTaken = [NSMutableDictionary dictionaryWithDictionary:DRIsDict];//主要是记录初始摄入食物后还缺哪些营养素
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
        
        //计算已经吃过给定食物还缺的各营养素的量，用于显示
        NSArray *nutrientsDRI = [DRIsDict allKeys];
        for(int i=0; i<nutrientsDRI.count; i++){
            NSString *nutrientName = nutrientsDRI[i];
            NSNumber *nmNutrientDRIvalue = [DRIsDict objectForKey:nutrientName];
            double nutrientAlreadyTakenVal = 0.0;
            NSNumber *nmInitialSupply = [nutrientSupplyDict objectForKey:nutrientName];
            if (nmInitialSupply != nil){
                nutrientAlreadyTakenVal = [nmInitialSupply doubleValue];
            }
            double nutrientLackVal = [nmNutrientDRIvalue doubleValue] - nutrientAlreadyTakenVal;
            if (nutrientLackVal < 0)
                nutrientLackVal = 0;
            [dictNutrientLackWhenInitialTaken setObject:[NSNumber numberWithDouble:nutrientLackVal] forKey:nutrientName];
        }
        
    }//if (takenFoodAttrAry != nil )
    
    NSMutableArray* foodSupplyNutrientSeqs = [NSMutableArray arrayWithCapacity:100];
    
    //对每个还需补足的营养素进行计算
    //while (nutrientNameDictToCal.allKeys.count>0) {
    while (TRUE) {
        NSString *nutrientNameToCal = nil;
        if (nutrientNameDictToCal.allKeys.count>0){
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
            nutrientNameToCal = maxLackNutrientName;
            if (nutrientNameToCal!=nil){
                [nutrientNameDictToCal removeObjectForKey:nutrientNameToCal];//已经取到待计算的营养素，可以从待计算集合中去掉了
            }
        }
        if (nutrientNameToCal == nil){
            //如果从前面找不到最需要补的营养素，说明nutrientNameDictToCal中的营养素已经都补够了。现在该计算lastSupplyCalNutrients中的营养素了。
            if (lastSupplyCalNutrients.count > 0){
                nutrientNameToCal = lastSupplyCalNutrients[0];
                [lastSupplyCalNutrients removeObjectAtIndex:0];
                NSNumber *nmSupplied = nutrientSupplyDict[nutrientNameToCal];
                NSNumber *nmTotalNeed = DRIsDict[nutrientNameToCal];
                double toAdd = [nmTotalNeed doubleValue]-[nmSupplied doubleValue];
                if (toAdd <= nearZero){
                    //可能由于在计算过程中，已有的或已选的食物已经把这种营养素的需要量给补够了。这样的营养素就可以跳过不计算了.
                    continue;
                }
            }
        }
        
        if (nutrientNameToCal == nil){//彻底没有需要计算的营养素了
            break;
        }else{
            if (needLimitNutrients && [limitedNutrientDictCanBeCal objectForKey:nutrientNameToCal]==nil){
                //对需求中限制可计算营养素集合以支持。不在这个集合中不计算。
                continue;
            }
        }
        //当前有需要计算的营养素
        NSNumber *nmSupplied = nutrientSupplyDict[nutrientNameToCal];
        NSNumber *nmTotalNeed = DRIsDict[nutrientNameToCal];
        double toAddForNutrient = [nmTotalNeed doubleValue]-[nmSupplied doubleValue];
        assert(toAddForNutrient>nearZero);
        
        NSArray * foodsToSupplyOneNutrient = [da getRichNutritionFood:nutrientNameToCal andTopN:topN];//找一些对于这种营养素含量最高的食物
        NSMutableArray *normalFoodsToSupplyOneNutrient = [NSMutableArray arrayWithArray:foodsToSupplyOneNutrient];
        NSMutableArray *alreadyUsedFoodsWhenOtherNutrients = [NSMutableArray arrayWithCapacity:foodsToSupplyOneNutrient.count];
        //先根据食物是否用过和多样性标识把补当前营养素的食物分为两类
        for(int i=normalFoodsToSupplyOneNutrient.count-1; i>=0; i--){
            NSDictionary *food = foodsToSupplyOneNutrient[i];
            NSString *foodNO = food[colName_NO];
            if ( [foodSupplyAmountDict objectForKey:foodNO]!=nil ){//已经用过这种食物了
                if (notAllowSameFood){//需要食物多样化的话，这里就不再用这种食物了
                    //[alreadyUsedFoodsWhenOtherNutrients addObject:food];
                    [alreadyUsedFoodsWhenOtherNutrients insertObject:food atIndex:0];
                    [normalFoodsToSupplyOneNutrient removeObjectAtIndex:i];//但如果实在补不齐，还可以再用它
                }
            }
        }
        
        while (TRUE) {//对每个食物计算补当前营养素的情况
            //for(int i=0; i<foodsToSupplyOneNutrient.count; i++){
            //NSDictionary *food = foodsToSupplyOneNutrient[i];
            NSDictionary *food = nil;
            if (normalFoodsToSupplyOneNutrient.count > 0){
                if (!randomSelectFood){
                    food = normalFoodsToSupplyOneNutrient[0];
                    [normalFoodsToSupplyOneNutrient removeObjectAtIndex:0];
                }else{
                    int idx = 0;
                    if (randomRangeSelectFood > 0){
                        idx = random() % randomRangeSelectFood;
                        idx = idx % normalFoodsToSupplyOneNutrient.count;//avoid index overflow
                    }else{
                        idx = random() % normalFoodsToSupplyOneNutrient.count;
                    }
                    
                    food = normalFoodsToSupplyOneNutrient[idx];
                    [normalFoodsToSupplyOneNutrient removeObjectAtIndex:idx];
                }
            }
            if (food == nil){
                if (alreadyUsedFoodsWhenOtherNutrients.count>0){
                    food = alreadyUsedFoodsWhenOtherNutrients[0];
                    [alreadyUsedFoodsWhenOtherNutrients removeObjectAtIndex:0];
                }
            }
            if (food == nil){
                break;//没有可以补充这种营养素的食物了，跳出循环
            }
            //取到一个food，来计算补这种营养素，以及顺便补其他营养素
            NSString *foodNO = food[colName_NO];
            if ( [foodSupplyAmountDict objectForKey:foodNO]!=nil ){//已经用过这种食物了
                NSNumber *nmIntakeFoodAmount = [foodSupplyAmountDict objectForKey:foodNO];
                if (upperLimit - [nmIntakeFoodAmount doubleValue] < nearZero){//这个食物已经用得够多到上限量了，换下一个来试
                    continue;
                }
            }
            
            NSNumber* nmNutrientContentOfFood = [food objectForKey:nutrientNameToCal];
            if ([nmNutrientContentOfFood doubleValue]==0.0){
                //这个营养素的目前计算到的含其最多的食物的含量已经为0，没法补齐这个营养素了.换下一个吧。
                //虽然食物的营养素含量不太可能为0，但以防万一
                continue;
            }
            
            double toAddForFood = toAddForNutrient / [nmNutrientContentOfFood doubleValue] * 100.0;//单位是g
            NSNumber *nmFoodUpperLimit = food[@"Upper_Limit(g)"];
            double dFoodUpperLimit = 0;
            if (nmFoodUpperLimit != nil && nmFoodUpperLimit != [NSNull null]){
                dFoodUpperLimit = [nmFoodUpperLimit doubleValue];
            }
            if (toAddForFood - upperLimit > nearZero){//要补的食物的量过多，当食物所含该种营养素的量太少时发生。这时只取到上限值，再找其他食物来补充。
                toAddForFood = upperLimit;
            }
            if (needUseFoodLimitTableWhenCal && dFoodUpperLimit > 0 && toAddForFood - dFoodUpperLimit > nearZero){
                toAddForFood = dFoodUpperLimit;
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
            [LZUtility addDoubleToDictionaryItem:toAddForFood withDictionary:recommendFoodAmountDict andKey:foodNO];//推荐量累加
            [recommendFoodAttrDict setObject:food forKey:foodNO];
            [LZUtility addDoubleToDictionaryItem:toAddForFood withDictionary:foodSupplyAmountDict andKey:foodNO];//供给量累加
            
            NSMutableArray *foodSupplyNutrientSeq = [NSMutableArray arrayWithCapacity:5];
            [foodSupplyNutrientSeq addObject:nutrientNameToCal];
            [foodSupplyNutrientSeq addObject:foodNO];
            [foodSupplyNutrientSeq addObject:[NSNumber numberWithDouble:toAddForFood]];
            [foodSupplyNutrientSeq addObject:[food objectForKey:@"CnCaption"]];
            [foodSupplyNutrientSeq addObject:[food objectForKey:@"Shrt_Desc"]];
            [foodSupplyNutrientSeqs addObject:foodSupplyNutrientSeq];
            
            if (toAddForNutrient > nearZero){
                //继续下一个循环取食物来补足当前营养素。
                //虽然有种策略是由于补充了这种食物后，当前营养素不一定是最缺的，可以计算下一个最缺的营养素而不必非要把当前的营养素补充完。不过由于这里的循环结构会导致当前营养素已经去掉，这种策略目前不适用。
            }else{
                //这个营养素已经补足，可以到外层循环计算下一个营养素了
                break;
            }
            //}//for i
        }//对每个食物计算补当前营养素的情况
    }//while (nutrientNameDictToCal.allKeys.count>0)
    
    NSLog(@"recommendFoodForEnoughNuitrition foodSupplyNutrientSeqs=\n%@",foodSupplyNutrientSeqs);
    NSLog(@"recommendFoodForEnoughNuitrition nutrientSupplyDict=\n%@, recommendFoodAmountDict=\n%@",nutrientSupplyDict,recommendFoodAmountDict);
    
    NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithCapacity:5];
    [retDict setObject:DRIsDict forKey:@"DRI"];//nutrient name as key, also column name
    [retDict setObject:nutrientSupplyDict forKey:@"NutrientSupply"];//nutrient name as key, also column name
    [retDict setObject:recommendFoodAmountDict forKey:@"FoodAmount"];//food NO as key
    [retDict setObject:recommendFoodAttrDict forKey:@"FoodAttr"];//food NO as key
    
    [retDict setObject:dictNutrientLackWhenInitialTaken forKey:@"NutrientLackWhenInitialTaken"];
    if (needLimitNutrients){
        [retDict setObject:limitedNutrientDictCanBeCal forKey:@"limitedNutrientDictCanBeCal"];
    }
    
    [retDict setObject:options forKey:@"optionsDict"];
    [retDict setObject:foodSupplyNutrientSeqs forKey:@"foodSupplyNutrientSeqs"];//2D array
    
    NSArray *otherInfos = [NSArray arrayWithObjects:@"randSeed",[NSNumber numberWithUnsignedInt:randSeed],
                           @"randomRangeSelectFood",[NSNumber numberWithInt:randomRangeSelectFood],
                           @"randomSelectFood",[NSNumber numberWithBool:randomSelectFood],
                           @"notAllowSameFood",[NSNumber numberWithBool:notAllowSameFood],
                           @"needLimitNutrients",[NSNumber numberWithBool:needLimitNutrients],
                           @"needUseFoodLimitTableWhenCal",[NSNumber numberWithBool:needUseFoodLimitTableWhenCal],
                           nil];
    [retDict setObject:otherInfos forKey:@"OtherInfo"];
    
    if (takenFoodAmountDict != nil && takenFoodAmountDict.count>0){
        [retDict setObject:takenFoodAmountDict forKey:@"TakenFoodAmount"];//food NO as key
        [retDict setObject:takenFoodAttrDict forKey:@"TakenFoodAttr"];//food NO as key
    }
    return retDict;
}




//---------------------------------------
-(NSMutableDictionary *) recommendFood2WithPreIntake:(NSDictionary*)takenFoodAmountDict andUserInfo:(NSDictionary*)userInfo andParams:(NSDictionary*)params andOptions:(NSDictionary*)options
{
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
    
    LZDataAccess *da = [LZDataAccess singleton];
    NSDictionary *DRIsDict = [da getStandardDRIs:sex age:age weight:weight height:height activityLevel:activityLevel];
    
    NSMutableDictionary *retDict = [self recommendFood2WithPreIntake:takenFoodAmountDict andDRIs:DRIsDict andParams:params andOptions:options];
    NSArray *userInfos = [NSArray arrayWithObjects:@"sex(0 for M)",[NSNumber numberWithInt:sex],@"age",[NSNumber numberWithInt:age],
                          @"weight(kg)",[NSNumber numberWithFloat:weight],@"height(cm)",[NSNumber numberWithFloat:height],@"activityLevel",[NSNumber numberWithInt:activityLevel],nil];
    [retDict setObject:userInfos forKey:@"UserInfo"];
    return retDict;
}
/*
 与recommendFoodForEnoughNuitritionWithPreIntake相比，补营养素的计算策略改为不是一定非要给一种补够，而是补了一定量再计算下一个最缺的。
 */

-(NSMutableDictionary *) recommendFood2WithPreIntake:(NSDictionary*)takenFoodAmountDict andDRIs:(NSDictionary*)DRIsDict andParams:(NSDictionary*)params andOptions:(NSDictionary*)options
{
    assert(params != nil && params.count > 0);
    int personDayCount = 1;
    NSNumber *nm_personDayCount = [params objectForKey:@"personDayCount"];
    assert(nm_personDayCount != nil);
    personDayCount = [nm_personDayCount intValue];
    assert(personDayCount>=1);

    BOOL notAllowSameFood = TRUE;//这是一个策略标志位，偏好食物的多样化的标志位，即当选取食物补充营养时，优先选取以前没有用过的食物。
    BOOL randomSelectFood = TRUE;
    int randomRangeSelectFood = 0;//配合randomSelectFood，用于限制随机范围，0表示不限制, >0表示优先选择其范围内的东西
    BOOL needLimitNutrients = TRUE;//是否要根据需求限制计算的营养素集合
    BOOL needUseFoodLimitTableWhenCal = TRUE;
    
    uint randSeed = arc4random();
    NSLog(@"in recommendFoodForEnoughNuitritionWithPreIntake, randSeed=%d",randSeed);//如果某次情况需要调试，通过这个seed的设置应该可以重复当时情况
    
    if(options != nil){
        NSNumber *nmFlag_notAllowSameFood = [options objectForKey:@"notAllowSameFood"];
        if (nmFlag_notAllowSameFood != nil)
            notAllowSameFood = [nmFlag_notAllowSameFood boolValue];
        
        NSNumber *nmFlag_randomSelectFood = [options objectForKey:@"randomSelectFood"];
        if (nmFlag_randomSelectFood != nil)
            randomSelectFood = [nmFlag_randomSelectFood boolValue];
        
        NSNumber *nm_randomRangeSelectFood = [options objectForKey:@"randomRangeSelectFood"];
        if (nm_randomRangeSelectFood != nil)
            randomRangeSelectFood = [nm_randomRangeSelectFood intValue];
        
        NSNumber *nm_randSeed = [options objectForKey:@"randSeed"];
        if (nm_randSeed != nil)
            randSeed = [nm_randSeed unsignedIntValue];
        
        NSNumber *nmFlag_needLimitNutrients = [options objectForKey:@"needLimitNutrients"];
        if (nmFlag_needLimitNutrients != nil)
            needLimitNutrients = [nmFlag_needLimitNutrients boolValue];
        
        NSNumber *nmFlag_needUseFoodLimitTableWhenCal = [options objectForKey:@"needUseFoodLimitTableWhenCal"];
        if (nmFlag_needUseFoodLimitTableWhenCal != nil)
            needUseFoodLimitTableWhenCal = [nmFlag_needUseFoodLimitTableWhenCal boolValue];
    }
    
    srandom(randSeed);
    
    int upperLimit = 1000; // 1000 g
    int topN = 20;
    NSString *colName_NO = @"NDB_No";
    double nearZero = 0.0000001;
    
    LZDataAccess *da = [LZDataAccess singleton];
    
    //这里列出的营养素有专门而简单的食物补充，通过我们预置的那些食物反而不好补充
    NSArray *nutrientArrayNotCal =[NSArray arrayWithObjects:@"Water_(g)", @"Sodium_(mg)", nil];
    NSSet *nutrientSetNotCal = [NSSet setWithArray:nutrientArrayNotCal];
    
    //这里的营养素最后再计算补充
    //    Choline_Tot_ (mg) 胆碱 最少需要187g的蛋来补充
    //    Vit_D_(µg) 只有鲤鱼等才有效补充
    NSMutableArray *nutrientArrayLastCal = [NSMutableArray arrayWithObjects:@"Vit_D_(µg)",@"Choline_Tot_ (mg)", @"Carbohydrt_(g)",@"Energ_Kcal", nil];
    
    //这是需求中规定只计算哪些营养素
//    NSArray *limitedNutrientsCanBeCal = [NSArray arrayWithObjects: @"Vit_A_RAE",@"Vit_C_(mg)",@"Vit_D_(µg)",@"Vit_E_(mg)",@"Vit_B6_(mg)",
//                                         @"Calcium_(mg)",@"Iron_(mg)",@"Zinc_(mg)",@"Fiber_TD_(g)",@"Folate_Tot_(µg)", nil];
    NSArray *limitedNutrientsCanBeCal = [self.class getCustomNutrients];
    NSSet *limitedNutrientSetCanBeCal = [NSSet setWithArray:limitedNutrientsCanBeCal];
    NSDictionary *limitedNutrientDictCanBeCal = [NSDictionary dictionaryWithObjects:limitedNutrientsCanBeCal forKeys:limitedNutrientsCanBeCal];
    
    //这是一个营养素的全集
    NSArray* nutrientNamesOrdered = [NSArray arrayWithObjects:@"Energ_Kcal",@"Carbohydrt_(g)",@"Lipid_Tot_(g)",@"Protein_(g)",
                                     @"Vit_A_RAE",@"Vit_C_(mg)",@"Vit_D_(µg)",@"Vit_E_(mg)",@"Vit_K_(µg)",
                                     @"Thiamin_(mg)",@"Riboflavin_(mg)",@"Niacin_(mg)",@"Vit_B6_(mg)",@"Folate_Tot_(µg)",
                                     @"Vit_B12_(µg)",@"Panto_Acid_mg)",
                                     @"Calcium_(mg)",@"Copper_(mg)",@"Iron_(mg)",@"Magnesium_(mg)",@"Manganese_(mg)",
                                     @"Phosphorus_(mg)",@"Selenium_(µg)",@"Zinc_(mg)",@"Potassium_(mg)",@"Sodium_(mg)",
                                     @"Water_(g)",@"Fiber_TD_(g)",@"Choline_Tot_ (mg)",@"Cholestrl_(mg)", nil];
    NSSet *nutrientNameSetOrdered = [NSSet setWithArray:nutrientNamesOrdered];
    
    //这里先根据各种过滤限制条件算出需要纳入计算的营养素，再对之进行顺序方面的设置
    NSMutableSet *nutrientSetToCal = [NSMutableSet setWithArray:DRIsDict.allKeys];//以DRI中所含营养素为初始值进行过滤
    [nutrientSetToCal minusSet:nutrientSetNotCal];
    if (needLimitNutrients){
        [nutrientSetToCal minusSet:limitedNutrientSetCanBeCal];
    }
    assert(nutrientSetToCal.count>0);
    assert([nutrientSetToCal isSubsetOfSet:nutrientNameSetOrdered]);//确认那个手工得到的全集还有效

    //对nutrientArrayLastCal也过滤一下
    nutrientArrayLastCal = [LZUtility arrayIntersectSet_withArray:nutrientArrayLastCal andSet:nutrientSetToCal];
    NSSet *nutrientSetLastCal = [NSSet setWithArray:nutrientArrayLastCal];
    
    // nutrientNamesOrdered 与 nutrientSetToCal 取交集得到保持顺序的nutrient array ToCal，从这个结果还要把 nutrientArrayLastCal 中的取出挪到最后。
    [nutrientSetToCal minusSet:nutrientSetLastCal];// 先取个小交集，从 nutrientSetToCal 减掉 nutrientArrayLastCal 的，
    NSMutableArray *nutrientNameAryToCal = [LZUtility arrayIntersectSet_withArray:[NSMutableArray arrayWithArray:nutrientNamesOrdered] andSet:nutrientSetToCal];
    [nutrientNameAryToCal addObjectsFromArray:nutrientArrayLastCal];//这里再把nutrientArrayLastCal的补回来
    //到这里 nutrientNameAryToCal 中的值是既经过过滤，又经过排序的了。可以用于下面的计算了
    assert(nutrientNameAryToCal.count>0);
    
    
    NSArray *takenFoodIDs = nil;
    if (takenFoodAmountDict!=nil && takenFoodAmountDict.count>0)
        takenFoodIDs = [takenFoodAmountDict allKeys];
    NSArray *takenFoodAttrAry = [da getFoodAttributesByIds:takenFoodIDs];
    
    NSMutableDictionary *recommendFoodAmountDict = [NSMutableDictionary dictionaryWithCapacity:100];//key is NDB_No
    NSMutableDictionary *recommendFoodAttrDict = [NSMutableDictionary dictionaryWithCapacity:100];//key is NDB_No
    NSMutableDictionary *foodSupplyAmountDict = [NSMutableDictionary dictionaryWithDictionary:takenFoodAmountDict];//包括takenFoodAmountDict 和 recommendFoodAmountDict。与nutrientSupplyDict对应。
    NSMutableDictionary *nutrientSupplyDict = [NSMutableDictionary dictionaryWithDictionary:DRIsDict];
    NSArray *nutrientNames1 = [nutrientSupplyDict allKeys];
    for (int i=0; i<nutrientNames1.count; i++) {//初始化supply集合
        [nutrientSupplyDict setObject:[NSNumber numberWithDouble:0.0] forKey:nutrientNames1[i]];
    }
    
    NSMutableDictionary *dictNutrientLackWhenInitialTaken = [NSMutableDictionary dictionaryWithDictionary:DRIsDict];//主要是记录初始摄入食物后还缺哪些营养素
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
        
        //计算已经吃过给定食物还缺的各营养素的量，用于显示
        NSArray *nutrientsDRI = [DRIsDict allKeys];
        for(int i=0; i<nutrientsDRI.count; i++){
            NSString *nutrientName = nutrientsDRI[i];
            NSNumber *nmNutrientDRIvalue = [DRIsDict objectForKey:nutrientName];
            double nutrientAlreadyTakenVal = 0.0;
            NSNumber *nmInitialSupply = [nutrientSupplyDict objectForKey:nutrientName];
            if (nmInitialSupply != nil){
                nutrientAlreadyTakenVal = [nmInitialSupply doubleValue];
            }
            double nutrientLackVal = [nmNutrientDRIvalue doubleValue] - nutrientAlreadyTakenVal;
            if (nutrientLackVal < 0)
                nutrientLackVal = 0;
            [dictNutrientLackWhenInitialTaken setObject:[NSNumber numberWithDouble:nutrientLackVal] forKey:nutrientName];
        }
        
    }//if (takenFoodAttrAry != nil )
    

    
    NSMutableArray* foodSupplyNutrientSeqs = [NSMutableArray arrayWithCapacity:100];
    //对每个还需补足的营养素进行计算
    while (nutrientNameAryToCal.count > 0) {
        for(int i=nutrientNameAryToCal.count-1; i>=0; i--){//先去掉已经补满的
            NSString *nutrientName = nutrientNameAryToCal[i];
            NSNumber *nmSupplied = nutrientSupplyDict[nutrientName];
            NSNumber *nmTotalNeed1Unit = DRIsDict[nutrientName];
            double toAdd = [nmTotalNeed1Unit doubleValue]*personDayCount - [nmSupplied doubleValue];
            if (toAdd <= nearZero){
                [nutrientNameAryToCal removeObjectAtIndex:i];
            }
        }
        if (nutrientNameAryToCal.count == 0){
            break;
        }
        
        NSString *nutrientNameToCal = nil;
        int idxOfNutrientNameToCal = 0;
        double maxNutrientLackRatio = nearZero;
        NSString *maxLackNutrientName = nil;
        for(int i=0; i<nutrientNameAryToCal.count; i++){//先找出最需要补的营养素,即缺乏比例最大的
            NSString *nutrientName = nutrientNameAryToCal[i];
            NSNumber *nmSupplied = nutrientSupplyDict[nutrientName];
            NSNumber *nmTotalNeed1Unit = DRIsDict[nutrientName];
            double toAdd = [nmTotalNeed1Unit doubleValue]*personDayCount-[nmSupplied doubleValue];
            assert(toAdd > nearZero);
            double lackRatio = toAdd/([nmTotalNeed1Unit doubleValue]*personDayCount);
            if (lackRatio > maxNutrientLackRatio){
                maxLackNutrientName = nutrientName;
                maxNutrientLackRatio = lackRatio;
                idxOfNutrientNameToCal = i;
            }
        }
        nutrientNameToCal = maxLackNutrientName;//已经取到待计算的营养素，但不从待计算集合中去掉，因为一次计算未必能够补充满这种营养素，由于有上限表之类的限制。并且注意下次找到的最需补充的营养素不一定是现在这个了。

        //当前有需要计算的营养素
        NSNumber *nmSupplied = nutrientSupplyDict[nutrientNameToCal];
        NSNumber *nmTotalNeed1Unit = DRIsDict[nutrientNameToCal];
        double toAddForNutrient = [nmTotalNeed1Unit doubleValue]*personDayCount-[nmSupplied doubleValue];
        assert(toAddForNutrient>nearZero);
        
        NSArray * foodsToSupplyOneNutrient = [da getRichNutritionFood:nutrientNameToCal andTopN:topN];//找一些对于这种营养素含量最高的食物
        NSMutableArray *normalFoodsToSupplyOneNutrient = [NSMutableArray arrayWithArray:foodsToSupplyOneNutrient];
        NSMutableArray *alreadyUsedFoodsWhenOtherNutrients = [NSMutableArray array];
        //先根据食物是否用过和多样性标识把补当前营养素的食物分为两类
        for(int i=normalFoodsToSupplyOneNutrient.count-1; i>=0; i--){
            NSDictionary *food = foodsToSupplyOneNutrient[i];
            NSString *foodNO = food[colName_NO];
            if ( [foodSupplyAmountDict objectForKey:foodNO]!=nil ){//已经用过这种食物了
                if (notAllowSameFood){//需要食物多样化的话，这里就不再用这种食物了
                    //[alreadyUsedFoodsWhenOtherNutrients addObject:food];
                    [alreadyUsedFoodsWhenOtherNutrients insertObject:food atIndex:0];
                    [normalFoodsToSupplyOneNutrient removeObjectAtIndex:i];//但如果实在补不齐，还可以再用它
                }
            }
        }
        
        //while (TRUE) {////选取一个食物，来补当前营养素
            NSDictionary *food = nil;
            
            if (normalFoodsToSupplyOneNutrient.count > 0){
                if (!randomSelectFood){
                    //to use RichLevel todo
                    food = normalFoodsToSupplyOneNutrient[0];
                }else{
                    int idx = 0;
                    if (randomRangeSelectFood > 0){
                        idx = random() % randomRangeSelectFood;
                        idx = idx % normalFoodsToSupplyOneNutrient.count;//avoid index overflow
                    }else{
                        idx = random() % normalFoodsToSupplyOneNutrient.count;
                    }
                    food = normalFoodsToSupplyOneNutrient[idx];
                }
            }
            if (food == nil){
                while(alreadyUsedFoodsWhenOtherNutrients.count>0){
                    int idx = 0;
                    if (randomRangeSelectFood > 0){
                        idx = random() % randomRangeSelectFood;
                        idx = idx % alreadyUsedFoodsWhenOtherNutrients.count;//avoid index overflow
                    }else{
                        idx = 0;
                    }
                    NSDictionary *food2 = alreadyUsedFoodsWhenOtherNutrients[idx];
                    [alreadyUsedFoodsWhenOtherNutrients removeObjectAtIndex:idx];
                    
                    NSString *foodNO = food2[colName_NO];
                    NSNumber *nmIntakeFoodAmount = [foodSupplyAmountDict objectForKey:foodNO];
                    if (upperLimit*daylight - [nmIntakeFoodAmount doubleValue] <= nearZero){//这个食物已经用得够多到绝对上限量了，换下一个来试
                        continue;
                    }
                    if (needUseFoodLimitTableWhenCal){
                        NSNumber *nmFoodUpperLimit = food[@"Upper_Limit(g)"];
                        double dFoodUpperLimit = 0;
                        if (nmFoodUpperLimit != nil && nmFoodUpperLimit != [NSNull null]){
                            dFoodUpperLimit = [nmFoodUpperLimit doubleValue];
                        }
                        if (dFoodUpperLimit > 0 && dFoodUpperLimit*daylight - [nmIntakeFoodAmount doubleValue] <= nearZero){//这个食物已经用得够多到自定义上限量了，换下一个来试
                            continue;
                        }
                    }
                    food = food2;
                    break;
                }//while(alreadyUsedFoodsWhenOtherNutrients.count>0)
            }
            if (food==nil){//这个营养素把所有能补的食物都用到上限了，不能再对它进行计算了
                [nutrientNameAryToCal removeObjectAtIndex:idxOfNutrientNameToCal];
                continue;//对于第1层while
                //break;//对于第2层while
            }

            //取到一个food，来计算补这种营养素，以及顺便补其他营养素
            NSString *foodNO = food[colName_NO];

            NSNumber* nmNutrientContentOfFood = [food objectForKey:nutrientNameToCal];
            assert([nmNutrientContentOfFood doubleValue]>0.0);
//            if ([nmNutrientContentOfFood doubleValue]==0.0){
//                //这个营养素的目前计算到的含其最多的食物的含量已经为0，没法补齐这个营养素了.换下一个吧。
//                //虽然食物的营养素含量不太可能为0，但以防万一
//                continue;
//            }
        
            double toAddForFood = toAddForNutrient / [nmNutrientContentOfFood doubleValue] * 100.0;//单位是g
            if (toAddForFood - upperLimit > nearZero){//要补的食物的量过多，当食物所含该种营养素的量太少时发生。这时这次只取到上限值，再找其他食物来补充。
                toAddForFood = upperLimit;
            }
            if (needUseFoodLimitTableWhenCal){
                NSNumber *nmFoodUpperLimit = food[@"Upper_Limit(g)"];
                double dFoodUpperLimit = 0;
                if (nmFoodUpperLimit != nil && nmFoodUpperLimit != [NSNull null]){
                    dFoodUpperLimit = [nmFoodUpperLimit doubleValue];
                }
                if (dFoodUpperLimit > 0 && toAddForFood - dFoodUpperLimit > nearZero){
                    toAddForFood = dFoodUpperLimit;//如果要用通常上限。这时这次只取到通常上限值，下次再计算别的最需要补充的食物。
                }  
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
            [LZUtility addDoubleToDictionaryItem:toAddForFood withDictionary:recommendFoodAmountDict andKey:foodNO];//推荐量累加
            [recommendFoodAttrDict setObject:food forKey:foodNO];
            [LZUtility addDoubleToDictionaryItem:toAddForFood withDictionary:foodSupplyAmountDict andKey:foodNO];//供给量累加
            
            NSMutableArray *foodSupplyNutrientSeq = [NSMutableArray arrayWithCapacity:5];
            [foodSupplyNutrientSeq addObject:nutrientNameToCal];
            [foodSupplyNutrientSeq addObject:foodNO];
            [foodSupplyNutrientSeq addObject:[NSNumber numberWithDouble:toAddForFood]];
            [foodSupplyNutrientSeq addObject:[food objectForKey:@"CnCaption"]];
            [foodSupplyNutrientSeq addObject:[food objectForKey:@"Shrt_Desc"]];
            [foodSupplyNutrientSeq addObject:[NSNumber numberWithDouble:maxNutrientLackRatio]];
        
            [foodSupplyNutrientSeqs addObject:foodSupplyNutrientSeq];
            
            if (toAddForNutrient > nearZero){
                //这次没有把这个营养素补充完，但现在由于补充了这种食物后，当前营养素不一定是最缺的，可以计算下一个最缺的营养素而不必非要把当前的营养素补充完
            }else{
                //这个营养素已经补足，可以到外层循环计算下一个营养素了
                [nutrientNameAryToCal removeObjectAtIndex:idxOfNutrientNameToCal];
            }

        //}//while ////选取一个食物，来补当前营养素
    }//while (nutrientNameAryToCal.count > 0)
    
    NSLog(@"recommendFoodForEnoughNuitrition foodSupplyNutrientSeqs=\n%@",foodSupplyNutrientSeqs);
    NSLog(@"recommendFoodForEnoughNuitrition nutrientSupplyDict=\n%@, recommendFoodAmountDict=\n%@",nutrientSupplyDict,recommendFoodAmountDict);
    
    NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithCapacity:5];
    [retDict setObject:DRIsDict forKey:@"DRI"];//nutrient name as key, also column name
    [retDict setObject:nutrientSupplyDict forKey:@"NutrientSupply"];//nutrient name as key, also column name
    [retDict setObject:recommendFoodAmountDict forKey:@"FoodAmount"];//food NO as key
    [retDict setObject:recommendFoodAttrDict forKey:@"FoodAttr"];//food NO as key
    
    [retDict setObject:dictNutrientLackWhenInitialTaken forKey:@"NutrientLackWhenInitialTaken"];
    if (needLimitNutrients){
        [retDict setObject:limitedNutrientDictCanBeCal forKey:@"limitedNutrientDictCanBeCal"];
    }
    
    [retDict setObject:options forKey:@"optionsDict"];
    [retDict setObject:params forKey:@"paramsDict"];
    [retDict setObject:foodSupplyNutrientSeqs forKey:@"foodSupplyNutrientSeqs"];//2D array
    
    
    NSArray *otherInfos = [NSArray arrayWithObjects:@"randSeed",[NSNumber numberWithUnsignedInt:randSeed],
                           @"randomRangeSelectFood",[NSNumber numberWithInt:randomRangeSelectFood],
                           @"randomSelectFood",[NSNumber numberWithBool:randomSelectFood],
                           @"notAllowSameFood",[NSNumber numberWithBool:notAllowSameFood],
                           @"needLimitNutrients",[NSNumber numberWithBool:needLimitNutrients],
                           @"needUseFoodLimitTableWhenCal",[NSNumber numberWithBool:needUseFoodLimitTableWhenCal],
                           
                           @"personDayCount",[NSNumber numberWithInt:personDayCount],
                           nil];
    [retDict setObject:otherInfos forKey:@"OtherInfo"];
    
    if (takenFoodAmountDict != nil && takenFoodAmountDict.count>0){
        [retDict setObject:takenFoodAmountDict forKey:@"TakenFoodAmount"];//food NO as key
        [retDict setObject:takenFoodAttrDict forKey:@"TakenFoodAttr"];//food NO as key
    }
    return retDict;
}

//-----------------------------------------



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
    
    NSDictionary *dictNutrientLackWhenInitialTaken = [recmdDict objectForKey:@"NutrientLackWhenInitialTaken"];
    NSDictionary *limitedNutrientDictCanBeCal = [recmdDict objectForKey:@"limitedNutrientDictCanBeCal"];
    
    NSArray *userInfos = [recmdDict objectForKey:@"UserInfo"];
    NSDictionary *options = [recmdDict objectForKey:@"optionsDict"];
    NSArray *otherInfos = [recmdDict objectForKey:@"OtherInfo"];
    NSArray *foodSupplyNutrientSeqs = [recmdDict objectForKey:@"foodSupplyNutrientSeqs"];//2D array

    
    NSDictionary *takenFoodAmountDict = [recmdDict objectForKey:@"TakenFoodAmount"];//food NO as key
    NSDictionary *takenFoodAttrDict = [recmdDict objectForKey:@"TakenFoodAttr"];//food NO as key
    
    NSDictionary *params = [recmdDict objectForKey:@"paramsDict"];
    int personDayCount = 1;
    if (params != nil){
        NSNumber *nm_personDayCount = [params objectForKey:@"personDayCount"];
        assert(nm_personDayCount != nil);
        personDayCount = [nm_personDayCount intValue];

    }

    
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
    
    
    //各种食物具体的量和提供各种营养素的量
//    NSArray* recommendFoodIDs = recommendFoodAmountDict.allKeys;
//    for(int i=0; i<recommendFoodIDs.count; i++){
//        NSString *foodID = recommendFoodIDs[i];
//        NSNumber *nmFoodAmount = [recommendFoodAmountDict objectForKey:foodID];
//        NSDictionary *foodAttrs = [recommendFoodAttrDict objectForKey:foodID];
//        row = [NSMutableArray arrayWithArray:rowForInit];
//        //row = [NSMutableArray arrayWithCapacity:(colIdx_NutrientStart+nutrientNames.count)];
//        row[0] = foodID;
//        row[1] = foodAttrs[@"CnCaption"];
//        row[2] = nmFoodAmount;
//        for(int j=0; j<nutrientNames.count;j++){
//            NSString *nutrientName = nutrientNames[j];
//            NSNumber *nmFoodAttrValue = [foodAttrs objectForKey:nutrientName];
//            if (nmFoodAttrValue == nil || nmFoodAttrValue == [NSNull null]){//有warning没事，试过了没问题
//                //do nothing
//            }else{
//                double foodSupplyNutrientAmount = [nmFoodAttrValue doubleValue]*[nmFoodAmount doubleValue]/100.0;
//                row[j+colIdx_NutrientStart] = [NSNumber numberWithDouble:foodSupplyNutrientAmount];
//            }
//        }//for j
//        [rows addObject:row];
//    }//for i
    NSMutableDictionary *recommendFoodAmountDict2 = [NSMutableDictionary dictionaryWithDictionary:recommendFoodAmountDict];
    for(int i=0; i<foodSupplyNutrientSeqs.count; i++){//主要是按计算顺序来显示
        NSArray * foodSupplyNutrientSeq = foodSupplyNutrientSeqs[i];
        NSString *foodID = foodSupplyNutrientSeq[1];
        if([recommendFoodAmountDict2 objectForKey:foodID]==nil){
            //这种情况是一种食物在供给中出现了多次，由于计算过程在某些情况下所造成
            continue;
        }
        [recommendFoodAmountDict2 removeObjectForKey:foodID];
        
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
    assert(recommendFoodAmountDict2.count==0);
    
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
    row[0] = @"DRI";
    for(int i=0; i<nutrientNames.count; i++){
        NSString *nutrientName = nutrientNames[i];
        NSNumber *nmNutrientDRI1unit = [DRIsDict objectForKey:nutrientName];
        if (nmNutrientDRI1unit != nil && nmNutrientDRI1unit != [NSNull null])
            row[i+colIdx_NutrientStart] = [NSNumber numberWithDouble:([nmNutrientDRI1unit doubleValue]*personDayCount)];
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
    
    //各种营养素相对DRI的lack
    NSMutableArray *rowNutrientLack = [NSMutableArray arrayWithArray:rowForInit];
    rowNutrientLack[0] = @"NutrientLack";
    for(int i=0; i<nutrientNames.count; i++){
        NSString *nutrientName = nutrientNames[i];
        NSNumber *nmNutrient = [dictNutrientLackWhenInitialTaken objectForKey:nutrientName];
        if (nmNutrient != nil && nmNutrient != [NSNull null])
            rowNutrientLack[i+colIdx_NutrientStart] = nmNutrient;
        else
            rowNutrientLack[i+colIdx_NutrientStart] = [NSNumber numberWithDouble:0.0];
    }
    [rows addObject:rowNutrientLack];
    
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
//    for(int i=0; i<recommendFoodIDs.count; i++){
//        NSString *foodID = recommendFoodIDs[i];
//        NSDictionary *foodAttrs = [recommendFoodAttrDict objectForKey:foodID];
//        row = [NSMutableArray arrayWithArray:rowForInit];
//        //row = [NSMutableArray arrayWithCapacity:(colIdx_NutrientStart+nutrientNames.count)];
//        row[0] = foodID;
//        row[1] = foodAttrs[@"CnCaption"];
//        row[2] = @"100";
//        for(int j=0; j<nutrientNames.count;j++){
//            NSString *nutrientName = nutrientNames[j];
//            NSNumber *nmFoodAttrValue = [foodAttrs objectForKey:nutrientName];
//            if (nmFoodAttrValue == nil || nmFoodAttrValue == [NSNull null]){
//                //do nothing
//            }else{
//                row[j+colIdx_NutrientStart] = nmFoodAttrValue;
//            }
//        }//for j
//        [rows addObject:row];
//    }//for i
    recommendFoodAmountDict2 = [NSMutableDictionary dictionaryWithDictionary:recommendFoodAmountDict];
    for(int i=0; i<foodSupplyNutrientSeqs.count; i++){//主要是按计算顺序来显示
        NSArray * foodSupplyNutrientSeq = foodSupplyNutrientSeqs[i];
        NSString *foodID = foodSupplyNutrientSeq[1];
        if([recommendFoodAmountDict2 objectForKey:foodID]==nil){
            //这种情况是一种食物在供给中出现了多次，由于计算过程在某些情况下所造成
            continue;
        }
        [recommendFoodAmountDict2 removeObjectForKey:foodID];

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
    assert(recommendFoodAmountDict2.count==0);
    
    row = [NSMutableArray arrayWithArray:rowForInit];
    row[0] = @"--------";
    [rows addObject:row];
    if(userInfos!=nil){
        [rows addObject:userInfos];
    }
    [rows addObject:otherInfos];
    row = [NSMutableArray arrayWithArray:rowForInit];
    row[0] = @"--------";
    [rows addObject:row];

//    for(int i=0; i<foodSupplyNutrientSeqs.count; i++){
//    }
    [rows addObjectsFromArray:foodSupplyNutrientSeqs];

    
    return rows;
}

-(void) formatCsv_RecommendFoodForEnoughNuitrition: (NSString *)csvFileName withRecommendResult:(NSDictionary*)recmdDict
{
    NSArray * ary2D = [self generateData2D_RecommendFoodForEnoughNuitrition:recmdDict];
    [LZUtility convert2DArrayToCsv:csvFileName withData:ary2D];
    [self convert2DArrayToText:ary2D];
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
    //NSLog(@"convert2DArrayToText ret:\n%@",rowsStr);
    return rowsStr;
}





-(NSMutableString*) generateHtml_RecommendFoodForEnoughNuitrition:(NSDictionary*)recmdDict
{
    NSLog(@"generateHtml_RecommendFoodForEnoughNuitrition enter");
    
    NSDictionary *DRIsDict = [recmdDict objectForKey:@"DRI"];//nutrient name as key, also column name
    NSDictionary *nutrientSupplyDict = [recmdDict objectForKey:@"NutrientSupply"];//nutrient name as key, also column name
    NSDictionary *recommendFoodAmountDict = [recmdDict objectForKey:@"FoodAmount"];//food NO as key
    NSDictionary *recommendFoodAttrDict = [recmdDict objectForKey:@"FoodAttr"];//food NO as key
    
    NSDictionary *dictNutrientLackWhenInitialTaken = [recmdDict objectForKey:@"NutrientLackWhenInitialTaken"];
    NSDictionary *limitedNutrientDictCanBeCal = [recmdDict objectForKey:@"limitedNutrientDictCanBeCal"];
    
    //NSArray *userInfos = [recmdDict objectForKey:@"UserInfo"];//2D array
    NSDictionary *options = [recmdDict objectForKey:@"optionsDict"];
    NSArray *foodSupplyNutrientSeqs = [recmdDict objectForKey:@"foodSupplyNutrientSeqs"];//2D array
    
    
    NSDictionary *takenFoodAmountDict = [recmdDict objectForKey:@"TakenFoodAmount"];//food NO as key
    NSDictionary *takenFoodAttrDict = [recmdDict objectForKey:@"TakenFoodAttr"];//food NO as key
    
    int limitRecommendFoodCount = 0;//0;//4;//只限制显示的
//    if ([options objectForKey:@"limitRecommendFoodCount"]!=nil){
//        NSNumber *nm_limitRecommendFoodCount = [options objectForKey:@"limitRecommendFoodCount"];
//        limitRecommendFoodCount = [nm_limitRecommendFoodCount intValue];
//    }
    
    
    NSMutableDictionary *foodSupplyFirstChooseNutrientLogDict = [NSMutableDictionary dictionary];
    for (int i=0; i<foodSupplyNutrientSeqs.count; i++) {
        NSArray *foodSupplyNutrientSeq= foodSupplyNutrientSeqs[i];
        NSString *nutrientName = foodSupplyNutrientSeq[0];
        NSString *foodID = foodSupplyNutrientSeq[1];
        [foodSupplyFirstChooseNutrientLogDict setObject:nutrientName forKey:foodID];
    }
    
    
    double nearZero = 0.0000001;
    
    NSMutableString *strHtml = [NSMutableString stringWithCapacity:1000*1000];
    [strHtml appendString:@"<style>\n"];
    [strHtml appendString:@"td {border:1px solid;}\n"];
    [strHtml appendString:@"</style>\n"];
    [strHtml appendString:@"<body>\n"];
    

//    NSArray* nutrientNames = [DRIsDict allKeys];
//    NSArray* nutrientNamesOrdered = [NSArray arrayWithObjects:@"Energ_Kcal",@"Carbohydrt_(g)",@"Lipid_Tot_(g)",@"Protein_(g)",
//                                     @"Vit_A_RAE",@"Vit_C_(mg)",@"Vit_D_(µg)",@"Vit_E_(mg)",@"Vit_K_(µg)",
//                                     @"Thiamin_(mg)",@"Riboflavin_(mg)",@"Niacin_(mg)",@"Vit_B6_(mg)",@"Folate_Tot_(µg)",
//                                     @"Vit_B12_(µg)",@"Panto_Acid_mg)",
//                                     @"Calcium_(mg)",@"Copper_(mg)",@"Iron_(mg)",@"Magnesium_(mg)",@"Manganese_(mg)",
//                                     @"Phosphorus_(mg)",@"Selenium_(µg)",@"Zinc_(mg)",@"Potassium_(mg)",@"Sodium_(mg)",
//                                     @"Water_(g)",@"Fiber_TD_(g)",@"Choline_Tot_ (mg)",@"Cholestrl_(mg)", nil];
//    assert(nutrientNames.count==nutrientNamesOrdered.count);
//    for(int i=0; i<nutrientNamesOrdered.count; i++){
//        assert([DRIsDict objectForKey:nutrientNamesOrdered[i]]!=nil);
//    }
//    nutrientNames = nutrientNamesOrdered;
    
    [strHtml appendString:@"<p>已经吃了的食物列表：</p>\n"];
    if (takenFoodAmountDict != nil && takenFoodAmountDict.count>0){
        NSArray* foodIDs = takenFoodAmountDict.allKeys;
        NSMutableArray* rows = [NSMutableArray arrayWithCapacity:takenFoodAmountDict.count];
        int colLen = 3;
        for(int i=0; i<foodIDs.count; i++){
            NSString *foodID = foodIDs[i];
            NSNumber *nmFoodAmount = [takenFoodAmountDict objectForKey:foodID];
            NSDictionary *foodAttrs = [takenFoodAttrDict objectForKey:foodID];
            NSMutableArray* row = [LZUtility generateEmptyArray:colLen];
            row[0] = foodID;
            row[1] = foodAttrs[@"CnCaption"];
            row[2] = nmFoodAmount;
            [rows addObject:row];
        }//for i
        NSString *strTbl = [LZUtility convert2DArrayToHtmlTable:rows withColumnNames:nil];
        [strHtml appendString:strTbl];
    }else{
        [strHtml appendString:@"<p>无。</p>\n"];
    }//if (takenFoodAmountDict != nil)
    
    
    [strHtml appendString:@"<p>缺乏的营养素列表：</p>\n"];
    if (dictNutrientLackWhenInitialTaken == nil || dictNutrientLackWhenInitialTaken.count == 0){
        [strHtml appendString:@"<p>无。</p>\n"];
    }else{
        NSArray* nutrientNames = dictNutrientLackWhenInitialTaken.allKeys;
        NSMutableArray* rows = [NSMutableArray arrayWithCapacity:dictNutrientLackWhenInitialTaken.count];
        int colLen = 3;
        for(int i=0; i<nutrientNames.count; i++){
            NSString *nutrientName = nutrientNames[i];
            NSNumber *nmNutrientLackVal = [dictNutrientLackWhenInitialTaken objectForKey:nutrientName];
            NSNumber *nmNutrientDRI = [DRIsDict objectForKey:nutrientName];
            
            if (limitedNutrientDictCanBeCal==nil ||
                (limitedNutrientDictCanBeCal!=nil && [limitedNutrientDictCanBeCal objectForKey:nutrientName]!=nil)
                )
            {//这里要考虑到需求中可能限制了营养素集合
                if ([nmNutrientLackVal doubleValue]>nearZero){
                    double lackRatio = [nmNutrientLackVal doubleValue] / [nmNutrientDRI doubleValue];
                    NSMutableArray* row = [LZUtility generateEmptyArray:colLen];
                    row[0] = nutrientName;
                    row[1] = nmNutrientLackVal;
                    row[2] = [NSNumber numberWithDouble:lackRatio];
                    [rows addObject:row];
                }
            }
        }//for i
        if (rows.count > 0){
            NSString *strTbl = [LZUtility convert2DArrayToHtmlTable:rows withColumnNames:[NSArray arrayWithObjects:@"营养素", @"缺乏量", @"缺乏比例", nil]];
            [strHtml appendString:strTbl];
        }else{
            [strHtml appendString:@"<p>无。</p>\n"];
        }
    }

    [strHtml appendString:@"<p>推荐的食物列表：</p>\n"];
    if (recommendFoodAmountDict != nil&& recommendFoodAmountDict.count>0){
        NSMutableArray* rows = [NSMutableArray arrayWithCapacity:recommendFoodAmountDict.count];
        int colLen = 4;
        
//        NSArray* foodIDs = recommendFoodAmountDict.allKeys;
//        for(int i=0; i<foodIDs.count; i++){
//            NSString *foodID = foodIDs[i];
//            NSNumber *nmFoodAmount = [recommendFoodAmountDict objectForKey:foodID];
//            NSDictionary *foodAttrs = [recommendFoodAttrDict objectForKey:foodID];
//            NSString *nutrientName = [foodSupplyFirstChooseNutrientLogDict objectForKey:foodID];
//            NSMutableArray* row = [LZUtility generateEmptyArray:colLen];
//            row[0] = foodID;
//            row[1] = foodAttrs[@"CnCaption"];
//            row[2] = nmFoodAmount;
//            row[3] = nutrientName;
//            [rows addObject:row];
//        }//for i
        NSMutableDictionary *recommendFoodAmountDict2 = [NSMutableDictionary dictionaryWithDictionary:recommendFoodAmountDict];
        for(int i=0; i<foodSupplyNutrientSeqs.count; i++){//主要是按计算顺序来显示
            NSArray * foodSupplyNutrientSeq = foodSupplyNutrientSeqs[i];
            NSString *foodID = foodSupplyNutrientSeq[1];
            if([recommendFoodAmountDict2 objectForKey:foodID]==nil){
                //这种情况是一种食物在供给中出现了多次，由于计算过程在某些情况下所造成
                continue;
            }
            [recommendFoodAmountDict2 removeObjectForKey:foodID];
            
            NSNumber *nmFoodAmount = [recommendFoodAmountDict objectForKey:foodID];
            NSDictionary *foodAttrs = [recommendFoodAttrDict objectForKey:foodID];
            NSString *nutrientName = [foodSupplyFirstChooseNutrientLogDict objectForKey:foodID];
            NSMutableArray* row = [LZUtility generateEmptyArray:colLen];
            row[0] = foodID;
            row[1] = foodAttrs[@"CnCaption"];
            row[2] = nmFoodAmount;
            row[3] = nutrientName;
            if (limitRecommendFoodCount > 0 && rows.count >= limitRecommendFoodCount){
                //如果超过需求中限制的推荐食物数量，则不显示
            }else{
                NSNumber *nmFoodLowerLimit = [foodAttrs objectForKey:@"Lower_Limit(g)"];
                if (nmFoodLowerLimit!=nil && nmFoodLowerLimit!=[NSNull null]
                    && [nmFoodLowerLimit doubleValue]>0 && [nmFoodAmount doubleValue]<[nmFoodLowerLimit doubleValue]){
                    //如果推荐食物数量太少，低于其预设的下限值，则不显示
                }else{
                    [rows addObject:row];
                }
            }
        }//for i
        assert(recommendFoodAmountDict2.count==0);
        
        NSString *strTbl = [LZUtility convert2DArrayToHtmlTable:rows withColumnNames:[NSArray arrayWithObjects:@"食物ID", @"食物名称", @"推荐量(g)", @"首补营养素", nil]];
        [strHtml appendString:strTbl];
        
    }else{
        [strHtml appendString:@"<p>无。</p>\n"];
    }//if (takenFoodAmountDict != nil)
    
    [strHtml appendString:@"<br/><hr/><br/>\n"];
    NSArray *detailData = [self generateData2D_RecommendFoodForEnoughNuitrition:recmdDict];
    NSString *detailHtml = [LZUtility convert2DArrayToHtmlTable:detailData withColumnNames:nil];
    [strHtml appendString:detailHtml];
        
    [strHtml appendString:@"</body>\n"];
    return strHtml;
}















@end
























