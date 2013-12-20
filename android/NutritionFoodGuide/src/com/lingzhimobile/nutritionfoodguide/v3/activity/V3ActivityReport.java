package com.lingzhimobile.nutritionfoodguide.v3.activity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import android.R.integer;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Pair;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.lingzhimobile.nutritionfoodguide.Constants;
import com.lingzhimobile.nutritionfoodguide.DataAccess;
import com.lingzhimobile.nutritionfoodguide.NutritionTool;
import com.lingzhimobile.nutritionfoodguide.R;
import com.lingzhimobile.nutritionfoodguide.RecommendFood;
import com.lingzhimobile.nutritionfoodguide.StoredConfigTool;
import com.lingzhimobile.nutritionfoodguide.Tool;
import com.lingzhimobile.nutritionfoodguide.test.TestCaseRecommendFood;

public class V3ActivityReport extends V3BaseActivity {
	
	final static int c_nutrientFoodCountLimit = 5;

    // widgets
    ListView elementFoodListView;
    ListView diseaseAttentionListView;
    LinearLayout attentionLinearLayout;
    
    TextView bmiTextView, healthTextView;


    
    ArrayList<String> m_SymptomIdList;
    String[] m_symptomIds;
    double m_BodyTemperature, m_Weight;
    int m_HeartRate, m_BloodPressureLow, m_BloodPressureHigh;
    HashMap<String, Object> m_measureHm;
    
    HashMap<String, Double> m_DRIsDict;
    HashMap<String, HashMap<String, Object>> m_nutrientInfoDict2Level;
    
    
    double m_BMI, m_HealthMark;
    ArrayList<String> m_nutrientIdList;
    String[] m_nutrientIds;
    HashMap<String, ArrayList<HashMap<String, Object>>> m_FoodsByNutrient;
    ArrayList<String> m_illnessIdList ;
    HashMap<String, HashMap<String, Object>> m_illnessInfoDict2Level;
    HashMap<String, ArrayList<HashMap<String, Object>>> m_suggestionsByIllnessHm;

//    List<String> nutrientList = new ArrayList<String>();
//    List<List<Pair<String, Double>>> recommendFoodList = new ArrayList<List<Pair<String, Double>>>();

//    List<String> diseaseList = new ArrayList<String>();
//    List<List<String>> attentionList = new ArrayList<List<String>>();

    NutrientFoodAdapter nutrientFoodAdapter;
    DiseaseAttentionAdapter diseaseAttentionAdapter;
    

    DataAccess da;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.v3_activity_report);
        
        da = DataAccess.getSingleton(this);
        
        getInputParams();
        calculate();
        show();
        
//        GetNutrientFoodTask getNutrientFoodTask = new GetNutrientFoodTask();
//        getNutrientFoodTask.execute();
//
//        GetDiseaseAttentionTask getDiseaseAttentionTask = new GetDiseaseAttentionTask();
//        getDiseaseAttentionTask.execute();

    }
    
    void getInputParams(){
    	Intent intent = getIntent();
        m_SymptomIdList = intent.getStringArrayListExtra(Constants.COLUMN_NAME_SymptomId);
        m_symptomIds = Tool.convertToStringArray(m_SymptomIdList);
        
        m_BodyTemperature = intent.getDoubleExtra(Constants.Key_BodyTemperature,0);
        m_Weight = intent.getDoubleExtra(Constants.Key_Weight,0);
        m_HeartRate = intent.getIntExtra(Constants.Key_HeartRate, 0);
        m_BloodPressureLow = intent.getIntExtra(Constants.Key_BloodPressureLow, 0);
        m_BloodPressureHigh = intent.getIntExtra(Constants.Key_BloodPressureHigh, 0);
        m_measureHm = new HashMap<String, Object>();
        m_measureHm.put(Constants.Key_BodyTemperature, m_BodyTemperature);
        m_measureHm.put(Constants.Key_Weight, m_Weight);
        m_measureHm.put(Constants.Key_HeartRate, m_HeartRate);
        m_measureHm.put(Constants.Key_BloodPressureLow, m_BloodPressureLow);
        m_measureHm.put(Constants.Key_BloodPressureHigh, m_BloodPressureHigh);
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
    	
    	m_nutrientIdList = da.getSymptomNutrientIdsWithDisplaySort_BySymptomIds(m_SymptomIdList);
    	m_nutrientIds = Tool.convertToStringArray(m_nutrientIdList);
    	m_nutrientInfoDict2Level = da.getNutrientInfoAs2LevelDictionary_withNutrientIds(m_nutrientIds);
    	
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
    	if (m_illnessIdList != null ){
    		ArrayList<HashMap<String, Object>> illnessRows = da.getIllness_ByIllnessIds(m_illnessIdList);
    		m_illnessInfoDict2Level = Tool.dictionaryArrayTo2LevelDictionary_withKeyName(Constants.COLUMN_NAME_IllnessId,illnessRows);
    		
    		m_suggestionsByIllnessHm = new HashMap<String, ArrayList<HashMap<String,Object>>>();
    		for(int i=0; i<m_illnessIdList.size(); i++){
    			String illnessId = m_illnessIdList.get(i);
    			ArrayList<HashMap<String, Object>> illnessSuggestions = da.getIllnessSuggestions_ByIllnessId(illnessId);
    			m_suggestionsByIllnessHm.put(illnessId, illnessSuggestions);
    		}
    	}
    }
    
    void show(){
		bmiTextView = (TextView) findViewById(R.id.bmiTextView);
		String bmiStr = String.format("%3.1f", m_BMI);
		bmiTextView.setText(bmiStr);
		  
		healthTextView = (TextView) findViewById(R.id.healthTextView);
		healthTextView.setText(String.valueOf(m_HealthMark));
		
		elementFoodListView = (ListView) findViewById(R.id.elementFoodListView);
		nutrientFoodAdapter = new NutrientFoodAdapter();
		elementFoodListView.setAdapter(nutrientFoodAdapter);
		
		diseaseAttentionListView = (ListView) findViewById(R.id.diseaseAttentionListView);
		diseaseAttentionAdapter = new DiseaseAttentionAdapter();
		diseaseAttentionListView.setAdapter(diseaseAttentionAdapter);
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
            diseaseAttentionAdapter.notifyDataSetChanged();
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

    class DiseaseAttentionAdapter extends BaseAdapter {

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
                convertView = getLayoutInflater().inflate(R.layout.v3_disease_cell, null);
            }
            String illnessId = m_illnessIdList.get(position);
            HashMap<String, Object> illnessInfo = m_illnessInfoDict2Level.get(illnessId);
            ArrayList<HashMap<String, Object>> illnessSuggestions = m_suggestionsByIllnessHm.get(illnessId);
            String illnessName = (String)illnessInfo.get(Constants.COLUMN_NAME_IllnessNameCn);
            
            TextView diseaseTextView = (TextView) convertView.findViewById(R.id.diseaseTextView);
            diseaseTextView.setText(illnessName);

            attentionLinearLayout = (LinearLayout) convertView.findViewById(R.id.attentionLinearLayout);
            attentionLinearLayout.removeAllViews();

            if (illnessSuggestions!=null) {
            	for(int i=0; i<illnessSuggestions.size(); i++){
            		HashMap<String, Object> illnessSuggestion = illnessSuggestions.get(i);
            		String suggestionName = (String)illnessSuggestion.get(Constants.COLUMN_NAME_SuggestionCn);
            		View view = getLayoutInflater().inflate(R.layout.v3_attention_cell, null);
                    TextView attentionTextView = (TextView) view.findViewById(R.id.attentionTextView);
                    attentionTextView.setText(suggestionName);
                    attentionLinearLayout.addView(view);
            	}
            }

            return convertView;
        }

    }

}
