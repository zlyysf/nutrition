package com.lingzhimobile.nutritionfoodguide;


import java.util.*;

//import com.lingzhimobile.nutritionfoodguide.ActivitySearchFoodCustom.FoodsByTypeExpandableListAdapter.OnClickListenerForInputAmount;
import com.lingzhimobile.nutritionfoodguide.DialogHelperSimpleInput.InterfaceWhenConfirmInput;
import com.umeng.analytics.MobclickAgent;


import android.R.integer;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Resources;
import android.database.Cursor;
import android.os.Bundle;
import android.text.InputType;
import android.util.*;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnFocusChangeListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.*;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ExpandableListView.*;


public class ActivityFoodByClass extends ActivityBase {
	public static final int IntentResultCode = 1000;
	
	static final String LogTag = "ActivityFoodByClass";

	String mInvokerType = null;
	String mFoodCnType;
	ArrayList<HashMap<String, Object>> m_foodsData;

	ListView m_listView1;
	Button m_btnTopRight;
	Button m_btnCancel;
	
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
        setContentView(R.layout.activity_foodbyclass);
        
        initViewHandles();
        initViewsContent();
        setViewEventHandlers();
        setViewsContent();
    }

	void initViewHandles(){
		m_btnCancel = (Button) findViewById(R.id.btnCancel);
		m_listView1 = (ListView)this.findViewById(R.id.listView1);
	}
	void initViewsContent(){
		Intent paramIntent = getIntent();
        
        mInvokerType = paramIntent.getStringExtra(Constants.IntentParamKey_InvokerType);
        mFoodCnType =  paramIntent.getStringExtra(Constants.COLUMN_NAME_CnType);

        String prevActvTitle = paramIntent.getStringExtra(Constants.IntentParamKey_BackButtonTitle);
        if (prevActvTitle!=null)
        	m_btnCancel.setText(prevActvTitle);
        
        m_btnTopRight = (Button) findViewById(R.id.btnTopRight);
		m_btnTopRight.setVisibility(View.GONE);
		
		m_currentTitle = mFoodCnType;
        TextView tvTitle = (TextView)findViewById(R.id.tvTitle);
        tvTitle.setText(m_currentTitle);
        
        DataAccess da = DataAccess.getSingleton(this);
        m_foodsData = da.getFoodsByShowingPart(null,null,mFoodCnType);
        
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
		ListAdapterForFood adapter = new ListAdapterForFood(this,m_foodsData,mInvokerType);
		m_listView1.setAdapter(adapter);
	}
    
	static class ListAdapterForFood extends BaseAdapter{
		ActivityBase m_thisActivity;
		ArrayList<HashMap<String, Object>> m_foodsData;
		String m_InvokerType;
		
		public ListAdapterForFood(ActivityBase thisActivity, ArrayList<HashMap<String, Object>> foodsData,String InvokerType){
			m_thisActivity = thisActivity;
			m_foodsData = foodsData;
			m_InvokerType = InvokerType;
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
		public Object getItem(int position) {
			return m_foodsData.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}
		
		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			if (convertView == null){
				convertView = m_thisActivity.getLayoutInflater().inflate(R.layout.row_food_input, null);
			}
			View vwItem = convertView;
			
			HashMap<String, Object> foodInfo = (HashMap<String, Object>)getItem(position);
			
			TextView tvFoodName = (TextView)vwItem.findViewById(R.id.tvFoodName);
			tvFoodName.setText((String)foodInfo.get(Constants.COLUMN_NAME_CnCaption));
			
			ImageView ivFood = (ImageView)vwItem.findViewById(R.id.ivFood);
			ivFood.setImageDrawable(Tool.getDrawableForFoodPic(m_thisActivity.getAssets(), (String)foodInfo.get(Constants.COLUMN_NAME_PicPath)));
			
			LinearLayout llRowFood = (LinearLayout)convertView.findViewById(R.id.llRowFood);
			LinearLayout llToInputFoodAmount = (LinearLayout)vwItem.findViewById(R.id.llToInputFoodAmount);
			ImageButton imgBtnAddFood = (ImageButton)vwItem.findViewById(R.id.imgBtnAddFood);
			if (Constants.InvokerType_FromSearchFood.equals(m_InvokerType)){
				llToInputFoodAmount.setVisibility(View.GONE);
				imgBtnAddFood.setVisibility(View.VISIBLE);
			}else{
				llToInputFoodAmount.setVisibility(View.VISIBLE);
				imgBtnAddFood.setVisibility(View.GONE);
			}
			
			OnClickListenerForInputFoodAmount myOnClickListenerForInputAmount = (OnClickListenerForInputFoodAmount)llRowFood.getTag();
			if (myOnClickListenerForInputAmount == null){
				myOnClickListenerForInputAmount = new OnClickListenerForInputFoodAmount(m_thisActivity,this,m_InvokerType);
				myOnClickListenerForInputAmount.initInputData(position);
				llRowFood.setOnClickListener(myOnClickListenerForInputAmount);
				if (Constants.InvokerType_FromSearchFood.equals(m_InvokerType)){
					imgBtnAddFood.setOnClickListener(myOnClickListenerForInputAmount);
				}
				llRowFood.setTag(myOnClickListenerForInputAmount);
			}else{
				myOnClickListenerForInputAmount.initInputData(position);
			}
			
			return vwItem;
		}
		
		static class OnClickListenerForInputFoodAmount extends OnClickListenerInListItem{
			ActivityBase m_thisActivity;
			BaseAdapter m_listAdapter;
			String m_InvokerType;
			
			public OnClickListenerForInputFoodAmount(ActivityBase thisActivity, BaseAdapter listAdapter,String InvokerType){
				m_thisActivity = thisActivity;
				m_listAdapter = listAdapter;
				m_InvokerType = InvokerType;
			}

			@Override
			public void onClick(View v) {
				showInputDialog();
			}
			void showInputDialog(){
				HashMap<String, Object> foodData = (HashMap<String, Object>)m_listAdapter.getItem(m_rowPos);
				String foodName = (String)foodData.get(Constants.COLUMN_NAME_CnCaption);
				
				DialogHelperSimpleInput myDialogHelperSimpleInput = new DialogHelperSimpleInput(m_thisActivity);
				EditText etInput = myDialogHelperSimpleInput.getInput();
				etInput.setInputType(InputType.TYPE_CLASS_NUMBER);
				String titleDialog = m_thisActivity.getResources().getString(R.string.inputFoodAmount);
				myDialogHelperSimpleInput.prepareDialogAttributes(titleDialog, foodName, null);
				myDialogHelperSimpleInput.setInterfaceWhenConfirmInput(new InterfaceWhenConfirmInput() {
					@Override
					public void onConfirmInput(String input) {
						if (input==null || input.length()==0){
							Tool.ShowMessageByDialog(m_thisActivity, "输入不能为空");
						}else{
							Log.d(LogTag, "onConfirmInput "+input);
							String sInput = input;
							HashMap<String, Object> foodData = (HashMap<String, Object>)m_listAdapter.getItem(m_rowPos); 
							String foodId = (String)foodData.get(Constants.COLUMN_NAME_NDB_No);
							
							MobclickAgent.onEvent(m_thisActivity,Constants.Umeng_Event_AddFoodByClass);
							
							if (Constants.InvokerType_FromSearchFood.equals(m_InvokerType)){
								Intent intent = new Intent(m_thisActivity,ActivityAddFoodChooseList.class);
				            	intent.putExtra(Constants.COLUMN_NAME_NDB_No, foodId);
				            	intent.putExtra(Constants.Key_Amount, Double.parseDouble(input));
				            	intent.putExtra(Constants.IntentParamKey_BackButtonTitle, m_thisActivity.getCurrentTitle());
								intent.putExtra(Constants.IntentParamKey_InvokerType, m_InvokerType);
								m_thisActivity.startActivity(intent);
								return;
							}else{
								Intent intent = new Intent();
				            	intent.putExtra(Constants.COLUMN_NAME_NDB_No, foodId);
				            	intent.putExtra(Constants.Key_Amount, Integer.parseInt(sInput));
				            	m_thisActivity.setResult(IntentResultCode, intent);
				            	m_thisActivity.finish();
				            	return;
							}
						}
					}
				});
				myDialogHelperSimpleInput.show();
			}
		}//class OnClickListenerForInputFoodAmount
		
	}//ListAdapterForFood
    
}













