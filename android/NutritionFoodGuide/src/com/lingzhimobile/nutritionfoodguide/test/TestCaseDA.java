package com.lingzhimobile.nutritionfoodguide.test;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import org.json.JSONException;
import org.json.JSONObject;

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
//		test_Symptom1(ctx);
//		test_inferIllnesses_withSymptoms1(ctx);
//		test_getIllnessSuggestionsDistinct1(ctx);
//		test_JsonTool();
		test_dalUserRecordSymptom1(ctx);
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
	
	static void test_inferIllnesses_withSymptoms1(Context ctx){
		String[] symptomIds = {"咽喉发痒","咽喉灼热","咳嗽",
            "咳痰","喘息",
            "食欲不振","恶心","呕吐","上腹痛"};
		HashMap<String, Object> measureData = new HashMap<String, Object>();
		measureData.put(Constants.Key_HeartRate, Integer.valueOf(101));
		measureData.put(Constants.Key_BloodPressureHigh, Integer.valueOf(150));
		measureData.put(Constants.Key_BloodPressureLow, Integer.valueOf(130));
		measureData.put(Constants.Key_BodyTemperature, Double.valueOf(38.4));

		ArrayList<String> illnessList = Tool.inferIllnesses_withSymptoms(Tool.convertFromArrayToList(symptomIds),measureData);
		Log.d(LogTag, "illnessList=" + Tool.getIndentFormatStringOfObject(illnessList, 0));
	}
	
	static void test_getIllnessSuggestionsDistinct1(Context ctx)
	{
		String[] illnessIds = {"感冒", "急性病毒性咽炎", "轻度高血压", "骨关节炎"};
		DataAccess da = DataAccess.getSingleton(ctx);
	    da.getIllnessSuggestionsDistinct_ByIllnessIds(Tool.convertFromArrayToList(illnessIds));
	}
	
	static void test_JsonTool(){
		HashMap<String, Object> hm1 = new HashMap<String, Object>();
		hm1.put("key1", "aaa");
		hm1.put("key2", 1.23);
		ArrayList<Object> list1 = new ArrayList<Object>();
		list1.add("www");
		list1.add(2.34);
		hm1.put("key3", list1);
		
		HashMap<String, Object> hm11 = new HashMap<String, Object>();
		hm11.put("key11", "bbb");
		hm11.put("key12", 34.56);
		hm1.put("key4", hm11);
		
		ArrayList<Object> list2 = new ArrayList<Object>();
		list2.add("list2");
		list2.add(hm11);
		hm1.put("key5", list2);
		
		HashMap<String, Object> hm12 = new HashMap<String, Object>();
		hm12.put("key21", "bbb");
		hm12.put("key22", list1);
		hm1.put("key6", hm12);
		
		JSONObject jsonObj = Tool.HashMapToJsonObject(hm1);
		String jsonStr = jsonObj.toString();
		Log.d(LogTag, "jsonObj toStr=" + jsonStr);
		
		JSONObject jsonObj2;
		try {
			jsonObj2 = new JSONObject(jsonStr);
		} catch (JSONException e) {
			throw new RuntimeException(e);
		}
		HashMap<String, Object> hm2 = Tool.JsonToHashMap(jsonObj2);
		Log.d(LogTag, "hm2=" + Tool.getIndentFormatStringOfObject(hm2, 0));
	}
	
	static void test_dalUserRecordSymptom1(Context ctx)
	{
		DataAccess da = DataAccess.getSingleton(ctx);
		
		int dayLocal = 20120304;
	    Date updateTime = new Date();
	    HashMap<String, Object> InputNameValuePairsData;
	    HashMap<String, Object> CalculateNameValuePairsData;
	    HashMap<String, Object> RecommendFoodAndAmounts;
	    HashMap<String, Object> LackNutrientsAndFoods, InferIllnessesAndSuggestions;
	    
	    String note = "note1";
	    
	    
	    Object[] Symptoms = new Object[]{"s11",1.23};
	    InputNameValuePairsData = new HashMap<String, Object>();
	    InputNameValuePairsData.put(Constants.Key_Symptoms, Symptoms);
	    InputNameValuePairsData.put(Constants.Key_Temperature, Double.valueOf(36.7));
	    InputNameValuePairsData.put(Constants.Key_Weight, Double.valueOf(67.8));
	    InputNameValuePairsData.put(Constants.Key_HeartRate, Integer.valueOf(61));
	    InputNameValuePairsData.put(Constants.Key_BloodPressureLow, Integer.valueOf(80));
	    InputNameValuePairsData.put(Constants.Key_BloodPressureHigh, Integer.valueOf(140));

	    CalculateNameValuePairsData = new HashMap<String, Object>();
	    CalculateNameValuePairsData.put(Constants.Key_BMI, Double.valueOf(23.4));
	    CalculateNameValuePairsData.put(Constants.Key_HealthMark, Double.valueOf(87.5));
//	    CalculateNameValuePairsData.put("LackNutrientIDs", new String[]{"B1","VC"});
//	    CalculateNameValuePairsData.put("InferIllnesses", new String[]{"ill11","ill12"});
//	    CalculateNameValuePairsData.put("Suggestions", new String[]{"a11","a12"});
	    RecommendFoodAndAmounts = new HashMap<String, Object>();
	    RecommendFoodAndAmounts.put("10001", Integer.valueOf(100));
	    RecommendFoodAndAmounts.put("10002", Integer.valueOf(150));
//	    CalculateNameValuePairsData.put("RecommendFoodAndAmounts", RecommendFoodAndAmounts);
	    LackNutrientsAndFoods = new HashMap<String, Object>();
	    LackNutrientsAndFoods.put("Vb1", RecommendFoodAndAmounts);
	    RecommendFoodAndAmounts = new HashMap<String, Object>();
	    RecommendFoodAndAmounts.put("10011", Integer.valueOf(100));
	    RecommendFoodAndAmounts.put("10012", Integer.valueOf(150));
	    LackNutrientsAndFoods.put("Vb2", RecommendFoodAndAmounts);
	    CalculateNameValuePairsData.put(Constants.Key_LackNutrientsAndFoods, LackNutrientsAndFoods);
	    
	    InferIllnessesAndSuggestions = new HashMap<String, Object>();
	    InferIllnessesAndSuggestions.put("illness11", new Object[]{"Suggestion11","Suggestion12"});
	    InferIllnessesAndSuggestions.put("illness12", new Object[]{"Suggestion21","Suggestion22"});
	    CalculateNameValuePairsData.put(Constants.Key_InferIllnessesAndSuggestions, InferIllnessesAndSuggestions);
	    

	    da.deleteUserRecordSymptomByByDayLocal(dayLocal);
	    
	    da.insertUserRecordSymptom_withDayLocal(dayLocal,updateTime,InputNameValuePairsData,note,CalculateNameValuePairsData);
	    da.getUserRecordSymptomDataByDayLocal(dayLocal);
	    
//	    
//	    updateTime = new Date();
//	    note = "note1b";
//	    InputNameValuePairsData = new HashMap<String, Object>();
//	    InputNameValuePairsData.put(Constants.Key_Symptoms, new String[]{"s11b","s12b"});
//	    InputNameValuePairsData.put(Constants.Key_Temperature, Double.valueOf(36.72));
//	    InputNameValuePairsData.put(Constants.Key_Weight, Double.valueOf(67.82));
//	    InputNameValuePairsData.put(Constants.Key_HeartRate, Integer.valueOf(612));
//	    InputNameValuePairsData.put(Constants.Key_BloodPressureLow, Integer.valueOf(802));
//	    InputNameValuePairsData.put(Constants.Key_BloodPressureHigh, Integer.valueOf(1402));
//
//	    CalculateNameValuePairsData = new HashMap<String, Object>();
//	    CalculateNameValuePairsData.put(Constants.Key_BMI, Double.valueOf(23.42));
//	    CalculateNameValuePairsData.put(Constants.Key_HealthMark, Double.valueOf(87.52));
//	    CalculateNameValuePairsData.put("LackNutrientIDs", new String[]{"B2","VD"});
//	    CalculateNameValuePairsData.put("InferIllnesses", new String[]{"ill11b","ill12b"});
//	    CalculateNameValuePairsData.put("Suggestions", new String[]{"a11b","a12b"});
//	    RecommendFoodAndAmounts = new HashMap<String, Object>();
//	    RecommendFoodAndAmounts.put("10001", Integer.valueOf(1002));
//	    RecommendFoodAndAmounts.put("10002", Integer.valueOf(1502));
//	    CalculateNameValuePairsData.put("RecommendFoodAndAmounts", RecommendFoodAndAmounts);
//
//	    da.updateUserRecordSymptom_withDayLocal(dayLocal,updateTime,InputNameValuePairsData,note,CalculateNameValuePairsData);
//	    da.getUserRecordSymptomDataByDayLocal(dayLocal);
//	    
//	    
//	    
//	    dayLocal = 20120404;
//	    updateTime = new Date();
//	    note = "note1b";
//	    
//	    InputNameValuePairsData = new HashMap<String, Object>();
//	    InputNameValuePairsData.put(Constants.Key_Symptoms, new String[]{"s21","s22"});
//	    InputNameValuePairsData.put(Constants.Key_Temperature, Double.valueOf(236.7));
//	    InputNameValuePairsData.put(Constants.Key_Weight, Double.valueOf(267.8));
//	    InputNameValuePairsData.put(Constants.Key_HeartRate, Integer.valueOf(261));
//	    InputNameValuePairsData.put(Constants.Key_BloodPressureLow, Integer.valueOf(280));
//	    InputNameValuePairsData.put(Constants.Key_BloodPressureHigh, Integer.valueOf(2140));
//
//	    CalculateNameValuePairsData = new HashMap<String, Object>();
//	    CalculateNameValuePairsData.put(Constants.Key_BMI, Double.valueOf(223.4));
//	    CalculateNameValuePairsData.put(Constants.Key_HealthMark, Double.valueOf(287.5));
//	    CalculateNameValuePairsData.put("LackNutrientIDs", new String[]{"B3","VE"});
//	    CalculateNameValuePairsData.put("InferIllnesses", new String[]{"ill21","ill22"});
//	    CalculateNameValuePairsData.put("Suggestions", new String[]{"a21","a22"});
//	    
//	    RecommendFoodAndAmounts = new HashMap<String, Object>();
//	    RecommendFoodAndAmounts.put("10001", Integer.valueOf(2100));
//	    RecommendFoodAndAmounts.put("10002", Integer.valueOf(2150));
//	    CalculateNameValuePairsData.put("RecommendFoodAndAmounts", RecommendFoodAndAmounts);
//	    	    
//	    da.deleteUserRecordSymptomByByDayLocal(dayLocal);
//	    
//	    da.insertUserRecordSymptom_withDayLocal(dayLocal,updateTime,InputNameValuePairsData,note,CalculateNameValuePairsData);
//	    
//	    da.getUserRecordSymptomDataByRange_withStartDayLocal(0,0,0,0);
//	    
//	    da.getUserRecordSymptom_DistinctMonth();

	}

}



















