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

#define KeyShouldShowAdView 1 //作用于部分广告条，以方便截图

#define ParseApp_ApplicationID @"fztdtApy436OtueDufo0hWx6IQIVn08CqepzgxB1" //zlyysf nutrition1 app
#define ParseApp_ClientKey @"TwMxnh4aTLN3U4jmJBUGlQ45QnNRgehAvHj98Qex" //zlyysf nutrition1 app

//#define ParseApp_ApplicationID @"KOObufGbStKu8OP2QrcGEU0dkwMpvlD0rJ09PD6R" //lingzhi RemedyPills app
//#define ParseApp_ClientKey @"MkXIifLvrpe5mONp4IhPs0ijcpg15ZCJdSJpFIT8" //lingzhi RemedyPills app

#define ParseObject_UserRecord @"UserRecord"
#define ParseObjectKey_objectId @"objectId"
#define ParseObjectKey_UserRecord_deviceId @"deviceId"
#define ParseObjectKey_UserRecord_attachFile @"attachFile"
#define ParseObject_UserRecordSymptom @"UserRecordSymptom"
#define ParseObjectKey_UserRecordSymptom_deviceId @"deviceId"
#define ParseObject_FoodCollocation @"FoodCollocation"
#define ParseObjectKey_FoodCollocation_deviceId @"deviceId"
#define ParseObjectKey_FoodCollocation_rowFoodCollocation @"rowFoodCollocation"
#define ParseObjectKey_FoodCollocation_foodAndAmount2LevelArray @"foodAndAmount2LevelArray"
#define ParseObjectKey_FoodCollocation_nameValueDict @"nameValueDict"

#define KeyDebugSettingsDict @"KeyDebugSettingsDict"
#define AppVersionCheckName @"NutritionFoodGuide"
#define Config_needConsiderNutrientLoss FALSE
#define Config_foodUpperLimit 1000 // unit g
#define Config_foodLowerLimit 1 // unit g
#define Config_foodNormalValue 250 // unit g
#define Config_nearZero 0.0000001
#define Config_defaultFoodIncreaseUnit 1

#define Config_getLackNutrientLimit 3 

#define ViewControllerUseBackImage 0
#define KeyAppLauchedForHealthCheck @"KeyAppLauchedForHealthCheck"

#define Config_notAllowSameFood TRUE
#define Config_ifNeedCustomDefinedFoods TRUE
#define Config_randomSelectFood TRUE
#define Config_needUseFoodLimitTableWhenCal TRUE
#define Config_needLimitNutrients TRUE
#define Config_needUseLessAsPossibleFood FALSE
#define Config_upperLimitTypeForSupplyAsPossible @"normal_value" //COLUMN_NAME_normal_value //  @"Upper_Limit(g)" // COLUMN_NAME_Upper_Limit
//#define Config_needUseLowLimitAsUnit TRUE
#define Config_needUseDefinedIncrementUnit TRUE
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
#define NutrientId_Folate @"Folate_Tot_(µg)"

#define kFatFactor 1/9 //means 1g fat contains 9Kcal energy
#define kCarbFactor 1/4 //means 1g carbohydrt contains 4Kcal energy
#define LZUserSexKey @"LZUserSexKey" //int 0 means male 1 means female
#define LZUserAgeKey @"LZUserAgeKey" //int 
#define LZUserHeightKey @"LZUserHeightKey"//int cm
#define LZUserWeightKey @"LZUserWeightKey"//int kg
#define LZUserActivityLevelKey @"LZUserActivityLevelKey"//int 0 means Sedentary,1 means Low Active,2 means Active,3 means Very Active
#define LZUserDailyIntakeKey @"LZUserDailyIntakeKey" //a dictionary for user daily intake
//#define LZPlanPersonsKey @"LZPersonAmountKey"//int
//#define LZPlanDaysKey @"LZPlanDaysKey"//int
#define LZUserBirthKey @"LZUserBirthKey" // NSDate object

#define LZSettingKey_randomSelectFood @"randomSelectFood" //BOOL
#define LZSettingKey_randomRangeSelectFood @"randomRangeSelectFood" //int
#define LZSettingKey_needLimitNutrients @"needLimitNutrients" //BOOL
#define LZSettingKey_limitRecommendFoodCount @"limitRecommendFoodCount" //int
#define LZSettingKey_notAllowSameFood @"notAllowSameFood" //BOOL
#define LZSettingKey_needUseFoodLimitTableWhenCal @"needUseFoodLimitTableWhenCal"
#define LZSettingKey_needUseLessAsPossibleFood @"needUseLessAsPossibleFood"
#define LZSettingKey_upperLimitTypeForSupplyAsPossible @"upperLimitTypeForSupplyAsPossible"

#define LZSettingKey_needConsiderNutrientLoss @"needConsiderNutrientLoss"
//#define LZSettingKey_needUseLowLimitAsUnit @"needUseLowLimitAsUnit"
#define LZSettingKey_needUseDefinedIncrementUnit @"needUseDefinedIncrementUnit"
#define LZSettingKey_needUseNormalLimitWhenSmallIncrementLogic @"needUseNormalLimitWhenSmallIncrementLogic"
#define LZSettingKey_needUseFirstRecommendWhenSmallIncrementLogic @"needUseFirstRecommendWhenSmallIncrementLogic"
#define LZSettingKey_needFirstSpecialForShucaiShuiguo @"needFirstSpecialForShucaiShuiguo"
#define LZSettingKey_needSpecialForFirstBatchFoods @"needSpecialForFirstBatchFoods"
#define LZSettingKey_alreadyChoosedFoodHavePriority @"alreadyChoosedFoodHavePriority"
#define LZSettingKey_needPriorityFoodToSpecialNutrient @"needPriorityFoodToSpecialNutrient"
#define LZSettingKey_randSeed @"randSeed"
#define LZSettingKey_randSeedOut @"randSeedOut"

#define LZSettingKey_alreadyLoadFromRemote @"alreadyLoadFromRemote"

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
#define COLUMN_NAME_CnCaption @"CnCaption"  // 食物的中文名
#define COLUMN_NAME_FoodNameEn @"FoodNameEn" //食物的英文名
#define COLUMN_NAME_CnType @"CnType"
#define COLUMN_NAME_classify @"classify" //食物的内部分类
#define TABLE_NAME_FoodCnDescription @"FoodCnDescription" // TO BE changed to CustomFood
#define TABLE_NAME_FoodCustom @"FoodCustom"

#define COLUMN_NAME_SingleItemUnitName @"SingleItemUnitName"
#define COLUMN_NAME_SingleItemUnitWeight @"SingleItemUnitWeight"

#define TABLE_NAME_Food_Supply_DRI_Common @"Food_Supply_DRI_Common"
#define TABLE_NAME_Food_Supply_DRI_Amount @"Food_Supply_DRI_Amount"
#define TABLE_NAME_Food_Supply_DRIUL_Amount @"Food_Supply_DRIUL_Amount"

//#define TABLE_NAME_FoodLimit @"FoodLimit"
#define COLUMN_NAME_Lower_Limit @"Lower_Limit(g)"
#define COLUMN_NAME_Upper_Limit @"Upper_Limit(g)"
#define COLUMN_NAME_normal_value @"normal_value"
#define COLUMN_NAME_first_recommend @"first_recommend"
#define COLUMN_NAME_increment_unit @"increment_unit"

#define TABLE_NAME_NutritionInfo @"NutritionInfo"
#define COLUMN_NAME_NutrientID @"NutrientID"

#define COLUMN_NAME_NutrientCnCaption @"NutrientCnCaption"
#define COLUMN_NAME_NutrientEnCaption @"NutrientEnCaption"
#define COLUMN_NAME_NutrientEnUnit @"NutrientEnUnit"
#define COLUMN_NAME_LossRate @"LossRate"
#define COLUMN_NAME_NutrientDescription @"NutrientDescription"

//#define TABLE_NAME_FoodPicPath @"FoodPicPath"
#define COLUMN_NAME_PicPath @"PicPath"

#define TABLE_NAME_FoodCollocation @"FoodCollocation"
#define TABLE_NAME_CollocationFood @"CollocationFood"
#define TABLE_NAME_FoodCollocationParam @"FoodCollocationParam"
#define COLUMN_NAME_CollocationId @"CollocationId"
#define COLUMN_NAME_CollocationName @"CollocationName"
#define COLUMN_NAME_CollocationCreateTime @"CollocationCreateTime"
#define COLUMN_NAME_FoodId @"FoodId"
#define COLUMN_NAME_FoodAmount @"FoodAmount"
#define KEY_NAME_ParseObjectId @"ParseObjectId"
#define COLUMN_NAME_ParamName @"ParamName"
#define COLUMN_NAME_ParamValue @"ParamValue"


#define TABLE_NAME_CustomRichFood @"CustomRichFood"
#define TABLE_NAME_CustomRichFood2 @"CustomRichFood2"

#define COLUMN_NAME_MinUpperAmount @"MinUpperAmount"
#define COLUMN_NAME_MinAdequateAmount @"MinAdequateAmount"
#define COLUMN_NAME_MaxAdequateAmount @"MaxAdequateAmount"
#define COLUMN_NAME_NutrientID_max @"NutrientID_max"
#define COLUMN_NAME_NutrientID_min @"NutrientID_min"

#define TABLE_NAME_DiseaseNutrient @"DiseaseNutrient"
#define TABLE_NAME_DiseaseGroup @"DiseaseGroup"
#define TABLE_NAME_DiseaseInGroup @"DiseaseInGroup"
#define COLUMN_NAME_Disease @"Disease"
#define COLUMN_NAME_DiseaseEn @"DiseaseEn"
#define COLUMN_NAME_DiseaseGroup @"DiseaseGroup"
#define COLUMN_NAME_dsGroupType @"dsGroupType"
//#define COLUMN_NAME_dsGroupWizardOrder @"dsGroupWizardOrder" //TODO delete
#define COLUMN_NAME_DiseaseDepartment @"DiseaseDepartment"
#define COLUMN_NAME_DiseaseType @"DiseaseType"
#define COLUMN_NAME_DiseaseTimeType @"DiseaseTimeType"
#define COLUMN_NAME_LackLevelMark @"LackLevelMark"

#define TABLE_NAME_UserCheckDiseaseRecord @"UserCheckDiseaseRecord"
#define COLUMN_NAME_Day @"Day"
#define COLUMN_NAME_TimeType @"TimeType"

#define TABLE_NAME_TranslationItem @"TranslationItem"
#define COLUMN_NAME_ItemType @"ItemType"
#define COLUMN_NAME_ItemID @"ItemID"
#define COLUMN_NAME_ItemNameCn @"ItemNameCn"
#define COLUMN_NAME_ItemNameEn @"ItemNameEn"


#define TABLE_NAME_SymptomType @"SymptomType"
#define TABLE_NAME_Symptom @"Symptom"
#define TABLE_NAME_SymptomNutrient @"SymptomNutrient"
#define TABLE_NAME_SymptomPossibleIllness @"SymptomPossibleIllness"
#define TABLE_NAME_Illness @"Illness"
#define TABLE_NAME_IllnessToSuggestion @"IllnessToSuggestion"
#define TABLE_NAME_IllnessSuggestion @"IllnessSuggestion"
#define COLUMN_NAME_SymptomTypeId @"SymptomTypeId"
#define COLUMN_NAME_DisplayOrder @"DisplayOrder"
#define COLUMN_NAME_SymptomTypeNameCn @"SymptomTypeNameCn"
#define COLUMN_NAME_SymptomTypeNameEn @"SymptomTypeNameEn"
#define COLUMN_NAME_ForSex @"ForSex"
#define COLUMN_NAME_SymptomId @"SymptomId"
#define COLUMN_NAME_SymptomNameCn @"SymptomNameCn"
#define COLUMN_NAME_SymptomNameEn @"SymptomNameEn"
#define COLUMN_NAME_HealthMark @"HealthMark"
#define COLUMN_NAME_IllnessId @"IllnessId"
#define COLUMN_NAME_IllnessNameCn @"IllnessNameCn"
#define COLUMN_NAME_IllnessNameEn @"IllnessNameEn"
#define COLUMN_NAME_UrlCn @"UrlCn"
#define COLUMN_NAME_UrlEn @"UrlEn"

#define TABLE_NAME_UserRecordSymptom @"UserRecordSymptom"
#define COLUMN_NAME_DayLocal @"DayLocal"
#define COLUMN_NAME_UpdateTimeUTC @"UpdateTimeUTC"

#define COLUMN_NAME_inputNameValuePairs @"inputNameValuePairs"
#define COLUMN_NAME_Note @"Note"
#define COLUMN_NAME_calculateNameValuePairs @"calculateNameValuePairs"
#define COLUMN_NAME_SuggestionId @"SuggestionId"
#define COLUMN_NAME_SuggestionCn @"SuggestionCn"
#define COLUMN_NAME_SuggestionEn @"SuggestionEn"


#define ForSex_both @"both"
#define ForSex_male @"male"
#define ForSex_female @"female"

#define Key_HeartRate @"HeartRate"
#define Key_BloodPressureLow @"BloodPressureLow"
#define Key_BloodPressureHigh @"BloodPressureHigh"
#define Key_BodyTemperature @"BodyTemperature"
#define Key_Weight ParamKey_weight

#define Key_Symptoms @"Symptoms"
#define Key_SymptomsByType @"SymptomsByType"
//#define Key_Temperature @"Temperature"
#define Key_BMI @"BMI"
//#define Key_LackNutrientIDs @"LackNutrientIDs"
#define Key_LackNutrientsAndFoods @"LackNutrientsAndFoods"
#define Key_InferIllnessesAndSuggestions @"InferIllnessesAndSuggestions"
#define Key_IllnessIds @"IllnessIds"
#define Key_distinctSuggestionIds @"distinctSuggestionIds"
//#define Key_InferIllnesses @"InferIllnesses"
#define Key_HealthMark @"HealthMark"
//#define Key_RecommendFoodAndAmounts @"RecommendFoodAndAmounts"
//#define Key_Suggestions @"Suggestions"
#define Key_NutrientsWithFoodAndAmounts @"NutrientsWithFoodAndAmounts"



#define TranslationItemType_FoodCnType @"FoodCnType"
#define TranslationItemType_SingleItemUnitName @"SingleItemUnitName"

#define DiseaseGroupType_wizard @"wizard"
#define DiseaseGroupType_specialPeople @"specialPeople"
#define DiseaseGroupType_discomfort @"discomfort"
#define DiseaseGroupType_healthCare @"healthCare"
#define DiseaseGroupType_illness @"illness"
#define DiseaseGroupType_DailyDiseaseDiagnose @"DailyDiseaseDiagnose"

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
#define Key_recommendFoodAttrDict @"recommendFoodAttrDict"

#define Key_TakenFoodAmount @"TakenFoodAmount"
#define Key_TakenFoodAttr @"TakenFoodAttr"

#define Key_optionsDict @"optionsDict"
#define Key_paramsDict @"paramsDict"
#define Key_outRows @"outRows"

#define Key_preChooseFoodInfoDict @"preChooseFoodInfoDict"
#define Key_preChooseRichFoodInfoAryDict @"preChooseRichFoodInfoAryDict"

#define Key_nutrientInitialSupplyRate @"nutrientInitialSupplyRate"
#define Key_nutrientSupplyRate @"nutrientSupplyRate"
#define Key_nutrientTakenRateInfoArray @"nutrientTakenRateInfoArray"
#define Key_nutrientTotalSupplyRateInfoArray @"nutrientTotalSupplyRateInfoArray"
#define Key_food1Supply1NutrientAmount @"food1Supply1NutrientAmount"
#define Key_supplyNutrientAmount @"supplyNutrientAmount"
#define Key_nutrientTotalDRI @"nutrientTotalDRI"
#define Key_1foodSupply1NutrientRate @"1foodSupply1NutrientRate"
#define Key_supplyNutrientRate @"supplyNutrientRate"
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

#define kProgressBarRect CGRectMake(0,0,230,10)
#define kKeyBoardToolBarRect CGRectMake(0,0,320,44)
#define TopNavigationBarHeight 44
#define FoodTypeSelectorViewHeight 41
#define ItemSelectedColor [UIColor colorWithRed:67/255.f green:113/255.f blue:71/255.f alpha:0.2f]

#define Notification_TakenFoodChangedKey @"KeyTakenFoodChangedNotification"
#define Notification_SettingsChangedKey @"KeySettingsChangedNotification"
#define Notification_TakenFoodDeletedKey @"KeyTakenFoodDeletedNotification"
#define Notification_HistoryUpdatedKey @"KeyHistoryUpdatedNotification"

#define UMSDKAPPKey @"51b96cc356240b6ee80a05dc"
#define ShareSDKAPPKey @"4d8c71c46cb"
#define LocalNotifyTimeInterval (72*60*60) // 72 hours

#define MobChannelIdTongbu @"TongbuTui"
#define MobChannelId91Store @"91Store"
#define MobChannelId25pp @"25pp"

#define KeyIsAlreadyReviewdeOurApp @"KeyIsAlreadyReviewdeOurApp" // YES means already reviewed
#define KeyReviewAlertControllCount @"KeyReviewAlertControllCount" // >=10 popAlert
#define KeyHealthCheckReminderState @"KeyHealthCheckReminderState"

#define KeyCheckReminderShangWu @"KeyCheckReminderShangWu"
#define KeyCheckReminderXiaWu @"KeyCheckReminderXiaWu"
#define KeyCheckReminderShuiQian @"KeyCheckReminderShuiQian"

#define MY_BANNER_UNIT_ID @"a151bfe57a8e242"//admob key

//share config info
#define SinaWeiboAppKey @"2194086998"
#define SinaWeiboAppSecret @"626218cc582db24b710fcb5510801393"
//#define SinaWeiboAppKey @"3626415671"
//#define SinaWeiboAppSecret @"9d17e75a675323f5b719cb058c5b9d0d"

#define WeChatAppId @"wxe7284abf139401f5"
#define kKGConvertLBRatio 2.2046

//百度广告APP SID 和计费名
#define BaiduAdsAppSID @"f06ac562"
#define BaiduAdsAppSpec @"f06ac562"
#define UmengPathZhuYeMian @"主页面"
#define UmengPathShanShiQingDan @"膳食清单页面"
#define UmengPathYingYangDaPei @"营养搭配页面"
#define UmengPathShiWuXiangQing @"食物详情页面"
#define UmengPathShiWuZhongLeiErJi @"食物种类二级页面"
#define UmengPathSheZhi @"设置页面"
#define UmengPathYingYangSuTianJia @"按营养素添加食物页面"
#define UmengPathWeiBoFenXiang @"微博分享页面"
#define UmengPathGeRenXinXi @"个人信息页面"
#define UmengPathQingDanTiaoXuan @"清单挑选页面"
#define UmengPathShiWuChaXun @"食物查询页面"
#define UmengPathYingYangYuanSu @"营养元素页面"
#define UmengPathYingYangFuHan @"营养素富含食物页面"
#define UmengPathJianKangZhenDuan @"健康诊断页面"
#define UmengPathZhenDuanJieGuo @"诊断结果页面"
#define UmengPathTiXingSheZhi @"提醒设置页面"

#define UmengEventTuiJian @"Recommend"
#define UmengEventHuanYiZu @"ChangeFood"
#define UmengEventZhenDuan @"HealthCheck"


#define SeperatorForNames @",,"

//#define Seperator_Level1 @";;;"
//#define Seperator_Level2 @",,,"
//#define Seperator_NameToValue @"="

#define KeyNotifyTimeTypeShangWu @"1"
#define KeyNotifyTimeTypeXiaWu @"2"
#define KeyNotifyTimeTypeShuiQian @"3"
#define KeyNotifyTimeTypeReminder @"10"

typedef void (^JustCallbackBlock)(BOOL succeeded);



#endif

















