package com.lingzhimobile.nutritionfoodguide.v3.activity;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
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
import com.lingzhimobile.nutritionfoodguide.v3.adapter.HomeTabAdapter;

public class V3ActivityHome extends FragmentActivity {

    private ViewPager mViewPager;
    private HomeTabAdapter mHomeTabAdapter;
    RadioButton tabButtonDiagnose, tabButtonHistory, tabButtonChart,
            tabButtonCyclopedia, tabButtonSetting;
    Button leftButton, rightButton;
    TextView title;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.tab_activity);
        title = (TextView) findViewById(R.id.titleText);
        leftButton = (Button) findViewById(R.id.leftButton);
        rightButton = (Button) findViewById(R.id.rightButton);
        leftButton.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                Intent intent = new Intent(V3ActivityHome.this, ActivityTestCases.class);
                V3ActivityHome.this.startActivity(intent);
            }
        });

        mViewPager = (ViewPager) findViewById(R.id.viewPager);

        final String[] sectionTitles = getResources().getStringArray(
                R.array.home_tab_selections);
        mHomeTabAdapter = new HomeTabAdapter(getSupportFragmentManager(),
                sectionTitles);
        mViewPager.setAdapter(mHomeTabAdapter);
        mViewPager.setOnTouchListener(new OnTouchListener() {
            
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                // TODO Auto-generated method stub
                return true;
            }
        });
        setTitleLayout(0);

        tabButtonDiagnose = (RadioButton) findViewById(R.id.rbDiagnose);
        tabButtonDiagnose.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                mViewPager.setCurrentItem(0, false);
                setTitleLayout(0);
            }
        });
        tabButtonHistory = (RadioButton) findViewById(R.id.rbHistory);
        tabButtonHistory.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                mViewPager.setCurrentItem(1, false);
                setTitleLayout(1);
            }
        });
        tabButtonChart = (RadioButton) findViewById(R.id.rbChart);
        tabButtonChart.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                mViewPager.setCurrentItem(2, false);
                setTitleLayout(2);
            }
        });
        tabButtonCyclopedia = (RadioButton) findViewById(R.id.rbCyclopedia);
        tabButtonCyclopedia.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                mViewPager.setCurrentItem(3, false);
                setTitleLayout(3);
            }
        });
        tabButtonSetting = (RadioButton) findViewById(R.id.rbSetting);
        tabButtonSetting.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                mViewPager.setCurrentItem(4, false);
                setTitleLayout(4);
            }
        });

    }

    protected void setTitleLayout(int i) {
        switch (i) {
        case 0:
            title.setText("健康记录");
            break;
        case 1:
            title.setText("11月");
            break;
        case 2:
            title.setText("11月");
            break;
        case 3:
            title.setText("百科");
            break;
        case 4:
            title.setText("设置");
            break;
        }
    }
}
