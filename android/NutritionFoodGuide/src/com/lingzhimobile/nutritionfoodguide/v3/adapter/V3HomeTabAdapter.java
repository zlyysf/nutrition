package com.lingzhimobile.nutritionfoodguide.v3.adapter;

import com.lingzhimobile.nutritionfoodguide.v3.fragment.V3DiagnoseFragment;
import com.lingzhimobile.nutritionfoodguide.v3.fragment.V3EncyclopediaFragment;
import com.lingzhimobile.nutritionfoodguide.v3.fragment.V3TabContentFragment;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

public class V3HomeTabAdapter extends FragmentPagerAdapter{

    private String[] mSectionTitles;
    
    public V3HomeTabAdapter(FragmentManager fm, String[] sectionTitles) {
        super(fm);
        mSectionTitles = sectionTitles;
    }

    @Override
    public Fragment getItem(int arg0) {
        if (arg0 == 0){
         return V3DiagnoseFragment.newInstance(arg0);
        } else if (arg0 == 3) {
            return V3EncyclopediaFragment.newInstance(arg0);
        }
        else {
        return  V3TabContentFragment.newInstance(arg0);
        }
    }

    @Override
    public int getCount() {
        return mSectionTitles.length;
    }

}
