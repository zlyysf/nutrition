package com.lingzhimobile.nutritionfoodguide.v3.adapter;

import java.util.*;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import com.lingzhimobile.nutritionfoodguide.v3.fragment.HistoryMonthFragment;
import com.lingzhimobile.nutritionfoodguide.v3.fragment.V3BaseHeadFragment;

public class HistoryMonthAdapter extends FragmentPagerAdapter {

	ArrayList<Integer> mMonthList;
	V3BaseHeadFragment m_fragment;
    public HistoryMonthAdapter(FragmentManager fm, ArrayList<Integer> monthList, V3BaseHeadFragment fragment) {
        super(fm);
        mMonthList = monthList;
        m_fragment = fragment;
    }

    @Override
    public Fragment getItem(int arg0) {
        int yearMonth = mMonthList.get(arg0);
        return HistoryMonthFragment.newInstance(yearMonth,m_fragment);
    }

    @Override
    public int getCount() {
        return mMonthList==null?0:mMonthList.size();
    }

    @Override
    public CharSequence getPageTitle(int position) {
    	if (mMonthList!=null){
    		int yearMonth = mMonthList.get(position);
        	int year = yearMonth / 100;
        	int month = yearMonth % 100;
        	String title = year + " 年 " + month + " 月";
            return title;
    	}else{
    		return "";
    	}
    }

    
}
