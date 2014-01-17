package com.lingzhimobile.nutritionfoodguide.v3.fragment;

import java.util.ArrayList;
import java.util.HashMap;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.lingzhimobile.nutritionfoodguide.DataAccess;
import com.lingzhimobile.nutritionfoodguide.R;
import com.lingzhimobile.nutritionfoodguide.v3.adapter.HistoryDayAdapter;
import com.lingzhimobile.nutritionfoodguide.v3.adapter.HistoryMonthAdapter;

public class HistoryMonthFragment extends Fragment {
	static final String LogTag = HistoryMonthFragment.class.getSimpleName();
	
	final static String Key_yearMonth = "yearMonth";
	
	View m_fragmentView ;
	
	ListView m_recordListView;
	LinearLayout m_llSideIndex;

	HistoryDayAdapter m_dayAdapter;
    public int m_yearMonth;
    V3BaseHeadFragment m_topfragment;
    ArrayList<HashMap<String, Object>> records;

    public static HistoryMonthFragment newInstance(int yearMonth, V3BaseHeadFragment topfragment) {
    	
        HistoryMonthFragment fragment = new HistoryMonthFragment();
        fragment.m_topfragment = topfragment;
        fragment.m_yearMonth = yearMonth;
//        Bundle args = new Bundle();
//        args.putInt(Key_yearMonth, yearMonth);
//        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
    	Log.d(LogTag, "onCreate enter ");
        super.onCreate(savedInstanceState);

        
        Log.d(LogTag, "onCreate exit ");
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
    	Log.d(LogTag, "onCreateView ");
    	m_fragmentView = inflater.inflate(R.layout.v3_fragment_month, container, false);
        m_recordListView = (ListView) m_fragmentView.findViewById(R.id.recordListView);
        m_llSideIndex = (LinearLayout)m_fragmentView.findViewById(R.id.llSideIndex);
        
        refreshViews(m_yearMonth);
        
        return m_fragmentView;
    }

	public void onViewStateRestored (Bundle savedInstanceState){
		//super.restoreViewState(null) should be called before.在这里会导致 OnPageChangeListener.onPageSelected 被调用
		Log.d(LogTag, "onViewStateRestored enter");
		super.onViewStateRestored(savedInstanceState);
		Log.d(LogTag, "onViewStateRestored exit");
		
	}
    public void onStart() {
		Log.d(LogTag, "onStart");
		super.onStart();
	}
    public void onResume() {
		Log.d(LogTag, "onResume");
		super.onResume();
	}
    
    public void refreshViews(int yearMonth){
    	View vw = getView();
    	Log.d(LogTag, "refreshViews m_fragmentView="+m_fragmentView+" , getView="+vw);//看来两个东西不是同一个 refreshViews m_fragmentView=android.widget.LinearLayout@419a7d40 , getView=null

    	m_yearMonth = yearMonth;
    	if (m_fragmentView != null){
        	DataAccess da = DataAccess.getSingleton(getActivity());
//            m_yearMonth = getArguments().getInt(Key_yearMonth);
            records = da.getUserRecordSymptomDataByRange_withStartDayLocal(0,0, m_yearMonth, m_yearMonth + 1);
            
        	m_recordListView = (ListView) m_fragmentView.findViewById(R.id.recordListView);
            m_llSideIndex = (LinearLayout)m_fragmentView.findViewById(R.id.llSideIndex);
            if (m_dayAdapter == null){
            	m_dayAdapter = new HistoryDayAdapter(getActivity(), records, m_topfragment, m_recordListView, m_llSideIndex);
            	m_recordListView.setAdapter(m_dayAdapter);
            	m_dayAdapter.notifyDataSetChanged();
            }else{
            	m_dayAdapter.updateData(getActivity(), records, m_topfragment, m_recordListView, m_llSideIndex);
            }
    	}
    }
    
}
