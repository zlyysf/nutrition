package com.lingzhimobile.nutritionfoodguide.test;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

import com.lingzhimobile.nutritionfoodguide.Constants;
import com.lingzhimobile.nutritionfoodguide.DataAccess;
import com.lingzhimobile.nutritionfoodguide.RecommendFood;
import com.lingzhimobile.nutritionfoodguide.Tool;

import android.R.integer;
import android.content.Context;
import android.util.Log;

public class TestCaseRecommendFood {
	final static String LogTag = "TestCaseRecommendFood";
	
	public static void testMain(Context ctx){
//		test1(ctx);
		test_calculateGiveFoodsSupplyNutrientAndFormatForUI_withRecommend(ctx);
	}
	
	static void test1(Context ctx){
		
	}
	
	static void  test_calculateGiveFoodsSupplyNutrientAndFormatForUI_withRecommend(Context ctx)
	{
		assert(false);//run无效，debug有效......
		HashMap<String, Object> userInfo = getUserInfo();
		
		HashMap<String, Double> takenFoodAmountDict = new HashMap<String, Double>();
		takenFoodAmountDict.put("20450", Double.valueOf(200));//rice
		takenFoodAmountDict.put("16108", Double.valueOf(100));//huangdou
	    

	    boolean needConsiderNutrientLoss = false;
	    //    boolean needLimitNutrients = false;
	    boolean needUseDefinedIncrementUnit = true;
	    boolean needUseNormalLimitWhenSmallIncrementLogic = true;
	    long randSeed = 0; //0; //0;
	    HashMap<String, Object> options = new HashMap<String, Object>();
	    options.put(Constants.LZSettingKey_needConsiderNutrientLoss, Boolean.valueOf(needConsiderNutrientLoss));
//	    options.put(Constants.LZSettingKey_needLimitNutrients,Boolean.valueOf(needLimitNutrients) );
	    options.put(Constants.LZSettingKey_needUseDefinedIncrementUnit, Boolean.valueOf(needUseDefinedIncrementUnit) );
	    options.put(Constants.LZSettingKey_needUseNormalLimitWhenSmallIncrementLogic, Boolean.valueOf(needUseNormalLimitWhenSmallIncrementLogic));
	    options.put(Constants.LZSettingKey_randSeed, Long.valueOf(randSeed) );
	    
//	    NSString *paramsDigestStr = [self.class getParamsDigestStr_withUserInfo:userInfo andOptions:options andTakenFoodAmountDict:takenFoodAmountDict];
//	    NSString *csvFileName = [NSString stringWithFormat:@"recBySI_%@.csv",paramsDigestStr ];
//	    NSString *htmlFileName = [NSString stringWithFormat:@"recBySI_%@.html",paramsDigestStr ];
//	    NSLog(@"csvFileName=%@\nhtmlFileName=%@",csvFileName,htmlFileName);
//	    
//	    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	    NSString *documentsDirectory = [paths objectAtIndex:0];
//	    NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:htmlFileName];
//	    NSLog(@"htmlFilePath=%@",htmlFilePath);
	    
	    RecommendFood rf = new RecommendFood(ctx);
	    HashMap<String, Object> retDict = rf.recommendFoodBySmallIncrementWithPreIntakeOut(takenFoodAmountDict,userInfo,options,null);

//	    HashMap<String, Double> recommendFoodAmountDict = (HashMap<String, Double>)retDict.get(Constants.Key_recommendFoodAmountDict);
//	    
//	    HashMap<String, Object> params = new HashMap<String, Object>();
//	    params.put(Constants.Key_userInfo, userInfo);
//
//	    params.put("givenFoodsAmount1", takenFoodAmountDict);
//	    params.put("givenFoodsAmount2", recommendFoodAmountDict);
//	    Object formatResult = rf.calculateGiveFoodsSupplyNutrientAndFormatForUI(params);
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
	
	

}
