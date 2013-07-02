//
//  LZConstants.h
//  nutrition
//
//  Created by liu miao on 4/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#ifndef nutrition_LZConstants_h
#define nutrition_LZConstants_h

#define KeyIsEnvironmentDebug 1

#define Config_needConsiderNutrientLoss TRUE
#define Config_foodUpperLimit 1000 // unit g
#define Config_foodLowerLimit 1 // unit g
#define Config_foodNormalValue 250 // unit g
#define Config_nearZero 0.0000001

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

#define NutrientId_VD @"Vit_D_(µg)"
#define NutrientId_Magnesium @"Magnesium_(mg)"

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




#define COLUMN_NAME_NDB_No @"NDB_No"

#define TABLE_NAME_USDA_ABBREV @"FoodNutrition"
#define TABLE_NAME_DRIFemale @"DRIFemale"
#define TABLE_NAME_DRIMale @"DRIMale"

#define TABLE_NAME_DRIULFemale @"DRIULFemale"
#define TABLE_NAME_DRIULMale @"DRIULMale"

#define TABLE_NAME_DRIULrateFemale @"DRIULrateFemale"
#define TABLE_NAME_DRIULrateMale @"DRIULrateMale"

#define TABLE_NAME_FoodNutritionCustom @"FoodNutritionCustom"
#define COLUMN_NAME_CnCaption @"CnCaption"
#define COLUMN_NAME_CnType @"CnType"
#define COLUMN_NAME_classify @"classify"

#define TABLE_NAME_Food_Supply_DRI_Common @"Food_Supply_DRI_Common"
#define TABLE_NAME_Food_Supply_DRI_Amount @"Food_Supply_DRI_Amount"

#define TABLE_NAME_FoodLimit @"FoodLimit"
#define COLUMN_NAME_Lower_Limit @"Lower_Limit(g)"
#define COLUMN_NAME_Upper_Limit @"Upper_Limit(g)"
#define COLUMN_NAME_normal_value @"normal_value"
#define TABLE_NAME_FoodCnDescription @"FoodCnDescription"

#define TABLE_NAME_NutritionInfo @"NutritionInfo"
#define COLUMN_NAME_NutrientID @"NutrientID"

#define COLUMN_NAME_NutrientCnCaption @"NutrientCnCaption"
#define COLUMN_NAME_NutrientEnUnit @"NutrientEnUnit"
#define COLUMN_NAME_LossRate @"LossRate"
#define COLUMN_NAME_NutrientDescription @"NutrientDescription"

#define TABLE_NAME_FoodPicPath @"FoodPicPath"
#define COLUMN_NAME_PicPath @"PicPath"

#define Key_Amount @"Amount"
#define Key_Name @"Name"
#define Key_Unit @"Unit"
#define Key_PicturePath @"PicturePath"
#define Key_FoodAmount @"FoodAmount"
//#define Key_takenFoodInfo2LevelDict @"takenFoodInfo2LevelDict"
//#define Key_recommendFoodInfo2LevelDict @"recommendFoodInfo2LevelDict"
#define Key_takenFoodInfoDictArray @"takenFoodInfoDictArray"
#define Key_recommendFoodInfoDictArray @"recommendFoodInfoDictArray"

#define Key_nutrientInitialSupplyRate @"nutrientInitialSupplyRate"
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

















