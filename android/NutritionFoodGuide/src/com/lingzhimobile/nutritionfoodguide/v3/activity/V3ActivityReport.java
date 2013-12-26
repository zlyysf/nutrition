package com.lingzhimobile.nutritionfoodguide.v3.activity;

import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Map.Entry;


import org.json.JSONArray;
import org.json.JSONException;

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
import com.lingzhimobile.nutritionfoodguide.v3.fragment.*;

public class V3ActivityReport extends V3BaseActivity {
	
	static final String LogTag = "V3ActivityReport";
	
	final static int c_nutrientFoodCountLimit = 5;

    // widgets
	Button m_btnSave;
	ListView m_lvehIllness, m_lvehSuggestion;
	
    ListView elementFoodListView;
//    ListView diseaseAttentionListView;
    LinearLayout attentionLinearLayout;
    TextView bmiTextView, healthTextView;

    ArrayList<String> m_SymptomIdList;
    String[] m_symptomIds;
    String m_SymptomsByType_str;
    ArrayList<Object> m_SymptomsByType;
    double m_BodyTemperature, m_Weight;
    int m_HeartRate, m_BloodPressureLow, m_BloodPressureHigh;
    HashMap<String, Object> m_measureHm;
    String m_note;
    
    HashMap<String, Double> m_DRIsDict;
    HashMap<String, HashMap<String, Object>> m_nutrientInfoDict2Level;
    
    double m_BMI, m_HealthMark;
    ArrayList<String> m_nutrientIdList;
    String[] m_nutrientIds;
    HashMap<String, ArrayList<HashMap<String, Object>>> m_FoodsByNutrient;
    ArrayList<String> m_illnessIdList ;
    HashMap<String, HashMap<String, Object>> m_illnessInfoDict2Level;
    ArrayList<String> m_suggestionDistinctIdList;
//    ArrayList<HashMap<String, Object>> m_suggestionDistinctRowList;
    HashMap<String, HashMap<String, Object>> m_suggestionInfoDict2Level;
    
    HashMap<String, ArrayList<HashMap<String, Object>>> m_suggestionsByIllnessHm;
    
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
        bmiTextView = (TextView) findViewById(R.id.bmiTextView);
        healthTextView = (TextView) findViewById(R.id.healthTextView);
        elementFoodListView = (ListView) findViewById(R.id.elementFoodListView);
//        diseaseAttentionListView = (ListView) findViewById(R.id.diseaseAttentionListView);
        
        m_lvehIllness = (ListView) findViewById(R.id.lvehIllness);
        m_lvehSuggestion = (ListView) findViewById(R.id.lvehSuggestion);
	}
    
    void initViewsContent(){
    	getInputParams();
        
    }
    
    void setViewEventHandlers(){
    	m_btnSave.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                save();
            }
        });
    }
    
    void setViewsContent(){
    	calculate();
    	show();
    }
    
    
    void getInputParams() {
    	Intent intent = getIntent();
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
    	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
    	Date updateTime = new Date();
		int dayLocal = Integer.parseInt(sdf.format(updateTime));
    	HashMap<String, Object> row = da.getUserRecordSymptomDataByDayLocal(dayLocal);
    	m_alreadyExistDataRow = (row!=null);
    	
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
        	m_nutrientIds = Tool.convertToStringArray(m_nutrientIdList);
    	}
    	
    	m_nutrientInfoDict2Level = GlobalVar.getAllNutrient2LevelDict(this);
    	
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
    	
    	if (!m_alreadyExistDataRow){
    		save();
    	}
    }
    
    void show(){
		String bmiStr = String.format("%3.1f", m_BMI);
		bmiTextView.setText(bmiStr);
		  
		healthTextView.setText(String.valueOf(m_HealthMark));
		
		nutrientFoodAdapter = new NutrientFoodAdapter();
		elementFoodListView.setAdapter(nutrientFoodAdapter);
		
//		diseaseAttentionAdapter = new DiseaseAttentionAdapter();
//		diseaseAttentionListView.setAdapter(diseaseAttentionAdapter);
		
		IllnessAdapter IllnessAdapter1 = new IllnessAdapter();
		m_lvehIllness.setAdapter(IllnessAdapter1);
		SuggestionAdapter SuggestionAdapter1 = new SuggestionAdapter();
		m_lvehSuggestion.setAdapter(SuggestionAdapter1);
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
//    	Calendar calendarNow = Calendar.getInstance();
//    	int year = calendarNow.get(Calendar.YEAR);    //获取年
//    	int month = calendarNow.get(Calendar.MONTH) + 1; 
    	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
    	Date updateTime = new Date();
		int dayLocal = Integer.parseInt(sdf.format(updateTime));
		
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
            
            ArrayList<HashMap<String, Object>> nutrientFoods = m_FoodsByNutrient.get(nutrientId);
            
            
            TextView elementTextView = (TextView) convertView.findViewById(R.id.nutrientTextView);
            elementTextView.setText(nutrientCaption);

            LinearLayout recommendViewPager = (LinearLayout) convertView.findViewById(R.id.recommendViewPager);
            recommendViewPager.removeAllViews();
            if (nutrientFoods!=null && nutrientFoods.size()>0) {
                for(int i=0; i<nutrientFoods.size(); i++){
                	HashMap<String, Object> food = nutrientFoods.get(i);
                	String foodName = (String)food.get(Constants.COLUMN_NAME_CnCaption);
                	Double foodAmount = (Double)food.get(Constants.Key_Amount);
                	View viewPager = getLayoutInflater().inflate(R.layout.v3_recomment_food_cell, null);
                    TextView foodNameTextView = (TextView) viewPager.findViewById(R.id.foodNameTextView);
                    TextView foodCountTextView = (TextView) viewPager.findViewById(R.id.foodCountTextView);
                    ImageView ivFood = (ImageView) viewPager.findViewById(R.id.ivFood);
                    foodNameTextView.setText(foodName);
                    foodCountTextView.setText(foodAmount.intValue()+"g");
                    ivFood.setImageDrawable(Tool.getDrawableForFoodPic(getAssets(), (String)food.get(Constants.COLUMN_NAME_PicPath)));
                    recommendViewPager.addView(viewPager);
                }
            }

            return convertView;
        }

    }

//    class DiseaseAttentionAdapter extends BaseAdapter {
//
//        @Override
//        public int getCount() {
//            return m_illnessIdList==null?0:m_illnessIdList.size();
//        }
//
//        @Override
//        public Object getItem(int arg0) {
//            return m_illnessIdList.get(arg0);
//        }
//
//        @Override
//        public long getItemId(int position) {
//            return position;
//        }
//
//        @Override
//        public View getView(int position, View convertView, ViewGroup parent) {
//            if (convertView == null) {
//                convertView = getLayoutInflater().inflate(R.layout.v3_disease_cell, null);
//            }
//            String illnessId = m_illnessIdList.get(position);
//            HashMap<String, Object> illnessInfo = m_illnessInfoDict2Level.get(illnessId);
//            ArrayList<HashMap<String, Object>> illnessSuggestions = m_suggestionsByIllnessHm.get(illnessId);
//            String illnessName = (String)illnessInfo.get(Constants.COLUMN_NAME_IllnessNameCn);
//            
//            TextView diseaseTextView = (TextView) convertView.findViewById(R.id.diseaseTextView);
//            diseaseTextView.setText(illnessName);
//
//            attentionLinearLayout = (LinearLayout) convertView.findViewById(R.id.attentionLinearLayout);
//            attentionLinearLayout.removeAllViews();
//
//            if (illnessSuggestions!=null) {
//            	for(int i=0; i<illnessSuggestions.size(); i++){
//            		HashMap<String, Object> illnessSuggestion = illnessSuggestions.get(i);
//            		String suggestionName = (String)illnessSuggestion.get(Constants.COLUMN_NAME_SuggestionCn);
//            		View view = getLayoutInflater().inflate(R.layout.v3_attention_cell, null);
//                    TextView attentionTextView = (TextView) view.findViewById(R.id.attentionTextView);
//                    attentionTextView.setText(suggestionName);
//                    attentionLinearLayout.addView(view);
//            	}
//            }
//
//            return convertView;
//        }
//
//    }
    
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
            
            String illnessId = m_illnessIdList.get(position);
            HashMap<String, Object> illnessInfo = m_illnessInfoDict2Level.get(illnessId);
            
            String illnessName = (String)illnessInfo.get(Constants.COLUMN_NAME_IllnessNameCn);
            
            tvIllness.setText(illnessName);

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
            
            String suggestionId = m_suggestionDistinctIdList.get(position);
            HashMap<String, Object> suggestionInfo = m_suggestionInfoDict2Level.get(suggestionId);
            
            String suggestionTxt = (String)suggestionInfo.get(Constants.COLUMN_NAME_SuggestionCn);
            
            tvSuggestion.setText(suggestionTxt);

            return convertView;
        }

    }

}
