package com.lingzhimobile.nutritionfoodguide.v3.fragment;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;

import com.lingzhimobile.nutritionfoodguide.DataAccess;
import com.lingzhimobile.nutritionfoodguide.R;
import com.lingzhimobile.nutritionfoodguide.test.TestCaseDA;
import com.lingzhimobile.nutritionfoodguide.v3.adapter.HistoryMonthAdapter;

public class V3HistoryFragment extends V3BaseHeadFragment {

	ArrayList<Integer> monthList;
    ViewPager monthViewPager;
    HistoryMonthAdapter monthAdapter;

    ArrayList<HashMap<String, Object>> historyMap;

    DataAccess da;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        Bundle arg = getArguments();

        da = DataAccess.getSingleton(getActivity());
        monthList = da.getUserRecordSymptom_DistinctMonth();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.v3_fragment_history, container, false);
        initHeaderLayout(view);
        
        Drawable prevDrawable = getResources().getDrawable(R.drawable.v3_prev_bg);
        prevDrawable.setBounds(0, 0, 27, 45);
        leftButton.setCompoundDrawables(prevDrawable, null, null, null);


        Drawable nextDrawable = getResources().getDrawable(R.drawable.v3_next_bg);
        nextDrawable.setBounds(0, 0, 27, 45);
        rightButton.setCompoundDrawables(null, null, nextDrawable, null);
        leftButton.setText("");
        rightButton.setText("");

        monthViewPager = (ViewPager) view.findViewById(R.id.historyViewPager);
        monthAdapter = new HistoryMonthAdapter(getChildFragmentManager(), monthList, this);
        monthViewPager.setAdapter(monthAdapter);
        
        monthViewPager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
			@Override
			public void onPageSelected(int position) {
				setTitleWithPager();
			}
			@Override
			public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
			}
			@Override
			public void onPageScrollStateChanged(int state) {
			}
		});

        m_currentTitle = monthAdapter.getPageTitle(0).toString();
        title.setText(m_currentTitle);
        return view;
    }
    
    void setTitleWithPager(){
    	int currentItemIndex = monthViewPager.getCurrentItem();
    	m_currentTitle = monthAdapter.getPageTitle(currentItemIndex).toString();
    	title.setText(m_currentTitle);
    }

    public static V3HistoryFragment newInstance(int tabId) {
        V3HistoryFragment fragment = new V3HistoryFragment();
        Bundle args = new Bundle();
        args.putInt("tab_id", tabId);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    protected void setHeader() {
        leftButton.setText("Previous");
        rightButton.setText("Next");

        leftButton.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                int currentItemIndex = monthViewPager.getCurrentItem();
                if (currentItemIndex > 0) {
                    currentItemIndex --;
                    m_currentTitle = monthAdapter.getPageTitle(currentItemIndex).toString();
                    title.setText(m_currentTitle);
                    monthViewPager.setCurrentItem(currentItemIndex, false);
                }
            }
        });

        rightButton.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                int currentItemIndex = monthViewPager.getCurrentItem();
                if (currentItemIndex < monthAdapter.getCount()-1){
                    currentItemIndex++;
                    m_currentTitle = monthAdapter.getPageTitle(currentItemIndex).toString();
                    title.setText(m_currentTitle);
                    monthViewPager.setCurrentItem(currentItemIndex, false);
                }
            }
        });

    }
}
