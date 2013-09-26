package com.lingzhimobile.nutritionfoodguide;

import android.R.integer;

public class Constants {
	
	public static final int KeyIsEnvironmentDebug = 0;
	
	public static final boolean Config_needConsiderNutrientLoss = false;
	public static final int Config_foodUpperLimit = 1000; // unit g
	public static final int Config_foodLowerLimit = 1; // unit g
	public static final int Config_foodNormalValue = 250; // unit g
	public static final double Config_nearZero = 0.0000001;
	public static final int Config_defaultFoodIncreaseUnit = 1;

	public static final boolean Config_ifNeedCustomDefinedFoods =true;

	public static final boolean Config_needLimitNutrients =true;
	//public static final boolean Config_needUseLowLimitAsUnit =true;
	public static final boolean Config_needUseDefinedIncrementUnit =true;
	public static final boolean Config_needUseNormalLimitWhenSmallIncrementLogic =true;
	public static final boolean Config_needUseFirstRecommendWhenSmallIncrementLogic =true; //FALSE //它为TRUE时，会导致补得过量经常发生，从而删掉某个少量的推荐的食物后再推荐可能会报营养已满不用推荐，从而让用户觉得算法有问题。不过，即使设置为false，算法仍然没有能彻底避免这种情况。但是，现在由于算法加了推荐后再减少食物的功能，这个问题不存在了。
	public static final boolean Config_needFirstSpecialForShucaiShuiguo =true;
	public static final boolean Config_needSpecialForFirstBatchFoods =true;
	public static final boolean Config_alreadyChoosedFoodHavePriority =true; //主要用于减少食物种类
	public static final boolean Config_needPriorityFoodToSpecialNutrient = false; //有了 alreadyChoosedFoodHavePriority 为true，感觉needPriorityFoodToSpecialNutrient的特色没必要了
	
	
	public static final String FoodClassify_gulei ="gulei";
	public static final String FoodClassify_gandoulei ="gandoulei";
	public static final String FoodClassify_shucai ="shucai";
	public static final String FoodClassify_shuiguo ="shuiguo";
	public static final String FoodClassify_ganguo ="ganguo";
	public static final String FoodClassify_nailei ="nailei";

	public static final String FoodClassify_rou ="rou";

	public static final String FoodClassify_rou_shui_yu ="rou-shui-yu";
	public static final String FoodClassify_rou_shui_xia ="rou-shui-xia";
	public static final String FoodClassify_rou_chu_rou ="rou-chu-rou";
	public static final String FoodClassify_rou_qin ="rou-qin";
	public static final String FoodClassify_danlei ="danlei";
	
	
	public static final String Gender_female = "female";
	public static final String Gender_male = "male";
	
	public static final String COLUMN_NAME_NDB_No = "NDB_No";
	
	public static final String NutrientId_Energe ="Energ_Kcal";
	public static final String NutrientId_Carbohydrt ="Carbohydrt_(g)";
	public static final String NutrientId_Lipid ="Lipid_Tot_(g)";
	public static final String NutrientId_Protein ="Protein_(g)";
	
	public static final String NutrientId_VC ="Vit_C_(mg)";
	public static final String NutrientId_VD ="Vit_D_(µg)";
	public static final String NutrientId_Magnesium ="Magnesium_(mg)";
	public static final String NutrientId_Fiber ="Fiber_TD_(g)";
	public static final String NutrientId_Folate ="Folate_Tot_(µg)";
	
	public static final String TABLE_NAME_USDA_ABBREV ="FoodNutrition";
	public static final String TABLE_NAME_DRIFemale ="DRIFemale";
	public static final String TABLE_NAME_DRIMale ="DRIMale";

	public static final String TABLE_NAME_DRIULFemale ="DRIULFemale";
	public static final String TABLE_NAME_DRIULMale ="DRIULMale";

	public static final String TABLE_NAME_DRIULrateFemale ="DRIULrateFemale";
	public static final String TABLE_NAME_DRIULrateMale ="DRIULrateMale";

	//public static final String TABLE_NAME_FoodNutritionCustom ="FoodNutritionCustom" // TO be replaced by CustomFood join FoodNutrition OR same name view
	public static final String VIEW_NAME_FoodNutritionCustom ="FoodNutritionCustom" ;
	public static final String COLUMN_NAME_CnCaption ="CnCaption";
	public static final String COLUMN_NAME_CnType ="CnType";
	public static final String COLUMN_NAME_classify ="classify";
	public static final String TABLE_NAME_FoodCnDescription ="FoodCnDescription"; // TO BE changed to CustomFood
	public static final String TABLE_NAME_FoodCustom ="FoodCustom";

	public static final String COLUMN_NAME_SingleItemUnitName ="SingleItemUnitName";
	public static final String COLUMN_NAME_SingleItemUnitWeight ="SingleItemUnitWeight";

	public static final String TABLE_NAME_Food_Supply_DRI_Common ="Food_Supply_DRI_Common";
	public static final String TABLE_NAME_Food_Supply_DRI_Amount ="Food_Supply_DRI_Amount";
	public static final String TABLE_NAME_Food_Supply_DRIUL_Amount ="Food_Supply_DRIUL_Amount";

	//public static final String TABLE_NAME_FoodLimit ="FoodLimit"
	public static final String COLUMN_NAME_Lower_Limit ="Lower_Limit(g)";
	public static final String COLUMN_NAME_Upper_Limit ="Upper_Limit(g)";
	public static final String COLUMN_NAME_normal_value ="normal_value";
	public static final String COLUMN_NAME_first_recommend ="first_recommend";
	public static final String COLUMN_NAME_increment_unit ="increment_unit";

	public static final String TABLE_NAME_NutritionInfo ="NutritionInfo";
	public static final String COLUMN_NAME_NutrientID ="NutrientID";

	public static final String COLUMN_NAME_NutrientCnCaption ="NutrientCnCaption";
	public static final String COLUMN_NAME_NutrientEnUnit ="NutrientEnUnit";
	public static final String COLUMN_NAME_LossRate ="LossRate";
	public static final String COLUMN_NAME_NutrientDescription ="NutrientDescription";

	//public static final String TABLE_NAME_FoodPicPath ="FoodPicPath"
	public static final String COLUMN_NAME_PicPath ="PicPath";

	public static final String TABLE_NAME_FoodCollocation ="FoodCollocation";
	public static final String TABLE_NAME_CollocationFood ="CollocationFood";
	public static final String TABLE_NAME_FoodCollocationParam ="FoodCollocationParam";
	public static final String COLUMN_NAME_CollocationId ="CollocationId";
	public static final String COLUMN_NAME_FoodId ="FoodId";
	public static final String COLUMN_NAME_FoodAmount ="FoodAmount";

	public static final String TABLE_NAME_CustomRichFood ="CustomRichFood";

	public static final String COLUMN_NAME_MinUpperAmount ="MinUpperAmount";
	public static final String COLUMN_NAME_MinAdequateAmount ="MinAdequateAmount";
	public static final String COLUMN_NAME_MaxAdequateAmount ="MaxAdequateAmount";
	public static final String COLUMN_NAME_NutrientID_max ="NutrientID_max";
	public static final String COLUMN_NAME_NutrientID_min ="NutrientID_min";

	public static final String TABLE_NAME_DiseaseNutrient ="DiseaseNutrient";
	public static final String TABLE_NAME_DiseaseGroup ="DiseaseGroup";
	public static final String TABLE_NAME_DiseaseInGroup ="DiseaseInGroup";
	public static final String COLUMN_NAME_Disease ="Disease";
	public static final String COLUMN_NAME_DiseaseGroup ="DiseaseGroup";
	public static final String COLUMN_NAME_dsGroupType ="dsGroupType";
	public static final String COLUMN_NAME_dsGroupWizardOrder ="dsGroupWizardOrder";
	public static final String COLUMN_NAME_DiseaseDepartment ="DiseaseDepartment";
	
	
	public static final String DiseaseGroupType_wizard ="wizard";
	public static final String DiseaseGroupType_specialPeople ="specialPeople";
	public static final String DiseaseGroupType_discomfort ="discomfort";
	public static final String DiseaseGroupType_healthCare ="healthCare";
	public static final String DiseaseGroupType_illness ="illness";

	public static final String Key_Amount ="Amount";
	public static final String Key_Name ="Name";
	public static final String Key_Unit ="Unit";
	public static final String Key_PicturePath ="PicturePath";
	public static final String Key_FoodAmount ="FoodAmount";
	public static final String Key_DRI ="DRI";
	public static final String Key_DRIUL ="DRIUL";
	public static final String Key_userInfo ="userInfo";

	public static final String Key_givenNutrients ="givenNutrients";

	public static final String Key_originalNutrientNameAryToCal ="originalNutrientNameAryToCal";
	//public static final String Key_takenFoodInfo2LevelDict ="takenFoodInfo2LevelDict"
	//public static final String Key_recommendFoodInfo2LevelDict ="recommendFoodInfo2LevelDict"
	public static final String Key_takenFoodInfoDictArray ="takenFoodInfoDictArray";
	public static final String Key_recommendFoodInfoDictArray ="recommendFoodInfoDictArray";
	public static final String Key_recommendFoodAmountDict ="recommendFoodAmountDict";

	public static final String Key_TakenFoodAmount ="TakenFoodAmount";
	public static final String Key_TakenFoodAttr ="TakenFoodAttr";

	public static final String Key_optionsDict ="optionsDict";
	public static final String Key_outRows ="outRows";

	public static final String Key_preChooseFoodInfoDict ="preChooseFoodInfoDict";
	public static final String Key_preChooseRichFoodInfoAryDict ="preChooseRichFoodInfoAryDict";

	public static final String Key_nutrientInitialSupplyRate ="nutrientInitialSupplyRate";
	public static final String Key_nutrientSupplyRate ="nutrientSupplyRate";
	public static final String Key_nutrientTakenRateInfoArray ="nutrientTakenRateInfoArray";
	public static final String Key_nutrientTotalSupplyRateInfoArray ="nutrientTotalSupplyRateInfoArray";
	public static final String Key_food1Supply1NutrientAmount ="food1Supply1NutrientAmount";
	public static final String Key_supplyNutrientAmount ="supplyNutrientAmount";
	public static final String Key_nutrientTotalDRI ="nutrientTotalDRI";
	public static final String Key_1foodSupply1NutrientRate ="1foodSupply1NutrientRate";
	public static final String Key_supplyNutrientRate ="supplyNutrientRate";
	public static final String Key_foodNutrientContent ="foodNutrientContent";
	public static final String Key_foodSupplyNutrientInfoAryDict ="foodSupplyNutrientInfoAryDict";
	public static final String Key_foodStandardNutrientInfoAryDict ="foodStandardNutrientInfoAryDict";
	public static final String Key_takenFoodNutrientInfoAryDictDict ="takenFoodNutrientInfoAryDictDict";
	public static final String Key_recommendFoodNutrientInfoAryDictDict ="recommendFoodNutrientInfoAryDictDict";

	public static final String Key_orderedGivenFoodIds1 ="orderedGivenFoodIds1";
	public static final String Key_orderedGivenFoodIds2 ="orderedGivenFoodIds2";
	public static final String Key_orderedGivenFoodIds ="orderedGivenFoodIds";
	public static final String Key_givenFoodInfoDict2Level ="givenFoodInfoDict2Level";
	public static final String Key_givenFoodAttrDict2Level ="givenFoodAttrDict2Level";
	public static final String Key_nutrientSupplyRateInfoArray ="nutrientSupplyRateInfoArray";
	public static final String Key_nutrientSupplyDict ="nutrientSupplyDict";

	public static final String KeyUserRecommendPreferNutrientArray ="UserRecommendPreferNutrientArray";
	public static final String Type_normalSet ="normalSet";
	public static final String Type_lastSet ="lastSet";

	public static final String Strategy_random  ="random";
	public static final String Strategy_max  ="max";

	
	
	
	public static final String LZSettingKey_randomSelectFood ="randomSelectFood" ;//BOOL
	public static final String LZSettingKey_randomRangeSelectFood ="randomRangeSelectFood" ;//int
	public static final String LZSettingKey_needLimitNutrients ="needLimitNutrients" ;//BOOL
	public static final String LZSettingKey_limitRecommendFoodCount ="limitRecommendFoodCount"; //int
	public static final String LZSettingKey_notAllowSameFood ="notAllowSameFood" ;//BOOL
	public static final String LZSettingKey_needUseFoodLimitTableWhenCal ="needUseFoodLimitTableWhenCal";
	public static final String LZSettingKey_needUseLessAsPossibleFood ="needUseLessAsPossibleFood";
	public static final String LZSettingKey_upperLimitTypeForSupplyAsPossible ="upperLimitTypeForSupplyAsPossible";

	public static final String LZSettingKey_needConsiderNutrientLoss ="needConsiderNutrientLoss";
	//public static final String LZSettingKey_needUseLowLimitAsUnit ="needUseLowLimitAsUnit";
	public static final String LZSettingKey_needUseDefinedIncrementUnit ="needUseDefinedIncrementUnit";
	public static final String LZSettingKey_needUseNormalLimitWhenSmallIncrementLogic ="needUseNormalLimitWhenSmallIncrementLogic";
	public static final String LZSettingKey_needUseFirstRecommendWhenSmallIncrementLogic ="needUseFirstRecommendWhenSmallIncrementLogic";
	public static final String LZSettingKey_needFirstSpecialForShucaiShuiguo ="needFirstSpecialForShucaiShuiguo";
	public static final String LZSettingKey_needSpecialForFirstBatchFoods ="needSpecialForFirstBatchFoods";
	public static final String LZSettingKey_alreadyChoosedFoodHavePriority ="alreadyChoosedFoodHavePriority";
	public static final String LZSettingKey_needPriorityFoodToSpecialNutrient ="needPriorityFoodToSpecialNutrient";
	public static final String LZSettingKey_randSeed ="randSeed";
	public static final String LZSettingKey_randSeedOut ="randSeedOut";

	
	public static final String ParamKey_sex ="sex";//int 0 means male 1 means female
	public static final String ParamKey_age ="age";//int 
	public static final String ParamKey_weight ="weight";//int cm
	public static final String ParamKey_height ="height";//int kg
	public static final String ParamKey_activityLevel ="activityLevel";//int 0 means Sedentary,1 means Low Active,2 means Active,3 means Very Active
	
	public static final int Value_sex_male = 0;
	public static final int Value_sex_female = 1;
	
	public static final int Value_activityLevel_light = 0;
	public static final int Value_activityLevel_middle = 1;
	public static final int Value_activityLevel_strong = 2;
	public static final int Value_activityLevel_veryStrong = 3;
	

}
