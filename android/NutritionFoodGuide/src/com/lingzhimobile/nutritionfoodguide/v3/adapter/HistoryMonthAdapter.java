package com.lingzhimobile.nutritionfoodguide.v3.adapter;

import java.util.List;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import com.lingzhimobile.nutritionfoodguide.v3.fragment.HistoryMonthFragment;

public class HistoryMonthAdapter extends FragmentPagerAdapter {

    List<Integer> mMonthList;
    public HistoryMonthAdapter(FragmentManager fm, List<Integer> monthList) {
        super(fm);
        mMonthList = monthList;
    }

    @Override
    public Fragment getItem(int arg0) {
        int month = mMonthList.get(arg0);
        return HistoryMonthFragment.newInstance(month);
    }

    @Override
    public int getCount() {
        return mMonthList.size();
    }

    @Override
    public CharSequence getPageTitle(int position) {
        return String.valueOf(mMonthList.get(position));
    }

    
}
