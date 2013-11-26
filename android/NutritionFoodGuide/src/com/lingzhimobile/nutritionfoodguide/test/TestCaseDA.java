package com.lingzhimobile.nutritionfoodguide.test;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import com.lingzhimobile.nutritionfoodguide.ActivityFoodCombination;
import com.lingzhimobile.nutritionfoodguide.Constants;
import com.lingzhimobile.nutritionfoodguide.DataAccess;
import com.lingzhimobile.nutritionfoodguide.RecommendFood;
import com.lingzhimobile.nutritionfoodguide.Tool;

import android.content.Context;
import android.util.Log;

public class TestCaseDA {
	final static String LogTag = "TestCaseDA";
	
	public static void testMain(Context ctx){
//		test1(ctx);
//		test_calculateGiveStaticFoodsDynamicFoodSupplyNutrientAndFormatForUI(ctx);
//		test_foodCollocationApis(ctx);
		test_Symptom1(ctx);
	}
	
	static void test1(Context ctx){
		DataAccess da = DataAccess.getSingleton(ctx);
		da.getDRIbyGender(Constants.Gender_female	, 30);
	}
	
	
	static HashMap<String, Object> getUserInfo()
	{
		HashMap<String, Object> hmUserInfo = new HashMap<String, Object>();
		int sex = 0;//Male
	    int age = 25;
	    double weight=72;//kg
	    double height = 180;//cm
	    int activityLevel = 0;//0--3
		hmUserInfo.put(Constants.ParamKey_sex, Integer.valueOf(sex));
		hmUserInfo.put(Constants.ParamKey_age, Integer.valueOf(age));
		
		hmUserInfo.put(Constants.ParamKey_weight, Double.valueOf(weight));
		hmUserInfo.put(Constants.ParamKey_height, Double.valueOf(height));
		
		hmUserInfo.put(Constants.ParamKey_activityLevel, Integer.valueOf(activityLevel));
		
		return hmUserInfo;
	}
	
	static void test_calculateGiveStaticFoodsDynamicFoodSupplyNutrientAndFormatForUI(Context ctx){
		HashMap<String, Object> userInfo = getUserInfo();
		
		HashMap<String, Double> staticFoodAmountDict = new HashMap<String, Double>();
		staticFoodAmountDict.put("20450", Double.valueOf(200));//rice
		staticFoodAmountDict.put("16108", Double.valueOf(100));//huangdou
		
		String dynamicFoodId = "09003";
	    Double dObj_dynamicFoodAmount = Double.valueOf(200);
	    
	    Object[] staticFoodIdObjs = staticFoodAmountDict.keySet().toArray();
	    ArrayList<String> allFoodIdList = Tool.convertFromArrayToList( Tool.convertToStringArray(staticFoodIdObjs) );
	    allFoodIdList.add(dynamicFoodId);
	    String[] allFoodIds = Tool.convertToStringArray(allFoodIdList);
	    
	    DataAccess da = DataAccess.getSingleton(ctx);
	    ArrayList<HashMap<String, Object>> allFoodAttrAry = da.getFoodAttributesByIds(allFoodIds);
	    HashMap<String, HashMap<String, Object>> allFoodAttr2LevelDict = Tool.dictionaryArrayTo2LevelDictionary_withKeyName(Constants.COLUMN_NAME_NDB_No, allFoodAttrAry);
	    HashMap<String, Object> dynamicFoodAttrs = allFoodAttr2LevelDict.get(dynamicFoodId);
	    
	    RecommendFood rf = new RecommendFood(ctx);
	    HashMap<String, Object> params = new HashMap<String, Object>();
	    params.put(Constants.Key_userInfo, userInfo);
	    params.put("dynamicFoodAttrs", dynamicFoodAttrs);
	    params.put("dynamicFoodAmount", dObj_dynamicFoodAmount);
	    params.put("staticFoodAttrsDict2Level", allFoodAttr2LevelDict);
	    params.put("staticFoodAmountDict", staticFoodAmountDict);
	    rf.calculateGiveStaticFoodsDynamicFoodSupplyNutrientAndFormatForUI(params);

	}
	
	static void test_foodCollocationApis(Context ctx){
		DataAccess da = DataAccess.getSingleton(ctx);
		
		String collationName;
    	ArrayList<Object[]> foodAmount2LevelArray;
    	Object[] foodAmountPair;
    	long collocationId;
    	
    	collationName = "collationName "+(new Date()).toString();
    	foodAmount2LevelArray = new ArrayList<Object[]>();
    	foodAmountPair = new Object[]{"20450", Double.valueOf(101)};
		foodAmount2LevelArray.add(foodAmountPair);
		foodAmountPair = new Object[]{"16108", Double.valueOf(102)};
		foodAmount2LevelArray.add(foodAmountPair);
    	collocationId = da.insertFoodCollocationData_withCollocationName(collationName, foodAmount2LevelArray);
    	Log.d(LogTag, "collocationId1="+collocationId);
    	
    	collationName = "collationName "+(new Date()).toString();
    	foodAmount2LevelArray = new ArrayList<Object[]>();
    	foodAmountPair = new Object[]{"09003", Double.valueOf(201)};
		foodAmount2LevelArray.add(foodAmountPair);
		collocationId = da.insertFoodCollocationData_withCollocationName(collationName, foodAmount2LevelArray);
    	Log.d(LogTag, "collocationId2="+collocationId);
    	
    	da.getAllFoodCollocation();
    	
    	collationName = "collationName2 "+(new Date()).toString();
    	foodAmount2LevelArray = new ArrayList<Object[]>();
    	foodAmountPair = new Object[]{"09003", Double.valueOf(221)};
		foodAmount2LevelArray.add(foodAmountPair);
		foodAmountPair = new Object[]{"16108", Double.valueOf(222)};
		foodAmount2LevelArray.add(foodAmountPair);
		da.updateFoodCollocationData_withCollocationId(collocationId, collationName, foodAmount2LevelArray);
		
		da.getAllFoodCollocation();
		
		da.getFoodCollocationData_withCollocationId(collocationId);
		
		
	}
	
	static void test_Symptom1(Context ctx){
		DataAccess da = DataAccess.getSingleton(ctx);
		
		ArrayList<HashMap<String, Object>> symptomTypeRows = da.getSymptomTypeRows_withForSex(Constants.ForSex_male);
		ArrayList<Object> symptomTypeIdObjs = Tool.getPropertyArrayListFromDictionaryArray_withPropertyName(Constants.COLUMN_NAME_SymptomTypeId, symptomTypeRows);
		ArrayList<String> symptomTypeIds = Tool.convertToStringArrayList(symptomTypeIdObjs);
		Log.d(LogTag, "symptomTypeIds="+Tool.getIndentFormatStringOfObject(symptomTypeIds, 0));
		da.getSymptomRowsByTypeDict_BySymptomTypeIds(symptomTypeIds);
		
		ArrayList<String> symptomIdList = Tool.convertFromArrayToList(new String[]{"头晕", "头发脱落", "易疲劳", "易流泪"});
		ArrayList<String> nutrientIdList = da.getSymptomNutrientDistinctIds_BySymptomIds(symptomIdList);
		
//		HashMap<String, HashMap<String, Object>> nutrientInfoDict2Level = da.getNutrientInfoAs2LevelDictionary_withNutrientIds(null);
//		HashMap<String, Object> nutrientInfo = nutrientInfoDict2Level.get(nutrientIdList.get(0));
	}

}



















