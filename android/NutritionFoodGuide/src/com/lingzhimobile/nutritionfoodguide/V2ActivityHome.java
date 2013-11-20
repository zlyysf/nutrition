package com.lingzhimobile.nutritionfoodguide;





import org.apache.commons.lang3.StringUtils;


import com.umeng.analytics.MobclickAgent;

import android.os.Bundle;
import android.app.*;
import android.content.*;
import android.util.*;
import android.view.*;
import android.widget.*;


@SuppressWarnings("deprecation")
public class V2ActivityHome extends ActivityGroup{

    static final String LogTag = "ActivityHomeV2";
    
    static final String LocalActivityManager_startActivity_ID_Diagnose = "Diagnose";
    static final String LocalActivityManager_startActivity_ID_History = "History";
    static final String LocalActivityManager_startActivity_ID_Chart = "Chart";
    static final String LocalActivityManager_startActivity_ID_Cyclopedia = "Cyclopedia";
    static final String LocalActivityManager_startActivity_ID_Setting = "Setting";
    
    Context m_this;
    LinearLayout m_llTabInnerMainView;
    RadioGroup m_radioGroupAsTab;
    RadioButton m_rbDiagnose, m_rbHistory, m_rbChart, m_rbCyclopedia, m_rbSetting;
    
   

	public void onResume() {
		super.onResume();
		MobclickAgent.onResume(this);
	}
	public void onPause() {
		super.onPause();
		MobclickAgent.onPause(this);
	}
	
	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.v2_activity_home);
		
		m_this = this;
		
		initViewHandles();
        initViewsContent();
        setViewEventHandlers();
        setViewsContent();
	}

	@Override
    public boolean dispatchKeyEvent(KeyEvent event) {
        if (getLocalActivityManager().getCurrentActivity().onKeyDown(event.getKeyCode(), event)) {
            return true;
        } else {
            return super.dispatchKeyEvent(event);
        }

    }

	void initViewHandles(){
		m_llTabInnerMainView = (LinearLayout) findViewById(R.id.llTabInnerMainView);
		m_radioGroupAsTab = (RadioGroup) findViewById(R.id.radioGroupAsTab);
        m_rbDiagnose = (RadioButton) findViewById(R.id.rbDiagnose);
        m_rbHistory = (RadioButton) findViewById(R.id.rbHistory);
        m_rbChart = (RadioButton) findViewById(R.id.rbChart);
        m_rbCyclopedia = (RadioButton) findViewById(R.id.rbCyclopedia);
        m_rbSetting = (RadioButton) findViewById(R.id.rbSetting);
	}
	void initViewsContent(){
		
	}
	void setViewEventHandlers(){
		m_radioGroupAsTab.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
			@Override
			public void onCheckedChanged(RadioGroup group, int checkedId) {
				showCurrentPositionActivity();
			}
		});
	}
	void setViewsContent(){
		m_rbDiagnose.setChecked(true);//not cause RadioGroup.OnCheckedChangeListener
		showCurrentPositionActivity();
	}
	
	void showCurrentPositionActivity(){
		String sLocalActivityManager_startActivity_ID = null;
		Intent intent1 = null;
		
		if (m_rbDiagnose.isChecked()){
			intent1 = new Intent(m_this,V2ActivityDiagnose.class);
			sLocalActivityManager_startActivity_ID = LocalActivityManager_startActivity_ID_Diagnose;
		}
		if (m_rbHistory.isChecked()){
			intent1 = new Intent(m_this,ActivitySearchFoodCustom.class);
			sLocalActivityManager_startActivity_ID = LocalActivityManager_startActivity_ID_History;
		}
		if (m_rbChart.isChecked()){
			intent1 = new Intent(m_this,ActivitySearchFoodWithClass.class);
			sLocalActivityManager_startActivity_ID = LocalActivityManager_startActivity_ID_Chart;
		}
		if (m_rbCyclopedia.isChecked()){
			intent1 = new Intent(m_this,ActivitySetting.class);
			sLocalActivityManager_startActivity_ID = LocalActivityManager_startActivity_ID_Cyclopedia;
		}
		if (m_rbSetting.isChecked()){
			intent1 = new Intent(m_this,ActivityUserProfile.class);
			sLocalActivityManager_startActivity_ID = LocalActivityManager_startActivity_ID_Setting;
		}
		
		intent1.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
		m_llTabInnerMainView.removeAllViews();
		LocalActivityManager lam = getLocalActivityManager();
		Window actvWindow = lam.startActivity(sLocalActivityManager_startActivity_ID,intent1);
		View actvDecorView = actvWindow.getDecorView();
		m_llTabInnerMainView.addView(actvDecorView);
	}
	

    
}
