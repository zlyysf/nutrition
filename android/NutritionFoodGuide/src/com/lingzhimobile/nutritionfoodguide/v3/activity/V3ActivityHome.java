package com.lingzhimobile.nutritionfoodguide.v3.activity;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.widget.Button;
import android.widget.RadioButton;
import android.widget.TextView;

import com.lingzhimobile.nutritionfoodguide.ActivityTestCases;
import com.lingzhimobile.nutritionfoodguide.R;
import com.lingzhimobile.nutritionfoodguide.v3.adapter.V3HomeTabAdapter;
import com.parse.ParseAnalytics;

public class V3ActivityHome extends V3BaseActivity {

    private ViewPager mViewPager;
    private V3HomeTabAdapter mHomeTabAdapter;
    RadioButton tabButtonDiagnose, tabButtonHistory, tabButtonChart,
            tabButtonCyclopedia, tabButtonSetting;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        ParseAnalytics.trackAppOpened(getIntent());

        setContentView(R.layout.tab_activity);

        mViewPager = (ViewPager) findViewById(R.id.viewPager);

        final String[] sectionTitles = getResources().getStringArray(
                R.array.home_tab_selections);
        mHomeTabAdapter = new V3HomeTabAdapter(getSupportFragmentManager(),
                sectionTitles);
        mViewPager.setAdapter(mHomeTabAdapter);
        mViewPager.setOnTouchListener(new OnTouchListener() {
            
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                // TODO Auto-generated method stub
                return true;
            }
        });

        tabButtonDiagnose = (RadioButton) findViewById(R.id.rbDiagnose);
        tabButtonDiagnose.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                mViewPager.setCurrentItem(0, false);
            }
        });
        tabButtonHistory = (RadioButton) findViewById(R.id.rbHistory);
        tabButtonHistory.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                mViewPager.setCurrentItem(1, false);
            }
        });
        tabButtonChart = (RadioButton) findViewById(R.id.rbChart);
        tabButtonChart.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                mViewPager.setCurrentItem(2, false);
            }
        });
        tabButtonCyclopedia = (RadioButton) findViewById(R.id.rbCyclopedia);
        tabButtonCyclopedia.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                mViewPager.setCurrentItem(3, false);
            }
        });
        tabButtonSetting = (RadioButton) findViewById(R.id.rbSetting);
        tabButtonSetting.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                mViewPager.setCurrentItem(4, false);
            }
        });

    }

}
