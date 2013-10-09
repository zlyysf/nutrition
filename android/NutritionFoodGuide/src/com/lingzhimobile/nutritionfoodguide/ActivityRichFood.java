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
	
	public static final String Key_InvokerType = "InvokerType";
	public static final String InvokerType_FromNutrients = "FromNutrients";
	public static final String InvokerType_FromFoodCombination = "FromFoodCombination";
	
	String mInvokerType = null;
	String mNutrientId;
	String mNutrientCnCaption;
	double mToSupplyNutrientAmount ;

	ArrayList<HashMap<String, Object>> m_foodsData;


	ListView mListView1;
	Button mBtnSave;
	Button m_btnCancel;
	

	@Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_richfood);
        
        Intent paramIntent = getIntent();
        
        mNutrientId =  paramIntent.getStringExtra(Constants.COLUMN_NAME_NutrientID);
        mToSupplyNutrientAmount = paramIntent.getDoubleExtra(Constants.Key_Amount, 0);
        mNutrientCnCaption = paramIntent.getStringExtra(Constants.Key_Name);
        
//        m_foodsData = new ArrayList<HashMap<String, Object>>();
        DataAccess da = DataAccess.getSingleton(this);
        m_foodsData = da.getRichNutritionFoodForNutrient(mNutrientId, mToSupplyNutrientAmount, false);
        
        TextView textView1 = (TextView)this.findViewById(R.id.textView1);
        textView1.setText(Tool.getStringFromIdWithParams(getResources(), R.string.chooseRichFood,new String[]{mNutrientCnCaption}));
		
		ListView listView1 = (ListView)this.findViewById(R.id.listView1);
		mListView1 = listView1;
		RichFoodAdapter adapter = new RichFoodAdapter();
        listView1.setAdapter(adapter);
        ListViewEventListener lvEventListener = new ListViewEventListener();
        listView1.setOnItemClickListener(lvEventListener);
        
      
		m_btnCancel = (Button) findViewById(R.id.btnCancel);
        m_btnCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
//            	Intent intent = new Intent();
//            	intent.putExtra(Constants.COLUMN_NAME_NDB_No, "12345");
//            	intent.putExtra(Constants.Key_Amount, 123.45);
//            	setResult(IntentResultCode, intent);
            	finish();
            	
            }
        });
        
        mBtnSave = (Button) findViewById(R.id.btnReset);
        mBtnSave.setVisibility(View.INVISIBLE);
//        mBtnSave.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//            	ArrayList<String> foodIdList = new ArrayList<String>();
//            	ArrayList<String> foodAmountList = new ArrayList<String>();
//            	for(int i=0; i<m_foodsData.size(); i++){
//            		View rowView = mListView1.getChildAt(i);//MAYBE null pointer
//            		EditText etFoodAmount = (EditText)rowView.findViewById(R.id.etFoodAmount);
//            		String sAmount = etFoodAmount.getText().toString();
//            		if (sAmount.length()>0){
//	            		int iAmount = Integer.parseInt(sAmount);
//	            		if (iAmount > 0){
//	            			HashMap<String, Object> foodInfo = m_foodsData.get(i);
//	            			String foodId = (String)foodInfo.get(Constants.COLUMN_NAME_NDB_No);
//	            			foodIdList.add(foodId);
//	            			foodAmountList.add(iAmount+"");
//	            		}
//            		}
//            	}
//            	
//            	
//            	
//            	Intent intent = new Intent();
//            	intent.putStringArrayListExtra(IntentResultKey_foodIdCol, foodIdList);
//            	intent.putStringArrayListExtra(IntentResultKey_foodAmountCol, foodAmountList);
////            	intent.putExtra(Constants.COLUMN_NAME_NDB_No, "12345");
////            	intent.putExtra(Constants.Key_Amount, 123.45);
//            	setResult(IntentResultCode, intent);
//            	
//            	finish();
//            	
//            }
//        });
        
    }
    
	class ListViewEventListener implements OnItemSelectedListener,OnItemClickListener{

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position,	long id) {
//			HashMap<String, Object> foodInfo = m_foodsData.get(position);
//			
//			Intent intent = new Intent();
//        	intent.putExtra(Constants.COLUMN_NAME_NDB_No, (String)foodInfo.get(Constants.COLUMN_NAME_NDB_No));
//        	intent.putExtra(Constants.Key_Amount, 456.45);
//        	setResult(IntentResultCode, intent);
//        	
//        	finish();
			
		}

		@Override
		public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
		}

		@Override
		public void onNothingSelected(AdapterView<?> parent) {
		}
		
	}
    
    
	class RichFoodAdapter extends BaseAdapter{
		
//		AlertDialog mPrevAlertDialog;

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
		
//		void closePrevAlertDialog(){
//			Log.d(LogTag, "closePrevAlertDialog enter ");
//			if (mPrevAlertDialog!=null){
//				if (mPrevAlertDialog.isShowing()){
//					Log.d(LogTag, "closePrevAlertDialog before mPrevAlertDialog.dismiss "+mPrevAlertDialog);
//					mPrevAlertDialog.dismiss();
//					Log.d(LogTag, "closePrevAlertDialog after  mPrevAlertDialog.dismiss "+mPrevAlertDialog);
//				}else{
//					Log.d(LogTag, "closePrevAlertDialog NOT mPrevAlertDialog.isShowing "+mPrevAlertDialog);
//				}
//				mPrevAlertDialog = null;
//			}
//		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			if (convertView == null){
				convertView = getLayoutInflater().inflate(R.layout.row_rich_food_input, null);
			}
			ImageView ivFood = (ImageView)convertView.findViewById(R.id.ivFood);
			TextView tvFoodName = (TextView)convertView.findViewById(R.id.tvFoodName);
			TextView tvFoodAmount = (TextView)convertView.findViewById(R.id.tvFoodAmount);
			
			HashMap<String, Object> foodInfo = m_foodsData.get(position);
			tvFoodName.setText((String)foodInfo.get(Constants.COLUMN_NAME_CnCaption));
			Double foodAmount = (Double)foodInfo.get(Constants.Key_Amount);
			int iAmount = (int)Math.ceil(foodAmount);
			tvFoodAmount.setText(iAmount+"g");
			ivFood.setImageDrawable(Tool.getDrawableForFoodPic(getAssets(), (String)foodInfo.get(Constants.COLUMN_NAME_PicPath)));
			
//			EditText etFoodAmount = (EditText)convertView.findViewById(R.id.etFoodAmount);
//			Button btnShowInputDialog = (Button)convertView.findViewById(R.id.btnShowInputDialog);//用 imageview 代替 button ,利用上层的 llToInputFoodAmount 的事件处理，而不必像button那样必须加一个

			LinearLayout llRowNutrient = (LinearLayout)convertView.findViewById(R.id.llRowNutrient);
			OnClickListenerForInputAmount myOnClickListenerForInputAmount = null;
			myOnClickListenerForInputAmount = (OnClickListenerForInputAmount)llRowNutrient.getTag();
			if (myOnClickListenerForInputAmount == null){
				myOnClickListenerForInputAmount = new OnClickListenerForInputAmount() ;
				myOnClickListenerForInputAmount.initInputData(position);
				llRowNutrient.setTag(myOnClickListenerForInputAmount);
				llRowNutrient.setOnClickListener(myOnClickListenerForInputAmount);
//				etFoodAmount.setOnClickListener(myOnClickListenerForInputAmount);//在disabled的状态时，看来事件不被触发
//				etFoodAmount.setOnClickListener(myOnClickListenerForInputAmount);//在enabled的状态时，先要获得focus，再点击才能触发onclick事件
//				etFoodAmount.setOnTouchListener(myOnClickListenerForInputAmount);//在disabled的状态时，看来事件不被触发
//				etFoodAmount.setOnFocusChangeListener(myOnClickListenerForInputAmount);//在enabled的状态时，焦点的变换在cancal时会导致死循环
//				btnShowInputDialog.setOnClickListener(myOnClickListenerForInputAmount);
			}else{
				Log.d(LogTag, "reused EditText reuse OnClickListenerForInputAmount");
				myOnClickListenerForInputAmount.initInputData(position);
			}
			
//			etFoodAmount.setEnabled(false);
			
			
			return convertView;
		}
		
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
				myDialogHelperSimpleInput.prepareDialogAttributes("输入食物数量", foodName, preInput);
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
				
//				AlertDialog.Builder dlgBuilder =new AlertDialog.Builder(ActivityRichFood.this);
//				View vwDialogContent = getLayoutInflater().inflate(R.layout.dialog_input_food_amount, null);
//				EditText etAmount = (EditText)vwDialogContent.findViewById(R.id.etAmount);
//				TextView tvFood = (TextView)vwDialogContent.findViewById(R.id.tvFood);
//				HashMap<String, Object> foodData = m_foodsData.get(m_rowPos);
//				String foodName = (String)foodData.get(Constants.COLUMN_NAME_CnCaption);
//				tvFood.setText(foodName);
//				
//				DialogInterfaceEventListener_EditText dialogInterfaceEventListener_EditText1 = new DialogInterfaceEventListener_EditText(etAmount);
//				dlgBuilder.setView(vwDialogContent);
//				dlgBuilder.setPositiveButton("OK", dialogInterfaceEventListener_EditText1);
//				dlgBuilder.setNegativeButton("Cancel", dialogInterfaceEventListener_EditText1);
//				
//				
//				AlertDialog dlg = dlgBuilder.create();
//				
////				closePrevAlertDialog();//Activity  has leaked window 的问题，发现是与ListViewEventListener.onItemClick 中调用了 finish() 有关。
////				mPrevAlertDialog = dlg;
//				
//				dialogInterfaceEventListener_EditText1.SetDialog(dlg);
//				dlg.setOnShowListener(dialogInterfaceEventListener_EditText1);
//				dlg.setOnDismissListener(dialogInterfaceEventListener_EditText1);
//				Log.d(LogTag, "before show AlertDialog "+dlg);
//				dlg.show();
//				Log.d(LogTag, "after  show AlertDialog "+dlg);
				
				
			}
			
//			class DialogInterfaceEventListener_EditText implements DialogInterface.OnClickListener, DialogInterface.OnShowListener, DialogInterface.OnDismissListener{
//				Dialog mDialog;
//				EditText m_editText1;
//				public DialogInterfaceEventListener_EditText(EditText editText1){
//					m_editText1 = editText1;
//				}
//				public void SetDialog(Dialog dlg){
//					mDialog = dlg;
//					
////					m_editText1.setOnFocusChangeListener(new View.OnFocusChangeListener() {
////						@Override
////						public void onFocusChange(View v, boolean hasFocus) {
////							Log.d(LogTag, "DialogInterfaceOnClickListener_EditText m_editText1 onFocusChange, hasFocus="+hasFocus);
////							if (hasFocus) {
////								mDialog.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
////					       }
////						}
////					});
//				}
//				
//				@Override
//				public void onClick(DialogInterface dlgInterface, int which) {
//					if(which == DialogInterface.BUTTON_POSITIVE){
//						Log.d(LogTag, "DialogInterfaceOnClickListener_EditText onClick OK "+mDialog);
//						String sInput = m_editText1.getText().toString();
//						HashMap<String, Object> foodData = m_foodsData.get(m_rowPos);
//						String foodId = (String)foodData.get(Constants.COLUMN_NAME_NDB_No);
//						
//						Intent intent = new Intent();
//		            	intent.putExtra(Constants.COLUMN_NAME_NDB_No, foodId);
//		            	intent.putExtra(Constants.Key_Amount, Integer.parseInt(sInput));
//		            	ActivityRichFood.this.setResult(IntentResultCode, intent);
//		            	
//		            	ActivityRichFood.this.finish();
//					}else if(which == DialogInterface.BUTTON_NEGATIVE){
//						Log.d(LogTag, "DialogInterfaceOnClickListener_EditText onClick Cancel "+mDialog);
//					}else if(which == DialogInterface.BUTTON_NEUTRAL){//忽略按键的点击事件
//						Log.d(LogTag, "DialogInterfaceOnClickListener_EditText onClick Ignore "+mDialog);
//					}else{
//						Log.d(LogTag, "DialogInterfaceOnClickListener_EditText onClick other "+mDialog);
//					}
////					m_editText1 = null;
////	            	mDialog = null;//Activity  has leaked window 的问题，发现是与ListViewEventListener.onItemClick 中调用了 finish() 有关。
//				}
//
//				@Override
//				public void onShow(DialogInterface dlgInterface) {
//					Log.d(LogTag, "DialogInterfaceOnClickListener_EditText onShow "+mDialog);
//					InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
//			        imm.showSoftInput(m_editText1, InputMethodManager.SHOW_IMPLICIT);//能show出键盘
////			        imm.showSoftInput(m_editText1, InputMethodManager.SHOW_FORCED);//能show出键盘
////					m_editText1.requestFocus();
//				}
//				@Override
//				public void onDismiss(DialogInterface dialog) {
//					Log.d(LogTag, "DialogInterfaceOnClickListener_EditText onDismiss "+mDialog+ " | "+dialog);
//					
//				}
//			}//class DialogInterfaceOnClickListener_EditText
			
		}//class OnClickListenerForInputAmount
		
		
	}//RichFoodAdapter
    
    
    
    
    
}













