//
//  LZConstants.h
//  nutrition
//
//  Created by liu miao on 4/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#ifndef nutrition_LZConstants_h
#define nutrition_LZConstants_h

#define Config_needConsiderNutrientLoss TRUE
#define Config_foodUpperLimit 1000 // unit g
#define Config_foodLowerLimit 1 // unit g
#define Config_foodNormalValue 250 // unit g
#define Config_nearZero 0.0000001


#define kFatFactor 1/9 //means 1g fat contains 9Kcal energy
#define kCarbFactor 1/4 //means 1g carbohydrt contains 4Kcal energy
#define LZUserSexKey @"LZUserSexKey" //int 0 means male 1 means female
#define LZUserAgeKey @"LZUserAgeKey" //int 
#define LZUserHeightKey @"LZUserHeightKey"//float cm
#define LZUserWeightKey @"LZUserWeightKey"//float kg
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

#define KeyIsEnvironmentDebug 1

#define KeyIsAlreadyReviewdeOurApp @"KeyIsAlreadyReviewdeOurApp" // YES means already reviewed
#define KeyReviewAlertControllCount @"KeyReviewAlertControllCount" // >=10 popAlert

#define SinaWeiboAppKey @"3626415671"
#define SinaWeiboAppSecret @"9d17e75a675323f5b719cb058c5b9d0d"

#endif

















