package com.lingzhimobile.nutritionfoodguide.test;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

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
		test_calculateGiveStaticFoodsDynamicFoodSupplyNutrientAndFormatForUI(ctx);
	}
	
	static void test1(Context ctx){
		DataAccess da = DataAccess.getSingleTon(ctx);
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
	    
	    DataAccess da = DataAccess.getSingleTon(ctx);
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

}
