package com.lingzhimobile.nutritionfoodguide.v3.fragment;

import java.util.*;


import android.R.bool;
import android.app.*;
import android.content.Context;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
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
    
    TextView birthdayTextView, m_tvActivityLevelDescription;
    EditText heightTextView, weightTextView;
    RadioGroup genderRadioGroup, intensityRadioGroup;
    RadioButton maleRadioButton, femaleRadioButton, intensity1RadioButton, intensity2RadioButton, intensity3RadioButton, intensity4RadioButton;
    
    Button m_btnSave;
	TextView m_tvTitle;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.v3_fragment_setting, container, false);
        
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
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
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
    	HashMap<String, Object> userInfo = StoredConfigTool.getUserInfo(getActivity());
        m_birthday = (Date)userInfo.get(Constants.ParamKey_birthday);
        String strDt = formatDate(getActivity(), m_birthday);
        birthdayTextView.setText(strDt);

        Double dbl_height = (Double)userInfo.get(Constants.ParamKey_height);
        Double dbl_weight = (Double)userInfo.get(Constants.ParamKey_weight);
        heightTextView.setText(Tool.formatFloatOrInt(dbl_height, 1));
        weightTextView.setText(Tool.formatFloatOrInt(dbl_weight, 1));
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
    
    void setViewEventHandlers(){
    	m_btnSave.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
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
                
                setSaveButtonEnabled(false);
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
				if (checkedId==R.id.intensity1RadioButton){
					m_tvActivityLevelDescription.setText(R.string.ActivityLevelDescription0);
				}else if (checkedId==R.id.intensity2RadioButton){
					m_tvActivityLevelDescription.setText(R.string.ActivityLevelDescription1);
				}else if (checkedId==R.id.intensity3RadioButton){
					m_tvActivityLevelDescription.setText(R.string.ActivityLevelDescription2);
				}else if (checkedId==R.id.intensity4RadioButton){
					m_tvActivityLevelDescription.setText(R.string.ActivityLevelDescription3);
				}
					
				setSaveButtonEnabled(true);
			}
		});
        
        genderRadioGroup.setOnCheckedChangeListener(new OnCheckedChangeListener() {
			@Override
			public void onCheckedChanged(RadioGroup group, int checkedId) {	
				setSaveButtonEnabled(true);
			}
		});
        
        TextWatcher TextWatcher1 = new TextWatcher() {
			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
				setSaveButtonEnabled(true);
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
    	setSaveButtonEnabled(false);
    }
    
    void setSaveButtonEnabled(boolean enableFlag){
    	boolean isEnabled = m_btnSave.isEnabled();
    	if (isEnabled != enableFlag){
    		m_btnSave.setEnabled(enableFlag);
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
			GregorianCalendar gCal = new GregorianCalendar(year, monthOfYear, dayOfMonth);
			m_birthday = gCal.getTime();
			setDateTextForTextControl(getActivity(),m_tvDate,m_birthday);
			
			setSaveButtonEnabled(true);
		}
	};//class TimePickerDialog_OnTimeSetListener

}
