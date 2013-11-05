package com.lingzhimobile.nutritionfoodguide;


import java.util.*;

import com.umeng.analytics.MobclickAgent;


import android.R.integer;
import android.app.Activity;
import android.app.AlarmManager;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.PendingIntent;
import android.app.TimePickerDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Resources;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.text.Selection;
import android.text.Spannable;
import android.text.format.DateFormat;
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


public class ActivityDiagnoseAlertSetting extends Activity {
	
	static final String LogTag = "ActivityDiagnoseAlertSetting";
	
	static final int ShowDialogID_TimeMorning = 0;
	static final int ShowDialogID_TimeAfternoon = 1;
	static final int ShowDialogID_TimeNight = 2;
	
	
	
	
	TextView m_tvTitle, m_tvTimeMorning, m_tvTimeAfternoon, m_tvTimeNight;
	CheckBox m_cbEnableAlert;
	Button m_btnCancel,m_btnSave;
	int m_hour_morning, m_minute_morning, m_hour_afternoon, m_minute_afternoon, m_hour_night, m_minute_night;
	 

	
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
        setContentView(R.layout.activity_diagnose_alert_setting);
        
        initViewHandles();
        initViewsContent();
        setViewsContent();
        setViewEventHandlers();
    }
	@Override
	protected void onStart() {
        super.onStart();
    }
	
	void initViewHandles(){
		m_tvTitle = (TextView)findViewById(R.id.tvTitle);
		m_btnSave = (Button) findViewById(R.id.btnTopRight);
        m_btnCancel = (Button) findViewById(R.id.btnCancel);
        m_cbEnableAlert = (CheckBox)findViewById(R.id.cbEnableAlert);
        m_tvTimeMorning = (TextView)findViewById(R.id.tvTimeMorning);
        m_tvTimeAfternoon = (TextView)findViewById(R.id.tvTimeAfternoon);
        m_tvTimeNight = (TextView)findViewById(R.id.tvTimeNight);
	}
	void initViewsContent(){

		Intent paramIntent = getIntent();
		String prevActvTitle = paramIntent.getStringExtra(Constants.IntentParamKey_BackButtonTitle);
		if (prevActvTitle != null)
			m_btnCancel.setText(prevActvTitle);

		m_tvTitle.setText(R.string.title_setting);
		m_btnSave.setText(R.string.save);

		HashMap<String, Object> alertSettingHm = StoredConfigTool.getAlertSetting(this);
		Boolean AlertSetting_EnableFlag = (Boolean)alertSettingHm.get(Constants.PreferenceKey_AlertSetting_EnableFlag);
		Integer Morning_Hour = (Integer)alertSettingHm.get(Constants.PreferenceKey_AlertSetting_Morning_Hour);
		Integer Morning_Minute = (Integer)alertSettingHm.get(Constants.PreferenceKey_AlertSetting_Morning_Minute);
		Integer Afternoon_Hour = (Integer)alertSettingHm.get(Constants.PreferenceKey_AlertSetting_Afternoon_Hour);
		Integer Afternoon_Minute = (Integer)alertSettingHm.get(Constants.PreferenceKey_AlertSetting_Afternoon_Minute);
		Integer Night_Hour = (Integer)alertSettingHm.get(Constants.PreferenceKey_AlertSetting_Night_Hour);
		Integer Night_Minute = (Integer)alertSettingHm.get(Constants.PreferenceKey_AlertSetting_Night_Minute);
		
		m_hour_morning = Morning_Hour;
		m_minute_morning = Morning_Minute;
		m_hour_afternoon = Afternoon_Hour;
		m_minute_afternoon = Afternoon_Minute;
		m_hour_night = Night_Hour;
		m_minute_night = Night_Minute;
		
		m_cbEnableAlert.setChecked(AlertSetting_EnableFlag);
		setTimeTextForTextControl(m_tvTimeMorning,Morning_Hour,Morning_Minute);
		setTimeTextForTextControl(m_tvTimeAfternoon,Afternoon_Hour,Afternoon_Minute);
		setTimeTextForTextControl(m_tvTimeNight,Night_Hour,Night_Minute);
	}
	void setViewEventHandlers(){

        m_btnCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	finish();
            }
        });
        
        m_btnSave.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	StoredConfigTool.saveAlertSetting(ActivityDiagnoseAlertSetting.this, m_cbEnableAlert.isChecked(), 
            			m_hour_morning, m_minute_morning, m_hour_afternoon, m_minute_afternoon, m_hour_night, m_minute_night);
            	
            	if (m_cbEnableAlert.isChecked()){
            		setAlarm(ActivityDiagnoseAlertSetting.this);
            	}else{
            		cancelAlerm(ActivityDiagnoseAlertSetting.this);
            	}
            	
            	finish();
            }
        });
        
        m_tvTimeMorning.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	Log.d(LogTag, "m_tvTimeMorning onClick");
            	Context curCtx = ActivityDiagnoseAlertSetting.this;
            	TimePickerDialog_OnTimeSetListener OnTimeSetListener1 = new TimePickerDialog_OnTimeSetListener(ShowDialogID_TimeMorning);
            	boolean is24HourFormat = android.text.format.DateFormat.is24HourFormat(curCtx);
            	TimePickerDialog tmDialog = new TimePickerDialog(curCtx, OnTimeSetListener1, m_hour_morning, m_minute_morning, is24HourFormat);
            	tmDialog.show();
            }
        });
        m_tvTimeAfternoon.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	Log.d(LogTag, "m_tvTimeMorning onClick");
            	Context curCtx = ActivityDiagnoseAlertSetting.this;
            	TimePickerDialog_OnTimeSetListener OnTimeSetListener1 = new TimePickerDialog_OnTimeSetListener(ShowDialogID_TimeAfternoon);
            	boolean is24HourFormat = android.text.format.DateFormat.is24HourFormat(curCtx);
            	TimePickerDialog tmDialog = new TimePickerDialog(curCtx, OnTimeSetListener1, m_hour_afternoon, m_minute_afternoon, is24HourFormat);
            	tmDialog.show();
            }
        });
        m_tvTimeNight.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	Log.d(LogTag, "m_tvTimeMorning onClick");
            	Context curCtx = ActivityDiagnoseAlertSetting.this;
            	TimePickerDialog_OnTimeSetListener OnTimeSetListener1 = new TimePickerDialog_OnTimeSetListener(ShowDialogID_TimeNight);
            	boolean is24HourFormat = android.text.format.DateFormat.is24HourFormat(curCtx);
            	TimePickerDialog tmDialog = new TimePickerDialog(curCtx, OnTimeSetListener1, m_hour_night, m_minute_night, is24HourFormat);
            	tmDialog.show();
            }
        });
        
	}
	
	
	void setViewsContent(){
	}
	
	void setTimeTextForTextControl(TextView tvTime, int hour, int minute){
		Date dtDate = new Date();
		dtDate.setHours(hour);
		dtDate.setMinutes(minute);
		java.text.DateFormat jdtFormat = android.text.format.DateFormat.getTimeFormat(this);
		tvTime.setText(jdtFormat.format(dtDate));
	}
	
    class TimePickerDialog_OnTimeSetListener implements TimePickerDialog.OnTimeSetListener
    {
    	int m_ShowDialogID;//这个本来该由dialog一路传递的参数，由于dialog的无能，只好通过这种方式传递
    	public TimePickerDialog_OnTimeSetListener(int ShowDialogID){
    		m_ShowDialogID = ShowDialogID;
    	}
   
		@Override
		public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
			switch (m_ShowDialogID) {
			case ShowDialogID_TimeMorning:
				m_hour_morning = hourOfDay;
				m_minute_morning = minute;
				setTimeTextForTextControl(m_tvTimeMorning,hourOfDay,minute);
				break;
			case ShowDialogID_TimeAfternoon:
				m_hour_afternoon = hourOfDay;
				m_minute_afternoon = minute;
				setTimeTextForTextControl(m_tvTimeAfternoon,hourOfDay,minute);
				break;
			case ShowDialogID_TimeNight:
				m_hour_night = hourOfDay;
				m_minute_night = minute;
				setTimeTextForTextControl(m_tvTimeNight,hourOfDay,minute);
				break;
			default:
				break;
			}
		}
	};//class TimePickerDialog_OnTimeSetListener
	


	public static void setAlarm(Context ctx){
		cancelAlerm(ctx);
		
		HashMap<String, Object> alertSettingHm = StoredConfigTool.getAlertSetting(ctx);
		Boolean AlertSetting_EnableFlag = (Boolean)alertSettingHm.get(Constants.PreferenceKey_AlertSetting_EnableFlag);
		Integer hour_morning = (Integer)alertSettingHm.get(Constants.PreferenceKey_AlertSetting_Morning_Hour);
		Integer minute_morning = (Integer)alertSettingHm.get(Constants.PreferenceKey_AlertSetting_Morning_Minute);
		Integer hour_afternoon = (Integer)alertSettingHm.get(Constants.PreferenceKey_AlertSetting_Afternoon_Hour);
		Integer minute_afternoon = (Integer)alertSettingHm.get(Constants.PreferenceKey_AlertSetting_Afternoon_Minute);
		Integer hour_night = (Integer)alertSettingHm.get(Constants.PreferenceKey_AlertSetting_Night_Hour);
		Integer minute_night = (Integer)alertSettingHm.get(Constants.PreferenceKey_AlertSetting_Night_Minute);
		
		if (! AlertSetting_EnableFlag.booleanValue()){
			return;
		}
		
		AlarmManager alarmMng= (AlarmManager) ctx.getSystemService(ALARM_SERVICE);
		
		long intervalForAlert =  AlarmManager.INTERVAL_DAY; //1 * 60 * 1000;
		Calendar calendarNow = Calendar.getInstance();
		Calendar calendar_morning = Calendar.getInstance();
		Calendar calendar_afternoon = Calendar.getInstance();
		Calendar calendar_night = Calendar.getInstance();
		
		calendar_morning.set(Calendar.HOUR_OF_DAY, hour_morning);
		calendar_morning.set(Calendar.MINUTE, minute_morning);
		if ( calendar_morning.compareTo(calendarNow) < 0 ){
			calendar_morning.add(Calendar.DAY_OF_MONTH, 1);
		}
		Intent intent_morning = new Intent(ctx, BroadcastReceiverAlert.class);
		intent_morning.setData(Constants.URIflag_morning);
		PendingIntent pendingIntent_morning= PendingIntent.getBroadcast(ctx, 0, intent_morning, 0);  
		alarmMng.cancel(pendingIntent_morning);
		alarmMng.setInexactRepeating(AlarmManager.RTC_WAKEUP, calendar_morning.getTimeInMillis(), intervalForAlert , pendingIntent_morning);
          
		calendar_afternoon.set(Calendar.HOUR_OF_DAY, hour_afternoon);
		calendar_afternoon.set(Calendar.MINUTE, minute_afternoon);
		if ( calendar_afternoon.compareTo(calendarNow) < 0 ){
			calendar_afternoon.add(Calendar.DAY_OF_MONTH, 1);
		}
		Intent intent_afternoon = new Intent(ctx, BroadcastReceiverAlert.class);
		intent_afternoon.setData(Constants.URIflag_afternoon);
		PendingIntent pendingIntent_afternoon= PendingIntent.getBroadcast(ctx, 0, intent_afternoon, 0);  
		alarmMng.cancel(pendingIntent_afternoon);
		alarmMng.setInexactRepeating(AlarmManager.RTC_WAKEUP, calendar_afternoon.getTimeInMillis(), intervalForAlert , pendingIntent_afternoon);
		
		calendar_night.set(Calendar.HOUR_OF_DAY, hour_night);
		calendar_night.set(Calendar.MINUTE, minute_night);
		if ( calendar_night.compareTo(calendarNow) < 0 ){
			calendar_night.add(Calendar.DAY_OF_MONTH, 1);
		}
		Intent intent_night = new Intent(ctx, BroadcastReceiverAlert.class);
		intent_night.setData(Constants.URIflag_night);
		PendingIntent pendingIntent_night= PendingIntent.getBroadcast(ctx, 0, intent_night, 0);  
		alarmMng.cancel(pendingIntent_night);
		alarmMng.setInexactRepeating(AlarmManager.RTC_WAKEUP, calendar_night.getTimeInMillis(), intervalForAlert , pendingIntent_night);
	}
	public static void cancelAlerm(Context ctx){
		AlarmManager alarmMng= (AlarmManager) ctx.getSystemService(ALARM_SERVICE);
		
		Intent intent1 = new Intent(ctx, BroadcastReceiverAlert.class);
		intent1.setData(Constants.URIflag_morning);
		PendingIntent pendIntent1= PendingIntent.getBroadcast(ctx, 0, intent1, 0);  
		alarmMng.cancel(pendIntent1);
		
		Intent intent2 = new Intent(ctx, BroadcastReceiverAlert.class);
		intent2.setData(Constants.URIflag_afternoon);
		PendingIntent pendIntent2= PendingIntent.getBroadcast(ctx, 0, intent1, 0);  
		alarmMng.cancel(pendIntent2);
		
		Intent intent3 = new Intent(ctx, BroadcastReceiverAlert.class);
		intent3.setData(Constants.URIflag_night);
		PendingIntent pendIntent3= PendingIntent.getBroadcast(ctx, 0, intent1, 0);  
		alarmMng.cancel(pendIntent3);
	}
	
    
}













