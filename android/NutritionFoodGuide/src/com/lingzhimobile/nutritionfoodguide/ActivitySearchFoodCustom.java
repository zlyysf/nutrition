package com.lingzhimobile.nutritionfoodguide;

import java.util.*;

import com.lingzhimobile.nutritionfoodguide.DialogHelperSimpleInput.InterfaceWhenConfirmInput;



import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.os.Bundle;
import android.text.Editable;
import android.text.InputType;
import android.text.TextWatcher;
import android.util.*;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.view.View.OnFocusChangeListener;
import android.view.View.OnTouchListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.*;
import android.widget.ExpandableListView.*;


public class ActivitySearchFoodCustom extends Activity {
	public static final int IntentResultCode = 1011;
	
	static final String LogTag = "ActivitySearchFoodCustom";
	
	
	
	String mInvokerType = null;


	EditText m_etSearch;
	TextView m_tvSearchTextClear;
	ExpandableListView m_expandableListView1;
	FoodsByTypeExpandableListAdapter m_FoodsByTypeExpandableListAdapter;
	Button mBtnFinish,m_btnCancel;

	@Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_search_food_custom);
        
        Intent paramIntent = getIntent();
        mInvokerType = paramIntent.getStringExtra(Constants.IntentParamKey_InvokerType);

        
        DataAccess da = DataAccess.getSingleton(this);
		
		ArrayList<HashMap<String, Object>> allfoods = da.getAllFood();
		SearchFoodTextWatcher searchFoodTextWatcher1 = new SearchFoodTextWatcher();
		m_etSearch = (EditText)findViewById(R.id.etSearch);
		m_etSearch.addTextChangedListener(searchFoodTextWatcher1);
		m_tvSearchTextClear = (TextView)findViewById(R.id.tvSearchTextClear);
		m_tvSearchTextClear.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				m_etSearch.setText("");
				InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
				imm.hideSoftInputFromWindow(ActivitySearchFoodCustom.this.getCurrentFocus().getWindowToken(),0);
			}
		});
		
		m_expandableListView1 = (ExpandableListView)this.findViewById(R.id.expandableListView1);
		m_FoodsByTypeExpandableListAdapter = new FoodsByTypeExpandableListAdapter(m_expandableListView1, allfoods);
        m_expandableListView1.setAdapter(m_FoodsByTypeExpandableListAdapter);
        //设置ExpandableListView 默认是展开的
//        for (int i = 0; i < m_foodCnTypes.length; i++) {
//        	expandableListView1.expandGroup(i);
//        }
//        expandableListView1.setOnGroupClickListener(new OnGroupClickListener(){
//        	//使点击group的项目不做折叠动作
//        	@Override
//        	public boolean onGroupClick(ExpandableListView parent, View v, int groupPosition, long id) { 
//        		return true;
//       	    }
//        });
//        expandableListView1.setGroupIndicator(null);//去掉ExpandableListView 默认的组上的下拉箭头
        
        
        m_expandableListView1.setOnChildClickListener(new OnChildClickListener(){

			@Override
			public boolean onChildClick(ExpandableListView parent, View v, int groupPosition, int childPosition, long id) {
				//...
				
				return true;
			}
        });
        
        mBtnFinish = (Button) findViewById(R.id.btnReset);
        mBtnFinish.setVisibility(View.INVISIBLE);

        
        m_btnCancel = (Button) findViewById(R.id.btnCancel);
        m_btnCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	finish();
            }
        });
        
        
    }
	
	void doFinish(){
		finish();
//		m_FoodsByTypeExpandableListAdapter.m_expandableListView = null;
	}
	
	class SearchFoodTextWatcher implements TextWatcher{
		@Override
		public void beforeTextChanged(CharSequence s, int start, int count, int after) {
		}
		@Override
		public void onTextChanged(CharSequence s, int start, int before, int count) {
			m_FoodsByTypeExpandableListAdapter.getFilter().filter(s);
		}
		@Override
		public void afterTextChanged(Editable s) {
		}
	}
    
    
    class FoodsByTypeExpandableListAdapter extends BaseExpandableListAdapter implements Filterable
	{
    	public ExpandableListView m_expandableListView;
    	ArrayList<HashMap<String, Object>> m_foods;
    	HashMap<String,ArrayList<HashMap<String, Object>>> m_foodsByCnTypeHm;
    	String[] m_foodCnTypes;
    	FoodByCnTypeFilter m_filter;
    	
    	public FoodsByTypeExpandableListAdapter(ExpandableListView expandableListView, ArrayList<HashMap<String, Object>> foods){
    		m_expandableListView = expandableListView;
    		m_foods = foods;
    		
    		if (m_foods != null){
    			m_foodsByCnTypeHm = Tool.groupBy(Constants.COLUMN_NAME_CnType, foods);
    			m_foodCnTypes = new String[m_foodsByCnTypeHm.size()];
        		m_foodsByCnTypeHm.keySet().toArray(m_foodCnTypes);
    		}else{
    			m_foodsByCnTypeHm = null;
    			m_foodCnTypes = null;
    		}    		
    	}
    	
    	public Object getGroup(int groupPosition)
		{
    		String foodCnType = m_foodCnTypes[groupPosition];
			return foodCnType;
		}
		public int getGroupCount()
		{
			return (m_foodCnTypes==null)?0: m_foodCnTypes.length;
		}
		public long getGroupId(int groupPosition)
		{
			return groupPosition;
		}
		
		public Object getChild(int groupPosition, int childPosition)
		{
			String foodCnType = (String)getGroup(groupPosition);
			ArrayList<HashMap<String, Object>> foodLst = m_foodsByCnTypeHm.get(foodCnType);
			HashMap<String, Object> food = foodLst.get(childPosition);
			return food;
		}
		public int getChildrenCount(int groupPosition)
		{
			String foodCnType = (String)getGroup(groupPosition);
			ArrayList<HashMap<String, Object>> foodLst = m_foodsByCnTypeHm.get(foodCnType);
			return foodLst.size();
		}
		public long getChildId(int groupPosition, int childPosition)
		{
			return childPosition;
		}

		public boolean isChildSelectable(int groupPosition, int childPosition)
		{
			return true;
		}
		public boolean hasStableIds()
		{
			return true;
		}
		
		public void ExpandAll(){
			if (m_foodCnTypes != null){
				for (int i = 0; i < m_foodCnTypes.length; i++) {
		        	m_expandableListView.expandGroup(i);
		        }
			}
		}
		
		@Override
		public Filter getFilter() {
			if (m_filter==null)
				m_filter = new FoodByCnTypeFilter();
			return m_filter;
		}
		class FoodByCnTypeFilter extends Filter{
			class ResultData{
				public ArrayList<HashMap<String, Object>> foods;
				public HashMap<String,ArrayList<HashMap<String, Object>>> foodsByCnTypeHm;
		    	public String[] foodCnTypes;
			}
			
			ResultData originalData = null;
			public FoodByCnTypeFilter(){
				originalData = new ResultData();
				originalData.foods = m_foods;
				originalData.foodsByCnTypeHm = m_foodsByCnTypeHm;
				originalData.foodCnTypes = m_foodCnTypes;
			}

			@Override
			protected FilterResults performFiltering(CharSequence constraint) {
				FilterResults results = new FilterResults();  
                if (constraint == null || constraint.length() == 0) { 
                    results.values = originalData;  
                    results.count = originalData.foodCnTypes.length;  
                } else {
                	ArrayList<HashMap<String, Object>> foodsFiltered = new ArrayList<HashMap<String,Object>>();
                	if (originalData.foods != null){
                		for(int i=0; i<originalData.foods.size(); i++){
                			HashMap<String, Object> food = originalData.foods.get(i);
                			String foodCnCaption = (String)food.get(Constants.COLUMN_NAME_CnCaption);
                			if (foodCnCaption!=null && foodCnCaption.contains(constraint)){
                				foodsFiltered.add(food);
                			}
                		}//for
                	}
                	HashMap<String,ArrayList<HashMap<String, Object>>> foodsByCnTypeHm = Tool.groupBy(Constants.COLUMN_NAME_CnType, foodsFiltered);
                	String[] foodCnTypes = new String[foodsByCnTypeHm.size()];
            		foodsByCnTypeHm.keySet().toArray(foodCnTypes);
            		ResultData resData1 = new ResultData();
            		resData1.foods = foodsFiltered;
            		resData1.foodsByCnTypeHm = foodsByCnTypeHm;
            		resData1.foodCnTypes = foodCnTypes;
                    results.values = resData1;  
                    results.count = resData1.foodCnTypes.length;  
                }  
                return results;  
			}

			@Override
			protected void publishResults(CharSequence constraint, FilterResults results) {
				ResultData resData1 = (ResultData)results.values;  
				m_foods = resData1.foods;
		    	m_foodsByCnTypeHm = resData1.foodsByCnTypeHm;
		    	m_foodCnTypes = resData1.foodCnTypes;
                notifyDataSetChanged();  
                ExpandAll();
			}
		}//class FoodByCnTypeFilter
		
		public View getGroupView(int groupPosition, boolean isExpanded,	View convertView, ViewGroup parent)
		{
			if (convertView == null){
				convertView = getLayoutInflater().inflate(R.layout.row_food_cntype, null);
			}
			View vwItem = convertView;
			
			TextView textView = (TextView)vwItem.findViewById(R.id.textView1);
			textView.setText(getGroup(groupPosition).toString());
			return vwItem;
		}
		public View getChildView(int groupPosition, int childPosition,
				boolean isLastChild, View convertView, ViewGroup parent)
		{
			if (convertView == null){
				convertView = getLayoutInflater().inflate(R.layout.row_food_input, null);
			}
			View vwItem = convertView;
			
			HashMap<String, Object> food = (HashMap<String, Object>)getChild(groupPosition, childPosition);
			
			TextView tvFoodName = (TextView)vwItem.findViewById(R.id.tvFoodName);
			tvFoodName.setText((String)food.get(Constants.COLUMN_NAME_CnCaption));
			
			ImageView ivFood = (ImageView)vwItem.findViewById(R.id.ivFood);
			ivFood.setImageDrawable(Tool.getDrawableForFoodPic(getAssets(), (String)food.get(Constants.COLUMN_NAME_PicPath)));
			
			LinearLayout llToInputFoodAmount = (LinearLayout)vwItem.findViewById(R.id.llToInputFoodAmount);
//			ImageView ivAsEditText = (ImageView)vwItem.findViewById(R.id.ivAsEditText);
			ImageButton imgBtnAddFood = (ImageButton)vwItem.findViewById(R.id.imgBtnAddFood);
			if (Constants.InvokerType_FromSearchFood.equals(mInvokerType)){
				llToInputFoodAmount.setVisibility(View.GONE);
				imgBtnAddFood.setVisibility(View.VISIBLE);
				OnClickListenerForInputAmount myOnClickListenerToAddFoodToList = (OnClickListenerForInputAmount)imgBtnAddFood.getTag();
				if (myOnClickListenerToAddFoodToList == null){
					myOnClickListenerToAddFoodToList = new OnClickListenerForInputAmount();
					myOnClickListenerToAddFoodToList.initInputData(groupPosition, childPosition);
					imgBtnAddFood.setOnClickListener(myOnClickListenerToAddFoodToList);
					imgBtnAddFood.setTag(myOnClickListenerToAddFoodToList);
				}else{
					myOnClickListenerToAddFoodToList.initInputData(groupPosition, childPosition);
				}
				
			}else{
				llToInputFoodAmount.setVisibility(View.VISIBLE);
				imgBtnAddFood.setVisibility(View.GONE);
				
				OnClickListenerForInputAmount onClickListenerToAddFood1 = (OnClickListenerForInputAmount)llToInputFoodAmount.getTag();
				if (onClickListenerToAddFood1 == null){
					onClickListenerToAddFood1 = new OnClickListenerForInputAmount();
					onClickListenerToAddFood1.initInputData(groupPosition,childPosition);
					llToInputFoodAmount.setOnClickListener(onClickListenerToAddFood1);
					llToInputFoodAmount.setTag(onClickListenerToAddFood1);
				}else{
					onClickListenerToAddFood1.initInputData(groupPosition,childPosition);
				}
			}
			return vwItem;
		}

		class OnClickListenerForInputAmount extends OnClickListenerInExpandListItem implements OnTouchListener,OnFocusChangeListener{

			@Override
			public void onClick(View v) {
				showInputDialog();
			}
			@Override
			public boolean onTouch(View v, MotionEvent event) {
				showInputDialog();
				return true;
			}
			@Override
			public void onFocusChange(View v, boolean hasFocus) {
				if (hasFocus){
					showInputDialog();
				}
			}
			void showInputDialog(){
				HashMap<String, Object> foodData = (HashMap<String, Object>)getChild(m_Data2LevelPosition.groupPos,m_Data2LevelPosition.childPos); 
				String foodName = (String)foodData.get(Constants.COLUMN_NAME_CnCaption);
				
				DialogHelperSimpleInput myDialogHelperSimpleInput = new DialogHelperSimpleInput(ActivitySearchFoodCustom.this);
				EditText etInput = myDialogHelperSimpleInput.getInput();
				etInput.setInputType(InputType.TYPE_CLASS_NUMBER);
				myDialogHelperSimpleInput.prepareDialogAttributes("输入食物数量", foodName, null);
				myDialogHelperSimpleInput.setInterfaceWhenConfirmInput(new InterfaceWhenConfirmInput() {
					@Override
					public void onConfirmInput(String input) {
						if (input==null || input.length()==0){
							Tool.ShowMessageByDialog(ActivitySearchFoodCustom.this, "输入不能为空");
						}else{
							Log.d(LogTag, "onConfirmInput "+input);
							String sInput = input;
							HashMap<String, Object> foodData = (HashMap<String, Object>)getChild(m_Data2LevelPosition.groupPos,m_Data2LevelPosition.childPos); 
							String foodId = (String)foodData.get(Constants.COLUMN_NAME_NDB_No);
							
							if (Constants.InvokerType_FromSearchFood.equals(mInvokerType)){
								Intent intent = new Intent(ActivitySearchFoodCustom.this,ActivityAddFoodChooseList.class);
//								intent.putExtra(ActivityAddFoodChooseList.IntentKey_ActionType, ActivityAddFoodChooseList.ActionType_ToFoodCombination);
				            	intent.putExtra(Constants.COLUMN_NAME_NDB_No, foodId);
				            	intent.putExtra(Constants.Key_Amount, Double.parseDouble(input));
								startActivity(intent);
								return;
							}else{
								Intent intent = new Intent();
				            	intent.putExtra(Constants.COLUMN_NAME_NDB_No, foodId);
				            	intent.putExtra(Constants.Key_Amount, Integer.parseInt(sInput));
				            	setResult(IntentResultCode, intent);
				            	finish();
				            	return;
							}
						}
					}
				});
				myDialogHelperSimpleInput.show();
			}
		}//class OnClickListenerForInputAmount
	}//class FoodsByTypeExpandableListAdapter
}













