//
//  LZRecommendFood.m
//  nutrition
//
//  Created by Yasofon on 13-5-2.
//  Copyright (c) 2013年 lingzhi mobile. All rights reserved.
//

#import "LZRecommendFood.h"
#import "LZConstants.h"
#import "LZUtility.h"


@implementation LZRecommendFood

/*
 自定义要计算的营养素的清单
 */
+(NSArray*)getCustomNutrients
{
    NSArray *limitedNutrientsCanBeCal = nil;
    if (!KeyIsEnvironmentDebug){
        limitedNutrientsCanBeCal = [NSArray arrayWithObjects: @"Vit_A_RAE",@"Vit_C_(mg)",@"Vit_D_(µg)",@"Vit_E_(mg)",@"Vit_B6_(mg)",
                                    @"Calcium_(mg)",@"Iron_(mg)",@"Zinc_(mg)",@"Fiber_TD_(g)",@"Folate_Tot_(µg)", nil];
    }else{
//        limitedNutrientsCanBeCal = [NSArray arrayWithObjects:
//                                    @"Vit_A_RAE",@"Vit_C_(mg)",@"Vit_D_(µg)",@"Vit_E_(mg)",@"Vit_K_(µg)",
//                                    @"Thiamin_(mg)",@"Riboflavin_(mg)",@"Niacin_(mg)",@"Vit_B6_(mg)",@"Folate_Tot_(µg)",
//                                    @"Vit_B12_(µg)",@"Panto_Acid_mg)",
//                                    @"Calcium_(mg)",@"Copper_(mg)",@"Iron_(mg)",@"Magnesium_(mg)",@"Manganese_(mg)",
//                                    @"Phosphorus_(mg)",@"Selenium_(µg)",@"Zinc_(mg)",@"Potassium_(mg)",
//                                    @"Protein_(g)",@"Lipid_Tot_(g)",
//                                    @"Fiber_TD_(g)",@"Choline_Tot_ (mg)", nil];
        
        limitedNutrientsCanBeCal = [NSArray arrayWithObjects:
                                    @"Vit_A_RAE",@"Vit_C_(mg)",@"Vit_D_(µg)",@"Vit_E_(mg)",@"Vit_K_(µg)",
                                    @"Thiamin_(mg)",@"Riboflavin_(mg)",@"Niacin_(mg)",@"Vit_B6_(mg)",@"Folate_Tot_(µg)",
                                    @"Vit_B12_(µg)",@"Panto_Acid_mg)",
                                    @"Calcium_(mg)",@"Copper_(mg)",@"Iron_(mg)",@"Magnesium_(mg)",@"Manganese_(mg)",
                                    @"Phosphorus_(mg)",@"Selenium_(µg)",@"Zinc_(mg)",@"Potassium_(mg)",
                                    @"Protein_(g)",
                                    @"Fiber_TD_(g)",@"Choline_Tot_ (mg)", nil];

    }
    return limitedNutrientsCanBeCal;
}
/*
 营养素的一个全集，应该与DRI表中的营养素集合相同。顺序不一样，这个顺序用于计算，是经过特定算法的经验调整。
 */
+(NSArray*)getFullAndOrderedNutrients
{
    NSArray* nutrientNamesOrdered = [NSArray arrayWithObjects:
                                     @"Vit_A_RAE",@"Vit_C_(mg)",@"Vit_D_(µg)",@"Vit_E_(mg)",@"Vit_K_(µg)",
                                     @"Thiamin_(mg)",@"Riboflavin_(mg)",@"Niacin_(mg)",@"Vit_B6_(mg)",@"Folate_Tot_(µg)",
                                     @"Vit_B12_(µg)",@"Panto_Acid_mg)",
                                     @"Calcium_(mg)",@"Copper_(mg)",@"Iron_(mg)",@"Magnesium_(mg)",@"Manganese_(mg)",
                                     @"Phosphorus_(mg)",@"Selenium_(µg)",@"Zinc_(mg)",@"Potassium_(mg)",@"Sodium_(mg)",
                                     @"Protein_(g)",@"Lipid_Tot_(g)",@"Energ_Kcal",@"Carbohydrt_(g)",
                                     @"Water_(g)",@"Fiber_TD_(g)",@"Choline_Tot_ (mg)",@"Cholestrl_(mg)", nil];
    return nutrientNamesOrdered;
}
/*
 营养素的全集，与DRI表中的营养素集合相同。并且顺序也与DRI表中的顺序相同。这样在显示时比对DRI表时比较有用。
 */
+(NSArray*)getDRItableNutrientsWithSameOrder
{
    NSArray* nutrientNames = [NSArray arrayWithObjects:@"Energ_Kcal",@"Carbohydrt_(g)",@"Lipid_Tot_(g)",@"Protein_(g)",
         @"Vit_A_RAE",@"Vit_C_(mg)",@"Vit_D_(µg)",@"Vit_E_(mg)",@"Vit_K_(µg)",
         @"Thiamin_(mg)",@"Riboflavin_(mg)",@"Niacin_(mg)",@"Vit_B6_(mg)",@"Folate_Tot_(µg)",
         @"Vit_B12_(µg)",@"Panto_Acid_mg)",
         @"Calcium_(mg)",@"Copper_(mg)",@"Iron_(mg)",@"Magnesium_(mg)",@"Manganese_(mg)",
         @"Phosphorus_(mg)",@"Selenium_(µg)",@"Zinc_(mg)",@"Potassium_(mg)",@"Sodium_(mg)",
         @"Water_(g)",@"Fiber_TD_(g)",@"Choline_Tot_ (mg)",@"Cholestrl_(mg)", nil];
    return nutrientNames;
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
    NSDictionary *DRIsDict = [da getStandardDRIs:sex age:age weight:weight height:height activityLevel:activityLevel considerLoss:Config_needConsiderNutrientLoss];
    
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
    NSDictionary *DRIsDict = [da getAbstractPersonDRIsWithConsiderLoss:Config_needConsiderNutrientLoss];
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
 这里算法的主要特点是 ，补营养素的计算策略是一次对一种营养素用各种食物补够。
 
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
            double maxNutrientLackRatio = Config_nearZero;
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
                if (toAdd <= Config_nearZero){
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
                if (toAdd <= Config_nearZero){
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
        assert(toAddForNutrient>Config_nearZero);
        
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
                if (upperLimit - [nmIntakeFoodAmount doubleValue] < Config_nearZero){//这个食物已经用得够多到上限量了，换下一个来试
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
            if (nmFoodUpperLimit != nil && (NSNull*)nmFoodUpperLimit != [NSNull null]){
                dFoodUpperLimit = [nmFoodUpperLimit doubleValue];
            }
            if (toAddForFood - upperLimit > Config_nearZero){//要补的食物的量过多，当食物所含该种营养素的量太少时发生。这时只取到上限值，再找其他食物来补充。
                toAddForFood = upperLimit;
            }
            if (needUseFoodLimitTableWhenCal && dFoodUpperLimit > 0 && toAddForFood - dFoodUpperLimit > Config_nearZero){
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
            
            if (toAddForNutrient > Config_nearZero){
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
/*
 这是主接口函数,使用补充食物新策略
 */
-(NSMutableDictionary *) recommendFood2_AbstractPerson:(NSDictionary*)params withDecidedFoods:(NSDictionary*)decidedFoodAmountDict andOptions:(NSDictionary*)options
{
    NSNumber *nm_personCount = [params objectForKey:@"personCount"];
    uint personCount = [nm_personCount unsignedIntValue];
    assert(personCount>0);
    NSNumber *nm_dayCount = [params objectForKey:@"dayCount"];
    uint dayCount = [nm_dayCount unsignedIntValue];
    assert(dayCount>0);
    
    uint multiCount = personCount*dayCount;
    uint personDayCount = multiCount;
    NSDictionary *params2 = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithUnsignedInt:personDayCount],@"personDayCount",
                            nil];
    
    LZDataAccess *da = [LZDataAccess singleton];
    NSDictionary *DRIsDict = [da getAbstractPersonDRIsWithConsiderLoss:Config_needConsiderNutrientLoss];
    
    NSMutableDictionary *retDict = [self recommendFood2WithPreIntake:decidedFoodAmountDict andDRIs:DRIsDict andParams:params2 andOptions:options];
    return retDict;
    
}
/*
 这是使用补充食物新策略的一个外部接口函数
 */
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
    NSDictionary *DRIsDict = [da getStandardDRIs:sex age:age weight:weight height:height activityLevel:activityLevel considerLoss:Config_needConsiderNutrientLoss];
    
    NSMutableDictionary *retDict = [self recommendFood2WithPreIntake:takenFoodAmountDict andDRIs:DRIsDict andParams:params andOptions:options];
    NSArray *userInfos = [NSArray arrayWithObjects:@"sex(0 for M)",[NSNumber numberWithInt:sex],@"age",[NSNumber numberWithInt:age],
                          @"weight(kg)",[NSNumber numberWithFloat:weight],@"height(cm)",[NSNumber numberWithFloat:height],@"activityLevel",[NSNumber numberWithInt:activityLevel],nil];
    [retDict setObject:userInfos forKey:@"UserInfo"];
    [retDict setObject:userInfo forKey:@"userInfoDict"];
    return retDict;
}


/*
 与recommendFoodForEnoughNuitritionWithPreIntake相比，补营养素的计算策略改为不是一定非要给一种补够，而是补了一定量再计算下一个最缺的。
 这里推荐算法的一些主要特征：
     找最缺的营养素先补。
     用某种食物给某种营养素进行补充时，不是一次一定要补够，而是根据上下限表里面的数据给出一个合适值来补充。这次没补够不管，找下一个最缺的营养素进行一次新的过程。
     对于营养素，根据在实践中的一些经验，划分出了不需补充的和最后补充的。
     专门设置了一个食物的上下限表，目前只用了上限值，以防止推荐出的食物的量过多
 
 
 参数：
     takenFoodAmountDict 已经决定使用的食物，比如已经吃过的或已经准备购买的。食物的NDB_No的值是key.
     DRIsDict 单人单天的DRI。
     params 一些必要的参数。目前有key为personDayCount的。
     options 各种设置选项，影响算法的。

 返回值是一个Dictionary，包含key有：
 "DRI"，与DRIsDict相同，对应当前用户的DRI清单，虽然也可以调用方法计算出来。
 "nutrientInitialSupplyDict"，已吃食物提供的营养量清单。
 "NutrientSupply"，所有食物提供的各种营养素的合计，包括已经决定的和推荐的。
 "FoodAmount",推荐的各种食物的数量的清单，是一个Dictionary，食物的NDB_No的值是key。
 "FoodAttr"，推荐的各种食物的详细信息的清单，与"FoodAmount"的食物相同，是一个Dictionary，食物的NDB_No的值是key。
 "TakenFoodAmount"，已经吃了的食物数量的清单，与参数takenFoodAmountDict完全相同。
 "TakenFoodAttr"，已经吃了的食物的详细信息的清单，与"TakenFoodAmount"的食物相同，是一个Dictionary，食物的NDB_No的值是key。
 "NutrientLackWhenInitialTaken"，其数据是记录初始摄入食物后还缺哪些营养素，key是营养素名，value是缺乏的值。不缺乏或超标时为0值。与DRI相除后可以得到缺乏比例。
 至于mockup上是供给比例，可以再改再提供。
 "limitedNutrientDictCanBeCal",是一个自定义的营养素清单，目前是一个dict，key和value都是营养素名。必要时可以再给出一个数组。
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
        if (nm_randSeed != nil && [nm_randSeed unsignedIntValue] > 0)
            randSeed = [nm_randSeed unsignedIntValue];
        
        NSNumber *nmFlag_needLimitNutrients = [options objectForKey:@"needLimitNutrients"];
        if (nmFlag_needLimitNutrients != nil)
            needLimitNutrients = [nmFlag_needLimitNutrients boolValue];
        
        NSNumber *nmFlag_needUseFoodLimitTableWhenCal = [options objectForKey:@"needUseFoodLimitTableWhenCal"];
        if (nmFlag_needUseFoodLimitTableWhenCal != nil)
            needUseFoodLimitTableWhenCal = [nmFlag_needUseFoodLimitTableWhenCal boolValue];
    }

    NSLog(@"in recommendFoodForEnoughNuitritionWithPreIntake, randSeed=%u",randSeed);//如果某次情况需要调试，通过这个seed的设置应该可以重复当时情况
    srandom(randSeed);
    
    int defFoodUpperLimit = Config_foodUpperLimit; // 1000 g
    int defFoodLowerLimit = Config_foodLowerLimit;
    int defFoodNormalValue = Config_foodNormalValue;
    //int topN = 20;
    int topN = 50;
    NSString *colName_NO = @"NDB_No";

    
    LZDataAccess *da = [LZDataAccess singleton];
    
    NSMutableArray *calculationLogs = [NSMutableArray arrayWithCapacity:1000];
    NSMutableArray *calculationLog;
    NSMutableString *logMsg;
    
    //这里列出的营养素有专门而简单的食物补充，通过我们预置的那些食物反而不好补充
    NSArray *nutrientArrayNotCal =[NSArray arrayWithObjects:@"Water_(g)", @"Sodium_(mg)", nil];
    NSSet *nutrientSetNotCal = [NSSet setWithArray:nutrientArrayNotCal];
    
    //这里的营养素最后再计算补充
    //    Choline_Tot_ (mg) 胆碱 最少需要187g的蛋来补充或475g黄豆，都有悖常识，似乎是极难补充
    //    Vit_D_(µg) 只有鲤鱼等4种才有效补充
    //    Fiber_TD_(g) 最适合的只有豆角一种 151g，其次是豆类中的绿豆 233g，蔬菜水果类中的其次是藕 776g，都有些离谱了。不过，如果固定用蔬菜水果类来补，每天3斤的量，还说得过去。另外，不同书籍对其需要量及补充食物的含量都有区别。
    NSMutableArray *nutrientArrayLastCal = [NSMutableArray arrayWithObjects:@"Vit_D_(µg)",@"Choline_Tot_ (mg)",@"Fiber_TD_(g)", @"Carbohydrt_(g)",@"Energ_Kcal", nil];
    
    //这是需求中规定只计算哪些营养素
//    NSArray *limitedNutrientsCanBeCal = [NSArray arrayWithObjects: @"Vit_A_RAE",@"Vit_C_(mg)",@"Vit_D_(µg)",@"Vit_E_(mg)",@"Vit_B6_(mg)",
//                                         @"Calcium_(mg)",@"Iron_(mg)",@"Zinc_(mg)",@"Fiber_TD_(g)",@"Folate_Tot_(µg)", nil];
    NSArray *limitedNutrientsCanBeCal = [self.class getCustomNutrients];
    NSSet *limitedNutrientSetCanBeCal = [NSSet setWithArray:limitedNutrientsCanBeCal];
    NSDictionary *limitedNutrientDictCanBeCal = [NSDictionary dictionaryWithObjects:limitedNutrientsCanBeCal forKeys:limitedNutrientsCanBeCal];
    
    //这是一个营养素的全集
    NSArray* nutrientNamesOrdered = [self.class getFullAndOrderedNutrients];
//    NSArray* nutrientNamesOrdered = [NSArray arrayWithObjects:
//                                     @"Vit_A_RAE",@"Vit_C_(mg)",@"Vit_D_(µg)",@"Vit_E_(mg)",@"Vit_K_(µg)",
//                                     @"Thiamin_(mg)",@"Riboflavin_(mg)",@"Niacin_(mg)",@"Vit_B6_(mg)",@"Folate_Tot_(µg)",
//                                     @"Vit_B12_(µg)",@"Panto_Acid_mg)",
//                                     @"Calcium_(mg)",@"Copper_(mg)",@"Iron_(mg)",@"Magnesium_(mg)",@"Manganese_(mg)",
//                                     @"Phosphorus_(mg)",@"Selenium_(µg)",@"Zinc_(mg)",@"Potassium_(mg)",@"Sodium_(mg)",
//                                     @"Protein_(g)",@"Lipid_Tot_(g)",@"Energ_Kcal",@"Carbohydrt_(g)",
//                                     @"Water_(g)",@"Fiber_TD_(g)",@"Choline_Tot_ (mg)",@"Cholestrl_(mg)", nil];
    NSSet *nutrientNameSetOrdered = [NSSet setWithArray:nutrientNamesOrdered];
    
    //这里先根据各种过滤限制条件算出需要纳入计算的营养素，再对之进行顺序方面的设置
    NSMutableSet *nutrientSetToCal = [NSMutableSet setWithArray:DRIsDict.allKeys];//以DRI中所含营养素为初始值进行过滤
    [nutrientSetToCal minusSet:nutrientSetNotCal];
    if (needLimitNutrients){//如果需要使用限制集中的营养素的话
        [nutrientSetToCal intersectSet:limitedNutrientSetCanBeCal];
    }
    assert(nutrientSetToCal.count>0);
    assert([nutrientSetToCal isSubsetOfSet:nutrientNameSetOrdered]);//确认那个手工得到的全集还有效

    //对nutrientArrayLastCal也过滤一下
    nutrientArrayLastCal = [LZUtility arrayIntersectSet_withArray:nutrientArrayLastCal andSet:nutrientSetToCal];
    NSSet *nutrientSetLastCal = [NSSet setWithArray:nutrientArrayLastCal];
    
//    // nutrientNamesOrdered 与 nutrientSetToCal 取交集得到保持顺序的nutrient array ToCal，从这个结果还要把 nutrientArrayLastCal 中的取出挪到最后。
//    [nutrientSetToCal minusSet:nutrientSetLastCal];// 先取个小交集，从 nutrientSetToCal 减掉 nutrientArrayLastCal 的，
//    NSMutableArray *nutrientNameAryToCal = [LZUtility arrayIntersectSet_withArray:[NSMutableArray arrayWithArray:nutrientNamesOrdered] andSet:nutrientSetToCal];
//    [nutrientNameAryToCal addObjectsFromArray:nutrientArrayLastCal];//这里再把nutrientArrayLastCal的补回来
//    //到这里 nutrientNameAryToCal 中的值是既经过过滤，又经过排序的了。可以用于下面的计算了
//    assert(nutrientNameAryToCal.count>0);
    
    // nutrientNamesOrdered 与 nutrientSetToCal 取交集得到保持顺序的nutrient array ToCal，从这个结果还要把 nutrientArrayLastCal 中的取出，因为nutrientArrayLastCal会单独处理。
    [nutrientSetToCal minusSet:nutrientSetLastCal];
    NSMutableArray *nutrientNameAryToCal = [LZUtility arrayIntersectSet_withArray:[NSMutableArray arrayWithArray:nutrientNamesOrdered] andSet:nutrientSetToCal];//主要作用是把nutrientSetToCal中的内容根据nutrientNamesOrdered的顺序来排序
    //到这里，要计算的营养素含在nutrientNameAryToCal 和 nutrientArrayLastCal 中了

    logMsg = [NSMutableString stringWithFormat:@"nutrientNameAryToCal begin, cnt=%d, %@",nutrientNameAryToCal.count, [nutrientNameAryToCal componentsJoinedByString:@","] ];
    NSLog(@"%@",logMsg);
    calculationLog = [NSMutableArray array];
    [calculationLog addObject:@"nutrientNameAryToCal begin,cnt="];
    [calculationLog addObject: [NSNumber numberWithInt:nutrientNameAryToCal.count]];
    [calculationLog addObjectsFromArray:nutrientNameAryToCal];
    [calculationLogs addObject:calculationLog];
    
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
    
    NSDictionary *nutrientInitialSupplyDict = [NSDictionary dictionaryWithDictionary:nutrientSupplyDict];//记录already taken food提供的营养素的量
    
    NSMutableArray* foodSupplyNutrientSeqs = [NSMutableArray arrayWithCapacity:100];
    //对每个还需补足的营养素进行计算
    while (TRUE) {
        NSString *nutrientNameToCal = nil;
        int idxOfNutrientNameToCal = 0;
        NSString *typeOfNutrientNamesToCal = nil;
        double maxNutrientLackRatio = Config_nearZero;
        NSString *maxLackNutrientName = nil;
        if (nutrientNameAryToCal.count > 0){
            for(int i=nutrientNameAryToCal.count-1; i>=0; i--){//先去掉已经补满的
                NSString *nutrientName = nutrientNameAryToCal[i];
                NSNumber *nmSupplied = nutrientSupplyDict[nutrientName];
                NSNumber *nmTotalNeed1Unit = DRIsDict[nutrientName];
                double toAdd = [nmTotalNeed1Unit doubleValue]*personDayCount - [nmSupplied doubleValue];
                if (toAdd <= Config_nearZero){
                    [nutrientNameAryToCal removeObjectAtIndex:i];
                    logMsg = [NSMutableString stringWithFormat:@"Already Full for %@, removed",nutrientName ];
                    NSLog(@"%@",logMsg);
                    calculationLog = [NSMutableArray arrayWithObjects:logMsg, nil];
                    [calculationLogs addObject:calculationLog];
                }
            }
            if (nutrientNameAryToCal.count > 0){
                logMsg = [NSMutableString stringWithFormat:@"nutrientNameAryToCal cal-ing,cnt=%d, %@",nutrientNameAryToCal.count, [nutrientNameAryToCal componentsJoinedByString:@","]];
                NSLog(@"%@",logMsg);
                calculationLog = [NSMutableArray array];
                [calculationLog addObject:@"nutrientNameAryToCal cal-ing,cnt="];
                [calculationLog addObject: [NSNumber numberWithInt:nutrientNameAryToCal.count]];
                [calculationLog addObjectsFromArray:nutrientNameAryToCal];
                [calculationLogs addObject:calculationLog];
                
                maxNutrientLackRatio = Config_nearZero;
                maxLackNutrientName = nil;
                calculationLog = [NSMutableArray arrayWithObjects:@"nutrients lack rates:", nil];
                for(int i=0; i<nutrientNameAryToCal.count; i++){//先找出最需要补的营养素,即缺乏比例最大的
                    NSString *nutrientName = nutrientNameAryToCal[i];
                    NSNumber *nmSupplied = nutrientSupplyDict[nutrientName];
                    NSNumber *nmTotalNeed1Unit = DRIsDict[nutrientName];
                    double toAdd = [nmTotalNeed1Unit doubleValue]*personDayCount-[nmSupplied doubleValue];
                    assert(toAdd > Config_nearZero);
                    double lackRatio = toAdd/([nmTotalNeed1Unit doubleValue]*personDayCount);
                    [calculationLog addObject:nutrientName];
                    [calculationLog addObject:[NSNumber numberWithDouble:lackRatio]];
                    if (lackRatio > maxNutrientLackRatio){
                        maxLackNutrientName = nutrientName;
                        maxNutrientLackRatio = lackRatio;
                        idxOfNutrientNameToCal = i;
                    }
                }
                NSLog(@"%@",[calculationLog componentsJoinedByString:@","]);
                [calculationLogs addObject:calculationLog];

                logMsg = [NSMutableString stringWithFormat:@"maxLackNutrientName=%@, maxNutrientLackRatio=%.2f, idxOfNutrientNameToCal=%d",maxLackNutrientName,maxNutrientLackRatio,idxOfNutrientNameToCal];
                NSLog(@"%@",logMsg);
                calculationLog = [NSMutableArray array];
                [calculationLog addObject:@"maxLackNutrientName="];
                [calculationLog addObject:maxLackNutrientName];
                [calculationLog addObject:@"maxNutrientLackRatio="];
                [calculationLog addObject:[NSNumber numberWithDouble:maxNutrientLackRatio]];
                [calculationLog addObject:@"idxOfNutrientNameToCal="];
                [calculationLog addObject:[NSNumber numberWithInt:idxOfNutrientNameToCal]];
                [calculationLog addObjectsFromArray:nutrientNameAryToCal];
                
                [calculationLogs addObject:calculationLog];
                
                nutrientNameToCal = maxLackNutrientName;//已经取到待计算的营养素，但不从待计算集合中去掉，因为一次计算未必能够补充满这种营养素，由于有上限表之类的限制。并且注意下次找到的最需补充的营养素不一定是现在这个了。
                typeOfNutrientNamesToCal = Type_normalSet;
            }//if (nutrientNameAryToCal.count > 0) L2
        }//if (nutrientNameAryToCal.count > 0) L1
        
        if (nutrientNameToCal==nil){
            assert(nutrientNameAryToCal.count==0);//下面该看nutrientArrayLastCal中的营养素了
            if (nutrientArrayLastCal.count>0){
                for(int i=nutrientArrayLastCal.count-1; i>=0; i--){//先去掉已经补满的
                    NSString *nutrientName = nutrientArrayLastCal[i];
                    NSNumber *nmSupplied = nutrientSupplyDict[nutrientName];
                    NSNumber *nmTotalNeed1Unit = DRIsDict[nutrientName];
                    double toAdd = [nmTotalNeed1Unit doubleValue]*personDayCount - [nmSupplied doubleValue];
                    if (toAdd <= Config_nearZero){
                        [nutrientArrayLastCal removeObjectAtIndex:i];
                        logMsg = [NSMutableString stringWithFormat:@"Already Full for %@, removed",nutrientName ];
                        NSLog(@"%@",logMsg);
                        calculationLog = [NSMutableArray arrayWithObjects:logMsg, nil];
                        [calculationLogs addObject:calculationLog];
                    }
                }
            }

            if(nutrientArrayLastCal.count > 0){
                idxOfNutrientNameToCal = 0;
                nutrientNameToCal = nutrientArrayLastCal[idxOfNutrientNameToCal];
                typeOfNutrientNamesToCal = Type_lastSet;
            }
        }
                
        if (nutrientNameToCal==nil){
            assert(nutrientNameAryToCal.count==0);
            assert(nutrientArrayLastCal.count==0);
            break;
        }

        //当前有需要计算的营养素
        NSNumber *nmSupplied = nutrientSupplyDict[nutrientNameToCal];
        NSNumber *nmTotalNeed1Unit = DRIsDict[nutrientNameToCal];
        double toAddForNutrient = [nmTotalNeed1Unit doubleValue]*personDayCount-[nmSupplied doubleValue];
        assert(toAddForNutrient>Config_nearZero);
        
        NSArray * foodsToSupplyOneNutrient = [da getRichNutritionFood:nutrientNameToCal andTopN:topN];//找一些对于这种营养素含量最高的食物
        NSMutableArray *normalFoodsToSupplyOneNutrient = [NSMutableArray arrayWithArray:foodsToSupplyOneNutrient];
        NSMutableArray *alreadyUsedFoodsWhenOtherNutrients = [NSMutableArray array];
        //先根据食物是否用过和多样性标识把补当前营养素的食物分为两类
        for(int i=normalFoodsToSupplyOneNutrient.count-1; i>=0; i--){
            NSDictionary *food = foodsToSupplyOneNutrient[i];
            NSString *foodNO = food[colName_NO];
            if ( [foodSupplyAmountDict objectForKey:foodNO]!=nil ){//已经用过这种食物了  TODO 已经用过几次的计数比较，使用尚未用过的或用的次数少的......
                if (notAllowSameFood){//需要食物多样化的话，这里就不再用这种食物了
                    //[alreadyUsedFoodsWhenOtherNutrients addObject:food];
                    [alreadyUsedFoodsWhenOtherNutrients insertObject:food atIndex:0];
                    [normalFoodsToSupplyOneNutrient removeObjectAtIndex:i];//但如果实在补不齐，还可以再用它
                }
            }
        }
        
        //while (TRUE) {////选取一个食物，来补当前营养素
            NSDictionary *food = nil;
            
            if (normalFoodsToSupplyOneNutrient.count > 0){//先找尚未用过的食物
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
                while(alreadyUsedFoodsWhenOtherNutrients.count>0){//再循环找已经用过的食物且未超上限的
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
                    
                    double dFoodUpperLimit = defFoodUpperLimit;
                    if (needUseFoodLimitTableWhenCal){//如果使用限制表中的数据
                        NSNumber *nmFoodUpperLimit = food[COLUMN_NAME_Upper_Limit];
                        if (nmFoodUpperLimit != nil && (NSNull*)nmFoodUpperLimit != [NSNull null]){//用if而不是assert是容错考虑
                            dFoodUpperLimit = [nmFoodUpperLimit doubleValue];
                        }
                    }
                    if (dFoodUpperLimit*personDayCount - [nmIntakeFoodAmount doubleValue] <= Config_nearZero){//这个食物已经用得够多到上限量了，换下一个来试
                        continue;
                    }
                    
                    food = food2;
                    break;
                }//while(alreadyUsedFoodsWhenOtherNutrients.count>0)
            }
            if (food==nil){//这个营养素把所有能补的食物都用到上限了，不能再对它进行计算了
                logMsg = [NSMutableString stringWithFormat:@"no more proper food for the nutrient:%@,%d,%@",nutrientNameToCal,idxOfNutrientNameToCal,typeOfNutrientNamesToCal];
                NSLog(@"%@",logMsg);
                calculationLog = [NSMutableArray array];
                [calculationLog addObject:@"no more proper food for the nutrient:"];
                [calculationLog addObject:nutrientNameToCal];
                [calculationLog addObject:[NSNumber numberWithInt:idxOfNutrientNameToCal]];
                [calculationLog addObject:typeOfNutrientNamesToCal];
                if ([typeOfNutrientNamesToCal isEqualToString:Type_normalSet]){
                    [calculationLog addObject:[NSNumber numberWithInt:nutrientNameAryToCal.count]];
                    [calculationLog addObjectsFromArray:nutrientNameAryToCal];
                }else{
                    [calculationLog addObject:[NSNumber numberWithInt:nutrientArrayLastCal.count]];
                    [calculationLog addObjectsFromArray:nutrientArrayLastCal];
                }
                [calculationLogs addObject:calculationLog];
                
                if ([typeOfNutrientNamesToCal isEqualToString:Type_normalSet]){
                    [nutrientNameAryToCal removeObjectAtIndex:idxOfNutrientNameToCal];
                }else{
                    [nutrientArrayLastCal removeObjectAtIndex:idxOfNutrientNameToCal];
                }

                continue;//对于第1层while
                //break;//对于第2层while
            }

            //取到一个food，来计算补这种营养素，以及顺便补其他营养素
            NSString *foodNO = food[colName_NO];

            NSNumber* nmNutrientContentOfFood = [food objectForKey:nutrientNameToCal];
            assert([nmNutrientContentOfFood doubleValue]>0.0);//确认选出的这个食物含这种营养素
        
            double toAddForFood = toAddForNutrient / [nmNutrientContentOfFood doubleValue] * 100.0;//单位是g
            double dFoodNormalValue = defFoodNormalValue;
            if (needUseFoodLimitTableWhenCal){//如果使用限制表中的数据
                NSNumber *nmFoodNormalValue = food[COLUMN_NAME_normal_value];
                if(nmFoodNormalValue != nil && (NSNull*)nmFoodNormalValue != [NSNull null]){//用if而不是assert是容错考虑
                    dFoodNormalValue = [nmFoodNormalValue doubleValue];
                }
            }
            if (toAddForFood - dFoodNormalValue > Config_nearZero){//要补的食物的量对于普通建议量有点多，目前暂且不用上限值，这时这次只取到普通建议量，再找其他食物来补充。
                toAddForFood = dFoodNormalValue;
            }
        
            double dFoodLowerLimit = defFoodLowerLimit;
            if (needUseFoodLimitTableWhenCal){//如果使用限制表中的数据
                NSNumber *nmFoodLowerLimit = food[COLUMN_NAME_Lower_Limit];
                if(nmFoodLowerLimit != nil && (NSNull*)nmFoodLowerLimit != [NSNull null]){//用if而不是assert是容错考虑
                    dFoodLowerLimit = [nmFoodLowerLimit doubleValue];
                }
            }
            if (toAddForFood < dFoodLowerLimit) {//当这次要补的食物的量过少，近似于0而低于下限值时，则使用下限值，除非下限值为0
                toAddForFood = dFoodLowerLimit;
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
            logMsg = [NSMutableString stringWithFormat:@"supply food:%@", [foodSupplyNutrientSeq componentsJoinedByString:@" , "]];
            NSLog(@"%@",logMsg);
            calculationLog = [NSMutableArray array];
            [calculationLog addObject:@"supply food:"];
            [calculationLog addObjectsFromArray:foodSupplyNutrientSeq];
            [calculationLogs addObject:calculationLog];
        
            [foodSupplyNutrientSeqs addObject:foodSupplyNutrientSeq];
            
            if (toAddForNutrient > Config_nearZero){
                //这次没有把这个营养素补充完，但现在由于补充了这种食物后，当前营养素不一定是最缺的，可以计算下一个最缺的营养素而不必非要把当前的营养素补充完
            }else{
                //这个营养素已经补足，可以到外层循环计算下一个营养素了。
                logMsg = [NSMutableString stringWithFormat:@"food supply Full, remove %@, %d, %@",nutrientNameToCal,idxOfNutrientNameToCal,typeOfNutrientNamesToCal];
                NSLog(@"%@",logMsg);
                calculationLog = [NSMutableArray array];
                [calculationLog addObject:@"food supply Full, remove "];
                [calculationLog addObject:nutrientNameToCal];
                [calculationLog addObject:[NSNumber numberWithInt:idxOfNutrientNameToCal]];
                [calculationLog addObject:typeOfNutrientNamesToCal];
                if ([typeOfNutrientNamesToCal isEqualToString:Type_normalSet]){
                    [calculationLog addObject:[NSNumber numberWithInt:nutrientNameAryToCal.count]];
                    [calculationLog addObjectsFromArray:nutrientNameAryToCal];
                }else{
                    [calculationLog addObject:[NSNumber numberWithInt:nutrientArrayLastCal.count]];
                    [calculationLog addObjectsFromArray:nutrientArrayLastCal];
                }
                [calculationLogs addObject:calculationLog];
                
                if ([typeOfNutrientNamesToCal isEqualToString:Type_normalSet]){
                    [nutrientNameAryToCal removeObjectAtIndex:idxOfNutrientNameToCal];
                }else{
                    [nutrientArrayLastCal removeObjectAtIndex:idxOfNutrientNameToCal];
                }
            }

        //}//while ////选取一个食物，来补当前营养素
    }//while (nutrientNameAryToCal.count > 0)
    
    NSLog(@"recommendFoodForEnoughNuitrition foodSupplyNutrientSeqs=\n%@",foodSupplyNutrientSeqs);
    NSLog(@"recommendFoodForEnoughNuitrition nutrientSupplyDict=\n%@, recommendFoodAmountDict=\n%@",nutrientSupplyDict,recommendFoodAmountDict);
    
    NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithCapacity:5];
    [retDict setObject:DRIsDict forKey:@"DRI"];//nutrient name as key, also column name
    [retDict setObject:nutrientInitialSupplyDict forKey:@"nutrientInitialSupplyDict"];
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
    [retDict setObject:calculationLogs forKey:@"calculationLogs"];//2D array

    
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

/*
 这里考虑到了营养素的损失情况。目前只对营养素进行了损失系数的设置，其实不够科学，因为不同食物对于同一种营养素的损失情况是不一样的，而且还存在烹调加工的问题。比如熟吃的蔬菜和生吃的水果对于VC。
 */
-(NSMutableDictionary *) recommendFood3_AbstractPerson:(NSDictionary*)params withDecidedFoods:(NSDictionary*)decidedFoodAmountDict andOptions:(NSDictionary*)options
{
    NSNumber *nm_personCount = [params objectForKey:@"personCount"];
    uint personCount = [nm_personCount unsignedIntValue];
    assert(personCount>0);
    NSNumber *nm_dayCount = [params objectForKey:@"dayCount"];
    uint dayCount = [nm_dayCount unsignedIntValue];
    assert(dayCount>0);
    
    uint multiCount = personCount*dayCount;
    uint personDayCount = multiCount;
    NSDictionary *params2 = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithUnsignedInt:personDayCount],@"personDayCount",
                             nil];
    
    LZDataAccess *da = [LZDataAccess singleton];
    NSDictionary *DRIsDict = [da getAbstractPersonDRIsWithConsiderLoss:Config_needConsiderNutrientLoss];
    
    NSMutableDictionary *retDict = [self recommendFood3WithPreIntake:decidedFoodAmountDict andDRIs:DRIsDict andParams:params2 andOptions:options];
    NSMutableDictionary *retDict2 = [self mergeSomeSameClassFoodForRecommend1personDay:retDict];
    
    return retDict2;
    
}



/*
 与recommendFoodForEnoughNuitritionWithPreIntake相比，补营养素的计算策略改为不是一定非要给一种补够，而是补了一定量再计算下一个最缺的。
 与recommendFood2WithPreIntake相比，加了一个对单人天时的同类食物合并。不过，目前主要是在上层函数做了改动，这里的差别不大。
 这里推荐算法的一些主要特征：
     找最缺的营养素先补。
     用某种食物给某种营养素进行补充时，不是一次一定要补够，而是根据上下限表里面的数据给出一个合适值来补充。这次没补够不管，找下一个最缺的营养素进行一次新的过程。
     对于营养素，根据在实践中的一些经验，划分出了不需补充的和最后补充的。
     专门设置了一个食物的上下限表，目前上限值、下限值、推荐值都用上了，以防止推荐出的食物的量过多.
     另外还有一个营养素的损失系数的问题，不过不是在这里考虑，而是在上层函数中考虑。
 
 参数：
 takenFoodAmountDict 已经决定使用的食物，比如已经吃过的或已经准备购买的。食物的NDB_No的值是key.
 DRIsDict 单人单天的DRI。
 params 一些必要的参数。目前有key为personDayCount的。
 options 各种设置选项，影响算法的。
 
 返回值是一个Dictionary，包含key有：
 "DRI"，与DRIsDict相同，对应当前用户的DRI清单，虽然也可以调用方法计算出来。
 "nutrientInitialSupplyDict"，已吃食物提供的营养量清单。
 "NutrientSupply"，所有食物提供的各种营养素的合计，包括已经决定的和推荐的。
 "FoodAmount",推荐的各种食物的数量的清单，是一个Dictionary，食物的NDB_No的值是key。
 "FoodAttr"，推荐的各种食物的详细信息的清单，与"FoodAmount"的食物相同，是一个Dictionary，食物的NDB_No的值是key。
 "TakenFoodAmount"，已经吃了的食物数量的清单，与参数takenFoodAmountDict完全相同。
 "TakenFoodAttr"，已经吃了的食物的详细信息的清单，与"TakenFoodAmount"的食物相同，是一个Dictionary，食物的NDB_No的值是key。
 "NutrientLackWhenInitialTaken"，其数据是记录初始摄入食物后还缺哪些营养素，key是营养素名，value是缺乏的值。不缺乏或超标时为0值。与DRI相除后可以得到缺乏比例。
 至于mockup上是供给比例，可以再改再提供。
 "limitedNutrientDictCanBeCal",是一个自定义的营养素清单，目前是一个dict，key和value都是营养素名。必要时可以再给出一个数组。
 */
-(NSMutableDictionary *) recommendFood3WithPreIntake:(NSDictionary*)takenFoodAmountDict andDRIs:(NSDictionary*)DRIsDict andParams:(NSDictionary*)params andOptions:(NSDictionary*)options
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
        if (nm_randSeed != nil && [nm_randSeed unsignedIntValue] > 0)
            randSeed = [nm_randSeed unsignedIntValue];
        
        NSNumber *nmFlag_needLimitNutrients = [options objectForKey:@"needLimitNutrients"];
        if (nmFlag_needLimitNutrients != nil)
            needLimitNutrients = [nmFlag_needLimitNutrients boolValue];
        
        NSNumber *nmFlag_needUseFoodLimitTableWhenCal = [options objectForKey:@"needUseFoodLimitTableWhenCal"];
        if (nmFlag_needUseFoodLimitTableWhenCal != nil)
            needUseFoodLimitTableWhenCal = [nmFlag_needUseFoodLimitTableWhenCal boolValue];
    }
    
    NSLog(@"in recommendFoodForEnoughNuitritionWithPreIntake, randSeed=%u",randSeed);//如果某次情况需要调试，通过这个seed的设置应该可以重复当时情况
    srandom(randSeed);
    
    int defFoodUpperLimit = Config_foodUpperLimit; // 1000 g
    int defFoodLowerLimit = Config_foodLowerLimit;
    int defFoodNormalValue = Config_foodNormalValue;
    //int topN = 20;
    int topN = 50;
    NSString *colName_NO = @"NDB_No";
    
    
    LZDataAccess *da = [LZDataAccess singleton];
    
    NSMutableArray *calculationLogs = [NSMutableArray arrayWithCapacity:1000];
    NSMutableArray *calculationLog;
    NSMutableString *logMsg;
    
    //这里列出的营养素有专门而简单的食物补充，通过我们预置的那些食物反而不好补充
    NSArray *nutrientArrayNotCal =[NSArray arrayWithObjects:@"Water_(g)", @"Sodium_(mg)", nil];
    NSSet *nutrientSetNotCal = [NSSet setWithArray:nutrientArrayNotCal];
    
    //这里的营养素最后再计算补充
    //    Choline_Tot_ (mg) 胆碱 最少需要187g的蛋来补充或475g黄豆，都有悖常识，似乎是极难补充
    //    Vit_D_(µg) 只有鲤鱼等4种才有效补充
    //    Fiber_TD_(g) 最适合的只有豆角一种 151g，其次是豆类中的绿豆 233g，蔬菜水果类中的其次是藕 776g，都有些离谱了。不过，如果固定用蔬菜水果类来补，每天3斤的量，还说得过去。另外，不同书籍对其需要量及补充食物的含量都有区别。
    //    Calcium_(mg) 能补的食物种类虽多，但是量比较大--不过经试验特殊对待并无显著改进
    NSMutableArray *nutrientArrayLastCal = [NSMutableArray arrayWithObjects: @"Vit_D_(µg)",@"Choline_Tot_ (mg)",@"Fiber_TD_(g)", @"Carbohydrt_(g)",@"Energ_Kcal", nil];
    
    //这是需求中规定只计算哪些营养素
    //    NSArray *limitedNutrientsCanBeCal = [NSArray arrayWithObjects: @"Vit_A_RAE",@"Vit_C_(mg)",@"Vit_D_(µg)",@"Vit_E_(mg)",@"Vit_B6_(mg)",
    //                                         @"Calcium_(mg)",@"Iron_(mg)",@"Zinc_(mg)",@"Fiber_TD_(g)",@"Folate_Tot_(µg)", nil];
    NSArray *limitedNutrientsCanBeCal = [self.class getCustomNutrients];
    NSSet *limitedNutrientSetCanBeCal = [NSSet setWithArray:limitedNutrientsCanBeCal];
    NSDictionary *limitedNutrientDictCanBeCal = [NSDictionary dictionaryWithObjects:limitedNutrientsCanBeCal forKeys:limitedNutrientsCanBeCal];
    
    //这是一个营养素的全集
    NSArray* nutrientNamesOrdered = [self.class getFullAndOrderedNutrients];
    NSSet *nutrientNameSetOrdered = [NSSet setWithArray:nutrientNamesOrdered];
    
    //这里先根据各种过滤限制条件算出需要纳入计算的营养素，再对之进行顺序方面的设置
    NSMutableSet *nutrientSetToCal = [NSMutableSet setWithArray:DRIsDict.allKeys];//以DRI中所含营养素为初始值进行过滤
    [nutrientSetToCal minusSet:nutrientSetNotCal];
    if (needLimitNutrients){//如果需要使用限制集中的营养素的话
        [nutrientSetToCal intersectSet:limitedNutrientSetCanBeCal];
    }
    assert(nutrientSetToCal.count>0);
    assert([nutrientSetToCal isSubsetOfSet:nutrientNameSetOrdered]);//确认那个手工得到的全集还有效
    
    //对nutrientArrayLastCal也过滤一下
    nutrientArrayLastCal = [LZUtility arrayIntersectSet_withArray:nutrientArrayLastCal andSet:nutrientSetToCal];
    NSSet *nutrientSetLastCal = [NSSet setWithArray:nutrientArrayLastCal];
    
    //    // nutrientNamesOrdered 与 nutrientSetToCal 取交集得到保持顺序的nutrient array ToCal，从这个结果还要把 nutrientArrayLastCal 中的取出挪到最后。
    //    [nutrientSetToCal minusSet:nutrientSetLastCal];// 先取个小交集，从 nutrientSetToCal 减掉 nutrientArrayLastCal 的，
    //    NSMutableArray *nutrientNameAryToCal = [LZUtility arrayIntersectSet_withArray:[NSMutableArray arrayWithArray:nutrientNamesOrdered] andSet:nutrientSetToCal];
    //    [nutrientNameAryToCal addObjectsFromArray:nutrientArrayLastCal];//这里再把nutrientArrayLastCal的补回来
    //    //到这里 nutrientNameAryToCal 中的值是既经过过滤，又经过排序的了。可以用于下面的计算了
    //    assert(nutrientNameAryToCal.count>0);
    
    // nutrientNamesOrdered 与 nutrientSetToCal 取交集得到保持顺序的nutrient array ToCal，从这个结果还要把 nutrientArrayLastCal 中的取出，因为nutrientArrayLastCal会单独处理。
    [nutrientSetToCal minusSet:nutrientSetLastCal];
    NSMutableArray *nutrientNameAryToCal = [LZUtility arrayIntersectSet_withArray:[NSMutableArray arrayWithArray:nutrientNamesOrdered] andSet:nutrientSetToCal];//主要作用是把nutrientSetToCal中的内容根据nutrientNamesOrdered的顺序来排序
    //到这里，要计算的营养素含在nutrientNameAryToCal 和 nutrientArrayLastCal 中了
    
    NSMutableArray *nutrientNameAryToCalTotalOriginal = [NSMutableArray arrayWithArray:nutrientNameAryToCal];
    [nutrientNameAryToCalTotalOriginal addObjectsFromArray:nutrientArrayLastCal];
    
    
    logMsg = [NSMutableString stringWithFormat:@"nutrientNameAryToCal begin, cnt=%d, %@",nutrientNameAryToCal.count, [nutrientNameAryToCal componentsJoinedByString:@","] ];
    NSLog(@"%@",logMsg);
    calculationLog = [NSMutableArray array];
    [calculationLog addObject:@"nutrientNameAryToCal begin,cnt="];
    [calculationLog addObject: [NSNumber numberWithInt:nutrientNameAryToCal.count]];
    [calculationLog addObjectsFromArray:nutrientNameAryToCal];
    [calculationLogs addObject:calculationLog];
    
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
    
    NSDictionary *nutrientInitialSupplyDict = [NSDictionary dictionaryWithDictionary:nutrientSupplyDict];//记录already taken food提供的营养素的量
    
    NSMutableArray* foodSupplyNutrientSeqs = [NSMutableArray arrayWithCapacity:100];
    //对每个还需补足的营养素进行计算
    while (TRUE) {
        NSString *nutrientNameToCal = nil;
        int idxOfNutrientNameToCal = 0;
        NSString *typeOfNutrientNamesToCal = nil;
        double maxNutrientLackRatio = Config_nearZero;
        NSString *maxLackNutrientName = nil;
        if (nutrientNameAryToCal.count > 0){
            for(int i=nutrientNameAryToCal.count-1; i>=0; i--){//先去掉已经补满的
                NSString *nutrientName = nutrientNameAryToCal[i];
                NSNumber *nmSupplied = nutrientSupplyDict[nutrientName];
                NSNumber *nmTotalNeed1Unit = DRIsDict[nutrientName];
                double toAdd = [nmTotalNeed1Unit doubleValue]*personDayCount - [nmSupplied doubleValue];
                if (toAdd <= Config_nearZero){
                    [nutrientNameAryToCal removeObjectAtIndex:i];
                    logMsg = [NSMutableString stringWithFormat:@"Already Full for %@, removed",nutrientName ];
                    NSLog(@"%@",logMsg);
                    calculationLog = [NSMutableArray arrayWithObjects:logMsg, nil];
                    [calculationLogs addObject:calculationLog];
                }
            }
            if (nutrientNameAryToCal.count > 0){
                logMsg = [NSMutableString stringWithFormat:@"nutrientNameAryToCal cal-ing,cnt=%d, %@",nutrientNameAryToCal.count, [nutrientNameAryToCal componentsJoinedByString:@","]];
                NSLog(@"%@",logMsg);
                calculationLog = [NSMutableArray array];
                [calculationLog addObject:@"nutrientNameAryToCal cal-ing,cnt="];
                [calculationLog addObject: [NSNumber numberWithInt:nutrientNameAryToCal.count]];
                [calculationLog addObjectsFromArray:nutrientNameAryToCal];
                [calculationLogs addObject:calculationLog];
                
                maxNutrientLackRatio = Config_nearZero;
                maxLackNutrientName = nil;
                calculationLog = [NSMutableArray arrayWithObjects:@"nutrients lack rates:", nil];
                for(int i=0; i<nutrientNameAryToCal.count; i++){//先找出最需要补的营养素,即缺乏比例最大的
                    NSString *nutrientName = nutrientNameAryToCal[i];
                    NSNumber *nmSupplied = nutrientSupplyDict[nutrientName];
                    NSNumber *nmTotalNeed1Unit = DRIsDict[nutrientName];
                    double toAdd = [nmTotalNeed1Unit doubleValue]*personDayCount-[nmSupplied doubleValue];
                    assert(toAdd > Config_nearZero);
                    double lackRatio = toAdd/([nmTotalNeed1Unit doubleValue]*personDayCount);
                    [calculationLog addObject:nutrientName];
                    [calculationLog addObject:[NSNumber numberWithDouble:lackRatio]];
                    if (lackRatio > maxNutrientLackRatio){
                        maxLackNutrientName = nutrientName;
                        maxNutrientLackRatio = lackRatio;
                        idxOfNutrientNameToCal = i;
                    }
                }
                NSLog(@"%@",[calculationLog componentsJoinedByString:@","]);
                [calculationLogs addObject:calculationLog];
                
                logMsg = [NSMutableString stringWithFormat:@"maxLackNutrientName=%@, maxNutrientLackRatio=%.2f, idxOfNutrientNameToCal=%d",maxLackNutrientName,maxNutrientLackRatio,idxOfNutrientNameToCal];
                NSLog(@"%@",logMsg);
                calculationLog = [NSMutableArray array];
                [calculationLog addObject:@"maxLackNutrientName="];
                [calculationLog addObject:maxLackNutrientName];
                [calculationLog addObject:@"maxNutrientLackRatio="];
                [calculationLog addObject:[NSNumber numberWithDouble:maxNutrientLackRatio]];
                [calculationLog addObject:@"idxOfNutrientNameToCal="];
                [calculationLog addObject:[NSNumber numberWithInt:idxOfNutrientNameToCal]];
                [calculationLog addObjectsFromArray:nutrientNameAryToCal];
                
                [calculationLogs addObject:calculationLog];
                
                nutrientNameToCal = maxLackNutrientName;//已经取到待计算的营养素，但不从待计算集合中去掉，因为一次计算未必能够补充满这种营养素，由于有上限表之类的限制。并且注意下次找到的最需补充的营养素不一定是现在这个了。
                typeOfNutrientNamesToCal = Type_normalSet;
            }//if (nutrientNameAryToCal.count > 0) L2
        }//if (nutrientNameAryToCal.count > 0) L1
        
        if (nutrientNameToCal==nil){
            assert(nutrientNameAryToCal.count==0);//下面该看nutrientArrayLastCal中的营养素了
            if (nutrientArrayLastCal.count>0){
                for(int i=nutrientArrayLastCal.count-1; i>=0; i--){//先去掉已经补满的
                    NSString *nutrientName = nutrientArrayLastCal[i];
                    NSNumber *nmSupplied = nutrientSupplyDict[nutrientName];
                    NSNumber *nmTotalNeed1Unit = DRIsDict[nutrientName];
                    double toAdd = [nmTotalNeed1Unit doubleValue]*personDayCount - [nmSupplied doubleValue];
                    if (toAdd <= Config_nearZero){
                        [nutrientArrayLastCal removeObjectAtIndex:i];
                        logMsg = [NSMutableString stringWithFormat:@"Already Full for %@, removed",nutrientName ];
                        NSLog(@"%@",logMsg);
                        calculationLog = [NSMutableArray arrayWithObjects:logMsg, nil];
                        [calculationLogs addObject:calculationLog];
                    }
                }
            }
            
            if(nutrientArrayLastCal.count > 0){
                idxOfNutrientNameToCal = 0;
                nutrientNameToCal = nutrientArrayLastCal[idxOfNutrientNameToCal];
                typeOfNutrientNamesToCal = Type_lastSet;
            }
        }
        
        if (nutrientNameToCal==nil){
            assert(nutrientNameAryToCal.count==0);
            assert(nutrientArrayLastCal.count==0);
            break;
        }
        
        //当前有需要计算的营养素
        NSNumber *nmSupplied = nutrientSupplyDict[nutrientNameToCal];
        NSNumber *nmTotalNeed1Unit = DRIsDict[nutrientNameToCal];
        double toAddForNutrient = [nmTotalNeed1Unit doubleValue]*personDayCount-[nmSupplied doubleValue];
        assert(toAddForNutrient>Config_nearZero);
        
        NSArray * foodsToSupplyOneNutrient = [da getRichNutritionFood:nutrientNameToCal andTopN:topN];//找一些对于这种营养素含量最高的食物
        NSMutableArray *normalFoodsToSupplyOneNutrient = [NSMutableArray arrayWithArray:foodsToSupplyOneNutrient];
        NSMutableArray *alreadyUsedFoodsWhenOtherNutrients = [NSMutableArray array];
        //先根据食物是否用过和多样性标识把补当前营养素的食物分为两类
        for(int i=normalFoodsToSupplyOneNutrient.count-1; i>=0; i--){
            NSDictionary *food = foodsToSupplyOneNutrient[i];
            NSString *foodNO = food[colName_NO];
            if ( [foodSupplyAmountDict objectForKey:foodNO]!=nil ){//已经用过这种食物了  TODO 已经用过几次的计数比较，使用尚未用过的或用的次数少的......
                if (notAllowSameFood){//需要食物多样化的话，这里就不再用这种食物了
                    //[alreadyUsedFoodsWhenOtherNutrients addObject:food];
                    [alreadyUsedFoodsWhenOtherNutrients insertObject:food atIndex:0];
                    [normalFoodsToSupplyOneNutrient removeObjectAtIndex:i];//但如果实在补不齐，还可以再用它
                }
            }
        }
        
        //while (TRUE) {////选取一个食物，来补当前营养素
        NSDictionary *food = nil;
        
        if (normalFoodsToSupplyOneNutrient.count > 0){//先找尚未用过的食物
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
            while(alreadyUsedFoodsWhenOtherNutrients.count>0){//再循环找已经用过的食物且未超上限的
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
                
                double dFoodUpperLimit = defFoodUpperLimit;
                if (needUseFoodLimitTableWhenCal){//如果使用限制表中的数据
                    NSNumber *nmFoodUpperLimit = food[COLUMN_NAME_Upper_Limit];
                    if (nmFoodUpperLimit != nil && (NSNull*)nmFoodUpperLimit != [NSNull null]){//用if而不是assert是容错考虑
                        dFoodUpperLimit = [nmFoodUpperLimit doubleValue];
                    }
                }
                if (dFoodUpperLimit*personDayCount - [nmIntakeFoodAmount doubleValue] <= Config_nearZero){//这个食物已经用得够多到上限量了，换下一个来试
                    continue;
                }
                
                food = food2;
                break;
            }//while(alreadyUsedFoodsWhenOtherNutrients.count>0)
        }
        if (food==nil){//这个营养素把所有能补的食物都用到上限了，不能再对它进行计算了
            logMsg = [NSMutableString stringWithFormat:@"no more proper food for the nutrient:%@,%d,%@",nutrientNameToCal,idxOfNutrientNameToCal,typeOfNutrientNamesToCal];
            NSLog(@"%@",logMsg);
            calculationLog = [NSMutableArray array];
            [calculationLog addObject:@"no more proper food for the nutrient:"];
            [calculationLog addObject:nutrientNameToCal];
            [calculationLog addObject:[NSNumber numberWithInt:idxOfNutrientNameToCal]];
            [calculationLog addObject:typeOfNutrientNamesToCal];
            if ([typeOfNutrientNamesToCal isEqualToString:Type_normalSet]){
                [calculationLog addObject:[NSNumber numberWithInt:nutrientNameAryToCal.count]];
                [calculationLog addObjectsFromArray:nutrientNameAryToCal];
            }else{
                [calculationLog addObject:[NSNumber numberWithInt:nutrientArrayLastCal.count]];
                [calculationLog addObjectsFromArray:nutrientArrayLastCal];
            }
            [calculationLogs addObject:calculationLog];
            
            if ([typeOfNutrientNamesToCal isEqualToString:Type_normalSet]){
                [nutrientNameAryToCal removeObjectAtIndex:idxOfNutrientNameToCal];
            }else{
                [nutrientArrayLastCal removeObjectAtIndex:idxOfNutrientNameToCal];
            }
            
            continue;//对于第1层while
            //break;//对于第2层while
        }
        
        //取到一个food，来计算补这种营养素，以及顺便补其他营养素
        NSString *foodNO = food[colName_NO];
        
        NSNumber* nmNutrientContentOfFood = [food objectForKey:nutrientNameToCal];
        assert([nmNutrientContentOfFood doubleValue]>0.0);//确认选出的这个食物含这种营养素
        
        double toAddForFood = toAddForNutrient / [nmNutrientContentOfFood doubleValue] * 100.0;//单位是g
        double dFoodNormalValue = defFoodNormalValue;
        if (needUseFoodLimitTableWhenCal){//如果使用限制表中的数据
            NSNumber *nmFoodNormalValue = food[COLUMN_NAME_normal_value];
            if(nmFoodNormalValue != nil && (NSNull*)nmFoodNormalValue != [NSNull null]){//用if而不是assert是容错考虑
                dFoodNormalValue = [nmFoodNormalValue doubleValue];
            }
        }
        if (toAddForFood - dFoodNormalValue > Config_nearZero){//要补的食物的量对于普通建议量有点多，目前暂且不用上限值，这时这次只取到普通建议量，再找其他食物来补充。
            toAddForFood = dFoodNormalValue;
        }
        
        double dFoodLowerLimit = defFoodLowerLimit;
        if (needUseFoodLimitTableWhenCal){//如果使用限制表中的数据
            NSNumber *nmFoodLowerLimit = food[COLUMN_NAME_Lower_Limit];
            if(nmFoodLowerLimit != nil && (NSNull*)nmFoodLowerLimit != [NSNull null]){//用if而不是assert是容错考虑
                dFoodLowerLimit = [nmFoodLowerLimit doubleValue];
            }
        }
        if (toAddForFood < dFoodLowerLimit) {//当这次要补的食物的量过少，近似于0而低于下限值时，则使用下限值，除非下限值为0
            toAddForFood = dFoodLowerLimit;
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
        logMsg = [NSMutableString stringWithFormat:@"supply food:%@", [foodSupplyNutrientSeq componentsJoinedByString:@" , "]];
        NSLog(@"%@",logMsg);
        calculationLog = [NSMutableArray array];
        [calculationLog addObject:@"supply food:"];
        [calculationLog addObjectsFromArray:foodSupplyNutrientSeq];
        [calculationLogs addObject:calculationLog];
        
        [foodSupplyNutrientSeqs addObject:foodSupplyNutrientSeq];
        
        if (toAddForNutrient > Config_nearZero){
            //这次没有把这个营养素补充完，但现在由于补充了这种食物后，当前营养素不一定是最缺的，可以计算下一个最缺的营养素而不必非要把当前的营养素补充完
        }else{
            //这个营养素已经补足，可以到外层循环计算下一个营养素了。
            logMsg = [NSMutableString stringWithFormat:@"food supply Full, remove %@, %d, %@",nutrientNameToCal,idxOfNutrientNameToCal,typeOfNutrientNamesToCal];
            NSLog(@"%@",logMsg);
            calculationLog = [NSMutableArray array];
            [calculationLog addObject:@"food supply Full, remove "];
            [calculationLog addObject:nutrientNameToCal];
            [calculationLog addObject:[NSNumber numberWithInt:idxOfNutrientNameToCal]];
            [calculationLog addObject:typeOfNutrientNamesToCal];
            if ([typeOfNutrientNamesToCal isEqualToString:Type_normalSet]){
                [calculationLog addObject:[NSNumber numberWithInt:nutrientNameAryToCal.count]];
                [calculationLog addObjectsFromArray:nutrientNameAryToCal];
            }else{
                [calculationLog addObject:[NSNumber numberWithInt:nutrientArrayLastCal.count]];
                [calculationLog addObjectsFromArray:nutrientArrayLastCal];
            }
            [calculationLogs addObject:calculationLog];
            
            if ([typeOfNutrientNamesToCal isEqualToString:Type_normalSet]){
                [nutrientNameAryToCal removeObjectAtIndex:idxOfNutrientNameToCal];
            }else{
                [nutrientArrayLastCal removeObjectAtIndex:idxOfNutrientNameToCal];
            }
        }
        
        //}//while ////选取一个食物，来补当前营养素
    }//while (nutrientNameAryToCal.count > 0)
    
    NSLog(@"recommendFoodForEnoughNuitrition foodSupplyNutrientSeqs=\n%@",foodSupplyNutrientSeqs);
    NSLog(@"recommendFoodForEnoughNuitrition nutrientSupplyDict=\n%@, recommendFoodAmountDict=\n%@",nutrientSupplyDict,recommendFoodAmountDict);
    
    NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithCapacity:5];
    [retDict setObject:DRIsDict forKey:@"DRI"];//nutrient name as key, also column name
    [retDict setObject:nutrientInitialSupplyDict forKey:@"nutrientInitialSupplyDict"];
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
    [retDict setObject:calculationLogs forKey:@"calculationLogs"];//2D array
    
    
    NSArray *otherInfos = [NSArray arrayWithObjects:@"randSeed",[NSNumber numberWithUnsignedInt:randSeed],
                           @"randomRangeSelectFood",[NSNumber numberWithInt:randomRangeSelectFood],
                           @"randomSelectFood",[NSNumber numberWithBool:randomSelectFood],
                           @"notAllowSameFood",[NSNumber numberWithBool:notAllowSameFood],
                           @"needLimitNutrients",[NSNumber numberWithBool:needLimitNutrients],
                           @"needUseFoodLimitTableWhenCal",[NSNumber numberWithBool:needUseFoodLimitTableWhenCal],
                           
                           @"personDayCount",[NSNumber numberWithInt:personDayCount],
                           nil];
    [retDict setObject:otherInfos forKey:@"OtherInfo"];
    
    [retDict setObject:nutrientNameAryToCalTotalOriginal forKey:@"nutrientNameAryToCalTotalOriginal"];
    
    
    
    if (takenFoodAmountDict != nil && takenFoodAmountDict.count>0){
        [retDict setObject:takenFoodAmountDict forKey:@"TakenFoodAmount"];//food NO as key
        [retDict setObject:takenFoodAttrDict forKey:@"TakenFoodAttr"];//food NO as key
    }
    return retDict;
}

/*
 合并算法的主要需求是 在单人天的情况下 ，推荐出的食物如果存在某个细类的有好几种食物，如有好几种鱼，给人感觉不是太好，从而需要合并。
 但是，这也存在着严重bug。如下例：
     当已经选了一些食物而缺钙缺VD时，会选出几种鱼。
     含vd多的鱼含钙很少，含钙多的鱼含vd很少，没有交集。
     这样，如果vd和钙都导致选出了鱼，最后合并鱼类，按现在的算法，会导致单种鱼的需要量很高。或者某些鱼这两项都含量低的时候更是如此。
 */
-(NSMutableDictionary*)mergeSomeSameClassFoodForRecommend1personDay:(NSMutableDictionary *)recommendResult
{
    NSLog(@"mergeSomeSameClassFoodForRecommend1personDay enter");
    
    NSDictionary *DRIsDict = [recommendResult objectForKey:@"DRI"];//nutrient name as key, also column name
//    NSDictionary *nutrientInitialSupplyDict = [recommendResult objectForKey:@"nutrientInitialSupplyDict"];
    NSDictionary *nutrientSupplyDict = [recommendResult objectForKey:@"NutrientSupply"];//nutrient name as key, also column name
    NSMutableDictionary *recommendFoodAmountDict = [recommendResult objectForKey:@"FoodAmount"];//food NO as key
    NSMutableDictionary *recommendFoodAttrDict = [recommendResult objectForKey:@"FoodAttr"];//food NO as key
    
    //    NSDictionary *dictNutrientLackWhenInitialTaken = [recommendResult objectForKey:@"NutrientLackWhenInitialTaken"];
//    NSDictionary *limitedNutrientDictCanBeCal = [recommendResult objectForKey:@"limitedNutrientDictCanBeCal"];
    

//    NSDictionary *options = [recommendResult objectForKey:@"optionsDict"];
    NSDictionary *params = [recommendResult objectForKey:@"paramsDict"];
    
//    NSArray *foodSupplyNutrientSeqs = [recommendResult objectForKey:@"foodSupplyNutrientSeqs"];//2D array
//    NSArray *calculationLogs = [recommendResult objectForKey:@"calculationLogs"];//2D array
//    NSArray *otherInfos = [recommendResult objectForKey:@"OtherInfo"];

//    NSMutableDictionary *takenFoodAmountDict = [recommendResult objectForKey:@"TakenFoodAmount"];//food NO as key
//    NSMutableDictionary *takenFoodAttrDict = [recommendResult objectForKey:@"TakenFoodAttr"];//food NO as key
    
    NSArray * nutrientNameAryToCalTotalOriginal = [recommendResult objectForKey:@"nutrientNameAryToCalTotalOriginal"];
    
    int personDayCount = 1;
    NSNumber *nm_personDayCount = [params objectForKey:@"personDayCount"];
    assert(nm_personDayCount != nil);
    personDayCount = [nm_personDayCount intValue];
    assert(personDayCount>=1);
    if (personDayCount>1)
        return recommendResult;
    //when personDayCount==1, need try to merge
    
    if (recommendFoodAttrDict == nil)
        return recommendResult;
    NSMutableDictionary *recommendClassifyCountDict = [NSMutableDictionary dictionary];
    NSArray * recommendFoodIds =[recommendFoodAttrDict allKeys];
    for(int i=0; i<recommendFoodIds.count; i++){
        NSString *recommendFoodId = recommendFoodIds[i];
        NSDictionary *foodInfo = [recommendFoodAttrDict objectForKey:recommendFoodId];
        NSString *foodClassify = [foodInfo objectForKey:COLUMN_NAME_classify];
        [LZUtility addDoubleToDictionaryItem:1.0 withDictionary:recommendClassifyCountDict andKey:foodClassify];
    }
    NSArray *classifyAry = [recommendClassifyCountDict allKeys];
    for(int i=0; i<classifyAry.count; i++){
        NSString *foodClassify = classifyAry[i];
        NSNumber *nmClassifyCount = [recommendClassifyCountDict objectForKey:foodClassify];
        if ([nmClassifyCount doubleValue]<2.0){//只保留含食物数量大于等于2种的食物类别
            [recommendClassifyCountDict removeObjectForKey:foodClassify];
        }
    }
    NSMutableDictionary *needMergeClassifyCountDict = [NSMutableDictionary dictionary];//目前要合并的食物分类我们使用最细层级。
    NSNumber *nmClassifyCount = nil;
    NSString *classifyToMerge = nil;
    classifyToMerge = FoodClassify_rou_shui_yu;
    nmClassifyCount = [recommendClassifyCountDict objectForKey:classifyToMerge];
    if (nmClassifyCount != nil){
        [needMergeClassifyCountDict setObject:nmClassifyCount forKey:classifyToMerge];
    }
    
    classifyToMerge = FoodClassify_rou_shui_xia;
    nmClassifyCount = [recommendClassifyCountDict objectForKey:classifyToMerge];
    if (nmClassifyCount != nil){
        [needMergeClassifyCountDict setObject:nmClassifyCount forKey:classifyToMerge];
    }
    
    classifyToMerge = FoodClassify_rou_chu_rou;
    nmClassifyCount = [recommendClassifyCountDict objectForKey:classifyToMerge];
    if (nmClassifyCount != nil){
        [needMergeClassifyCountDict setObject:nmClassifyCount forKey:classifyToMerge];
    }
    
    classifyToMerge = FoodClassify_rou_qin;
    nmClassifyCount = [recommendClassifyCountDict objectForKey:classifyToMerge];
    if (nmClassifyCount != nil){
        [needMergeClassifyCountDict setObject:nmClassifyCount forKey:classifyToMerge];
    }
    
    classifyToMerge = FoodClassify_danlei;
    nmClassifyCount = [recommendClassifyCountDict objectForKey:classifyToMerge];
    if (nmClassifyCount != nil){
        [needMergeClassifyCountDict setObject:nmClassifyCount forKey:classifyToMerge];
    }

    NSArray *classifyToMergeAry = [needMergeClassifyCountDict allKeys];
    if (classifyToMergeAry.count == 0)
        return recommendResult;
    NSMutableArray *mergeLogs = [NSMutableArray arrayWithCapacity:100];
    NSMutableArray *mergeLog;
    NSMutableDictionary *recommendFoodAmountDict2 = [NSMutableDictionary dictionaryWithDictionary:recommendFoodAmountDict];
    NSMutableDictionary *recommendFoodAttrDict2 = [NSMutableDictionary dictionaryWithDictionary:recommendFoodAttrDict];
    NSMutableDictionary *nutrientSupplyDict2 = [NSMutableDictionary dictionaryWithDictionary:nutrientSupplyDict];
    for( int a=0; a<classifyToMergeAry.count; a++){
        NSString *foodClassify = classifyToMergeAry[a];
        
        NSMutableDictionary *originalFoodAttrOfClassifyDict = [NSMutableDictionary dictionary];
        NSMutableDictionary *originalFoodAmountOfClassifyDict = [NSMutableDictionary dictionary];
        
        //这个类的对应的那些食物，从推荐清单中取出，并且所提供的各营养的量从supply中减去
        NSArray * recommendFoodIds =[recommendFoodAmountDict2 allKeys];
        for(int i=0; i<recommendFoodIds.count; i++){
            NSString *foodId = recommendFoodIds[i];
            NSDictionary *foodInfo = [recommendFoodAttrDict2 objectForKey:foodId];
            NSString *classifyOfTheFood = [foodInfo objectForKey:COLUMN_NAME_classify];
            if ([foodClassify isEqualToString:classifyOfTheFood]){
                NSNumber *nmFoodAmount = [recommendFoodAmountDict2 objectForKey:foodId];
                [originalFoodAttrOfClassifyDict setObject:foodInfo forKey:foodId];
                [originalFoodAmountOfClassifyDict setObject:nmFoodAmount forKey:foodId];
                [recommendFoodAmountDict2 removeObjectForKey:foodId];
                [recommendFoodAttrDict2 removeObjectForKey:foodId];
                //这个食物的各营养的量从supply中减去
                NSArray *nutrients = [DRIsDict allKeys];
                for(int j=0; j<nutrients.count; j++){
                    NSString *nutrient = nutrients[j];
                    NSNumber *nmNutrientContentOfFood = [foodInfo objectForKey:nutrient];
                    if (nmNutrientContentOfFood != nil && [nmNutrientContentOfFood doubleValue] != 0.0){
                        double dFoodSupplyTheNutrient = [nmNutrientContentOfFood doubleValue]*([nmFoodAmount doubleValue]/100.0)*(-1);
                        [LZUtility addDoubleToDictionaryItem:dFoodSupplyTheNutrient withDictionary:nutrientSupplyDict2 andKey:nutrient];
                    }
                }//for j
                mergeLog = [NSMutableArray arrayWithObjects:@"MergeFrom",foodId,nmFoodAmount,[foodInfo objectForKey:COLUMN_NAME_CnCaption], nil];
                [mergeLogs addObject:mergeLog];
            }//if ([foodClassify isEqualToString:foodClassify2])
        }//for(int i=0; i<recommendFoodIds.count; i++)
        
        //需要找属于这个类的那些食物中能补足所有（需计算的）营养素的至少一个食物，可能随机选也可能选所需最少量的那个食物
        NSString *minAmountFoodId = nil;
        double dMinFoodAmount = 0;
        NSMutableArray *oneSupplyAllFoodIdAry = [NSMutableArray array];
        NSMutableArray *oneSupplyAllFoodAmountAry = [NSMutableArray array];
        NSArray *foodIdsOfClassify = [originalFoodAmountOfClassifyDict allKeys];
        for(int i=0; i<foodIdsOfClassify.count; i++){
            NSString *foodIdOfClassify = foodIdsOfClassify[i];
            NSDictionary *foodInfo = [originalFoodAttrOfClassifyDict objectForKey:foodIdOfClassify];
            double maxLocalFoodAmount = 0;
            BOOL foodCoverAllLackNutrient = TRUE;
            for(int j=0; j<nutrientNameAryToCalTotalOriginal.count; j++){//注意这里的营养素是需计算的那些，而不是全集
                NSString *nutrientName = nutrientNameAryToCalTotalOriginal[j];
                NSNumber *nmSupplied = nutrientSupplyDict2[nutrientName];
                NSNumber *nmStandardNeed1Unit = DRIsDict[nutrientName];
                double toAdd = [nmStandardNeed1Unit doubleValue]*personDayCount-[nmSupplied doubleValue];
                if (toAdd > Config_nearZero){//这个营养素缺乏
                    NSNumber *nmNutrientContentOfFood = [foodInfo objectForKey:nutrientName];
                    if ([nmNutrientContentOfFood doubleValue] != 0.0){
                        double dNeedFoodAmountForTheNutrient = toAdd / [nmNutrientContentOfFood doubleValue] * 100.0;
                        if (maxLocalFoodAmount == 0)
                            maxLocalFoodAmount = dNeedFoodAmountForTheNutrient;
                        else if (maxLocalFoodAmount < dNeedFoodAmountForTheNutrient)
                            maxLocalFoodAmount = dNeedFoodAmountForTheNutrient;
                    }else{
                        foodCoverAllLackNutrient = FALSE;//这表明同类食物各自所含的营养素也还有较大差别，存在有些营养素这个食物有另一个食物没有的问题，而不是含量高低的问题。注意这里需要分类极其细化.
                        NSLog(@"WARNING: foodCoverAllLackNutrient = FALSE, %@, %@", foodIdOfClassify, [foodInfo objectForKey:COLUMN_NAME_CnCaption]);
                        break;
                    }
                }//if (toAdd > Config_nearZero)
            }//for(int j=0; j<nutrientNameAryToCal.count; j++)
            
            if (foodCoverAllLackNutrient){
                [oneSupplyAllFoodIdAry addObject:foodIdsOfClassify];
                [oneSupplyAllFoodAmountAry addObject:[NSNumber numberWithDouble:maxLocalFoodAmount]];
                if (minAmountFoodId==nil){
                    minAmountFoodId = foodIdOfClassify;
                    dMinFoodAmount = maxLocalFoodAmount;
                }else{
                    if (dMinFoodAmount > maxLocalFoodAmount){
                        minAmountFoodId = foodIdOfClassify;
                        dMinFoodAmount = maxLocalFoodAmount;
                    }
                }
            }
        }//for(int i=0; i<foodIdsOfClassify.count; i++)
        if (minAmountFoodId==nil){//说明这类的这几个食物所含营养素各有差别，单个食物不能补足欠缺
            NSLog(@"WARNING: goodFoodId==nil, %@", foodClassify);
            continue;
        }else{//goodFoodId exist
            assert(oneSupplyAllFoodIdAry.count>0);
            NSLog(@"in mergeSomeSameClassFoodForRecommend1personDay,toMergeClassify=%@, oneSupplyAllFoodIdAry=%@, oneSupplyAllFoodAmountAry=%@",foodClassify, oneSupplyAllFoodIdAry,oneSupplyAllFoodAmountAry);
            //这里使用所需最少量的那个食物加回到推荐集合中，以补足同类食物消去后所缺的营养,注意这里的营养使用全集
            [recommendFoodAmountDict2 setObject:[NSNumber numberWithDouble:dMinFoodAmount] forKey:minAmountFoodId];
            NSDictionary *goodFoodInfo = [originalFoodAttrOfClassifyDict objectForKey:minAmountFoodId];
            [recommendFoodAttrDict2 setObject:goodFoodInfo forKey:minAmountFoodId];
            
            mergeLog = [NSMutableArray arrayWithObjects:@"MergeTo",minAmountFoodId,[NSNumber numberWithDouble:dMinFoodAmount],[goodFoodInfo objectForKey:COLUMN_NAME_CnCaption], nil];
            [mergeLogs addObject:mergeLog];
            
            //这个食物的各营养的量加到supply中
            NSArray *nutrients = [nutrientSupplyDict2 allKeys];
            for(int i=0; i<nutrients.count; i++){
                NSString *nutrient = nutrients[i];
                NSNumber *nmNutrientContentOfFood = [goodFoodInfo objectForKey:nutrient];
                assert(nmNutrientContentOfFood!=nil);
                if ([nmNutrientContentOfFood doubleValue] != 0.0){
                    [LZUtility addDoubleToDictionaryItem:[nmNutrientContentOfFood doubleValue]*dMinFoodAmount/100.0 withDictionary:nutrientSupplyDict2 andKey:nutrient];
                }
            }//for i
        }
    }//for( int a=0; a<classifyToMergeAry.count; a++)
    
    NSLog(@"in mergeSomeSameClassFoodForRecommend1personDay,mergeLogs=\n%@",mergeLogs);
    
    [recommendResult setObject:recommendFoodAmountDict2 forKey:@"FoodAmount"];//food NO as key
    [recommendResult setObject:recommendFoodAttrDict2 forKey:@"FoodAttr"];//food NO as key
    [recommendResult setObject:nutrientSupplyDict2 forKey:@"NutrientSupply"];//nutrient name as key, also column name
    [recommendResult setObject:mergeLogs forKey:@"mergeLogs"];
    
    [recommendResult setObject:recommendFoodAmountDict forKey:@"FoodAmountOld"];//food NO as key
    [recommendResult setObject:recommendFoodAttrDict forKey:@"FoodAttrOld"];//food NO as key
    [recommendResult setObject:nutrientSupplyDict forKey:@"NutrientSupplyOld"];//nutrient name as key, also column name

    return recommendResult;
    
}




/*
 当只需计算已经决定的食物的供给营养情况时，可以用这个函数
 */
-(NSMutableDictionary *) takenFoodSupplyNutrients_AbstractPerson:(NSDictionary*)params withDecidedFoods:(NSDictionary*)decidedFoodAmountDict
{
    NSNumber *nm_personCount = [params objectForKey:@"personCount"];
    uint personCount = [nm_personCount unsignedIntValue];
    assert(personCount>0);
    NSNumber *nm_dayCount = [params objectForKey:@"dayCount"];
    uint dayCount = [nm_dayCount unsignedIntValue];
    assert(dayCount>0);
    
    uint multiCount = personCount*dayCount;
    uint personDayCount = multiCount;
    NSDictionary *params2 = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithUnsignedInt:personDayCount],@"personDayCount",
                             nil];
    
    LZDataAccess *da = [LZDataAccess singleton];
    NSDictionary *DRIsDict = [da getAbstractPersonDRIsWithConsiderLoss:Config_needConsiderNutrientLoss];
    
    NSMutableDictionary *retDict = [self takenFoodSupplyNutrients:decidedFoodAmountDict andDRIs:DRIsDict andParams:params2];
    return retDict;
    
}
-(NSMutableDictionary *) takenFoodSupplyNutrients_withUserInfo:(NSDictionary*)userInfo andDecidedFoods:(NSDictionary*)decidedFoodAmountDict andOptions:(NSDictionary*)options
{
    LZDataAccess *da = [LZDataAccess singleton];
    NSDictionary *DRIsDict = [da getStandardDRIs_withUserInfo:userInfo andOptions:options];
    NSDictionary *params2 = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithUnsignedInt:1],@"personDayCount",
                             nil];
    NSMutableDictionary *retDict = [self takenFoodSupplyNutrients:decidedFoodAmountDict andDRIs:DRIsDict andParams:params2];
    return retDict;
    
}

-(NSMutableDictionary *) takenFoodSupplyNutrients:(NSDictionary*)takenFoodAmountDict andDRIs:(NSDictionary*)DRIsDict andParams:(NSDictionary*)params
{
//    if (takenFoodAmountDict == nil || takenFoodAmountDict.count == 0)
//        return nil;
    
    assert(params != nil && params.count > 0);
    int personDayCount = 1;
    NSNumber *nm_personDayCount = [params objectForKey:@"personDayCount"];
    assert(nm_personDayCount != nil);
    personDayCount = [nm_personDayCount intValue];
    assert(personDayCount>=1);
    
    NSString *colName_NO = @"NDB_No";

    
    LZDataAccess *da = [LZDataAccess singleton];
    
    
        
    NSArray *takenFoodIDs = nil;
    NSArray *takenFoodAttrAry = nil;
    if (takenFoodAmountDict != nil){
        takenFoodIDs = [takenFoodAmountDict allKeys];
        takenFoodAttrAry = [da getFoodAttributesByIds:takenFoodIDs];
    }
    
    NSMutableDictionary *nutrientSupplyDict = [NSMutableDictionary dictionaryWithDictionary:DRIsDict];
    NSArray *nutrientNames1 = [nutrientSupplyDict allKeys];
    for (int i=0; i<nutrientNames1.count; i++) {//初始化supply集合
        [nutrientSupplyDict setObject:[NSNumber numberWithDouble:0.0] forKey:nutrientNames1[i]];
    }
    

    NSMutableDictionary *takenFoodAttrDict = [NSMutableDictionary dictionaryWithCapacity:100];//key is NDB_No

    //已经吃了的各食物的各营养的量加到supply中
    if (takenFoodAttrAry != nil){
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
    }
    
    NSDictionary *nutrientInitialSupplyDict = [NSDictionary dictionaryWithDictionary:nutrientSupplyDict];//记录already taken food提供的营养素的量
    
    NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithCapacity:5];
    [retDict setObject:DRIsDict forKey:@"DRI"];//nutrient name as key, also column name
    [retDict setObject:nutrientInitialSupplyDict forKey:@"nutrientInitialSupplyDict"];
    [retDict setObject:params forKey:@"paramsDict"];
    if (takenFoodAmountDict != nil){
        [retDict setObject:takenFoodAmountDict forKey:@"TakenFoodAmount"];//food NO as key
        [retDict setObject:takenFoodAttrDict forKey:@"TakenFoodAttr"];//food NO as key
    }
    return retDict;
}

//-----------------------------------------
-(NSMutableArray*)formatFoodStandardContentForFood:(NSDictionary *)foodInfo
{
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSArray *customNutrients = [self.class getCustomNutrients];
    LZDataAccess *da = [LZDataAccess singleton];
    NSDictionary * nutrientInfoDict2Level = [da getNutrientInfoAs2LevelDictionary_withNutrientIds:customNutrients];
    for(NSString *nutrientId in customNutrients)
    {
        NSNumber *nm_foodNutrientContent = foodInfo[nutrientId];
        NSDictionary *nutrientInfoDict = nutrientInfoDict2Level[nutrientId];
        NSString *nutrientCnCaption = nutrientInfoDict[COLUMN_NAME_NutrientCnCaption];
        NSString *nutrientNutrientEnUnit = nutrientInfoDict[COLUMN_NAME_NutrientEnUnit];
        
        NSDictionary *foodStandardNutrientInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  nutrientId,COLUMN_NAME_NutrientID,
                                                  nm_foodNutrientContent,Key_foodNutrientContent,
                                                  nutrientCnCaption,Key_Name,
                                                  nutrientNutrientEnUnit,Key_Unit,
                                                  nil];
        [resultArray addObject:foodStandardNutrientInfo];
    }
    return resultArray;
}

-(NSMutableDictionary*)formatFoodsStandardContentForUI
{
    NSLog(@"formatFoodsStandardContentForUI enter");
    
    NSArray *customNutrients = [self.class getCustomNutrients];
    LZDataAccess *da = [LZDataAccess singleton];
    NSDictionary * nutrientInfoDict2Level = [da getNutrientInfoAs2LevelDictionary_withNutrientIds:customNutrients];
    
    NSMutableDictionary* formatResult = [NSMutableDictionary dictionary];
    
    NSArray * foodinfoAry = [da getAllFood];
    NSMutableDictionary *foodinfoDict = [NSMutableDictionary dictionaryWithCapacity:foodinfoAry.count];
    NSMutableDictionary *foodStandardNutrientsDataDict = [NSMutableDictionary dictionaryWithCapacity:foodinfoAry.count];
    for(int i=0; i<foodinfoAry.count; i++){
        NSDictionary *foodInfo = foodinfoAry[i];
        NSString *foodId = [foodInfo objectForKey:COLUMN_NAME_NDB_No];
        [foodinfoDict setObject:foodInfo forKey:foodId];
        
        NSMutableArray *foodStandardNutrientInfoAry = [NSMutableArray arrayWithCapacity:customNutrients.count];
        for(int j=0; j<customNutrients.count; j++){
            NSString *nutrientId = customNutrients[j];
            NSNumber *nm_foodNutrientContent = foodInfo[nutrientId];
            NSDictionary *nutrientInfoDict = nutrientInfoDict2Level[nutrientId];
            NSString *nutrientCnCaption = nutrientInfoDict[COLUMN_NAME_NutrientCnCaption];
            NSString *nutrientNutrientEnUnit = nutrientInfoDict[COLUMN_NAME_NutrientEnUnit];
            
            NSDictionary *foodStandardNutrientInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      nutrientId,COLUMN_NAME_NutrientID,
                                                      nm_foodNutrientContent,Key_foodNutrientContent,
                                                      nutrientCnCaption,Key_Name,
                                                      nutrientNutrientEnUnit,Key_Unit,
                                                      nil];
            [foodStandardNutrientInfoAry addObject:foodStandardNutrientInfo];
        }//for j
        foodStandardNutrientsDataDict[foodId] = foodStandardNutrientInfoAry;
    }//for i

    [formatResult setValue:foodinfoDict forKey:@"foodinfoDict"];
    [formatResult setValue:foodStandardNutrientsDataDict forKey:@"foodStandardNutrientsDataDict"];
    
    NSLog(@"formatFoodsStandardContentForUI exit, result=%@",formatResult);
    return formatResult;
}


-(NSMutableDictionary*)formatRecommendResultForUI:(NSMutableDictionary *)recommendResult
{
    NSLog(@"formatRecommendResultForUI enter");
    
    NSDictionary *DRIsDict = [recommendResult objectForKey:@"DRI"];//nutrient name as key, also column name
//    NSDictionary *nutrientInitialSupplyDict = [recommendResult objectForKey:@"nutrientInitialSupplyDict"];
    NSDictionary *nutrientSupplyDict = [recommendResult objectForKey:@"NutrientSupply"];//nutrient name as key, also column name
    NSDictionary *recommendFoodAmountDict = [recommendResult objectForKey:@"FoodAmount"];//food NO as key
    NSDictionary *recommendFoodAttrDict = [recommendResult objectForKey:@"FoodAttr"];//food NO as key
    
//    NSDictionary *dictNutrientLackWhenInitialTaken = [recommendResult objectForKey:@"NutrientLackWhenInitialTaken"];
//    NSDictionary *limitedNutrientDictCanBeCal = [recommendResult objectForKey:@"limitedNutrientDictCanBeCal"];
    
//    NSArray *userInfos = [recommendResult objectForKey:@"UserInfo"];
//    NSDictionary *options = [recommendResult objectForKey:@"optionsDict"];
//    NSArray *otherInfos = [recommendResult objectForKey:@"OtherInfo"];
//    NSArray *foodSupplyNutrientSeqs = [recommendResult objectForKey:@"foodSupplyNutrientSeqs"];//2D array
//    NSArray *calculationLogs = [recommendResult objectForKey:@"calculationLogs"];//2D array
    
//    NSDictionary *takenFoodAmountDict = [recommendResult objectForKey:@"TakenFoodAmount"];//food NO as key
//    NSDictionary *takenFoodAttrDict = [recommendResult objectForKey:@"TakenFoodAttr"];//food NO as key
    
    NSDictionary *params = [recommendResult objectForKey:@"paramsDict"];
    int personDayCount = 1;
    if (params != nil){
        NSNumber *nm_personDayCount = [params objectForKey:@"personDayCount"];
        assert(nm_personDayCount != nil);
        personDayCount = [nm_personDayCount intValue];
    }
    
    NSArray *customNutrients = [self.class getCustomNutrients];
    LZDataAccess *da = [LZDataAccess singleton];
    NSDictionary * nutrientInfoDict2Level = [da getNutrientInfoAs2LevelDictionary_withNutrientIds:customNutrients];

//    NSMutableDictionary* formatResult = [NSMutableDictionary dictionary];    
    NSMutableDictionary* formatResult = [self formatTakenResultForUI:recommendResult];
    
    //推荐食物
    if (recommendFoodAmountDict!=nil){
        NSArray *recommendFoodIds = [recommendFoodAmountDict allKeys];
        NSArray *orderedFoodIds = [da getOrderedFoodIds:recommendFoodIds];
        assert(recommendFoodIds.count == orderedFoodIds.count);
        
        NSMutableArray *recommendFoodInfoDictArray = [NSMutableArray array];
        for(int i=0; i<orderedFoodIds.count; i++){
            NSString *foodId = orderedFoodIds[i];
            NSDictionary *foodAttrs = recommendFoodAttrDict[foodId];
            NSNumber *nmFoodAmount = recommendFoodAmountDict[foodId];
            NSString *foodName = foodAttrs[COLUMN_NAME_CnCaption];
            NSString *foodPicPath = foodAttrs[COLUMN_NAME_PicPath];
            NSDictionary *recommendFoodInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   foodId,COLUMN_NAME_NDB_No,
                                                   foodName,Key_Name,
                                                   nmFoodAmount,Key_Amount,
                                                   foodPicPath, Key_PicturePath,
                                                   nil];
            if ([nmFoodAmount intValue]>0){//如果是小于1的double，转成整数会得到0，显示不妥
                [recommendFoodInfoDictArray addObject:recommendFoodInfoDict];
            }
        }//for
        [formatResult setValue:recommendFoodInfoDictArray forKey:Key_recommendFoodInfoDictArray];
    }
    
    //推荐后总的供给的营养比例
    NSMutableArray *nutrientTotalSupplyRateInfoArray = [NSMutableArray array];
    for(int i=0; i<customNutrients.count; i++){
        NSString *nutrientId = customNutrients[i];
        NSNumber *nm_DRI1unit = DRIsDict[nutrientId];
        NSNumber *nm_TotalSupply = nutrientSupplyDict[nutrientId];
        double supplyRate = [nm_TotalSupply doubleValue]/([nm_DRI1unit doubleValue]*personDayCount);
//        if (supplyRate>1.0)
//            supplyRate = 1.0;
        NSDictionary *nutrientInfoDict = nutrientInfoDict2Level[nutrientId];
        NSString *nutrientCnCaption = nutrientInfoDict[COLUMN_NAME_NutrientCnCaption];
        NSDictionary *nutrientTotalSupplyRateInfo= [NSDictionary dictionaryWithObjectsAndKeys:
                                                    nutrientId,COLUMN_NAME_NutrientID,
                                                    [NSNumber numberWithDouble:supplyRate],Key_nutrientInitialSupplyRate,
                                                    nutrientCnCaption,Key_Name,
                                                    nil];
        [nutrientTotalSupplyRateInfoArray addObject:nutrientTotalSupplyRateInfo];
    }
    [formatResult setValue:nutrientTotalSupplyRateInfoArray forKey:Key_nutrientTotalSupplyRateInfoArray];
    
    
    //推荐食物的每个食物的供给营养素的情况
    if (recommendFoodAmountDict!=nil){
        NSArray *recommendFoodIds = [recommendFoodAmountDict allKeys];
        NSMutableDictionary *recommendFoodNutrientInfoAryDictDict = [NSMutableDictionary dictionary];
        
        NSMutableDictionary *recommendFoodSupplyNutrientInfoAryDict = [NSMutableDictionary dictionary];
        for(int i=0; i<recommendFoodIds.count; i++){
            NSString *foodId = recommendFoodIds[i];
            NSDictionary *foodAttrs = recommendFoodAttrDict[foodId];
            NSNumber *nmFoodAmount = recommendFoodAmountDict[foodId];
            
            NSMutableArray *food1supplyNutrientArray = [NSMutableArray arrayWithCapacity:customNutrients.count];
            for(int j=0; j<customNutrients.count; j++){
                NSString *nutrientId = customNutrients[j];
                NSNumber *nm_foodNutrientContent = foodAttrs[nutrientId];
                NSNumber *nm_DRI1unit = DRIsDict[nutrientId];
                double food1Supply1NutrientAmount = [nm_foodNutrientContent doubleValue]/100.0*[nmFoodAmount doubleValue];
                double nutrientTotalDRI = [nm_DRI1unit doubleValue]*personDayCount;
                double supplyRate = food1Supply1NutrientAmount / nutrientTotalDRI;
//                if (supplyRate>1.0)
//                    supplyRate = 1.0;
                NSDictionary *nutrientInfoDict = nutrientInfoDict2Level[nutrientId];
                NSString *nutrientCnCaption = nutrientInfoDict[COLUMN_NAME_NutrientCnCaption];
                NSString *nutrientNutrientEnUnit = nutrientInfoDict[COLUMN_NAME_NutrientEnUnit];
                
                NSDictionary *food1Supply1NutrientInfo= [NSDictionary dictionaryWithObjectsAndKeys:
                                                         nutrientId,COLUMN_NAME_NutrientID,
                                                         [NSNumber numberWithDouble:food1Supply1NutrientAmount],Key_food1Supply1NutrientAmount,
                                                         [NSNumber numberWithDouble:nutrientTotalDRI],Key_nutrientTotalDRI,
                                                         [NSNumber numberWithDouble:supplyRate],Key_1foodSupply1NutrientRate,
                                                         nutrientCnCaption,Key_Name,
                                                         nutrientNutrientEnUnit,Key_Unit,
                                                         nil];
                [food1supplyNutrientArray addObject:food1Supply1NutrientInfo];
            }//for j
            recommendFoodSupplyNutrientInfoAryDict[foodId] = food1supplyNutrientArray;
        }//for i
        
        NSMutableDictionary *recommendFoodStandardNutrientInfoAryDict = [NSMutableDictionary dictionary];
        for(int i=0; i<recommendFoodIds.count; i++){
            NSString *foodId = recommendFoodIds[i];
            NSDictionary *foodAttrs = recommendFoodAttrDict[foodId];
            
            NSMutableArray *foodStandardNutrientInfoAry = [NSMutableArray arrayWithCapacity:customNutrients.count];
            for(int j=0; j<customNutrients.count; j++){
                NSString *nutrientId = customNutrients[j];
                NSNumber *nm_foodNutrientContent = foodAttrs[nutrientId];
                NSDictionary *nutrientInfoDict = nutrientInfoDict2Level[nutrientId];
                NSString *nutrientCnCaption = nutrientInfoDict[COLUMN_NAME_NutrientCnCaption];
                NSString *nutrientNutrientEnUnit = nutrientInfoDict[COLUMN_NAME_NutrientEnUnit];
                
                NSDictionary *foodStandardNutrientInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                                          nutrientId,COLUMN_NAME_NutrientID,
                                                          nm_foodNutrientContent,Key_foodNutrientContent,
                                                          nutrientCnCaption,Key_Name,
                                                          nutrientNutrientEnUnit,Key_Unit,
                                                          nil];
                [foodStandardNutrientInfoAry addObject:foodStandardNutrientInfo];
            }//for j
            recommendFoodStandardNutrientInfoAryDict[foodId] = foodStandardNutrientInfoAry;
        }//for i
        
        
        [recommendFoodNutrientInfoAryDictDict setValue:recommendFoodSupplyNutrientInfoAryDict forKey:Key_foodSupplyNutrientInfoAryDict];
        [recommendFoodNutrientInfoAryDictDict setValue:recommendFoodStandardNutrientInfoAryDict forKey:Key_foodStandardNutrientInfoAryDict];
        
        [formatResult setValue:recommendFoodNutrientInfoAryDictDict forKey:Key_recommendFoodNutrientInfoAryDictDict];
    }
    
    NSLog(@"formatRecommendResultForUI exit, result=%@",formatResult);
    return formatResult;
}


-(NSMutableDictionary*)formatTakenResultForUI:(NSMutableDictionary *)takenResult
{
    NSLog(@"formatTakenResultForUI enter");
    
    NSDictionary *DRIsDict = [takenResult objectForKey:@"DRI"];//nutrient name as key, also column name
    NSDictionary *nutrientInitialSupplyDict = [takenResult objectForKey:@"nutrientInitialSupplyDict"];
    NSDictionary *takenFoodAmountDict = [takenResult objectForKey:@"TakenFoodAmount"];//food NO as key
    NSDictionary *takenFoodAttrDict = [takenResult objectForKey:@"TakenFoodAttr"];//food NO as key
    
    NSDictionary *params = [takenResult objectForKey:@"paramsDict"];
    int personDayCount = 1;
    if (params != nil){
        NSNumber *nm_personDayCount = [params objectForKey:@"personDayCount"];
        assert(nm_personDayCount != nil);
        personDayCount = [nm_personDayCount intValue];
    }
    
    NSArray *customNutrients = [self.class getCustomNutrients];
    LZDataAccess *da = [LZDataAccess singleton];
    NSDictionary * nutrientInfoDict2Level = [da getNutrientInfoAs2LevelDictionary_withNutrientIds:customNutrients];
    
    NSMutableDictionary* formatResult = [NSMutableDictionary dictionary];
//    if (takenResult == nil)
//        return formatResult;
    
    //已经决定了的食物
    if (takenFoodAmountDict!=nil){
        NSArray *takenFoodIds = [takenFoodAmountDict allKeys];
        NSArray *orderedFoodIds = [da getOrderedFoodIds:takenFoodIds];
        assert(takenFoodIds.count == orderedFoodIds.count);
        
        //NSMutableDictionary *takenFoodInfoDict2Level = [NSMutableDictionary dictionary];
        NSMutableArray *takenFoodInfoDictArray = [NSMutableArray array];
        for(int i=0; i<orderedFoodIds.count; i++){
            NSString *foodId = orderedFoodIds[i];
            NSDictionary *foodAttrs = takenFoodAttrDict[foodId];
            NSNumber *nmFoodAmount = takenFoodAmountDict[foodId];
            NSString *foodName = foodAttrs[COLUMN_NAME_CnCaption];
            NSString *foodPicPath = foodAttrs[COLUMN_NAME_PicPath];
            NSDictionary *takenFoodInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                               foodId,COLUMN_NAME_NDB_No,
                                               foodName,Key_Name,
                                               nmFoodAmount,Key_Amount,
                                               foodPicPath, Key_PicturePath,
                                               nil];
            //[takenFoodInfoDict2Level setValue:takenFoodInfoDict forKey:foodId];
            [takenFoodInfoDictArray addObject:takenFoodInfoDict];
        }//for
        //[formatResult setValue:takenFoodInfoDict2Level forKey:Key_takenFoodInfo2LevelDict];
        [formatResult setValue:takenFoodInfoDictArray forKey:Key_takenFoodInfoDictArray];
    }
    
    //已经摄取的营养比例
    NSMutableArray *nutrientTakenRateInfoArray = [NSMutableArray array];
    for(int i=0; i<customNutrients.count; i++){
        NSString *nutrientId = customNutrients[i];
        NSNumber *nm_DRI1unit = DRIsDict[nutrientId];
        NSNumber *nm_InitialSupply = nutrientInitialSupplyDict[nutrientId];
        double supplyRate = [nm_InitialSupply doubleValue]/([nm_DRI1unit doubleValue]*personDayCount);
//        if (supplyRate>1.0)
//            supplyRate = 1.0;
        NSDictionary *nutrientInfoDict = nutrientInfoDict2Level[nutrientId];
        NSString *nutrientCnCaption = nutrientInfoDict[COLUMN_NAME_NutrientCnCaption];
        NSDictionary *nutrientTakenRateInfo= [NSDictionary dictionaryWithObjectsAndKeys:
                                              nutrientId,COLUMN_NAME_NutrientID,
                                              [NSNumber numberWithDouble:supplyRate],Key_nutrientInitialSupplyRate,
                                              nutrientCnCaption,Key_Name,
                                              nil];
        [nutrientTakenRateInfoArray addObject:nutrientTakenRateInfo];
    }
    //暂且取消这里的排序显示
//    if(TRUE){
//        [nutrientTakenRateInfoArray sortUsingComparator:(NSComparator)^(NSDictionary *nutrientTakenRateInfo1, NSDictionary *nutrientTakenRateInfo2) {
//            NSNumber *nmSupplyRate1 = nutrientTakenRateInfo1[Key_nutrientInitialSupplyRate];
//            NSNumber *nmSupplyRate2 = nutrientTakenRateInfo2[Key_nutrientInitialSupplyRate];
//            if ( [nmSupplyRate1 doubleValue] == [nmSupplyRate2 doubleValue]){
//                return NSOrderedSame;
//            }else if ( [nmSupplyRate1 doubleValue] < [nmSupplyRate2 doubleValue]){
//                return NSOrderedDescending; //NSOrderedAscending;
//            }else{
//                return NSOrderedAscending;  //NSOrderedDescending;
//            }
//        } ];
//    }

    [formatResult setValue:nutrientTakenRateInfoArray forKey:Key_nutrientTakenRateInfoArray];
    
    //已经决定了的食物的每个食物的供给营养素的情况
    if (takenFoodAmountDict!=nil){
        NSArray *takenFoodIds = [takenFoodAmountDict allKeys];
        NSMutableDictionary *takenFoodNutrientInfoAryDictDict = [NSMutableDictionary dictionary];
        
        NSMutableDictionary *takenFoodSupplyNutrientInfoAryDict = [NSMutableDictionary dictionary];
        for(int i=0; i<takenFoodIds.count; i++){
            NSString *foodId = takenFoodIds[i];
            NSDictionary *foodAttrs = takenFoodAttrDict[foodId];
            NSNumber *nmFoodAmount = takenFoodAmountDict[foodId];
            
            NSMutableArray *food1supplyNutrientArray = [NSMutableArray arrayWithCapacity:customNutrients.count];
            for(int j=0; j<customNutrients.count; j++){
                NSString *nutrientId = customNutrients[j];
                NSNumber *nm_foodNutrientContent = foodAttrs[nutrientId];
                NSNumber *nm_DRI1unit = DRIsDict[nutrientId];
                double food1Supply1NutrientAmount = [nm_foodNutrientContent doubleValue]/100.0*[nmFoodAmount doubleValue];
                double nutrientTotalDRI = [nm_DRI1unit doubleValue]*personDayCount;
                double supplyRate = food1Supply1NutrientAmount / nutrientTotalDRI;
                NSDictionary *nutrientInfoDict = nutrientInfoDict2Level[nutrientId];
                NSString *nutrientCnCaption = nutrientInfoDict[COLUMN_NAME_NutrientCnCaption];
                NSString *nutrientNutrientEnUnit = nutrientInfoDict[COLUMN_NAME_NutrientEnUnit];
                
                NSDictionary *food1Supply1NutrientInfo= [NSDictionary dictionaryWithObjectsAndKeys:
                                                         nutrientId,COLUMN_NAME_NutrientID,
                                                         [NSNumber numberWithDouble:food1Supply1NutrientAmount],Key_food1Supply1NutrientAmount,
                                                         [NSNumber numberWithDouble:nutrientTotalDRI],Key_nutrientTotalDRI,
                                                         [NSNumber numberWithDouble:supplyRate],Key_1foodSupply1NutrientRate,
                                                         nutrientCnCaption,Key_Name,
                                                         nutrientNutrientEnUnit,Key_Unit,
                                                         nil];
                [food1supplyNutrientArray addObject:food1Supply1NutrientInfo];
            }//for j
            
                        
            takenFoodSupplyNutrientInfoAryDict[foodId] = food1supplyNutrientArray;
        }//for i
        
        NSMutableDictionary *takenFoodStandardNutrientInfoAryDict = [NSMutableDictionary dictionary];
        for(int i=0; i<takenFoodIds.count; i++){
            NSString *foodId = takenFoodIds[i];
            NSDictionary *foodAttrs = takenFoodAttrDict[foodId];
            
            NSMutableArray *foodStandardNutrientInfoAry = [NSMutableArray arrayWithCapacity:customNutrients.count];
            for(int j=0; j<customNutrients.count; j++){
                NSString *nutrientId = customNutrients[j];
                NSNumber *nm_foodNutrientContent = foodAttrs[nutrientId];
                NSDictionary *nutrientInfoDict = nutrientInfoDict2Level[nutrientId];
                NSString *nutrientCnCaption = nutrientInfoDict[COLUMN_NAME_NutrientCnCaption];
                NSString *nutrientNutrientEnUnit = nutrientInfoDict[COLUMN_NAME_NutrientEnUnit];
                
                NSDictionary *foodStandardNutrientInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                                          nutrientId,COLUMN_NAME_NutrientID,
                                                          nm_foodNutrientContent,Key_foodNutrientContent,
                                                          nutrientCnCaption,Key_Name,
                                                          nutrientNutrientEnUnit,Key_Unit,
                                                          nil];
                [foodStandardNutrientInfoAry addObject:foodStandardNutrientInfo];
            }//for j
            takenFoodStandardNutrientInfoAryDict[foodId] = foodStandardNutrientInfoAry;
        }//for i
        
        
        [takenFoodNutrientInfoAryDictDict setValue:takenFoodSupplyNutrientInfoAryDict forKey:Key_foodSupplyNutrientInfoAryDict];
        [takenFoodNutrientInfoAryDictDict setValue:takenFoodStandardNutrientInfoAryDict forKey:Key_foodStandardNutrientInfoAryDict];
        
        [formatResult setValue:takenFoodNutrientInfoAryDictDict forKey:Key_takenFoodNutrientInfoAryDictDict];
    }
    NSLog(@"formatTakenResultForUI exit, result=%@",formatResult);
    return formatResult;
}

/*
 如果不传DRI，可以传userInfo。givenFoodsAmount1和givenFoodsAmount2都可选，不过如果都不传，则返回nil。
 输出： Key_orderedGivenFoodIds1, Key_orderedGivenFoodIds2, Key_orderedGivenFoodIds,
     Key_givenFoodInfoDict2Level,Key_givenFoodAttrDict2Level, Key_nutrientSupplyRateInfoArray,
     Key_takenFoodNutrientInfoAryDictDict(Key_foodSupplyNutrientInfoAryDict, Key_foodStandardNutrientInfoAryDict)
     
 */
-(NSMutableDictionary*)calculateGiveFoodsSupplyNutrientAndFormatForUI:(NSDictionary *)paramsDict
{
    NSLog(@"calculateGiveFoodsSupplyNutrientAndFormatForUI enter");
    
    NSDictionary *DRIsDict = [paramsDict objectForKey:Key_DRI];//nutrient name as key, also column name
    NSDictionary *userInfo = [paramsDict objectForKey:Key_userInfo];
    NSDictionary *givenFoodsAmount1Dict = [paramsDict objectForKey:@"givenFoodsAmount1"];//food NO as key
    NSDictionary *givenFoodsAmount2Dict = [paramsDict objectForKey:@"givenFoodsAmount2"];//food NO as key
    NSMutableDictionary *givenFoodsAmountDict = [NSMutableDictionary dictionaryWithDictionary:givenFoodsAmount1Dict];
    
    if (givenFoodsAmount2Dict.count > 0){
        NSArray *foodIds = [givenFoodsAmount2Dict allKeys];
        for(int i=0; i<foodIds.count; i++){//这样做是防止有同一个食物在不同的食物集合中出现
            NSString *foodId = foodIds[i];
            NSNumber *nmFoodAmount = [givenFoodsAmount2Dict objectForKey:foodId ];
            [LZUtility addDoubleToDictionaryItem:[nmFoodAmount doubleValue] withDictionary:givenFoodsAmountDict andKey:foodId];
        }
    }
//    if (givenFoodsAmountDict.count == 0){
//        return nil;
//    }
    NSMutableDictionary* formatResult = [NSMutableDictionary dictionary];
    LZDataAccess *da = [LZDataAccess singleton];
    if (DRIsDict == nil){
        assert(userInfo!=nil);
        DRIsDict = [da getStandardDRIs_withUserInfo:userInfo andOptions:nil];
        [formatResult setValue:DRIsDict forKey:Key_DRI];
    }
    
    NSArray *givenFoodIds = [givenFoodsAmountDict allKeys];
    NSArray *givenFoodAttrAry = [da getFoodAttributesByIds:givenFoodIds];
    NSMutableDictionary *givenFoodAttrDict2Level = [LZUtility dictionaryArrayTo2LevelDictionary_withKeyName:COLUMN_NAME_NDB_No andDicArray:givenFoodAttrAry];
    
    NSArray *customNutrients = [self.class getCustomNutrients];// 显示时将显示我们预定义的全部营养素，从而这里不用 getCalculationNutrientsForSmallIncrementLogic_withDRI ..
    NSDictionary * nutrientInfoDict2Level = [da getNutrientInfoAs2LevelDictionary_withNutrientIds:customNutrients];
    
    //对给定的食物取显示所需信息
    if (givenFoodsAmount1Dict.count > 0){
        NSArray *givenFoodIds1 = [givenFoodsAmount1Dict allKeys];
        NSArray *orderedGivenFoodIds1 = [da getOrderedFoodIds:givenFoodIds1];
        [formatResult setValue:orderedGivenFoodIds1 forKey:Key_orderedGivenFoodIds1];
    }
    if (givenFoodsAmount2Dict.count > 0){
        NSArray *givenFoodIds2 = [givenFoodsAmount2Dict allKeys];
        NSArray *orderedGivenFoodIds2 = [da getOrderedFoodIds:givenFoodIds2];
        [formatResult setValue:orderedGivenFoodIds2 forKey:Key_orderedGivenFoodIds2];
    }

    NSArray *orderedGivenFoodIds = [da getOrderedFoodIds:givenFoodIds];
    assert(givenFoodIds.count == orderedGivenFoodIds.count);
    if (orderedGivenFoodIds!=nil)
        [formatResult setValue:orderedGivenFoodIds forKey:Key_orderedGivenFoodIds];

    NSMutableDictionary *givenFoodInfoDict2Level = [NSMutableDictionary dictionary];
//    NSMutableArray *givenFoodInfoDictArray = [NSMutableArray array];
    for(int i=0; i<orderedGivenFoodIds.count; i++){
        NSString *foodId = orderedGivenFoodIds[i];
        NSDictionary *foodAttrs = givenFoodAttrDict2Level[foodId];
        NSNumber *nmFoodAmount = givenFoodsAmountDict[foodId];
        NSString *foodName = foodAttrs[COLUMN_NAME_CnCaption];
        NSString *foodPicPath = foodAttrs[COLUMN_NAME_PicPath];
        NSDictionary *foodInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                           foodId,COLUMN_NAME_NDB_No,
                                           foodName,Key_Name,
                                           nmFoodAmount,Key_Amount,
                                           foodPicPath, Key_PicturePath,
                                           nil];
        [givenFoodInfoDict2Level setValue:foodInfoDict forKey:foodId];
//        [givenFoodInfoDictArray addObject:foodInfoDict];
    }//for
    [formatResult setValue:givenFoodInfoDict2Level forKey:Key_givenFoodInfoDict2Level];
    //[formatResult setValue:takenFoodInfoDictArray forKey:Key_takenFoodInfoDictArray];
    
    //所有给定食物提供的营养比例
    NSMutableDictionary *nutrientSupplyDict = [NSMutableDictionary dictionaryWithDictionary:DRIsDict];
    NSArray *nutrientNames1 = [nutrientSupplyDict allKeys];
    for (int i=0; i<nutrientNames1.count; i++) {//初始化supply集合
        [nutrientSupplyDict setObject:[NSNumber numberWithDouble:0.0] forKey:nutrientNames1[i]];
    }
    NSMutableDictionary *localOutFoodAttrDict = [NSMutableDictionary dictionaryWithCapacity:100];//key is NDB_No
    NSMutableDictionary *l1paramsDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:localOutFoodAttrDict,@"destFoodInfoDict", nil];
    [self foodsSupplyNutrients:givenFoodAttrAry andAmounts:givenFoodsAmountDict andDestNutrientSupply:nutrientSupplyDict andOtherData:l1paramsDict];
    [formatResult setValue:nutrientSupplyDict forKey:Key_nutrientSupplyDict];
    NSMutableArray *nutrientSupplyRateInfoArray = [NSMutableArray array];
    for(int i=0; i<customNutrients.count; i++){
        NSString *nutrientId = customNutrients[i];
        NSNumber *nm_DRI1unit = DRIsDict[nutrientId];
        NSNumber *nm_Supply = nutrientSupplyDict[nutrientId];
        double supplyRate = [nm_Supply doubleValue]/([nm_DRI1unit doubleValue]);
        NSDictionary *nutrientInfoDict = nutrientInfoDict2Level[nutrientId];
        NSString *nutrientCnCaption = nutrientInfoDict[COLUMN_NAME_NutrientCnCaption];
        NSDictionary *nutrientSupplyRateInfo= [NSDictionary dictionaryWithObjectsAndKeys:
                                              nutrientId,COLUMN_NAME_NutrientID,
                                              [NSNumber numberWithDouble:supplyRate],Key_nutrientSupplyRate,
                                              nutrientCnCaption,Key_Name,
                                              nil];
        [nutrientSupplyRateInfoArray addObject:nutrientSupplyRateInfo];
    }
    [formatResult setValue:nutrientSupplyRateInfoArray forKey:Key_nutrientSupplyRateInfoArray];
    
    //已经决定了的食物的每个食物的供给营养素的情况
    NSMutableDictionary *givenFoodNutrientInfoAryDictDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *givenFoodSupplyNutrientInfoAryDict = [NSMutableDictionary dictionary];
    for(int i=0; i<givenFoodIds.count; i++){
        NSString *foodId = givenFoodIds[i];
        NSDictionary *foodAttrs = givenFoodAttrDict2Level[foodId];
        NSNumber *nmFoodAmount = givenFoodsAmountDict[foodId];
        
        NSMutableArray *food1supplyNutrientArray = [NSMutableArray arrayWithCapacity:customNutrients.count];
        for(int j=0; j<customNutrients.count; j++){
            NSString *nutrientId = customNutrients[j];
            NSNumber *nm_foodNutrientContent = foodAttrs[nutrientId];
            NSNumber *nm_DRI1unit = DRIsDict[nutrientId];
            double food1Supply1NutrientAmount = [nm_foodNutrientContent doubleValue]*[nmFoodAmount doubleValue]/100.0;
            double nutrientTotalDRI = [nm_DRI1unit doubleValue];
            double supplyRate = food1Supply1NutrientAmount / nutrientTotalDRI;
            NSDictionary *nutrientInfoDict = nutrientInfoDict2Level[nutrientId];
            NSString *nutrientCnCaption = nutrientInfoDict[COLUMN_NAME_NutrientCnCaption];
            NSString *nutrientNutrientEnUnit = nutrientInfoDict[COLUMN_NAME_NutrientEnUnit];
            
            NSDictionary *food1Supply1NutrientInfo= [NSDictionary dictionaryWithObjectsAndKeys:
                                                     nutrientId,COLUMN_NAME_NutrientID,
                                                     [NSNumber numberWithDouble:food1Supply1NutrientAmount],Key_food1Supply1NutrientAmount,
                                                     [NSNumber numberWithDouble:nutrientTotalDRI],Key_nutrientTotalDRI,
                                                     [NSNumber numberWithDouble:supplyRate],Key_1foodSupply1NutrientRate,
                                                     nutrientCnCaption,Key_Name,
                                                     nutrientNutrientEnUnit,Key_Unit,
                                                     nil];
            [food1supplyNutrientArray addObject:food1Supply1NutrientInfo];
        }//for j
        givenFoodSupplyNutrientInfoAryDict[foodId] = food1supplyNutrientArray;
    }//for i
    NSMutableDictionary *givenFoodStandardNutrientInfoAryDict = [NSMutableDictionary dictionary];
    for(int i=0; i<givenFoodIds.count; i++){
        NSString *foodId = givenFoodIds[i];
        NSDictionary *foodAttrs = givenFoodAttrDict2Level[foodId];
        
        NSMutableArray *foodStandardNutrientInfoAry = [NSMutableArray arrayWithCapacity:customNutrients.count];
        for(int j=0; j<customNutrients.count; j++){
            NSString *nutrientId = customNutrients[j];
            NSNumber *nm_foodNutrientContent = foodAttrs[nutrientId];
            NSDictionary *nutrientInfoDict = nutrientInfoDict2Level[nutrientId];
            NSString *nutrientCnCaption = nutrientInfoDict[COLUMN_NAME_NutrientCnCaption];
            NSString *nutrientNutrientEnUnit = nutrientInfoDict[COLUMN_NAME_NutrientEnUnit];
            
            NSDictionary *foodStandardNutrientInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      nutrientId,COLUMN_NAME_NutrientID,
                                                      nm_foodNutrientContent,Key_foodNutrientContent,
                                                      nutrientCnCaption,Key_Name,
                                                      nutrientNutrientEnUnit,Key_Unit,
                                                      nil];
            [foodStandardNutrientInfoAry addObject:foodStandardNutrientInfo];
        }//for j
        givenFoodStandardNutrientInfoAryDict[foodId] = foodStandardNutrientInfoAry;
    }//for i
    [givenFoodNutrientInfoAryDictDict setValue:givenFoodSupplyNutrientInfoAryDict forKey:Key_foodSupplyNutrientInfoAryDict];
    [givenFoodNutrientInfoAryDictDict setValue:givenFoodStandardNutrientInfoAryDict forKey:Key_foodStandardNutrientInfoAryDict];
    [formatResult setValue:givenFoodNutrientInfoAryDictDict forKey:Key_takenFoodNutrientInfoAryDictDict];
    
    [formatResult setValue:givenFoodAttrDict2Level forKey:Key_givenFoodAttrDict2Level];
    
    NSLog(@"calculateGiveFoodsSupplyNutrientAndFormatForUI exit, result=%@",formatResult);
    return formatResult;
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
//    NSDictionary *nutrientInitialSupplyDict = [recmdDict objectForKey:@"nutrientInitialSupplyDict"];
    NSDictionary *recommendFoodAmountDict = [recmdDict objectForKey:@"FoodAmount"];//food NO as key
    NSDictionary *recommendFoodAttrDict = [recmdDict objectForKey:@"FoodAttr"];//food NO as key
    
//    NSDictionary *dictNutrientLackWhenInitialTaken = [recmdDict objectForKey:@"NutrientLackWhenInitialTaken"];
//    NSDictionary *limitedNutrientDictCanBeCal = [recmdDict objectForKey:@"limitedNutrientDictCanBeCal"];
    
    NSArray *userInfos = [recmdDict objectForKey:@"UserInfo"];
    NSDictionary *userInfoDict = [recmdDict objectForKey:@"userInfoDict"];
    NSDictionary *options = [recmdDict objectForKey:@"optionsDict"];
    NSArray *otherInfos = [recmdDict objectForKey:@"OtherInfo"];
    NSArray *foodSupplyNutrientSeqs = [recmdDict objectForKey:@"foodSupplyNutrientSeqs"];//2D array
    NSArray *calculationLogs = [recmdDict objectForKey:@"calculationLogs"];//2D array

    NSDictionary *takenFoodAmountDict = [recmdDict objectForKey:@"TakenFoodAmount"];//food NO as key
    NSDictionary *takenFoodAttrDict = [recmdDict objectForKey:@"TakenFoodAttr"];//food NO as key
    
    NSDictionary *recommendFoodAmountDictOld = [recmdDict objectForKey:@"FoodAmountOld"];//food NO as key
    NSDictionary *recommendFoodAttrDictOld = [recmdDict objectForKey:@"FoodAttrOld"];//food NO as key
    NSDictionary *nutrientSupplyDictOld = [recmdDict objectForKey:@"NutrientSupplyOld"];//nutrient name as key, also column name
    NSArray *mergeLogs = [recmdDict objectForKey:@"mergeLogs"];
    
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
    NSArray* nutrientNamesOrdered = [self.class getDRItableNutrientsWithSameOrder];
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
        //已经摄取的各种食物具体的量和提供各种营养素的量
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
                if (nmFoodAttrValue == nil || (NSNull*)nmFoodAttrValue == [NSNull null]){//有warning没事，试过了没问题
                    //do nothing
                }else{
                    double foodSupplyNutrientAmount = [nmFoodAttrValue doubleValue]*[nmFoodAmount doubleValue]/100.0;
                    row[j+colIdx_NutrientStart] = [NSNumber numberWithDouble:foodSupplyNutrientAmount];
                }
            }//for j
            [rows addObject:row];
        }//for i
    }//if (takenFoodAmountDict != nil)
    
    
    //推荐的各种食物具体的量和提供各种营养素的量
    if (recommendFoodAmountDict!= nil){
        if (recommendFoodAmountDictOld != nil){//此时存在合并推荐食物的动作，从而foodSupplyNutrientSeqs不准，不能使用foodSupplyNutrientSeqs起排序作用。
            NSArray* recommendFoodIDs = recommendFoodAmountDict.allKeys;
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
                    if (nmFoodAttrValue == nil || (NSNull *)nmFoodAttrValue == [NSNull null]){//有warning没事，试过了没问题
                        //do nothing
                    }else{
                        double foodSupplyNutrientAmount = [nmFoodAttrValue doubleValue]*[nmFoodAmount doubleValue]/100.0;
                        row[j+colIdx_NutrientStart] = [NSNumber numberWithDouble:foodSupplyNutrientAmount];
                    }
                }//for j
                [rows addObject:row];
            }//for i
        }else{
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
                    if (nmFoodAttrValue == nil || (NSNull*)nmFoodAttrValue == [NSNull null]){//有warning没事，试过了没问题
                        //do nothing
                    }else{
                        double foodSupplyNutrientAmount = [nmFoodAttrValue doubleValue]*[nmFoodAmount doubleValue]/100.0;
                        row[j+colIdx_NutrientStart] = [NSNumber numberWithDouble:foodSupplyNutrientAmount];
                    }
                }//for j
                [rows addObject:row];
            }//for i
            assert(recommendFoodAmountDict2.count==0);
        }
    }//if (recommendFoodAmountDict!= nil)
    
    //各种食物提供各种营养素的量的合计，手动算
    NSMutableArray* rowSum = [NSMutableArray arrayWithArray:rowForInit];
    rowSum[0] = @"Sum";
    for(int j=0; j<nutrientNames.count;j++){
        double sumCol = 0.0;
        int foodRowCount = rows.count - rowIdx_foodItemStart;
        for(int i=0; i<foodRowCount; i++){
            NSNumber *nmCell = rows[i+rowIdx_foodItemStart][j+colIdx_NutrientStart] ;
            if ((NSNull*)nmCell != [NSNull null])//有warning没事，试过了没问题
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
        if (nmNutrientSupply != nil || (NSNull*)nmNutrientSupply == [NSNull null])
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
        if (nmNutrientDRI1unit != nil && (NSNull*)nmNutrientDRI1unit != [NSNull null])
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
    
//    //初始摄入各种营养素相对DRI的lack，目前没啥用
//    NSMutableArray *rowNutrientLack = [NSMutableArray arrayWithArray:rowForInit];
//    rowNutrientLack[0] = @"NutrientLack";
//    for(int i=0; i<nutrientNames.count; i++){
//        NSString *nutrientName = nutrientNames[i];
//        NSNumber *nmNutrient = [dictNutrientLackWhenInitialTaken objectForKey:nutrientName];
//        if (nmNutrient != nil && (NSNull*)nmNutrient != [NSNull null])
//            rowNutrientLack[i+colIdx_NutrientStart] = nmNutrient;
//        else
//            rowNutrientLack[i+colIdx_NutrientStart] = [NSNumber numberWithDouble:0.0];
//    }
//    [rows addObject:rowNutrientLack];
    
//    //nutrientInitialSupplyDict 初始摄入各种营养素相对DRI的比例，目前没啥用
//    NSMutableArray *rowInitSupplyRate = [NSMutableArray arrayWithArray:rowForInit];
//    rowInitSupplyRate[0] = @"InitSupplyRate";
//    for(int i=0; i<nutrientNames.count; i++){
//        NSString *nutrientName = nutrientNames[i];
//        NSNumber *nmInitSupplyNutrientAmount = [nutrientInitialSupplyDict objectForKey:nutrientName];
//        NSNumber *nmNutrientDRI1unit = [DRIsDict objectForKey:nutrientName];
//        if ([nmNutrientDRI1unit doubleValue]==0.0){
//            rowInitSupplyRate[i+colIdx_NutrientStart] = @"N/A";
//        }else{
//            double initSupplyRate = [nmInitSupplyNutrientAmount doubleValue]/([nmNutrientDRI1unit doubleValue]*personDayCount);
//            rowInitSupplyRate[i+colIdx_NutrientStart] = [NSNumber numberWithDouble:initSupplyRate];
//        }
//    }
//    [rows addObject:rowInitSupplyRate];
    
    row = [NSMutableArray arrayWithArray:rowForInit];
    row[0] = @"--------";
    [rows addObject:row];
    
    row = [NSMutableArray arrayWithArray:rowForInit];
    row[0] = @"Standard";
    [rows addObject:row];
    
    //各种食物含各种营养素的标准量
    //已摄取的各种食物含各种营养素的标准量
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
                if (nmFoodAttrValue == nil || (NSNull*)nmFoodAttrValue == [NSNull null]){
                    //do nothing
                }else{
                    row[j+colIdx_NutrientStart] = nmFoodAttrValue;
                }
            }//for j
            [rows addObject:row];
        }//for i
    }
    //推荐的各种食物含各种营养素的标准量
    if (recommendFoodAmountDictOld != nil){//此时存在合并推荐食物的动作，从而foodSupplyNutrientSeqs不准，不能使用foodSupplyNutrientSeqs起排序作用，目前foodSupplyNutrientSeqs对recommendFoodAmountDictOld起作用。
        NSArray* recommendFoodIDs = recommendFoodAmountDictOld.allKeys; // recommendFoodAmountDict.allKeys;//recommendFoodAmountDictOld 的食物种类覆盖了 recommendFoodAmountDict的。 
        for(int i=0; i<recommendFoodIDs.count; i++){
            NSString *foodID = recommendFoodIDs[i];
            NSDictionary *foodAttrs = [recommendFoodAttrDictOld objectForKey:foodID];
            row = [NSMutableArray arrayWithArray:rowForInit];
            row[0] = foodID;
            row[1] = foodAttrs[@"CnCaption"];
            row[2] = @"100";
            for(int j=0; j<nutrientNames.count;j++){
                NSString *nutrientName = nutrientNames[j];
                NSNumber *nmFoodAttrValue = [foodAttrs objectForKey:nutrientName];
                if (nmFoodAttrValue == nil || (NSNull *)nmFoodAttrValue == [NSNull null]){
                    //do nothing
                }else{
                    row[j+colIdx_NutrientStart] = nmFoodAttrValue;
                }
            }//for j
            [rows addObject:row];
        }//for i
    }else{
        if (recommendFoodAmountDict!=nil){
            NSMutableDictionary *recommendFoodAmountDict2 = [NSMutableDictionary dictionaryWithDictionary:recommendFoodAmountDict];
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
                    if (nmFoodAttrValue == nil || (NSNull*)nmFoodAttrValue == [NSNull null]){
                        //do nothing
                    }else{
                        row[j+colIdx_NutrientStart] = nmFoodAttrValue;
                    }
                }//for j
                [rows addObject:row];
                
            }//for i
            assert(recommendFoodAmountDict2.count==0);
        }
    }
    
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

    if (userInfoDict!=nil){
        [rows addObject:[LZUtility dictionaryAllToArray:userInfoDict]];
    }
    if(options != nil){
        [rows addObject:[LZUtility dictionaryAllToArray:options]];
    }
    if(params != nil){
        [rows addObject:[LZUtility dictionaryAllToArray:params]];
    }
    
    row = [NSMutableArray arrayWithArray:rowForInit];
    row[0] = @"--------foodSupplyNutrientSeqs";
    [rows addObject:row];
    [rows addObjectsFromArray:foodSupplyNutrientSeqs];
    
    row = [NSMutableArray arrayWithArray:rowForInit];
    row[0] = @"--------calculationLogs";
    [rows addObject:row];
    [rows addObjectsFromArray:calculationLogs];
    
    //也显示合并前的数据用以对比
    if (recommendFoodAmountDictOld != nil){
        row = [NSMutableArray arrayWithArray:rowForInit];
        row[0] = @"--------recommendFoodAmountDictOld, before merge, related";
        [rows addObject:row];
        
        row = [NSMutableArray arrayWithArray:rowForInit];
        for(int i=0; i<nutrientNames.count; i++){
            NSString *nutrientName = nutrientNames[i];
            row[i+colIdx_NutrientStart] = nutrientName;
        }
        [rows addObject:row];
        
        int rowIdx_foodItemStart = rows.count;
        if (takenFoodAmountDict != nil){
            NSArray* takenFoodIDs = takenFoodAmountDict.allKeys;
            //已经摄取的各种食物具体的量和提供各种营养素的量
            for(int i=0; i<takenFoodIDs.count; i++){
                NSString *foodID = takenFoodIDs[i];
                NSNumber *nmFoodAmount = [takenFoodAmountDict objectForKey:foodID];
                NSDictionary *foodAttrs = [takenFoodAttrDict objectForKey:foodID];
                row = [NSMutableArray arrayWithArray:rowForInit];
                row[0] = foodID;
                row[1] = foodAttrs[@"CnCaption"];
                row[2] = nmFoodAmount;
                for(int j=0; j<nutrientNames.count;j++){
                    NSString *nutrientName = nutrientNames[j];
                    NSNumber *nmFoodAttrValue = [foodAttrs objectForKey:nutrientName];
                    if (nmFoodAttrValue == nil || (NSNull*)nmFoodAttrValue == [NSNull null]){//有warning没事，试过了没问题
                        //do nothing
                    }else{
                        double foodSupplyNutrientAmount = [nmFoodAttrValue doubleValue]*[nmFoodAmount doubleValue]/100.0;
                        row[j+colIdx_NutrientStart] = [NSNumber numberWithDouble:foodSupplyNutrientAmount];
                    }
                }//for j
                [rows addObject:row];
            }//for i
        }//if (takenFoodAmountDict != nil)
        
        //合并前推荐的各种食物具体的量和提供各种营养素的量
        NSMutableDictionary *recommendFoodAmountDict2 = [NSMutableDictionary dictionaryWithDictionary:recommendFoodAmountDictOld];
        for(int i=0; i<foodSupplyNutrientSeqs.count; i++){//主要是按计算顺序来显示
            NSArray * foodSupplyNutrientSeq = foodSupplyNutrientSeqs[i];
            NSString *foodID = foodSupplyNutrientSeq[1];
            if([recommendFoodAmountDict2 objectForKey:foodID]==nil){
                //这种情况是一种食物在供给中出现了多次，由于计算过程在某些情况下所造成
                continue;
            }
            [recommendFoodAmountDict2 removeObjectForKey:foodID];
            
            NSNumber *nmFoodAmount = [recommendFoodAmountDictOld objectForKey:foodID];
            NSDictionary *foodAttrs = [recommendFoodAttrDictOld objectForKey:foodID];
            row = [NSMutableArray arrayWithArray:rowForInit];
            row[0] = foodID;
            row[1] = foodAttrs[@"CnCaption"];
            row[2] = nmFoodAmount;
            for(int j=0; j<nutrientNames.count;j++){
                NSString *nutrientName = nutrientNames[j];
                NSNumber *nmFoodAttrValue = [foodAttrs objectForKey:nutrientName];
                if (nmFoodAttrValue == nil || (NSNull*)nmFoodAttrValue == [NSNull null]){//有warning没事，试过了没问题
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
        rowSum[0] = @"Sum";
        for(int j=0; j<nutrientNames.count;j++){
            double sumCol = 0.0;
            int foodRowCount = rows.count - rowIdx_foodItemStart;
            for(int i=0; i<foodRowCount; i++){
                NSNumber *nmCell = rows[i+rowIdx_foodItemStart][j+colIdx_NutrientStart] ;
                if ((NSNull*)nmCell != [NSNull null])//有warning没事，试过了没问题
                    sumCol += [nmCell doubleValue];
            }//for i
            rowSum[j+colIdx_NutrientStart] = [NSNumber numberWithDouble:sumCol];
        }//for j
        [rows addObject:rowSum];
        
        //各种食物提供各种营养素的量的合计，从supply old中来
        row = [NSMutableArray arrayWithArray:rowForInit];
        row[0] = @"Supply";
        for(int i=0; i<nutrientNames.count; i++){
            NSString *nutrientName = nutrientNames[i];
            NSNumber *nmNutrientSupply = [nutrientSupplyDictOld objectForKey:nutrientName];
            if (nmNutrientSupply != nil || (NSNull*)nmNutrientSupply == [NSNull null])
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
            if (nmNutrientDRI1unit != nil && (NSNull*)nmNutrientDRI1unit != [NSNull null])
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
        
        row = [NSMutableArray arrayWithArray:rowForInit];
        row[0] = @"--------";
        [rows addObject:row];
        
        [rows addObjectsFromArray:mergeLogs];
        
        row = [NSMutableArray arrayWithArray:rowForInit];
        row[0] = @"--------";
        [rows addObject:row];

        
    }//if (recommendFoodAmountDictOld != nil) to show recommendFoodAmountDictOld related
    
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




/*
 limitRecommendFoodCount ，这个参数已经被废弃
 */
-(NSMutableString*) generateHtml_RecommendFoodForEnoughNuitrition:(NSDictionary*)recmdDict
{
    NSLog(@"generateHtml_RecommendFoodForEnoughNuitrition enter");
    
//    NSDictionary *DRIsDict = [recmdDict objectForKey:@"DRI"];//nutrient name as key, also column name
//    NSDictionary *nutrientSupplyDict = [recmdDict objectForKey:@"NutrientSupply"];//nutrient name as key, also column name
    NSDictionary *recommendFoodAmountDict = [recmdDict objectForKey:@"FoodAmount"];//food NO as key
    NSDictionary *recommendFoodAttrDict = [recmdDict objectForKey:@"FoodAttr"];//food NO as key
    
//    NSDictionary *dictNutrientLackWhenInitialTaken = [recmdDict objectForKey:@"NutrientLackWhenInitialTaken"];//to be discarded
//    NSDictionary *limitedNutrientDictCanBeCal = [recmdDict objectForKey:@"limitedNutrientDictCanBeCal"];//little use, to be discarded
    
    //NSArray *userInfos = [recmdDict objectForKey:@"UserInfo"];//2D array
//    NSDictionary *options = [recmdDict objectForKey:@"optionsDict"];
//    NSArray *foodSupplyNutrientSeqs = [recmdDict objectForKey:@"foodSupplyNutrientSeqs"];//2D array
    
    
    NSDictionary *takenFoodAmountDict = [recmdDict objectForKey:@"TakenFoodAmount"];//food NO as key
    NSDictionary *takenFoodAttrDict = [recmdDict objectForKey:@"TakenFoodAttr"];//food NO as key
    
//    NSDictionary *recommendFoodAmountDictOld = [recmdDict objectForKey:@"FoodAmountOld"];//food NO as key
//    NSDictionary *recommendFoodAttrDictOld = [recmdDict objectForKey:@"FoodAttrOld"];//food NO as key
    
    //int limitRecommendFoodCount = 0;//already discard this param
//    if ([options objectForKey:@"limitRecommendFoodCount"]!=nil){
//        NSNumber *nm_limitRecommendFoodCount = [options objectForKey:@"limitRecommendFoodCount"];
//        limitRecommendFoodCount = [nm_limitRecommendFoodCount intValue];
//    }
    
    //首补营养素是一个旧而不好的功能，去掉
//    NSMutableDictionary *foodSupplyFirstChooseNutrientLogDict = [NSMutableDictionary dictionary];
//    for (int i=0; i<foodSupplyNutrientSeqs.count; i++) {
//        NSArray *foodSupplyNutrientSeq= foodSupplyNutrientSeqs[i];
//        NSString *nutrientName = foodSupplyNutrientSeq[0];
//        NSString *foodID = foodSupplyNutrientSeq[1];
//        [foodSupplyFirstChooseNutrientLogDict setObject:nutrientName forKey:foodID];
//    }
    
    

    
    NSMutableString *strHtml = [NSMutableString stringWithCapacity:1000*1000];
    [strHtml appendString:@"<style>\n"];
    [strHtml appendString:@"td {border:1px solid;}\n"];
    [strHtml appendString:@"</style>\n"];
    [strHtml appendString:@"<body>\n"];
    
    
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
    
    
//    [strHtml appendString:@"<p>缺乏的营养素列表：</p>\n"];
//    if (dictNutrientLackWhenInitialTaken == nil || dictNutrientLackWhenInitialTaken.count == 0){
//        [strHtml appendString:@"<p>无。</p>\n"];
//    }else{
//        NSArray* nutrientNames = dictNutrientLackWhenInitialTaken.allKeys;
//        NSMutableArray* rows = [NSMutableArray arrayWithCapacity:dictNutrientLackWhenInitialTaken.count];
//        int colLen = 3;
//        for(int i=0; i<nutrientNames.count; i++){
//            NSString *nutrientName = nutrientNames[i];
//            NSNumber *nmNutrientLackVal = [dictNutrientLackWhenInitialTaken objectForKey:nutrientName];
//            NSNumber *nmNutrientDRI = [DRIsDict objectForKey:nutrientName];
//            
//            if (limitedNutrientDictCanBeCal==nil ||
//                (limitedNutrientDictCanBeCal!=nil && [limitedNutrientDictCanBeCal objectForKey:nutrientName]!=nil)
//                )
//            {//这里要考虑到需求中可能限制了营养素集合
//                if ([nmNutrientLackVal doubleValue]>Config_nearZero){
//                    double lackRatio = [nmNutrientLackVal doubleValue] / [nmNutrientDRI doubleValue];
//                    NSMutableArray* row = [LZUtility generateEmptyArray:colLen];
//                    row[0] = nutrientName;
//                    row[1] = nmNutrientLackVal;
//                    row[2] = [NSNumber numberWithDouble:lackRatio];
//                    [rows addObject:row];
//                }
//            }
//        }//for i
//        if (rows.count > 0){
//            NSString *strTbl = [LZUtility convert2DArrayToHtmlTable:rows withColumnNames:[NSArray arrayWithObjects:@"营养素", @"缺乏量", @"缺乏比例", nil]];
//            [strHtml appendString:strTbl];
//        }else{
//            [strHtml appendString:@"<p>无。</p>\n"];
//        }
//    }

    [strHtml appendString:@"<p>推荐的食物列表：</p>\n"];
    if (recommendFoodAmountDict != nil&& recommendFoodAmountDict.count>0){
        NSMutableArray* rows = [NSMutableArray arrayWithCapacity:recommendFoodAmountDict.count];
        int colLen = 4;
        
        NSArray* foodIDs = recommendFoodAmountDict.allKeys;
        for(int i=0; i<foodIDs.count; i++){
            NSString *foodID = foodIDs[i];
            NSNumber *nmFoodAmount = [recommendFoodAmountDict objectForKey:foodID];
            NSDictionary *foodAttrs = [recommendFoodAttrDict objectForKey:foodID];
            //NSString *nutrientName = [foodSupplyFirstChooseNutrientLogDict objectForKey:foodID];
            NSMutableArray* row = [LZUtility generateEmptyArray:colLen];
            row[0] = foodID;
            row[1] = foodAttrs[@"CnCaption"];
            row[2] = nmFoodAmount;
            //row[3] = nutrientName;
            [rows addObject:row];
        }//for i
        NSString *strTbl = [LZUtility convert2DArrayToHtmlTable:rows withColumnNames:[NSArray arrayWithObjects:@"食物ID", @"食物名称", @"推荐量(g)", nil]];
        
//        //这里主要是按计算顺序来显示，但是由于可能会对recommendFoodAmountDict进行合并，情况有些复杂。暂且不按计算顺序了，还是使用上面的代码直接取dict集合。
//        NSMutableDictionary *recommendFoodAmountDict2 = [NSMutableDictionary dictionaryWithDictionary:recommendFoodAmountDict];
//        for(int i=0; i<foodSupplyNutrientSeqs.count; i++){
//            NSArray * foodSupplyNutrientSeq = foodSupplyNutrientSeqs[i];
//            NSString *foodID = foodSupplyNutrientSeq[1];
//            if([recommendFoodAmountDict2 objectForKey:foodID]==nil){
//                //这种情况是一种食物在供给中出现了多次，由于计算过程在某些情况下所造成
//                continue;
//            }
//            [recommendFoodAmountDict2 removeObjectForKey:foodID];
//            
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
//        assert(recommendFoodAmountDict2.count==0);
//        NSString *strTbl = [LZUtility convert2DArrayToHtmlTable:rows withColumnNames:[NSArray arrayWithObjects:@"食物ID", @"食物名称", @"推荐量(g)", @"首补营养素", nil]];
        
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





/*
 从不同指定类别中选出一种食物取并集
 如从现有的绝大部分内部类中选 谷类及制品, 干豆类及制品, 蔬菜类及制品, 水果类及制品, "坚果、种子类",泛肉类除鱼类,乳类及制品,蛋类及制品
 中各选一个食物出来，并考虑VD、VC，然后取并集(9--10种食物)。
 然后再对每个普通营养素检查，如果存在有某个营养素的富含食物不在已选取的食物集合中出现的，则补充一种这样的富含食物。
 这样，可选食物集合与全集相比差别不大。也省去了出现多种同某些小类食物而让人感觉不合理的可能。
 
 蔬菜类分得不够细，可能选到一个不含vc的蔬菜，目前还没有特殊处理。因为如何能在一个蔬菜和一个水果中推荐好它们各自合适的量，还是个问题。
 
 返回值是一个总括型的dictionary，各个细项值才是具体的一些返回结果。
 */
-(NSDictionary*) getSomeFoodsToSupplyNutrientsCalculated2_withParams:(NSDictionary*)paramData andOptions:(NSDictionary*)options
{
    BOOL needUseNormalLimitWhenSmallIncrementLogic = Config_needUseNormalLimitWhenSmallIncrementLogic;
    if(options != nil){
        NSNumber *nmFlag_needUseNormalLimitWhenSmallIncrementLogic = [options objectForKey:LZSettingKey_needUseNormalLimitWhenSmallIncrementLogic];
        if (nmFlag_needUseNormalLimitWhenSmallIncrementLogic != nil)
            needUseNormalLimitWhenSmallIncrementLogic = [nmFlag_needUseNormalLimitWhenSmallIncrementLogic boolValue];
    }
    
    NSArray *excludeFoodIds = [paramData objectForKey:@"excludeFoodIds"];
    NSArray *nutrientNameAryToCal = [paramData objectForKey:@"nutrientNameAryToCal"];
    NSDictionary* DRIsDict = [paramData objectForKey:@"DRI"];
    assert(nutrientNameAryToCal.count>0);
    assert(DRIsDict.count>0);
    
    NSMutableArray * getFoodsLogs = [NSMutableArray arrayWithCapacity:100];
    NSMutableArray * getFoodsLog;
    NSArray * foodClassAry = [NSArray arrayWithObjects: FoodClassify_gulei, FoodClassify_gandoulei, FoodClassify_shucai, FoodClassify_shuiguo, FoodClassify_ganguo, FoodClassify_nailei, FoodClassify_danlei, nil];
    //这里需要对 FoodClassify_shucai 特殊处理，特指植物型蔬菜.目前在数据中把 FoodClassify_shucai 对应的作为植物型蔬菜
    //另外，要不要每种营养素有至少2个富含食物呢？属于猜
    //另外，要不要预算富含食物的某个上限值的量都不能满足DRI的情况，属于定量分析  TODO 从而，下面的食物的量也得考虑上限值
    NSDictionary *foodInfo_shucai, *foodInfo_shuiguo;
    LZDataAccess *da = [LZDataAccess singleton];
    NSMutableDictionary *foodInfoDict = [NSMutableDictionary dictionary];
    for(int i=0; i<foodClassAry.count; i++){
        NSString *foodClass = foodClassAry[i];
        NSDictionary *foodInfo = [da getOneFoodByFilters_withIncludeFoodClass:foodClass andExcludeFoodClass:nil andEqualClass:nil andIncludeFoodIds:nil andExcludeFoodIds:excludeFoodIds];
        assert(foodInfo!=nil);
        if ([foodClass isEqualToString:FoodClassify_shuiguo]){
            foodInfo_shuiguo = foodInfo;
        }
        NSString *foodId = [foodInfo objectForKey:COLUMN_NAME_NDB_No];
        [foodInfoDict setObject:foodInfo forKey:foodId];
        getFoodsLog = [NSMutableArray arrayWithObjects:@"getByClass",foodClass,foodId,foodInfo[COLUMN_NAME_CnCaption], nil];
        [getFoodsLogs addObject:getFoodsLog];
    }
    
    //蔬菜取两种,一种特意取普通蔬菜,在比较class时用=方式
    NSDictionary *foodInfo;
    NSString *foodClass, *foodId, *nutrient;
    NSMutableArray *exFoodIds;
    NSArray *excFoodIds, *incFoodIds;
    foodClass = FoodClassify_shucai;
    exFoodIds = [NSMutableArray arrayWithArray:foodInfoDict.allKeys];
    if (excludeFoodIds.count>0) [exFoodIds addObjectsFromArray:excludeFoodIds];
    foodInfo = [da getOneFoodByFilters_withIncludeFoodClass:nil andExcludeFoodClass:nil andEqualClass:foodClass andIncludeFoodIds:nil andExcludeFoodIds:exFoodIds];
    assert(foodInfo!=nil);
    foodInfo_shucai = foodInfo;
    foodId = [foodInfo objectForKey:COLUMN_NAME_NDB_No];
    [foodInfoDict setObject:foodInfo forKey:foodId];
    getFoodsLog = [NSMutableArray arrayWithObjects:@"getBy=Class",foodClass,foodId,foodInfo[COLUMN_NAME_CnCaption], nil];
    [getFoodsLogs addObject:getFoodsLog];
    
    foodInfo = [da getOneFoodByFilters_withIncludeFoodClass:FoodClassify_rou andExcludeFoodClass:FoodClassify_rou_shui_yu andEqualClass:nil andIncludeFoodIds:nil andExcludeFoodIds:excludeFoodIds];
    assert(foodInfo!=nil);
    foodId = [foodInfo objectForKey:COLUMN_NAME_NDB_No];
    [foodInfoDict setObject:foodInfo forKey:foodId];
    getFoodsLog = [NSMutableArray arrayWithObjects:@"getByClass_Exclude",FoodClassify_rou,foodId,foodInfo[COLUMN_NAME_CnCaption], nil];
    [getFoodsLogs addObject:getFoodsLog];
    
    //补维生素D中只有鱼类最适合，故特殊处理。从而上面选肉类的时候排除鱼类，避免一次推荐包含多种鱼。
    nutrient = NutrientId_VD;
    foodClass = FoodClassify_rou_shui_yu;
    foodInfo = [da getOneRichNutritionFood:nutrient andIncludeFoodClass:foodClass andExcludeFoodClass:nil andIncludeFoodIds:nil andExcludeFoodIds:excludeFoodIds andGetStrategy:Strategy_random];
    assert(foodInfo!=nil);
    foodId = [foodInfo objectForKey:COLUMN_NAME_NDB_No];
    [foodInfoDict setObject:foodInfo forKey:foodId];
    getFoodsLog = [NSMutableArray arrayWithObjects:@"specialForVD",nutrient,foodId,foodInfo[COLUMN_NAME_CnCaption], nil];
    [getFoodsLogs addObject:getFoodsLog];
    
    NSMutableDictionary *firstBatchFoodInfoDict = [NSMutableDictionary dictionaryWithDictionary:foodInfoDict];
    
    nutrient = NutrientId_Fiber;
    foodClass = FoodClassify_shucai;
    incFoodIds = foodInfoDict.allKeys;
    foodInfo = [da getOneRichNutritionFood:nutrient andIncludeFoodClass:foodClass andExcludeFoodClass:nil andIncludeFoodIds:incFoodIds andExcludeFoodIds:excludeFoodIds andGetStrategy:Strategy_random];
    if (foodInfo==nil){
        excFoodIds = foodInfoDict.allKeys;
        foodInfo = [da getOneRichNutritionFood:nutrient andIncludeFoodClass:foodClass andExcludeFoodClass:nil andIncludeFoodIds:nil andExcludeFoodIds:excludeFoodIds andGetStrategy:Strategy_random];
        foodId = [foodInfo objectForKey:COLUMN_NAME_NDB_No];
        [foodInfoDict setObject:foodInfo forKey:foodId];
        getFoodsLog = [NSMutableArray arrayWithObjects:@"specialForFiber",nutrient,foodId,foodInfo[COLUMN_NAME_CnCaption], nil];
        [getFoodsLogs addObject:getFoodsLog];
    }

//    NSArray * foodIds = foodInfoDict.allKeys;
//    NSArray* nutrients = nutrientNameAryToCal;
//    if (nutrients == nil) [self.class getCustomNutrients];
    NSMutableDictionary *richFoodInfoAryDict = [NSMutableDictionary dictionary];//每个营养素都记录一组富含食物,以营养素为key
    NSMutableArray *nutrientsWithoutRichFood = [NSMutableArray array];
    //看看每个营养素是否都存在一个富含该成分的食物
    NSMutableDictionary *arrangeParams = [NSMutableDictionary dictionaryWithObjectsAndKeys: foodInfoDict,@"foodInfoDict"
                                          ,nutrientNameAryToCal,@"nutrientNameAryToCal" ,getFoodsLogs,@"Out_getFoodsLogs"
                                          ,@"getFoods1 RichFor",@"logDesc" ,[NSNumber numberWithBool:FALSE],@"NeedAssertExistRichFood"
                                          ,nutrientsWithoutRichFood,@"Out_nutrientsWithoutRichFood"
                                          ,nil];
    richFoodInfoAryDict = [self arrangeFoodsToNutrientRichFoods:arrangeParams withOldRichFoodInfoAryDict:richFoodInfoAryDict];
    
    BOOL needRearrangeRichFood = false;
    if(nutrientsWithoutRichFood.count > 0){
        //如果存在某些营养素没有富含食物，则补充对应食物
        needRearrangeRichFood = true;
        for(int i=0; i<nutrientsWithoutRichFood.count; i++){
            NSString *nutrient = nutrientsWithoutRichFood[i];
            NSDictionary *foodInfo = [da getOneRichNutritionFood:nutrient andIncludeFoodClass:nil andExcludeFoodClass:nil andIncludeFoodIds:nil andExcludeFoodIds:excludeFoodIds andGetStrategy:Strategy_random];
            assert(foodInfo!=nil);
            NSString *foodId = [foodInfo objectForKey:COLUMN_NAME_NDB_No];
            assert([foodInfoDict objectForKey:foodId]==nil);
            [foodInfoDict setObject:foodInfo forKey:foodId];
            [richFoodInfoAryDict setObject:[NSArray arrayWithObjects:foodInfo, nil] forKey:nutrient];
            getFoodsLog = [NSMutableArray arrayWithObjects:@"getForNutrient",nutrient,foodId,foodInfo[COLUMN_NAME_CnCaption], nil];
            [getFoodsLogs addObject:getFoodsLog];
        }
    }
    if (needRearrangeRichFood){
        //再整理一遍使营养素对应富含食物，由于补充了几个食物进来，这几个食物也可能是别的营养素的富含食物
        NSMutableDictionary *arrangeParams = [NSMutableDictionary dictionaryWithObjectsAndKeys: foodInfoDict,@"foodInfoDict"
                                              ,nutrientNameAryToCal,@"nutrientNameAryToCal" ,getFoodsLogs,@"Out_getFoodsLogs"
                                              ,@"getFoods2 RichFor",@"logDesc" ,[NSNumber numberWithBool:TRUE],@"NeedAssertExistRichFood",  nil];
        richFoodInfoAryDict = [self arrangeFoodsToNutrientRichFoods:arrangeParams withOldRichFoodInfoAryDict:richFoodInfoAryDict];
    }
    
    //检查富含食物考虑到某种上限量的限制能否满足DRI
    int whileCount = 1;
    while(TRUE){
        NSMutableArray *nutrientsLackFood = [NSMutableArray array];
        //    NSMutableArray *nutrientsLackAmount = [NSMutableArray array];
        //找出把食物用到某种上限也没法补充够DRI的营养素
        for(int i=0; i<nutrientNameAryToCal.count; i++){
            NSString *nutrient = nutrientNameAryToCal[i];
            NSArray *richFoodInfoAry = [richFoodInfoAryDict objectForKey:nutrient];
            assert(richFoodInfoAry.count>0);
            NSNumber* nmDRI = [DRIsDict objectForKey:nutrient];
            
            double dFoodSupplyNutrientSum = 0;
            for(int j=0; j<richFoodInfoAry.count; j++){
                NSDictionary *foodInfo = richFoodInfoAry[j];
                NSNumber *nmNutrientContent = [foodInfo objectForKey:nutrient];
                NSNumber *nmFoodUpperLimit = [foodInfo objectForKey:COLUMN_NAME_Upper_Limit];
                NSNumber *nmFoodNormalLimit = [foodInfo objectForKey:COLUMN_NAME_normal_value];
                assert(nmFoodUpperLimit!=nil && nmFoodNormalLimit!=nil);
                double dFoodLimit = [nmFoodUpperLimit doubleValue];
                if (needUseNormalLimitWhenSmallIncrementLogic){
                    dFoodLimit = [nmFoodNormalLimit doubleValue];
                }
                double dSupply = [nmNutrientContent doubleValue]*dFoodLimit/100.0;
                dFoodSupplyNutrientSum += dSupply;
            }//for j
            if (dFoodSupplyNutrientSum < [nmDRI doubleValue]){
                [nutrientsLackFood addObject:nutrient];
            }
        }//for i
        if (nutrientsLackFood.count > 0){
            //如果存在补充不够的营养素，再给这些营养素补充食物
            exFoodIds = [NSMutableArray arrayWithArray:foodInfoDict.allKeys];
            if (excludeFoodIds.count>0) [exFoodIds addObjectsFromArray:excludeFoodIds];
            for(int i=0; i<nutrientsLackFood.count; i++){
                NSString *nutrient = nutrientsLackFood[i];
                NSDictionary *foodInfo = [da getOneRichNutritionFood:nutrient andIncludeFoodClass:nil andExcludeFoodClass:nil andIncludeFoodIds:nil andExcludeFoodIds:exFoodIds andGetStrategy:Strategy_random];
                assert(foodInfo!=nil);
                NSString *foodId = [foodInfo objectForKey:COLUMN_NAME_NDB_No];
//                assert([foodInfoDict objectForKey:foodId]==nil);//由于同一个食物可能富含多种营养素，从而可能根据不同营养素选到同一个食物，从而不能做这个assert
                [foodInfoDict setObject:foodInfo forKey:foodId];
                NSString *logDesc = [NSString stringWithFormat:@"add for lack Nutrient %d.",whileCount];
                getFoodsLog = [NSMutableArray arrayWithObjects:logDesc,nutrient,foodId,foodInfo[COLUMN_NAME_CnCaption], nil];
                [getFoodsLogs addObject:getFoodsLog];
            }
            
            //再整理一遍使营养素对应富含食物，由于补充了几个食物进来，这几个食物也可能是别的营养素的富含食物
            NSString *logDesc = [NSString stringWithFormat:@"getFoods-addForLack %d.",whileCount];
            NSMutableDictionary *arrangeParams = [NSMutableDictionary dictionaryWithObjectsAndKeys: foodInfoDict,@"foodInfoDict"
                                                  ,nutrientNameAryToCal,@"nutrientNameAryToCal" ,getFoodsLogs,@"Out_getFoodsLogs"
                                                  ,logDesc,@"logDesc" ,[NSNumber numberWithBool:TRUE],@"NeedAssertExistRichFood",  nil];
            richFoodInfoAryDict = [self arrangeFoodsToNutrientRichFoods:arrangeParams withOldRichFoodInfoAryDict:richFoodInfoAryDict];
        }else{
            break;
        }
        whileCount++;
    }//while(TRUE)
    
    NSMutableDictionary * retData = [NSMutableDictionary dictionary];
    [retData setObject:foodInfoDict forKey:@"foodInfoDict"];//包含所有食物
    [retData setObject:richFoodInfoAryDict forKey:@"richFoodInfoAryDict"];//把所有食物按照各个营养素做了一下整理，每个营养素对应到其中的富含食物
    [retData setObject:getFoodsLogs forKey:@"getFoodsLogs"];
    [retData setObject:foodInfo_shucai forKey:@"foodInfo_shucai"];
    [retData setObject:foodInfo_shuiguo forKey:@"foodInfo_shuiguo"];
    [retData setObject:firstBatchFoodInfoDict forKey:@"firstBatchFoodInfoDict"];
    return retData;
}

-(NSMutableDictionary*)arrangeFoodsToNutrientRichFoods:(NSDictionary*)paramData withOldRichFoodInfoAryDict:(NSDictionary*)oldRichFoodInfoAryDict
{
    NSDictionary* foodInfoDict = [paramData objectForKey:@"foodInfoDict"];
    NSArray *nutrientNameAryToCal = [paramData objectForKey:@"nutrientNameAryToCal"];
    NSMutableArray * getFoodsLogs = [paramData objectForKey:@"Out_getFoodsLogs"];
    NSString *logDesc = [paramData objectForKey:@"logDesc"];
    NSNumber *nmNeedAssertExistRichFood = [paramData objectForKey:@"NeedAssertExistRichFood"];
    assert(foodInfoDict!=nil && nutrientNameAryToCal!=nil && getFoodsLogs!=nil && logDesc!=nil && nmNeedAssertExistRichFood!=nil);
    NSMutableArray *nutrientsWithoutRichFood = [paramData objectForKey:@"Out_nutrientsWithoutRichFood"];
    
    NSString *logDescNoExist = [NSString stringWithFormat:@"%@ NoExist",logDesc];
    NSMutableDictionary* richFoodInfoAryDict = [NSMutableDictionary dictionary];
    LZDataAccess *da = [LZDataAccess singleton];
    NSArray *incFoodIds = foodInfoDict.allKeys;
    for(int i=0; i<nutrientNameAryToCal.count; i++){
        NSString *nutrient = nutrientNameAryToCal[i];

        //暂不对维生素D特殊处理，因为调整了一下鱼的普通上限，试试看
//        if ([NutrientId_VD isEqualToString:nutrient]){
//            //对维生素D目前特殊处理，因为在前面专门找了鱼类来补，有某种鱼对应维生素D
//            if (oldRichFoodInfoAryDict.count > 0){
//                NSArray *richFoodInfoAry = [oldRichFoodInfoAryDict objectForKey:NutrientId_VD];
//                assert(richFoodInfoAry.count > 0);
//                [richFoodInfoAryDict setObject:richFoodInfoAry forKey:nutrient];
//                continue;
//            }
//        }
        
        //看看每个普通营养素是否都存在一个富含该成分的食物
        NSArray * richFoodInfoAry = [da getFoodsOfRichNutritionAndIntersectGivenSet_withNutrient:nutrient andGivenFoodIds:incFoodIds];
        if ([nmNeedAssertExistRichFood boolValue]){
            assert(richFoodInfoAry.count>0);
        }
        NSMutableArray *getFoodsLog;
        if (richFoodInfoAry.count>0){
            [richFoodInfoAryDict setObject:richFoodInfoAry forKey:nutrient];
            
            getFoodsLog = [NSMutableArray arrayWithObjects:logDesc,nutrient, nil];
            for(int j=0; j<richFoodInfoAry.count; j++){
                NSDictionary *foodInfo = richFoodInfoAry[j];
                [getFoodsLog addObject:foodInfo[COLUMN_NAME_NDB_No]];
                [getFoodsLog addObject:foodInfo[COLUMN_NAME_CnCaption]];
            }
            [getFoodsLogs addObject:getFoodsLog];
        }else{
            if (nutrientsWithoutRichFood!=nil)
                [nutrientsWithoutRichFood addObject:nutrient];
            getFoodsLog = [NSMutableArray arrayWithObjects:logDescNoExist,nutrient, nil];
            [getFoodsLogs addObject:getFoodsLog];
        }

    }//for i
    return richFoodInfoAryDict;
}


/*
 options 里面用到了 needLimitNutrients 的key，现在暂且不用，有错未解决..这错应该是跟 getCustomNutrients 中注释掉的相关
 这里的输出的营养素只是用于计算的。显示的目前使用 getCustomNutrients 的即可。
 当givenNutrients不为nil时，将使用givenNutrients来限制要计算的营养素，由于在实际上一些需要排除计算的营养素已经在传入givenNutrients前就排除了，这里实际的作用是将givenNutrients排序。
 
 */
-(NSDictionary*) getCalculationNutrientsForSmallIncrementLogic_withDRI:(NSDictionary*)DRIsDict andOptions:(NSDictionary*)options andParams:(NSDictionary*)params
{
    BOOL needLimitNutrients = TRUE;//是否要根据需求限制计算的营养素集合    
//    if(options != nil){
//        NSNumber *nmFlag_needLimitNutrients = [options objectForKey:LZSettingKey_needLimitNutrients];
//        if (nmFlag_needLimitNutrients != nil)
//            needLimitNutrients = [nmFlag_needLimitNutrients boolValue];
//    }
    
    NSArray *givenNutrients = nil;
    if (params!=nil){
        givenNutrients = [params objectForKey:Key_givenNutrients];//这些营养素的意义在于只要求这些要补足，即只有它们用于计算。注意这应该是getCustomNutrients的子集
    }
    
    NSArray *customNutrients = [self.class getCustomNutrients];
    assert([LZUtility arrayContainArrayInSetWay_withOuterArray:customNutrients andInnerArray:givenNutrients]);
    
    //这里列出的营养素有专门而简单的食物补充，通过我们预置的那些食物反而不好补充
    NSArray *nutrientArrayNotCal =[NSArray arrayWithObjects:@"Water_(g)", @"Sodium_(mg)", nil];
    
//    //这里的营养素最后再计算补充
//    //    Choline_Tot_ (mg) 胆碱 最少需要187g的蛋来补充或475g黄豆，都有悖常识，似乎是极难补充
//    //    Vit_D_(µg) 只有鲤鱼等4种才有效补充
//    //    Fiber_TD_(g) 最适合的只有豆角一种 151g，其次是豆类中的绿豆 233g，蔬菜水果类中的其次是藕 776g，都有些离谱了。不过，如果固定用蔬菜水果类来补，每天3斤的量，还说得过去。另外，不同书籍对其需要量及补充食物的含量都有区别。
//    //    Calcium_(mg) 能补的食物种类虽多，但是量比较大--不过经试验特殊对待并无显著改进
//    NSMutableArray *nutrientArrayLastCal = [NSMutableArray arrayWithObjects: @"Vit_D_(µg)",@"Choline_Tot_ (mg)",@"Fiber_TD_(g)", @"Carbohydrt_(g)",@"Energ_Kcal", nil];
    
    NSMutableArray *normalNutrientsToCal = nil;
    //这是一个营养素的全集
    NSArray* nutrientNamesOrdered = [self.class getFullAndOrderedNutrients];
    NSArray* nutrientsInDRI = DRIsDict.allKeys;
    assert([LZUtility arrayEqualArrayInSetWay_withArray1:nutrientNamesOrdered andArray2:nutrientsInDRI]);
    normalNutrientsToCal = [NSMutableArray arrayWithArray:nutrientNamesOrdered];
    
    if (TRUE){//(needLimitNutrients){//如果需要使用限制集中的营养素的话
        //normalNutrientsToCal = [NSMutableArray arrayWithArray: customNutrients];//这里不使用这条语句主要是由于要利用nutrientNamesOrdered中的顺序以供后面计算用
        [LZUtility arrayIntersectSet_withArray:normalNutrientsToCal andSet:[NSSet setWithArray:customNutrients]];
    }
    
    if(givenNutrients.count > 0){
        [LZUtility arrayIntersectSet_withArray:normalNutrientsToCal andSet:[NSSet setWithArray:givenNutrients]];
    }
    
    [LZUtility arrayMinusSet_withArray:normalNutrientsToCal andMinusSet:[NSSet setWithArray:nutrientArrayNotCal]];//去掉不应计算的营养素，虽然在前面那些限制性的营养素集合中可能已经去掉了
    
    //对以前那些需最后计算的营养素暂且不管，因为算法已经改变

    NSMutableDictionary *retData = [NSMutableDictionary dictionary];
    [retData setObject:normalNutrientsToCal forKey:@"normalNutrientsToCal"];
    return retData;
}

-(void)oneFoodSupplyNutrients:(NSDictionary*)foodInfo andAmount:(double)foodAmount andDestNutrientSupply:(NSMutableDictionary*)destNutrientSupplyDict andOtherData:(NSDictionary*)otherParams
{
    NSString *foodId = [foodInfo objectForKey:COLUMN_NAME_NDB_No];
    assert(foodId!=nil);
    //这个食物的各营养的量加到supply中
    NSArray *nutrientsToSupply = [destNutrientSupplyDict allKeys];
    for(int j=0; j<nutrientsToSupply.count; j++){
        NSString *nutrient = nutrientsToSupply[j];
        NSNumber *nmNutrientContentOfFood = [foodInfo objectForKey:nutrient];
        assert(nmNutrientContentOfFood != nil);
        if ([nmNutrientContentOfFood doubleValue] != 0.0){
            double addedNutrientAmount = [nmNutrientContentOfFood doubleValue]*(foodAmount/100.0);
            [LZUtility addDoubleToDictionaryItem:addedNutrientAmount withDictionary:destNutrientSupplyDict andKey:nutrient];
        }
    }//for j
}
-(void)foodsSupplyNutrients:(NSArray*)foodInfoAry andAmounts:(NSDictionary*)foodAmountDict andDestNutrientSupply:(NSMutableDictionary*)destNutrientSupplyDict andOtherData:(NSDictionary*)otherParams
{
    NSDictionary *foodInfoDict = [LZUtility dictionaryArrayTo2LevelDictionary_withKeyName:COLUMN_NAME_NDB_No andDicArray:foodInfoAry];
    [self foodsSupplyNutrients_withAmounts:foodAmountDict andFoodInfoDict:foodInfoDict andDestNutrientSupply:destNutrientSupplyDict andOtherData:otherParams];
//    NSMutableDictionary *destFoodInfoDict = nil;
//    if (otherParams != nil){
//        destFoodInfoDict = [otherParams objectForKey:@"destFoodInfoDict"];
//    }
//    if (foodInfoAry != nil ){
//        assert(foodInfoAry.count >= foodAmountDict.count);
//        //已经吃了的各食物的各营养的量加到supply中
//        for(int i=0; i<foodInfoAry.count; i++){
//            NSDictionary *foodInfo = foodInfoAry[i];
//            NSString *foodId = [foodInfo objectForKey:COLUMN_NAME_NDB_No];
//            assert(foodId!=nil);
//            NSNumber *nmFoodAmount = nil;
//            if (foodAmountDict != nil)
//                nmFoodAmount = [foodAmountDict objectForKey:foodId];
//            double dFoodAmount = 0;
//            if (nmFoodAmount != nil)
//                dFoodAmount = [nmFoodAmount doubleValue];
//            
//            if (destFoodInfoDict!=nil){//食物信息顺便放到一个集中的dict，以便后面使用
//                [destFoodInfoDict setObject:foodInfo forKey:foodId];
//            }
//            
//            //这个食物的各营养的量加到supply中
//            [self oneFoodSupplyNutrients:foodInfo andAmount:dFoodAmount andDestNutrientSupply:destNutrientSupplyDict andOtherData:nil];
//        }//for i
//    }else{
//        assert(foodAmountDict == nil || foodAmountDict.count == 0);
//    }
}

-(void)foodsSupplyNutrients_withAmounts:(NSDictionary*)foodAmountDict andFoodInfoDict:(NSDictionary*)foodInfoDict andDestNutrientSupply:(NSMutableDictionary*)destNutrientSupplyDict andOtherData:(NSDictionary*)otherParams
{
    NSMutableDictionary *destFoodInfoDict = nil;
    if (otherParams != nil){
        destFoodInfoDict = [otherParams objectForKey:@"destFoodInfoDict"];
    }
    if (foodAmountDict.count > 0){
        assert(foodInfoDict.count >= foodAmountDict.count);
        //已经吃了的各食物的各营养的量加到supply中
        NSArray *foodIds = foodAmountDict.allKeys;
        for(int i=0; i<foodIds.count; i++){
            NSString *foodId = foodIds[i];
            NSDictionary *foodInfo = foodInfoDict[foodId];
            assert(foodInfo != nil);
            NSNumber *nmFoodAmount = [foodAmountDict objectForKey:foodId];
            assert(nmFoodAmount != nil);
            double dFoodAmount = [nmFoodAmount doubleValue];
            if (destFoodInfoDict!=nil){//食物信息顺便放到一个集中的dict，以便后面使用
                [destFoodInfoDict setObject:foodInfo forKey:foodId];
            }
            
            //这个食物的各营养的量加到supply中
            [self oneFoodSupplyNutrients:foodInfo andAmount:dFoodAmount andDestNutrientSupply:destNutrientSupplyDict andOtherData:nil];
        }//for i
    }
}






/*
 need flag Config_needConsiderNutrientLoss for getStandardDRIs_withUserInfo ..
 options contain flag LZSettingKey_needLimitNutrients, LZSettingKey_needUseLowLimitAsUnit, LZSettingKey_randSeed
 params contain Key_givenNutrients
 */
-(NSMutableDictionary *) recommendFoodBySmallIncrementWithPreIntake:(NSDictionary*)givenFoodAmountDict andUserInfo:(NSDictionary*)userInfo andOptions:(NSMutableDictionary*)options andParams:(NSDictionary*)params
{
//    BOOL needConsiderNutrientLoss = Config_needConsiderNutrientLoss;
//    if(options != nil){
//        NSNumber *nmFlag_needConsiderNutrientLoss = [options objectForKey:@"needConsiderNutrientLoss"];
//        if (nmFlag_needConsiderNutrientLoss != nil)
//            needConsiderNutrientLoss = [nmFlag_needConsiderNutrientLoss boolValue];
//    }

    LZDataAccess *da = [LZDataAccess singleton];
    NSDictionary *DRIsDict = [da getStandardDRIs_withUserInfo:userInfo andOptions:options];
    NSDictionary *DRIULsDict = [da getStandardDRIULs_withUserInfo:userInfo andOptions:options];
    NSDictionary *DRIdata = [NSDictionary dictionaryWithObjectsAndKeys: DRIsDict,Key_DRI, DRIULsDict,Key_DRIUL, nil];
    NSMutableDictionary * retData = [self recommendFoodBySmallIncrementWithPreIntake:givenFoodAmountDict andDRIdata:DRIdata andOptions:options andParams:params];
    [retData setObject:userInfo forKey:@"userInfoDict"];
    return retData;
}
/*
  渐进增量算法的主要思想是：
      先选出一定数量的属于各个种类的食物，然后根据营养素补充动态情况来不断递增动态的某个食物，直到补满DRI。
      另外，又多了一个减量算法，即对于补得太多超过dri的上限值的一些营养素，尝试减少某些食物。

目前增量算法的主要脉络：
    先选出n种食物，选的规则或方法会在下面单列出来，需要至少满足这些食物所含要计算的营养素的总和能够覆盖那些营养素的DRI。
    先对所有食物取一个初始供应量（根据标识位可以是0也可以是初始推荐量），再逐步按某种规则选出某单个食物加单位增量。
         (1)先选出最缺乏的一种营养素，
         (2)再选出一种合适的食物
             从这n种食物中选，且是富含这种营养素的食物中选，
                 有标识位控制优先从已选的富含食物中随机选，没有已选的则随机选。或者使用下面的复杂逻辑
                     如果不存在任何一种营养素的量已经超过DRI的情况，随机选一种
                     如果存在一些营养素的量已经超过DRI的情况，选一种导致超标最少的食物。
                         当超标的营养素都不存在上限时，随机选一种
                         当超标的营养素中只有一个存在上限时，
                             补充单位目标营养素导致的唯一的那个超标营养素的量增长最少的食物可以入选。
                             但是当多个营养素超标且有多个营养素存在上限时，如何定义导致超标最少呢？-- 下面的策略的总的思想是尽可能晚的突破上限。
                             对每个食物的各个这样的营养素，算出某种导致超标的指数(见2-C-rate2)，
                             取其中的最大值。
                             然后取出最大值中最小的那个食物。
         (3)给这个食物加单位增量(目前各个食物有自己的单位增量)， 然后给各营养素增加相应的供给量。
         (4)然后再选出相对DRI最缺的一种营养素 进入同于(1)的下一个同样的循环，直到都不缺为止。
 
 预选n种食物的逻辑
     首先从不同指定类别中选出一种食物取并集，
     如从现有的绝大部分内部类中选 谷类及制品, 干豆类及制品, 蔬菜类及制品, 水果类及制品, "坚果、种子类",泛肉类除鱼类,乳类及制品,蛋类及制品 等这些类中各选一个食物出来，
     特殊考虑VD选一种鱼类
     再特殊考虑其他选出某种或某些食物
     然后再对每个要计算的营养素检查，
     如果存在某个营养素的DRI还不能被达到上限量的这些食物满足时，则补充一种富含这种营养素的食物。直到所有营养素的DRI都能够被满足。

(2-C-rate2)
某种导致超标的指数 如下定义：
    这种食物导致的dest营养素的增长比例 = 增加单位量这种食物导致的dest营养素的增量 / DRI_Ofdest营养素
    这种食物导致的营养素A的超量比例 = 增加单位量这种食物导致的营养素A的增量 / (营养素A的上限 - DRI_Of营养素A)
    这种食物针对目标营养素补充导致的营养素A的超量指数 = 这种食物导致的营养素A的超量比例 / 这种食物导致的dest营养素的增长比例
    找出 这种食物针对目标营养素补充导致的营养素A的超量指数 的最大值
    再找出 最大值中的最小值，取最小值对应的食物。
        点评：这里的意思是，在使用某种食物给dest营养素进行补充带来单位增长的同时， 导致的其他已超标中的营养素往上限的增长比例的最大值尽可能小.
        这样防止某个超标营养素遥遥领先于其他营养素突破自己的上限。平均情况暂且不予考虑。
 
 options contain flag
        LZSettingKey_needLimitNutrients,
        LZSettingKey_needUseLowLimitAsUnit,
        LZSettingKey_needUseNormalLimitWhenSmallIncrementLogic,
        LZSettingKey_needUseFirstRecommendWhenSmallIncrementLogic, //注意需要预选食物没有时才有效，这是一个粗略判断，虽然预选食物少到某种程度也可以有效，但是这难以判断。
 LZSettingKey_needFirstSpecialForShucaiShuiguo, //注意当needSpecialForFirstBatchFoods 发挥作用时，它无效，因为needSpecialForFirstBatchFoods实际包含了它.而且需要VC的补充量为0时才有效。
        LZSettingKey_needSpecialForFirstBatchFoods //注意需要预选食物没有时才有效
        LZSettingKey_randSeed
 params contain Key_givenNutrients
 */
-(NSMutableDictionary *) recommendFoodBySmallIncrementWithPreIntake:(NSDictionary*)givenFoodAmountDict andDRIdata:(NSDictionary*)DRIdata andOptions:(NSMutableDictionary*)options andParams:(NSDictionary*)params
{
    
    BOOL needLimitNutrients = TRUE;//是否要根据需求限制计算的营养素集合
//    BOOL needUseFoodLimitTableWhenCal = TRUE;
    BOOL needUseLowLimitAsUnit = TRUE;// 食物的增量是使用下限值还是通用的1g的增量
    BOOL needUseNormalLimitWhenSmallIncrementLogic = Config_needUseNormalLimitWhenSmallIncrementLogic; //对于食物的限量是使用普通限制还是使用上限限制
    BOOL needUseFirstRecommendWhenSmallIncrementLogic = Config_needUseFirstRecommendWhenSmallIncrementLogic; //食物第一次的增量是否使用最初推荐量
    BOOL needFirstSpecialForShucaiShuiguo = Config_needFirstSpecialForShucaiShuiguo; //对于最开始选出来的蔬菜水果，在最开始使用最初推荐量。这被 needSpecialForFirstBatchFoods 所覆盖。
    BOOL needSpecialForFirstBatchFoods = Config_needSpecialForFirstBatchFoods; //第一批选出的食物在最开始时使用到各自的最初推荐量
    BOOL alreadyChoosedFoodHavePriority = Config_alreadyChoosedFoodHavePriority;//是否已经用过的食物优先使用
    BOOL needPriorityFoodToSpecialNutrient = Config_needPriorityFoodToSpecialNutrient; //对于某些营养素，优先使用某些种类的食物，如蔬菜
    
    BOOL needSpecialForFirstBatchFoods_applied = FALSE;
    
    uint randSeed = arc4random();
    
    if(options != nil){
        NSNumber *nmFlag_needLimitNutrients = [options objectForKey:LZSettingKey_needLimitNutrients];
        if (nmFlag_needLimitNutrients != nil)
            needLimitNutrients = [nmFlag_needLimitNutrients boolValue];
        
        NSNumber *nmFlag_needUseLowLimitAsUnit = [options objectForKey:LZSettingKey_needUseLowLimitAsUnit];
        if (nmFlag_needUseLowLimitAsUnit != nil)
            needUseLowLimitAsUnit = [nmFlag_needUseLowLimitAsUnit boolValue];

        NSNumber *nmFlag_needUseNormalLimitWhenSmallIncrementLogic = [options objectForKey:LZSettingKey_needUseNormalLimitWhenSmallIncrementLogic];
        if (nmFlag_needUseNormalLimitWhenSmallIncrementLogic != nil)
            needUseNormalLimitWhenSmallIncrementLogic = [nmFlag_needUseNormalLimitWhenSmallIncrementLogic boolValue];
        
        NSNumber *nmFlag_needUseFirstRecommendWhenSmallIncrementLogic = [options objectForKey:LZSettingKey_needUseFirstRecommendWhenSmallIncrementLogic];
        if (nmFlag_needUseFirstRecommendWhenSmallIncrementLogic != nil)
            needUseFirstRecommendWhenSmallIncrementLogic = [nmFlag_needUseFirstRecommendWhenSmallIncrementLogic boolValue];
        
        NSNumber *nmFlag_needFirstSpecialForShucaiShuiguo = [options objectForKey:LZSettingKey_needFirstSpecialForShucaiShuiguo];
        if (nmFlag_needFirstSpecialForShucaiShuiguo != nil)
            needFirstSpecialForShucaiShuiguo = [nmFlag_needFirstSpecialForShucaiShuiguo boolValue];
        
        NSNumber *nmFlag_needSpecialForFirstBatchFoods = [options objectForKey:LZSettingKey_needSpecialForFirstBatchFoods];
        if (nmFlag_needSpecialForFirstBatchFoods != nil)
            needSpecialForFirstBatchFoods = [nmFlag_needSpecialForFirstBatchFoods boolValue];
        
        NSNumber *nmFlag_alreadyChoosedFoodHavePriority = [options objectForKey:LZSettingKey_alreadyChoosedFoodHavePriority];
        if (nmFlag_alreadyChoosedFoodHavePriority != nil)
            alreadyChoosedFoodHavePriority = [nmFlag_alreadyChoosedFoodHavePriority boolValue];
        
        NSNumber *nmFlag_needPriorityFoodToSpecialNutrient = [options objectForKey:LZSettingKey_needPriorityFoodToSpecialNutrient];
        if (nmFlag_needPriorityFoodToSpecialNutrient != nil)
            needPriorityFoodToSpecialNutrient = [nmFlag_needPriorityFoodToSpecialNutrient boolValue];
        
        NSNumber *nm_randSeed = [options objectForKey:LZSettingKey_randSeed];
        if (nm_randSeed != nil && [nm_randSeed unsignedIntValue] > 0)
            randSeed = [nm_randSeed unsignedIntValue];
        else
            [options setObject:[NSNumber numberWithUnsignedInt:randSeed] forKey:LZSettingKey_randSeedOut];
    }
    
    NSLog(@"in recommendFoodBySmallIncrementWithPreIntake, randSeed=%u",randSeed);//如果某次情况需要调试，通过这个seed的设置应该可以重复当时情况
    srandom(randSeed);
    
    int defFoodIncreaseUnit = Config_defaultFoodIncreaseUnit;
    
    NSDictionary* DRIsDict = [DRIdata objectForKey:Key_DRI];
    NSDictionary* DRIULsDict = [DRIdata objectForKey:Key_DRIUL];
    
    LZDataAccess *da = [LZDataAccess singleton];
    
    NSMutableArray *calculationLogs = [NSMutableArray arrayWithCapacity:1000];
    NSMutableArray *calculationLog;
    NSMutableString *logMsg;
    
    //算出需要计算的营养素清单及预置一定的顺序
    NSDictionary *calNutrientsData = [self getCalculationNutrientsForSmallIncrementLogic_withDRI:DRIsDict andOptions:options andParams:params];
    NSMutableArray *normalNutrientsToCal = [calNutrientsData objectForKey:@"normalNutrientsToCal"];
    NSMutableArray *originalNutrientNameAryToCal = normalNutrientsToCal;

    logMsg = [NSMutableString stringWithFormat:@"normalNutrientsToCal, cnt=%d, %@",normalNutrientsToCal.count, [normalNutrientsToCal componentsJoinedByString:@","] ];
    NSLog(@"%@",logMsg);
    calculationLog = [NSMutableArray array];
    [calculationLog addObject:@"normalNutrientsToCal begin,cnt="];
    [calculationLog addObject: [NSNumber numberWithInt:normalNutrientsToCal.count]];
    [calculationLog addObjectsFromArray:normalNutrientsToCal];
    [calculationLogs addObject:calculationLog];
    
    //提前选定一些食物用于补足各项营养素，下面只是计算各个食物的量
    NSMutableDictionary *paramDataForChooseFoods = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                    originalNutrientNameAryToCal,@"nutrientNameAryToCal",
                                                    DRIsDict,@"DRI",
                                                    nil];
    if (givenFoodAmountDict.count > 0)
        [paramDataForChooseFoods setObject:[givenFoodAmountDict allKeys] forKey:@"excludeFoodIds"];
    NSDictionary* preChooseFoodsData = [self getSomeFoodsToSupplyNutrientsCalculated2_withParams:paramDataForChooseFoods andOptions:options];
    NSDictionary* preChooseFoodInfoDict = [preChooseFoodsData objectForKey:@"foodInfoDict"];
    NSDictionary* preChooseRichFoodInfoAryDict = [preChooseFoodsData objectForKey:@"richFoodInfoAryDict"];
    NSArray* getFoodsLogs = [preChooseFoodsData objectForKey:@"getFoodsLogs"];
    NSDictionary* preChooseFoodInfo_shucai = [preChooseFoodsData objectForKey:@"foodInfo_shucai"];
    NSDictionary* preChooseFoodInfo_shuiguo = [preChooseFoodsData objectForKey:@"foodInfo_shuiguo"];
    NSDictionary* firstBatchFoodInfoDict = [preChooseFoodsData objectForKey:@"firstBatchFoodInfoDict"];

    
    //预先为计算 这种食物针对目标营养素补充导致的营养素A的超量指数 准备一些可以预先计算的数据，
    //这种食物导致的营养素A的超量比例 = 增加单位量这种食物导致的营养素A的增量 / (营养素A的上限 - DRI_Of营养素A)
    //这种食物导致的dest营养素的增长比例 = 增加单位量这种食物导致的dest营养素的增量 / DRI_Ofdest营养素
    NSMutableDictionary* foodsCauseNutrientsExceedRateDict = [NSMutableDictionary dictionary ];
    NSMutableDictionary* foodsCauseNutrientsAddRateDict = [NSMutableDictionary dictionary ];
    NSArray * preChooseFoodIdAry = [preChooseFoodInfoDict allKeys];
    for(int i=0; i<preChooseFoodIdAry.count; i++){
        NSString *foodId = preChooseFoodIdAry[i];
        NSDictionary *foodInfo = [preChooseFoodInfoDict objectForKey:foodId];
        NSMutableDictionary *foodCauseNutrientsExceedRateDict = [NSMutableDictionary dictionary ];
        NSMutableDictionary *foodCauseNutrientsAddRateDict = [NSMutableDictionary dictionary ];
        for(int j=0; j<normalNutrientsToCal.count; j++){
            NSString *nutrient = normalNutrientsToCal[j];
            NSNumber *nmDRI = [DRIsDict objectForKey:nutrient];
            NSNumber *nmDRIul = [DRIULsDict objectForKey:nutrient];
            NSNumber *foodNutrientContent = [foodInfo objectForKey:nutrient];
            assert(nmDRI!=nil);
            assert(nmDRIul!=nil);
            assert(foodNutrientContent!=nil);
            if([nmDRIul doubleValue]>Config_nearZero && [nmDRI doubleValue]>Config_nearZero && [foodNutrientContent doubleValue]>Config_nearZero){
                //此营养素的DRI推荐值和上限值存在，并且食物对于此营养素的含量不为0
                //对于镁，表中标注的上限值仅表示从药理学的角度得出的摄入值，而并不包括从食物和水中摄入的量。  The ULs for magnesium represent intake from a pharmacological agent only and do not include intake from food and water.
                if (! [nutrient isEqualToString:NutrientId_Magnesium]){//对于镁元素由于源数据的原因得特殊处理
                    assert([nmDRIul doubleValue]>[nmDRI doubleValue]);
                    double nutrientExceedRate = [foodNutrientContent doubleValue]/([nmDRIul doubleValue] - [nmDRI doubleValue]);
                    [foodCauseNutrientsExceedRateDict setObject:[NSNumber numberWithDouble:nutrientExceedRate] forKey:nutrient];
                }else{
                    double nutrientExceedRate = [foodNutrientContent doubleValue]/([nmDRIul doubleValue]+[nmDRI doubleValue] - [nmDRI doubleValue]);
                    [foodCauseNutrientsExceedRateDict setObject:[NSNumber numberWithDouble:nutrientExceedRate] forKey:nutrient];
                }
            }
            if([nmDRI doubleValue]>Config_nearZero && [foodNutrientContent doubleValue]>Config_nearZero){
                //此营养素的DRI推荐值存在，并且食物对于此营养素的含量不为0
                double nutrientAddRate = [foodNutrientContent doubleValue] / [nmDRIul doubleValue];
                [foodCauseNutrientsAddRateDict setObject:[NSNumber numberWithDouble:nutrientAddRate] forKey:nutrient];
            }
        }//for j
        [foodsCauseNutrientsExceedRateDict setObject:foodCauseNutrientsExceedRateDict forKey:foodId];
        [foodsCauseNutrientsAddRateDict setObject:foodCauseNutrientsAddRateDict forKey:foodId];
    }//for i
    
    
    NSArray *takenFoodIDs = nil;
    if (givenFoodAmountDict!=nil && givenFoodAmountDict.count>0)
        takenFoodIDs = [givenFoodAmountDict allKeys];
    NSArray *takenFoodAttrAry = [da getFoodAttributesByIds:takenFoodIDs];
    
    NSMutableDictionary *recommendFoodAmountDict = [NSMutableDictionary dictionaryWithCapacity:100];//key is NDB_No
//    NSMutableDictionary *recommendFoodAttrDict = [NSMutableDictionary dictionaryWithCapacity:100];//key is NDB_No
    NSMutableDictionary *foodSupplyAmountDict = [NSMutableDictionary dictionaryWithDictionary:givenFoodAmountDict];//包括takenFoodAmountDict 和 recommendFoodAmountDict。与nutrientSupplyDict对应。
    NSMutableDictionary *nutrientSupplyDict = [NSMutableDictionary dictionaryWithDictionary:DRIsDict];
    NSArray *nutrientNames1 = [nutrientSupplyDict allKeys];
    for (int i=0; i<nutrientNames1.count; i++) {//初始化supply集合
        [nutrientSupplyDict setObject:[NSNumber numberWithDouble:0.0] forKey:nutrientNames1[i]];
    }
    
    NSMutableDictionary *takenFoodAttrDict = [NSMutableDictionary dictionaryWithCapacity:100];//key is NDB_No
    if (takenFoodAttrAry != nil ){//已经吃了的各食物的各营养的量加到supply中
        NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:takenFoodAttrDict,@"destFoodInfoDict", nil];
        [self foodsSupplyNutrients:takenFoodAttrAry andAmounts:givenFoodAmountDict andDestNutrientSupply:nutrientSupplyDict andOtherData:paramsDict];
    }//if (takenFoodAttrAry != nil )
    
    NSDictionary *nutrientInitialSupplyDict = [NSDictionary dictionaryWithDictionary:nutrientSupplyDict];//记录already taken food提供的营养素的量
    
    NSMutableArray *nutrientNameAryToCal = [NSMutableArray arrayWithArray: normalNutrientsToCal];
    NSMutableArray *nutrientNameArySupplyEnough = [NSMutableArray array];
    NSMutableArray *nutrientNameAryToUpperLimit = [NSMutableArray array];
    NSMutableArray* foodSupplyNutrientSeqs = [NSMutableArray arrayWithCapacity:100];
    NSMutableArray *alreadyReachUpperLimitFoodIds = [NSMutableArray array];
    NSMutableArray *alreadyReachNormalLimitFoodIds = [NSMutableArray array];
    
    if (needSpecialForFirstBatchFoods){
        if (givenFoodAmountDict.count == 0 && originalNutrientNameAryToCal.count>=6){
            //如果有预选食物，由于难以判断预选的多少，所以干脆认为多而不特殊的批量加上第一批。
            //如果营养素太少，又使用了第一批批量的话，可能造成即使选了1个营养素也有约6个食物来补，使人不符常理。
            needSpecialForFirstBatchFoods_applied = true;
            NSArray *foodIds = [firstBatchFoodInfoDict allKeys];
            NSMutableDictionary *firstBatchFoodAmountDict = [NSMutableDictionary dictionaryWithCapacity:foodIds.count];
            for(int i=0; i<foodIds.count; i++){
                NSString *foodId = foodIds[i];
                NSDictionary *foodInfo = firstBatchFoodInfoDict[foodId];
                NSNumber *nmFood_first_recommend = foodInfo[COLUMN_NAME_first_recommend];
                assert(nmFood_first_recommend!=nil && [nmFood_first_recommend doubleValue]>0);
                [firstBatchFoodAmountDict setObject:nmFood_first_recommend forKey:foodId];
                
                NSMutableArray *foodSupplyNutrientSeq = [NSMutableArray arrayWithCapacity:5];
                [foodSupplyNutrientSeq addObject:@""];
                [foodSupplyNutrientSeq addObject:@"special first batch food"];
                [foodSupplyNutrientSeq addObject:[foodInfo objectForKey:@"CnCaption"]];
                [foodSupplyNutrientSeq addObject:foodId];
                [foodSupplyNutrientSeq addObject:nmFood_first_recommend];
                [foodSupplyNutrientSeq addObject:[foodInfo objectForKey:@"Shrt_Desc"]];
                [foodSupplyNutrientSeq addObject:@""];
                [foodSupplyNutrientSeqs addObject:foodSupplyNutrientSeq];
                logMsg = [NSMutableString stringWithFormat:@"supply food:%@", [foodSupplyNutrientSeq componentsJoinedByString:@" , "]];
                NSLog(@"%@",logMsg);
                calculationLog = [NSMutableArray array];
                [calculationLog addObject:@"supply food:"];
                [calculationLog addObjectsFromArray:foodSupplyNutrientSeq];
                [calculationLogs addObject:calculationLog];
            }//for
            [self foodsSupplyNutrients_withAmounts:firstBatchFoodAmountDict andFoodInfoDict:preChooseFoodInfoDict andDestNutrientSupply:nutrientSupplyDict andOtherData:nil];//营养量累加
            [LZUtility addDoubleDictionaryToDictionary_withSrcAmountDictionary:firstBatchFoodAmountDict withDestDictionary:recommendFoodAmountDict];//推荐量累加
            [LZUtility addDoubleDictionaryToDictionary_withSrcAmountDictionary:firstBatchFoodAmountDict withDestDictionary:foodSupplyAmountDict];//供给量累加
        }//if (givenFoodAmountDict.count == 0 && originalNutrientNameAryToCal.count>=6)
    }//if (needSpecialForFirstBatchFoods)
    
    if (needFirstSpecialForShucaiShuiguo && !needSpecialForFirstBatchFoods_applied){
        if (originalNutrientNameAryToCal.count>=4){//为了避免所选营养素太少而推荐食物相对感觉太多的情况
            double dSupplyVC = [LZUtility getDoubleFromDictionaryItem_withDictionary:nutrientSupplyDict andKey:NutrientId_VC];
            if (dSupplyVC == 0 ){
                //由于存在少数不富含任何一种营养素的食物，这里只选富含食物就会把它们漏了。这里从返回结果中直接取。
                NSDictionary *food_shucai = preChooseFoodInfo_shucai;
                NSDictionary *food_shuiguo = preChooseFoodInfo_shuiguo;
                if (food_shucai != nil){
                    NSString *nutrientNameToCal = NutrientId_VC;
                    NSDictionary * foodToSupplyOneNutrient = food_shucai;
                    NSString *foodIdToSupply = foodToSupplyOneNutrient[COLUMN_NAME_NDB_No];
                    NSNumber *nmFood_first_recommend = foodToSupplyOneNutrient[COLUMN_NAME_first_recommend];
                    assert(nmFood_first_recommend!=nil);
                    double dFoodIncreaseUnit = [nmFood_first_recommend doubleValue];
                    
                    [self oneFoodSupplyNutrients:foodToSupplyOneNutrient andAmount:dFoodIncreaseUnit andDestNutrientSupply:nutrientSupplyDict andOtherData:nil];//营养量累加
                    [LZUtility addDoubleToDictionaryItem:dFoodIncreaseUnit withDictionary:recommendFoodAmountDict andKey:foodIdToSupply];//推荐量累加
                    [LZUtility addDoubleToDictionaryItem:dFoodIncreaseUnit withDictionary:foodSupplyAmountDict andKey:foodIdToSupply];//供给量累加
                    
                    NSMutableArray *foodSupplyNutrientSeq = [NSMutableArray arrayWithCapacity:5];
                    [foodSupplyNutrientSeq addObject:nutrientNameToCal];
                    [foodSupplyNutrientSeq addObject:@"special first for VC"];
                    [foodSupplyNutrientSeq addObject:[foodToSupplyOneNutrient objectForKey:@"CnCaption"]];
                    [foodSupplyNutrientSeq addObject:foodIdToSupply];
                    [foodSupplyNutrientSeq addObject:[NSNumber numberWithDouble:dFoodIncreaseUnit]];
                    [foodSupplyNutrientSeq addObject:[foodToSupplyOneNutrient objectForKey:@"Shrt_Desc"]];
                    [foodSupplyNutrientSeq addObject:FoodClassify_shucai];
                    [foodSupplyNutrientSeqs addObject:foodSupplyNutrientSeq];
                    logMsg = [NSMutableString stringWithFormat:@"supply food:%@", [foodSupplyNutrientSeq componentsJoinedByString:@" , "]];
                    NSLog(@"%@",logMsg);
                    calculationLog = [NSMutableArray array];
                    [calculationLog addObject:@"supply food:"];
                    [calculationLog addObjectsFromArray:foodSupplyNutrientSeq];
                    [calculationLogs addObject:calculationLog];
                }
                if (food_shuiguo != nil){
                    NSString *nutrientNameToCal = NutrientId_VC;
                    NSDictionary * foodToSupplyOneNutrient = food_shuiguo;
                    NSString *foodIdToSupply = foodToSupplyOneNutrient[COLUMN_NAME_NDB_No];
                    NSNumber *nmFood_first_recommend = foodToSupplyOneNutrient[COLUMN_NAME_first_recommend];
                    assert(nmFood_first_recommend!=nil);
                    double dFoodIncreaseUnit = [nmFood_first_recommend doubleValue];
                    
                    [self oneFoodSupplyNutrients:foodToSupplyOneNutrient andAmount:dFoodIncreaseUnit andDestNutrientSupply:nutrientSupplyDict andOtherData:nil];//营养量累加
                    [LZUtility addDoubleToDictionaryItem:dFoodIncreaseUnit withDictionary:recommendFoodAmountDict andKey:foodIdToSupply];//推荐量累加
                    [LZUtility addDoubleToDictionaryItem:dFoodIncreaseUnit withDictionary:foodSupplyAmountDict andKey:foodIdToSupply];//供给量累加
                    
                    
                    NSMutableArray *foodSupplyNutrientSeq = [NSMutableArray arrayWithCapacity:5];
                    [foodSupplyNutrientSeq addObject:nutrientNameToCal];
                    [foodSupplyNutrientSeq addObject:@"special first for VC"];
                    [foodSupplyNutrientSeq addObject:[foodToSupplyOneNutrient objectForKey:@"CnCaption"]];
                    [foodSupplyNutrientSeq addObject:foodIdToSupply];
                    [foodSupplyNutrientSeq addObject:[NSNumber numberWithDouble:dFoodIncreaseUnit]];
                    [foodSupplyNutrientSeq addObject:[foodToSupplyOneNutrient objectForKey:@"Shrt_Desc"]];
                    [foodSupplyNutrientSeq addObject:FoodClassify_shuiguo];
                    [foodSupplyNutrientSeqs addObject:foodSupplyNutrientSeq];
                    logMsg = [NSMutableString stringWithFormat:@"supply food:%@", [foodSupplyNutrientSeq componentsJoinedByString:@" , "]];
                    NSLog(@"%@",logMsg);
                    calculationLog = [NSMutableArray array];
                    [calculationLog addObject:@"supply food:"];
                    [calculationLog addObjectsFromArray:foodSupplyNutrientSeq];
                    [calculationLogs addObject:calculationLog];
                }
            }//if (dSupplyVC == 0)
        }//if (originalNutrientNameAryToCal.count>=4)
    }//needFirstSpecialForShucaiShuiguo

    //对每个还需补足的营养素进行计算
    while (TRUE) {
        NSString *nutrientNameToCal = nil;
        int idxOfNutrientNameToCal = 0;
//        NSString *typeOfNutrientNamesToCal = nil;
        double maxNutrientLackRatio = Config_nearZero;
        NSString *maxLackNutrientName = nil;
        if (nutrientNameAryToCal.count > 0){
            for(int i=nutrientNameAryToCal.count-1; i>=0; i--){//先去掉已经补满的
                NSString *nutrientName = nutrientNameAryToCal[i];
                NSNumber *nmSupplied = nutrientSupplyDict[nutrientName];
                NSNumber *nmTotalNeed1Unit = DRIsDict[nutrientName];
                NSNumber *nmDRIul = DRIULsDict[nutrientName];
                double toAdd = [nmTotalNeed1Unit doubleValue] - [nmSupplied doubleValue];
                if (toAdd <= Config_nearZero){
                    [nutrientNameAryToCal removeObjectAtIndex:i];
                    [nutrientNameArySupplyEnough addObject:nutrientName];
                    if ([nmDRIul doubleValue]>0)
                        [nutrientNameAryToUpperLimit addObject:nutrientName];
                    logMsg = [NSMutableString stringWithFormat:@"Already Full for %@, removed",nutrientName ];
                    NSLog(@"%@",logMsg);
                    calculationLog = [NSMutableArray arrayWithObjects:logMsg, nil];
                    [calculationLogs addObject:calculationLog];
                }
            }
            if (nutrientNameAryToCal.count > 0){
                logMsg = [NSMutableString stringWithFormat:@"nutrientNameAryToCal cal-ing,cnt=%d, %@",nutrientNameAryToCal.count, [nutrientNameAryToCal componentsJoinedByString:@","]];
                NSLog(@"%@",logMsg);
                calculationLog = [NSMutableArray array];
                [calculationLog addObject:@"nutrientNameAryToCal cal-ing,cnt="];
                [calculationLog addObject: [NSNumber numberWithInt:nutrientNameAryToCal.count]];
                [calculationLog addObjectsFromArray:nutrientNameAryToCal];
                [calculationLogs addObject:calculationLog];
                
                maxNutrientLackRatio = Config_nearZero;
                maxLackNutrientName = nil;
                calculationLog = [NSMutableArray arrayWithObjects:@"nutrients lack rates:", nil];
                for(int i=0; i<nutrientNameAryToCal.count; i++){//先找出最需要补的营养素,即缺乏比例最大的
                    NSString *nutrientName = nutrientNameAryToCal[i];
                    NSNumber *nmSupplied = nutrientSupplyDict[nutrientName];
                    NSNumber *nmTotalNeed1Unit = DRIsDict[nutrientName];
                    double toAdd = [nmTotalNeed1Unit doubleValue]-[nmSupplied doubleValue];
                    assert(toAdd > Config_nearZero);
                    double lackRatio = toAdd/([nmTotalNeed1Unit doubleValue]);
                    [calculationLog addObject:nutrientName];
                    [calculationLog addObject:[NSNumber numberWithDouble:lackRatio]];
                    if (lackRatio > maxNutrientLackRatio){
                        maxLackNutrientName = nutrientName;
                        maxNutrientLackRatio = lackRatio;
                        idxOfNutrientNameToCal = i;
                    }
                }
                NSLog(@"%@",[calculationLog componentsJoinedByString:@","]);
                [calculationLogs addObject:calculationLog];
                
                logMsg = [NSMutableString stringWithFormat:@"maxLackNutrientName=%@, maxNutrientLackRatio=%.2f, idxOfNutrientNameToCal=%d",maxLackNutrientName,maxNutrientLackRatio,idxOfNutrientNameToCal];
                NSLog(@"%@",logMsg);
                calculationLog = [NSMutableArray array];
                [calculationLog addObject:@"maxLackNutrientName="];
                [calculationLog addObject:maxLackNutrientName];
                [calculationLog addObject:@"maxNutrientLackRatio="];
                [calculationLog addObject:[NSNumber numberWithDouble:maxNutrientLackRatio]];
                [calculationLog addObject:@"idxOfNutrientNameToCal="];
                [calculationLog addObject:[NSNumber numberWithInt:idxOfNutrientNameToCal]];
                [calculationLog addObjectsFromArray:nutrientNameAryToCal];
                
                [calculationLogs addObject:calculationLog];
                
                nutrientNameToCal = maxLackNutrientName;//已经取到待计算的营养素，但不从待计算集合中去掉，因为一次计算未必能够补充满这种营养素，由于有上限表之类的限制。并且注意下次找到的最需补充的营养素不一定是现在这个了。
//                typeOfNutrientNamesToCal = Type_normalSet;
            }//if (nutrientNameAryToCal.count > 0) L2
        }//if (nutrientNameAryToCal.count > 0) L1
        
        if (nutrientNameToCal==nil){
            assert(nutrientNameAryToCal.count==0);
            break;
        }
        
        //当前有需要计算的营养素
//        NSNumber *nmSupplied = nutrientSupplyDict[nutrientNameToCal];
//        NSNumber *nmTotalNeed1Unit = DRIsDict[nutrientNameToCal];
//        double toAddForNutrient = [nmTotalNeed1Unit doubleValue]-[nmSupplied doubleValue];
//        assert(toAddForNutrient>Config_nearZero);
        
        
        NSArray * foodsToSupplyOneNutrient = [preChooseRichFoodInfoAryDict objectForKey:nutrientNameToCal];//找一些对于这种营养素含量最高的食物
        assert(foodsToSupplyOneNutrient!=nil && foodsToSupplyOneNutrient.count>0);
        NSDictionary *foodToSupplyOneNutrient = nil;
        NSMutableString *foundFoodWay;
        if (foodsToSupplyOneNutrient.count == 1){//只有一种富含食物时，只能选它
            foodToSupplyOneNutrient = foodsToSupplyOneNutrient[0];
            foundFoodWay = [NSMutableString stringWithString: @"only 1 food for nutrient"];
        }else{//foodsToSupplyOneNutrient.count > 1//富含食物超过一种时，需要选一种合适的
            NSMutableArray *foodIdsToSupplyOneNutrient = [LZUtility getPropertyArrayFromDictionaryArray_withPropertyName:COLUMN_NAME_NDB_No andDictionaryArray:foodsToSupplyOneNutrient];
            if (needUseNormalLimitWhenSmallIncrementLogic){
                [LZUtility arrayMinusArray_withSrcArray:foodIdsToSupplyOneNutrient andMinusArray:alreadyReachNormalLimitFoodIds];
            }else{
                [LZUtility arrayMinusArray_withSrcArray:foodIdsToSupplyOneNutrient andMinusArray:alreadyReachUpperLimitFoodIds];
            }
            
            NSMutableArray *foodIdsNotReachUpperLimit = foodIdsToSupplyOneNutrient;
            assert(foodIdsNotReachUpperLimit.count>0);//否则是前面的计算有误，因为在选食物时考虑了上限的问题
            if (foodIdsNotReachUpperLimit.count==1){
                NSString *foodIdToSupplyOneNutrient = foodIdsToSupplyOneNutrient[0];
                foodToSupplyOneNutrient = [preChooseFoodInfoDict objectForKey:foodIdToSupplyOneNutrient];
                foundFoodWay = [NSMutableString stringWithString: @"only 1 food notReach ULimit"];
                assert(foodToSupplyOneNutrient!=nil);
            }else{//foodIdsNotReachUpperLimit.count > 1
                //从多种富含此营养素的且未超数量上限的食物中选出最合适的一种
                BOOL doneUsePriorityFoodToSpecialNutrient = false;//表示是否已经取到食物了
                if (alreadyChoosedFoodHavePriority){
                    NSMutableArray *foodIdsNotReachUpperLimit_local = [NSMutableArray arrayWithArray:foodIdsNotReachUpperLimit];
                    NSArray *recommendFoodIds = [recommendFoodAmountDict allKeys];
                    NSMutableArray * foodIds_recommended_NotReachUpperLimit = [LZUtility arrayIntersectArray_withSrcArray:foodIdsNotReachUpperLimit_local andIntersectArray:recommendFoodIds];
                    if (foodIds_recommended_NotReachUpperLimit.count > 0){
                        int idx = 0;
                        long randval = 0;
                        if (foodIds_recommended_NotReachUpperLimit.count>1){
                            randval = random();
                            idx = randval % foodIds_recommended_NotReachUpperLimit.count;
                        }
                        NSString *foodId = foodIds_recommended_NotReachUpperLimit[idx];
                        foodToSupplyOneNutrient = [preChooseFoodInfoDict objectForKey:foodId];
                        assert(foodToSupplyOneNutrient!=nil);
                        foundFoodWay = [NSMutableString stringWithFormat: @"priorityFoodForAlready,%ld %d %d.",randval,foodIds_recommended_NotReachUpperLimit.count,idx];
                        doneUsePriorityFoodToSpecialNutrient = true;
                    }
                }
                
                if (!doneUsePriorityFoodToSpecialNutrient){
                    //其次优先使用蔬菜水果来补，但是脂肪除外
                    
                    BOOL canUsePriorityFoodToSpecialNutrient = false;
                    
                    //一般以蔬菜水果优先，但脂肪排除在外；另外当是纤维素时，以蔬菜水果豆类优先
                    if (needPriorityFoodToSpecialNutrient){
                        
                        NSSet * nutrientsNeedNoPriorityFood = [NSSet setWithObjects:NutrientId_Lipid, nil];//目前脂肪不该用蔬菜水果优先补充
                        canUsePriorityFoodToSpecialNutrient = ! [nutrientsNeedNoPriorityFood containsObject:nutrientNameToCal];
                        if (canUsePriorityFoodToSpecialNutrient){
                            if ([NutrientId_Fiber isEqualToString:nutrientNameToCal]){//当是纤维素时，以蔬菜水果豆类优先
                                NSArray *foodIdsOfPriority = [da getFoodIdsByFilters_withIncludeFoodClassAry: [NSArray arrayWithObjects:FoodClassify_shuiguo,FoodClassify_gandoulei, nil] andExcludeFoodClassAry:nil andIncludeEqualFoodClassAry:[NSArray arrayWithObjects:FoodClassify_shucai, nil] andIncludeFoodIds:foodIdsNotReachUpperLimit andExcludeFoodIds:nil];
                                if (foodIdsOfPriority.count >0){
                                    int idx = 0;
                                    long randval = 0;
                                    if (foodIdsOfPriority.count>1){
                                        randval = random();
                                        idx = randval % foodIdsOfPriority.count;
                                    }
                                    NSString *foodId = foodIdsOfPriority[idx];
                                    foodToSupplyOneNutrient = [preChooseFoodInfoDict objectForKey:foodId];
                                    assert(foodToSupplyOneNutrient!=nil);
                                    foundFoodWay = [NSMutableString stringWithFormat: @"priorityFoodForFiber,%ld %d %d.",randval,foodIdsOfPriority.count,idx];
                                    doneUsePriorityFoodToSpecialNutrient= true;
                                }
                            }else{//一般以蔬菜水果优先补充普通营养素,脂肪已排除在外
                                NSArray *foodIdsOfShucaiShuiguo = [da getFoodIdsByFilters_withIncludeFoodClassAry:[NSArray arrayWithObjects:FoodClassify_shuiguo, nil] andExcludeFoodClassAry:nil andIncludeEqualFoodClassAry:[NSArray arrayWithObjects:FoodClassify_shucai, nil] andIncludeFoodIds:foodIdsNotReachUpperLimit andExcludeFoodIds:nil];
                                if (foodIdsOfShucaiShuiguo.count >0){
                                    int idx = 0;
                                    long randval = 0;
                                    if (foodIdsOfShucaiShuiguo.count>1){
                                        randval = random();
                                        idx = randval % foodIdsOfShucaiShuiguo.count;
                                    }
                                    NSString *foodId = foodIdsOfShucaiShuiguo[idx];
                                    foodToSupplyOneNutrient = [preChooseFoodInfoDict objectForKey:foodId];
                                    assert(foodToSupplyOneNutrient!=nil);
                                    foundFoodWay = [NSMutableString stringWithFormat: @"priorityShucaiShuiguo,%ld %d %d.",randval,foodIdsOfShucaiShuiguo.count,idx];
                                    doneUsePriorityFoodToSpecialNutrient= true;
                                }
                            }
                        }//if (isGoodToFirstUseShucaiShuiguiToSupply)
                    }//if (needFirstUseShucaiShuiguiToSupply)
                }//if (!doneUsePriorityFoodToSpecialNutrient)

                if ( ! doneUsePriorityFoodToSpecialNutrient ){
                    //前面使用优先食物来补的条件不具备
                    if (alreadyChoosedFoodHavePriority){
                        //这种情况下简单点，随机选
                        long randval = random();
                        int idx = randval % foodIdsNotReachUpperLimit.count;
                        NSString *foodId = foodIdsNotReachUpperLimit[idx];
                        foodToSupplyOneNutrient = [preChooseFoodInfoDict objectForKey:foodId];
                        foundFoodWay = [NSMutableString stringWithFormat: @"m foods, 1stChooseAlreadyFood, random get,%ld %d %d.",randval,foodIdsNotReachUpperLimit.count,idx];
                    }else{// if (alreadyChoosedFoodHavePriority)
                        //先看看是否存在某种营养素已经超量
                        NSMutableArray *exceedDRINutrients = nutrientNameAryToUpperLimit;
                        if (exceedDRINutrients.count == 0){//目前不存在任何一种营养素的量已经超过DRI的情况，可以任取一种富含食物
                            long randval = random();
                            int idx = randval % foodIdsNotReachUpperLimit.count;
                            NSString *foodId = foodIdsNotReachUpperLimit[idx];
                            foodToSupplyOneNutrient = [preChooseFoodInfoDict objectForKey:foodId];
                            foundFoodWay = [NSMutableString stringWithFormat: @"m foods, no exceed, random get,%ld %d %d.",randval,foodIdsNotReachUpperLimit.count,idx];
                        }else {//exceedDRINutrients.count > 0 //存在有多种营养素超量，得选一种合适的富含食物
                            /*
                             取到 这种食物导致的dest营养素的增长比例 = 增加单位量这种食物导致的dest营养素的增量 / DRI_Ofdest营养素
                             取到 这种食物导致的营养素A的超量比例 = 增加单位量这种食物导致的营养素A的增量 / (营养素A的上限 - DRI_Of营养素A)
                             计算 这种食物针对目标营养素补充导致的营养素A的超量指数 = 这种食物导致的营养素A的超量比例 / 这种食物导致的dest营养素的增长比例
                             找出 这种食物针对目标营养素补充导致的营养素A的超量指数 的最大值
                             再找出 最大值中的最小值，取最小值对应的食物。
                             这些计算值目前可以预算，如果效率很低，可以考虑预算而提高效率 TODO
                             */
                            double dMinOfMaxAddCauseExceedRateForFoods = 0;
                            int foodIdx_MinAddCauseExceedRate = -1;
                            NSMutableArray * valAry_MaxAddCauseExceedRateForFood = [NSMutableArray array];
                            NSMutableArray * foodIdxAry_MinOfMaxAddCauseExceedRateForFood = [NSMutableArray array];
                            for(int i=0; i<foodIdsNotReachUpperLimit.count; i++){
                                NSString *foodId = foodIdsNotReachUpperLimit[i];
                                NSDictionary *foodInfoToSupplyOneNutrient = [preChooseFoodInfoDict objectForKey:foodId];
                                //                        NSString *foodId = [foodInfoToSupplyOneNutrient objectForKey:COLUMN_NAME_NDB_No];
                                //                        assert(foodId!=nil);
                                NSMutableDictionary *foodCauseNutrientsExceedRateDict = [foodsCauseNutrientsExceedRateDict objectForKey:foodId];
                                NSMutableDictionary *foodCauseNutrientsAddRateDict = [foodsCauseNutrientsAddRateDict objectForKey:foodId];
                                NSNumber *nmFoodCauseDestNutrientAddRate = [foodCauseNutrientsAddRateDict objectForKey:nutrientNameToCal];
                                double dMaxAddCauseExceedRateForOneFood = 0;
                                if (nmFoodCauseDestNutrientAddRate != nil){//此种食物含目标营养素
                                    for(int j=0; j<exceedDRINutrients.count; j++){
                                        NSString *exceedDRINutrient = exceedDRINutrients[j];
                                        NSNumber *nmFoodCauseNutrientExceedRate = [foodCauseNutrientsExceedRateDict objectForKey:exceedDRINutrient];
                                        if(nmFoodCauseNutrientExceedRate != nil){//当前营养素存在上限。不存在上限时认为下面的计算值为0，由于要求max，从而不必再继续计算当前营养素。
                                            assert([nmFoodCauseNutrientExceedRate doubleValue]!=0);
                                            double dFoodAddCauseExceedRate = [nmFoodCauseNutrientExceedRate doubleValue] / [nmFoodCauseDestNutrientAddRate doubleValue];
                                            if (dMaxAddCauseExceedRateForOneFood < dFoodAddCauseExceedRate){
                                                dMaxAddCauseExceedRateForOneFood = dFoodAddCauseExceedRate;
                                            }
                                        }
                                    }//for j
                                }
                                [valAry_MaxAddCauseExceedRateForFood addObject:[NSNumber numberWithDouble:dMaxAddCauseExceedRateForOneFood]];
                                if (i == 0){
                                    dMinOfMaxAddCauseExceedRateForFoods = dMaxAddCauseExceedRateForOneFood;
                                    foodIdx_MinAddCauseExceedRate = i;
                                }else{
                                    if (dMinOfMaxAddCauseExceedRateForFoods < dMaxAddCauseExceedRateForOneFood){
                                        dMinOfMaxAddCauseExceedRateForFoods = dMaxAddCauseExceedRateForOneFood;
                                        foodIdx_MinAddCauseExceedRate = i;
                                    }
                                }
                            }//for i
                            //最小值对应的食物不排除有多个的情况。把这些食物找出来
                            for(int i=0; i<valAry_MaxAddCauseExceedRateForFood.count; i++){
                                NSNumber *nmMaxAddCauseExceedRateForOneFood = valAry_MaxAddCauseExceedRateForFood[i];
                                if (dMinOfMaxAddCauseExceedRateForFoods == [nmMaxAddCauseExceedRateForOneFood doubleValue]){
                                    [foodIdxAry_MinOfMaxAddCauseExceedRateForFood addObject:[NSNumber numberWithInt:i]];
                                }
                            }
                            assert(foodIdxAry_MinOfMaxAddCauseExceedRateForFood.count > 0);
                            if (foodIdxAry_MinOfMaxAddCauseExceedRateForFood.count == 1){
                                NSNumber *nmFoodIdx = foodIdxAry_MinOfMaxAddCauseExceedRateForFood[0];
                                NSString *foodId = foodIdsNotReachUpperLimit[[nmFoodIdx intValue]];
                                foodToSupplyOneNutrient = [preChooseFoodInfoDict objectForKey:foodId];
                                //                        foodToSupplyOneNutrient = [foodsToSupplyOneNutrient objectAtIndex:[nmFoodIdx intValue]];
                                foundFoodWay = [NSMutableString stringWithString: @"m foods, have exceed, min 1"];
                            }else{
                                long randval = random();
                                int idx = randval % foodIdxAry_MinOfMaxAddCauseExceedRateForFood.count;
                                NSNumber *nmFoodIdx = foodIdxAry_MinOfMaxAddCauseExceedRateForFood[idx];
                                NSString *foodId = foodIdsNotReachUpperLimit[[nmFoodIdx intValue]];
                                foodToSupplyOneNutrient = [preChooseFoodInfoDict objectForKey:foodId];
                                //                        foodToSupplyOneNutrient = [foodsToSupplyOneNutrient objectAtIndex:[nmFoodIdx intValue]];
                                foundFoodWay = [NSMutableString stringWithFormat: @"m foods, have exceed, min m, random get %ld %d %d.",randval,foodIdxAry_MinOfMaxAddCauseExceedRateForFood.count,idx];
                            }
                        }//else exceedDRINutrients.count > 0 //存在有多种营养素超量，得选一种合适的富含食物
                    }//not if (alreadyChoosedFoodHavePriority)
                }//if ( ! doneUsePriorityFoodToSpecialNutrient )
            }//foodIdsNotReachUpperLimit.count > 1
        }//else foodsToSupplyOneNutrient.count > 1 //富含食物超过一种时，需要选一种合适的
        //在上面的为某种营养素找一种食物的计算过程中，当有多种食物可选时，暂且不考虑食物的上限限制
        assert(foodToSupplyOneNutrient!=nil);

        //取到一个food，来计算补这种营养素，以及顺便补其他营养素
        NSString *foodIdToSupply = foodToSupplyOneNutrient[COLUMN_NAME_NDB_No];
        
        NSNumber* nmNutrientContentOfFood = [foodToSupplyOneNutrient objectForKey:nutrientNameToCal];
        assert([nmNutrientContentOfFood doubleValue]>0.0);//确认选出的这个食物含这种营养素
        double dFoodIncreaseUnit = defFoodIncreaseUnit;
        if (needUseLowLimitAsUnit){
            NSNumber *nmFoodLowerLimit = foodToSupplyOneNutrient[COLUMN_NAME_Lower_Limit];
            assert(nmFoodLowerLimit!=nil);
            dFoodIncreaseUnit = [nmFoodLowerLimit doubleValue];
        }
        if(needUseFirstRecommendWhenSmallIncrementLogic && (givenFoodAmountDict.count == 0) ){
            NSNumber *nmFood_first_recommend = foodToSupplyOneNutrient[COLUMN_NAME_first_recommend];
            assert(nmFood_first_recommend!=nil);
            double foodAlreadyAmount = [LZUtility getDoubleFromDictionaryItem_withDictionary:foodSupplyAmountDict andKey:foodIdToSupply];
            if (foodAlreadyAmount == 0)
                dFoodIncreaseUnit = [nmFood_first_recommend doubleValue];
        }
        //这个食物的各营养的量加到supply中
        [self oneFoodSupplyNutrients:foodToSupplyOneNutrient andAmount:dFoodIncreaseUnit andDestNutrientSupply:nutrientSupplyDict andOtherData:nil];
    
        [LZUtility addDoubleToDictionaryItem:dFoodIncreaseUnit withDictionary:recommendFoodAmountDict andKey:foodIdToSupply];//推荐量累加
        [LZUtility addDoubleToDictionaryItem:dFoodIncreaseUnit withDictionary:foodSupplyAmountDict andKey:foodIdToSupply];//供给量累加
        NSNumber *nmAmountOfCurrentRecFood = [recommendFoodAmountDict objectForKey:foodIdToSupply];
        NSNumber *nmUpperLimitOfCurrentRecFood = foodToSupplyOneNutrient[COLUMN_NAME_Upper_Limit];
        double dCurrentToUpperLimit = [nmUpperLimitOfCurrentRecFood doubleValue]- [nmAmountOfCurrentRecFood doubleValue];
        if (dCurrentToUpperLimit < Config_nearZero){
            [alreadyReachUpperLimitFoodIds addObject:foodIdToSupply];
        }
        NSNumber *nmNormalLimitOfCurrentRecFood = foodToSupplyOneNutrient[COLUMN_NAME_normal_value];
        double dCurrentToNormalLimit = [nmNormalLimitOfCurrentRecFood doubleValue]- [nmAmountOfCurrentRecFood doubleValue];
        if (dCurrentToNormalLimit < Config_nearZero){
            [alreadyReachNormalLimitFoodIds addObject:foodIdToSupply];
        }
    
        NSMutableArray *foodSupplyNutrientSeq = [NSMutableArray arrayWithCapacity:5];
        [foodSupplyNutrientSeq addObject:nutrientNameToCal];
        [foodSupplyNutrientSeq addObject:[NSNumber numberWithDouble:maxNutrientLackRatio]];
        [foodSupplyNutrientSeq addObject:[foodToSupplyOneNutrient objectForKey:@"CnCaption"]];
        [foodSupplyNutrientSeq addObject:foodIdToSupply];
        [foodSupplyNutrientSeq addObject:[NSNumber numberWithDouble:dFoodIncreaseUnit]];
        [foodSupplyNutrientSeq addObject:[foodToSupplyOneNutrient objectForKey:@"Shrt_Desc"]];
        [foodSupplyNutrientSeq addObject:foundFoodWay];
        [foodSupplyNutrientSeqs addObject:foodSupplyNutrientSeq];
        logMsg = [NSMutableString stringWithFormat:@"supply food:%@", [foodSupplyNutrientSeq componentsJoinedByString:@" , "]];
        NSLog(@"%@",logMsg);
        calculationLog = [NSMutableArray array];
        [calculationLog addObject:@"supply food:"];
        [calculationLog addObjectsFromArray:foodSupplyNutrientSeq];
        [calculationLogs addObject:calculationLog];
        
    }//while (nutrientNameAryToCal.count > 0)
    
    for (id key in recommendFoodAmountDict) {
        NSNumber *nmRecAmount = recommendFoodAmountDict[key];
        assert([nmRecAmount doubleValue]>0);
    }
    
    NSLog(@"recommendFoodForEnoughNuitrition foodSupplyNutrientSeqs=\n%@",foodSupplyNutrientSeqs);
    NSLog(@"recommendFoodForEnoughNuitrition nutrientSupplyDict=\n%@, recommendFoodAmountDict=\n%@",nutrientSupplyDict,recommendFoodAmountDict);
    
    NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithCapacity:5];
    [retDict setObject:DRIsDict forKey:Key_DRI];//nutrient name as key, also column name
    [retDict setObject:DRIULsDict forKey:Key_DRIUL];//nutrient name as key, also column name
    [retDict setObject:nutrientInitialSupplyDict forKey:@"nutrientInitialSupplyDict"];
    [retDict setObject:nutrientSupplyDict forKey:Key_nutrientSupplyDict];//nutrient name as key, also column name
    [retDict setObject:foodSupplyAmountDict forKey:@"foodSupplyAmountDict"];
    [retDict setObject:recommendFoodAmountDict forKey:Key_recommendFoodAmountDict];//food NO as key
//    [retDict setObject:recommendFoodAttrDict forKey:@"FoodAttr"];//food NO as key
    
    [retDict setObject:preChooseFoodInfoDict forKey:Key_preChooseFoodInfoDict];
    [retDict setObject:preChooseRichFoodInfoAryDict forKey:Key_preChooseRichFoodInfoAryDict];
    [retDict setObject:getFoodsLogs forKey:@"getFoodsLogs"];
//    [retDict addEntriesFromDictionary:preChooseFoodsData];


    [retDict setObject:originalNutrientNameAryToCal forKey:Key_originalNutrientNameAryToCal];

    [retDict setObject:options forKey:Key_optionsDict];
//    [retDict setObject:params forKey:@"paramsDict"];
    [retDict setObject:foodSupplyNutrientSeqs forKey:@"foodSupplyNutrientSeqs"];//2D array
    [retDict setObject:calculationLogs forKey:@"calculationLogs"];//2D array
    
    
//    NSArray *otherInfos = [NSArray arrayWithObjects:@"randSeed",[NSNumber numberWithUnsignedInt:randSeed],
//                           @"needLimitNutrients",[NSNumber numberWithBool:needLimitNutrients],
//                           @"needUseLowLimitAsUnit",[NSNumber numberWithBool:needUseLowLimitAsUnit],
//                           nil];
//    [retDict setObject:otherInfos forKey:@"OtherInfo"];
    
    if (givenFoodAmountDict != nil && givenFoodAmountDict.count>0){
        [retDict setObject:givenFoodAmountDict forKey:Key_TakenFoodAmount];//food NO as key
        [retDict setObject:takenFoodAttrDict forKey:Key_TakenFoodAttr];//food NO as key
    }
    
    [self reduceFoodsToNotExceed_ecommendFoodBySmallIncrement:retDict];
    
    return retDict;

}

/*
减量算法的主要逻辑是
    找出超过DRI的上限的那些营养素。后来也包括超过DRI的营养素，不过优先级靠后。
    对每个这样的营养素，尝试对其富含的那些食物的每个食物进行计算，
        计算其能否被减少，最多能减多少
        目前的策略是一次减到底
        有可以减的食物，则减去计算出的量，再循环，全部重新计算。直到没有一个食物能够减量，此时计算结束。
 
 */
-(void)reduceFoodsToNotExceed_ecommendFoodBySmallIncrement:(NSMutableDictionary*)recmdDict
{
    NSDictionary *DRIsDict = [recmdDict objectForKey:Key_DRI];//nutrient name as key, also column name
    NSDictionary *DRIULsDict = [recmdDict objectForKey:Key_DRIUL];
    NSArray *originalNutrientNameAryToCal = [recmdDict objectForKey:Key_originalNutrientNameAryToCal];
    NSSet *originalNutrientNameSetToCal = [NSSet setWithArray:originalNutrientNameAryToCal];
    
    NSMutableDictionary *nutrientSupplyDict = [recmdDict objectForKey:Key_nutrientSupplyDict];//nutrient name as key, also column name
    //    NSDictionary *nutrientInitialSupplyDict = [recmdDict objectForKey:@"nutrientInitialSupplyDict"];
    NSMutableDictionary *foodSupplyAmountDict = [recmdDict objectForKey:@"foodSupplyAmountDict"];
    NSMutableDictionary *recommendFoodAmountDict = [recmdDict objectForKey:Key_recommendFoodAmountDict];//food NO as key
    //    NSDictionary *recommendFoodAttrDict = [recmdDict objectForKey:@"FoodAttr"];//food NO as key
    NSDictionary *preChooseFoodInfoDict = [recmdDict objectForKey:Key_preChooseFoodInfoDict];
    NSDictionary *preChooseRichFoodInfoAryDict = [recmdDict objectForKey:Key_preChooseRichFoodInfoAryDict];
    NSArray *getFoodsLogs = [recmdDict objectForKey:@"getFoodsLogs"];
    
    //    NSArray *userInfos = [recmdDict objectForKey:@"UserInfo"];
    NSDictionary *userInfo = [recmdDict objectForKey:@"userInfoDict"];
    NSDictionary *options = [recmdDict objectForKey:Key_optionsDict];
    //    NSDictionary *params = [recmdDict objectForKey:@"paramsDict"];
    NSArray *otherInfos = [recmdDict objectForKey:@"OtherInfo"];
    
    NSMutableArray *foodSupplyNutrientSeqs = [recmdDict objectForKey:@"foodSupplyNutrientSeqs"];//2D array
    NSMutableArray *calculationLogs = [recmdDict objectForKey:@"calculationLogs"];//2D array
    
    NSDictionary *takenFoodAmountDict = [recmdDict objectForKey:Key_TakenFoodAmount];//food NO as key
    NSDictionary *takenFoodAttrDict = [recmdDict objectForKey:Key_TakenFoodAttr];//food NO as key
    
//    BOOL needLimitNutrients = TRUE;
//    BOOL needUseLowLimitAsUnit = TRUE;
//    BOOL needUseNormalLimitWhenSmallIncrementLogic = Config_needUseNormalLimitWhenSmallIncrementLogic;
//    BOOL needUseFirstRecommendWhenSmallIncrementLogic = Config_needUseFirstRecommendWhenSmallIncrementLogic;
    BOOL needFirstSpecialForShucaiShuiguo = Config_needFirstSpecialForShucaiShuiguo;
//    BOOL needSpecialForFirstBatchFoods = Config_needSpecialForFirstBatchFoods;
//    BOOL alreadyChoosedFoodHavePriority = Config_alreadyChoosedFoodHavePriority;
//    BOOL needPriorityFoodToSpecialNutrient = Config_needPriorityFoodToSpecialNutrient;
    
    if(options != nil){
//        NSNumber *nmFlag_needLimitNutrients = [options objectForKey:LZSettingKey_needLimitNutrients];
//        if (nmFlag_needLimitNutrients != nil)
//            needLimitNutrients = [nmFlag_needLimitNutrients boolValue];
//        
//        NSNumber *nmFlag_needUseLowLimitAsUnit = [options objectForKey:LZSettingKey_needUseLowLimitAsUnit];
//        if (nmFlag_needUseLowLimitAsUnit != nil)
//            needUseLowLimitAsUnit = [nmFlag_needUseLowLimitAsUnit boolValue];
//        
//        NSNumber *nmFlag_needUseNormalLimitWhenSmallIncrementLogic = [options objectForKey:LZSettingKey_needUseNormalLimitWhenSmallIncrementLogic];
//        if (nmFlag_needUseNormalLimitWhenSmallIncrementLogic != nil)
//            needUseNormalLimitWhenSmallIncrementLogic = [nmFlag_needUseNormalLimitWhenSmallIncrementLogic boolValue];
//        
//        NSNumber *nmFlag_needUseFirstRecommendWhenSmallIncrementLogic = [options objectForKey:LZSettingKey_needUseFirstRecommendWhenSmallIncrementLogic];
//        if (nmFlag_needUseFirstRecommendWhenSmallIncrementLogic != nil)
//            needUseFirstRecommendWhenSmallIncrementLogic = [nmFlag_needUseFirstRecommendWhenSmallIncrementLogic boolValue];

        NSNumber *nmFlag_needFirstSpecialForShucaiShuiguo = [options objectForKey:LZSettingKey_needFirstSpecialForShucaiShuiguo];
        if (nmFlag_needFirstSpecialForShucaiShuiguo != nil)
            needFirstSpecialForShucaiShuiguo = [nmFlag_needFirstSpecialForShucaiShuiguo boolValue];

//        NSNumber *nmFlag_needSpecialForFirstBatchFoods = [options objectForKey:LZSettingKey_needSpecialForFirstBatchFoods];
//        if (nmFlag_needSpecialForFirstBatchFoods != nil)
//            needSpecialForFirstBatchFoods = [nmFlag_needSpecialForFirstBatchFoods boolValue];
//        
//        NSNumber *nmFlag_alreadyChoosedFoodHavePriority = [options objectForKey:LZSettingKey_alreadyChoosedFoodHavePriority];
//        if (nmFlag_alreadyChoosedFoodHavePriority != nil)
//            alreadyChoosedFoodHavePriority = [nmFlag_alreadyChoosedFoodHavePriority boolValue];
//        
//        NSNumber *nmFlag_needPriorityFoodToSpecialNutrient = [options objectForKey:LZSettingKey_needPriorityFoodToSpecialNutrient];
//        if (nmFlag_needPriorityFoodToSpecialNutrient != nil)
//            needPriorityFoodToSpecialNutrient = [nmFlag_needPriorityFoodToSpecialNutrient boolValue];
        
    }

    
    NSMutableDictionary *recommendFoodAmountDictOld = [NSMutableDictionary dictionaryWithDictionary:recommendFoodAmountDict];
    NSMutableDictionary *foodSupplyAmountDictOld = [NSMutableDictionary dictionaryWithDictionary:foodSupplyAmountDict];
    NSMutableDictionary *nutrientSupplyDictOld = [NSMutableDictionary dictionaryWithDictionary:nutrientSupplyDict];
    [recmdDict setObject:recommendFoodAmountDictOld forKey:@"recommendFoodAmountDictOld"];
    [recmdDict setObject:foodSupplyAmountDictOld forKey:@"foodSupplyAmountDictOld"];
    [recmdDict setObject:nutrientSupplyDictOld forKey:@"nutrientSupplyDictOld"];
    
    NSMutableString *logMsg;
    NSMutableArray *calculationLog;
    bool haveReducedFood;
    while(true){
        haveReducedFood = FALSE;
        
        NSMutableArray *exceedDRIrateInfoAry = [NSMutableArray arrayWithCapacity:originalNutrientNameAryToCal.count];
        NSMutableArray *exceedULrateInfoAry = [NSMutableArray arrayWithCapacity:originalNutrientNameAryToCal.count];
        //找出超过UL和DRI的营养素集合。注意只在要计算的那些营养素找，这里作这样一个限制，是对应着只管要计算的那些营养素的思想。
        for(int i=0; i<originalNutrientNameAryToCal.count; i++){
            NSString *nutrient = originalNutrientNameAryToCal[i];
            NSNumber *nmSupply = [nutrientSupplyDict objectForKey:nutrient];
            NSNumber *nmDRI = [DRIsDict objectForKey:nutrient];
            NSNumber *nmUL = [DRIULsDict objectForKey:nutrient];
            assert(nmSupply!=nil);
            assert(nmDRI!=nil);
            assert(nmUL!=nil);
            if ([nmUL doubleValue]>0 && [nmSupply doubleValue]>[nmUL doubleValue]){
                double rateSupplyVsUL = [nmSupply doubleValue] / [nmUL doubleValue];
                NSDictionary *rateInfo = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithDouble:rateSupplyVsUL],@"rate", nutrient,@"nutrient", nil];
                [exceedULrateInfoAry addObject:rateInfo];
            }else if ([nmSupply doubleValue]>[nmDRI doubleValue]){
                if ( needFirstSpecialForShucaiShuiguo && [NutrientId_VC isEqualToString:nutrient]){
                    //此时对于 VC 特殊处理，因为这个flag是特意多补蔬菜水果，而蔬菜水果主要与VC相关。VC如果只超过DRI就不用减食物了，免得特意加上的蔬菜水果又被减掉。
                }else{
                    double rateSupplyVsDRI = [nmSupply doubleValue] / [nmDRI doubleValue];
                    NSDictionary *rateInfo = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithDouble:rateSupplyVsDRI],@"rate", nutrient,@"nutrient", nil];
                    [exceedDRIrateInfoAry addObject:rateInfo];
                }
            }
        }//for
        
        NSComparisonResult (^compareBlockVar)(id obj1,id obj2) ;
        compareBlockVar = ^(id obj1,id obj2){
            NSDictionary *rateInfo1 = obj1;
            NSDictionary *rateInfo2 = obj2;
            NSNumber *nmRate1 = rateInfo1[@"rate"];
            NSNumber *nmRate2 = rateInfo2[@"rate"];
            //顺序是ascending
            if ([nmRate1 doubleValue] > [nmRate2 doubleValue]){
                return (NSComparisonResult)NSOrderedDescending;
            }else if ([nmRate1 doubleValue] < [nmRate2 doubleValue]){
                return (NSComparisonResult)NSOrderedAscending ;
            }else{
                return (NSComparisonResult)NSOrderedSame;
            }
        };
        
        if (exceedULrateInfoAry.count > 0){
            //有超过UL的营养素，升序排序降序处理
            [exceedULrateInfoAry sortUsingComparator:compareBlockVar];
        }
        if (exceedDRIrateInfoAry.count > 0){
            //有超过UL的营养素，升序排序降序处理
            [exceedDRIrateInfoAry sortUsingComparator:compareBlockVar];
        }
        
        while (exceedULrateInfoAry.count > 0 || exceedDRIrateInfoAry.count > 0){
            //对每个超过UL的营养素,尝试着减食物的量,从超得最多的来处理
            NSString *nutrientExceedType = nil;
            NSString *exceedNutrient = nil;
            NSNumber *nmRate = nil;
            if (exceedULrateInfoAry.count > 0){
                NSDictionary *exceedNutrientInfo = exceedULrateInfoAry[exceedULrateInfoAry.count-1];
                [exceedULrateInfoAry removeLastObject];
                nutrientExceedType = @"exceedUL";
                exceedNutrient = exceedNutrientInfo[@"nutrient"];
                nmRate = exceedNutrientInfo[@"rate"];
            }else if (exceedDRIrateInfoAry.count > 0){
                NSDictionary *exceedNutrientInfo = exceedDRIrateInfoAry[exceedDRIrateInfoAry.count-1];
                [exceedDRIrateInfoAry removeLastObject];
                nutrientExceedType = @"exceedDRI";
                exceedNutrient = exceedNutrientInfo[@"nutrient"];
                nmRate = exceedNutrientInfo[@"rate"];
            }
            assert(exceedNutrient!=nil);
            NSString *nutrient = exceedNutrient;

            NSArray *richFoodInfoAry = preChooseRichFoodInfoAryDict[nutrient];
            assert(richFoodInfoAry.count>0);
            NSMutableArray *idxAry = [NSMutableArray arrayWithCapacity:richFoodInfoAry.count];
            for(int i=0; i<richFoodInfoAry.count; i++){
                [idxAry addObject:[NSNumber numberWithInt:i]];
            }//for
            //对当前的超过UL或DRI的营养素的每个富含食物，进行尝试减量。 这里是随机找出某种富含食物来减。至于如何找到最合适的食物来减，目前没想到合适的规则。
            while (idxAry.count>0) {
                int chooseIdx = -1;
                if (idxAry.count==1){
                    NSNumber *nmIdx = idxAry[0];
                    chooseIdx = [nmIdx intValue];
                    [idxAry removeObjectAtIndex:0];
                }else{
                    int idx1 = random() % idxAry.count;
                    NSNumber *nmIdx2 = idxAry[idx1];
                    chooseIdx = [nmIdx2 intValue];
                    [idxAry removeObjectAtIndex:idx1];
                }
                NSDictionary *foodInfo = richFoodInfoAry[chooseIdx];
                NSString *foodId = foodInfo[COLUMN_NAME_NDB_No];
                NSNumber *nmFoodAmount = recommendFoodAmountDict[foodId];
                if ([nmFoodAmount doubleValue] > Config_nearZero){//这种食物的使用量大于0，才有可能减它
                    double maxDeltaFoodAmount = 0;
                    //对于当前的食物，对每个营养素算最多能减的数量，这为各个值中的最小值
                    for(int j=0; j<originalNutrientNameAryToCal.count; j++){
                        NSString *nutrientL1 = originalNutrientNameAryToCal[j];
                        NSNumber *nmSupply = [nutrientSupplyDict objectForKey:nutrientL1];
                        NSNumber *nmDRI = [DRIsDict objectForKey:nutrientL1];
                        
                        NSNumber *nmFoodStandardSupplyNutrient = foodInfo[nutrientL1];
                        if ([nmFoodStandardSupplyNutrient doubleValue]>0){//当前food含有当前这种营养素
                            if ([nmSupply doubleValue]-[nmDRI doubleValue]<=Config_nearZero){
                                //此时这种营养素已经为DRI值，不能再往下减这种食物了
                                maxDeltaFoodAmount = 0;
                                break;
                            }else{
                                double deltaFoodAmount = ([nmSupply doubleValue]-[nmDRI doubleValue])*100.0/[nmFoodStandardSupplyNutrient doubleValue];
                                if (maxDeltaFoodAmount == 0)
                                    maxDeltaFoodAmount = deltaFoodAmount;
                                else if (maxDeltaFoodAmount > deltaFoodAmount)
                                    maxDeltaFoodAmount = deltaFoodAmount;
                            }
                        }
                    }//for j
                    if (maxDeltaFoodAmount >= [nmFoodAmount doubleValue]){//这种食物能够减少的上限是它的使用量
                        maxDeltaFoodAmount = [nmFoodAmount doubleValue];
                    }else{//now maxDeltaFoodAmount < [nmFoodAmount doubleValue]
                        if([nmFoodAmount doubleValue] - maxDeltaFoodAmount < Config_nearZero){// 可以认为 [nmFoodAmount doubleValue] == maxDeltaFoodAmount
                            maxDeltaFoodAmount = [nmFoodAmount doubleValue];
                        }else if([nmFoodAmount doubleValue] - maxDeltaFoodAmount < 1){
                            maxDeltaFoodAmount = [nmFoodAmount doubleValue] - 1;//避免显示时四舍五入为0的情况。
                            if (maxDeltaFoodAmount < 0){//此时说明 [nmFoodAmount doubleValue] < 1 ,但是这种情况应该不会发生(除去微小的误差情况)。因为最开始它>=1，之后减的话，要么彻底减掉，要么间距至少为1，这样保证减掉之后得到的值仍>=1
                                maxDeltaFoodAmount = 0;
                            }
                        }else{//[nmFoodAmount doubleValue] - maxDeltaFoodAmount >= 1
                            //do nothing about maxDeltaFoodAmount
                        }
                    }
                    if (maxDeltaFoodAmount < Config_nearZero){
                        maxDeltaFoodAmount = 0;
                    }
                    if (maxDeltaFoodAmount > 0){//可以减少这种食物
                        double reduceFoodAmount = -1 * maxDeltaFoodAmount;//这里暂且一减到底
                        [self oneFoodSupplyNutrients:foodInfo andAmount:reduceFoodAmount andDestNutrientSupply:nutrientSupplyDict andOtherData:nil];//营养量累加
                        [LZUtility addDoubleToDictionaryItem:reduceFoodAmount withDictionary:recommendFoodAmountDict andKey:foodId];//推荐量累加
                        [LZUtility addDoubleToDictionaryItem:reduceFoodAmount withDictionary:foodSupplyAmountDict andKey:foodId];//供给量累加
                        
                        NSMutableArray *foodSupplyNutrientSeq = [NSMutableArray arrayWithCapacity:5];
                        [foodSupplyNutrientSeq addObject:nutrient];
                        [foodSupplyNutrientSeq addObject:nmRate];
                        [foodSupplyNutrientSeq addObject:[foodInfo objectForKey:@"CnCaption"]];
                        [foodSupplyNutrientSeq addObject:foodId];
                        [foodSupplyNutrientSeq addObject:[NSNumber numberWithDouble:reduceFoodAmount]];
                        [foodSupplyNutrientSeq addObject:[foodInfo objectForKey:@"Shrt_Desc"]];
                        [foodSupplyNutrientSeq addObject:nutrientExceedType];
                        [foodSupplyNutrientSeqs addObject:foodSupplyNutrientSeq];
                        logMsg = [NSMutableString stringWithFormat:@"reduce food:%@", [foodSupplyNutrientSeq componentsJoinedByString:@" , "]];
                        NSLog(@"%@",logMsg);
                        calculationLog = [NSMutableArray array];
                        [calculationLog addObject:@"reduce food"];
                        [calculationLog addObjectsFromArray:foodSupplyNutrientSeq];
                        [calculationLogs addObject:calculationLog];
                        
                        haveReducedFood = true;
                        break;
                    }//if (minReduceFoodAmount > 0)
                }//if ([nmFoodAmount doubleValue] > Config_nearZero)
            }//while (idxAry.count>0)
            if (haveReducedFood){
                break;
            }

        }//while (exceedULrateInfoAry.count > 0 || exceedDRIrateInfoAry.count > 0)
        if (!haveReducedFood){
            break;//由于上面的计算是完全遍历，如果一个食物都没减量，说明确实是没有食物可以减量了，计算完成。
        }
    }//while true
    NSArray *keys = recommendFoodAmountDict.allKeys;
    for(int i=0 ; i<keys.count; i++){
        id key = keys[i];
        NSNumber *nmRecAmount = recommendFoodAmountDict[key];
        if ([nmRecAmount doubleValue] < Config_nearZero){
            [recommendFoodAmountDict removeObjectForKey:key];
        }else{
            assert([nmRecAmount doubleValue] >= 1);
        }
    }
}





/*
 这里只管每个food根据自己的量对每个营养素进行供应，并且与DRI及UL值进行对比的情况。由于有新旧推荐值。所以这里单独提出来一个函数
 */
-(NSArray*) generateTableFoodSupplyNutrient_RecommendFoodBySmallIncrement:(NSDictionary*)recmdDict
{
    NSLog(@"generateTableFoodSupplyNutrient_RecommendFoodBySmallIncrement enter");
    
    NSDictionary *DRIsDict = [recmdDict objectForKey:Key_DRI];//nutrient name as key, also column name
    NSDictionary *DRIULsDict = [recmdDict objectForKey:Key_DRIUL];
    NSArray *originalNutrientNameAryToCal = [recmdDict objectForKey:Key_originalNutrientNameAryToCal];
    NSSet *originalNutrientNameSetToCal = [NSSet setWithArray:originalNutrientNameAryToCal];
    
//    NSDictionary *nutrientSupplyDictOld = [recmdDict objectForKey:@"nutrientSupplyDictOld"];
//    NSDictionary *recommendFoodAmountDictOld = [recmdDict objectForKey:@"recommendFoodAmountDictOld"];
    
    NSDictionary *nutrientSupplyDict = [recmdDict objectForKey:Key_nutrientSupplyDict];//nutrient name as key, also column name
    NSDictionary *recommendFoodAmountDict = [recmdDict objectForKey:Key_recommendFoodAmountDict];//food NO as key

    NSDictionary *preChooseFoodInfoDict = [recmdDict objectForKey:Key_preChooseFoodInfoDict];
    NSDictionary *preChooseRichFoodInfoAryDict = [recmdDict objectForKey:Key_preChooseRichFoodInfoAryDict];
   
    
    NSDictionary *takenFoodAmountDict = [recmdDict objectForKey:Key_TakenFoodAmount];//food NO as key
    NSDictionary *takenFoodAttrDict = [recmdDict objectForKey:Key_TakenFoodAttr];//food NO as key
    
    NSNumber *nm_needShowFoodStandard = [recmdDict objectForKey:@"needShowFoodStandard"];
    
    NSMutableArray *outRows = [recmdDict objectForKey:Key_outRows];
    NSMutableArray *rows = outRows;
    
    int colIdx_NutrientStart = 3;
    NSArray* nutrientNames = [DRIsDict allKeys];
    NSArray* allNutrientNamesOrdered = [self.class getDRItableNutrientsWithSameOrder];
    assert([LZUtility arrayEqualArrayInSetWay_withArray1:nutrientNames andArray2:allNutrientNamesOrdered]);
    nutrientNames = allNutrientNamesOrdered;
    
    int columnCount = colIdx_NutrientStart+nutrientNames.count;
    NSMutableArray *rowForInit = [NSMutableArray arrayWithCapacity:columnCount];
    for(int i=0; i<columnCount; i++){
        [rowForInit addObject:[NSNull null]];
    }
    
    NSMutableArray* row;
    //营养素列名集合的行
    NSMutableArray* rowNutrientNames = [NSMutableArray arrayWithArray:rowForInit];
    row = rowNutrientNames;
    for(int i=0; i<nutrientNames.count; i++){
        NSString *nutrientName = nutrientNames[i];
        if ( [originalNutrientNameSetToCal containsObject:nutrientName]){
            NSMutableString *s1 = [NSMutableString stringWithFormat:@"%@ *",nutrientName ];
            row[i+colIdx_NutrientStart] = s1;
        }else{
            row[i+colIdx_NutrientStart] = nutrientName;
        }
    }
    [rows addObject:row];
    
    int rowIdx_foodItemStart = rows.count;
    if (takenFoodAmountDict != nil){
        NSArray* takenFoodIDs = takenFoodAmountDict.allKeys;
        //已经摄取的各种食物具体的量和提供各种营养素的量
        for(int i=0; i<takenFoodIDs.count; i++){
            NSString *foodID = takenFoodIDs[i];
            NSNumber *nmFoodAmount = [takenFoodAmountDict objectForKey:foodID];
            NSDictionary *foodAttrs = [takenFoodAttrDict objectForKey:foodID];
            row = [NSMutableArray arrayWithArray:rowForInit];
            row[0] = foodID;
            row[1] = foodAttrs[@"CnCaption"];
            row[2] = nmFoodAmount;
            for(int j=0; j<nutrientNames.count;j++){
                NSString *nutrientName = nutrientNames[j];
                NSNumber *nmFoodAttrValue = [foodAttrs objectForKey:nutrientName];
                if (nmFoodAttrValue == nil || (NSNull*)nmFoodAttrValue == [NSNull null]){//有warning没事，试过了没问题
                    //do nothing
                }else{
                    double foodSupplyNutrientAmount = [nmFoodAttrValue doubleValue]*[nmFoodAmount doubleValue]/100.0;
                    row[j+colIdx_NutrientStart] = [NSNumber numberWithDouble:foodSupplyNutrientAmount];
                }
            }//for j
            [rows addObject:row];
        }//for i
    }//if (takenFoodAmountDict != nil)

        
    
    //推荐的各种食物具体的量和提供各种营养素的量
    if (preChooseFoodInfoDict != nil){
        NSArray* foodIDs = preChooseFoodInfoDict.allKeys;
        //已经摄取的各种食物具体的量和提供各种营养素的量
        for(int i=0; i<foodIDs.count; i++){
            NSString *foodID = foodIDs[i];
            NSNumber *nmFoodAmount = [recommendFoodAmountDict objectForKey:foodID];
            double dFoodAmount = 0;
            if (nmFoodAmount != nil)
                dFoodAmount = [nmFoodAmount doubleValue];
            NSDictionary *foodAttrs = [preChooseFoodInfoDict objectForKey:foodID];
            row = [NSMutableArray arrayWithArray:rowForInit];
            row[0] = foodID;
            row[1] = foodAttrs[@"CnCaption"];
            row[2] = [NSNumber numberWithDouble:dFoodAmount];
            for(int j=0; j<nutrientNames.count;j++){
                NSString *nutrientName = nutrientNames[j];
                NSNumber *nmFoodAttrValue = [foodAttrs objectForKey:nutrientName];
                if (nmFoodAttrValue == nil || (NSNull*)nmFoodAttrValue == [NSNull null]){//有warning没事，试过了没问题
                    //do nothing
                }else{
                    double foodSupplyNutrientAmount = [nmFoodAttrValue doubleValue]*dFoodAmount/100.0;
                    row[j+colIdx_NutrientStart] = [NSNumber numberWithDouble:foodSupplyNutrientAmount];
                }
            }//for j
            [rows addObject:row];
        }//for i
    }//if (preChooseFoodInfoDict != nil)
    
    //各种食物提供各种营养素的量的合计，手动算
    NSMutableArray* rowSum = [NSMutableArray arrayWithArray:rowForInit];
    rowSum[0] = @"Sum";
    for(int j=0; j<nutrientNames.count;j++){
        double sumCol = 0.0;
        int foodRowCount = rows.count - rowIdx_foodItemStart;
        for(int i=0; i<foodRowCount; i++){
            NSNumber *nmCell = rows[i+rowIdx_foodItemStart][j+colIdx_NutrientStart] ;
            if ((NSNull*)nmCell != [NSNull null])//有warning没事，试过了没问题
                sumCol += [nmCell doubleValue];
        }//for i
        rowSum[j+colIdx_NutrientStart] = [NSNumber numberWithDouble:sumCol];
    }//for j
    [rows addObject:rowSum];
    
    //各种食物提供各种营养素的量的合计，从supply中来
    NSMutableArray *rowSupply = [NSMutableArray arrayWithArray:rowForInit];
    rowSupply[0] = @"Supply";
    for(int i=0; i<nutrientNames.count; i++){
        NSString *nutrientName = nutrientNames[i];
        NSNumber *nmNutrientSupply = [nutrientSupplyDict objectForKey:nutrientName];
        if (nmNutrientSupply != nil || (NSNull*)nmNutrientSupply == [NSNull null])
            rowSupply[i+colIdx_NutrientStart] = nmNutrientSupply;
        else
            rowSupply[i+colIdx_NutrientStart] = [NSNumber numberWithDouble:0.0];
    }
    [rows addObject:rowSupply];
    
    //各种营养素DRI
    NSMutableArray *rowDRI = [NSMutableArray arrayWithArray:rowForInit];
    rowDRI[0] = @"DRI";
    for(int i=0; i<nutrientNames.count; i++){
        NSString *nutrientName = nutrientNames[i];
        NSNumber *nmNutrientDRI1unit = [DRIsDict objectForKey:nutrientName];
        if (nmNutrientDRI1unit != nil && (NSNull*)nmNutrientDRI1unit != [NSNull null])
            rowDRI[i+colIdx_NutrientStart] = nmNutrientDRI1unit;
        else
            rowDRI[i+colIdx_NutrientStart] = [NSNumber numberWithDouble:0.0];
    }
    [rows addObject:rowDRI];
    
    //各种营养素的供应对于需要比例
    NSMutableArray *rowSupplyToNeedRatio = [NSMutableArray arrayWithArray:rowForInit];
    rowSupplyToNeedRatio[0] = @"Supply to DRI ratio";
    for(int j=0; j<nutrientNames.count; j++){
        NSNumber *nmSupply = rowSupply[j+colIdx_NutrientStart];
        NSNumber *nmNutrientDRI = rowDRI[j+colIdx_NutrientStart];
        
        if ([nmNutrientDRI doubleValue] != 0.0){
            rowSupplyToNeedRatio[j+colIdx_NutrientStart] = [NSNumber numberWithDouble:([nmSupply doubleValue] / [nmNutrientDRI doubleValue])];
        }else{
            rowSupplyToNeedRatio[j+colIdx_NutrientStart] = @"N/A";
        }
    }
    [rows addObject:rowSupplyToNeedRatio];
    
    //各种营养素DRI UL
    NSMutableArray *rowDRIul = [NSMutableArray arrayWithArray:rowForInit];
    rowDRIul[0] = @"DRIUL";
    for(int i=0; i<nutrientNames.count; i++){
        NSString *nutrientName = nutrientNames[i];
        NSNumber *nmNutrientDRIul = [DRIULsDict objectForKey:nutrientName];
        if (nmNutrientDRIul != nil && (NSNull*)nmNutrientDRIul != [NSNull null])
            rowDRIul[i+colIdx_NutrientStart] = nmNutrientDRIul;
        else
            rowDRIul[i+colIdx_NutrientStart] = [NSNumber numberWithDouble:0.0];
    }
    [rows addObject:rowDRIul];
    
    //各种营养素的供应对于上限比例
    NSMutableArray *rowSupplyToULRatio = [NSMutableArray arrayWithArray:rowForInit];
    NSMutableArray *exceedULnutrients = [NSMutableArray arrayWithCapacity:20];
    rowSupplyToULRatio[0] = @"Supply to DRIUL ratio";
    [exceedULnutrients addObject:@"exceedULnutrients"];
    for(int j=0; j<nutrientNames.count; j++){
        NSNumber *nmSupply = rowSupply[j+colIdx_NutrientStart];
        NSNumber *nmNutrientDRIul = rowDRIul[j+colIdx_NutrientStart];
        
        if ([nmNutrientDRIul doubleValue] > 0.0){
            NSNumber* nmRatioDRIul = [NSNumber numberWithDouble:([nmSupply doubleValue] / [nmNutrientDRIul doubleValue])];
            rowSupplyToULRatio[j+colIdx_NutrientStart] = nmRatioDRIul;
            if ([nmRatioDRIul doubleValue]> 1.0){
                [exceedULnutrients addObject:rowNutrientNames[j+colIdx_NutrientStart]];
                [exceedULnutrients addObject:nmRatioDRIul];
            }
        }else{
            rowSupplyToULRatio[j+colIdx_NutrientStart] = @"N/A";
        }
    }
    [rows addObject:rowSupplyToULRatio];
    [rows addObject:exceedULnutrients];
    
    
    int takenFoodCount = 0, recommendFoodCount = 0;
    if (takenFoodAmountDict != nil)  takenFoodCount = takenFoodAmountDict.count;
    if (recommendFoodAmountDict.count > 0){
        for(id key in recommendFoodAmountDict){
            NSNumber *nmVal = recommendFoodAmountDict[key];
            if ([nmVal doubleValue]>0) recommendFoodCount++;
        }
    }
    row = [NSMutableArray arrayWithArray:rowForInit];
    row[0] = @"takenFoodCount";
    row[1] = [NSNumber numberWithInt:takenFoodCount];
    row[2] = @"recommendFoodCount";
    row[3] = [NSNumber numberWithInt:recommendFoodCount];
    row[4] = @"allFoodCount";
    row[5] = [NSNumber numberWithInt:takenFoodCount+recommendFoodCount];
    [rows addObject:row];
    
    row = [NSMutableArray arrayWithArray:rowForInit];
    row[0] = @"--------";
    [rows addObject:row];
    
    if ( [nm_needShowFoodStandard boolValue]){
        row = [NSMutableArray arrayWithArray:rowForInit];
        row[0] = @"Standard";
        [rows addObject:row];
        
        //各种食物含各种营养素的标准量
        //已摄取的各种食物含各种营养素的标准量
        if (takenFoodAmountDict != nil){
            NSArray* takenFoodIDs = takenFoodAmountDict.allKeys;
            for(int i=0; i<takenFoodIDs.count; i++){
                NSString *foodID = takenFoodIDs[i];
                NSDictionary *foodAttrs = [takenFoodAttrDict objectForKey:foodID];
                row = [NSMutableArray arrayWithArray:rowForInit];
                row[0] = foodID;
                row[1] = foodAttrs[@"CnCaption"];
                row[2] = @"100";
                for(int j=0; j<nutrientNames.count;j++){
                    NSString *nutrientName = nutrientNames[j];
                    NSNumber *nmFoodAttrValue = [foodAttrs objectForKey:nutrientName];
                    if (nmFoodAttrValue == nil || (NSNull*)nmFoodAttrValue == [NSNull null]){
                        //do nothing
                    }else{
                        row[j+colIdx_NutrientStart] = nmFoodAttrValue;
                    }
                }//for j
                [rows addObject:row];
            }//for i
        }
        //推荐的各种食物含各种营养素的标准量
        if (preChooseFoodInfoDict != nil){
            NSArray* foodIDs = preChooseFoodInfoDict.allKeys;
            for(int i=0; i<foodIDs.count; i++){
                NSString *foodID = foodIDs[i];
                NSDictionary *foodAttrs = [preChooseFoodInfoDict objectForKey:foodID];
                row = [NSMutableArray arrayWithArray:rowForInit];
                row[0] = foodID;
                row[1] = foodAttrs[@"CnCaption"];
                row[2] = @"100";
                for(int j=0; j<nutrientNames.count;j++){
                    NSString *nutrientName = nutrientNames[j];
                    NSNumber *nmFoodAttrValue = [foodAttrs objectForKey:nutrientName];
                    if (nmFoodAttrValue == nil || (NSNull*)nmFoodAttrValue == [NSNull null]){
                        //do nothing
                    }else{
                        row[j+colIdx_NutrientStart] = nmFoodAttrValue;
                    }
                }//for j
                [rows addObject:row];
            }//for i
        }
    }
        
    return rows;
}






-(NSArray*) generateData3D_RecommendFoodBySmallIncrement:(NSDictionary*)recmdDict
{
    NSLog(@"generateData3D_RecommendFoodBySmallIncrement enter");
    
    NSDictionary *DRIsDict = [recmdDict objectForKey:Key_DRI];//nutrient name as key, also column name
    NSDictionary *DRIULsDict = [recmdDict objectForKey:Key_DRIUL];
    NSArray *originalNutrientNameAryToCal = [recmdDict objectForKey:Key_originalNutrientNameAryToCal];
    NSSet *originalNutrientNameSetToCal = [NSSet setWithArray:originalNutrientNameAryToCal];
    
    NSDictionary *nutrientSupplyDictOld = [recmdDict objectForKey:@"nutrientSupplyDictOld"];
    NSDictionary *recommendFoodAmountDictOld = [recmdDict objectForKey:@"recommendFoodAmountDictOld"];
    
    NSDictionary *nutrientSupplyDict = [recmdDict objectForKey:Key_nutrientSupplyDict];//nutrient name as key, also column name
    //    NSDictionary *nutrientInitialSupplyDict = [recmdDict objectForKey:@"nutrientInitialSupplyDict"];
    NSDictionary *recommendFoodAmountDict = [recmdDict objectForKey:Key_recommendFoodAmountDict];//food NO as key
//    NSDictionary *recommendFoodAttrDict = [recmdDict objectForKey:@"FoodAttr"];//food NO as key
    NSDictionary *preChooseFoodInfoDict = [recmdDict objectForKey:Key_preChooseFoodInfoDict];
    NSDictionary *preChooseRichFoodInfoAryDict = [recmdDict objectForKey:Key_preChooseRichFoodInfoAryDict];
    NSArray *getFoodsLogs = [recmdDict objectForKey:@"getFoodsLogs"];
    
//    NSArray *userInfos = [recmdDict objectForKey:@"UserInfo"];
    NSDictionary *userInfo = [recmdDict objectForKey:@"userInfoDict"];
    NSDictionary *options = [recmdDict objectForKey:@"optionsDict"];
//    NSDictionary *params = [recmdDict objectForKey:@"paramsDict"];
    NSArray *otherInfos = [recmdDict objectForKey:@"OtherInfo"];
    
    NSArray *foodSupplyNutrientSeqs = [recmdDict objectForKey:@"foodSupplyNutrientSeqs"];//2D array
    NSArray *calculationLogs = [recmdDict objectForKey:@"calculationLogs"];//2D array
    
    NSDictionary *takenFoodAmountDict = [recmdDict objectForKey:Key_TakenFoodAmount];//food NO as key
    NSDictionary *takenFoodAttrDict = [recmdDict objectForKey:Key_TakenFoodAttr];//food NO as key
    
//    NSDictionary *recommendFoodAmountDictOld = [recmdDict objectForKey:@"FoodAmountOld"];//food NO as key
//    NSDictionary *recommendFoodAttrDictOld = [recmdDict objectForKey:@"FoodAttrOld"];//food NO as key
//    NSDictionary *nutrientSupplyDictOld = [recmdDict objectForKey:@"NutrientSupplyOld"];//nutrient name as key, also column name
//    NSArray *mergeLogs = [recmdDict objectForKey:@"mergeLogs"];
    
    NSMutableArray *rowsAry = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *rows = [NSMutableArray arrayWithCapacity:1000];
    NSMutableArray* row;
    
    int colIdx_NutrientStart = 3;
    NSArray* nutrientNames = [DRIsDict allKeys];
    NSArray* allNutrientNamesOrdered = [self.class getDRItableNutrientsWithSameOrder];
    assert([LZUtility arrayEqualArrayInSetWay_withArray1:nutrientNames andArray2:allNutrientNamesOrdered]);
    nutrientNames = allNutrientNamesOrdered;
    int columnCount = colIdx_NutrientStart+nutrientNames.count;
    NSMutableArray *rowForInit = [NSMutableArray arrayWithCapacity:columnCount];
    for(int i=0; i<columnCount; i++){
        [rowForInit addObject:[NSNull null]];
    }
    
    NSMutableDictionary *inoutParams;
    inoutParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        DRIsDict,Key_DRI,
                                        DRIULsDict,Key_DRIUL,
                                        originalNutrientNameAryToCal,Key_originalNutrientNameAryToCal,
                                        nutrientSupplyDict,Key_nutrientSupplyDict,
                                        recommendFoodAmountDict,Key_recommendFoodAmountDict,
                                        preChooseFoodInfoDict,Key_preChooseFoodInfoDict,
                                        preChooseRichFoodInfoAryDict,Key_preChooseRichFoodInfoAryDict,
                                        [NSNumber numberWithBool:false],@"needShowFoodStandard",
                                        rows,Key_outRows,
                                        nil];
    if (takenFoodAmountDict!=nil) [inoutParams setObject:takenFoodAmountDict forKey:Key_TakenFoodAmount];
    if (takenFoodAttrDict!=nil) [inoutParams setObject:takenFoodAttrDict forKey:Key_TakenFoodAttr];
    [self generateTableFoodSupplyNutrient_RecommendFoodBySmallIncrement:inoutParams];
    
    row = [NSMutableArray arrayWithArray:rowForInit];
    row[0] = @"--------BeforeReduce";
    [rows addObject:row];
    inoutParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                   DRIsDict,Key_DRI,
                   DRIULsDict,Key_DRIUL,
                   originalNutrientNameAryToCal,Key_originalNutrientNameAryToCal,
                   nutrientSupplyDictOld,Key_nutrientSupplyDict,
                   recommendFoodAmountDictOld,Key_recommendFoodAmountDict,
                   preChooseFoodInfoDict,Key_preChooseFoodInfoDict,
                   preChooseRichFoodInfoAryDict,Key_preChooseRichFoodInfoAryDict,
                   [NSNumber numberWithBool:true],@"needShowFoodStandard",
                   rows,Key_outRows,
                   nil];
    if (takenFoodAmountDict!=nil) [inoutParams setObject:takenFoodAmountDict forKey:Key_TakenFoodAmount];
    if (takenFoodAttrDict!=nil) [inoutParams setObject:takenFoodAttrDict forKey:Key_TakenFoodAttr];
    [self generateTableFoodSupplyNutrient_RecommendFoodBySmallIncrement:inoutParams];
    
           
    row = [NSMutableArray arrayWithArray:rowForInit];
    row[0] = @"preChooseRichFoodInfoAryDict";
    [rows addObject:row];
    if (preChooseRichFoodInfoAryDict!=nil){
        NSArray *nutrientNames2 = [preChooseRichFoodInfoAryDict allKeys];
        assert([LZUtility arrayEqualArrayInSetWay_withArray1:nutrientNames2 andArray2:originalNutrientNameAryToCal]);
        for(int i=0; i<originalNutrientNameAryToCal.count; i++){
            NSString *nutrientName = originalNutrientNameAryToCal[i];
            NSArray *richfoods = [preChooseRichFoodInfoAryDict objectForKey:nutrientName];
            assert(richfoods.count>0);
            row = [NSMutableArray arrayWithArray:rowForInit];
            row[0] = nutrientName;
            int colStart = 1;
            for(int j=0; j<richfoods.count; j++){
                NSDictionary *food = richfoods[j];
                row[colStart + j*2+0] = food[COLUMN_NAME_NDB_No];
                row[colStart + j*2+1] = food[@"CnCaption"];
            }
            [rows addObject:row];
        }//for i
    }
    
    [rowsAry addObject:rows];
    rows = [NSMutableArray arrayWithCapacity:100];
    
    row = [NSMutableArray arrayWithArray:rowForInit];
    row[0] = @"--------";
    [rows addObject:row];
    
    if (otherInfos!=nil)
        [rows addObject:otherInfos];
    
    row = [NSMutableArray arrayWithArray:rowForInit];
    row[0] = @"--------";
    [rows addObject:row];
    
    if (userInfo!=nil){
        [rows addObject:[LZUtility dictionaryAllToArray:userInfo]];
    }
    if(options != nil){
        [rows addObject:[LZUtility dictionaryAllToArray:options]];
    }
//    if(params != nil){
//        [rows addObject:[LZUtility dictionaryAllToArray:params]];
//    }
    [rowsAry addObject:rows];
    rows = [NSMutableArray arrayWithCapacity:1000];

    row = [NSMutableArray arrayWithArray:rowForInit];
    row[0] = @"--------getFoodsLogs";
    [rows addObject:row];
    [rows addObjectsFromArray:getFoodsLogs];
    
    [rowsAry addObject:rows];
    rows = [NSMutableArray arrayWithCapacity:1000];
    
    row = [NSMutableArray arrayWithArray:rowForInit];
    row[0] = @"--------foodSupplyNutrientSeqs";
    [rows addObject:row];
    [rows addObjectsFromArray:foodSupplyNutrientSeqs];
    
    [rowsAry addObject:rows];
    rows = [NSMutableArray arrayWithCapacity:1000];
    
    row = [NSMutableArray arrayWithArray:rowForInit];
    row[0] = @"--------calculationLogs";
    [rows addObject:row];
    [rows addObjectsFromArray:calculationLogs];
    
    [rowsAry addObject:rows];
        
    return rowsAry;
}

-(NSMutableString*) generateHtml_RecommendFoodBySmallIncrement:(NSDictionary*)recmdDict
{
    NSLog(@"generateHtml_RecommendFoodBySmallIncrement enter");

    NSMutableString *strHtml = [NSMutableString stringWithCapacity:1000*1000];
    [strHtml appendString:@"<style>\n"];
    [strHtml appendString:@"td {border:1px solid;}\n"];
    [strHtml appendString:@"</style>\n"];
    [strHtml appendString:@"<body>\n"];

    [strHtml appendString:@"<br/><hr/><br/>\n"];
    NSArray *detailData = [self generateData3D_RecommendFoodBySmallIncrement:recmdDict];
//    NSString *detailHtml = [LZUtility convert2DArrayToHtmlTable:detailData withColumnNames:nil];
    NSString *detailHtml = [LZUtility convert3DArrayToHtmlTables:detailData];
    [strHtml appendString:detailHtml];
    
    [strHtml appendString:@"</body>\n"];
    return strHtml;
}


//由于功能有所改变，这个函数将被废弃
-(NSMutableDictionary*)formatRecommendResultBySmallIncrementForUI:(NSMutableDictionary *)recommendResult
{
    NSLog(@"formatRecommendResultBySmallIncrementForUI enter");
    
    NSDictionary *DRIsDict = [recommendResult objectForKey:@"DRI"];//nutrient name as key, also column name
    NSDictionary *DRIULsDict = [recommendResult objectForKey:@"DRIUL"];
    NSArray *originalNutrientNameAryToCal = [recommendResult objectForKey:@"originalNutrientNameAryToCal"];
    NSDictionary *nutrientSupplyDict = [recommendResult objectForKey:@"NutrientSupply"];//nutrient name as key, also column name
    NSDictionary *recommendFoodAmountDict = [recommendResult objectForKey:Key_recommendFoodAmountDict];//food NO as key
    NSDictionary *recommendFoodAttrDict = [recommendResult objectForKey:@"preChooseFoodInfoDict"];//food NO as key
    NSDictionary *preChooseRichFoodInfoAryDict = [recommendResult objectForKey:@"preChooseRichFoodInfoAryDict"];
    
    
    
    NSArray *customNutrients = originalNutrientNameAryToCal;
    LZDataAccess *da = [LZDataAccess singleton];
    NSDictionary * nutrientInfoDict2Level = [da getNutrientInfoAs2LevelDictionary_withNutrientIds:customNutrients];
    
    //    NSMutableDictionary* formatResult = [NSMutableDictionary dictionary];
    NSMutableDictionary* formatResult = [self formatTakenResultForUI:recommendResult];
    
    //推荐食物
    if (recommendFoodAmountDict!=nil && recommendFoodAmountDict.count>0){
        NSArray *recommendFoodIds = [recommendFoodAmountDict allKeys];
        NSArray *orderedFoodIds = [da getOrderedFoodIds:recommendFoodIds];
        assert(recommendFoodIds.count == orderedFoodIds.count);
        
        NSMutableArray *recommendFoodInfoDictArray = [NSMutableArray array];
        for(int i=0; i<orderedFoodIds.count; i++){
            NSString *foodId = orderedFoodIds[i];
            NSDictionary *foodAttrs = recommendFoodAttrDict[foodId];
            NSNumber *nmFoodAmount = recommendFoodAmountDict[foodId];
            if ([nmFoodAmount intValue]>0){//如果是小于1的double，转成整数会得到0，显示不妥
                NSDictionary *recommendFoodInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       foodId,COLUMN_NAME_NDB_No,
                                                       foodAttrs[COLUMN_NAME_CnCaption],Key_Name,
                                                       nmFoodAmount,Key_Amount,
                                                       foodAttrs[COLUMN_NAME_PicPath], Key_PicturePath,
                                                       nil];
                [recommendFoodInfoDictArray addObject:recommendFoodInfoDict];
            }
        }//for
        [formatResult setValue:recommendFoodInfoDictArray forKey:Key_recommendFoodInfoDictArray];
    }
    
    //推荐后总的供给的营养比例
    NSMutableArray *nutrientTotalSupplyRateInfoArray = [NSMutableArray array];
    for(int i=0; i<customNutrients.count; i++){
        NSString *nutrientId = customNutrients[i];
        NSNumber *nm_DRI1unit = DRIsDict[nutrientId];
        NSNumber *nm_TotalSupply = nutrientSupplyDict[nutrientId];
        double supplyRate = [nm_TotalSupply doubleValue]/([nm_DRI1unit doubleValue]);
        NSDictionary *nutrientInfoDict = nutrientInfoDict2Level[nutrientId];
        NSString *nutrientCnCaption = nutrientInfoDict[COLUMN_NAME_NutrientCnCaption];
        NSDictionary *nutrientTotalSupplyRateInfo= [NSDictionary dictionaryWithObjectsAndKeys:
                                                    nutrientId,COLUMN_NAME_NutrientID,
                                                    [NSNumber numberWithDouble:supplyRate],Key_nutrientInitialSupplyRate,
                                                    nutrientCnCaption,Key_Name,
                                                    nil];
        [nutrientTotalSupplyRateInfoArray addObject:nutrientTotalSupplyRateInfo];
    }
    [formatResult setValue:nutrientTotalSupplyRateInfoArray forKey:Key_nutrientTotalSupplyRateInfoArray];
    
    
    //推荐食物的每个食物的供给营养素的情况
    if (recommendFoodAmountDict!=nil && recommendFoodAmountDict.count>0){
        NSArray *recommendFoodIds = [recommendFoodAmountDict allKeys];
        NSMutableDictionary *recommendFoodNutrientInfoAryDictDict = [NSMutableDictionary dictionary];
        
        NSMutableDictionary *recommendFoodSupplyNutrientInfoAryDict = [NSMutableDictionary dictionary];
        for(int i=0; i<recommendFoodIds.count; i++){
            NSString *foodId = recommendFoodIds[i];
            NSDictionary *foodAttrs = recommendFoodAttrDict[foodId];
            NSNumber *nmFoodAmount = recommendFoodAmountDict[foodId];
            
            NSMutableArray *food1supplyNutrientArray = [NSMutableArray arrayWithCapacity:customNutrients.count];
            for(int j=0; j<customNutrients.count; j++){
                NSString *nutrientId = customNutrients[j];
                NSNumber *nm_foodNutrientContent = foodAttrs[nutrientId];
                NSNumber *nm_DRI1unit = DRIsDict[nutrientId];
                double food1Supply1NutrientAmount = [nm_foodNutrientContent doubleValue]*[nmFoodAmount doubleValue]/100.0;
                double nutrientTotalDRI = [nm_DRI1unit doubleValue];
                double supplyRate = food1Supply1NutrientAmount / nutrientTotalDRI;
                NSDictionary *nutrientInfoDict = nutrientInfoDict2Level[nutrientId];
                NSString *nutrientCnCaption = nutrientInfoDict[COLUMN_NAME_NutrientCnCaption];
                NSString *nutrientNutrientEnUnit = nutrientInfoDict[COLUMN_NAME_NutrientEnUnit];
                
                NSDictionary *food1Supply1NutrientInfo= [NSDictionary dictionaryWithObjectsAndKeys:
                                                         nutrientId,COLUMN_NAME_NutrientID,
                                                         [NSNumber numberWithDouble:food1Supply1NutrientAmount],Key_food1Supply1NutrientAmount,
                                                         [NSNumber numberWithDouble:nutrientTotalDRI],Key_nutrientTotalDRI,
                                                         [NSNumber numberWithDouble:supplyRate],Key_1foodSupply1NutrientRate,
                                                         nutrientCnCaption,Key_Name,
                                                         nutrientNutrientEnUnit,Key_Unit,
                                                         nil];
                [food1supplyNutrientArray addObject:food1Supply1NutrientInfo];
            }//for j
            recommendFoodSupplyNutrientInfoAryDict[foodId] = food1supplyNutrientArray;
        }//for i
        
        NSMutableDictionary *recommendFoodStandardNutrientInfoAryDict = [NSMutableDictionary dictionary];
        for(int i=0; i<recommendFoodIds.count; i++){
            NSString *foodId = recommendFoodIds[i];
            NSDictionary *foodAttrs = recommendFoodAttrDict[foodId];
            
            NSMutableArray *foodStandardNutrientInfoAry = [NSMutableArray arrayWithCapacity:customNutrients.count];
            for(int j=0; j<customNutrients.count; j++){
                NSString *nutrientId = customNutrients[j];
                NSNumber *nm_foodNutrientContent = foodAttrs[nutrientId];
                NSDictionary *nutrientInfoDict = nutrientInfoDict2Level[nutrientId];
                NSString *nutrientCnCaption = nutrientInfoDict[COLUMN_NAME_NutrientCnCaption];
                NSString *nutrientNutrientEnUnit = nutrientInfoDict[COLUMN_NAME_NutrientEnUnit];
                
                NSDictionary *foodStandardNutrientInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                                          nutrientId,COLUMN_NAME_NutrientID,
                                                          nm_foodNutrientContent,Key_foodNutrientContent,
                                                          nutrientCnCaption,Key_Name,
                                                          nutrientNutrientEnUnit,Key_Unit,
                                                          nil];
                [foodStandardNutrientInfoAry addObject:foodStandardNutrientInfo];
            }//for j
            recommendFoodStandardNutrientInfoAryDict[foodId] = foodStandardNutrientInfoAry;
        }//for i
        
        
        [recommendFoodNutrientInfoAryDictDict setValue:recommendFoodSupplyNutrientInfoAryDict forKey:Key_foodSupplyNutrientInfoAryDict];
        [recommendFoodNutrientInfoAryDictDict setValue:recommendFoodStandardNutrientInfoAryDict forKey:Key_foodStandardNutrientInfoAryDict];
        
        [formatResult setValue:recommendFoodNutrientInfoAryDictDict forKey:Key_recommendFoodNutrientInfoAryDictDict];
    }
    
    NSLog(@"formatRecommendResultBySmallIncrementForUI exit, result=%@",formatResult);
    return formatResult;
}





@end
























