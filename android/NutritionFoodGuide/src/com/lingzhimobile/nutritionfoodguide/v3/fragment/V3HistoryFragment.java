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
import android.widget.Button;

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
    
    Button m_btnPrev, m_btnNext;

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
        initViewHandles(inflater, view);
        initViewsContent();
        setViewEventHandlers();
        setViewsContent();
        return view;
    }
    void initViewHandles(LayoutInflater inflater, View view){
        initHeaderLayout(view);
        m_btnPrev = leftButton;
        m_btnNext = rightButton;
        monthViewPager = (ViewPager) view.findViewById(R.id.historyViewPager);
    }
    void initViewsContent(){
    	Drawable prevDrawable = getResources().getDrawable(R.drawable.v3_prev_bg);
        prevDrawable.setBounds(0, 0, 27, 45);
        m_btnPrev.setCompoundDrawables(prevDrawable, null, null, null);

        Drawable nextDrawable = getResources().getDrawable(R.drawable.v3_next_bg);
        nextDrawable.setBounds(0, 0, 27, 45);
        m_btnNext.setCompoundDrawables(null, null, nextDrawable, null);
        m_btnPrev.setText("");
        m_btnNext.setText("");
        
        monthAdapter = new HistoryMonthAdapter(getChildFragmentManager(), monthList, this);
        monthViewPager.setAdapter(monthAdapter);
    }
    
    void setViewEventHandlers(){
        m_btnPrev.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                int currentItemIndex = monthViewPager.getCurrentItem();
                if (currentItemIndex > 0) {
                    currentItemIndex --;
                    monthViewPager.setCurrentItem(currentItemIndex, false);
                    setTitleWithPager();
                }
                setNavButtonEnableState();
            }
        });

        m_btnNext.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                int currentItemIndex = monthViewPager.getCurrentItem();
                if (currentItemIndex < monthAdapter.getCount()-1){
                    currentItemIndex++;
                    monthViewPager.setCurrentItem(currentItemIndex, false);
                    setTitleWithPager();
                }
                setNavButtonEnableState();
            }
        });
        
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
    }
    void setViewsContent(){
        monthViewPager.setCurrentItem(monthAdapter.getCount()-1, false);
        setNavButtonEnableState();
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
    }
    
    void setNavButtonEnableState(){
    	if (monthList==null || monthList.size()<=1){
    		m_btnPrev.setEnabled(false);
    		m_btnNext.setEnabled(false);
    	}else{
    		int currentItemIndex = monthViewPager.getCurrentItem();
        	if (currentItemIndex>0){
        		m_btnPrev.setEnabled(true);
        	} else {
        		m_btnPrev.setEnabled(false);
			}
        	if (currentItemIndex==monthList.size()-1){
        		m_btnNext.setEnabled(false);
        	}else{
        		m_btnNext.setEnabled(true);
        	}
    	}
    }
}
