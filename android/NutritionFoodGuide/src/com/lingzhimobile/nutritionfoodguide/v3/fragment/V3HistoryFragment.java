package com.lingzhimobile.nutritionfoodguide.v3.fragment;

import java.util.ArrayList;
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
import android.widget.Button;
import android.widget.TextView;

import com.lingzhimobile.nutritionfoodguide.R;

public class V3HistoryFragment extends Fragment {

    List<Integer> monthList;
    Button previousButton, nextButton;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Bundle arg = getArguments();
        monthList = new ArrayList<Integer>();
        monthList.add(201308);
        monthList.add(201309);
        monthList.add(201310);
        monthList.add(201311);
        monthList.add(201312);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.v3_fragment_history, container,
                false);
        previousButton = (Button) view.findViewById(R.id.leftButton);
        nextButton = (Button) view.findViewById(R.id.rightButton);
        final ViewPager monthViewPager = (ViewPager) view
                .findViewById(R.id.historyViewPager);
        final MonthAdapter monthAdapter = new MonthAdapter(getChildFragmentManager());
        monthViewPager.setAdapter(monthAdapter);

        previousButton.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                int currentItemIndex = monthViewPager.getCurrentItem();
                if (currentItemIndex > 0)
                    monthViewPager.setCurrentItem(currentItemIndex - 1, false);
            }
        });

        nextButton.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                int currentItemIndex = monthViewPager.getCurrentItem();
                if (currentItemIndex < monthAdapter.getCount())
                    monthViewPager.setCurrentItem(currentItemIndex + 1, false);
            }
        });
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
        
        public static MonthFragment newInstance(int month) {
            MonthFragment fragment = new MonthFragment();
            Bundle args = new Bundle();
            args.putInt("month", month);
            fragment.setArguments(args);
            return fragment;
        }

        
        @Override
        public void onCreate(Bundle savedInstanceState) {
            // TODO Auto-generated method stub
            super.onCreate(savedInstanceState);
            
            mMonth = getArguments().getInt("month");
        }


        @Override
        public View onCreateView(LayoutInflater inflater, ViewGroup container,
                Bundle savedInstanceState) {
            View view = inflater.inflate(R.layout.v3_fragment_month, container,
                    false);
            TextView monthTextView = (TextView) view
                    .findViewById(R.id.monthTextView);
            monthTextView.setText(String.valueOf(mMonth));
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

    }
}
