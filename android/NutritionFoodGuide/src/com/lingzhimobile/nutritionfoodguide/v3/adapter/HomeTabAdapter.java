package com.lingzhimobile.nutritionfoodguide.v3.adapter;

import com.lingzhimobile.nutritionfoodguide.v3.fragment.TabContentFragment;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

public class HomeTabAdapter extends FragmentPagerAdapter{

    private String[] mSectionTitles;
    
    public HomeTabAdapter(FragmentManager fm, String[] sectionTitles) {
        super(fm);
        mSectionTitles = sectionTitles;
    }

    @Override
    public Fragment getItem(int arg0) {
        // TODO Auto-generated method stub
        return  TabContentFragment.newInstance(arg0);
    }

    @Override
    public int getCount() {
        // TODO Auto-generated method stub
        return mSectionTitles.length;
    }

}
