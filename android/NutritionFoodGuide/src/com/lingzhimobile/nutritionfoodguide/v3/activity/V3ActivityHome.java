package com.lingzhimobile.nutritionfoodguide.v3.activity;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.*;
import android.util.Log;
import android.util.SparseBooleanArray;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.RadioButton;

import com.lingzhimobile.nutritionfoodguide.DataAccess;
import com.lingzhimobile.nutritionfoodguide.R;
import com.lingzhimobile.nutritionfoodguide.ToolParse;
import com.lingzhimobile.nutritionfoodguide.v3.fragment.V3DiagnoseFragment;
import com.lingzhimobile.nutritionfoodguide.v3.fragment.V3EncyclopediaFragment;
import com.lingzhimobile.nutritionfoodguide.v3.fragment.V3HistoryFragment;
import com.lingzhimobile.nutritionfoodguide.v3.fragment.V3SettingFragment;
import com.lingzhimobile.nutritionfoodguide.v3.fragment.V3TabContentFragment;
import com.parse.ParseAnalytics;

public class V3ActivityHome extends V3BaseActivity {
	
	static final String LogTag = V3ActivityHome.class.getSimpleName();

    private static final String TAG_DIAGNOSE = "diagnose";
    private static final String TAG_HISTORY = "history";
    private static final String TAG_CHART = "chart";
    private static final String TAG_CYCLOPEDIA = "cyclopedia";
    private static final String TAG_SETTING = "setting";
    private static final int Position_Tab_Diagnose = 0;
    private static final int Position_Tab_History = 1;
//    private static final int Position_Tab_Chart = 2;
    private static final int Position_Tab_Cyclopedia = 2;
    private static final int Position_Tab_Setting = 3;
    private static final String[] TAGS = new String[]{TAG_DIAGNOSE, TAG_HISTORY, TAG_CYCLOPEDIA, TAG_SETTING};//TAG_CHART
    
    int m_currentTabItemIndex = 0;
    
    RadioButton tabButtonDiagnose, tabButtonHistory, tabButtonChart,
            tabButtonCyclopedia, tabButtonSetting;

    @Override
    public void onBackPressed() {
        this.finish();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.d(LogTag, "onCreate enter");
        
        ParseAnalytics.trackAppOpened(getIntent());
        
        ToolParse.syncRemoteDataToLocal(this, null);
        DataAccess.mLogEnabled = false;

        setContentView(R.layout.tab_activity);

        tabButtonDiagnose = (RadioButton) findViewById(R.id.rbDiagnose);
        tabButtonDiagnose.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                setCurrentItem(Position_Tab_Diagnose);
            }
        });
        tabButtonHistory = (RadioButton) findViewById(R.id.rbHistory);
        tabButtonHistory.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                setCurrentItem(Position_Tab_History);
            }
        });
//        tabButtonChart = (RadioButton) findViewById(R.id.rbChart);
//        tabButtonChart.setOnClickListener(new OnClickListener() {
//
//            @Override
//            public void onClick(View arg0) {
//                setCurrentItem(Position_Tab_Chart);
//            }
//        });
        tabButtonCyclopedia = (RadioButton) findViewById(R.id.rbCyclopedia);
        tabButtonCyclopedia.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                setCurrentItem(Position_Tab_Cyclopedia);
            }
        });
        tabButtonSetting = (RadioButton) findViewById(R.id.rbSetting);
        tabButtonSetting.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                setCurrentItem(Position_Tab_Setting);
            }
        });

        setCurrentItem(Position_Tab_Diagnose);
    }

    protected void setCurrentItem(int i) {
//    	int prevTabItemIndex = m_currentTabItemIndex;
    	m_currentTabItemIndex  = i;
    	FragmentManager fragmentManager = this.getSupportFragmentManager();
        Fragment fragment = fragmentManager.findFragmentByTag(TAGS[i]);
        if (fragment == null) {
            switch(i){
            case Position_Tab_Diagnose:
                fragment = V3DiagnoseFragment.newInstance(0);
                break;
            case Position_Tab_History:
                fragment = V3HistoryFragment.newInstance(1);
                break;
//            case Position_Tab_Chart:
//                fragment = V3TabContentFragment.newInstance(2);
//                break;
            case Position_Tab_Cyclopedia:
                fragment = V3EncyclopediaFragment.newInstance(1);
                break;
            case Position_Tab_Setting:
                fragment = V3SettingFragment.newInstance(1);
                break;
            }
        }else{
        	switch(i){
            case Position_Tab_Diagnose:
//            	fragment = V3DiagnoseFragment.newInstance(0);
                break;
            case Position_Tab_History:
            	V3HistoryFragment fragmentHis = (V3HistoryFragment)fragment;
            	fragmentHis.needClearAllSubFragment();
                break;
//            case Position_Tab_Chart:
//                
//                break;
            case Position_Tab_Cyclopedia:
                
                break;
            case Position_Tab_Setting:
            	fragment = V3SettingFragment.newInstance(1);
                break;
            }
        }
        //看来没法从fragmentManager中删掉某个fragment
//        Fragment toRemoveFragment = null;
//        if (prevTabItemIndex == Position_Tab_Setting){
//        	toRemoveFragment = fragmentManager.findFragmentByTag(TAGS[prevTabItemIndex]);
//        }
        
        FragmentTransaction fragTran = fragmentManager.beginTransaction();
//        if (toRemoveFragment != null){
//        	fragTran.remove(toRemoveFragment);
//        	Log.d(LogTag, "fragTran.remove prevTabItemIndex="+prevTabItemIndex);
//        }
        fragTran.replace(R.id.contentFrameLayout, fragment, TAGS[i]);
//        if (prevTabItemIndex != Position_Tab_Setting){
//        	fragTran.addToBackStack(null);
//        }
        fragTran.addToBackStack(null);
        fragTran.commit();
        
//        if (prevTabItemIndex == Position_Tab_Setting){
//        	Fragment toRemoveFragment2 = fragmentManager.findFragmentByTag(TAGS[prevTabItemIndex]);
//        	Log.d(LogTag, "toRemoveFragment2="+toRemoveFragment2);//not null, seemed that FragmentTransaction.remove not remove from fragmentManager
//        }
        
    }

    @Override
	public void onActivityResult(int requestCode, int resultCode, Intent data)
	{
		super.onActivityResult(requestCode, resultCode, data);
		FragmentManager fragmentManager = this.getSupportFragmentManager();
		if (m_currentTabItemIndex == Position_Tab_Diagnose){
			Fragment fragment = fragmentManager.findFragmentByTag(TAGS[m_currentTabItemIndex]);
			((V3DiagnoseFragment)fragment).onActivityResult(requestCode, resultCode, data);
		}
		
	}
}
