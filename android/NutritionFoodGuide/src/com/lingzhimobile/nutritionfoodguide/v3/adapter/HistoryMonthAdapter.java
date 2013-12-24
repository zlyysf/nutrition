package com.lingzhimobile.nutritionfoodguide.v3.adapter;

import java.util.*;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import com.lingzhimobile.nutritionfoodguide.v3.fragment.HistoryMonthFragment;

public class HistoryMonthAdapter extends FragmentPagerAdapter {

	ArrayList<Integer> mMonthList;
    public HistoryMonthAdapter(FragmentManager fm, ArrayList<Integer> monthList) {
        super(fm);
        mMonthList = monthList;
    }

    @Override
    public Fragment getItem(int arg0) {
        int yearMonth = mMonthList.get(arg0);
        return HistoryMonthFragment.newInstance(yearMonth);
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
