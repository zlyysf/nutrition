package com.lingzhimobile.nutritionfoodguide.v3.activity;

import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Map.Entry;


import org.json.JSONArray;
import org.json.JSONException;

import android.R.bool;
import android.R.integer;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.util.Pair;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.lingzhimobile.nutritionfoodguide.*;
import com.lingzhimobile.nutritionfoodguide.v3.activity.V3ActivityFoodsByType.ListAdapterForFood;
import com.lingzhimobile.nutritionfoodguide.v3.fragment.*;
import com.lingzhimobile.nutritionfoodguide.v3.fragment.V3EncyclopediaFragment.OnClickListener_nutrient;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.SaveCallback;

public class V3ActivityReport extends V3BaseActivity {
	
	static final String LogTag = "V3ActivityReport";
	public static final int IntentResultCode = 1000;
	
	final static int c_nutrientFoodCountLimit = 5;

    // widgets
	Button m_btnSave, m_btnBack;
	ScrollViewDebug m_scrollView1;
	LinearLayout m_llLackNutrients, m_llRecommendFood, m_llPossibleIllness, m_llSuggestion;
	ListView m_lvehIllness, m_lvehSuggestion;
	
    ListView elementFoodListView;
//    ListView diseaseAttentionListView;
    LinearLayout attentionLinearLayout;
    TextView bmiTextView, healthTextView, m_tvBmiTooLight, m_tvBmiNormal, m_tvBmiTooWeight, m_tvBmiFat;
    ArrayList<TextView> m_tvNutrients;

    ArrayList<String> m_SymptomIdList;
    String[] m_symptomIds;
    String m_SymptomsByType_str;
    ArrayList<Object> m_SymptomsByType;
    double m_BodyTemperature, m_Weight;
    int m_HeartRate, m_BloodPressureLow, m_BloodPressureHigh;
    HashMap<String, Object> m_measureHm;
    String m_note;
    int m_dayLocal;
    
    HashMap<String, Double> m_DRIsDict;
    HashMap<String, HashMap<String, Object>> m_nutrientInfoDict2Level;
    
    double m_BMI, m_HealthMark;
    ArrayList<String> m_nutrientIdList;
    String[] m_nutrientIds;
    HashMap<String, ArrayList<HashMap<String, Object>>> m_FoodsByNutrient;
    HashMap<String, HashMap<String, Double>> m_FoodAndAmountByNutrientData;
    ArrayList<String> m_illnessIdList ;
    HashMap<String, HashMap<String, Object>> m_illnessInfoDict2Level;
    ArrayList<String> m_suggestionDistinctIdList;
//    ArrayList<HashMap<String, Object>> m_suggestionDistinctRowList;
    HashMap<String, HashMap<String, Object>> m_suggestionInfoDict2Level;
    
    HashMap<String, ArrayList<HashMap<String, Object>>> m_suggestionsByIllnessHm;
    
    boolean m_IsShowingData = false;
    boolean m_alreadyExistDataRow = false;

//    List<String> nutrientList = new ArrayList<String>();
//    List<List<Pair<String, Double>>> recommendFoodList = new ArrayList<List<Pair<String, Double>>>();

//    List<String> diseaseList = new ArrayList<String>();
//    List<List<String>> attentionList = new ArrayList<List<String>>();

    NutrientFoodAdapter nutrientFoodAdapter;
//    DiseaseAttentionAdapter diseaseAttentionAdapter;
    

    DataAccess da;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.v3_activity_report);
        
        da = DataAccess.getSingleton(this);
        
        initViewHandles();
        initViewsContent();
        setViewEventHandlers();
        setViewsContent();

//        GetNutrientFoodTask getNutrientFoodTask = new GetNutrientFoodTask();
//        getNutrientFoodTask.execute();
//
//        GetDiseaseAttentionTask getDiseaseAttentionTask = new GetDiseaseAttentionTask();
//        getDiseaseAttentionTask.execute();

    }
    
    void initViewHandles(){
        m_btnSave = (Button) findViewById(R.id.rightButton);
        m_btnSave.setText(R.string.save);
        m_btnBack = (Button) findViewById(R.id.leftButton);
        m_currentTitle = "养生报告";
        TextView tvTitle = (TextView)findViewById(R.id.titleText);
        tvTitle.setText(m_currentTitle);
        
        m_scrollView1 = (ScrollViewDebug)findViewById(R.id.scrollView1);
        
        m_llLackNutrients = (LinearLayout)findViewById(R.id.llLackNutrients);
        m_llRecommendFood = (LinearLayout)findViewById(R.id.llRecommendFood);
        m_llPossibleIllness = (LinearLayout)findViewById(R.id.llPossibleIllness);
        m_llSuggestion = (LinearLayout)findViewById(R.id.llSuggestion);

        bmiTextView = (TextView) findViewById(R.id.bmiTextView);
        m_tvBmiTooLight =  (TextView) findViewById(R.id.tvBmiTooLight);
        m_tvBmiNormal =  (TextView) findViewById(R.id.tvBmiNormal);
        m_tvBmiTooWeight =  (TextView) findViewById(R.id.tvBmiTooWeight);
        m_tvBmiFat =  (TextView) findViewById(R.id.tvBmiFat);
        healthTextView = (TextView) findViewById(R.id.healthTextView);
        elementFoodListView = (ListView) findViewById(R.id.elementFoodListView);
//        diseaseAttentionListView = (ListView) findViewById(R.id.diseaseAttentionListView);
        
        TextView tvNutrient1 = (TextView) findViewById(R.id.tvNutrient1);
        TextView tvNutrient2 = (TextView) findViewById(R.id.tvNutrient2);
        TextView tvNutrient3 = (TextView) findViewById(R.id.tvNutrient3);
        TextView tvNutrient4 = (TextView) findViewById(R.id.tvNutrient4);
        m_tvNutrients = new ArrayList<TextView>();
        m_tvNutrients.add(tvNutrient1);
        m_tvNutrients.add(tvNutrient2);
        m_tvNutrients.add(tvNutrient3);
        m_tvNutrients.add(tvNutrient4);
        
        m_lvehIllness = (ListView) findViewById(R.id.lvehIllness);
        m_lvehSuggestion = (ListView) findViewById(R.id.lvehSuggestion);
	}
    
    void initViewsContent(){
    	Intent intent = getIntent();
    	
    	String prevActvTitle = intent.getStringExtra(Constants.IntentParamKey_BackButtonTitle);
        if (prevActvTitle!=null)
        	m_btnBack.setText(prevActvTitle);
        
        m_IsShowingData = intent.getBooleanExtra(Constants.IntentParamKey_IsShowingData, false);
        m_nutrientInfoDict2Level = GlobalVar.getAllNutrient2LevelDict(this);
        if (!m_IsShowingData){
        	Date updateTime = new Date();
        	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
    		m_dayLocal = Integer.parseInt(sdf.format(updateTime));
        	HashMap<String, Object> row = da.getUserRecordSymptomDataByDayLocal(m_dayLocal);
        	m_alreadyExistDataRow = (row!=null);
        	
        	m_SymptomIdList = intent.getStringArrayListExtra(Constants.COLUMN_NAME_SymptomId);
            m_symptomIds = Tool.convertToStringArray(m_SymptomIdList);
            
            m_BodyTemperature = intent.getDoubleExtra(Constants.Key_BodyTemperature,0);
            m_Weight = intent.getDoubleExtra(Constants.Key_Weight,0);
            m_HeartRate = intent.getIntExtra(Constants.Key_HeartRate, 0);
            m_BloodPressureLow = intent.getIntExtra(Constants.Key_BloodPressureLow, 0);
            m_BloodPressureHigh = intent.getIntExtra(Constants.Key_BloodPressureHigh, 0);
            
            m_note = intent.getStringExtra(Constants.COLUMN_NAME_Note);
            
            m_measureHm = new HashMap<String, Object>();
            if (m_BodyTemperature > 0)
            	m_measureHm.put(Constants.Key_BodyTemperature, m_BodyTemperature);
            if (m_Weight > 0)
            	m_measureHm.put(Constants.Key_Weight, m_Weight);
            if (m_HeartRate>0)
            	m_measureHm.put(Constants.Key_HeartRate, m_HeartRate);
            if (m_BloodPressureLow>0)
            	m_measureHm.put(Constants.Key_BloodPressureLow, m_BloodPressureLow);
            if (m_BloodPressureHigh>0)
            	m_measureHm.put(Constants.Key_BloodPressureHigh, m_BloodPressureHigh);
            
            m_SymptomsByType_str = intent.getStringExtra(Constants.Key_SymptomsByType);
            if (m_SymptomsByType_str!=null && m_SymptomsByType_str.length()>0){
            	try {
        			m_SymptomsByType = Tool.JsonToArrayList(new JSONArray(m_SymptomsByType_str));
        			Log.d(LogTag, "m_SymptomsByType="+m_SymptomsByType);
        		} catch (JSONException e) {
        			Log.e(LogTag, "new JSONArray string Err"+e.getMessage(),e);
        			throw new RuntimeException(e);
        		}
            }else{
            	m_SymptomsByType = null;
            }
            
            calculate();
        }else{
        	m_dayLocal = intent.getIntExtra(Constants.COLUMN_NAME_DayLocal, 0);
        	HashMap<String, Object> row = da.getUserRecordSymptomDataByDayLocal(m_dayLocal);
//        	assert(row!=null);
        	HashMap<String, Object> InputNameValuePairsData = (HashMap<String, Object>)row.get(Constants.COLUMN_NAME_inputNameValuePairs);
        	HashMap<String, Object> CalculateNameValuePairsData = (HashMap<String, Object>)row.get(Constants.COLUMN_NAME_calculateNameValuePairs);
        	
        	m_SymptomIdList = (ArrayList<String>)InputNameValuePairsData.get(Constants.Key_Symptoms);
        	m_symptomIds = Tool.convertToStringArray(m_SymptomIdList);
        	m_SymptomsByType = (ArrayList<Object>)InputNameValuePairsData.get(Constants.Key_SymptomsByType);
    	    Double obj_BodyTemperature = Double.parseDouble(""+ InputNameValuePairsData.get(Constants.Key_BodyTemperature));
    	    m_BodyTemperature = obj_BodyTemperature==null? 0 : obj_BodyTemperature.doubleValue();
    	    Double obj_Weight = Double.parseDouble(""+ InputNameValuePairsData.get(Constants.Key_Weight));
    	    m_Weight = (obj_Weight==null)? 0 : obj_Weight.doubleValue();
    	    Integer obj_HeartRate = (Integer)InputNameValuePairsData.get(Constants.Key_HeartRate);
    	    m_HeartRate = (obj_HeartRate==null)? 0 : obj_HeartRate.intValue();
    	    Integer obj_BloodPressureLow = (Integer)InputNameValuePairsData.get(Constants.Key_BloodPressureLow);
    	    m_BloodPressureLow = (obj_BloodPressureLow==null) ? 0 : obj_BloodPressureLow.intValue();
    	    Integer obj_BloodPressureHigh = (Integer)InputNameValuePairsData.get(Constants.Key_BloodPressureHigh);
    	    m_BloodPressureHigh = (obj_BloodPressureHigh==null) ? 0 : obj_BloodPressureHigh.intValue();
        	
    	    Double obj_BMI = Double.parseDouble(""+ CalculateNameValuePairsData.get(Constants.Key_BMI));
    	    m_BMI = (obj_BMI==null)? 0 : obj_BMI.doubleValue();
    	    Double obj_HealthMark = Double.parseDouble(""+ CalculateNameValuePairsData.get(Constants.Key_HealthMark));
    	    m_HealthMark = (obj_HealthMark==null)? 0 : obj_HealthMark.doubleValue();
    	    
    	    m_FoodAndAmountByNutrientData = (HashMap<String, HashMap<String, Double>>)CalculateNameValuePairsData.get(Constants.Key_LackNutrientsAndFoods);
    	    if (m_FoodAndAmountByNutrientData != null){
    	    	m_nutrientIdList = new ArrayList<String>();
    	    	
    	    	Iterator<Map.Entry<String, HashMap<String, Double>>> iter = m_FoodAndAmountByNutrientData.entrySet().iterator();
        		while (iter.hasNext()) {
        			Map.Entry<String, HashMap<String, Double>> entry = iter.next();
    	    		String nutrientId = entry.getKey();
    	    		HashMap<String, Double> foodAndAmountHm = entry.getValue();
    	    		m_nutrientIdList.add(nutrientId);
        		}
        		m_nutrientIds= Tool.convertToStringArray(m_nutrientIdList);
    	    }
    	    
//    	    HashMap<String, ArrayList<String>> InferIllnessesAndSuggestions = CalculateNameValuePairsData.get(Constants.Key_InferIllnessesAndSuggestions);
    	    
    	    m_illnessIdList = (ArrayList<String>)CalculateNameValuePairsData.get(Constants.Key_IllnessIds);
    	    m_suggestionDistinctIdList = (ArrayList<String>)CalculateNameValuePairsData.get(Constants.Key_distinctSuggestionIds);
        }
        
    }
    
    void setViewEventHandlers(){
    	m_btnBack.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                setResult(IntentResultCode);
                finish();
            }
        });
    	m_btnSave.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                save();
                m_btnSave.setEnabled(false);
            }
        });
    	m_scrollView1.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				m_scrollView1.mCanScroll = true;
			}
		});
    }
    
    void setViewsContent(){
    	if (m_IsShowingData){
    		m_btnSave.setVisibility(View.INVISIBLE);
    	}
    	show();
    }
    

    
    ArrayList<HashMap<String, Object>> getRandItemWithGivenCount(int count, ArrayList<HashMap<String, Object>> items){
    	if (items == null || items.size()<=count)
    		return items;
    	ArrayList<HashMap<String, Object>> items2 = new ArrayList<HashMap<String,Object>>();
    	items2.addAll(items);
    	ArrayList<HashMap<String, Object>> gotItems = new ArrayList<HashMap<String,Object>>();
    	for(int i=0; i<count; i++){
    		int idx = Tool.getRandObj().nextInt(items2.size())  ;
    		HashMap<String, Object> item = items2.remove(idx);
    		gotItems.add(item);
    	}
    	return gotItems;
    }
    
    void calculate(){
    	Date updateTime = new Date();
//    	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
//		m_dayLocal = Integer.parseInt(sdf.format(updateTime));
//    	HashMap<String, Object> row = da.getUserRecordSymptomDataByDayLocal(m_dayLocal);
//    	m_alreadyExistDataRow = (row!=null);
    	
    	HashMap<String, Object> hmUserInfo = StoredConfigTool.getUserInfo(this);
    	m_DRIsDict = da.getStandardDRIs_withUserInfo(hmUserInfo, null);
    	
    	m_BMI = 0;
    	Double heightObj = (Double)hmUserInfo.get(Constants.ParamKey_height);
    	Double weightObj = (Double)hmUserInfo.get(Constants.ParamKey_weight);
    	double weight = m_Weight;
    	if (weight==0)
    		weight = weightObj.doubleValue();
    	m_BMI = Tool.getBMI_withWeight(weight, heightObj.doubleValue());
    	
    	m_HealthMark = 100;
    	if (m_symptomIds!=null && m_symptomIds.length>0){
    		double deductSum = da.getSymptomHealthMarkSum_BySymptomIds(m_symptomIds);
    		m_HealthMark = Math.max(0, 100 - deductSum);
    	}
    	
    	if (m_SymptomIdList!=null && m_SymptomIdList.size()>0){
    		m_nutrientIdList = da.getSymptomNutrientIdsWithDisplaySort_BySymptomIds(m_SymptomIdList);
    		m_nutrientIdList = Tool.getSubList(m_nutrientIdList, 0, Constants.Config_getLackNutrientLimit);
        	m_nutrientIds = Tool.convertToStringArray(m_nutrientIdList);
    	}
    	
    	if (m_nutrientIds!=null && m_nutrientIds.length>0){
    		m_FoodsByNutrient = new HashMap<String, ArrayList<HashMap<String,Object>>>();
    		for(int i=0; i<m_nutrientIds.length; i++){
    			String nutrientId = m_nutrientIds[i];
    			Double nutrientDRI = (Double)m_DRIsDict.get(nutrientId);
    			ArrayList<HashMap<String, Object>> foods = da.getRichNutritionFood2_withAmount_ForNutrient(nutrientId, nutrientDRI);
    			ArrayList<HashMap<String, Object>> foods2 = getRandItemWithGivenCount(c_nutrientFoodCountLimit, foods);
    			m_FoodsByNutrient.put(nutrientId, foods2);
    		}//for i
    	}
    	
    	m_illnessIdList = Tool.inferIllnesses_withSymptoms(m_SymptomIdList, m_measureHm);
    	
    	if (!m_alreadyExistDataRow){
    		save();
    		m_btnSave.setEnabled(false);
    		m_btnSave.setText(R.string.saved);
    	}
    }
    
    void show(){
		String bmiStr = String.format("%3.1f", m_BMI);
		bmiTextView.setText(bmiStr);
		
		if (m_BMI < 18.5){
    		m_tvBmiTooLight.setBackgroundResource(R.drawable.v3_border_bmi_toolight_bg);
    	}else if  (m_BMI <= 25){
    		m_tvBmiNormal.setBackgroundResource(R.drawable.v3_border_bmi_normal_bg);
    	}else if  (m_BMI <= 30){
    		m_tvBmiTooWeight.setBackgroundResource(R.drawable.v3_border_bmi_tooweight_bg);
    	}else{
    		m_tvBmiFat.setBackgroundResource(R.drawable.v3_border_bmi_fat_bg);
    	}

		healthTextView.setText(Tool.formatFloatOrInt(m_HealthMark, 1));
		
		V3EncyclopediaFragment.OnClickListener_nutrient OnClickListener_nutrient1 = new V3EncyclopediaFragment.OnClickListener_nutrient(this,m_currentTitle);
    	int lenOfNutrientIds = m_nutrientIds==null? 0 : m_nutrientIds.length;
    	if (lenOfNutrientIds == 0){
    		m_llLackNutrients.setVisibility(View.GONE);
    		m_llRecommendFood.setVisibility(View.GONE);
    	}else{
    		m_llLackNutrients.setVisibility(View.VISIBLE);
    		m_llRecommendFood.setVisibility(View.VISIBLE);
    		
	    	for(int i = 0;i< m_tvNutrients.size();i++){
	    		TextView tvNutrient = m_tvNutrients.get(i);
	            if ( i < lenOfNutrientIds){
	            	tvNutrient.setVisibility(View.VISIBLE);
	            	String nutrientId = m_nutrientIds[i];
	            	HashMap<String, Object> nutrientInfo = m_nutrientInfoDict2Level.get(nutrientId);
	            	String nutrientCaption = (String)nutrientInfo.get(Constants.COLUMN_NAME_IconTitleCn);
	            	String[] cnenParts = Tool.splitNutrientTitleToCnEn(nutrientCaption);
	            	tvNutrient.setText(cnenParts[cnenParts.length-1]);
	            	tvNutrient.setTag(nutrientId);
	            	tvNutrient.setOnClickListener(OnClickListener_nutrient1);
	                Tool.changeBackground_NutritionButton(V3ActivityReport.this, tvNutrient, nutrientId, true);
	            } else {
	            	tvNutrient.setVisibility(View.INVISIBLE);
	            }
	        }
	    	
	    	nutrientFoodAdapter = new NutrientFoodAdapter();
			elementFoodListView.setAdapter(nutrientFoodAdapter);
    	}
    	
    	if (m_illnessIdList != null && m_illnessIdList.size()>0 ){
    		ArrayList<HashMap<String, Object>> illnessRows = da.getIllness_ByIllnessIds(m_illnessIdList);
    		m_illnessInfoDict2Level = Tool.dictionaryArrayTo2LevelDictionary_withKeyName(Constants.COLUMN_NAME_IllnessId,illnessRows);
    		
    		m_suggestionsByIllnessHm = new HashMap<String, ArrayList<HashMap<String,Object>>>();
    		for(int i=0; i<m_illnessIdList.size(); i++){
    			String illnessId = m_illnessIdList.get(i);
    			ArrayList<HashMap<String, Object>> illnessSuggestions = da.getIllnessSuggestions_ByIllnessId(illnessId);
    			m_suggestionsByIllnessHm.put(illnessId, illnessSuggestions);
    		}
    		
    		m_suggestionDistinctIdList = da.getIllnessSuggestionDistinctIds_ByIllnessIds(m_illnessIdList);
    		ArrayList<HashMap<String, Object>> suggestionDistinctRowList = da.getIllnessSuggestions_BySuggestionIds(m_suggestionDistinctIdList);
    		m_suggestionInfoDict2Level = Tool.dictionaryArrayTo2LevelDictionary_withKeyName(Constants.COLUMN_NAME_SuggestionId,suggestionDistinctRowList);
    		
    	}
		
//		diseaseAttentionAdapter = new DiseaseAttentionAdapter();
//		diseaseAttentionListView.setAdapter(diseaseAttentionAdapter);
    	if (m_illnessIdList == null || m_illnessIdList.size()==0 ){
    		m_llPossibleIllness.setVisibility(View.GONE);
    	}else{
    		m_llPossibleIllness.setVisibility(View.VISIBLE);
    		IllnessAdapter IllnessAdapter1 = new IllnessAdapter();
    		m_lvehIllness.setAdapter(IllnessAdapter1);
    	}
    	
    	if (m_suggestionDistinctIdList == null || m_suggestionDistinctIdList.size()==0){
    		m_llSuggestion.setVisibility(View.GONE);
    	}else{
    		m_llSuggestion.setVisibility(View.VISIBLE);
    		SuggestionAdapter SuggestionAdapter1 = new SuggestionAdapter();
    		m_lvehSuggestion.setAdapter(SuggestionAdapter1);
    	}
    	
    }
    
    HashMap<String, HashMap<String, Double>> getData_FoodAndAmountByNutrient_fromFoodsByNutrient(){
    	HashMap<String, HashMap<String, Double>> FoodAndAmountByNutrientData = new HashMap<String, HashMap<String,Double>>();
    	if (m_FoodsByNutrient!=null){
    		Iterator<Map.Entry<String, ArrayList<HashMap<String, Object>>>> iter = m_FoodsByNutrient.entrySet().iterator();
    		while (iter.hasNext()) {
    			Map.Entry<String, ArrayList<HashMap<String, Object>>> entry = iter.next();
	    		String nutrientId = entry.getKey();
	    		ArrayList<HashMap<String, Object>> foods = entry.getValue();
	    		HashMap<String, Double> foodAndAmountHm = new HashMap<String, Double>();
	    		if (foods!=null){
	    			for(int i=0; i<foods.size(); i++){
	    				HashMap<String, Object> food = foods.get(i);
	    				String foodId = (String)food.get(Constants.COLUMN_NAME_NDB_No);
	    				Double foodAmount = (Double)food.get(Constants.Key_Amount);
	    				foodAndAmountHm.put(foodId, foodAmount);
	    			}
	    		}
	    		FoodAndAmountByNutrientData.put(nutrientId, foodAndAmountHm);
    		}
    	}
    	return FoodAndAmountByNutrientData;
    }
    
    HashMap<String, ArrayList<String>> getData_SuggestionIdsByIllness_fromSuggestionsByIllness(){
    	//HashMap<String, ArrayList<HashMap<String, Object>>> m_suggestionsByIllnessHm;
    	HashMap<String, ArrayList<String>> SuggestionIdsByIllnessData = new HashMap<String, ArrayList<String>>();
    	if (m_suggestionsByIllnessHm!=null){
    		Iterator<Map.Entry<String, ArrayList<HashMap<String, Object>>>> iter = m_suggestionsByIllnessHm.entrySet().iterator();
    		while (iter.hasNext()) {
    			Map.Entry<String, ArrayList<HashMap<String, Object>>> entry = iter.next();
    			String illnessId = entry.getKey();
	    		ArrayList<HashMap<String, Object>> suggestions = entry.getValue();
	    		ArrayList<Object> suggestionIdsAsObj = Tool.getPropertyArrayListFromDictionaryArray_withPropertyName(Constants.COLUMN_NAME_SuggestionId, suggestions);
	    		ArrayList<String> suggestionIds = Tool.convertToStringArrayList(suggestionIdsAsObj);
	    		if (suggestionIds==null)
	    			suggestionIds = new ArrayList<String>();
	    		SuggestionIdsByIllnessData.put(illnessId, suggestionIds);
    		}
    	}
    	return SuggestionIdsByIllnessData;
    }
    
    void save(){
    	Log.d(LogTag, "save enter");
    	
    	GlobalVar.UserDiagnoseRecordHaveUpdated_forHistory = true;

		Date updateTime = new Date();
		int dayLocal = m_dayLocal;
		
	    HashMap<String, Object> InputNameValuePairsData;
	    HashMap<String, Object> CalculateNameValuePairsData;
	    HashMap<String, ArrayList<String>>  InferIllnessesAndSuggestions;
	    
	    InputNameValuePairsData = new HashMap<String, Object>();
	    InputNameValuePairsData.put(Constants.Key_Symptoms, m_symptomIds);
	    InputNameValuePairsData.put(Constants.Key_SymptomsByType, m_SymptomsByType);
	    InputNameValuePairsData.put(Constants.Key_BodyTemperature, Double.valueOf(m_BodyTemperature));
	    InputNameValuePairsData.put(Constants.Key_Weight, Double.valueOf(m_Weight));
	    InputNameValuePairsData.put(Constants.Key_HeartRate, Integer.valueOf(m_HeartRate));
	    InputNameValuePairsData.put(Constants.Key_BloodPressureLow, Integer.valueOf(m_BloodPressureLow));
	    InputNameValuePairsData.put(Constants.Key_BloodPressureHigh, Integer.valueOf(m_BloodPressureHigh));

	    CalculateNameValuePairsData = new HashMap<String, Object>();
	    CalculateNameValuePairsData.put(Constants.Key_BMI, Double.valueOf(m_BMI));
	    CalculateNameValuePairsData.put(Constants.Key_HealthMark, Double.valueOf(m_HealthMark));
	    
	    HashMap<String, HashMap<String, Double>> FoodAndAmountByNutrientData = getData_FoodAndAmountByNutrient_fromFoodsByNutrient();
	    CalculateNameValuePairsData.put(Constants.Key_LackNutrientsAndFoods, FoodAndAmountByNutrientData);
	    
	    InferIllnessesAndSuggestions = getData_SuggestionIdsByIllness_fromSuggestionsByIllness();
	    CalculateNameValuePairsData.put(Constants.Key_InferIllnessesAndSuggestions, InferIllnessesAndSuggestions);
	    CalculateNameValuePairsData.put(Constants.Key_IllnessIds, m_illnessIdList);
	    CalculateNameValuePairsData.put(Constants.Key_distinctSuggestionIds, m_suggestionDistinctIdList);
	    
	    if (!m_alreadyExistDataRow){
	    	da.insertUserRecordSymptom_withDayLocal(dayLocal,updateTime,InputNameValuePairsData,m_note,CalculateNameValuePairsData);
	    	m_alreadyExistDataRow = true;
	    }else{
	    	da.updateUserRecordSymptom_withDayLocal(dayLocal, updateTime, InputNameValuePairsData, m_note, CalculateNameValuePairsData);
	    }
	    
	    ParseObject parseObj = ToolParse.getToSaveParseObject_UserRecordSymptom(this, dayLocal, updateTime, InputNameValuePairsData, m_note, CalculateNameValuePairsData);
	    parseObj.saveInBackground(new ToolParse.SaveCallbackClass(parseObj) {
			@Override
			public void done(ParseException e) {
				ParseObject parseObj = getParseObject();
				int dayLocal = parseObj.getInt(Constants.COLUMN_NAME_DayLocal);
				
				String msg;
				if (e != null){
					msg = "ERR: "+e.getMessage();
				}else{
					msg = "Save OK."+ parseObj.getObjectId();
				}
				Log.d(LogTag, "parseObj.saveInBackground msg:"+msg);
				StoredConfigTool.saveParseObjectInfo_CurrentUserRecordSymptom(V3ActivityReport.this, parseObj.getObjectId(), dayLocal);
			}
		});//saveInBackground
    }

    class GetDiseaseAttentionTask extends AsyncTask<Void, Void, Void> {

        @Override
        protected Void doInBackground(Void... arg0) {
//            HashMap<String, Object> measureData = new HashMap<String, Object>();
//            measureData.put(Constants.Key_HeartRate, heartRate);
//            measureData.put(Constants.Key_BloodPressureHigh, bloodPressureHigh);
//            measureData.put(Constants.Key_BloodPressureLow, bloodPressureLow);
//            measureData.put(Constants.Key_BodyTemperature, bodyTemperature);
//
//            diseaseList = Tool.inferIllnesses_withSymptoms(
//                    Tool.convertFromArrayToList(symptomIds), measureData);
//
//            for (String disease : diseaseList) {
//                ArrayList<String> tempList = new ArrayList<String>();
//                tempList.add(disease);
//                ArrayList<HashMap<String, Object>> result = da
//                        .getIllnessSuggestionsDistinct_ByIllnessIds(tempList);
//                List<String> attention = new ArrayList<String>();
//                if (result != null) {
//                    for (HashMap<String, Object> map : result) {
//                        attention.add(map.get("SuggestionId").toString());
//                    }
//                }
//                attentionList.add(attention);
//            }

            return null;
        }

        @Override
        protected void onPostExecute(Void result) {
            super.onPostExecute(result);
//            diseaseAttentionAdapter.notifyDataSetChanged();
        }

    }

    class GetNutrientFoodTask extends AsyncTask<Void, Void, Void> {

        @Override
        protected Void doInBackground(Void... arg0) {

//            ArrayList<String> symptomIdList = Tool
//                    .convertFromArrayToList(symptomIds);
//            ArrayList<String> nutrientIdList = da
//                    .getSymptomNutrientDistinctIds_BySymptomIds(symptomIdList);
//
//            HashMap<String, Object> userInfo = TestCaseRecommendFood
//                    .getUserInfo();
//            String[] nutrientIds = Tool.convertToStringArray(nutrientIdList);
//            RecommendFood rf = new RecommendFood(V3ActivityReport.this);
//            HashMap<String, ArrayList<HashMap<String, Object>>> map = rf
//                    .getSingleNutrientRichFoodWithAmount_forNutrients(
//                            nutrientIds, userInfo, null);
//
//            for (String nutrientId : nutrientIds) {
//                ArrayList<Pair<String, Double>> recommentFoods = new ArrayList<Pair<String, Double>>();
//                ArrayList<HashMap<String, Object>> food = (ArrayList<HashMap<String, Object>>) map
//                        .get(nutrientId);
//                for (HashMap<String, Object> foodItem : food) {
//                    String cnCaption = (String) foodItem.get(Constants.COLUMN_NAME_CnCaption);
//                    Double amount = (Double) foodItem.get(Constants.Key_Amount);
//                    recommentFoods.add(new Pair<String, Double>(cnCaption,
//                            amount));
//                }
//                recommendFoodList.add(recommentFoods);
//            }
//            nutrientList.addAll(nutrientIdList);
            return null;
        }

        @Override
        protected void onPostExecute(Void result) {
            super.onPostExecute(result);
            nutrientFoodAdapter.notifyDataSetChanged();
        }

    }
    
    static class OnClickListenerForFood extends OnClickListenerInListItem{
		V3BaseActivity m_thisActivity;
		HashMap<String, Object> m_foodData; 

		public OnClickListenerForFood(V3BaseActivity thisActivity, HashMap<String, Object> foodData){
			m_thisActivity = thisActivity;
			m_foodData = foodData;
		}

		@Override
		public void onClick(View v) {
			String foodName = (String)m_foodData.get(Constants.COLUMN_NAME_CnCaption);
			String foodId = (String)m_foodData.get(Constants.COLUMN_NAME_NDB_No);
			Log.d(LogTag, "OnClickListenerForFood foodId="+foodId+", foodName="+foodName);
			Intent intent1 = new Intent(m_thisActivity, ActivityFoodNutrition.class);
			intent1.putExtra(Constants.IntentParamKey_BackButtonTitle, m_thisActivity.getCurrentTitle());
			intent1.putExtra(Constants.COLUMN_NAME_NDB_No, foodId);
			m_thisActivity.startActivity(intent1);
		}
	}//class OnClickListenerForInputFoodAmount

    class NutrientFoodAdapter extends BaseAdapter {

        @Override
        public int getCount() {
            return m_nutrientIdList==null?0:m_nutrientIdList.size();
        }

        @Override
        public Object getItem(int arg0) {
            return m_nutrientIdList.get(arg0);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            if (convertView == null) {
                convertView = getLayoutInflater().inflate(R.layout.v3_nutrient_cell, null);
            }
            String nutrientId = m_nutrientIdList.get(position);
            HashMap<String, Object> nutrientInfo = m_nutrientInfoDict2Level.get(nutrientId);
            String nutrientCaption = (String)nutrientInfo.get(Constants.COLUMN_NAME_IconTitleCn);
            
            String[] cnenParts = Tool.splitNutrientTitleToCnEn(nutrientCaption);
            
            TextViewSimpleVertical tvvNutrient = (TextViewSimpleVertical) convertView.findViewById(R.id.tvvNutrient);
            tvvNutrient.setTextVertical(cnenParts[cnenParts.length-1]);

            LinearLayout recommendViewPager = (LinearLayout) convertView.findViewById(R.id.recommendViewPager);
            recommendViewPager.removeAllViews();
            if (!m_IsShowingData){
            	ArrayList<HashMap<String, Object>> nutrientFoods = m_FoodsByNutrient.get(nutrientId);
                if (nutrientFoods!=null && nutrientFoods.size()>0) {
                    for(int i=0; i<nutrientFoods.size(); i++){
                    	HashMap<String, Object> food = nutrientFoods.get(i);
                    	String foodName = (String)food.get(Constants.COLUMN_NAME_CnCaption);
                    	Double foodAmount = (Double)food.get(Constants.Key_Amount);
                    	
                    	View viewPager = getLayoutInflater().inflate(R.layout.v3_recomment_food_cell, null);
//                    	LinearLayout llFood = (LinearLayout)viewPager.findViewById(R.id.llFood);
                        TextView foodNameTextView = (TextView) viewPager.findViewById(R.id.foodNameTextView);
                        TextView foodCountTextView = (TextView) viewPager.findViewById(R.id.foodCountTextView);
                        ImageView ivFood = (ImageView) viewPager.findViewById(R.id.ivFood);
                        ImageView imageViewBgEffect = (ImageView)viewPager.findViewById(R.id.imageViewBgEffect);

                        foodNameTextView.setText(foodName);
                        foodCountTextView.setText(foodAmount.intValue()+"g");
                        ivFood.setImageDrawable(Tool.getDrawableForFoodPic(getAssets(), (String)food.get(Constants.COLUMN_NAME_PicPath)));
                        recommendViewPager.addView(viewPager);
//                        llFood.setOnClickListener(new OnClickListenerForFood(V3ActivityReport.this,food));
                        imageViewBgEffect.setOnClickListener(new OnClickListenerForFood(V3ActivityReport.this,food));
                        
                        
                    }
                }
            }else{
            	HashMap<String, Double> FoodAndAmountHm = m_FoodAndAmountByNutrientData.get(nutrientId);
                HashMap<String, HashMap<String, Object>> AllFood2LevelDict = GlobalVar.getAllFood2LevelDict(V3ActivityReport.this);
                ArrayList<String> foodIds = Tool.getKeysFromHashMap(FoodAndAmountHm);
                if (foodIds!=null && foodIds.size()>0){
                	for(int i=0; i<foodIds.size(); i++){
                		String foodId = foodIds.get(i);
                		HashMap<String, Object> food = AllFood2LevelDict.get(foodId);
                		String foodName = (String)food.get(Constants.COLUMN_NAME_CnCaption);
                    	Double foodAmount = Double.parseDouble(""+ FoodAndAmountHm.get(foodId));
                    	View viewPager = getLayoutInflater().inflate(R.layout.v3_recomment_food_cell, null);
//                    	LinearLayout llFood = (LinearLayout)viewPager.findViewById(R.id.llFood);
                        TextView foodNameTextView = (TextView) viewPager.findViewById(R.id.foodNameTextView);
                        TextView foodCountTextView = (TextView) viewPager.findViewById(R.id.foodCountTextView);
                        ImageView ivFood = (ImageView) viewPager.findViewById(R.id.ivFood);
                        ImageView imageViewBgEffect = (ImageView)viewPager.findViewById(R.id.imageViewBgEffect);
                        
                        foodNameTextView.setText(foodName);
                        foodCountTextView.setText(foodAmount.intValue()+"g");
                        ivFood.setImageDrawable(Tool.getDrawableForFoodPic(getAssets(), (String)food.get(Constants.COLUMN_NAME_PicPath)));
                        recommendViewPager.addView(viewPager);
//                        llFood.setOnClickListener(new OnClickListenerForFood(V3ActivityReport.this,food));
                        imageViewBgEffect.setOnClickListener(new OnClickListenerForFood(V3ActivityReport.this,food));
                	}
                }
            }
            

            return convertView;
        }

    }


    
    class IllnessAdapter extends BaseAdapter {

        @Override
        public int getCount() {
            return m_illnessIdList==null?0:m_illnessIdList.size();
        }

        @Override
        public Object getItem(int arg0) {
            return m_illnessIdList.get(arg0);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            if (convertView == null) {
                convertView = getLayoutInflater().inflate(R.layout.v3_row_illness, null);
            }
            TextView tvIllness = (TextView) convertView.findViewById(R.id.tvIllness);
            LinearLayout llIllness = (LinearLayout)convertView.findViewById(R.id.llIllness);
            
            String illnessId = m_illnessIdList.get(position);
            HashMap<String, Object> illnessInfo = m_illnessInfoDict2Level.get(illnessId);
            
            String illnessName = (String)illnessInfo.get(Constants.COLUMN_NAME_IllnessNameCn);
            
            tvIllness.setText(illnessName);
            
            V3EncyclopediaFragment.OnClickListenerInListItem_illness OnClickListenerInListItem_illness1 = new V3EncyclopediaFragment.OnClickListenerInListItem_illness(V3ActivityReport.this,m_currentTitle,illnessId);
            llIllness.setOnClickListener(OnClickListenerInListItem_illness1);

            return convertView;
        }

    }
    class SuggestionAdapter extends BaseAdapter {

        @Override
        public int getCount() {
            return m_suggestionDistinctIdList==null?0:m_suggestionDistinctIdList.size();
        }

        @Override
        public Object getItem(int arg0) {
            return m_suggestionDistinctIdList.get(arg0);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            if (convertView == null) {
                convertView = getLayoutInflater().inflate(R.layout.v3_row_suggestion, null);
            }
            TextView tvSuggestion = (TextView) convertView.findViewById(R.id.tvSuggestion);
            TextView tvRowPos = (TextView) convertView.findViewById(R.id.tvRowPos);
            
            String suggestionId = m_suggestionDistinctIdList.get(position);
            HashMap<String, Object> suggestionInfo = m_suggestionInfoDict2Level.get(suggestionId);
            
            String suggestionTxt = (String)suggestionInfo.get(Constants.COLUMN_NAME_SuggestionCn);
            
            tvSuggestion.setText(suggestionTxt);
            tvRowPos.setText((position+1)+"");

            return convertView;
        }

    }

}
