package com.lingzhimobile.nutritionfoodguide;

import java.io.IOException;
import java.util.*;

import com.lingzhimobile.nutritionfoodguide.ActivityRichFood.RichFoodAdapter.OnClickListenerForInputAmount.DialogInterfaceEventListener_EditText;


import android.R.integer;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.os.Bundle;
import android.util.*;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.*;
import android.widget.ExpandableListView.*;


public class ActivityFoodCombination extends Activity {
	
	public static final int IntentRequestCode_ActivityRichFood = 100;
	public static final int IntentRequestCode_ActivityAllFoodExpandList = 101;
	public static final int IntentRequestCode_ActivitySearchFoodCustom = 102;
	
	static final String LogTag = "ActivityFoodCombination";
	
	static final String[] GroupTitles = new String[]{"一天的食物","一天的营养比例"};
	
	
	HashMap<String, Double> m_foodAmountHm;
	ArrayList<String> m_OrderedFoodIdList ;
	HashMap<String, HashMap<String, Object>> m_foods2LevelHm ;
	
//	ArrayList<HashMap<String, Object>> m_foodsData;
//	ArrayList<String> m_foodIdList;
//	ArrayList<Double> m_foodAmountList;
	ArrayList<HashMap<String, Object>> m_nutrientsData;
	HashMap<String, Object> m_paramsForCalculateNutritionSupply;
	Button mBtnReset,m_btnCancel,m_btnAdd,m_btnShare,m_btnRecommend;
	
	ExpandableListView m_expandableListView1;
	
	ExpandableListAdapter_FoodNutrition mListAdapter;

	@Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_food_combination);
        initViewHandles();
        setViewEventHandlers();
        setViewsContent();

    }
	
	void initViewHandles(){
		mBtnReset = (Button) findViewById(R.id.btnReset);
        mBtnReset.setText(R.string.save);
        m_btnCancel = (Button) findViewById(R.id.btnCancel);
        m_btnAdd = (Button) findViewById(R.id.btnAdd);
        m_btnShare = (Button) findViewById(R.id.btnShare);
        m_btnRecommend = (Button) findViewById(R.id.btnRecommend);
        m_expandableListView1 = (ExpandableListView)this.findViewById(R.id.expandableListView1);
        
	}
	void setViewEventHandlers(){
        m_expandableListView1.setOnChildClickListener(new OnChildClickListener(){

			@Override
			public boolean onChildClick(ExpandableListView parent, View v, int groupPosition, int childPosition, long id) {
				Log.d(LogTag, "expandableListView1 onChildClick ["+groupPosition+","+childPosition+"]");//没有反应
				if (groupPosition==0){
					
				}else{
					HashMap<String, Double> DRIsDict = (HashMap<String, Double>)(m_paramsForCalculateNutritionSupply.get(Constants.Key_DRI));
					
					HashMap<String, Object> nutrientInfo = m_nutrientsData.get(childPosition);
					Intent intent = new Intent(ActivityFoodCombination.this, ActivityRichFood.class);
					String nutrientId = (String)nutrientInfo.get(Constants.COLUMN_NAME_NutrientID);
					intent.putExtra(Constants.COLUMN_NAME_NutrientID, nutrientId);
					intent.putExtra(Constants.Key_Amount, DRIsDict.get(nutrientId).toString());
					startActivity(intent);
				}
				
				return true;
			}
        });
        
        mBtnReset.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            }
        });
        m_btnCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	finish();
            }
        });
        m_btnAdd.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
				Intent intent = new Intent(ActivityFoodCombination.this, ActivityAllFoodExpandList.class);
				startActivityForResult(intent,IntentRequestCode_ActivityAllFoodExpandList);
            }
        });
        m_btnShare.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
				Intent intent = new Intent(ActivityFoodCombination.this, ActivitySearchFoodCustom.class);
				startActivityForResult(intent,IntentRequestCode_ActivitySearchFoodCustom);
            }
        });
        m_btnRecommend.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	showChooseNutrientsToRecommend();
            }
        });
	}
	void setViewsContent(){

        m_foodAmountHm = new HashMap<String, Double>();
        m_OrderedFoodIdList = new ArrayList<String>();
        m_foods2LevelHm = new HashMap<String, HashMap<String,Object>>();
//        m_foodsData = new ArrayList<HashMap<String, Object>>();
//        m_foodIdList = new ArrayList<String>();
//        m_foodAmountList = new ArrayList<Double>();
        
//        m_nutrientsData = new ArrayList<Object>();
        
        RecommendFood rf = new RecommendFood(this);
        HashMap<String, Object> userInfo = StoredConfigTool.getUserInfo(this);
	    HashMap<String, Object> params = new HashMap<String, Object>();
	    params.put(Constants.Key_userInfo, userInfo);
//	    params.put("dynamicFoodAttrs", dynamicFoodAttrs);
//	    params.put("dynamicFoodAmount", dObj_dynamicFoodAmount);
//	    params.put("staticFoodAttrsDict2Level", allFoodAttr2LevelDict);
//	    params.put("staticFoodAmountDict", staticFoodAmountDict);
	    m_nutrientsData = rf.calculateGiveStaticFoodsDynamicFoodSupplyNutrientAndFormatForUI(params);

	    m_paramsForCalculateNutritionSupply = params;
		
	    ExpandableListAdapter_FoodNutrition adapter = new ExpandableListAdapter_FoodNutrition(this);
        mListAdapter = adapter;
        m_expandableListView1.setAdapter(adapter);
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
	
	
	class DialogInterfaceEventListener_SelectNutrients implements DialogInterface.OnClickListener, DialogInterface.OnMultiChoiceClickListener{
		AlertDialog mAlertDialog;
		CheckBox m_cbSelectAll;
		String[] m_nutrientItems;
		boolean[] m_flagsForNutrients;
		public DialogInterfaceEventListener_SelectNutrients(CheckBox cbSelectAll, String[] nutrientItems, boolean[] flagsForNutrients){
			m_cbSelectAll = cbSelectAll;
			m_nutrientItems = nutrientItems;
			m_flagsForNutrients = flagsForNutrients;
		}
		public void SetDialog(AlertDialog dlg){
			mAlertDialog = dlg;

			m_cbSelectAll.setOnClickListener(new View.OnClickListener() {
				@Override
				public void onClick(View v) {
					boolean checked = m_cbSelectAll.isChecked();
					ListView lv = mAlertDialog.getListView();
					for(int i=0; i<m_nutrientItems.length; i++){
						m_flagsForNutrients[i] = checked;
						lv.setItemChecked(i, checked);
					}
					lv.invalidate();
				}
			});
		}
		
		
		//DialogInterface.OnClickListener
		@Override
		public void onClick(DialogInterface dlgInterface, int which) {
			if(which == DialogInterface.BUTTON_POSITIVE){
				Log.d(LogTag, "DialogInterfaceEventListener_SelectNutrients onClick OK");
				ListView lv = mAlertDialog.getListView();
				ArrayList<String> selNutrients = new ArrayList<String>();
				//看来使用 getCheckedItemPositions 不准确，当列表太长预置全选状态时就选不到未显示的一些条目
//				SparseBooleanArray selPosAry = lv.getCheckedItemPositions();
//				for(int i=0; i<m_nutrientItems.length; i++){
//					if (selPosAry.get(i)){
//						String selNutrient = m_nutrientItems[i];
//						selNutrients.add(selNutrient);
//					}
//				}
				for(int i=0; i<m_nutrientItems.length; i++){
					if (m_flagsForNutrients[i]){
						String selNutrient = m_nutrientItems[i];
						selNutrients.add(selNutrient);
					}
				}
				Log.d(LogTag, "selNutrients="+selNutrients);
				if (selNutrients.size()==0){
//					Toast toast1 = Toast.makeText(ActivityFoodCombination.this, "您必须至少选择一个", Toast.LENGTH_SHORT);
//					toast1.show();
					new AlertDialog.Builder(ActivityFoodCombination.this).setTitle("您必须至少选择一个").setPositiveButton("OK", null).show();
					
				}else{
					StoredConfigTool.saveNutrientsToRecommend(getApplicationContext(), selNutrients);
					
					doRecommend(selNutrients);
				}
				
			}else if(which == DialogInterface.BUTTON_NEGATIVE){
			}else if(which == DialogInterface.BUTTON_NEUTRAL){//忽略按键的点击事件
			}
			m_cbSelectAll = null;
			mAlertDialog = null;
		}
		
		//DialogInterface.OnMultiChoiceClickListener
		@Override
		public void onClick(DialogInterface dialog, int which, boolean isChecked) {
			Log.d(LogTag, "DialogInterface.OnMultiChoiceClickListener.onClick, which="+which+", isChecked="+isChecked);
			m_flagsForNutrients[which] = isChecked;
		}

	}//class DialogInterfaceEventListener_SelectNutrients
	
	void showChooseNutrientsToRecommend(){
		AlertDialog.Builder dlgBuilder =new AlertDialog.Builder(this);
		
		View vwDialogContent = getLayoutInflater().inflate(R.layout.dialog_customertitle_selectall, null);
		CheckBox cbSelectAll = (CheckBox)vwDialogContent.findViewById(R.id.cbSelectAll);
		boolean initialChecked = true;
		cbSelectAll.setChecked(initialChecked);

//		String[] nutrients = NutritionTool.getCustomNutrients(null);
//		boolean[] flagsForNutrients = Tool.generateArrayWithFillItem(initialChecked, nutrients.length);
		String[] prevSelNutrients = StoredConfigTool.getNutrientsToRecommend(this);
		String[] nutrients = NutritionTool.getCustomNutrients(null);
		boolean[] flagsForNutrients = Tool.generateContainFlags(nutrients, prevSelNutrients);
		
		DialogInterfaceEventListener_SelectNutrients diEventListener = new DialogInterfaceEventListener_SelectNutrients(cbSelectAll, nutrients, flagsForNutrients);
		dlgBuilder.setCustomTitle(vwDialogContent);
		//这里setMultiChoiceItems的第二个参数有讲究，如果传了值，则在程序中只用 dialogListview.setItemChecked 会导致没有效果，需要先设置 flagsForNutrients 的相应条目才行.参见下面的url和文字。
		//http://stackoverflow.com/questions/3608018/toggling-check-boxes-in-multichoice-alertdialog-in-android
		//One thing to watch for: you must specify "null" for the "checkedItems" parameter in your "setMultiChoiceItems" call -- otherwise the "setItemChecked" calls won't work as expected. It would end up using that array to store the checked state, and "setItemChecked" would'nt update it correctly, so everything would get confused. Odd, but true.
		//但是，就算不传值而是传 null 值，还是有问题----使用 getCheckedItemPositions 不准确，当列表太长预置全选状态时就选不到未显示的一些条目.
		//正确方式是，传有值，如flagsForNutrients，然后同步设置它的值。目前暂时没发现问题。
		dlgBuilder.setMultiChoiceItems(nutrients, flagsForNutrients, diEventListener);
//		dlgBuilder.setMultiChoiceItems(nutrients, null, diEventListener);
		
		dlgBuilder.setPositiveButton("OK", diEventListener);
		dlgBuilder.setNegativeButton("Cancel", diEventListener);
		
		AlertDialog dlg = dlgBuilder.create();
		
		diEventListener.SetDialog(dlg);
		dlg.show();
	}
	
	void doRecommend(ArrayList<String> selectedNutrients){
		HashMap<String, Object> userInfo = StoredConfigTool.getUserInfo(ActivityFoodCombination.this);
		
		HashMap<String, Double> takenFoodAmountDict = m_foodAmountHm;
	    

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
	    
	    HashMap<String, Object> params = new HashMap<String, Object>();
	    if (selectedNutrients!=null && selectedNutrients.size()>0)  params.put(Constants.Key_givenNutrients, Tool.convertToStringArray(selectedNutrients));
	    
	    RecommendFood rf = new RecommendFood(ActivityFoodCombination.this);
	    HashMap<String, Object> retDict = rf.recommendFoodBySmallIncrementWithPreIntakeOut(takenFoodAmountDict,userInfo,options,params);
	    

	    HashMap<String, Double> recommendFoodAmountDict = (HashMap<String, Double>)retDict.get(Constants.Key_recommendFoodAmountDict);
	    HashMap<String, HashMap<String, Object>> preChooseFoodInfoDict = (HashMap<String, HashMap<String, Object>>)retDict.get(Constants.Key_preChooseFoodInfoDict);
	    m_foodAmountHm.putAll(recommendFoodAmountDict);
	    m_foods2LevelHm.putAll(preChooseFoodInfoDict);
	    DataAccess da  = DataAccess.getSingleTon(ActivityFoodCombination.this);
	    m_OrderedFoodIdList = da.getOrderedFoodIds(m_foodAmountHm);

	    
	    reCalculateFoodSupplyNutrient();
		mListAdapter.notifyDataSetChanged();
	}
    
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data)
	{
		super.onActivityResult(requestCode, resultCode, data);
		switch (requestCode)
		{
			case IntentRequestCode_ActivityRichFood:
			case IntentRequestCode_ActivityAllFoodExpandList:
			case IntentRequestCode_ActivitySearchFoodCustom:
				switch (resultCode)
				{
					case ActivityRichFood.IntentResultCode:
					case ActivityAllFoodExpandList.IntentResultCode:
					case ActivitySearchFoodCustom.IntentResultCode:
						String foodId = data.getStringExtra(Constants.COLUMN_NAME_NDB_No);
						int foodAmount = data.getIntExtra(Constants.Key_Amount, 0);
						Log.d(LogTag, "onActivityResult foodId="+foodId+", foodAmount="+foodAmount);
						
//						m_foodIdList.add(foodId);//TODO check repeated food
//						m_foodAmountList.add(Double.valueOf(foodAmount));
						Tool.addDoubleToDictionaryItem(foodAmount, m_foodAmountHm, foodId);
						
						DataAccess da  = DataAccess.getSingleTon(ActivityFoodCombination.this);
						m_OrderedFoodIdList = da.getOrderedFoodIds(m_foodAmountHm);
						
						ArrayList<HashMap<String, Object>> foodInfoList = da.getFoodAttributesByIds(new String[]{foodId});

						assert(foodInfoList.size()==1);
//						m_foodsData.addAll(foodInfoList);
						m_foods2LevelHm.put(foodId, foodInfoList.get(0));
						
//						RecommendFood rf = new RecommendFood(this);
//				        HashMap<String, Object> userInfo = StoredConfigTool.getUserInfo(this);
//					    HashMap<String, Object> params = new HashMap<String, Object>();
////					    params.put(Constants.Key_userInfo, userInfo);
//					    params.put(Constants.Key_DRI, m_paramsForCalculateNutritionSupply.get(Constants.Key_DRI));
////					    params.put("dynamicFoodAttrs", dynamicFoodAttrs);
////					    params.put("dynamicFoodAmount", dObj_dynamicFoodAmount);
//					    params.put("staticFoodAttrsDict2Level", m_foods2LevelHm);
//					    params.put("staticFoodAmountDict", m_foodAmountHm);
//					    m_nutrientsData = rf.calculateGiveStaticFoodsDynamicFoodSupplyNutrientAndFormatForUI(params);
//					    m_paramsForCalculateNutritionSupply = params;
						reCalculateFoodSupplyNutrient();
						
						mListAdapter.notifyDataSetChanged();
						
//						ArrayList<String> foodIdList = data.getStringArrayListExtra(ActivityRichFood.IntentResultKey_foodIdCol);
//						ArrayList<String> foodAmountList = data.getStringArrayListExtra(ActivityRichFood.IntentResultKey_foodAmountCol);
//						Log.d(LogTag, "onActivityResult foodIdList="+foodIdList+", foodAmountList="+foodAmountList);
						
						break;

					default:
						break;
				}
				break;

			default:
				break;
		}
	}
    
    
    void reCalculateFoodSupplyNutrient(){
		RecommendFood rf = new RecommendFood(this);
        HashMap<String, Object> userInfo = StoredConfigTool.getUserInfo(this);
	    HashMap<String, Object> params = new HashMap<String, Object>();
//	    params.put(Constants.Key_userInfo, userInfo);
	    params.put(Constants.Key_DRI, m_paramsForCalculateNutritionSupply.get(Constants.Key_DRI));
//	    params.put("dynamicFoodAttrs", dynamicFoodAttrs);
//	    params.put("dynamicFoodAmount", dObj_dynamicFoodAmount);
	    params.put("staticFoodAttrsDict2Level", m_foods2LevelHm);
	    params.put("staticFoodAmountDict", m_foodAmountHm);
	    m_nutrientsData = rf.calculateGiveStaticFoodsDynamicFoodSupplyNutrientAndFormatForUI(params);
	    m_paramsForCalculateNutritionSupply = params;
    }
    
    
    
    
	
	public class ExpandableListAdapter_FoodNutrition extends BaseExpandableListAdapter
	{
		Activity m_actv;
		
		
		public ExpandableListAdapter_FoodNutrition(Activity actv){
			assert(actv!=null);
			m_actv = actv;
		}
		public void notifyDataSetChanged(){
			super.notifyDataSetChanged();
		}

		public Object getChild(int groupPosition, int childPosition)
		{
			if (groupPosition==0){
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
	

		public int getChildrenCount(int groupPosition)
		{
			if (groupPosition==0){
//				return m_foodsData.size();
				return m_OrderedFoodIdList.size();
			}else{
				return m_nutrientsData.size();
			}
		}
	
		public View getChildView(int groupPosition, int childPosition,
				boolean isLastChild, View convertView, ViewGroup parent)
		{
			View vwItem = null;
			if (groupPosition==0){
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
					convertView = m_actv.getLayoutInflater().inflate(R.layout.row_food, null);
				}
				vwItem = convertView;
				if (tvFoodName == null) tvFoodName = (TextView)convertView.findViewById(R.id.tvFoodName);
				TextView tvFoodAmount = (TextView)convertView.findViewById(R.id.tvFoodAmount);
				String foodId = m_OrderedFoodIdList.get(childPosition);
//				HashMap<String, Object> foodInfo = m_foodsData.get(childPosition);
				HashMap<String, Object> foodInfo = m_foods2LevelHm.get(foodId);
				assert(foodInfo!=null);
//				Double foodAmount = m_foodAmountList.get(childPosition);
				Double foodAmount = m_foodAmountHm.get(foodId);
				tvFoodName.setText((String)foodInfo.get(Constants.COLUMN_NAME_CnCaption));
				tvFoodAmount.setText(foodAmount.toString());
				
				ImageView ivFood = (ImageView)convertView.findViewById(R.id.ivFood);
				ivFood.setImageDrawable(Tool.getDrawableForFoodPic(getAssets(), (String)foodInfo.get(Constants.COLUMN_NAME_PicPath)));
				
				ImageButton imgBtnRemoveFood = (ImageButton)convertView.findViewById(R.id.imgBtnRemoveFood);
				ChildRowRelateData tagData = new ChildRowRelateData();
				tagData.childPosition = childPosition;
				tagData.groupPosition = groupPosition;
				imgBtnRemoveFood.setTag(tagData);
				imgBtnRemoveFood.setOnClickListener(new View.OnClickListener() {
					@Override
					public void onClick(View v) {
						ChildRowRelateData tagData = (ChildRowRelateData)v.getTag();
						String foodId = m_OrderedFoodIdList.get(tagData.childPosition);
						m_OrderedFoodIdList.remove(tagData.childPosition);
						m_foodAmountHm.remove(foodId);
						m_foods2LevelHm.remove(foodId);
						reCalculateFoodSupplyNutrient();

						notifyDataSetChanged();
					}
				});
			}else{
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
					convertView = m_actv.getLayoutInflater().inflate(R.layout.row_nutrient, null);
				}
				vwItem = convertView;
				
				HashMap<String, Object> nutrientInfo = m_nutrientsData.get(childPosition);
				Double dObj_supplyRate = (Double)nutrientInfo.get(Constants.Key_supplyNutrientRate);
				int supplyPercent = (int) Math.round( dObj_supplyRate.doubleValue() * 100 );
				TextView tvNutrient = (TextView)vwItem.findViewById(R.id.tvNutrient);
				tvNutrient.setText((String)nutrientInfo.get(Constants.Key_Name));
				
				ProgressBar pbSupplyPercent = (ProgressBar)vwItem.findViewById(R.id.pbSupplyPercent);
				ImageButton imgBtnAddByNutrient = (ImageButton)vwItem.findViewById(R.id.imgBtnAddByNutrient);
				
				if (tvSupplyPercent==null) tvSupplyPercent = (TextView)vwItem.findViewById(R.id.tvSupplyPercent);
				tvSupplyPercent.setText(supplyPercent+"%");
				pbSupplyPercent.setProgress(supplyPercent);
				
				ChildRowRelateData childRowRelateData1 = new ChildRowRelateData();
				childRowRelateData1.childPosition = childPosition;
				childRowRelateData1.groupPosition = groupPosition;
				OnClickListenerToAddFoodByNutrient onClickListenerToAddFoodByNutrient1 = null;
				onClickListenerToAddFoodByNutrient1 = (OnClickListenerToAddFoodByNutrient)imgBtnAddByNutrient.getTag();
				if (onClickListenerToAddFoodByNutrient1 == null){
					onClickListenerToAddFoodByNutrient1 = new OnClickListenerToAddFoodByNutrient(childRowRelateData1);
					imgBtnAddByNutrient.setTag(onClickListenerToAddFoodByNutrient1);
				}else{
					onClickListenerToAddFoodByNutrient1.initInputData(childRowRelateData1);
				}
				pbSupplyPercent.setOnClickListener(onClickListenerToAddFoodByNutrient1);
				imgBtnAddByNutrient.setOnClickListener(onClickListenerToAddFoodByNutrient1);
			}
			return vwItem;
		}
		
		class OnClickListenerToAddFoodByNutrient implements View.OnClickListener{
			
			ChildRowRelateData m_ChildRowRelateData ;
			
			public OnClickListenerToAddFoodByNutrient(ChildRowRelateData childRowRelateData){
				m_ChildRowRelateData = childRowRelateData;
			}
			public void initInputData(ChildRowRelateData childRowRelateData){
				m_ChildRowRelateData = childRowRelateData;
			}

			@Override
			public void onClick(View v) {
				//ChildRowRelateData tagData = (ChildRowRelateData)v.getTag();
				ChildRowRelateData tagData = m_ChildRowRelateData;
				Log.d(LogTag, "groupPosition,groupPosition=["+tagData.groupPosition+","+tagData.childPosition+"]");
				
				HashMap<String, Double> DRIsDict = (HashMap<String, Double>)(m_paramsForCalculateNutritionSupply.get(Constants.Key_DRI));
				
				HashMap<String, Object> nutrientInfo = m_nutrientsData.get(tagData.childPosition);
				Intent intent = new Intent(ActivityFoodCombination.this, ActivityRichFood.class);
				String nutrientId = (String)nutrientInfo.get(Constants.COLUMN_NAME_NutrientID);
				intent.putExtra(Constants.COLUMN_NAME_NutrientID, nutrientId);
				intent.putExtra(Constants.Key_Amount, DRIsDict.get(nutrientId).doubleValue());
				startActivityForResult(intent,IntentRequestCode_ActivityRichFood);
				
			}
			
		}
		
		public View getGroupView(int groupPosition, boolean isExpanded,	View convertView, ViewGroup parent)
		{
			View vwItem = m_actv.getLayoutInflater().inflate(R.layout.expandablelist_groupitem, null);
			TextView textView = (TextView)vwItem.findViewById(R.id.textView1);
			textView.setText(GroupTitles[groupPosition]);
			return vwItem;
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
	
	}
	    
    class ChildRowRelateData {
		public int groupPosition;
		public int childPosition;
	}
    
}













