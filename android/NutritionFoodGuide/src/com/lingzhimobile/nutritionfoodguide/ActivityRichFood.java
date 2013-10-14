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


public class ActivityRichFood extends Activity {
	public static final int IntentResultCode = 1000;
	
	public static final String IntentResultKey_foodIdCol = "foodIdList";
	public static final String IntentResultKey_foodAmountCol = "foodAmountList";
	
	static final String LogTag = "ActivityRichFood";
	

	String m_currentTitle;
	
	String mInvokerType = null;
	String mNutrientId;
	String mNutrientCnCaption;
	double mToSupplyNutrientAmount ;

	ArrayList<HashMap<String, Object>> m_foodsData;


	ListView mListView1;
	Button btnTopRight;
	Button m_btnCancel;
	

	@Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_richfood);
        
        Intent paramIntent = getIntent();
        
        mInvokerType = paramIntent.getStringExtra(Constants.IntentParamKey_InvokerType);
        mNutrientId =  paramIntent.getStringExtra(Constants.COLUMN_NAME_NutrientID);
        mToSupplyNutrientAmount = paramIntent.getDoubleExtra(Constants.Key_Amount, 0);
        mNutrientCnCaption = paramIntent.getStringExtra(Constants.Key_Name);
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
        
        btnTopRight = (Button) findViewById(R.id.btnTopRight);
        btnTopRight.setVisibility(View.INVISIBLE);
        
        m_currentTitle = mNutrientCnCaption;
        TextView tvTitle = (TextView)findViewById(R.id.tvTitle);
        tvTitle.setText(m_currentTitle);
        
//        m_foodsData = new ArrayList<HashMap<String, Object>>();
        DataAccess da = DataAccess.getSingleton(this);
        m_foodsData = da.getRichNutritionFoodForNutrient(mNutrientId, mToSupplyNutrientAmount, false);
        
        TextView textView1 = (TextView)this.findViewById(R.id.textView1);
        textView1.setText(Tool.getStringFromIdWithParams(getResources(), R.string.chooseRichFood,new String[]{mNutrientCnCaption}));
		
		ListView listView1 = (ListView)this.findViewById(R.id.listView1);
		mListView1 = listView1;
		RichFoodAdapter adapter = new RichFoodAdapter();
        listView1.setAdapter(adapter);
//        ListViewEventListener lvEventListener = new ListViewEventListener();
//        listView1.setOnItemClickListener(lvEventListener);
        
        
      
		
        
    }
    
    int getIntAmount(double dAmount){
    	return (int)Math.ceil(dAmount);
    }
    
	class RichFoodAdapter extends BaseAdapter{


		@Override
		public int getCount() {
			return m_foodsData.size();
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
				if (Constants.InvokerType_FromNutrients.equals(mInvokerType)){
					convertView = getLayoutInflater().inflate(R.layout.row_rich_food, null);
				}else{
					convertView = getLayoutInflater().inflate(R.layout.row_rich_food_input, null);
				}
			}
			ImageView ivFood = (ImageView)convertView.findViewById(R.id.ivFood);
			TextView tvFoodName = (TextView)convertView.findViewById(R.id.tvFoodName);
			TextView tvFoodAmount = (TextView)convertView.findViewById(R.id.tvFoodAmount);
			
			HashMap<String, Object> foodInfo = m_foodsData.get(position);
			String foodId = (String)foodInfo.get(Constants.COLUMN_NAME_NDB_No);
			tvFoodName.setText((String)foodInfo.get(Constants.COLUMN_NAME_CnCaption));
			Double foodAmount = (Double)foodInfo.get(Constants.Key_Amount);
			int iAmount = getIntAmount(foodAmount);
			tvFoodAmount.setText(iAmount+"g");
			ivFood.setImageDrawable(Tool.getDrawableForFoodPic(getAssets(), (String)foodInfo.get(Constants.COLUMN_NAME_PicPath)));
			
			if (Constants.InvokerType_FromNutrients.equals(mInvokerType)){
				ImageButton imgBtnAddFood = (ImageButton)convertView.findViewById(R.id.imgBtnAddFood);
				OnClickListenerToAddFoodToList myOnClickListenerToAddFoodToList =  (OnClickListenerToAddFoodToList)imgBtnAddFood.getTag();
				if (myOnClickListenerToAddFoodToList==null){
					myOnClickListenerToAddFoodToList = new OnClickListenerToAddFoodToList();
					myOnClickListenerToAddFoodToList.initInputData(position,foodId,foodAmount);
					imgBtnAddFood.setTag(myOnClickListenerToAddFoodToList);
					imgBtnAddFood.setOnClickListener(myOnClickListenerToAddFoodToList);
				}else{
					myOnClickListenerToAddFoodToList.initInputData(position,foodId,foodAmount);
				}
				
			}else{
				LinearLayout llRowNutrient = (LinearLayout)convertView.findViewById(R.id.llRowNutrient);
				OnClickListenerForInputAmount myOnClickListenerForInputAmount = null;
				myOnClickListenerForInputAmount = (OnClickListenerForInputAmount)llRowNutrient.getTag();
				if (myOnClickListenerForInputAmount == null){
					myOnClickListenerForInputAmount = new OnClickListenerForInputAmount() ;
					myOnClickListenerForInputAmount.initInputData(position);
					llRowNutrient.setTag(myOnClickListenerForInputAmount);
					llRowNutrient.setOnClickListener(myOnClickListenerForInputAmount);
				}else{
					Log.d(LogTag, "reused EditText reuse OnClickListenerForInputAmount");
					myOnClickListenerForInputAmount.initInputData(position);
				}
			}
			
			return convertView;
		}
		
		class OnClickListenerToAddFoodToList extends OnClickListenerInListItem{
			String m_foodId;
			Double m_foodAmount;
			
			@Override
			public void initInputData(int rowPos) {
				throw new RuntimeException("method abandoned");
			}
			
			public void initInputData(int rowPos, String foodId, Double foodAmount){
				super.initInputData(rowPos);
				m_foodId = foodId;
				m_foodAmount = foodAmount;
			}
			
			
			@Override
			public void onClick(View v) {
//				HashMap<String, Object> foodData = m_foodsData.get(m_rowPos);
				int iAmount = getIntAmount(m_foodAmount);
				Intent intent = new Intent(ActivityRichFood.this,ActivityAddFoodChooseList.class);
				intent.putExtra(Constants.IntentParamKey_BackButtonTitle, m_currentTitle);
//				intent.putExtra(ActivityAddFoodChooseList.IntentKey_ActionType, ActivityAddFoodChooseList.ActionType_ToFoodCombination);
            	intent.putExtra(Constants.COLUMN_NAME_NDB_No, m_foodId);
            	intent.putExtra(Constants.Key_Amount, Double.valueOf(iAmount));
				startActivity(intent);

			}
		}//OnClickListenerToAddFoodToList
		
		class OnClickListenerForInputAmount extends OnClickListenerInListItem implements OnTouchListener,OnFocusChangeListener{

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
				HashMap<String, Object> foodData = m_foodsData.get(m_rowPos);
				String foodName = (String)foodData.get(Constants.COLUMN_NAME_CnCaption);
				
				Double foodAmount = (Double)foodData.get(Constants.Key_Amount);
				int iAmount = (int)Math.ceil(foodAmount);
				String preInput = iAmount+"";
				
				DialogHelperSimpleInput myDialogHelperSimpleInput = new DialogHelperSimpleInput(ActivityRichFood.this);
				EditText etInput = myDialogHelperSimpleInput.getInput();
				etInput.setInputType(InputType.TYPE_CLASS_NUMBER);
				String titleDialog = getResources().getString(R.string.inputFoodAmount);
				myDialogHelperSimpleInput.prepareDialogAttributes(titleDialog, foodName, preInput);
				myDialogHelperSimpleInput.setInterfaceWhenConfirmInput(new InterfaceWhenConfirmInput() {
					@Override
					public void onConfirmInput(String input) {
						if (input==null || input.length()==0){
							Tool.ShowMessageByDialog(ActivityRichFood.this, "输入不能为空");
						}else{
							Log.d(LogTag, "onConfirmInput "+input);
							String sInput = input;
							HashMap<String, Object> foodData = m_foodsData.get(m_rowPos);
							String foodId = (String)foodData.get(Constants.COLUMN_NAME_NDB_No);
							
							Intent intent = new Intent();
			            	intent.putExtra(Constants.COLUMN_NAME_NDB_No, foodId);
			            	intent.putExtra(Constants.Key_Amount, Integer.parseInt(sInput));
			            	ActivityRichFood.this.setResult(IntentResultCode, intent);
			            	
			            	ActivityRichFood.this.finish();
						}
					}
				});
				myDialogHelperSimpleInput.show();
			}
		}//class OnClickListenerForInputAmount
		
		
	}//RichFoodAdapter
    
    
    
    
    
}













