package com.lingzhimobile.nutritionfoodguide;

import java.util.*;



import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.os.Bundle;
import android.text.Editable;
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
	
//	HashMap<String,Object> m_all_foodsByCnTypeHm;//Object is ArrayList<Object2> and Object2 is HashMap<String, Object>
//	String[] m_all_foodCnTypes;
	
//	ArrayList<HashMap<String, Object>> m_foods;
//	HashMap<String,ArrayList<HashMap<String, Object>>> m_foodsByCnTypeHm;
//	String[] m_foodCnTypes;


	EditText m_etSearch;
	TextView m_tvSearchTextClear;
	ExpandableListView m_expandableListView1;
	FoodsByTypeExpandableListAdapter m_FoodsByTypeExpandableListAdapter;
	Button mBtnFinish,m_btnCancel;
	

	@Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_search_food_custom);
        
        DataAccess da = DataAccess.getSingleTon(this);
		
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
//        mBtnFinish.setText(R.string.finish);
//        mBtnFinish.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//            	//...
//            	finish();
//            }
//        });
        
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
			
			ImageView ivAsEditText = (ImageView)vwItem.findViewById(R.id.ivAsEditText);
//			Button btnShowInputDialog = (Button)vwItem.findViewById(R.id.btnShowInputDialog);
			
			ChildRowRelateData childRowRelateData1 = new ChildRowRelateData();
			childRowRelateData1.childPosition = childPosition;
			childRowRelateData1.groupPosition = groupPosition;
			OnClickListenerForInputAmount onClickListenerToAddFood1 = null;
			onClickListenerToAddFood1 = (OnClickListenerForInputAmount)tvFoodName.getTag();
			if (onClickListenerToAddFood1 == null){
				onClickListenerToAddFood1 = new OnClickListenerForInputAmount(childRowRelateData1);
				ivAsEditText.setOnClickListener(onClickListenerToAddFood1);
				tvFoodName.setTag(onClickListenerToAddFood1);
			}else{
				onClickListenerToAddFood1.initInputData(childRowRelateData1);
			}
			
			return vwItem;
		}

		class ChildRowRelateData {
			public int groupPosition;
			public int childPosition;
		}
		class OnClickListenerForInputAmount implements OnClickListener,OnTouchListener,OnFocusChangeListener{
			
			ChildRowRelateData m_ChildRowRelateData ;
			
			public OnClickListenerForInputAmount(ChildRowRelateData childRowRelateData){
				m_ChildRowRelateData = childRowRelateData;
			}
			public void initInputData(ChildRowRelateData childRowRelateData){
				m_ChildRowRelateData = childRowRelateData;
			}
			

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
				AlertDialog.Builder dlgBuilder =new AlertDialog.Builder(ActivitySearchFoodCustom.this);
				View vwDialogContent = getLayoutInflater().inflate(R.layout.dialog_input_food_amount, null);
				EditText etAmount = (EditText)vwDialogContent.findViewById(R.id.etAmount);
				TextView tvFood = (TextView)vwDialogContent.findViewById(R.id.tvFood);
				HashMap<String, Object> foodData = (HashMap<String, Object>)getChild(m_ChildRowRelateData.groupPosition,m_ChildRowRelateData.childPosition); // m_foodsData.get(m_rowPos);
				String foodName = (String)foodData.get(Constants.COLUMN_NAME_CnCaption);
				tvFood.setText(foodName);
				
				DialogInterfaceEventListener_EditText dialogInterfaceEventListener_EditText1 = new DialogInterfaceEventListener_EditText(etAmount);
				dlgBuilder.setView(vwDialogContent);
				dlgBuilder.setPositiveButton("OK", dialogInterfaceEventListener_EditText1);
				dlgBuilder.setNegativeButton("Cancel", dialogInterfaceEventListener_EditText1);
				
				AlertDialog dlg = dlgBuilder.create();
				dialogInterfaceEventListener_EditText1.SetDialog(dlg);
				dlg.setOnShowListener(dialogInterfaceEventListener_EditText1);
				dlg.show();
			}
			
			class DialogInterfaceEventListener_EditText implements DialogInterface.OnClickListener, DialogInterface.OnShowListener{
				Dialog mDialog;
				EditText m_editText1;
				public DialogInterfaceEventListener_EditText(EditText editText1){
					m_editText1 = editText1;
				}
				public void SetDialog(Dialog dlg){
					mDialog = dlg;
				}
				
				@Override
				public void onClick(DialogInterface dlgInterface, int which) {
					if(which == DialogInterface.BUTTON_POSITIVE){
						Log.d(LogTag, "DialogInterfaceOnClickListener_EditText onClick OK");
						String sInput = m_editText1.getText().toString();
						HashMap<String, Object> foodData =  (HashMap<String, Object>)getChild(m_ChildRowRelateData.groupPosition,m_ChildRowRelateData.childPosition); //m_foodsData.get(m_rowPos);
						String foodId = (String)foodData.get(Constants.COLUMN_NAME_NDB_No);
						
						Intent intent = new Intent();
		            	intent.putExtra(Constants.COLUMN_NAME_NDB_No, foodId);
		            	intent.putExtra(Constants.Key_Amount, Integer.parseInt(sInput));
		            	ActivitySearchFoodCustom.this.setResult(IntentResultCode, intent);
		            	
		            	//ActivitySearchFoodCustom.this.finish();
		            	ActivitySearchFoodCustom.this.doFinish();
//		            	finish();
					}else if(which == DialogInterface.BUTTON_NEGATIVE){
					}else if(which == DialogInterface.BUTTON_NEUTRAL){//忽略按键的点击事件
					}
					m_editText1 = null;
	            	mDialog = null;
				}

				@Override
				public void onShow(DialogInterface dlgInterface) {
					Log.d(LogTag, "DialogInterfaceOnClickListener_EditText onShow");
					InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
			        imm.showSoftInput(m_editText1, InputMethodManager.SHOW_IMPLICIT);//能show出键盘
//			        imm.showSoftInput(m_editText1, InputMethodManager.SHOW_FORCED);//能show出键盘
//					m_editText1.requestFocus();
					
			        
				}
			}//class DialogInterfaceOnClickListener_EditText
		}//class OnClickListenerForInputAmount
		
	}//class FoodsByTypeExpandableListAdapter
    
    
    
}













