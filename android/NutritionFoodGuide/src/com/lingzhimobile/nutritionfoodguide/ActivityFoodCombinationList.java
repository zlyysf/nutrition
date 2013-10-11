package com.lingzhimobile.nutritionfoodguide;


import java.util.*;

import com.lingzhimobile.nutritionfoodguide.DialogHelperSimpleInput.InterfaceWhenConfirmInput;


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


public class ActivityFoodCombinationList extends Activity {
	
	static final String LogTag = "ActivityFoodCombinationList";
	
	public static final String IntentKey_aim = "aim";
	public static final String IntentValue_aim_EditItem = "EditItem";
	
	public static final int IntentRequestCode_ActivityFoodCombination = 100;

	ArrayList<HashMap<String, Object>> m_foodCollocationList;


	ListView mListView1;
	Button mBtnNew;
	Button m_btnCancel;
	
	FoodCombinationAdapter mListAdapter;
	String m_currentTitle;
	

	@Override
    protected void onCreate(Bundle savedInstanceState) {
		Log.d(LogTag, "onCreate savedInstanceState="+savedInstanceState);
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_foodcombination_list);
        
        Intent paramIntent = getIntent();
        String prevActvTitle = paramIntent.getStringExtra(Constants.IntentParamKey_BackButtonTitle);
        m_btnCancel = (Button) findViewById(R.id.btnCancel);
        if (prevActvTitle!=null)
        	m_btnCancel.setText(prevActvTitle);
        m_btnCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	finish();
            }
        });
        
        DataAccess da = DataAccess.getSingleton(this);
        m_foodCollocationList = da.getAllFoodCollocation();
        
        m_currentTitle = getResources().getString(R.string.title_foodCombinationList);
        TextView tvTitle = (TextView) findViewById(R.id.tvTitle);
        tvTitle.setText(m_currentTitle);
		
        mBtnNew = (Button) findViewById(R.id.btnTopRight);
        mBtnNew.setText(R.string.add);
        mBtnNew.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	Intent intent = new Intent(ActivityFoodCombinationList.this, ActivityFoodCombination.class);
            	intent.putExtra(Constants.IntentParamKey_BackButtonTitle, m_currentTitle);
				startActivityForResult(intent,IntentRequestCode_ActivityFoodCombination);
            }
        });
        
        mListView1 = (ListView)this.findViewById(R.id.listView1);
		mListAdapter = new FoodCombinationAdapter();
		mListView1.setAdapter(mListAdapter);
		
		dealParamIntent();
    }
	
	void dealParamIntent(){
		Tool.printActivityStack(this);
		
		Intent paramIntent = getIntent();
		Log.d(LogTag, "dealParamIntent paramIntent="+paramIntent);
		if (paramIntent != null){
			String aim = paramIntent.getStringExtra(IntentKey_aim);
			long collocationId = paramIntent.getLongExtra(Constants.COLUMN_NAME_CollocationId, -1);
			String foodId = paramIntent.getStringExtra(Constants.COLUMN_NAME_NDB_No);
			double foodAmount = paramIntent.getDoubleExtra(Constants.Key_Amount, 0);
			
			if (IntentValue_aim_EditItem.equals(aim)){
				Intent intent2 = new Intent(this, ActivityFoodCombination.class);
				intent2.putExtra(Constants.IntentParamKey_BackButtonTitle, m_currentTitle);//
				intent2.putExtra(Constants.COLUMN_NAME_CollocationId, collocationId);
				intent2.putExtra(Constants.COLUMN_NAME_NDB_No, foodId);
		    	intent2.putExtra(Constants.Key_Amount, foodAmount);
				startActivityForResult(intent2,IntentRequestCode_ActivityFoodCombination);
			}
		}
	}
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data)
	{
		super.onActivityResult(requestCode, resultCode, data);
		switch (requestCode)
		{
			case IntentRequestCode_ActivityFoodCombination:
				switch (resultCode)
				{
					case ActivityFoodCombination.IntentResultCode:

						DataAccess da = DataAccess.getSingleton(this);
				        m_foodCollocationList = da.getAllFoodCollocation();
						mListAdapter.notifyDataSetChanged();
//						mListView1.invalidate();
						break;
					default:
						break;
				}
				break;
			default:
				break;
		}
	}

    
    
	class FoodCombinationAdapter extends BaseAdapter{
		
//		AlertDialog mPrevAlertDialog;

		@Override
		public int getCount() {
			return m_foodCollocationList == null? 0 : m_foodCollocationList.size();
		}

		@Override
		public Object getItem(int position) {
			return m_foodCollocationList.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}
		
		@Override
		public void notifyDataSetChanged(){
			super.notifyDataSetChanged();
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			if (convertView == null){
				convertView = getLayoutInflater().inflate(R.layout.row_foodcombination, null);
			}

			TextView tvFoodCombinationName = (TextView)convertView.findViewById(R.id.tvFoodCombinationName);
			
			HashMap<String, Object> foodCollocationInfo = m_foodCollocationList.get(position);
			tvFoodCombinationName.setText((String)foodCollocationInfo.get(Constants.COLUMN_NAME_CollocationName));
			
			LinearLayout llFoodCollocation = (LinearLayout)convertView.findViewById(R.id.llFoodCollocation);
			OnRowClickListener myOnRowClickListener = (OnRowClickListener)llFoodCollocation.getTag();
			if (myOnRowClickListener == null){
				myOnRowClickListener = new OnRowClickListener() ;
				myOnRowClickListener.initInputData(position);
				llFoodCollocation.setTag(myOnRowClickListener);
				llFoodCollocation.setOnClickListener(myOnRowClickListener);
			}else{
				Log.d(LogTag, "reused EditText reuse OnClickListenerForInputAmount");
				myOnRowClickListener.initInputData(position);
			}
			
			ImageButton imgBtnRemoveFoodCombination = (ImageButton)convertView.findViewById(R.id.imgBtnRemoveFoodCombination);
			OnClickListenerToDeleteRow myOnClickListenerToDeleteRow = (OnClickListenerToDeleteRow)imgBtnRemoveFoodCombination.getTag();
			if (myOnClickListenerToDeleteRow == null){
				myOnClickListenerToDeleteRow = new OnClickListenerToDeleteRow();
				myOnClickListenerToDeleteRow.initInputData(position);
				imgBtnRemoveFoodCombination.setTag(myOnClickListenerToDeleteRow);
				imgBtnRemoveFoodCombination.setOnClickListener(myOnClickListenerToDeleteRow);
			}else{
				myOnClickListenerToDeleteRow.initInputData(position);
			}
			
			ImageButton imgBtnChangeName = (ImageButton)convertView.findViewById(R.id.imgBtnChangeName);
			OnClickListenerToChangeName myOnClickListenerToChangeName = (OnClickListenerToChangeName)imgBtnChangeName.getTag();
			if (myOnClickListenerToChangeName == null){
				myOnClickListenerToChangeName = new OnClickListenerToChangeName();
				myOnClickListenerToChangeName.initInputData(position);
				imgBtnChangeName.setTag(myOnClickListenerToChangeName);
				imgBtnChangeName.setOnClickListener(myOnClickListenerToChangeName);
			}else{
				myOnClickListenerToChangeName.initInputData(position);
			}

			return convertView;
		}
		
		class OnClickListenerToChangeName extends OnClickListenerInListItem{
			@Override
			public void onClick(View v) {
				HashMap<String, Object> foodCollocationInfo = m_foodCollocationList.get(m_rowPos);
				String collocationName = (String)foodCollocationInfo.get(Constants.COLUMN_NAME_CollocationName);
				
				DialogHelperSimpleInput myDialogHelperSimpleInput = new DialogHelperSimpleInput(ActivityFoodCombinationList.this);
				myDialogHelperSimpleInput.prepareDialogAttributes("更改名称", "填一个你更喜欢的名称吧！", collocationName);
				myDialogHelperSimpleInput.setInterfaceWhenConfirmInput(new InterfaceWhenConfirmInput() {
					
					@Override
					public void onConfirmInput(String input) {
						if (input==null || input.length()==0){
							Tool.ShowMessageByDialog(ActivityFoodCombinationList.this, "输入不能为空");
						}else{
							HashMap<String, Object> foodCollocationInfo = m_foodCollocationList.get(m_rowPos);
							Double obj_collocationId = (Double)foodCollocationInfo.get(Constants.COLUMN_NAME_CollocationId);
							long collocationId = obj_collocationId.longValue();
							
							String newCollocationName = input;
							
							DataAccess da = DataAccess.getSingleton();
							da.updateFoodCollocationName(newCollocationName, collocationId);
							
							m_foodCollocationList = da.getAllFoodCollocation();
							notifyDataSetChanged();
						}
					}
				});
				myDialogHelperSimpleInput.show();
				
			}
		}//OnClickListenerToChangeName
		
		class OnClickListenerToDeleteRow extends OnClickListenerInListItem{
			@Override
			public void onClick(View v) {
				HashMap<String, Object> foodCollocationInfo = m_foodCollocationList.get(m_rowPos);
				Double obj_collocationId = (Double)foodCollocationInfo.get(Constants.COLUMN_NAME_CollocationId);
				long collocationId = obj_collocationId.longValue();
				
				DataAccess da = DataAccess.getSingleton();
		        da.deleteFoodCollocationData_withCollocationId(collocationId);
				
				m_foodCollocationList = da.getAllFoodCollocation();
				notifyDataSetChanged();
			}
		}//OnClickListenerToDeleteRow
		
		class OnRowClickListener extends OnClickListenerInListItem{
			@Override
			public void onClick(View v) {
				HashMap<String, Object> foodCollocationInfo = m_foodCollocationList.get(m_rowPos);
				Double obj_collocationId = (Double)foodCollocationInfo.get(Constants.COLUMN_NAME_CollocationId);
				long collocationId = obj_collocationId.longValue();
				
				Intent intent = new Intent(ActivityFoodCombinationList.this, ActivityFoodCombination.class);
				intent.putExtra(Constants.IntentParamKey_BackButtonTitle, m_currentTitle);
				intent.putExtra(Constants.COLUMN_NAME_CollocationId, collocationId);
				startActivityForResult(intent,IntentRequestCode_ActivityFoodCombination);
			}
		}//class OnRowClickListener
		
		
	}//FoodCombinationAdapter
    
    
    
    
    
}













