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
import android.view.View.OnFocusChangeListener;
import android.view.View.OnTouchListener;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.*;
import android.widget.RadioGroup.OnCheckedChangeListener;


import com.lingzhimobile.nutritionfoodguide.*;

import com.lingzhimobile.nutritionfoodguide.DialogHelperSimpleInput.InterfaceWhenConfirmInput;
import com.lingzhimobile.nutritionfoodguide.v3.activity.V3ActivityFoodsByType.*;
import com.umeng.analytics.MobclickAgent;

public class V3ActivityFoodsByNutrient extends V3BaseActivity {
	
	static final String LogTag = "V3ActivityFoodsByNutrient";
	
	
	Button m_btnBack;
	TextView m_tvTitle;
	RadioGroup m_SegmentedRadioGroup1;
	RadioButton m_rbDescription, m_rbFoods;
	
//	ScrollViewDebug m_scrollView1;
	
	LinearLayout m_llFoods, m_llNutrientDescription;
	
	TextView m_tvNutrientFoods;
	GridView m_gridView1;
	
	WebView m_webView1;

//	String mInvokerType = null;
	String mNutrientId;
//	String mNutrientCnCaption;
	double mToSupplyNutrientAmount ;
	HashMap<String, Object> m_nutrientInfo;

	ArrayList<HashMap<String, Object>> m_foodsData;

	public void onResume() {
		Log.d(LogTag, "onResume");
		super.onResume();
		MobclickAgent.onResume(this);
	}
	public void onPause() {
		Log.d(LogTag, "onPause");
		super.onPause();
		MobclickAgent.onPause(this);
	}

	@Override
    protected void onCreate(Bundle savedInstanceState) {
		Log.d(LogTag, "onCreate");
        super.onCreate(savedInstanceState);
        setContentView(R.layout.v3_activity_foods_bynutrient);
        
        initViewHandles();
        initViewsContent();
        setViewEventHandlers();
        setViewsContent();
    }
	
    @Override
    protected void onDestroy() {
    	Log.d(LogTag, "onDestroy");
		//fix a warning . com.lingzhimobile.nutritionfoodguide.v3.activity.V3ActivityIllness has leaked IntentReceiver com.android.qualcomm.browsermanagement.BrowserManagement$1@41cd7790 that was originally registered here. Are you missing a call to unregisterReceiver()?
    	//android.app.IntentReceiverLeaked: Activity com.lingzhimobile.nutritionfoodguide.v3.activity.V3ActivityIllness has leaked IntentReceiver com.android.qualcomm.browsermanagement.BrowserManagement$1@41cd7790 that was originally registered here. Are you missing a call to unregisterReceiver()?
    	//solved by http://angrycode.cn/archives/476
    	m_webView1.destroy();
		super.onDestroy();
	}
    protected void onStart() {
		Log.d(LogTag, "onStart");
		super.onStop();
	}
    protected void onStop() {
		Log.d(LogTag, "onStop");
		super.onStop();
	}

    
	void initViewHandles(){
    	
    	m_tvTitle = (TextView) findViewById(R.id.titleText);
    	m_btnBack = (Button) findViewById(R.id.leftButton);
    	
    	m_SegmentedRadioGroup1 = (RadioGroup)findViewById(R.id.SegmentedRadioGroup1);
    	m_rbDescription = (RadioButton)findViewById(R.id.rbDescription);
    	m_rbFoods = (RadioButton)findViewById(R.id.rbFoods);
    	
    	m_llFoods = (LinearLayout)findViewById(R.id.llFoods);
        m_llNutrientDescription = (LinearLayout)findViewById(R.id.llNutrientDescription);
    	
//    	m_scrollView1 = (ScrollViewDebug)findViewById(R.id.scrollView1);
    	m_tvNutrientFoods = (TextView)findViewById(R.id.tvNutrientFoods);
        m_gridView1 = (GridView)findViewById(R.id.gridView1);

        
        m_webView1 = (WebView)findViewById(R.id.webView1);
        
	}
	void initViewsContent(){

		Intent paramIntent = getIntent();
        
        mNutrientId =  paramIntent.getStringExtra(Constants.COLUMN_NAME_NutrientID);
        mToSupplyNutrientAmount = paramIntent.getDoubleExtra(Constants.Key_Amount, 0);
//        mNutrientCnCaption = paramIntent.getStringExtra(Constants.Key_Name);
        String prevActvTitle = paramIntent.getStringExtra(Constants.IntentParamKey_BackButtonTitle);
        if (prevActvTitle!=null)
        	m_btnBack.setText(prevActvTitle);
        
        HashMap<String, HashMap<String, Object>> nutrientInfoDict2Level = GlobalVar.getAllNutrient2LevelDict(this);
        m_nutrientInfo = nutrientInfoDict2Level.get(mNutrientId);
        String nutrientCaption = (String)m_nutrientInfo.get(Constants.COLUMN_NAME_NutrientCnCaption);
        m_currentTitle = nutrientCaption;
        m_tvTitle.setText(m_currentTitle);
        
        String url = (String)m_nutrientInfo.get(Constants.COLUMN_NAME_UrlCn);
        Tool.setWebViewBasicHere(m_webView1);
        m_webView1.loadUrl(url);
        
        DataAccess da = DataAccess.getSingleton(this);
        m_foodsData = da.getRichNutritionFoodForNutrient(mNutrientId, mToSupplyNutrientAmount, false);
        
        String s1 = Tool.getStringFromIdWithParams(getResources(), R.string.v3_chooseRichFood,new String[]{nutrientCaption});
        m_tvNutrientFoods.setText(s1);
        
	}
	void setViewEventHandlers(){
		m_btnBack.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
                Log.d(LogTag, "done finish");
            }
        });

		m_SegmentedRadioGroup1.setOnCheckedChangeListener(new OnCheckedChangeListener() {
			@Override
			public void onCheckedChanged(RadioGroup group, int checkedId) {
//				int radioButtonId = group.getCheckedRadioButtonId();
//				RadioButton rb = (RadioButton)ActivityUserProfile.this.findViewById(radioButtonId);
				switchViews();
			}
		});
		
//		m_scrollView1.setOnClickListener(new View.OnClickListener() {
//			@Override
//			public void onClick(View v) {
//				m_scrollView1.mCanScroll = true;
//			}
//		});
	}
	void setViewsContent(){
		ListAdapterForFood_fromNutrient adapter = new ListAdapterForFood_fromNutrient(this,m_foodsData);
		m_gridView1.setAdapter(adapter);
		Tool.setGridViewFromTooHighToJustExpandHeight(m_gridView1);
		
//		m_scrollView1.getViewTreeObserver().addOnGlobalLayoutListener(new OnGlobalLayoutListener() {
//			@Override
//			public void onGlobalLayout() {
////				m_scrollView1.scrollTo(0, 0);
//			}
//		});
		
		
//		RichFoodAdapter adapter = new RichFoodAdapter();
//		m_listView1.setAdapter(adapter);
//		
//		if (Constants.InvokerType_FromNutrients.equals(mInvokerType) || Constants.InvokerType_FromDiagnoseResultNutrients.equals(mInvokerType)){
//			m_rbNutrientInfo.setChecked(true);
//		}else{
//			m_rbRichFood.setChecked(true);
//			m_llRightTab.setVisibility(View.GONE);
//		}
		
		m_rbFoods.setChecked(true);
		switchViews();

	}
	
	void switchViews(){
		if (m_rbDescription.isChecked()){
			m_llFoods.setVisibility(View.GONE);
			m_llNutrientDescription.setVisibility(View.VISIBLE);
		}else{
			m_llFoods.setVisibility(View.VISIBLE);
			m_llNutrientDescription.setVisibility(View.GONE);
		}
	}
	
    static class ListAdapterForFood_fromNutrient extends ListAdapterForFood{

		public ListAdapterForFood_fromNutrient(V3BaseActivity thisActivity, ArrayList<HashMap<String, Object>> foodsData) {
			super(thisActivity, foodsData);
		}
		
		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			Log.d(LogTag, "getView pos="+position+", convertView="+convertView);
			if (convertView == null){
				convertView = m_thisActivity.getLayoutInflater().inflate(R.layout.v3_grid_cell_square_food_amount, null);
			}
			View vwItem = convertView;
			
			HashMap<String, Object> foodInfo = getItem(position);
			
			TextView tvFood = (TextView)vwItem.findViewById(R.id.tvFood);
			tvFood.setText((String)foodInfo.get(Constants.COLUMN_NAME_CnCaption));
			
			TextView tvAmount = (TextView)vwItem.findViewById(R.id.tvAmount);
			Double amountObj = (Double)foodInfo.get(Constants.Key_Amount);
			String amountStr = String.format("%dg", amountObj.intValue());
			tvAmount.setText(amountStr);
			
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
    	
    }
}
