package com.lingzhimobile.nutritionfoodguide.v3.activity;

import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Map.Entry;


import org.json.JSONArray;
import org.json.JSONException;

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

public class V3ActivityFoodsByType extends V3BaseActivity {
	
	static final String LogTag = "V3ActivityFoodsByType";

	String mFoodCnType;
	ArrayList<HashMap<String, Object>> m_foodsData;

	TextView m_tvTitle;
	Button m_btnBack;
	GridView m_gridView1;

	
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
        setContentView(R.layout.v3_activity_foods_bytype);
        
        initViewHandles();
        initViewsContent();
        setViewEventHandlers();
        setViewsContent();
    }

	void initViewHandles(){
		Button rightButton = (Button) findViewById(R.id.rightButton);
    	rightButton.setVisibility(View.GONE);
    	m_btnBack = (Button) findViewById(R.id.leftButton);
    	m_tvTitle = (TextView) findViewById(R.id.titleText);
		m_gridView1 = (GridView)this.findViewById(R.id.gridView1);
	}
	void initViewsContent(){
		Intent paramIntent = getIntent();
        mFoodCnType =  paramIntent.getStringExtra(Constants.COLUMN_NAME_CnType);

//		m_currentTitle = mFoodCnType;
		m_tvTitle.setText(mFoodCnType);
        
        DataAccess da = DataAccess.getSingleton(this);
        m_foodsData = da.getFoodsByShowingPart(null,null,mFoodCnType);
        
	}
	void setViewEventHandlers(){
		m_btnBack.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
	}
	void setViewsContent(){
		ListAdapterForFood adapter = new ListAdapterForFood(this,m_foodsData);
		m_gridView1.setAdapter(adapter);
	}
    
	static class ListAdapterForFood extends BaseAdapter{
		Activity m_thisActivity;
		ArrayList<HashMap<String, Object>> m_foodsData;
		
		public ListAdapterForFood(Activity thisActivity, ArrayList<HashMap<String, Object>> foodsData){
			m_thisActivity = thisActivity;
			m_foodsData = foodsData;
		}
		public void setInputData(ArrayList<HashMap<String, Object>> foods){
			m_foodsData = foods;
			notifyDataSetChanged();
		}
		@Override
		public int getCount() {
			return m_foodsData==null? 0 : m_foodsData.size();
		}

		@Override
		public HashMap<String, Object> getItem(int position) {
			return m_foodsData.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}
		
		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			if (convertView == null){
				convertView = m_thisActivity.getLayoutInflater().inflate(R.layout.v3_grid_cell_square_food, null);
			}
			View vwItem = convertView;
			
			HashMap<String, Object> foodInfo = getItem(position);
			
			TextView textView1 = (TextView)vwItem.findViewById(R.id.textView1);
			textView1.setText((String)foodInfo.get(Constants.COLUMN_NAME_CnCaption));
			
			ImageView imageView1 = (ImageView)vwItem.findViewById(R.id.imageView1);
			imageView1.setImageDrawable(Tool.getDrawableForFoodPic(m_thisActivity.getAssets(), (String)foodInfo.get(Constants.COLUMN_NAME_PicPath)));
			
			OnClickListenerForInputFoodAmount myOnClickListenerForInputAmount = (OnClickListenerForInputFoodAmount)imageView1.getTag();
			if (myOnClickListenerForInputAmount == null){
				myOnClickListenerForInputAmount = new OnClickListenerForInputFoodAmount(m_thisActivity,this);
				myOnClickListenerForInputAmount.initInputData(position);
				imageView1.setOnClickListener(myOnClickListenerForInputAmount);
				imageView1.setTag(myOnClickListenerForInputAmount);
			}else{
				myOnClickListenerForInputAmount.initInputData(position);
			}
			
			return vwItem;
		}
		
		static class OnClickListenerForInputFoodAmount extends OnClickListenerInListItem{
			Activity m_thisActivity;
			BaseAdapter m_listAdapter;

			public OnClickListenerForInputFoodAmount(Activity thisActivity, BaseAdapter listAdapter){
				m_thisActivity = thisActivity;
				m_listAdapter = listAdapter;
			}

			@Override
			public void onClick(View v) {
				HashMap<String, Object> foodData = (HashMap<String, Object>)m_listAdapter.getItem(m_rowPos);
				String foodName = (String)foodData.get(Constants.COLUMN_NAME_CnCaption);
				String foodId = (String)foodData.get(Constants.COLUMN_NAME_NDB_No);
				Log.d(LogTag, "OnClickListenerForInputFoodAmount foodId="+foodId+", foodName="+foodName);
			}
		}//class OnClickListenerForInputFoodAmount
		
	}//ListAdapterForFood
    

}
