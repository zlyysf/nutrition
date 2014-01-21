package com.lingzhimobile.nutritionfoodguide.v3.fragment;

import java.util.*;


import android.R.bool;
import android.app.*;
import android.content.Context;

import android.os.Bundle;
import android.os.Parcelable;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.*;

import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.*;
import android.widget.RadioGroup.OnCheckedChangeListener;


import com.lingzhimobile.nutritionfoodguide.Constants;
import com.lingzhimobile.nutritionfoodguide.R;
import com.lingzhimobile.nutritionfoodguide.StoredConfigTool;
import com.lingzhimobile.nutritionfoodguide.Tool;
import com.lingzhimobile.nutritionfoodguide.v3.activity.V3ActivityHome;

public class V3SettingFragment extends V3BaseHeadFragment {
    static final String LogTag = V3SettingFragment.class.getSimpleName();

    Date m_birthday;
    
    TextView birthdayTextView;//in fact EditText
    TextView m_tvActivityLevelDescription;
    EditText heightTextView, weightTextView;
    RadioGroup genderRadioGroup, intensityRadioGroup;
    RadioButton maleRadioButton, femaleRadioButton, intensity1RadioButton, intensity2RadioButton, intensity3RadioButton, intensity4RadioButton;
    
    Button m_btnSave;
	TextView m_tvTitle;
	
	boolean m_isInInit = false;
	boolean m_anyDataHasChanged = false;

    @Override
    public void onCreate(Bundle savedInstanceState) {
    	Log.d(LogTag, "onCreate enter");
        super.onCreate(savedInstanceState);
        Log.d(LogTag, "onCreate exit");
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
    	Log.d(LogTag, "onCreateView");
        View view = inflater.inflate(R.layout.v3_fragment_setting, container, false);
        
        m_isInInit = true;
        
        initViewHandles(inflater, view);
        initViewsContent();
        setViewEventHandlers();
        setViewsContent();
        
        return view;
    }

    public static Fragment newInstance(int arg0) {
        Fragment settingFragment = new V3SettingFragment();
        return settingFragment;
    }
    


    @Override
    public void onActivityCreated (Bundle savedInstanceState){
		Log.d(LogTag, "onActivityCreated enter");
		super.onActivityCreated(savedInstanceState);
		Log.d(LogTag, "onActivityCreated exit");
	}
    
    //final void restoreViewState(android.os.Bundle savedInstanceState);
	
	public void onViewStateRestored (Bundle savedInstanceState){
		//super.restoreViewState(null) should be called before.在这里会导致 OnPageChangeListener.onPageSelected 被调用
		Log.d(LogTag, "onViewStateRestored enter");
		
		super.onViewStateRestored(savedInstanceState);
		m_isInInit = false;
		Log.d(LogTag, "onViewStateRestored exit m_anyDataHasChanged="+m_anyDataHasChanged);
		
		setSaveButtonEnabled(m_anyDataHasChanged);
		
	}
    public void onStart() {
		Log.d(LogTag, "onStart begin");
		super.onStart();
		Log.d(LogTag, "onStart exit");
	}
    public void onResume() {
    	Log.d(LogTag, "onResume begin");
		super.onResume();
		Log.d(LogTag, "onResume exit");
	}
    
    //not be called when switch tabs, seemed no use
    public void onSaveInstanceState (Bundle outState){
    	Log.d(LogTag, "onSaveInstanceState begin");
		super.onSaveInstanceState(outState);
		Log.d(LogTag, "onSaveInstanceState exit");
    }
    
	public void onPause() {
		Log.d(LogTag, "onPause");
		super.onPause();
	}
    public void onStop() {
		Log.d(LogTag, "onStop");
		super.onStop();
	}

    @Override
    protected void setHeader() {

    }
    
    void initViewHandles(LayoutInflater inflater, View view){
    	initHeaderLayout(view);

        m_tvTitle = (TextView) view.findViewById(R.id.titleText);
        m_tvTitle.setText(R.string.tabCaption_info);
    	m_btnSave = (Button) view.findViewById(R.id.rightButton);
    	m_btnSave.setText(R.string.save);
    	Button leftButton = (Button) view.findViewById(R.id.leftButton);
    	leftButton.setVisibility(View.GONE);
    	
        birthdayTextView = (TextView) view.findViewById(R.id.birthdayTextView);
        heightTextView = (EditText) view.findViewById(R.id.heightTextView);
        weightTextView = (EditText) view.findViewById(R.id.weightTextView);
        genderRadioGroup = (RadioGroup) view.findViewById(R.id.genderRadioGroup);
        intensityRadioGroup = (RadioGroup) view.findViewById(R.id.intensityRadioGroup);
        maleRadioButton = (RadioButton) view.findViewById(R.id.maleRadioButton);
        femaleRadioButton = (RadioButton) view.findViewById(R.id.femaleRadioButton);
        intensity1RadioButton = (RadioButton) view.findViewById(R.id.intensity1RadioButton);
        intensity2RadioButton = (RadioButton) view.findViewById(R.id.intensity2RadioButton);
        intensity3RadioButton = (RadioButton) view.findViewById(R.id.intensity3RadioButton);
        intensity4RadioButton = (RadioButton) view.findViewById(R.id.intensity4RadioButton);
        
        m_tvActivityLevelDescription = (TextView) view.findViewById(R.id.tvActivityLevelDescription);

    }
    void initViewsContent(){
    	
    }
    
    void setViewEventHandlers(){
    	m_btnSave.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
            	Log.d(LogTag, "btnSave onClick");
                HashMap<String, Object> userInfo = new HashMap<String, Object>();
//                userInfo.put(Constants.ParamKey_age,Integer.parseInt(birthdayTextView.getText().toString()));
                userInfo.put(Constants.ParamKey_birthday, m_birthday);
                userInfo.put(Constants.ParamKey_height,
                        Double.parseDouble(heightTextView.getText().toString()));
                userInfo.put(Constants.ParamKey_weight,
                        Double.parseDouble(weightTextView.getText().toString()));
                
                int sex = Constants.Value_sex_male;
            	if (femaleRadioButton.isChecked()){
            		sex = Constants.Value_sex_female;
            	}
                userInfo.put(Constants.ParamKey_sex, sex);
                
                
                int activityLevel = Constants.Value_activityLevel_light;
                if (intensity1RadioButton.isChecked()){
                	activityLevel = Constants.Value_activityLevel_light;
                }else if (intensity2RadioButton.isChecked()){
                	activityLevel = Constants.Value_activityLevel_middle;
                }else if (intensity3RadioButton.isChecked()){
                	activityLevel = Constants.Value_activityLevel_strong;
                }else if (intensity4RadioButton.isChecked()){
                	activityLevel = Constants.Value_activityLevel_veryStrong;
                }
                userInfo.put(Constants.ParamKey_activityLevel, activityLevel);
                StoredConfigTool.saveUserInfo(getActivity(), userInfo);
                
                m_anyDataHasChanged = false;
                setSaveButtonEnabled(m_anyDataHasChanged);
            }
        });
        

        birthdayTextView.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				DatePickerDialog_OnDateSetListener DatePickerDialog_OnDateSetListener1 = new DatePickerDialog_OnDateSetListener(birthdayTextView);
				Calendar cal = Calendar.getInstance();
				cal.setTime(m_birthday);
				DatePickerDialog DatePickerDialog1 = new DatePickerDialog(getActivity(),DatePickerDialog_OnDateSetListener1,
						cal.get(Calendar.YEAR),cal.get(Calendar.MONTH),cal.get(Calendar.DAY_OF_MONTH));
				DatePickerDialog1.show();
			}
		});
        
        intensityRadioGroup.setOnCheckedChangeListener(new OnCheckedChangeListener() {
			
			@Override
			public void onCheckedChanged(RadioGroup group, int checkedId) {
				Log.d(LogTag, "intensityRadioGroup onCheckedChanged enter, m_isInInit="+m_isInInit+", m_anyDataHasChanged="+m_anyDataHasChanged);
				if (checkedId==R.id.intensity1RadioButton){
					m_tvActivityLevelDescription.setText(R.string.ActivityLevelDescription0);
				}else if (checkedId==R.id.intensity2RadioButton){
					m_tvActivityLevelDescription.setText(R.string.ActivityLevelDescription1);
				}else if (checkedId==R.id.intensity3RadioButton){
					m_tvActivityLevelDescription.setText(R.string.ActivityLevelDescription2);
				}else if (checkedId==R.id.intensity4RadioButton){
					m_tvActivityLevelDescription.setText(R.string.ActivityLevelDescription3);
				}
				
				if (m_isInInit){
		    		//do nothing
		    	}else{
		    		m_anyDataHasChanged = true;
					setSaveButtonEnabled(m_anyDataHasChanged);
		    	}
				Log.d(LogTag, "intensityRadioGroup onCheckedChanged exit, m_isInInit="+m_isInInit+", m_anyDataHasChanged="+m_anyDataHasChanged);
			}
		});
        
        genderRadioGroup.setOnCheckedChangeListener(new OnCheckedChangeListener() {
			@Override
			public void onCheckedChanged(RadioGroup group, int checkedId) {
				Log.d(LogTag, "genderRadioGroup onCheckedChanged enter, m_isInInit="+m_isInInit+", m_anyDataHasChanged="+m_anyDataHasChanged);
				if (m_isInInit){
		    		//do nothing
		    	}else{
		    		m_anyDataHasChanged = true;
					setSaveButtonEnabled(m_anyDataHasChanged);
		    	}
				Log.d(LogTag, "genderRadioGroup onCheckedChanged exit, m_isInInit="+m_isInInit+", m_anyDataHasChanged="+m_anyDataHasChanged);
			}
		});
        
        TextWatcher TextWatcher1 = new TextWatcher() {
			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
				Log.d(LogTag, "onTextChanged enter, m_isInInit="+m_isInInit+", m_anyDataHasChanged="+m_anyDataHasChanged);
//				Tool.printStackTrace(LogTag);

				if (m_isInInit){
		    		//do nothing
		    	}else{
		    		m_anyDataHasChanged = true;
					setSaveButtonEnabled(m_anyDataHasChanged);
		    	}
				Log.d(LogTag, "onTextChanged exit, m_isInInit="+m_isInInit+", m_anyDataHasChanged="+m_anyDataHasChanged);
			}
			@Override
			public void beforeTextChanged(CharSequence s, int start, int count, int after) {
			}
			@Override
			public void afterTextChanged(Editable s) {
			}
		};
        heightTextView.addTextChangedListener(TextWatcher1);
        weightTextView.addTextChangedListener(TextWatcher1);
    }
    void setViewsContent(){
    	HashMap<String, Object> userInfo = StoredConfigTool.getUserInfo(getActivity());
        m_birthday = (Date)userInfo.get(Constants.ParamKey_birthday);
        String strDt = formatDate(getActivity(), m_birthday);
        birthdayTextView.setText(strDt);

        Double dbl_height = (Double)userInfo.get(Constants.ParamKey_height);
        Double dbl_weight = (Double)userInfo.get(Constants.ParamKey_weight);
//        heightTextView.setText(Tool.formatFloatOrInt(dbl_height, 1));
//        weightTextView.setText(Tool.formatFloatOrInt(dbl_weight, 1));
        genderRadioGroup.check((Integer) userInfo.get(Constants.ParamKey_sex));
        intensityRadioGroup.check((Integer) userInfo.get(Constants.ParamKey_activityLevel));
        
        Integer intObj_sex = (Integer)userInfo.get(Constants.ParamKey_sex);
		Integer intObj_activityLevel = (Integer)userInfo.get(Constants.ParamKey_activityLevel);
        if (Constants.Value_sex_female == intObj_sex.intValue()){
        	femaleRadioButton.setChecked(true);
		}else{
			maleRadioButton.setChecked(true);
		}
		if (Constants.Value_activityLevel_middle == intObj_activityLevel.intValue()){
			intensity1RadioButton.setChecked(true);
		}else if (Constants.Value_activityLevel_strong == intObj_activityLevel.intValue()){
			intensity2RadioButton.setChecked(true);
		}else if (Constants.Value_activityLevel_veryStrong == intObj_activityLevel.intValue()){
			intensity3RadioButton.setChecked(true);
		}else {
			intensity4RadioButton.setChecked(true);
		}

    }
    
    void setSaveButtonEnabled(boolean enableFlag){
    	if (m_isInInit){
    		//do nothing
    	}else{
    		boolean isEnabled = m_btnSave.isEnabled();
        	if (isEnabled != enableFlag){
        		m_btnSave.setEnabled(enableFlag);
        	}
    	}
    }
    
    
    static String formatDate(Context ctx, Date dt){
    	java.text.DateFormat jdtFormat = android.text.format.DateFormat.getDateFormat(ctx);
    	String strDt = jdtFormat.format(dt);
    	return strDt;
    }
    
	static void setDateTextForTextControl(Context ctx, TextView tvDate, Date dt){
		String strDt = formatDate(ctx, dt);
		tvDate.setText(strDt);
	}
    
    class DatePickerDialog_OnDateSetListener implements DatePickerDialog.OnDateSetListener
    {
    	TextView m_tvDate;
    	public DatePickerDialog_OnDateSetListener(TextView tvDate){
    		m_tvDate = tvDate;
    	}
    	
		@Override
		public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
			Log.d(LogTag, "onDateSet enter, m_isInInit="+m_isInInit+", m_anyDataHasChanged="+m_anyDataHasChanged);
			
			GregorianCalendar gCal = new GregorianCalendar(year, monthOfYear, dayOfMonth);
			m_birthday = gCal.getTime();
			setDateTextForTextControl(getActivity(),m_tvDate,m_birthday);
			
			m_anyDataHasChanged = true;
			setSaveButtonEnabled(m_anyDataHasChanged);
			
			Log.d(LogTag, "onDateSet exit, m_isInInit="+m_isInInit+", m_anyDataHasChanged="+m_anyDataHasChanged);
		}
	};//class TimePickerDialog_OnTimeSetListener

}
