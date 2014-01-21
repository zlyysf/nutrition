package com.lingzhimobile.nutritionfoodguide.v3.activity;

import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Map.Entry;




import android.R.integer;
import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.text.InputType;
import android.util.Log;
import android.util.Pair;
import android.view.*;

import android.view.View.OnClickListener;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.*;


import com.lingzhimobile.nutritionfoodguide.*;
import com.umeng.analytics.MobclickAgent;

public class ActivityFoodNutrition extends V3BaseActivity {
	
	static final String LogTag = "ActivityFoodNutrition";

	String m_foodId;
	double m_foodAmount = 100;
	HashMap<String, Object> m_foodInfo;
	HashMap<String, Double> m_DRIsDict;
	HashMap<String, HashMap<String, Object>> m_nutrientInfoDict2Level;
	ArrayList<HashMap<String, Object>> m_nutrientsData;

	TextView m_tvTitle;
	Button m_btnBack;
	ScrollViewDebug m_scrollView1;
	TextView m_tvAmount;
	ListView m_listView1;
	
	public void onResume() {
		super.onResume();
		MobclickAgent.onResume(this);
	}
	public void onPause() {
		super.onPause();
		MobclickAgent.onPause(this);
	}

	@Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.v3_activity_foodnutrition);
        
        initViewHandles();
        initViewsContent();
        setViewEventHandlers();
        setViewsContent();
    }

	void initViewHandles(){
		m_tvTitle = (TextView) findViewById(R.id.titleText);
		Button rightButton = (Button) findViewById(R.id.rightButton);
    	rightButton.setVisibility(View.GONE);
    	m_btnBack = (Button) findViewById(R.id.leftButton);
    	
    	m_tvAmount = (TextView)findViewById(R.id.tvAmount);
		m_listView1 = (ListView)findViewById(R.id.listView1);
		
		m_scrollView1 = (ScrollViewDebug)findViewById(R.id.scrollView1);
	}
	void initViewsContent(){
		Intent paramIntent = getIntent();
		m_foodId =  paramIntent.getStringExtra(Constants.COLUMN_NAME_NDB_No);
		
		String prevActvTitle = paramIntent.getStringExtra(Constants.IntentParamKey_BackButtonTitle);
        if (prevActvTitle!=null)
        	m_btnBack.setText(prevActvTitle);
	}
	void setViewEventHandlers(){
		m_btnBack.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
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
		HashMap<String, HashMap<String, Object>> foodInfoDict2Level = GlobalVar.getAllFood2LevelDict(this);
		m_foodInfo = foodInfoDict2Level.get(m_foodId);
		
		String foodCaption = (String)m_foodInfo.get(Constants.COLUMN_NAME_CnCaption);

//		m_currentTitle = foodCaption;
		m_tvTitle.setText(foodCaption);
		
		
        
        DataAccess da = DataAccess.getSingleton(this);
        HashMap<String, Object> hmUserInfo = StoredConfigTool.getUserInfo(this);
    	m_DRIsDict = da.getStandardDRIs_withUserInfo(hmUserInfo, null);
    	
    	m_nutrientInfoDict2Level= GlobalVar.getAllNutrient2LevelDict(this);
    	
    	m_tvAmount.setText(Double.valueOf(m_foodAmount).intValue()+"");
    	reCalculateFoodSupplyNutrient();
    	
		ListAdapterForFoodNutrition adapter = new ListAdapterForFoodNutrition();
		m_listView1.setAdapter(adapter);
		
		m_scrollView1.scrollTo(0, 0);
	}
	
    void reCalculateFoodSupplyNutrient(){
		RecommendFood rf = new RecommendFood(this);
        HashMap<String, Object> userInfo = StoredConfigTool.getUserInfo(this);
	    HashMap<String, Object> params = new HashMap<String, Object>();
//	    params.put(Constants.Key_userInfo, userInfo);
	    params.put(Constants.Key_DRI, m_DRIsDict);
	    params.put("dynamicFoodAttrs", m_foodInfo);
	    params.put("dynamicFoodAmount", Double.valueOf(m_foodAmount));
//	    params.put("staticFoodAttrsDict2Level", m_foods2LevelHm);
//	    params.put("staticFoodAmountDict", m_foodAmountHm);
	    m_nutrientsData = rf.calculateGiveStaticFoodsDynamicFoodSupplyNutrientAndFormatForUI(params);
    }
    
	class ListAdapterForFoodNutrition extends BaseAdapter{
		public ListAdapterForFoodNutrition(){
			
		}
		public void notifyDataSetChanged(){
			notifyDataSetChanged();
		}
		@Override
		public int getCount() {
			return m_nutrientsData==null? 0 : m_nutrientsData.size();
		}

		@Override
		public HashMap<String, Object> getItem(int position) {
			return m_nutrientsData.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}
		
		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			if (convertView == null){
				convertView = getLayoutInflater().inflate(R.layout.v3_row_nutrient, null);
			}

			HashMap<String, Object> nutrientData = m_nutrientsData.get(position);
			String nutrientId = (String)nutrientData.get(Constants.COLUMN_NAME_NutrientID);
			HashMap<String, Object> nutrientInfo = m_nutrientInfoDict2Level.get(nutrientId);
			String nutrientCaption = (String)nutrientInfo.get(Constants.COLUMN_NAME_IconTitleCn);
			
			Double dObj_supplyRate = (Double)nutrientData.get(Constants.Key_supplyNutrientRate);
			int supplyPercent = (int) Math.round( dObj_supplyRate.doubleValue() * 100 );
			Double dObj_nutrientTotalDRI = (Double)nutrientData.get(Constants.Key_nutrientTotalDRI);
			String enUnit = (String)nutrientData.get(Constants.Key_Unit);
			
			TextView tvNutrient = (TextView)convertView.findViewById(R.id.tvNutrient);
			String[] cnenParts = Tool.splitNutrientTitleToCnEn(nutrientCaption);
			tvNutrient.setText(cnenParts[cnenParts.length-1]);
//			LinearLayout llNutrient = (LinearLayout)convertView.findViewById(R.id.llNutrient);
			
//			LinearLayout llProgress = (LinearLayout)convertView.findViewById(R.id.llProgress);
			ProgressBar pbSupplyPercent = (ProgressBar)convertView.findViewById(R.id.pbSupplyPercent);

			TextView tvSupplyPercent = (TextView)convertView.findViewById(R.id.tvSupplyPercent);
			String sSupply = supplyPercent+"%" + "/" +dObj_nutrientTotalDRI.intValue() +enUnit;
			tvSupplyPercent.setText(sSupply);
			pbSupplyPercent.setProgress(supplyPercent);

			HashMap<String, Integer> NutrientColorMapping1 = NutritionTool.getNutrientColorMapping();
			Integer colorResIdObj = NutrientColorMapping1.get(nutrientId);
			int colorResId = R.color.progressbarFg1stOld;
			if (colorResIdObj != null){
				colorResId = colorResIdObj;
			}
			ActivityDiagnoseResult.changeProgressbarColors(ActivityFoodNutrition.this,pbSupplyPercent,supplyPercent, colorResId);

			return convertView;
		}


	}//ListAdapter
    

}
