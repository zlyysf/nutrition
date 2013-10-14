package com.lingzhimobile.nutritionfoodguide;


import java.util.*;


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
import android.text.Selection;
import android.text.Spannable;
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
import android.widget.RadioGroup.OnCheckedChangeListener;
import android.widget.ExpandableListView.*;


public class ActivityUserProfile extends Activity {
	
	static final String LogTag = "ActivityUserProfile";
	
	TextView m_tvTitle;
	Button m_btnCancel,mBtnSave;
	
	RadioGroup m_radioGroupSex,m_radioGroupActiveLevel;
	RadioButton m_rbMale, m_rbFemale, m_rbLevelLight, m_rbLevelMid, m_rbLevelStrong, m_rbLevelVeryStrong;
	EditText m_etAge, m_etHeight, m_etWeight;
	

	
	

	@Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_user_profile);
        
        initViewHandles();
        initViewsContent();
        
//        Intent paramIntent = getIntent(); 
//        mNutrientId =  paramIntent.getStringExtra(Constants.COLUMN_NAME_NutrientID);
//        mToSupplyNutrientAmount = paramIntent.getDoubleExtra(Constants.Key_Amount, 0);
        
//        TextView tvBasicInfo = (TextView)findViewById(R.id.tvBasicInfo);
//        tvBasicInfo.requestFocus();//没用，还是要出键盘 
//        InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
//		imm.hideSoftInputFromWindow(getCurrentFocus().getWindowToken(),0);// NullPointerException
//        imm.hideSoftInputFromWindow(m_etAge.getWindowToken(),0);////没用，还是要出键盘 
        /*
         * 在 AndroidManifest.xml 中 设置 <activity> 的 android:windowSoftInputMode="adjustUnspecified|stateHidden" 
         * 可以使进入activity后不自动弹出键盘，但焦点还在编辑框 
         */
        		

        setViewsContent();
        setViewEventHandlers();
    }
	@Override
	protected void onStart() {
        super.onStart();
//        InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
//		imm.hideSoftInputFromWindow(getCurrentFocus().getWindowToken(),0);//NullPointerException
//        imm.hideSoftInputFromWindow(m_etAge.getWindowToken(),0);//没用，还是要出键盘 
    }
	
	
	void initViewHandles(){
		m_tvTitle = (TextView)findViewById(R.id.tvTitle);
		mBtnSave = (Button) findViewById(R.id.btnTopRight);
        m_btnCancel = (Button) findViewById(R.id.btnCancel);
        
		m_radioGroupSex = (RadioGroup)this.findViewById(R.id.radioGroupSex);
        m_etAge = (EditText)this.findViewById(R.id.etAge);
        m_etHeight = (EditText)this.findViewById(R.id.etHeight);
        m_etWeight = (EditText)this.findViewById(R.id.etWeight);
        m_radioGroupActiveLevel = (RadioGroup)this.findViewById(R.id.radioGroupActiveLevel);
        
        m_rbMale = (RadioButton)this.findViewById(R.id.rbMale);
        m_rbFemale = (RadioButton)this.findViewById(R.id.rbFemale);
        m_rbLevelLight = (RadioButton)this.findViewById(R.id.rbLevelLight);
        m_rbLevelMid = (RadioButton)this.findViewById(R.id.rbLevelMid);
        m_rbLevelStrong = (RadioButton)this.findViewById(R.id.rbLevelStrong);
        m_rbLevelVeryStrong = (RadioButton)this.findViewById(R.id.rbLevelVeryStrong);
        
	}
	void initViewsContent(){

		Intent paramIntent = getIntent();
        String prevActvTitle = paramIntent.getStringExtra(Constants.IntentParamKey_BackButtonTitle);
        if (prevActvTitle!=null)
        	m_btnCancel.setText(prevActvTitle);
        
		 m_tvTitle.setText(R.string.title_userinfo);
	     mBtnSave.setText(R.string.save);
	}
	void setViewEventHandlers(){
        m_radioGroupSex.setOnCheckedChangeListener(new OnCheckedChangeListener() {
			
			@Override
			public void onCheckedChanged(RadioGroup group, int checkedId) {
//				int radioButtonId = group.getCheckedRadioButtonId();
//				RadioButton rb = (RadioButton)ActivityUserProfile.this.findViewById(radioButtonId);
				
			}
		});
        
        
        mBtnSave.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	saveViewsContent();
            	finish();
            }
        });
        
		
        m_btnCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	finish();
            }
        });
        
//        OnFocusChangeListenerToSetCursorAtEnd myOnFocusChangeListenerToSetCursorAtEnd = new OnFocusChangeListenerToSetCursorAtEnd();
//        m_etAge.setOnFocusChangeListener(myOnFocusChangeListenerToSetCursorAtEnd);//没能把光标移到末尾
//        m_etHeight.setOnFocusChangeListener(myOnFocusChangeListenerToSetCursorAtEnd);
//        m_etWeight.setOnFocusChangeListener(myOnFocusChangeListenerToSetCursorAtEnd);
	}
	
//	class OnFocusChangeListenerToSetCursorAtEnd implements OnFocusChangeListener{
//		@Override
//		public void onFocusChange(View v, boolean hasFocus) {
//			Log.d(LogTag, "OnFocusChangeListenerToSetCursorAtEnd.onFocusChange hasFocus="+hasFocus + ", v.hasFocus="+v.hasFocus());
//			if (hasFocus){
//				EditText et = (EditText)v;
//				if (et != null){
//					CharSequence text = et.getText();
//			        if (text instanceof Spannable) {
//			        	Log.d(LogTag, "OnFocusChangeListenerToSetCursorAtEnd.onFocusChange text instanceof Spannable");
//			            Spannable spanText = (Spannable)text;
//			            Selection.setSelection(spanText, text.length());
//			        }else{
//			        	Log.d(LogTag, "OnFocusChangeListenerToSetCursorAtEnd.onFocusChange NOT text instanceof Spannable");
//			        }
//				}
//			}
//		}
//	}
	
	void setViewsContent(){
		HashMap<String, Object> userInfo = StoredConfigTool.getUserInfo(this);
        Integer intObj_sex = (Integer)userInfo.get(Constants.ParamKey_sex);
		Integer intObj_age = (Integer)userInfo.get(Constants.ParamKey_age);
		Double dblObj_weight = (Double)userInfo.get(Constants.ParamKey_weight);
		Double dblObj_height = (Double)userInfo.get(Constants.ParamKey_height);
		Integer intObj_activityLevel = (Integer)userInfo.get(Constants.ParamKey_activityLevel);
		
		m_etAge.setText(intObj_age.toString());
		m_etHeight.setText(dblObj_height.intValue()+"");
		m_etWeight.setText(dblObj_weight.intValue()+"");
		
		if (Constants.Value_sex_female == intObj_sex.intValue()){
			m_rbFemale.setChecked(true);
		}else{
			m_rbMale.setChecked(true);
		}
		if (Constants.Value_activityLevel_middle == intObj_activityLevel.intValue()){
			m_rbLevelMid.setChecked(true);
		}else if (Constants.Value_activityLevel_strong == intObj_activityLevel.intValue()){
			m_rbLevelStrong.setChecked(true);
		}else if (Constants.Value_activityLevel_veryStrong == intObj_activityLevel.intValue()){
			m_rbLevelVeryStrong.setChecked(true);
		}else {
			m_rbLevelLight.setChecked(true);
		}
	}
	void saveViewsContent(){
		int age = Integer.parseInt(m_etAge.getText().toString());
    	double height = Double.parseDouble(m_etHeight.getText().toString());
    	double weight = Double.parseDouble(m_etWeight.getText().toString());
    	int sex = Constants.Value_sex_male;
    	if (m_rbFemale.isChecked()){
    		sex = Constants.Value_sex_female;
    	}
    	int activityLevel = Constants.Value_activityLevel_light;
    	if (m_rbLevelMid.isChecked()){
    		activityLevel = Constants.Value_activityLevel_middle;
    	}else if (m_rbLevelStrong.isChecked()){
    		activityLevel = Constants.Value_activityLevel_strong;
    	}else if (m_rbLevelVeryStrong.isChecked()){
    		activityLevel = Constants.Value_activityLevel_veryStrong;
    	}
    	HashMap<String, Object> hmUserInfo = new HashMap<String, Object>();
		hmUserInfo.put(Constants.ParamKey_sex, Integer.valueOf(sex));
		hmUserInfo.put(Constants.ParamKey_age, Integer.valueOf(age));
		hmUserInfo.put(Constants.ParamKey_weight, Double.valueOf(weight));
		hmUserInfo.put(Constants.ParamKey_height, Double.valueOf(height));
		hmUserInfo.put(Constants.ParamKey_activityLevel, Integer.valueOf(activityLevel));
		StoredConfigTool.saveUserInfo(ActivityUserProfile.this, hmUserInfo);
	}
    
    
    
    
}













