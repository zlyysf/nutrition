package com.lingzhimobile.nutritionfoodguide.v3.fragment;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.TextView;

import com.lingzhimobile.nutritionfoodguide.DataAccess;
import com.lingzhimobile.nutritionfoodguide.R;
import com.lingzhimobile.nutritionfoodguide.test.TestCaseDA;

public class V3HistoryFragment extends V3BaseHeadFragment {

    List<Integer> monthList;
    ViewPager monthViewPager;
    MonthAdapter monthAdapter;

    ArrayList<HashMap<String, Object>> historyMap;

    DataAccess da;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Bundle arg = getArguments();

        TestCaseDA.test_genData_UserRecordSymptom1(getActivity());
        da = DataAccess.getSingleton(getActivity());
        monthList = da.getUserRecordSymptom_DistinctMonth();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.v3_fragment_history, container,
                false);
        initHeaderLayout(view);
        monthViewPager = (ViewPager) view.findViewById(R.id.historyViewPager);
        monthAdapter = new MonthAdapter(getChildFragmentManager());
        monthViewPager.setAdapter(monthAdapter);

        title.setText(monthAdapter.getPageTitle(0));
        return view;
    }

    public static V3HistoryFragment newInstance(int tabId) {
        V3HistoryFragment fragment = new V3HistoryFragment();
        Bundle args = new Bundle();
        args.putInt("tab_id", tabId);
        fragment.setArguments(args);
        return fragment;
    }

    static class MonthFragment extends Fragment {

        int mMonth;
        ArrayList<HashMap<String, Object>> records;
        DataAccess da;

        public static MonthFragment newInstance(int month) {
            MonthFragment fragment = new MonthFragment();
            Bundle args = new Bundle();
            args.putInt("month", month);
            fragment.setArguments(args);
            return fragment;
        }

        @Override
        public void onCreate(Bundle savedInstanceState) {
            super.onCreate(savedInstanceState);

            da = DataAccess.getSingleton(getActivity());
            mMonth = getArguments().getInt("month");
            records = da.getUserRecordSymptomDataByRange_withStartDayLocal(0,
                    0, mMonth, mMonth + 1);
        }

        @Override
        public View onCreateView(LayoutInflater inflater, ViewGroup container,
                Bundle savedInstanceState) {
            View view = inflater.inflate(R.layout.v3_fragment_month, container,
                    false);
            TextView monthTextView = (TextView) view
                    .findViewById(R.id.monthTextView);
            monthTextView.setText(String.valueOf(mMonth));
            ((TextView) view.findViewById(R.id.recordTextView)).setText(records
                    .toString());
            return view;
        }

    }

    class MonthAdapter extends FragmentPagerAdapter {

        public MonthAdapter(FragmentManager fm) {
            super(fm);
        }

        @Override
        public Fragment getItem(int arg0) {
            int month = monthList.get(arg0);
            return MonthFragment.newInstance(month);
        }

        @Override
        public int getCount() {
            return monthList.size();
        }

        @Override
        public CharSequence getPageTitle(int position) {
            return String.valueOf(monthList.get(position));
        }

        
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
                    title.setText(monthAdapter.getPageTitle(currentItemIndex));
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
                    title.setText(monthAdapter.getPageTitle(currentItemIndex));
                    monthViewPager.setCurrentItem(currentItemIndex, false);
                }
            }
        });

    }
}
