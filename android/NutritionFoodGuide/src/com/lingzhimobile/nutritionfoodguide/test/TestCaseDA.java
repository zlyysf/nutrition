package com.lingzhimobile.nutritionfoodguide.test;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import org.json.JSONException;
import org.json.JSONObject;

import com.lingzhimobile.nutritionfoodguide.ActivityFoodCombination;
import com.lingzhimobile.nutritionfoodguide.ActivityTestCases;
import com.lingzhimobile.nutritionfoodguide.Constants;
import com.lingzhimobile.nutritionfoodguide.DataAccess;
import com.lingzhimobile.nutritionfoodguide.RecommendFood;
import com.lingzhimobile.nutritionfoodguide.StoredConfigTool;
import com.lingzhimobile.nutritionfoodguide.Tool;
import com.lingzhimobile.nutritionfoodguide.ToolParse;
import com.lingzhimobile.nutritionfoodguide.Tool.JustCallback;

import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.SaveCallback;

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
//		test_dalUserRecordSymptom1(ctx);
		test_genData_UserRecordSymptom1(ctx);
//		test_getIllness2(ctx);
//		test_syncRemoteDataInParse(ctx);
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
		
		String[] symptomIds = new String[]{"头晕", "头发脱落", "易疲劳", "易流泪"};
		ArrayList<String> symptomIdList = Tool.convertFromArrayToList(symptomIds);
		ArrayList<String> nutrientIdList = da.getSymptomNutrientDistinctIds_BySymptomIds(symptomIdList);
		
//		HashMap<String, HashMap<String, Object>> nutrientInfoDict2Level = da.getNutrientInfoAs2LevelDictionary_withNutrientIds(null);
//		HashMap<String, Object> nutrientInfo = nutrientInfoDict2Level.get(nutrientIdList.get(0));
		
		da.getSymptomHealthMarkSum_BySymptomIds(symptomIds);
		
		da.getSymptomRows_BySymptomIds(symptomIdList);
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
		ArrayList<String> illnessIdList = Tool.convertFromArrayToList(illnessIds);
		DataAccess da = DataAccess.getSingleton(ctx);
	    da.getIllnessSuggestionsDistinct_ByIllnessIds(Tool.convertFromArrayToList(illnessIds));
	    
	    da.getIllness_ByIllnessIds(illnessIdList);
	    da.getIllnessSuggestions_ByIllnessId("感冒");
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
	    InputNameValuePairsData.put(Constants.Key_BodyTemperature, Double.valueOf(36.7));
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
//	    InputNameValuePairsData.put(Constants.Key_BodyTemperature, Double.valueOf(36.72));
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
//	    InputNameValuePairsData.put(Constants.Key_BodyTemperature, Double.valueOf(236.7));
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
	public static void test_genData_UserRecordSymptom1(Context ctx)
	{
		DataAccess da = DataAccess.getSingleton(ctx);
		
		if (true){
			int dayLocal = 20120304;
		    Date updateTime = new Date();
		    HashMap<String, Object> InputNameValuePairsData;
		    HashMap<String, Object> CalculateNameValuePairsData;
		    HashMap<String, Object> RecommendFoodAndAmounts;
		    HashMap<String, Object> LackNutrientsAndFoods, InferIllnessesAndSuggestions;
		    
		    String note = "note"+dayLocal;
		    
		    InputNameValuePairsData = new HashMap<String, Object>();
		    InputNameValuePairsData.put(Constants.Key_BodyTemperature, Double.valueOf(36.7));
		    InputNameValuePairsData.put(Constants.Key_Weight, Double.valueOf(67.8));
		    InputNameValuePairsData.put(Constants.Key_HeartRate, Integer.valueOf(61));
		    InputNameValuePairsData.put(Constants.Key_BloodPressureLow, Integer.valueOf(80));
		    InputNameValuePairsData.put(Constants.Key_BloodPressureHigh, Integer.valueOf(140));
		    Object[] Symptoms = new Object[]{"头晕","视觉模糊"};
		    InputNameValuePairsData.put(Constants.Key_Symptoms, Symptoms);
		    ArrayList<Object> SymptomsByType = new ArrayList<Object>();
		    
		    ArrayList<Object> typeAndSymptoms1 = new ArrayList<Object>();
		    ArrayList<String> SymptomsOfType1 = Tool.convertFromArrayToList(new String[]{"烦躁","紧张焦虑"});
		    typeAndSymptoms1.add("心理");
		    typeAndSymptoms1.add(SymptomsOfType1);
		    SymptomsByType.add(typeAndSymptoms1);
		    
		    ArrayList<Object> typeAndSymptoms2 = new ArrayList<Object>();
		    ArrayList<String> SymptomsOfType2 = Tool.convertFromArrayToList(new String[]{"阳痿","早泄","精液减少"});
		    typeAndSymptoms2.add("男性");
		    typeAndSymptoms2.add(SymptomsOfType2);
		    SymptomsByType.add(typeAndSymptoms2);
		    InputNameValuePairsData.put(Constants.Key_SymptomsByType, SymptomsByType);
		    
		    CalculateNameValuePairsData = new HashMap<String, Object>();
		    CalculateNameValuePairsData.put(Constants.Key_BMI, Double.valueOf(23.4));
		    CalculateNameValuePairsData.put(Constants.Key_HealthMark, Double.valueOf(87.5));

		    RecommendFoodAndAmounts = new HashMap<String, Object>();
		    RecommendFoodAndAmounts.put("12036", Integer.valueOf(100));
		    RecommendFoodAndAmounts.put("01005", Integer.valueOf(150));

		    LackNutrientsAndFoods = new HashMap<String, Object>();
		    LackNutrientsAndFoods.put("Vit_A_RAE", RecommendFoodAndAmounts);
		    RecommendFoodAndAmounts = new HashMap<String, Object>();
		    RecommendFoodAndAmounts.put("20109", Integer.valueOf(100));
		    RecommendFoodAndAmounts.put("11224", Integer.valueOf(150));
		    LackNutrientsAndFoods.put("Calcium_(mg)", RecommendFoodAndAmounts);
		    CalculateNameValuePairsData.put(Constants.Key_LackNutrientsAndFoods, LackNutrientsAndFoods);
		    
		    InferIllnessesAndSuggestions = new HashMap<String, Object>();
		    InferIllnessesAndSuggestions.put("中度高血压", new Object[]{"确定和排除诱发过敏的食物","Suggestion12"});
		    InferIllnessesAndSuggestions.put("低血糖", new Object[]{"大量饮水，有利于痰液稀释，气管畅通","Suggestion22"});
		    CalculateNameValuePairsData.put(Constants.Key_InferIllnessesAndSuggestions, InferIllnessesAndSuggestions);
		    CalculateNameValuePairsData.put(Constants.Key_IllnessIds, new Object[]{"中度高血压","低血糖"});
		    CalculateNameValuePairsData.put(Constants.Key_distinctSuggestionIds, new Object[]{"坚持低脂肪的食谱。","控制血压和胆固醇的指标。"});
		    
		    da.deleteUserRecordSymptomByByDayLocal(dayLocal);
		    
		    da.insertUserRecordSymptom_withDayLocal(dayLocal,updateTime,InputNameValuePairsData,note,CalculateNameValuePairsData);
		}
		
		if (true){
			int dayLocal = 20120305;
		    Date updateTime = new Date();
		    HashMap<String, Object> InputNameValuePairsData;
		    HashMap<String, Object> CalculateNameValuePairsData;
		    HashMap<String, Object> RecommendFoodAndAmounts;
		    HashMap<String, Object> LackNutrientsAndFoods, InferIllnessesAndSuggestions;
		    
		    String note = "note"+dayLocal;
		    
		    InputNameValuePairsData = new HashMap<String, Object>();
		    InputNameValuePairsData.put(Constants.Key_BodyTemperature, Double.valueOf(37.7));
		    InputNameValuePairsData.put(Constants.Key_Weight, Double.valueOf(68.8));
		    InputNameValuePairsData.put(Constants.Key_HeartRate, Integer.valueOf(71));
		    InputNameValuePairsData.put(Constants.Key_BloodPressureLow, Integer.valueOf(85));
		    InputNameValuePairsData.put(Constants.Key_BloodPressureHigh, Integer.valueOf(145));
		    Object[] Symptoms = new Object[]{"头发干枯","耳鸣"};
		    InputNameValuePairsData.put(Constants.Key_Symptoms, Symptoms);
		    ArrayList<Object> SymptomsByType = new ArrayList<Object>();
		    
		    ArrayList<Object> typeAndSymptoms1 = new ArrayList<Object>();
		    ArrayList<String> SymptomsOfType1 = Tool.convertFromArrayToList(new String[]{"夜尿","多尿"});
		    typeAndSymptoms1.add("消化");
		    typeAndSymptoms1.add(SymptomsOfType1);
		    SymptomsByType.add(typeAndSymptoms1);
		    
		    ArrayList<Object> typeAndSymptoms2 = new ArrayList<Object>();
		    ArrayList<String> SymptomsOfType2 = Tool.convertFromArrayToList(new String[]{"站立不稳","体力耐力下降","负重能力下降"});
		    typeAndSymptoms2.add("行动");
		    typeAndSymptoms2.add(SymptomsOfType2);
		    SymptomsByType.add(typeAndSymptoms2);
		    InputNameValuePairsData.put(Constants.Key_SymptomsByType, SymptomsByType);
		    
		    CalculateNameValuePairsData = new HashMap<String, Object>();
		    CalculateNameValuePairsData.put(Constants.Key_BMI, Double.valueOf(24.4));
		    CalculateNameValuePairsData.put(Constants.Key_HealthMark, Double.valueOf(80.5));

		    RecommendFoodAndAmounts = new HashMap<String, Object>();
		    RecommendFoodAndAmounts.put("12036", Integer.valueOf(100));
		    RecommendFoodAndAmounts.put("01005", Integer.valueOf(150));

		    LackNutrientsAndFoods = new HashMap<String, Object>();
		    LackNutrientsAndFoods.put("Vit_C_(mg)", RecommendFoodAndAmounts);
		    RecommendFoodAndAmounts = new HashMap<String, Object>();
		    RecommendFoodAndAmounts.put("20109", Integer.valueOf(100));
		    RecommendFoodAndAmounts.put("11224", Integer.valueOf(150));
		    LackNutrientsAndFoods.put("Iron_(mg)", RecommendFoodAndAmounts);
		    CalculateNameValuePairsData.put(Constants.Key_LackNutrientsAndFoods, LackNutrientsAndFoods);
		    
		    InferIllnessesAndSuggestions = new HashMap<String, Object>();
		    InferIllnessesAndSuggestions.put("功能性消化不良", new Object[]{"确定和排除诱发过敏的食物","Suggestion12"});
		    InferIllnessesAndSuggestions.put("急性扁桃体炎", new Object[]{"大量饮水，有利于痰液稀释，气管畅通","Suggestion22"});
		    CalculateNameValuePairsData.put(Constants.Key_InferIllnessesAndSuggestions, InferIllnessesAndSuggestions);
		    CalculateNameValuePairsData.put(Constants.Key_IllnessIds, new Object[]{"急性扁桃体炎","功能性消化不良"});
		    CalculateNameValuePairsData.put(Constants.Key_distinctSuggestionIds, new Object[]{"坚持低脂肪的食谱。","控制血压和胆固醇的指标。"});
		    
		    da.deleteUserRecordSymptomByByDayLocal(dayLocal);
		    
		    da.insertUserRecordSymptom_withDayLocal(dayLocal,updateTime,InputNameValuePairsData,note,CalculateNameValuePairsData);
		}
		
		if (true){
			int dayLocal = 20120306;
		    Date updateTime = new Date();
		    HashMap<String, Object> InputNameValuePairsData;
		    HashMap<String, Object> CalculateNameValuePairsData;
		    HashMap<String, Object> RecommendFoodAndAmounts;
		    HashMap<String, Object> LackNutrientsAndFoods, InferIllnessesAndSuggestions;
		    
		    String note = "note"+dayLocal;
		    
		    InputNameValuePairsData = new HashMap<String, Object>();
		    InputNameValuePairsData.put(Constants.Key_BodyTemperature, Double.valueOf(37.1));
		    InputNameValuePairsData.put(Constants.Key_Weight, Double.valueOf(65.8));
		    InputNameValuePairsData.put(Constants.Key_HeartRate, Integer.valueOf(75));
		    InputNameValuePairsData.put(Constants.Key_BloodPressureLow, Integer.valueOf(95));
		    InputNameValuePairsData.put(Constants.Key_BloodPressureHigh, Integer.valueOf(155));
		    Object[] Symptoms = new Object[]{"脸色苍白","视觉模糊"};
		    InputNameValuePairsData.put(Constants.Key_Symptoms, Symptoms);
		    ArrayList<Object> SymptomsByType = new ArrayList<Object>();
		    
		    ArrayList<Object> typeAndSymptoms1 = new ArrayList<Object>();
		    ArrayList<String> SymptomsOfType1 = Tool.convertFromArrayToList(new String[]{"发热","畏寒"});
		    typeAndSymptoms1.add("周身");
		    typeAndSymptoms1.add(SymptomsOfType1);
		    SymptomsByType.add(typeAndSymptoms1);
		    
		    ArrayList<Object> typeAndSymptoms2 = new ArrayList<Object>();
		    ArrayList<String> SymptomsOfType2 = Tool.convertFromArrayToList(new String[]{"食欲不振","食欲亢进","恶心"});
		    typeAndSymptoms2.add("消化");
		    typeAndSymptoms2.add(SymptomsOfType2);
		    SymptomsByType.add(typeAndSymptoms2);
		    InputNameValuePairsData.put(Constants.Key_SymptomsByType, SymptomsByType);
          
          
		    CalculateNameValuePairsData = new HashMap<String, Object>();
		    CalculateNameValuePairsData.put(Constants.Key_BMI, Double.valueOf(24.1));
		    CalculateNameValuePairsData.put(Constants.Key_HealthMark, Double.valueOf(83.5));

		    RecommendFoodAndAmounts = new HashMap<String, Object>();
		    RecommendFoodAndAmounts.put("12036", Integer.valueOf(100));
		    RecommendFoodAndAmounts.put("01005", Integer.valueOf(150));

		    LackNutrientsAndFoods = new HashMap<String, Object>();
		    LackNutrientsAndFoods.put("Vit_C_(mg)", RecommendFoodAndAmounts);
		    RecommendFoodAndAmounts = new HashMap<String, Object>();
		    RecommendFoodAndAmounts.put("20109", Integer.valueOf(100));
		    RecommendFoodAndAmounts.put("11224", Integer.valueOf(150));
		    LackNutrientsAndFoods.put("Iron_(mg)", RecommendFoodAndAmounts);
		    CalculateNameValuePairsData.put(Constants.Key_LackNutrientsAndFoods, LackNutrientsAndFoods);
		    
		    InferIllnessesAndSuggestions = new HashMap<String, Object>();
		    InferIllnessesAndSuggestions.put("急性病毒性咽炎", new Object[]{"确定和排除诱发过敏的食物","Suggestion12"});
		    InferIllnessesAndSuggestions.put("急性病毒性喉炎", new Object[]{"大量饮水，有利于痰液稀释，气管畅通","Suggestion22"});
		    CalculateNameValuePairsData.put(Constants.Key_InferIllnessesAndSuggestions, InferIllnessesAndSuggestions);
		    CalculateNameValuePairsData.put(Constants.Key_IllnessIds, new Object[]{"中度高血压","低血糖"});
		    CalculateNameValuePairsData.put(Constants.Key_distinctSuggestionIds, new Object[]{"坚持低脂肪的食谱。","控制血压和胆固醇的指标。"});
		    
		    da.deleteUserRecordSymptomByByDayLocal(dayLocal);
		    
		    da.insertUserRecordSymptom_withDayLocal(dayLocal,updateTime,InputNameValuePairsData,note,CalculateNameValuePairsData);
		}
		
        if (true){
            int dayLocal = 20120314;
            Date updateTime = new Date();
            HashMap<String, Object> InputNameValuePairsData;
            HashMap<String, Object> CalculateNameValuePairsData;
            HashMap<String, Object> RecommendFoodAndAmounts;
            HashMap<String, Object> LackNutrientsAndFoods, InferIllnessesAndSuggestions;
            
            String note = "note"+dayLocal;
            
            
            InputNameValuePairsData = new HashMap<String, Object>();
            
            InputNameValuePairsData.put(Constants.Key_BodyTemperature, Double.valueOf(36.7));
            InputNameValuePairsData.put(Constants.Key_Weight, Double.valueOf(67.8));
            InputNameValuePairsData.put(Constants.Key_HeartRate, Integer.valueOf(61));
            InputNameValuePairsData.put(Constants.Key_BloodPressureLow, Integer.valueOf(80));
            InputNameValuePairsData.put(Constants.Key_BloodPressureHigh, Integer.valueOf(140));
			Object[] Symptoms = new Object[]{"头晕","易流泪"};
			InputNameValuePairsData.put(Constants.Key_Symptoms, Symptoms);
            ArrayList<Object> SymptomsByType = new ArrayList<Object>();
            
            ArrayList<Object> typeAndSymptoms1 = new ArrayList<Object>();
            ArrayList<String> SymptomsOfType1 = Tool.convertFromArrayToList(new String[]{"头晕","头发干枯"});
            typeAndSymptoms1.add("头面");
            typeAndSymptoms1.add(SymptomsOfType1);
            SymptomsByType.add(typeAndSymptoms1);
            
            ArrayList<Object> typeAndSymptoms2 = new ArrayList<Object>();
            ArrayList<String> SymptomsOfType2 = Tool.convertFromArrayToList(new String[]{"视觉模糊","暗光看不清","怕光"});
            typeAndSymptoms2.add("眼睛");
            typeAndSymptoms2.add(SymptomsOfType2);
            SymptomsByType.add(typeAndSymptoms2);
            InputNameValuePairsData.put(Constants.Key_SymptomsByType, SymptomsByType);

            CalculateNameValuePairsData = new HashMap<String, Object>();
            CalculateNameValuePairsData.put(Constants.Key_BMI, Double.valueOf(23.4));
            CalculateNameValuePairsData.put(Constants.Key_HealthMark, Double.valueOf(87.5));

            RecommendFoodAndAmounts = new HashMap<String, Object>();
            RecommendFoodAndAmounts.put("12036", Integer.valueOf(100));
            RecommendFoodAndAmounts.put("01005", Integer.valueOf(150));

            LackNutrientsAndFoods = new HashMap<String, Object>();
            LackNutrientsAndFoods.put("Vit_A_RAE", RecommendFoodAndAmounts);
            RecommendFoodAndAmounts = new HashMap<String, Object>();
            RecommendFoodAndAmounts.put("20109", Integer.valueOf(100));
            RecommendFoodAndAmounts.put("11224", Integer.valueOf(150));
            LackNutrientsAndFoods.put("Calcium_(mg)", RecommendFoodAndAmounts);
            CalculateNameValuePairsData.put(Constants.Key_LackNutrientsAndFoods, LackNutrientsAndFoods);
            
            InferIllnessesAndSuggestions = new HashMap<String, Object>();
            InferIllnessesAndSuggestions.put("中度高血压", new Object[]{"确定和排除诱发过敏的食物","Suggestion12"});
            InferIllnessesAndSuggestions.put("低血糖", new Object[]{"大量饮水，有利于痰液稀释，气管畅通","Suggestion22"});
            CalculateNameValuePairsData.put(Constants.Key_InferIllnessesAndSuggestions, InferIllnessesAndSuggestions);
            CalculateNameValuePairsData.put(Constants.Key_IllnessIds, new Object[]{"急性扁桃体炎","功能性消化不良"});
            CalculateNameValuePairsData.put(Constants.Key_distinctSuggestionIds, new Object[]{"坚持低脂肪的食谱。","控制血压和胆固醇的指标。"});
            
            da.deleteUserRecordSymptomByByDayLocal(dayLocal);
            
            da.insertUserRecordSymptom_withDayLocal(dayLocal,updateTime,InputNameValuePairsData,note,CalculateNameValuePairsData);
        }

        if (true){
            int dayLocal = 20120315;
            Date updateTime = new Date();
            HashMap<String, Object> InputNameValuePairsData;
            HashMap<String, Object> CalculateNameValuePairsData;
            HashMap<String, Object> RecommendFoodAndAmounts;
            HashMap<String, Object> LackNutrientsAndFoods, InferIllnessesAndSuggestions;
            
            String note = "note"+dayLocal;
            
            InputNameValuePairsData = new HashMap<String, Object>();
            InputNameValuePairsData.put(Constants.Key_BodyTemperature, Double.valueOf(36.7));
            InputNameValuePairsData.put(Constants.Key_Weight, Double.valueOf(67.8));
            InputNameValuePairsData.put(Constants.Key_HeartRate, Integer.valueOf(61));
            InputNameValuePairsData.put(Constants.Key_BloodPressureLow, Integer.valueOf(80));
            InputNameValuePairsData.put(Constants.Key_BloodPressureHigh, Integer.valueOf(140));
            Object[] Symptoms = new Object[]{"头晕","易流泪"};
            InputNameValuePairsData.put(Constants.Key_Symptoms, Symptoms);
            ArrayList<Object> SymptomsByType = new ArrayList<Object>();
            
            ArrayList<Object> typeAndSymptoms1 = new ArrayList<Object>();
            ArrayList<String> SymptomsOfType1 = Tool.convertFromArrayToList(new String[]{"耳鸣","耳后出油"});
            typeAndSymptoms1.add("耳鼻");
            typeAndSymptoms1.add(SymptomsOfType1);
            SymptomsByType.add(typeAndSymptoms1);
            
            ArrayList<Object> typeAndSymptoms2 = new ArrayList<Object>();
            ArrayList<String> SymptomsOfType2 = Tool.convertFromArrayToList(new String[]{"口唇干裂","张口疼痛","舌发炎/红包"});
            typeAndSymptoms2.add("口腔");
            typeAndSymptoms2.add(SymptomsOfType2);
            SymptomsByType.add(typeAndSymptoms2);
            InputNameValuePairsData.put(Constants.Key_SymptomsByType, SymptomsByType);
          
            CalculateNameValuePairsData = new HashMap<String, Object>();
            CalculateNameValuePairsData.put(Constants.Key_BMI, Double.valueOf(23.4));
            CalculateNameValuePairsData.put(Constants.Key_HealthMark, Double.valueOf(87.5));

            RecommendFoodAndAmounts = new HashMap<String, Object>();
            RecommendFoodAndAmounts.put("12036", Integer.valueOf(100));
            RecommendFoodAndAmounts.put("01005", Integer.valueOf(150));

            LackNutrientsAndFoods = new HashMap<String, Object>();
            LackNutrientsAndFoods.put("Vit_A_RAE", RecommendFoodAndAmounts);
            RecommendFoodAndAmounts = new HashMap<String, Object>();
            RecommendFoodAndAmounts.put("20109", Integer.valueOf(100));
            RecommendFoodAndAmounts.put("11224", Integer.valueOf(150));
            LackNutrientsAndFoods.put("Calcium_(mg)", RecommendFoodAndAmounts);
            CalculateNameValuePairsData.put(Constants.Key_LackNutrientsAndFoods, LackNutrientsAndFoods);
            
            InferIllnessesAndSuggestions = new HashMap<String, Object>();
            InferIllnessesAndSuggestions.put("中度高血压", new Object[]{"确定和排除诱发过敏的食物","Suggestion12"});
            InferIllnessesAndSuggestions.put("低血糖", new Object[]{"大量饮水，有利于痰液稀释，气管畅通","Suggestion22"});
            CalculateNameValuePairsData.put(Constants.Key_InferIllnessesAndSuggestions, InferIllnessesAndSuggestions);
            CalculateNameValuePairsData.put(Constants.Key_IllnessIds, new Object[]{"中度高血压","低血糖"});
            CalculateNameValuePairsData.put(Constants.Key_distinctSuggestionIds, new Object[]{"坚持低脂肪的食谱。","控制血压和胆固醇的指标。"});
            
            da.deleteUserRecordSymptomByByDayLocal(dayLocal);
            
            da.insertUserRecordSymptom_withDayLocal(dayLocal,updateTime,InputNameValuePairsData,note,CalculateNameValuePairsData);
        }

        if (true){
            int dayLocal = 20120316;
            Date updateTime = new Date();
            HashMap<String, Object> InputNameValuePairsData;
            HashMap<String, Object> CalculateNameValuePairsData;
            HashMap<String, Object> RecommendFoodAndAmounts;
            HashMap<String, Object> LackNutrientsAndFoods, InferIllnessesAndSuggestions;
            
            String note = "note"+dayLocal;
            
            InputNameValuePairsData = new HashMap<String, Object>();
            InputNameValuePairsData.put(Constants.Key_BodyTemperature, Double.valueOf(36.7));
            InputNameValuePairsData.put(Constants.Key_Weight, Double.valueOf(67.8));
            InputNameValuePairsData.put(Constants.Key_HeartRate, Integer.valueOf(61));
            InputNameValuePairsData.put(Constants.Key_BloodPressureLow, Integer.valueOf(80));
            InputNameValuePairsData.put(Constants.Key_BloodPressureHigh, Integer.valueOf(140));
            Object[] Symptoms = new Object[]{"头晕","易流泪"};
            InputNameValuePairsData.put(Constants.Key_Symptoms, Symptoms);
            ArrayList<Object> SymptomsByType = new ArrayList<Object>();
            
            ArrayList<Object> typeAndSymptoms1 = new ArrayList<Object>();
            ArrayList<String> SymptomsOfType1 = Tool.convertFromArrayToList(new String[]{"牙齿松动","牙齿脱落"});
            typeAndSymptoms1.add("牙齿");
            typeAndSymptoms1.add(SymptomsOfType1);
            SymptomsByType.add(typeAndSymptoms1);
            
            ArrayList<Object> typeAndSymptoms2 = new ArrayList<Object>();
            ArrayList<String> SymptomsOfType2 = Tool.convertFromArrayToList(new String[]{"咽喉发痒","咽喉灼热","咽喉疼痛"});
            typeAndSymptoms2.add("咽喉");
            typeAndSymptoms2.add(SymptomsOfType2);
            SymptomsByType.add(typeAndSymptoms2);
            InputNameValuePairsData.put(Constants.Key_SymptomsByType, SymptomsByType);
            
            CalculateNameValuePairsData = new HashMap<String, Object>();
            CalculateNameValuePairsData.put(Constants.Key_BMI, Double.valueOf(23.4));
            CalculateNameValuePairsData.put(Constants.Key_HealthMark, Double.valueOf(87.5));

            RecommendFoodAndAmounts = new HashMap<String, Object>();
            RecommendFoodAndAmounts.put("12036", Integer.valueOf(100));
            RecommendFoodAndAmounts.put("01005", Integer.valueOf(150));

            LackNutrientsAndFoods = new HashMap<String, Object>();
            LackNutrientsAndFoods.put("Vit_A_RAE", RecommendFoodAndAmounts);
            RecommendFoodAndAmounts = new HashMap<String, Object>();
            RecommendFoodAndAmounts.put("20109", Integer.valueOf(100));
            RecommendFoodAndAmounts.put("11224", Integer.valueOf(150));
            LackNutrientsAndFoods.put("Calcium_(mg)", RecommendFoodAndAmounts);
            CalculateNameValuePairsData.put(Constants.Key_LackNutrientsAndFoods, LackNutrientsAndFoods);
            
            InferIllnessesAndSuggestions = new HashMap<String, Object>();
            InferIllnessesAndSuggestions.put("中度高血压", new Object[]{"确定和排除诱发过敏的食物","Suggestion12"});
            InferIllnessesAndSuggestions.put("低血糖", new Object[]{"大量饮水，有利于痰液稀释，气管畅通","Suggestion22"});
            CalculateNameValuePairsData.put(Constants.Key_InferIllnessesAndSuggestions, InferIllnessesAndSuggestions);
            CalculateNameValuePairsData.put(Constants.Key_IllnessIds, new Object[]{"急性扁桃体炎","功能性消化不良"});
            CalculateNameValuePairsData.put(Constants.Key_distinctSuggestionIds, new Object[]{"坚持低脂肪的食谱。","控制血压和胆固醇的指标。"});
            
            da.deleteUserRecordSymptomByByDayLocal(dayLocal);
            
            da.insertUserRecordSymptom_withDayLocal(dayLocal,updateTime,InputNameValuePairsData,note,CalculateNameValuePairsData);
        }

        if (true){
			int dayLocal = 20120210;
		    Date updateTime = new Date();
		    HashMap<String, Object> InputNameValuePairsData;
		    HashMap<String, Object> CalculateNameValuePairsData;
		    HashMap<String, Object> RecommendFoodAndAmounts;
		    HashMap<String, Object> LackNutrientsAndFoods, InferIllnessesAndSuggestions;
		    
		    String note = "note"+dayLocal;
		    
		    InputNameValuePairsData = new HashMap<String, Object>();
		    InputNameValuePairsData.put(Constants.Key_BodyTemperature, Double.valueOf(36.1));
		    InputNameValuePairsData.put(Constants.Key_Weight, Double.valueOf(69.8));
		    InputNameValuePairsData.put(Constants.Key_HeartRate, Integer.valueOf(70));
		    InputNameValuePairsData.put(Constants.Key_BloodPressureLow, Integer.valueOf(75));
		    InputNameValuePairsData.put(Constants.Key_BloodPressureHigh, Integer.valueOf(135));
		    Object[] Symptoms = new Object[]{"脸下垂","眼睛易疲劳"};
		    InputNameValuePairsData.put(Constants.Key_Symptoms, Symptoms);
            ArrayList<Object> SymptomsByType = new ArrayList<Object>();
            
            ArrayList<Object> typeAndSymptoms1 = new ArrayList<Object>();
            ArrayList<String> SymptomsOfType1 = Tool.convertFromArrayToList(new String[]{"呼吸不畅","咳嗽"});
            typeAndSymptoms1.add("呼吸");
            typeAndSymptoms1.add(SymptomsOfType1);
            SymptomsByType.add(typeAndSymptoms1);
            
            ArrayList<Object> typeAndSymptoms2 = new ArrayList<Object>();
            ArrayList<String> SymptomsOfType2 = Tool.convertFromArrayToList(new String[]{"心律失常","心慌","心跳过速"});
            typeAndSymptoms2.add("心脏");
            typeAndSymptoms2.add(SymptomsOfType2);
            SymptomsByType.add(typeAndSymptoms2);
            InputNameValuePairsData.put(Constants.Key_SymptomsByType, SymptomsByType);
            
		    CalculateNameValuePairsData = new HashMap<String, Object>();
		    CalculateNameValuePairsData.put(Constants.Key_BMI, Double.valueOf(23.1));
		    CalculateNameValuePairsData.put(Constants.Key_HealthMark, Double.valueOf(84.5));

		    RecommendFoodAndAmounts = new HashMap<String, Object>();
		    RecommendFoodAndAmounts.put("12036", Integer.valueOf(100));
		    RecommendFoodAndAmounts.put("01005", Integer.valueOf(150));

		    LackNutrientsAndFoods = new HashMap<String, Object>();
		    LackNutrientsAndFoods.put("Vit_C_(mg)", RecommendFoodAndAmounts);
		    RecommendFoodAndAmounts = new HashMap<String, Object>();
		    RecommendFoodAndAmounts.put("20109", Integer.valueOf(100));
		    RecommendFoodAndAmounts.put("11224", Integer.valueOf(150));
		    LackNutrientsAndFoods.put("Iron_(mg)", RecommendFoodAndAmounts);
		    CalculateNameValuePairsData.put(Constants.Key_LackNutrientsAndFoods, LackNutrientsAndFoods);
		    
		    InferIllnessesAndSuggestions = new HashMap<String, Object>();
		    InferIllnessesAndSuggestions.put("急性肾小球肾炎", new Object[]{"确定和排除诱发过敏的食物","Suggestion12"});
		    InferIllnessesAndSuggestions.put("急性胃炎", new Object[]{"大量饮水，有利于痰液稀释，气管畅通","Suggestion22"});
		    CalculateNameValuePairsData.put(Constants.Key_InferIllnessesAndSuggestions, InferIllnessesAndSuggestions);
		    CalculateNameValuePairsData.put(Constants.Key_IllnessIds, new Object[]{"中度高血压","低血糖"});
		    CalculateNameValuePairsData.put(Constants.Key_distinctSuggestionIds, new Object[]{"坚持低脂肪的食谱。","控制血压和胆固醇的指标。"});
		    
		    da.deleteUserRecordSymptomByByDayLocal(dayLocal);
		    
		    da.insertUserRecordSymptom_withDayLocal(dayLocal,updateTime,InputNameValuePairsData,note,CalculateNameValuePairsData);
		}
		
		if (true){
			int dayLocal = 20120211;
		    Date updateTime = new Date();
		    HashMap<String, Object> InputNameValuePairsData;
		    HashMap<String, Object> CalculateNameValuePairsData;
		    HashMap<String, Object> RecommendFoodAndAmounts;
		    HashMap<String, Object> LackNutrientsAndFoods, InferIllnessesAndSuggestions;
		    
		    String note = "note"+dayLocal;
		    
		    InputNameValuePairsData = new HashMap<String, Object>();
		    InputNameValuePairsData.put(Constants.Key_BodyTemperature, Double.valueOf(36.6));
		    InputNameValuePairsData.put(Constants.Key_Weight, Double.valueOf(66.8));
		    InputNameValuePairsData.put(Constants.Key_HeartRate, Integer.valueOf(73));
		    InputNameValuePairsData.put(Constants.Key_BloodPressureLow, Integer.valueOf(78));
		    InputNameValuePairsData.put(Constants.Key_BloodPressureHigh, Integer.valueOf(138));
		    Object[] Symptoms = new Object[]{"脸抽搐","眼球浑浊"};
		    InputNameValuePairsData.put(Constants.Key_Symptoms, Symptoms);
            ArrayList<Object> SymptomsByType = new ArrayList<Object>();
            
            ArrayList<Object> typeAndSymptoms1 = new ArrayList<Object>();
            ArrayList<String> SymptomsOfType1 = Tool.convertFromArrayToList(new String[]{"胸闷","下腹痛"});
            typeAndSymptoms1.add("胸腹腔");
            typeAndSymptoms1.add(SymptomsOfType1);
            SymptomsByType.add(typeAndSymptoms1);
            
            ArrayList<Object> typeAndSymptoms2 = new ArrayList<Object>();
            ArrayList<String> SymptomsOfType2 = Tool.convertFromArrayToList(new String[]{"皮肤松弛","皮肤干燥","皮肤皱纹","伤口不愈合"});
            typeAndSymptoms2.add("皮肤");
            typeAndSymptoms2.add(SymptomsOfType2);
            SymptomsByType.add(typeAndSymptoms2);
            InputNameValuePairsData.put(Constants.Key_SymptomsByType, SymptomsByType);
            
		    CalculateNameValuePairsData = new HashMap<String, Object>();
		    CalculateNameValuePairsData.put(Constants.Key_BMI, Double.valueOf(23.6));
		    CalculateNameValuePairsData.put(Constants.Key_HealthMark, Double.valueOf(86.5));

		    RecommendFoodAndAmounts = new HashMap<String, Object>();
		    RecommendFoodAndAmounts.put("12036", Integer.valueOf(100));
		    RecommendFoodAndAmounts.put("01005", Integer.valueOf(150));

		    LackNutrientsAndFoods = new HashMap<String, Object>();
		    LackNutrientsAndFoods.put("Vit_C_(mg)", RecommendFoodAndAmounts);
		    RecommendFoodAndAmounts = new HashMap<String, Object>();
		    RecommendFoodAndAmounts.put("20109", Integer.valueOf(100));
		    RecommendFoodAndAmounts.put("11224", Integer.valueOf(150));
		    LackNutrientsAndFoods.put("Iron_(mg)", RecommendFoodAndAmounts);
		    CalculateNameValuePairsData.put(Constants.Key_LackNutrientsAndFoods, LackNutrientsAndFoods);
		    
		    InferIllnessesAndSuggestions = new HashMap<String, Object>();
		    InferIllnessesAndSuggestions.put("感冒", new Object[]{"确定和排除诱发过敏的食物","Suggestion12"});
		    InferIllnessesAndSuggestions.put("慢性支气管炎", new Object[]{"大量饮水，有利于痰液稀释，气管畅通","Suggestion22"});
		    CalculateNameValuePairsData.put(Constants.Key_InferIllnessesAndSuggestions, InferIllnessesAndSuggestions);
		    CalculateNameValuePairsData.put(Constants.Key_IllnessIds, new Object[]{"急性扁桃体炎","功能性消化不良"});
		    CalculateNameValuePairsData.put(Constants.Key_distinctSuggestionIds, new Object[]{"坚持低脂肪的食谱。","控制血压和胆固醇的指标。"});
		    
		    da.deleteUserRecordSymptomByByDayLocal(dayLocal);
		    
		    da.insertUserRecordSymptom_withDayLocal(dayLocal,updateTime,InputNameValuePairsData,note,CalculateNameValuePairsData);
		}
		
		if (true){
			int dayLocal = 20111220;
		    Date updateTime = new Date();
		    HashMap<String, Object> InputNameValuePairsData;
		    HashMap<String, Object> CalculateNameValuePairsData;
		    HashMap<String, Object> RecommendFoodAndAmounts;
		    HashMap<String, Object> LackNutrientsAndFoods, InferIllnessesAndSuggestions;
		    
		    String note = "note"+dayLocal;
		    
		    InputNameValuePairsData = new HashMap<String, Object>();
		    InputNameValuePairsData.put(Constants.Key_BodyTemperature, Double.valueOf(36.6));
		    InputNameValuePairsData.put(Constants.Key_Weight, Double.valueOf(66.8));
		    InputNameValuePairsData.put(Constants.Key_HeartRate, Integer.valueOf(73));
		    InputNameValuePairsData.put(Constants.Key_BloodPressureLow, Integer.valueOf(78));
		    InputNameValuePairsData.put(Constants.Key_BloodPressureHigh, Integer.valueOf(138));
		    Object[] Symptoms = new Object[]{"老年斑","眼睛发红发痒"};
		    InputNameValuePairsData.put(Constants.Key_Symptoms, Symptoms);
            ArrayList<Object> SymptomsByType = new ArrayList<Object>();
            
            ArrayList<Object> typeAndSymptoms1 = new ArrayList<Object>();
            ArrayList<String> SymptomsOfType1 = Tool.convertFromArrayToList(new String[]{"手脚震颤","手脚发痒"});
            typeAndSymptoms1.add("手足");
            typeAndSymptoms1.add(SymptomsOfType1);
            SymptomsByType.add(typeAndSymptoms1);
            
            ArrayList<Object> typeAndSymptoms2 = new ArrayList<Object>();
            ArrayList<String> SymptomsOfType2 = Tool.convertFromArrayToList(new String[]{"四肢无力","四肢肿胀","下肢水肿","关节疼痛","关节肿胀"});
            typeAndSymptoms2.add("四肢");
            typeAndSymptoms2.add(SymptomsOfType2);
            SymptomsByType.add(typeAndSymptoms2);
            InputNameValuePairsData.put(Constants.Key_SymptomsByType, SymptomsByType);
            
		    CalculateNameValuePairsData = new HashMap<String, Object>();
		    CalculateNameValuePairsData.put(Constants.Key_BMI, Double.valueOf(23.6));
		    CalculateNameValuePairsData.put(Constants.Key_HealthMark, Double.valueOf(86.5));

		    RecommendFoodAndAmounts = new HashMap<String, Object>();
		    RecommendFoodAndAmounts.put("12036", Integer.valueOf(100));
		    RecommendFoodAndAmounts.put("01005", Integer.valueOf(150));

		    LackNutrientsAndFoods = new HashMap<String, Object>();
		    LackNutrientsAndFoods.put("Vit_C_(mg)", RecommendFoodAndAmounts);
		    RecommendFoodAndAmounts = new HashMap<String, Object>();
		    RecommendFoodAndAmounts.put("20109", Integer.valueOf(100));
		    RecommendFoodAndAmounts.put("11224", Integer.valueOf(150));
		    LackNutrientsAndFoods.put("Iron_(mg)", RecommendFoodAndAmounts);
		    CalculateNameValuePairsData.put(Constants.Key_LackNutrientsAndFoods, LackNutrientsAndFoods);
		    
		    InferIllnessesAndSuggestions = new HashMap<String, Object>();
		    InferIllnessesAndSuggestions.put("慢性胃炎", new Object[]{"确定和排除诱发过敏的食物","Suggestion12"});
		    InferIllnessesAndSuggestions.put("支气管哮喘", new Object[]{"大量饮水，有利于痰液稀释，气管畅通","Suggestion22"});
		    CalculateNameValuePairsData.put(Constants.Key_InferIllnessesAndSuggestions, InferIllnessesAndSuggestions);
		    CalculateNameValuePairsData.put(Constants.Key_IllnessIds, new Object[]{"中度高血压","低血糖"});
		    CalculateNameValuePairsData.put(Constants.Key_distinctSuggestionIds, new Object[]{"坚持低脂肪的食谱。","控制血压和胆固醇的指标。"});
		    
		    da.deleteUserRecordSymptomByByDayLocal(dayLocal);
		    
		    da.insertUserRecordSymptom_withDayLocal(dayLocal,updateTime,InputNameValuePairsData,note,CalculateNameValuePairsData);
		}
	    
		da.getUserRecordSymptomDataByRange_withStartDayLocal(0,0,0,0);
	}
	static void test_getIllness2(Context ctx)
	{
	    
		DataAccess da = DataAccess.getSingleton(ctx);
	    da.getAllIllness();
	    
	    da.getFoodCnTypes();
	    
	}
	
	static void test_syncRemoteDataInParse(Context ctx){
		saveParseRowObj1(ctx);
	}
	
	static void saveParseRowObj1(Context ctx){
		final Context cCtx = ctx;

		if (true){
			final int daylocal1 = 20010304;
	    	Date dt = new Date();
	    	HashMap<String, Object> inputNameValuePairsData = new HashMap<String, Object>();
	    	String Note = "Note"+dt.toGMTString();
	    	HashMap<String, Object> calculateNameValuePairsData = new HashMap<String, Object>();
		   
	    	inputNameValuePairsData.put(Constants.Key_Symptoms, new Object[]{"症状1","症状2"});
	    	inputNameValuePairsData.put(Constants.Key_BodyTemperature, Double.valueOf(36.7));

	    	calculateNameValuePairsData.put(Constants.Key_BMI, Double.valueOf(23.4));

	    	HashMap<String, Object> RecommendFoodAndAmounts = new HashMap<String, Object>();
		    RecommendFoodAndAmounts.put("10001", Integer.valueOf(100));
		    RecommendFoodAndAmounts.put("10002", Integer.valueOf(150));
//		    CalculateNameValuePairsData.put("RecommendFoodAndAmounts", RecommendFoodAndAmounts);
		    HashMap<String, Object> LackNutrientsAndFoods = new HashMap<String, Object>();
		    LackNutrientsAndFoods.put("Vb1", RecommendFoodAndAmounts);
		    RecommendFoodAndAmounts = new HashMap<String, Object>();
		    RecommendFoodAndAmounts.put("10011", Integer.valueOf(100));
		    RecommendFoodAndAmounts.put("10012", Integer.valueOf(150));
		    LackNutrientsAndFoods.put("Vb2", RecommendFoodAndAmounts);
		    calculateNameValuePairsData.put(Constants.Key_LackNutrientsAndFoods, LackNutrientsAndFoods);
		    
		    HashMap<String, Object> InferIllnessesAndSuggestions = new HashMap<String, Object>();
		    InferIllnessesAndSuggestions.put("疾病1", new Object[]{"建议11","建议12"});
		    InferIllnessesAndSuggestions.put("疾病2", new Object[]{"建议21","建议22"});
		    calculateNameValuePairsData.put(Constants.Key_InferIllnessesAndSuggestions, InferIllnessesAndSuggestions);
		    
	    	final ParseObject parseObjUserRecord1 = ToolParse.getToSaveParseObject_UserRecordSymptom(ctx,daylocal1,dt,inputNameValuePairsData,Note,calculateNameValuePairsData );
	    	parseObjUserRecord1.saveInBackground(new SaveCallback() {
				
				@Override
				public void done(ParseException e) {
					String msg;
					if (e != null){
						msg = "ERR: "+e.getMessage();
					}else{
						msg = "Save OK."+ parseObjUserRecord1.getObjectId();
						StoredConfigTool.saveParseObjectInfo_CurrentUserRecordSymptom(cCtx, parseObjUserRecord1.getObjectId(), daylocal1);
					}
					Log.d("ActivityTestCases", "saveParseRowObj msg:"+msg);
					
					saveParseRowObj2(cCtx);
				}//done
			});//saveInBackground
		}
    }
	

	static void saveParseRowObj2(Context ctx){
		final Context cCtx = ctx;

		if (true){
			final int daylocal2 = 20010305;
	    	Date dt = new Date();
	    	HashMap<String, Object> inputNameValuePairsData = new HashMap<String, Object>();
	    	String Note = "Note"+dt.toGMTString();
	    	HashMap<String, Object> calculateNameValuePairsData = new HashMap<String, Object>();
		   
	    	inputNameValuePairsData.put(Constants.Key_Symptoms, new Object[]{"Symptom1","Symptom2"});
	    	inputNameValuePairsData.put(Constants.Key_BodyTemperature, Double.valueOf(36.7));

	    	calculateNameValuePairsData.put(Constants.Key_BMI, Double.valueOf(23.4));

	    	HashMap<String, Object> RecommendFoodAndAmounts = new HashMap<String, Object>();
		    RecommendFoodAndAmounts.put("20001", Integer.valueOf(100));
		    RecommendFoodAndAmounts.put("20002", Integer.valueOf(150));
//		    CalculateNameValuePairsData.put("RecommendFoodAndAmounts", RecommendFoodAndAmounts);
		    HashMap<String, Object> LackNutrientsAndFoods = new HashMap<String, Object>();
		    LackNutrientsAndFoods.put("Vb2", RecommendFoodAndAmounts);
		    RecommendFoodAndAmounts = new HashMap<String, Object>();
		    RecommendFoodAndAmounts.put("20011", Integer.valueOf(100));
		    RecommendFoodAndAmounts.put("20012", Integer.valueOf(150));
		    LackNutrientsAndFoods.put("Vb3", RecommendFoodAndAmounts);
		    calculateNameValuePairsData.put(Constants.Key_LackNutrientsAndFoods, LackNutrientsAndFoods);
		    
		    HashMap<String, Object> InferIllnessesAndSuggestions = new HashMap<String, Object>();
		    InferIllnessesAndSuggestions.put("disease1", new Object[]{"建议11","建议12"});
		    InferIllnessesAndSuggestions.put("disease2", new Object[]{"建议21","建议22"});
		    calculateNameValuePairsData.put(Constants.Key_InferIllnessesAndSuggestions, InferIllnessesAndSuggestions);
		    
	    	final ParseObject parseObjUserRecord2 = ToolParse.getToSaveParseObject_UserRecordSymptom(ctx,daylocal2,dt,inputNameValuePairsData,Note,calculateNameValuePairsData );
	    	parseObjUserRecord2.saveInBackground(new SaveCallback() {
				
				@Override
				public void done(ParseException e) {
					String msg;
					if (e != null){
						msg = "ERR: "+e.getMessage();
					}else{
						msg = "Save OK."+ parseObjUserRecord2.getObjectId();
						StoredConfigTool.saveParseObjectInfo_CurrentUserRecordSymptom(cCtx, parseObjUserRecord2.getObjectId(), daylocal2);
					}
					Log.d("ActivityTestCases", "saveParseRowObj msg:"+msg);
					
					ToolParse.syncRemoteDataToLocal(cCtx, new JustCallback(){

						@Override
						public void cbFun(boolean succeeded) {
							DataAccess da = DataAccess.getSingleton(cCtx);
							da.getUserRecordSymptomRawRowsByRange_withStartDayLocal(0,0,0,0);
							
							ToolParse.syncRemoteDataToLocal(cCtx, new JustCallback(){

								@Override
								public void cbFun(boolean succeeded) {
									DataAccess da = DataAccess.getSingleton(cCtx);
									da.getUserRecordSymptomRawRowsByRange_withStartDayLocal(0,0,0,0);
									
								}
							});//syncRemoteDataToLocal
						}
					});//syncRemoteDataToLocal
				}//done
			});//saveInBackground
		}
    }

	
	
}



















