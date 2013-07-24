//
//  LZConstants.h
//  nutrition
//
//  Created by liu miao on 4/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#ifndef nutrition_LZConstants_h
#define nutrition_LZConstants_h

#define KeyIsEnvironmentDebug 0

#define Config_needConsiderNutrientLoss FALSE
#define Config_foodUpperLimit 1000 // unit g
#define Config_foodLowerLimit 1 // unit g
#define Config_foodNormalValue 250 // unit g
#define Config_nearZero 0.0000001
#define Config_defaultFoodIncreaseUnit 1
#define Config_needUseNormalLimitWhenSmallIncrementLogic TRUE
#define Config_needUseFirstRecommendWhenSmallIncrementLogic TRUE //FALSE //它为TRUE时，会导致补得过量经常发生，从而删掉某个少量的推荐的食物后再推荐可能会报营养已满不用推荐，从而让用户觉得算法有问题。不过，即使设置为false，算法仍然没有能彻底避免这种情况。但是，现在由于算法加了推荐后再减少食物的功能，这个问题不存在了。
#define Config_needFirstSpecialForShucaiShuiguo TRUE
#define Config_needSpecialForFirstBatchFoods TRUE
#define Config_alreadyChoosedFoodHavePriority TRUE //主要用于减少食物种类
#define Config_needPriorityFoodToSpecialNutrient FALSE //有了 alreadyChoosedFoodHavePriority 为true，感觉needPriorityFoodToSpecialNutrient的特色没必要了

#define FoodClassify_gulei @"gulei"
#define FoodClassify_gandoulei @"gandoulei"
#define FoodClassify_shucai @"shucai"
#define FoodClassify_shuiguo @"shuiguo"
#define FoodClassify_ganguo @"ganguo"
#define FoodClassify_nailei @"nailei"

#define FoodClassify_rou @"rou"

#define FoodClassify_rou_shui_yu @"rou-shui-yu"
#define FoodClassify_rou_shui_xia @"rou-shui-xia"
#define FoodClassify_rou_chu_rou @"rou-chu-rou"
#define FoodClassify_rou_qin @"rou-qin"
#define FoodClassify_danlei @"danlei"

#define NutrientId_VC @"Vit_C_(mg)"
#define NutrientId_VD @"Vit_D_(µg)"
#define NutrientId_Magnesium @"Magnesium_(mg)"
#define NutrientId_Fiber @"Fiber_TD_(g)"
#define NutrientId_Lipid @"Lipid_Tot_(g)"
#define NutrientId_Protein @"Protein_(g)"

#define kFatFactor 1/9 //means 1g fat contains 9Kcal energy
#define kCarbFactor 1/4 //means 1g carbohydrt contains 4Kcal energy
#define LZUserSexKey @"LZUserSexKey" //int 0 means male 1 means female
#define LZUserAgeKey @"LZUserAgeKey" //int 
#define LZUserHeightKey @"LZUserHeightKey"//int cm
#define LZUserWeightKey @"LZUserWeightKey"//int kg
#define LZUserActivityLevelKey @"LZUserActivityLevelKey"//int 0 means Sedentary,1 means Low Active,2 means Active,3 means Very Active
#define LZUserDailyIntakeKey @"LZUserDailyIntakeKey" //a dictionary for user daily intake
#define LZPlanPersonsKey @"LZPersonAmountKey"//int
#define LZPlanDaysKey @"LZPlanDaysKey"//int

#define LZSettingKey_randomSelectFood @"randomSelectFood" //BOOL
#define LZSettingKey_randomRangeSelectFood @"randomRangeSelectFood" //int
#define LZSettingKey_needLimitNutrients @"needLimitNutrients" //BOOL
#define LZSettingKey_limitRecommendFoodCount @"limitRecommendFoodCount" //int
#define LZSettingKey_notAllowSameFood @"notAllowSameFood" //BOOL

#define LZSettingKey_needConsiderNutrientLoss @"needConsiderNutrientLoss"
#define LZSettingKey_needUseLowLimitAsUnit @"needUseLowLimitAsUnit"
#define LZSettingKey_needUseNormalLimitWhenSmallIncrementLogic @"needUseNormalLimitWhenSmallIncrementLogic"
#define LZSettingKey_needUseFirstRecommendWhenSmallIncrementLogic @"needUseFirstRecommendWhenSmallIncrementLogic"
#define LZSettingKey_needFirstSpecialForShucaiShuiguo @"needFirstSpecialForShucaiShuiguo"
#define LZSettingKey_needSpecialForFirstBatchFoods @"needSpecialForFirstBatchFoods"
#define LZSettingKey_alreadyChoosedFoodHavePriority @"alreadyChoosedFoodHavePriority"
#define LZSettingKey_needPriorityFoodToSpecialNutrient @"needPriorityFoodToSpecialNutrient"
#define LZSettingKey_randSeed @"randSeed"
#define LZSettingKey_randSeedOut @"randSeedOut"

#define ParamKey_sex @"sex"
#define ParamKey_age @"age"
#define ParamKey_weight @"weight"
#define ParamKey_height @"height"
#define ParamKey_activityLevel @"activityLevel"


#define COLUMN_NAME_NDB_No @"NDB_No"

#define TABLE_NAME_USDA_ABBREV @"FoodNutrition"
#define TABLE_NAME_DRIFemale @"DRIFemale"
#define TABLE_NAME_DRIMale @"DRIMale"

#define TABLE_NAME_DRIULFemale @"DRIULFemale"
#define TABLE_NAME_DRIULMale @"DRIULMale"

#define TABLE_NAME_DRIULrateFemale @"DRIULrateFemale"
#define TABLE_NAME_DRIULrateMale @"DRIULrateMale"

//#define TABLE_NAME_FoodNutritionCustom @"FoodNutritionCustom" // TO be replaced by CustomFood join FoodNutrition OR same name view
#define VIEW_NAME_FoodNutritionCustom @"FoodNutritionCustom" 
#define COLUMN_NAME_CnCaption @"CnCaption"
#define COLUMN_NAME_CnType @"CnType"
#define COLUMN_NAME_classify @"classify"
#define TABLE_NAME_FoodCnDescription @"FoodCnDescription" // TO BE changed to CustomFood
#define TABLE_NAME_FoodCustom @"FoodCustom"

#define COLUMN_NAME_SingleItemUnitName @"SingleItemUnitName"
#define COLUMN_NAME_SingleItemUnitWeight @"SingleItemUnitWeight"

#define TABLE_NAME_Food_Supply_DRI_Common @"Food_Supply_DRI_Common"
#define TABLE_NAME_Food_Supply_DRI_Amount @"Food_Supply_DRI_Amount"

//#define TABLE_NAME_FoodLimit @"FoodLimit"
#define COLUMN_NAME_Lower_Limit @"Lower_Limit(g)"
#define COLUMN_NAME_Upper_Limit @"Upper_Limit(g)"
#define COLUMN_NAME_normal_value @"normal_value"
#define COLUMN_NAME_first_recommend @"first_recommend"


#define TABLE_NAME_NutritionInfo @"NutritionInfo"
#define COLUMN_NAME_NutrientID @"NutrientID"

#define COLUMN_NAME_NutrientCnCaption @"NutrientCnCaption"
#define COLUMN_NAME_NutrientEnUnit @"NutrientEnUnit"
#define COLUMN_NAME_LossRate @"LossRate"
#define COLUMN_NAME_NutrientDescription @"NutrientDescription"

//#define TABLE_NAME_FoodPicPath @"FoodPicPath"
#define COLUMN_NAME_PicPath @"PicPath"

#define TABLE_NAME_FoodCollocation @"FoodCollocation"
#define TABLE_NAME_CollocationFood @"CollocationFood"
#define TABLE_NAME_FoodCollocationParam @"FoodCollocationParam"
#define COLUMN_NAME_CollocationId @"CollocationId"
#define COLUMN_NAME_FoodId @"FoodId"
#define COLUMN_NAME_FoodAmount @"FoodAmount"


#define Key_Amount @"Amount"
#define Key_Name @"Name"
#define Key_Unit @"Unit"
#define Key_PicturePath @"PicturePath"
#define Key_FoodAmount @"FoodAmount"
#define Key_DRI @"DRI"
#define Key_DRIUL @"DRIUL"
#define Key_userInfo @"userInfo"

#define Key_givenNutrients @"givenNutrients"

#define Key_originalNutrientNameAryToCal @"originalNutrientNameAryToCal"
//#define Key_takenFoodInfo2LevelDict @"takenFoodInfo2LevelDict"
//#define Key_recommendFoodInfo2LevelDict @"recommendFoodInfo2LevelDict"
#define Key_takenFoodInfoDictArray @"takenFoodInfoDictArray"
#define Key_recommendFoodInfoDictArray @"recommendFoodInfoDictArray"
#define Key_recommendFoodAmountDict @"recommendFoodAmountDict"

#define Key_TakenFoodAmount @"TakenFoodAmount"
#define Key_TakenFoodAttr @"TakenFoodAttr"

#define Key_outRows @"outRows"

#define Key_preChooseFoodInfoDict @"preChooseFoodInfoDict"
#define Key_preChooseRichFoodInfoAryDict @"preChooseRichFoodInfoAryDict"

#define Key_nutrientInitialSupplyRate @"nutrientInitialSupplyRate"
#define Key_nutrientSupplyRate @"nutrientSupplyRate"
#define Key_nutrientTakenRateInfoArray @"nutrientTakenRateInfoArray"
#define Key_nutrientTotalSupplyRateInfoArray @"nutrientTotalSupplyRateInfoArray"
#define Key_food1Supply1NutrientAmount @"food1Supply1NutrientAmount"
#define Key_nutrientTotalDRI @"nutrientTotalDRI"
#define Key_1foodSupply1NutrientRate @"1foodSupply1NutrientRate"
#define Key_foodNutrientContent @"foodNutrientContent"
#define Key_foodSupplyNutrientInfoAryDict @"foodSupplyNutrientInfoAryDict"
#define Key_foodStandardNutrientInfoAryDict @"foodStandardNutrientInfoAryDict"
#define Key_takenFoodNutrientInfoAryDictDict @"takenFoodNutrientInfoAryDictDict"
#define Key_recommendFoodNutrientInfoAryDictDict @"recommendFoodNutrientInfoAryDictDict"

#define Key_orderedGivenFoodIds1 @"orderedGivenFoodIds1"
#define Key_orderedGivenFoodIds2 @"orderedGivenFoodIds2"
#define Key_orderedGivenFoodIds @"orderedGivenFoodIds"
#define Key_givenFoodInfoDict2Level @"givenFoodInfoDict2Level"
#define Key_givenFoodAttrDict2Level @"givenFoodAttrDict2Level"
#define Key_nutrientSupplyRateInfoArray @"nutrientSupplyRateInfoArray"
#define Key_nutrientSupplyDict @"nutrientSupplyDict"

#define KeyUserRecommendPreferNutrientArray @"UserRecommendPreferNutrientArray"
#define Type_normalSet @"normalSet"
#define Type_lastSet @"lastSet"

#define Strategy_random  @"random"
#define Strategy_max  @"max"

#define kProgressBarRect CGRectMake(2,2,226,14)
#define kKeyBoardToolBarRect CGRectMake(0,0,320,44)
#define TopNavigationBarHeight 44
#define FoodTypeSelectorViewHeight 41

#define Notification_TakenFoodChangedKey @"KeyTakenFoodChangedNotification"
#define Notification_SettingsChangedKey @"KeySettingsChangedNotification"
#define Notification_TakenFoodDeletedKey @"KeyTakenFoodDeletedNotification"

#define UMSDKAPPKey @"51b96cc356240b6ee80a05dc"
#define ShareSDKAPPKey @"4d8c71c46cb"
#define LocalNotifyTimeInterval (72*60*60) // 72 hours



#define KeyIsAlreadyReviewdeOurApp @"KeyIsAlreadyReviewdeOurApp" // YES means already reviewed
#define KeyReviewAlertControllCount @"KeyReviewAlertControllCount" // >=10 popAlert


#define MY_BANNER_UNIT_ID @"a151bfe57a8e242"//admob key

//share config info
#define SinaWeiboAppKey @"3626415671"
#define SinaWeiboAppSecret @"9d17e75a675323f5b719cb058c5b9d0d"

#define WeChatAppId @"wxb842cd724ab15257"

#endif

















