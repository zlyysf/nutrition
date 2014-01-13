package com.lingzhimobile.nutritionfoodguide.v3.fragment;

import java.util.ArrayList;
import java.util.HashMap;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import android.widget.TextView;

import com.lingzhimobile.nutritionfoodguide.DataAccess;
import com.lingzhimobile.nutritionfoodguide.R;
import com.lingzhimobile.nutritionfoodguide.v3.adapter.HistoryDayAdapter;

public class HistoryMonthFragment extends Fragment {
	
	final static String Key_yearMonth = "yearMonth";

    int m_yearMonth;
    V3BaseHeadFragment m_topfragment;
    ArrayList<HashMap<String, Object>> records;
    DataAccess da;

    public static HistoryMonthFragment newInstance(int yearMonth, V3BaseHeadFragment topfragment) {
    	
        HistoryMonthFragment fragment = new HistoryMonthFragment();
        fragment.m_topfragment = topfragment;
        Bundle args = new Bundle();
        args.putInt(Key_yearMonth, yearMonth);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        da = DataAccess.getSingleton(getActivity());
        m_yearMonth = getArguments().getInt(Key_yearMonth);
        records = da.getUserRecordSymptomDataByRange_withStartDayLocal(0,0, m_yearMonth, m_yearMonth + 1);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.v3_fragment_month, container, false);
        ListView recordListView = (ListView) view.findViewById(R.id.recordListView);
        recordListView.setFastScrollEnabled(true);
        HistoryDayAdapter dayAdapter = new HistoryDayAdapter(getActivity(), records, m_topfragment);
        recordListView.setAdapter(dayAdapter);
        return view;
    }

}
