package com.lingzhimobile.nutritionfoodguide;


import java.util.*;

import com.lingzhimobile.nutritionfoodguide.DialogHelperSimpleInput.InterfaceWhenConfirmInput;


import android.R.integer;
import android.app.Activity;
import android.app.ActivityManager;
import android.app.ActivityManager.RunningTaskInfo;
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


public class ActivityAddFoodChooseList extends Activity {
	
	static final String LogTag = "ActivityAddFoodChooseList";
	
//	public static final String IntentKey_ActionType = "ActionType";
//	public static final String ActionType_ToFoodCombination = "ToFoodCombination";
	
	String m_foodId;
	double m_foodAmount;
	
	ListView m_listView1;
	FoodCombinationAdapter mListAdapter;
	String m_currentTitle;
	
	@Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_addfood_chooselist);
        
        Intent paramIntent = getIntent();
        m_foodId =  paramIntent.getStringExtra(Constants.COLUMN_NAME_NDB_No);
        m_foodAmount = paramIntent.getDoubleExtra(Constants.Key_Amount, 0);
        String prevActvTitle = paramIntent.getStringExtra(Constants.IntentParamKey_BackButtonTitle);
        Button btnCancel = (Button) findViewById(R.id.btnCancel);
        if (prevActvTitle!=null)
        	btnCancel.setText(prevActvTitle);
        btnCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	finish();
            }
        });
        
        m_currentTitle = getResources().getString(R.string.title_addfood_tolist_ornew);
        TextView tv_title = (TextView)this.findViewById(R.id.tvTitle);
        tv_title.setText(m_currentTitle);
		
        Button btn1 = (Button) findViewById(R.id.btnTopRight);
        btn1.setVisibility(View.GONE);
        
        Button btnAddToNew = (Button) findViewById(R.id.btnAddToNew);
        btnAddToNew.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	AddFoodToCollocation(-1);
            }
        });
        
        DataAccess da = DataAccess.getSingleton(this);
        ArrayList<HashMap<String, Object>> foodCollocationList = da.getAllFoodCollocation();
        mListAdapter = new FoodCombinationAdapter(foodCollocationList);
        m_listView1 = (ListView)this.findViewById(R.id.listView1);
		m_listView1.setAdapter(mListAdapter);
    }
	

	private void AddFoodToCollocation(long collocationId){
//		//i=0, numActivities=4, topActivity=com.lingzhimobile.nutritionfoodguide.ActivityAddFoodChooseList, baseActivity=com.lingzhimobile.nutritionfoodguide.ActivityHome
//		//i=1, numActivities=1, topActivity=com.android.launcher2.Launcher, baseActivity=com.android.launcher2.Launcher
		Tool.printActivityStack(this);
		
		Intent intent = new Intent(ActivityAddFoodChooseList.this, ActivityHome.class);
//		Intent intent = new Intent(ActivityAddFoodChooseList.this, ActivityT1.class);
		intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);// (Intent.FLAG_ACTIVITY_CLEAR_TASK);// (Intent.FLAG_ACTIVITY_CLEAR_TOP);
		intent.putExtra(Constants.COLUMN_NAME_CollocationId, collocationId);
		intent.putExtra(Constants.COLUMN_NAME_NDB_No, m_foodId);
    	intent.putExtra(Constants.Key_Amount, m_foodAmount);
		startActivity(intent);
//		finish();
		//here . Intent.FLAG_ACTIVITY_CLEAR_TOP
//		i=0, numActivities=4, topActivity=com.lingzhimobile.nutritionfoodguide.ActivityAddFoodChooseList, baseActivity=com.lingzhimobile.nutritionfoodguide.ActivityHome
//		i=1, numActivities=1, topActivity=com.android.launcher2.Launcher, baseActivity=com.android.launcher2.Launcher
		// but in ActivityHome, onCreate . and if back button on device clicked, no any activity show , despite of above finish() invoked. But it conforms the definition of FLAG_ACTIVITY_CLEAR_TOP in some way.
//		i=0, numActivities=2, topActivity=com.lingzhimobile.nutritionfoodguide.ActivityHome, baseActivity=com.lingzhimobile.nutritionfoodguide.ActivityAddFoodChooseList
//		i=1, numActivities=1, topActivity=com.android.launcher2.Launcher, baseActivity=com.android.launcher2.Launcher
		
		//but if ActivityT1 . Intent.FLAG_ACTIVITY_CLEAR_TOP
//		i=0, numActivities=4, topActivity=com.lingzhimobile.nutritionfoodguide.ActivityAddFoodChooseList, baseActivity=com.lingzhimobile.nutritionfoodguide.ActivityHome
//		i=1, numActivities=1, topActivity=com.android.launcher2.Launcher, baseActivity=com.android.launcher2.Launcher
//		ActivityT1 onCreate savedInstanceState=null
//		i=0, numActivities=5, topActivity=com.lingzhimobile.nutritionfoodguide.ActivityT1, baseActivity=com.lingzhimobile.nutritionfoodguide.ActivityHome
//		i=1, numActivities=1, topActivity=com.android.launcher2.Launcher, baseActivity=com.android.launcher2.Launcher

		//ActivityHome . Intent.FLAG_ACTIVITY_CLEAR_TASK
//		i=0, numActivities=4, topActivity=com.lingzhimobile.nutritionfoodguide.ActivityAddFoodChooseList, baseActivity=com.lingzhimobile.nutritionfoodguide.ActivityHome
//		i=1, numActivities=1, topActivity=com.android.launcher2.Launcher, baseActivity=com.android.launcher2.Launcher
//		ActivityHome.onCreate
//		i=0, numActivities=5, topActivity=com.lingzhimobile.nutritionfoodguide.ActivityHome, baseActivity=com.lingzhimobile.nutritionfoodguide.ActivityHome
//		i=1, numActivities=1, topActivity=com.android.launcher2.Launcher, baseActivity=com.android.launcher2.Launcher
	}
    
	class FoodCombinationAdapter extends BaseAdapter{
		ArrayList<HashMap<String, Object>> m_foodCollocationList;
		public FoodCombinationAdapter(ArrayList<HashMap<String, Object>> foodCollocationList){
			m_foodCollocationList = foodCollocationList;
		}

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
		public View getView(int position, View convertView, ViewGroup parent) {
			if (convertView == null){
				convertView = getLayoutInflater().inflate(R.layout.row_foodcombination, null);
			}

			HashMap<String, Object> foodCollocationInfo = m_foodCollocationList.get(position);
			
			TextView tvFoodCombinationName = (TextView)convertView.findViewById(R.id.tvFoodCombinationName);
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
			imgBtnRemoveFoodCombination.setVisibility(View.GONE);
			ImageButton imgBtnChangeName = (ImageButton)convertView.findViewById(R.id.imgBtnChangeName);
			imgBtnChangeName.setVisibility(View.GONE);
			
			return convertView;
		}
		
		class OnRowClickListener extends OnClickListenerInListItem{
			@Override
			public void onClick(View v) {
				HashMap<String, Object> foodCollocationInfo = m_foodCollocationList.get(m_rowPos);
				Double obj_collocationId = (Double)foodCollocationInfo.get(Constants.COLUMN_NAME_CollocationId);
				long collocationId = obj_collocationId.longValue();
				
				AddFoodToCollocation(collocationId);
			}
		}//class OnRowClickListener
	}//FoodCombinationAdapter
}













