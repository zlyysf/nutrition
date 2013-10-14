package com.lingzhimobile.nutritionfoodguide;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;


import com.lingzhimobile.nutritionfoodguide.DialogHelperSimpleInput.InterfaceWhenConfirmInput;
import com.lingzhimobile.nutritionfoodguide.OnClickListenerInExpandListItem.Data2LevelPosition;


import android.R.integer;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.os.Bundle;
import android.support.v4.widget.SimpleCursorAdapter.ViewBinder;
import android.text.InputType;
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
	
	public static final int IntentResultCode = 1101;
	
	static final String LogTag = "ActivityFoodCombination";
	
	static final String[] GroupTitles = new String[]{"一天的食物","一天的营养比例"};
	
	long m_collocationId = -1;
	String m_in_foodId;
	double m_in_foodAmount;
	HashMap<String, Double> m_foodAmountHm;
	ArrayList<String> m_OrderedFoodIdList ;
	HashMap<String, HashMap<String, Object>> m_foods2LevelHm ;
	
	ArrayList<HashMap<String, Object>> m_nutrientsData;
	HashMap<String, Object> m_paramsForCalculateNutritionSupply;
	HashMap<String, HashMap<String, Object>> m_nutrientInfoDict2Level;
	Button mBtnSave,m_btnCancel;
	ImageButton m_imgbtnAdd,m_imgbtnShare,m_imgbtnRecommend;
	
	ExpandableListView m_expandableListView1;
	
	ExpandableListAdapter_FoodNutrition mListAdapter;
	String m_currentTitle;
	


	@Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_food_combination);
        
        Intent paramIntent = getIntent();
        Log.d(LogTag, "onCreate paramIntent="+paramIntent);
        m_collocationId =  paramIntent.getLongExtra(Constants.COLUMN_NAME_CollocationId,-1);
        m_in_foodId = paramIntent.getStringExtra(Constants.COLUMN_NAME_NDB_No);
        m_in_foodAmount = paramIntent.getDoubleExtra(Constants.Key_Amount, 0);
        
        initViewHandles();
        initViewsContent();
        setViewEventHandlers();
        setViewsContent();
    }
	
	void initViewHandles(){
		mBtnSave = (Button) findViewById(R.id.btnTopRight);
        
        m_btnCancel = (Button) findViewById(R.id.btnCancel);
        m_imgbtnAdd = (ImageButton) findViewById(R.id.imgbtnAdd);
        m_imgbtnShare = (ImageButton) findViewById(R.id.imgbtnShare);
        m_imgbtnRecommend = (ImageButton) findViewById(R.id.imgbtnRecommend);
        m_expandableListView1 = (ExpandableListView)this.findViewById(R.id.expandableListView1);
        
        m_imgbtnShare.setVisibility(View.GONE);
	}
	void initViewsContent(){
		Intent paramIntent = getIntent();
        String prevActvTitle = paramIntent.getStringExtra(Constants.IntentParamKey_BackButtonTitle);
        if (prevActvTitle!=null)
        	m_btnCancel.setText(prevActvTitle);
        
        mBtnSave.setText(R.string.save);
        
        m_currentTitle = getResources().getString(R.string.title_food_combination);
        TextView tvTitle = (TextView) findViewById(R.id.tvTitle);
        tvTitle.setText(m_currentTitle);
        if (m_collocationId > 0){
        	DataAccess da = DataAccess.getSingleton();
        	HashMap<String, Object> foodCollocation = da.getFoodCollocationById(m_collocationId);
        	if (foodCollocation!=null){
        		String collocationName = (String)foodCollocation.get(Constants.COLUMN_NAME_CollocationName);
        		tvTitle.setText(collocationName);
        	}
        }
	}
	void setViewEventHandlers(){
//        m_expandableListView1.setOnChildClickListener(new OnChildClickListener(){
//
//			@Override
//			public boolean onChildClick(ExpandableListView parent, View v, int groupPosition, int childPosition, long id) {
//				Log.d(LogTag, "expandableListView1 onChildClick ["+groupPosition+","+childPosition+"]");//没有反应
//				if (groupPosition==0){
//					
//				}else{
//					HashMap<String, Double> DRIsDict = (HashMap<String, Double>)(m_paramsForCalculateNutritionSupply.get(Constants.Key_DRI));
//					
//					HashMap<String, Object> nutrientInfo = m_nutrientsData.get(childPosition);
//					Intent intent = new Intent(ActivityFoodCombination.this, ActivityRichFood.class);
//					String nutrientId = (String)nutrientInfo.get(Constants.COLUMN_NAME_NutrientID);
//					intent.putExtra(Constants.COLUMN_NAME_NutrientID, nutrientId);
//					intent.putExtra(Constants.Key_Amount, DRIsDict.get(nutrientId).toString());
//					intent.putExtra(Constants.Key_Name, (String)nutrientInfo.get(Constants.Key_Name));
//					startActivity(intent);
//				}
//				
//				return true;
//			}
//        });
        
        mBtnSave.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	if (m_foodAmountHm!=null && m_foodAmountHm.size()>0){
            		if (m_collocationId<0){//to new
            			Date dtNow = new Date();
            			SimpleDateFormat sdf = new SimpleDateFormat("MM月dd日");
            			String datePart = sdf.format(dtNow);
//            			DateFormat df = DateFormat.getDateInstance(DateFormat.SHORT);
//            			String datePart = df.format(dtNow);
            			
            			String collocationName = Tool.getStringFromIdWithParams(getResources(), R.string.defaultFoodCollocationName,new String[]{datePart});
            			
            			DialogHelperSimpleInput myDialogHelperSimpleInput = new DialogHelperSimpleInput(ActivityFoodCombination.this);
        				myDialogHelperSimpleInput.prepareDialogAttributes("保存食物清单", "给你的食物清单加个名称吧", collocationName);
        				myDialogHelperSimpleInput.setInterfaceWhenConfirmInput(new InterfaceWhenConfirmInput() {
        					@Override
        					public void onConfirmInput(String input) {
        						if (input==null || input.length()==0){
        							Tool.ShowMessageByDialog(ActivityFoodCombination.this, "输入不能为空");
        						}else{
        							String collocationName2 = input;
        							ArrayList<Object[]> foodAmount2LevelArray = convertFoodAmountHashmapToPairList();
        							DataAccess da = DataAccess.getSingleton();
        							da.insertFoodCollocationData_withCollocationName(collocationName2, foodAmount2LevelArray);
        	                    	Intent intent = new Intent();
        	                    	ActivityFoodCombination.this.setResult(IntentResultCode, intent);
        	                    	finish();
        						}
        					}
        				});
        				myDialogHelperSimpleInput.show();
            			return;
            		}else{//to edit
            			ArrayList<Object[]> foodAmount2LevelArray = convertFoodAmountHashmapToPairList();
                    	DataAccess da = DataAccess.getSingleton();
            			da.updateFoodCollocationData_withCollocationId(m_collocationId, null, foodAmount2LevelArray);
            			Intent intent = new Intent();
                    	ActivityFoodCombination.this.setResult(IntentResultCode, intent);
                    	finish();
                    	return;
            		}
            	}else{//NOT if (m_foodAmountHm!=null && m_foodAmountHm.size()>0)
            		Tool.ShowMessageByDialog(ActivityFoodCombination.this, "不能保存不含任何食物的食物搭配");
            		return;
            	}
            }
        });
        m_btnCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	finish();
            }
        });
        m_imgbtnAdd.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	Intent intent = new Intent(ActivityFoodCombination.this, ActivitySearchFoodCustom.class);
            	intent.putExtra(Constants.IntentParamKey_BackButtonTitle, m_currentTitle);
				startActivityForResult(intent,IntentRequestCode_ActivitySearchFoodCustom);
            }
        });
        m_imgbtnShare.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	Intent intent = new Intent(ActivityFoodCombination.this, ActivityAllFoodExpandList.class);
				startActivityForResult(intent,IntentRequestCode_ActivityAllFoodExpandList);
            }
        });
        m_imgbtnRecommend.setOnClickListener(new View.OnClickListener() {
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
        DataAccess da = DataAccess.getSingleton(ActivityFoodCombination.this);
        
        if (m_collocationId > 0){
        	//ArrayList<HashMap<String, Object>> collocationFoodData 
        	HashMap<String, Object> foodCollocationData = da.getFoodCollocationData_withCollocationId(m_collocationId);
        	ArrayList<HashMap<String, Object>> foodAndAmountArray = (ArrayList<HashMap<String, Object>>)foodCollocationData.get("foodAndAmountArray") ;
        	if (foodAndAmountArray!=null && foodAndAmountArray.size()>0 ){
        		ArrayList<String> foodIds = new ArrayList<String>();
        		for(int i=0; i<foodAndAmountArray.size(); i++){
        			HashMap<String, Object> foodAndAmountInfo = foodAndAmountArray.get(i);
        			String foodId = (String)foodAndAmountInfo.get(Constants.COLUMN_NAME_FoodId);
        			Double foodAmount = (Double)foodAndAmountInfo.get(Constants.COLUMN_NAME_FoodAmount);
        			m_foodAmountHm.put(foodId, foodAmount);
        			foodIds.add(foodId);
        		}
        		if (m_in_foodId!=null && m_in_foodId.length()>0){
        			if ( m_foodAmountHm.get(m_in_foodId)==null ){
        				m_foodAmountHm.put(m_in_foodId, Double.valueOf(m_in_foodAmount));
        				foodIds.add(m_in_foodId);
        			}else{
        				Tool.addDoubleToDictionaryItem(m_in_foodAmount, m_foodAmountHm, m_in_foodId);
        			}
        		}
        		String[] foodIdAry = foodIds.toArray(new String[foodIds.size()]);
        		ArrayList<HashMap<String, Object>> foodAttrAry = da.getFoodAttributesByIds(foodIdAry);
        		m_foods2LevelHm = Tool.dictionaryArrayTo2LevelDictionary_withKeyName(Constants.COLUMN_NAME_NDB_No, foodAttrAry);
        		m_OrderedFoodIdList = da.getOrderedFoodIds(foodIdAry);
        	}
        }else{
        	if (m_in_foodId!=null && m_in_foodId.length()>0){
        		m_foodAmountHm.put(m_in_foodId, Double.valueOf(m_in_foodAmount));
        		m_OrderedFoodIdList.add(m_in_foodId);
        		ArrayList<HashMap<String, Object>> foodAttrAry = da.getFoodAttributesByIds(new String[]{m_in_foodId});
        		m_foods2LevelHm = Tool.dictionaryArrayTo2LevelDictionary_withKeyName(Constants.COLUMN_NAME_NDB_No, foodAttrAry);
        	}
        }
        
        RecommendFood rf = new RecommendFood(this);
        HashMap<String, Object> userInfo = StoredConfigTool.getUserInfo(this);
	    HashMap<String, Object> params = new HashMap<String, Object>();
	    params.put(Constants.Key_userInfo, userInfo);
//	    params.put("dynamicFoodAttrs", dynamicFoodAttrs);
//	    params.put("dynamicFoodAmount", dObj_dynamicFoodAmount);
	    params.put("staticFoodAttrsDict2Level", m_foods2LevelHm);
	    params.put("staticFoodAmountDict", m_foodAmountHm);
	    m_nutrientsData = rf.calculateGiveStaticFoodsDynamicFoodSupplyNutrientAndFormatForUI(params);

	    m_paramsForCalculateNutritionSupply = params;
	    m_nutrientInfoDict2Level = (HashMap<String, HashMap<String, Object>>)m_paramsForCalculateNutritionSupply.get("nutrientInfoDict2Level");
		
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
	
	ArrayList<Object[]> convertFoodAmountHashmapToPairList(){
		ArrayList<Object[]> foodAmount2LevelArray = null;
		if (m_foodAmountHm!=null && m_foodAmountHm.size()>0){
    		foodAmount2LevelArray = new ArrayList<Object[]>();
        	String[] foodIds = m_foodAmountHm.keySet().toArray(new String[m_foodAmountHm.size()]);
        	for(int i=0; i<foodIds.length; i++){
        		String foodId = foodIds[i];
        		Double foodAmount = m_foodAmountHm.get(foodId);
        		Object[] foodAmountPair = new Object[]{foodId, foodAmount};
        		foodAmount2LevelArray.add(foodAmountPair);
        	}
		}
		return foodAmount2LevelArray;
	}
	
	class DialogInterfaceEventListener_SelectNutrients implements DialogInterface.OnClickListener, DialogInterface.OnMultiChoiceClickListener{
		AlertDialog mAlertDialog;
		CheckBox m_cbSelectAll;
		String[] m_nutrientIds;
//		String[] m_nutrientNames;
		boolean[] m_flagsForNutrients;
		public DialogInterfaceEventListener_SelectNutrients(CheckBox cbSelectAll, String[] nutrientIds, boolean[] flagsForNutrients){
			m_cbSelectAll = cbSelectAll;
			m_nutrientIds = nutrientIds;
//			m_nutrientNames = nutrientNames;
			m_flagsForNutrients = flagsForNutrients;
		}
		public void SetDialog(AlertDialog dlg){
			mAlertDialog = dlg;

			m_cbSelectAll.setOnClickListener(new View.OnClickListener() {
				@Override
				public void onClick(View v) {
					boolean checked = m_cbSelectAll.isChecked();
					ListView lv = mAlertDialog.getListView();
					for(int i=0; i<m_nutrientIds.length; i++){
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
				for(int i=0; i<m_nutrientIds.length; i++){
					if (m_flagsForNutrients[i]){
						String selNutrient = m_nutrientIds[i];
						selNutrients.add(selNutrient);
					}
				}
				Log.d(LogTag, "selNutrients="+selNutrients);
				if (selNutrients.size()==0){
//					Toast toast1 = Toast.makeText(ActivityFoodCombination.this, "您必须至少选择一个", Toast.LENGTH_SHORT);
//					toast1.show();
					new AlertDialog.Builder(ActivityFoodCombination.this).setTitle("您必须至少选择一个").setPositiveButton(R.string.OK, null).show();
					
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
		TextView tvTitleDialog = (TextView)vwDialogContent.findViewById(R.id.tvTitleDialog);
		tvTitleDialog.setText(R.string.chooseNutrientsExplain);
		CheckBox cbSelectAll = (CheckBox)vwDialogContent.findViewById(R.id.cbSelectAll);
		boolean initialChecked = true;
		cbSelectAll.setChecked(initialChecked);

//		String[] nutrientIds = NutritionTool.getCustomNutrients(null);
//		boolean[] flagsForNutrients = Tool.generateArrayWithFillItem(initialChecked, nutrientIds.length);
		String[] prevSelNutrients = StoredConfigTool.getNutrientsToRecommend(this);
		String[] nutrientIds = NutritionTool.getCustomNutrients(null);
		boolean[] flagsForNutrients = Tool.generateContainFlags(nutrientIds, prevSelNutrients);
		String[] nutrientNames = getNutrientNames(nutrientIds);
		
		DialogInterfaceEventListener_SelectNutrients diEventListener = new DialogInterfaceEventListener_SelectNutrients(cbSelectAll, nutrientIds, flagsForNutrients);
		dlgBuilder.setCustomTitle(vwDialogContent);
		//这里setMultiChoiceItems的第二个参数有讲究，如果传了值，则在程序中只用 dialogListview.setItemChecked 会导致没有效果，需要先设置 flagsForNutrients 的相应条目才行.参见下面的url和文字。
		//http://stackoverflow.com/questions/3608018/toggling-check-boxes-in-multichoice-alertdialog-in-android
		//One thing to watch for: you must specify "null" for the "checkedItems" parameter in your "setMultiChoiceItems" call -- otherwise the "setItemChecked" calls won't work as expected. It would end up using that array to store the checked state, and "setItemChecked" would'nt update it correctly, so everything would get confused. Odd, but true.
		//但是，就算不传值而是传 null 值，还是有问题----使用 getCheckedItemPositions 不准确，当列表太长预置全选状态时就选不到未显示的一些条目.
		//正确方式是，传有值，如flagsForNutrients，然后同步设置它的值。目前暂时没发现问题。
		dlgBuilder.setMultiChoiceItems(nutrientNames, flagsForNutrients, diEventListener);
		
		dlgBuilder.setPositiveButton(R.string.OK, diEventListener);
		dlgBuilder.setNegativeButton(R.string.cancel, diEventListener);
		
		AlertDialog dlg = dlgBuilder.create();
		
		diEventListener.SetDialog(dlg);
		dlg.show();
	}
	String[] getNutrientNames(String[] nutrientIds){
		String[] nutrientNames = new String[nutrientIds.length];
		for(int i=0; i<nutrientIds.length; i++){
			String nutrientId = nutrientIds[i];
			HashMap<String, Object> nutrientInfo = m_nutrientInfoDict2Level.get(nutrientId);
			String nutrientName = (String)nutrientInfo.get(Constants.COLUMN_NAME_NutrientCnCaption);
			nutrientNames[i] = nutrientName;
		}
		return nutrientNames;
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
	    DataAccess da  = DataAccess.getSingleton(ActivityFoodCombination.this);
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
						
						DataAccess da  = DataAccess.getSingleton(ActivityFoodCombination.this);
						m_OrderedFoodIdList = da.getOrderedFoodIds(m_foodAmountHm);
						
						ArrayList<HashMap<String, Object>> foodInfoList = da.getFoodAttributesByIds(new String[]{foodId});

						assert(foodInfoList.size()==1);
//						m_foodsData.addAll(foodInfoList);
						m_foods2LevelHm.put(foodId, foodInfoList.get(0));
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
	
		public View getChildView(int groupPosition, int childPosition, boolean isLastChild, View convertView, ViewGroup parent)
		{
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
				
				ImageView ivFood = (ImageView)convertView.findViewById(R.id.ivFood);
				ivFood.setImageDrawable(Tool.getDrawableForFoodPic(getAssets(), (String)foodInfo.get(Constants.COLUMN_NAME_PicPath)));
				
				LinearLayout llRowFood = (LinearLayout)convertView.findViewById(R.id.llRowFood);
				OnClickListenerToEditFoodAmount myOnClickListenerToEditFoodAmount = (OnClickListenerToEditFoodAmount)llRowFood.getTag();
				if (myOnClickListenerToEditFoodAmount == null){
					myOnClickListenerToEditFoodAmount = new OnClickListenerToEditFoodAmount();
					myOnClickListenerToEditFoodAmount.initInputData(groupPosition,childPosition);
					llRowFood.setTag(myOnClickListenerToEditFoodAmount);
					llRowFood.setOnClickListener(myOnClickListenerToEditFoodAmount);
				}else{
					myOnClickListenerToEditFoodAmount.initInputData(groupPosition,childPosition);
				}
				
				
				ImageButton imgBtnRemoveFood = (ImageButton)convertView.findViewById(R.id.imgBtnRemoveFood);
				Data2LevelPosition tagData = new Data2LevelPosition();
				tagData.childPos = childPosition;
				tagData.groupPos = groupPosition;
				imgBtnRemoveFood.setTag(tagData);
				imgBtnRemoveFood.setOnClickListener(new View.OnClickListener() {
					@Override
					public void onClick(View v) {
						Data2LevelPosition tagData = (Data2LevelPosition)v.getTag();
						String foodId = m_OrderedFoodIdList.get(tagData.childPos);
						m_OrderedFoodIdList.remove(tagData.childPos);
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
				
				HashMap<String, Object> nutrientData = m_nutrientsData.get(childPosition);
				String nutrientId = (String)nutrientData.get(Constants.COLUMN_NAME_NutrientID);
				HashMap<String, Object> nutrientInfo = m_nutrientInfoDict2Level.get(nutrientId);
				
				Double dObj_supplyRate = (Double)nutrientData.get(Constants.Key_supplyNutrientRate);
				int supplyPercent = (int) Math.round( dObj_supplyRate.doubleValue() * 100 );
				TextView tvNutrient = (TextView)convertView.findViewById(R.id.tvNutrient);
				tvNutrient.setText((String)nutrientData.get(Constants.Key_Name));
				LinearLayout llNutrient = (LinearLayout)convertView.findViewById(R.id.llNutrient);
				
				OnClickListenerToShowNutrientDescription myOnClickListenerToShowNutrientDescription = (OnClickListenerToShowNutrientDescription)llNutrient.getTag();
				if (myOnClickListenerToShowNutrientDescription == null){
					myOnClickListenerToShowNutrientDescription = new OnClickListenerToShowNutrientDescription();
					myOnClickListenerToShowNutrientDescription.initInputData((String)nutrientInfo.get(Constants.COLUMN_NAME_NutrientDescription));
					llNutrient.setOnClickListener(myOnClickListenerToShowNutrientDescription);
					llNutrient.setTag(myOnClickListenerToShowNutrientDescription);
				}else{
					myOnClickListenerToShowNutrientDescription.initInputData((String)nutrientInfo.get(Constants.COLUMN_NAME_NutrientDescription));
				}
				
				
				LinearLayout llProgress = (LinearLayout)convertView.findViewById(R.id.llProgress);
				ProgressBar pbSupplyPercent = (ProgressBar)convertView.findViewById(R.id.pbSupplyPercent);
				ImageButton imgBtnAddByNutrient = (ImageButton)convertView.findViewById(R.id.imgBtnAddByNutrient);
				
				if (tvSupplyPercent==null) tvSupplyPercent = (TextView)convertView.findViewById(R.id.tvSupplyPercent);
				tvSupplyPercent.setText(supplyPercent+"%");
				pbSupplyPercent.setProgress(supplyPercent);

				OnClickListenerToAddFoodByNutrient onClickListenerToAddFoodByNutrient1 = (OnClickListenerToAddFoodByNutrient)imgBtnAddByNutrient.getTag();
				if (onClickListenerToAddFoodByNutrient1 == null){
					onClickListenerToAddFoodByNutrient1 = new OnClickListenerToAddFoodByNutrient();
					onClickListenerToAddFoodByNutrient1.initInputData(groupPosition,childPosition);
					imgBtnAddByNutrient.setOnClickListener(onClickListenerToAddFoodByNutrient1);
					llProgress.setOnClickListener(onClickListenerToAddFoodByNutrient1);
					imgBtnAddByNutrient.setTag(onClickListenerToAddFoodByNutrient1);
				}else{
					onClickListenerToAddFoodByNutrient1.initInputData(groupPosition,childPosition);
				}
//				pbSupplyPercent.setOnClickListener(onClickListenerToAddFoodByNutrient1);
//				llProgress.setOnClickListener(onClickListenerToAddFoodByNutrient1);
//				imgBtnAddByNutrient.setOnClickListener(onClickListenerToAddFoodByNutrient1);
			}
			return convertView;
		}
		
		class OnClickListenerToShowNutrientDescription implements View.OnClickListener{
			String m_nutrientDescription;
			
			public void initInputData(String nutrientDescription){
				m_nutrientDescription = nutrientDescription;
			}

			@Override
			public void onClick(View v) {
				new AlertDialog.Builder(ActivityFoodCombination.this).setMessage(m_nutrientDescription).setPositiveButton("OK", null).show();
				
			}
		}
		
		class OnClickListenerToAddFoodByNutrient extends OnClickListenerInExpandListItem{
			@Override
			public void onClick(View v) {
				Log.d(LogTag, "OnClickListenerToAddFoodByNutrient 2levelPos=["+m_Data2LevelPosition.groupPos+","+m_Data2LevelPosition.childPos+"]"+v);
				
				HashMap<String, Object> nutrientData = m_nutrientsData.get(m_Data2LevelPosition.childPos);
				String nutrientId = (String)nutrientData.get(Constants.COLUMN_NAME_NutrientID);
				
				HashMap<String, Double> DRIsDict = (HashMap<String, Double>)(m_paramsForCalculateNutritionSupply.get(Constants.Key_DRI));
				Double amountDRI = DRIsDict.get(nutrientId);
				Double dObj_supplyNutrientAmount = (Double)nutrientData.get(Constants.Key_supplyNutrientAmount);
				
				double toSupplyDelta = amountDRI.doubleValue() - dObj_supplyNutrientAmount.doubleValue();
				Log.d(LogTag, "OnClickListenerToAddFoodByNutrient amountDRI="+amountDRI+", dObj_supplyNutrientAmount="+dObj_supplyNutrientAmount+", toSupplyDelta1="+toSupplyDelta);
				if (toSupplyDelta<0)
					toSupplyDelta = 0;
				
				Intent intent = new Intent(ActivityFoodCombination.this, ActivityRichFood.class);
				intent.putExtra(Constants.IntentParamKey_BackButtonTitle, m_currentTitle);
				intent.putExtra(Constants.IntentParamKey_InvokerType, Constants.InvokerType_FromFoodCombination);
				intent.putExtra(Constants.COLUMN_NAME_NutrientID, nutrientId);
				intent.putExtra(Constants.Key_Amount, toSupplyDelta);
				intent.putExtra(Constants.Key_Name, (String)nutrientData.get(Constants.Key_Name));
				startActivityForResult(intent,IntentRequestCode_ActivityRichFood);
			}
		}
		
		class OnClickListenerToEditFoodAmount extends OnClickListenerInExpandListItem{
			@Override
			public void onClick(View v) {
				Log.d(LogTag, "2levelPos=["+m_Data2LevelPosition.groupPos+","+m_Data2LevelPosition.childPos+"]");
				
				String foodId = m_OrderedFoodIdList.get(m_Data2LevelPosition.childPos);
				Double foodAmount = m_foodAmountHm.get(foodId);
				HashMap<String, Object> foodInfo = m_foods2LevelHm.get(foodId);
				
				DialogHelperSimpleInput myDialogHelperSimpleInput = new DialogHelperSimpleInput(ActivityFoodCombination.this);
				EditText etInput = myDialogHelperSimpleInput.getInput();
				etInput.setInputType(InputType.TYPE_CLASS_NUMBER);
				myDialogHelperSimpleInput.prepareDialogAttributes("修改食物数量", (String)foodInfo.get(Constants.COLUMN_NAME_CnCaption), foodAmount.intValue()+"");
				myDialogHelperSimpleInput.setInterfaceWhenConfirmInput(new InterfaceWhenConfirmInput() {
					@Override
					public void onConfirmInput(String input) {
						if (input==null || input.length()==0){
							Tool.ShowMessageByDialog(ActivityFoodCombination.this, "输入不能为空");
						}else{
							String amount2 = input;
							String foodId = m_OrderedFoodIdList.get(m_Data2LevelPosition.childPos);
							m_foodAmountHm.put(foodId, Double.parseDouble(amount2));
							reCalculateFoodSupplyNutrient();
							notifyDataSetChanged();
						}
					}
				});
				myDialogHelperSimpleInput.show();
    			return;
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
    
}













