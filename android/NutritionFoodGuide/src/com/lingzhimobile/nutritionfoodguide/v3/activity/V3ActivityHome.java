package com.lingzhimobile.nutritionfoodguide.v3.activity;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
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

    private static final String TAG_DIAGNOSE = "diagnose";
    private static final String TAG_HISTORY = "history";
    private static final String TAG_CHART = "chart";
    private static final String TAG_CYCLOPEDIA = "cyclopedia";
    private static final String TAG_SETTING = "setting";
    private static final String[] TAGS = new String[]{TAG_DIAGNOSE, TAG_HISTORY, TAG_CHART, TAG_CYCLOPEDIA, TAG_SETTING};
    
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
        
        ParseAnalytics.trackAppOpened(getIntent());
        
//        ToolParse.syncRemoteDataToLocal(this, null);
        DataAccess.mLogEnabled = false;

        setContentView(R.layout.tab_activity);

        tabButtonDiagnose = (RadioButton) findViewById(R.id.rbDiagnose);
        tabButtonDiagnose.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                setCurrentItem(0);
            }
        });
        tabButtonHistory = (RadioButton) findViewById(R.id.rbHistory);
        tabButtonHistory.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                setCurrentItem(1);
            }
        });
        tabButtonChart = (RadioButton) findViewById(R.id.rbChart);
        tabButtonChart.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                setCurrentItem(2);
            }
        });
        tabButtonCyclopedia = (RadioButton) findViewById(R.id.rbCyclopedia);
        tabButtonCyclopedia.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                setCurrentItem(3);
            }
        });
        tabButtonSetting = (RadioButton) findViewById(R.id.rbSetting);
        tabButtonSetting.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                setCurrentItem(4);
            }
        });

        setCurrentItem(0);
    }

    protected void setCurrentItem(int i) {
    	m_currentTabItemIndex  = i;
    	FragmentManager fragmentManager = this.getSupportFragmentManager();
        Fragment fragment = fragmentManager.findFragmentByTag(TAGS[i]);
        if (fragment == null) {
            switch(i){
            case 0:
                fragment = V3DiagnoseFragment.newInstance(0);
                break;
            case 1:
                fragment = V3HistoryFragment.newInstance(1);
                break;
            case 2:
                fragment = V3TabContentFragment.newInstance(2);
                break;
            case 3:
                fragment = V3EncyclopediaFragment.newInstance(1);
                break;
            case 4:
                fragment = V3SettingFragment.newInstance(1);
                break;
            }
        }else{
        	switch(i){
            case 0:
                
                break;
            case 1:
            	V3HistoryFragment fragmentHis = (V3HistoryFragment)fragment;
            	fragmentHis.needClearAllSubFragment();
                break;
            case 2:
                
                break;
            case 3:
                
                break;
            case 4:
                
                break;
            }
        }
        fragmentManager.beginTransaction().replace(R.id.contentFrameLayout, fragment, TAGS[i]).addToBackStack(null).commit();
    }

    @Override
	public void onActivityResult(int requestCode, int resultCode, Intent data)
	{
		super.onActivityResult(requestCode, resultCode, data);
		FragmentManager fragmentManager = this.getSupportFragmentManager();
		if (m_currentTabItemIndex == 0){
			Fragment fragment = fragmentManager.findFragmentByTag(TAGS[m_currentTabItemIndex]);
			((V3DiagnoseFragment)fragment).onActivityResult(requestCode, resultCode, data);
		}
		
	}
}
