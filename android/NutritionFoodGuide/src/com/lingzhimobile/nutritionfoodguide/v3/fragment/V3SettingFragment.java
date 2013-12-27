package com.lingzhimobile.nutritionfoodguide.v3.fragment;

import java.util.*;


import android.app.*;
import android.content.Context;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.*;


import com.lingzhimobile.nutritionfoodguide.Constants;
import com.lingzhimobile.nutritionfoodguide.R;
import com.lingzhimobile.nutritionfoodguide.StoredConfigTool;
import com.lingzhimobile.nutritionfoodguide.v3.activity.V3ActivityHome;

public class V3SettingFragment extends V3BaseHeadFragment {
    static final String LogTag = V3SettingFragment.class.getSimpleName();

    Date m_birthday;
    
    TextView birthdayTextView;
    EditText heightTextView, weightTextView;
    RadioGroup genderRadioGroup, intensityRadioGroup;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.v3_fragment_setting, container,
                false);
        initHeaderLayout(view);
        birthdayTextView = (TextView) view.findViewById(R.id.birthdayTextView);
        heightTextView = (EditText) view.findViewById(R.id.heightTextView);
        weightTextView = (EditText) view.findViewById(R.id.weightTextView);
        genderRadioGroup = (RadioGroup) view.findViewById(R.id.genderRadioGroup);
        intensityRadioGroup = (RadioGroup) view.findViewById(R.id.intensityRadioGroup);
        
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
        
        
        return view;
    }

    public static Fragment newInstance(int arg0) {
        Fragment settingFragment = new V3SettingFragment();
        return settingFragment;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        HashMap<String, Object> userInfo = StoredConfigTool.getUserInfo(getActivity());
        m_birthday = (Date)userInfo.get(Constants.ParamKey_birthday);
        String strDt = formatDate(getActivity(), m_birthday);
        birthdayTextView.setText(strDt);

        heightTextView.setText(userInfo.get(Constants.ParamKey_height)
                .toString());
        weightTextView.setText(userInfo.get(Constants.ParamKey_weight)
                .toString());
        genderRadioGroup.check((Integer) userInfo.get(Constants.ParamKey_sex));
        intensityRadioGroup.check((Integer) userInfo.get(Constants.ParamKey_activityLevel));

    }

    @Override
    protected void setHeader() {
        rightButton.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                HashMap<String, Object> userInfo = new HashMap<String, Object>();
//                userInfo.put(Constants.ParamKey_age,Integer.parseInt(birthdayTextView.getText().toString()));
                userInfo.put(Constants.ParamKey_birthday, m_birthday);
                userInfo.put(Constants.ParamKey_height,
                        Double.parseDouble(heightTextView.getText().toString()));
                userInfo.put(Constants.ParamKey_weight,
                        Double.parseDouble(weightTextView.getText().toString()));
                userInfo.put(Constants.ParamKey_sex, genderRadioGroup.getCheckedRadioButtonId());
                userInfo.put(Constants.ParamKey_activityLevel, intensityRadioGroup.getCheckedRadioButtonId());
                StoredConfigTool.saveUserInfo(getActivity(), userInfo);
            }
        });
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
		}
	};//class TimePickerDialog_OnTimeSetListener

}
