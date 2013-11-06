package com.lingzhimobile.nutritionfoodguide;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

import org.apache.commons.lang3.StringUtils;


import com.lingzhimobile.nutritionfoodguide.ActivityFoodByClass.ListAdapterForFood;
import com.lingzhimobile.nutritionfoodguide.ActivityFoodCombination.ExpandableListAdapter_FoodNutrition.OnClickListenerToAddFoodByNutrient;
import com.lingzhimobile.nutritionfoodguide.ActivityFoodCombination.ExpandableListAdapter_FoodNutrition.OnClickListenerToEditFoodAmount;
import com.lingzhimobile.nutritionfoodguide.ActivityFoodCombination.ExpandableListAdapter_FoodNutrition.OnClickListenerToShowNutrientDescription;
import com.lingzhimobile.nutritionfoodguide.ActivityFoodCombinationList.FoodCombinationAdapter.OnClickListenerToDeleteRow;
import com.lingzhimobile.nutritionfoodguide.DialogHelperSimpleInput.InterfaceWhenConfirmInput;
import com.lingzhimobile.nutritionfoodguide.OnClickListenerInExpandListItem.Data2LevelPosition;
import com.umeng.analytics.MobclickAgent;



import android.R.integer;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.database.DataSetObserver;
import android.graphics.Color;
import android.graphics.PorterDuff.Mode;
import android.graphics.drawable.ClipDrawable;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.LayerDrawable;
import android.graphics.drawable.ShapeDrawable;
import android.graphics.drawable.shapes.RoundRectShape;

import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import android.os.DropBoxManager.Entry;
import android.os.Handler;
import android.os.Message;
import android.support.v4.widget.SimpleCursorAdapter.ViewBinder;
import android.text.InputType;
import android.util.*;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.*;
import android.widget.LinearLayout.LayoutParams;
import android.widget.ExpandableListView.*;


public class ActivityDiagnoseResult extends ActivityBase {
	static final String LogTag = "ActivityDiagnoseResult";
	
	public static final int IntentResultCode = 1000;
	
	static final String[] GroupTitles = new String[]{"","您所选的症状","您体内严重缺乏的营养","您体内轻度缺乏的营养","您需要补充的食物","以上食物一天的营养比例",""};
	static final int GroupPos_mark = 0;
	static final int GroupPos_choose_disease = 1;
	static final int GroupPos_nutrient_badly = 2;
	static final int GroupPos_nutrient_slightlyly = 3;
	static final int GroupPos_food = 4;
	static final int GroupPos_nutrient_ratio = 5;
	
	
	String[] m_diseaseIds;
	ArrayList<String> m_diseaseIdList;
	String m_diseaseGroupNameAsId ;
	String[] m_nutrientIds_badlyLack,m_nutrientIds_slightlyLack, m_nutrientIds_all;
	int m_healthMark;


	HashMap<String, Double> m_foodAmountHm;
	ArrayList<String> m_OrderedFoodIdList ;
	HashMap<String, HashMap<String, Object>> m_foods2LevelHm ;
	
	ArrayList<HashMap<String, Object>> m_nutrientsData;
	HashMap<String, Object> m_paramsForCalculateNutritionSupply;
	HashMap<String, HashMap<String, Object>> m_nutrientInfoDict2Level;
	HashMap<String, Double> m_DRIsDict;
	
	Button m_btnCancel;

	
	ExpandableListView m_expandableListView1;
	
	BaseExpandableListAdapter m_ExpandableListAdapter;
	
	myProgressDialog m_prgressDialog;
	private AsyncTaskDoRecommend m_AsyncTaskDoRecommend;
	
	public Handler myHandler = new Handler() {

        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            if (m_prgressDialog!=null)
            	m_prgressDialog.dismiss();
            switch (msg.what) {
            case Constants.MessageID_OK:
//            	HashMap<String, Object> retDict =  (HashMap<String, Object>)msg.obj;
//
//            	HashMap<String, Double> recommendFoodAmountDict = (HashMap<String, Double>)retDict.get(Constants.Key_recommendFoodAmountDict);
//        	    HashMap<String, HashMap<String, Object>> preChooseFoodInfoDict = (HashMap<String, HashMap<String, Object>>)retDict.get(Constants.Key_preChooseFoodInfoDict);
//        	    if (recommendFoodAmountDict != null && recommendFoodAmountDict.size()>0 ){
//        	    	m_foodAmountHm.putAll(recommendFoodAmountDict);
//            	    m_foods2LevelHm.putAll(preChooseFoodInfoDict);
//            	    DataAccess da  = DataAccess.getSingleton(ActivityFoodCombination.this);
//            	    m_OrderedFoodIdList = da.getOrderedFoodIds(m_foodAmountHm);
//
//            	    reCalculateFoodSupplyNutrient();
//            		mListAdapter.notifyDataSetChanged();
//        	    }else{
//        	    	Tool.ShowMessageByDialog(ActivityFoodCombination.this, R.string.alreadyChooseEnoughFoodAndNeedToDelete);
//        	    }
        	    
            	HashMap<String, Object> retDict =  (HashMap<String, Object>)msg.obj;
            	HashMap<String, Double> recommendFoodAmountDict = (HashMap<String, Double>)retDict.get(Constants.Key_recommendFoodAmountDict);
        	    HashMap<String, HashMap<String, Object>> preChooseFoodInfoDict = (HashMap<String, HashMap<String, Object>>)retDict.get(Constants.Key_preChooseFoodInfoDict);
        	    HashMap<String, Double> DRIsDict = (HashMap<String, Double>)retDict.get(Constants.Key_DRI);
        	    m_DRIsDict = DRIsDict;
            	m_foodAmountHm = recommendFoodAmountDict;
        	    m_foods2LevelHm = preChooseFoodInfoDict;
        	    DataAccess da  = DataAccess.getSingleton(ActivityDiagnoseResult.this);
        	    m_OrderedFoodIdList = da.getOrderedFoodIds(m_foodAmountHm);

        	    HashMap<String, Object> params2 = new HashMap<String, Object>();
//        	    params2.put(Constants.Key_userInfo, userInfo);
        	    params2.put(Constants.Key_DRI, DRIsDict);
        	    params2.put("staticFoodAttrsDict2Level", m_foods2LevelHm);
        	    params2.put("staticFoodAmountDict", m_foodAmountHm);
        	    RecommendFood rf = new RecommendFood(ActivityDiagnoseResult.this);
        	    m_nutrientsData = rf.calculateGiveStaticFoodsDynamicFoodSupplyNutrientAndFormatForUI(params2);
        	    
        	    m_paramsForCalculateNutritionSupply = params2;
        	    
        	    m_ExpandableListAdapter.notifyDataSetChanged();
        	    
                break;
            }
        }
    };
    


	
	
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
        setContentView(R.layout.activity_diagnose_result);
        
        Intent paramIntent = getIntent();
//        Log.d(LogTag, "onCreate paramIntent="+paramIntent);
      
        initViewHandles();
        initViewsContent();
        setViewEventHandlers();
        setViewsContent();
    }
	
	void initViewHandles(){
		Button btnTopRight = (Button) findViewById(R.id.btnTopRight);
		btnTopRight.setVisibility(View.GONE);
        
        m_btnCancel = (Button) findViewById(R.id.btnCancel);
        m_expandableListView1 = (ExpandableListView)this.findViewById(R.id.expandableListView1);
        

	}
	void initViewsContent(){
		Intent paramIntent = getIntent();
		m_diseaseIds =  paramIntent.getStringArrayExtra(ActivityDiagnose.IntentParamKey_DiseaseIds);
		m_diseaseIdList = Tool.convertFromArrayToList(m_diseaseIds);
		m_diseaseGroupNameAsId = paramIntent.getStringExtra(Constants.COLUMN_NAME_DiseaseGroup);
		
        String prevActvTitle = paramIntent.getStringExtra(Constants.IntentParamKey_BackButtonTitle);
        if (prevActvTitle!=null)
        	m_btnCancel.setText(prevActvTitle);
        
        m_currentTitle = getResources().getString(R.string.diagnoseResult);
        TextView tvTitle = (TextView) findViewById(R.id.tvTitle);
        tvTitle.setText(m_currentTitle);
        
        DataAccess da = DataAccess.getSingleton(this);
        HashMap<String, ArrayList<HashMap<String, Object>>> diseaseNutrientInfosByDiseaseDict = da.getDiseaseNutrientRows_ByDiseaseIds(m_diseaseIdList, m_diseaseGroupNameAsId);
        HashSet<String> set_nutrientIds_badlyLack = new HashSet<String>();
        HashSet<String> set_nutrientIds_slightlyLack = new HashSet<String>();
        HashMap<String, Integer> nutrientMarkHm = new HashMap<String, Integer>();
        
        for(int i=0; i<m_diseaseIds.length; i++){
        	String diseaseId = m_diseaseIds[i];
        	ArrayList<HashMap<String, Object>> diseaseNutrientInfos = diseaseNutrientInfosByDiseaseDict.get(diseaseId);
        	if (diseaseNutrientInfos != null){
        		for(int j=0; j<diseaseNutrientInfos.size(); j++){
        			HashMap<String, Object> diseaseNutrientInfo = diseaseNutrientInfos.get(j);
        			String nutrientId = (String)diseaseNutrientInfo.get(Constants.COLUMN_NAME_NutrientID);
        			int lackLevelMark =((Double)diseaseNutrientInfo.get(Constants.COLUMN_NAME_LackLevelMark)).intValue();

        			if (lackLevelMark<=3){
        				set_nutrientIds_slightlyLack.add(nutrientId);
        			}else{
        				set_nutrientIds_badlyLack.add(nutrientId);
        			}
        			
        			int oldVal = Tool.getIntFromDictionaryItem_withDictionary(nutrientMarkHm, nutrientId);
        			if (oldVal<lackLevelMark){
        				nutrientMarkHm.put(nutrientId, Integer.valueOf(lackLevelMark));
        			}
            	}//for j
        	}
        }//for i
        int lackLevelMarkSum = 0;

        Iterator<Map.Entry<String,Integer>> iter = nutrientMarkHm.entrySet().iterator();
        while (iter.hasNext()) {
        	Map.Entry<String,Integer> entry = iter.next();
        	String key = entry.getKey();
        	Integer val = entry.getValue();
        	lackLevelMarkSum += val;
        }
        m_healthMark = 100-lackLevelMarkSum;

        m_nutrientIds_badlyLack = set_nutrientIds_badlyLack.toArray(new String[set_nutrientIds_badlyLack.size()]);
        
//        m_nutrientIds_badlyLack
        HashSet<String> set_nutrientIds_slightlyLack_only = (HashSet<String>) set_nutrientIds_slightlyLack.clone();
        set_nutrientIds_slightlyLack_only.removeAll(set_nutrientIds_badlyLack);
        m_nutrientIds_slightlyLack = set_nutrientIds_slightlyLack_only.toArray(new String[set_nutrientIds_slightlyLack_only.size()]);
        HashSet<String> set_nutrientIds_all = new HashSet<String>();
        set_nutrientIds_all.addAll(set_nutrientIds_badlyLack);
        set_nutrientIds_all.addAll(set_nutrientIds_slightlyLack);
        m_nutrientIds_all = set_nutrientIds_all.toArray(new String[set_nutrientIds_all.size()]);
        
        String[] nutrientIdsOrdered = NutritionTool.getFullAndOrderedNutrients();
        m_nutrientIds_badlyLack = Tool.arrayIntersectArray_withSrcArray(nutrientIdsOrdered,m_nutrientIds_badlyLack);
        m_nutrientIds_slightlyLack = Tool.arrayIntersectArray_withSrcArray(nutrientIdsOrdered,m_nutrientIds_slightlyLack);
        m_nutrientIds_all = Tool.arrayIntersectArray_withSrcArray(nutrientIdsOrdered,m_nutrientIds_all);
        
        m_nutrientInfoDict2Level = da.getNutrientInfoAs2LevelDictionary_withNutrientIds(null);
        
//        doRecommend();
        doRecommendAsync();
	}
	void setViewEventHandlers(){
        m_btnCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	finish();
            }
        });
 
	}
	void setViewsContent(){
       

        m_ExpandableListAdapter = new ExpandableListAdapter_DiagnoseResult(this);
        m_expandableListView1.setAdapter(m_ExpandableListAdapter);
        //设置ExpandableListView 默认是展开的
        for (int i = 0; i < GroupTitles.length; i++) {
        	m_expandableListView1.expandGroup(i);
        }
        m_expandableListView1.setOnGroupClickListener(new OnGroupClickListener(){
        	//使点击group的项目不做折叠动作
        	@Override
        	public boolean onGroupClick(ExpandableListView parent, View v, int groupPosition, long id) { 
        		return true;
       	    }
        });
        m_expandableListView1.setGroupIndicator(null);//去掉ExpandableListView 默认的组上的下拉箭头
	}
	

	

	
	
//	void doRecommend(){
//	    HashMap<String, Object> params = new HashMap<String, Object>();
//	    params.put(Constants.Key_givenNutrients, m_nutrientIds_all);
//	    
//	    HashMap<String, Object> userInfo = StoredConfigTool.getUserInfo(this);
//	    RecommendFood rf = new RecommendFood(this);
//	    HashMap<String, Object> retDict = rf.recommendFoodBySmallIncrementWithPreIntakeOut(null,userInfo,null,params);
//	    
//	    HashMap<String, Double> recommendFoodAmountDict = (HashMap<String, Double>)retDict.get(Constants.Key_recommendFoodAmountDict);
//	    HashMap<String, HashMap<String, Object>> preChooseFoodInfoDict = (HashMap<String, HashMap<String, Object>>)retDict.get(Constants.Key_preChooseFoodInfoDict);
//	    HashMap<String, Double> DRIsDict = (HashMap<String, Double>)retDict.get(Constants.Key_DRI);
//    	m_foodAmountHm = recommendFoodAmountDict;
//	    m_foods2LevelHm = preChooseFoodInfoDict;
//	    DataAccess da  = DataAccess.getSingleton(this);
//	    m_OrderedFoodIdList = da.getOrderedFoodIds(m_foodAmountHm);
//
//	    HashMap<String, Object> params2 = new HashMap<String, Object>();
//	    params2.put(Constants.Key_userInfo, userInfo);
//	    params2.put(Constants.Key_DRI, DRIsDict);
//	    params2.put("staticFoodAttrsDict2Level", m_foods2LevelHm);
//	    params2.put("staticFoodAmountDict", m_foodAmountHm);
//	    m_nutrientsData = rf.calculateGiveStaticFoodsDynamicFoodSupplyNutrientAndFormatForUI(params2);
//	    
//	    
//	    m_paramsForCalculateNutritionSupply = params2;
//	}
    
	
    void doRecommendAsync(){
    	HashMap<String, Object> params = new HashMap<String, Object>();
	    params.put(Constants.Key_givenNutrients, m_nutrientIds_all);
	    
	    HashMap<String, Object> userInfo = StoredConfigTool.getUserInfo(this);
	    
	    RecommendFood rf = new RecommendFood(this);
	    HashMap<String, Object> paramsRecommendForTask = new HashMap<String, Object>();
	    paramsRecommendForTask.put("RecommendFood", rf);
	    paramsRecommendForTask.put("userInfo", userInfo);
	    paramsRecommendForTask.put("params", params);
	    
	    m_AsyncTaskDoRecommend = new AsyncTaskDoRecommend(paramsRecommendForTask, myHandler.obtainMessage());
	    m_AsyncTaskDoRecommend.execute();
	    m_prgressDialog = myProgressDialog.show(this, null, R.string.calculating);
	}
    
    void reCalculateFoodSupplyNutrient(){
		
    }
    
    
    
    
	
	public class ExpandableListAdapter_DiagnoseResult extends BaseExpandableListAdapter
	{
		Activity m_actv;
		
		GridAdapter_Nutrients m_GridAdapter_Nutrients_badly;
		GridAdapter_Nutrients m_GridAdapter_Nutrients_slightly;
		
		public ExpandableListAdapter_DiagnoseResult(Activity actv){
			assert(actv!=null);
			m_actv = actv;
		}
		public void notifyDataSetChanged(){
			super.notifyDataSetChanged();
		}
		
	
		public Object getGroup(int groupPosition)
		{
			Object group = GroupTitles[groupPosition];
			return group;
		}
	
		public int getGroupCount()
		{
			return GroupTitles.length;
		}
	
		public long getGroupId(int groupPosition)
		{
			return groupPosition;
		}
	
		public boolean isChildSelectable(int groupPosition, int childPosition)
		{
			return true;
		}
	
		public boolean hasStableIds()
		{
			return true;
		}
		
		public View getGroupView(int groupPos, boolean isExpanded,	View convertView, ViewGroup parent)
		{
			View vwItem;
			if (groupPos==GroupPos_mark){
				vwItem = m_actv.getLayoutInflater().inflate(R.layout.grouprow_diagnose_result_empty, null);
			}else if (groupPos==GroupTitles.length-1){
				vwItem = m_actv.getLayoutInflater().inflate(R.layout.grouprow_diagnose_result_empty_with_height, null);
			}else if (groupPos==GroupPos_food){
				vwItem = m_actv.getLayoutInflater().inflate(R.layout.grouprow_diagnose_result_food, null);
				TextView textView = (TextView)vwItem.findViewById(R.id.textView1);
				textView.setText(GroupTitles[groupPos]);
				Button btnSave = (Button)vwItem.findViewById(R.id.btnSave);
				btnSave.setOnClickListener(new View.OnClickListener(){

					@Override
					public void onClick(View v) {
						
						Date dtNow = new Date();
            			SimpleDateFormat sdf = new SimpleDateFormat("MM月dd日");
            			String datePart = sdf.format(dtNow);
//            			DateFormat df = DateFormat.getDateInstance(DateFormat.SHORT);
//            			String datePart = df.format(dtNow);
            			
            			String collocationName = Tool.getStringFromIdWithParams(getResources(), R.string.defaultFoodCollocationName,new String[]{datePart});
            			
            			DialogHelperSimpleInput myDialogHelperSimpleInput = new DialogHelperSimpleInput(ActivityDiagnoseResult.this);
        				myDialogHelperSimpleInput.prepareDialogAttributes("保存食物清单", "给你的食物清单加个名称吧", collocationName);
        				myDialogHelperSimpleInput.setInterfaceWhenConfirmInput(new InterfaceWhenConfirmInput() {
        					@Override
        					public void onConfirmInput(String input) {
        						if (input==null || input.length()==0){
        							Tool.ShowMessageByDialog(ActivityDiagnoseResult.this, "输入不能为空");
        						}else{
        							String collocationName2 = input;
        							ArrayList<Object[]> foodAmount2LevelArray = ActivityFoodCombination.convertFoodAmountHashmapToPairList(m_foodAmountHm);
        							DataAccess da = DataAccess.getSingleton();
        							da.insertFoodCollocationData_withCollocationName(collocationName2, foodAmount2LevelArray);
        							
        							AlertDialog.Builder dlgBuilder =new AlertDialog.Builder(ActivityDiagnoseResult.this);
        							dlgBuilder.setTitle("保存成功").setMessage("您可以进入清单页面查看你的保存结果");
        							dlgBuilder.setPositiveButton("去看看", new DialogInterface.OnClickListener() {
										
										@Override
										public void onClick(DialogInterface dialog, int which) {
											Intent intent = new Intent(ActivityDiagnoseResult.this, ActivityHome.class);
											intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
											intent.putExtra(Constants.IntentParamKey_DestinationActivity, ActivityFoodCombinationList.class.getName());
											startActivity(intent);
										}
									});
        							dlgBuilder.setNegativeButton("知道了", null);
        							
        							AlertDialog dlg = dlgBuilder.create();
        							dlg.show();
        							
        						}
        					}
        				});
        				myDialogHelperSimpleInput.show();
            			return;
					}
					
					
				});
			}else{
				vwItem = m_actv.getLayoutInflater().inflate(R.layout.expandablelist_groupitem, null);
				TextView textView = (TextView)vwItem.findViewById(R.id.textView1);
				textView.setText(GroupTitles[groupPos]);
			}
			return vwItem;
		}

		public Object getChild(int groupPos, int childPosition)
		{
			if (groupPos==0){
//				return m_foodsData.get(childPosition);
				return m_OrderedFoodIdList.get(childPosition);
			}else{
				return m_nutrientsData.get(childPosition);
			}
		}
	
		public long getChildId(int groupPosition, int childPosition)
		{
			return childPosition;
		}
		public int getChildrenCount(int groupPos)
		{
			if (groupPos==GroupPos_mark || groupPos==GroupPos_choose_disease || groupPos==GroupPos_nutrient_badly || groupPos==GroupPos_nutrient_slightlyly){
				return 1;
			}else if (groupPos == GroupPos_food){
				return m_OrderedFoodIdList==null?0:m_OrderedFoodIdList.size();
			}else if (groupPos == GroupPos_nutrient_ratio){
				return m_nutrientsData==null?0:m_nutrientsData.size();
			}
			return 0;
		}
	
		public View getChildView(int groupPosition, int childPosition, boolean isLastChild, View convertView, ViewGroup parent)
		{
			View vw = null;
			if (groupPosition==GroupPos_mark){
//				if (convertView instanceof TextView){
//					vw = convertView;
//				}else{
//					vw = new TextView(ActivityDiagnoseResult.this);
//				}
				vw = getLayoutInflater().inflate(R.layout.row_diagnose_result_mark, null);
				TextView tvMark = (TextView)vw.findViewById(R.id.tvMark);
				tvMark.setText(m_healthMark+"分");
				
				TextView tvComment = (TextView)vw.findViewById(R.id.tvComment);
				int commentStrResId = R.string.diseaseMarkComment_good;
				int markColorResId = R.color.diseaseMark_good;
				if (m_healthMark < 60){
					commentStrResId = R.string.diseaseMarkComment_bad ;
					markColorResId = R.color.diseaseMark_bad;
				}else if(m_healthMark < 90){
					commentStrResId = R.string.diseaseMarkComment_normal;
					markColorResId = R.color.diseaseMark_normal;
				}else{
					commentStrResId = R.string.diseaseMarkComment_good;
					markColorResId = R.color.diseaseMark_good;
				}
				tvComment.setText(getResources().getText(commentStrResId));
				tvMark.setTextColor(getResources().getColor(markColorResId));
				
			}else if (groupPosition==GroupPos_choose_disease){
				vw = getLayoutInflater().inflate(R.layout.row_diagnose_result_diseases, null);
				TextView tvDiseases = (TextView)vw.findViewById(R.id.tvDiseases);
				tvDiseases.setText(StringUtils.join(m_diseaseIds," ; "));
			}else if (groupPosition==GroupPos_nutrient_badly){
				vw = getLayoutInflater().inflate(R.layout.item_grid_nutrients, null);
				GridView gridView1 = (GridView)vw.findViewById(R.id.gridView1);
				
				if (m_GridAdapter_Nutrients_badly == null)
					m_GridAdapter_Nutrients_badly = new GridAdapter_Nutrients();
				m_GridAdapter_Nutrients_badly.initInputData(m_nutrientIds_badlyLack, true);
				
				gridView1.setAdapter(m_GridAdapter_Nutrients_badly);
				
			}else if (groupPosition==GroupPos_nutrient_slightlyly){
				vw = getLayoutInflater().inflate(R.layout.item_grid_nutrients, null);
				GridView gridView1 = (GridView)vw.findViewById(R.id.gridView1);
				
				if (m_GridAdapter_Nutrients_slightly == null)
					m_GridAdapter_Nutrients_slightly = new GridAdapter_Nutrients();
				m_GridAdapter_Nutrients_slightly.initInputData(m_nutrientIds_slightlyLack, false);
				
				gridView1.setAdapter(m_GridAdapter_Nutrients_slightly);
				
			}else if (groupPosition==GroupPos_food){
				boolean needNewView = false;
				TextView tvFoodName = null;
				if (convertView == null){
					needNewView = true;
				}else{
					tvFoodName = (TextView)convertView.findViewById(R.id.tvFoodName);
					if (tvFoodName == null){//注意不同group的row view不同
						needNewView = true;
					}
				}
				if (needNewView){
					convertView = m_actv.getLayoutInflater().inflate(R.layout.row_food_onlyshow, null);
				}

				if (tvFoodName == null) tvFoodName = (TextView)convertView.findViewById(R.id.tvFoodName);
				TextView tvFoodAmount = (TextView)convertView.findViewById(R.id.tvFoodAmount);
				String foodId = m_OrderedFoodIdList.get(childPosition);
//				HashMap<String, Object> foodInfo = m_foodsData.get(childPosition);
				HashMap<String, Object> foodInfo = m_foods2LevelHm.get(foodId);
				assert(foodInfo!=null);
//				Double foodAmount = m_foodAmountList.get(childPosition);
				Double foodAmount = m_foodAmountHm.get(foodId);
				tvFoodName.setText((String)foodInfo.get(Constants.COLUMN_NAME_CnCaption));
				tvFoodAmount.setText(foodAmount.intValue()+"");
//				tvFoodAmount.setBackground(null);
				
				ImageView ivFood = (ImageView)convertView.findViewById(R.id.ivFood);
				ivFood.setImageDrawable(Tool.getDrawableForFoodPic(getAssets(), (String)foodInfo.get(Constants.COLUMN_NAME_PicPath)));
				
				LinearLayout llRowFood = (LinearLayout)convertView.findViewById(R.id.llRowFood);
				
//				ImageButton imgBtnRemoveFood = (ImageButton)convertView.findViewById(R.id.imgBtnRemoveFood);
//				imgBtnRemoveFood.setVisibility(View.GONE);

				vw = convertView;
			}else if (groupPosition==GroupPos_nutrient_ratio){
				boolean needNewView = false;
				TextView tvSupplyPercent = null;
				if (convertView == null){
					needNewView = true;
				}else{
					tvSupplyPercent = (TextView)convertView.findViewById(R.id.tvSupplyPercent);
					if (tvSupplyPercent == null){
						needNewView = true;
					}
				}
				if (needNewView){
					convertView = m_actv.getLayoutInflater().inflate(R.layout.row_nutrient_onlyshow, null);
				}
				
				HashMap<String, Object> nutrientData = m_nutrientsData.get(childPosition);
				assert(nutrientData!=null);
				String nutrientId = (String)nutrientData.get(Constants.COLUMN_NAME_NutrientID);
				assert(nutrientId!=null);
				HashMap<String, Object> nutrientInfo = m_nutrientInfoDict2Level.get(nutrientId);
				
				Double dObj_supplyRate = (Double)nutrientData.get(Constants.Key_supplyNutrientRate);
				int supplyPercent = (int) Math.round( dObj_supplyRate.doubleValue() * 100 );
				TextView tvNutrient = (TextView)convertView.findViewById(R.id.tvNutrient);
				tvNutrient.setText((String)nutrientData.get(Constants.Key_Name));
				LinearLayout llNutrient = (LinearLayout)convertView.findViewById(R.id.llNutrient);
				
//				OnClickListenerToShowNutrientDescription myOnClickListenerToShowNutrientDescription = (OnClickListenerToShowNutrientDescription)llNutrient.getTag();
//				if (myOnClickListenerToShowNutrientDescription == null){
//					myOnClickListenerToShowNutrientDescription = new OnClickListenerToShowNutrientDescription();
//					myOnClickListenerToShowNutrientDescription.initInputData((String)nutrientInfo.get(Constants.COLUMN_NAME_NutrientDescription));
//					llNutrient.setOnClickListener(myOnClickListenerToShowNutrientDescription);
//					llNutrient.setTag(myOnClickListenerToShowNutrientDescription);
//				}else{
//					myOnClickListenerToShowNutrientDescription.initInputData((String)nutrientInfo.get(Constants.COLUMN_NAME_NutrientDescription));
//				}
				
				
				LinearLayout llProgress = (LinearLayout)convertView.findViewById(R.id.llProgress);
				ProgressBar pbSupplyPercent = (ProgressBar)convertView.findViewById(R.id.pbSupplyPercent);
				
				if (tvSupplyPercent==null) tvSupplyPercent = (TextView)convertView.findViewById(R.id.tvSupplyPercent);
				tvSupplyPercent.setText(supplyPercent+"%");

				
				HashMap<String, Integer> NutrientColorMapping1 = NutritionTool.getNutrientColorMapping();
				Integer colorResIdObj = NutrientColorMapping1.get(nutrientId);
				Log.d(LogTag, "getChildView nutrientId="+nutrientId+", colorResIdObj="+colorResIdObj);
				int colorResId = R.color.progressbarFg1stOld;
				if (colorResIdObj != null){
					colorResId = colorResIdObj;
				}
				changeProgressbarColors(ActivityDiagnoseResult.this,pbSupplyPercent,supplyPercent, colorResId);

				
				vw = convertView;
			}
			return vw;

		}
		

		
		class OnClickListenerToShowNutrientDescription implements View.OnClickListener{
			String m_nutrientDescription;
			
			public void initInputData(String nutrientDescription){
				m_nutrientDescription = nutrientDescription;
			}

			@Override
			public void onClick(View v) {
				new AlertDialog.Builder(ActivityDiagnoseResult.this).setMessage(m_nutrientDescription).setPositiveButton("OK", null).show();
				
			}
		}
		
		
		
		
		
	
	}//class ExpandableListAdapter_DiagnoseResult
	
	public static void changeProgressbarColors(Activity curActv, ProgressBar progBar, int progVal, int colorResIdFor1stProg){
		final float[] roundedCorners = new float[] { 5, 5, 5, 5, 5, 5, 5, 5 };
		ShapeDrawable ShapeDrawable1 = new ShapeDrawable(new RoundRectShape(roundedCorners, null,null));
//		ShapeDrawable1.getPaint().setColor(Color.parseColor("#FF0000"));
		ShapeDrawable1.getPaint().setColor(curActv.getResources().getColor(colorResIdFor1stProg));
		ClipDrawable ClipDrawable1 = new ClipDrawable(ShapeDrawable1, Gravity.LEFT, ClipDrawable.HORIZONTAL);
		progBar.setProgressDrawable(ClipDrawable1);  
//		progBar.setBackground(getResources().getDrawable( R.drawable.pink));//no round corner
//		progBar.setBackground(getResources().getDrawable( android.R.drawable.progress_horizontal));//have round corner, should be because progress_horizontal have round corner
		if (Tool.getVersionOfAndroidSDK() >= 16){//运行时获取Android API版本来判断
			progBar.setBackground(curActv.getResources().getDrawable( R.drawable.progressbar_colors_solid_layers));//android 2.3 not have this method
		}else{
			progBar.setBackgroundDrawable(curActv.getResources().getDrawable( R.drawable.progressbar_colors_solid_layers));//deprecated in API level 16.
		}
//		
		
		
//		//http://stackoverflow.com/questions/2020882/how-to-change-progress-bars-progress-color-in-android
//		final float[] roundedCorners = new float[] { 5, 5, 5, 5, 5, 5, 5, 5 };
//		ShapeDrawable ShapeDrawable1 = new ShapeDrawable(new RoundRectShape(roundedCorners, null,null));
//		ShapeDrawable1.getPaint().setColor(getResources().getColor(R.color.red));
//		ClipDrawable ClipDrawable1 = new ClipDrawable(ShapeDrawable1, Gravity.LEFT, ClipDrawable.HORIZONTAL);
////		GradientDrawable Drawable1 = new GradientDrawable(GradientDrawable.Orientation.LEFT_RIGHT, new int[]{0xff1e90ff,0xff006ab6,0xff367ba8});
////		ClipDrawable ClipDrawable1 = new ClipDrawable(Drawable1, Gravity.LEFT, ClipDrawable.HORIZONTAL);
////		Drawable[] progressDrawables = {new ColorDrawable(0xff0000ff), ClipDrawable1, ClipDrawable1};
//		Drawable[] progressDrawables = {new ColorDrawable(getResources().getColor(R.color.gray)), ClipDrawable1, ClipDrawable1};
//		LayerDrawable progressLayerDrawable = new LayerDrawable(progressDrawables);
//		progressLayerDrawable.setId(0, android.R.id.background);
//	    progressLayerDrawable.setId(1, android.R.id.secondaryProgress);
//	    progressLayerDrawable.setId(2, android.R.id.progress);
//	    progBar.setProgressDrawable(progressLayerDrawable);
		
		progBar.setProgress(0);//根据网上说法，在动态改变progressbar的颜色的时候，其本身有点小bug，这里是滚动页面后进度条的前景色就没了。需要改变progress值使其刷新
		progBar.setProgress(progVal);
	}
	
	class GridAdapter_Nutrients extends BaseAdapter{
		
		String[] m_nutrientIds;
		boolean m_isBadlyLack;
		
		public GridAdapter_Nutrients(){
			
		}
		
		public void initInputData(String[] nutrientIds, boolean isBadlyLack){
			m_nutrientIds = nutrientIds;
			m_isBadlyLack = isBadlyLack;
		}
		
		@Override
		public int getCount() {
			return m_nutrientIds==null? 0:m_nutrientIds.length ;
		}

		@Override
		public Object getItem(int pos) {
			return m_nutrientIds[pos];
		}

		@Override
		public long getItemId(int pos) {
			return pos;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			String nutrientId = m_nutrientIds[position];
			HashMap<String, Object> nutrientInfo = m_nutrientInfoDict2Level.get(nutrientId);
			
			View vw;
//			String iconTitle = (String)nutrientInfo.get(Constants.COLUMN_NAME_IconTitleCn);
//			String[] titleCnEnParts = Tool.splitNutrientTitleToCnEn(iconTitle);
//			
//			ImageView imageView1;
//			if (titleCnEnParts.length == 1){
//				vw = getLayoutInflater().inflate(R.layout.grid_cell_square_nutrient, null);
//				imageView1 = (ImageView)vw.findViewById(R.id.imageView1);
//				TextView tvCenter = (TextView)vw.findViewById(R.id.tvCenter);
//				tvCenter.setText(titleCnEnParts[0]);
//			}else{
//				vw = getLayoutInflater().inflate(R.layout.grid_cell_square_nutrient2item, null);
//				imageView1 = (ImageView)vw.findViewById(R.id.imageView1);
//				TextView tvUp = (TextView)vw.findViewById(R.id.tvUp);
//				TextView tvDown = (TextView)vw.findViewById(R.id.tvDown);
//				tvUp.setText(titleCnEnParts[0]);
//				tvDown.setText(titleCnEnParts[1]);
//			}
//			HashMap<String, Integer> NutrientColorMapping1 = NutritionTool.getNutrientColorMapping();
//			Integer colorResId = NutrientColorMapping1.get(nutrientId);
//			if (colorResId != null){
//				if (m_isBadlyLack){
//					imageView1.setImageResource(colorResId);
//				}else{
//					imageView1.setImageResource(colorResId);
//				}
//			}
			
			HashMap<String, Integer> hmNutrientToImageResId = ActivityNutrients.getNutrientToImageResIdMap();
			vw = getLayoutInflater().inflate(R.layout.grid_cell_square_image, null);
			ImageView imageView1 = (ImageView)vw.findViewById(R.id.imageView1);
			imageView1.setImageResource(hmNutrientToImageResId.get(nutrientId));
			
			OnClickListenerInGrid OnClickListenerInGrid1 = new OnClickListenerInGrid();
			OnClickListenerInGrid1.initInputData(nutrientId, nutrientInfo);
			imageView1.setOnClickListener(OnClickListenerInGrid1);
			
			return vw;
		}
		
		class OnClickListenerInGrid implements View.OnClickListener{
			String m_nutrientId;
			HashMap<String, Object> m_nutrientInfo;
			
			public void initInputData(String nutrientId, HashMap<String, Object> nutrientInfo){
				m_nutrientId = nutrientId;
				m_nutrientInfo = nutrientInfo;
			}

			@Override
			public void onClick(View v) {
				Intent intent = new Intent(ActivityDiagnoseResult.this, ActivityRichFood.class);
				intent.putExtra(Constants.IntentParamKey_BackButtonTitle, m_currentTitle);
				intent.putExtra(Constants.IntentParamKey_InvokerType, Constants.InvokerType_FromDiagnoseResultNutrients);
				intent.putExtra(Constants.COLUMN_NAME_NutrientID, m_nutrientId);
				intent.putExtra(Constants.Key_Amount, m_DRIsDict.get(m_nutrientId).doubleValue());
				intent.putExtra(Constants.Key_Name, (String)m_nutrientInfo.get(Constants.COLUMN_NAME_NutrientCnCaption));
				startActivity(intent);
				
			}
			
		}//class OnClickListenerInGrid

		
	}//class GridAdapter_Nutrients
    
}













