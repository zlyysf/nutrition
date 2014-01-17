package com.lingzhimobile.nutritionfoodguide.v3.fragment;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import android.R.integer;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import com.lingzhimobile.nutritionfoodguide.DataAccess;
import com.lingzhimobile.nutritionfoodguide.R;
import com.lingzhimobile.nutritionfoodguide.test.TestCaseDA;
import com.lingzhimobile.nutritionfoodguide.v3.adapter.HistoryMonthAdapter;

public class V3HistoryFragment extends V3BaseHeadFragment {
	static final String LogTag = V3HistoryFragment.class.getSimpleName();

	Button m_btnPrev, m_btnNext;
	TextView m_tvNoData;
    ViewPager historyViewPager;
    HistoryMonthAdapter monthAdapter;
    
    ArrayList<Integer> m_monthList;



    /*
    onCreateView
//    moveToThePage pageIdx=0
//    moveToThePage pageIdx=3
    setTitleWithPager pageIdx=3
    onActivityCreated enter
    onActivityCreated exit
    onPageSelected position=0
    setTitleWithPager pageIdx=0
    onViewStateRestored enter
    onViewStateRestored exit
    onStart
    onResume
    */

	
    @Override
    public void onCreate(Bundle savedInstanceState) {
    	DataAccess.mLogEnabled = false;
    	
    	Log.d(LogTag, "onCreate enter");
        super.onCreate(savedInstanceState);
        Log.d(LogTag, "onCreate exit");
    }
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
    	Log.d(LogTag, "onCreateView");
        View view = inflater.inflate(R.layout.v3_fragment_history, container, false);
        initViewHandles(inflater, view);
        initViewsContent();
        setViewEventHandlers();
        setViewsContent();
        return view;
    }
	public void onActivityCreated (Bundle savedInstanceState){
		Log.d(LogTag, "onActivityCreated enter");
		super.onActivityCreated(savedInstanceState);
		Log.d(LogTag, "onActivityCreated exit");
	}
	
	public void onViewStateRestored (Bundle savedInstanceState){
		//super.restoreViewState(null) should be called before.在这里会导致 OnPageChangeListener.onPageSelected 被调用
		Log.d(LogTag, "onViewStateRestored enter");
		super.onViewStateRestored(savedInstanceState);
		Log.d(LogTag, "onViewStateRestored exit");
		
		setViewsState();
	}
    public void onStart() {
		Log.d(LogTag, "onStart");
		super.onStart();
	}
    public void onResume() {
		Log.d(LogTag, "onResume");
		super.onResume();
	}
	public void onPause() {
		Log.d(LogTag, "onPause");
		super.onPause();
	}
    public void onStop() {
		Log.d(LogTag, "onStop");
		super.onStop();
	}

    void initViewHandles(LayoutInflater inflater, View view){
        initHeaderLayout(view);
        m_btnPrev = leftButton;
        m_btnNext = rightButton;
        m_tvNoData = (TextView)view.findViewById(R.id.tvNoData);
        historyViewPager = (ViewPager) view.findViewById(R.id.historyViewPager);
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
        
        title.setText(R.string.tabCaption_history);
        
//    	DataAccess da = DataAccess.getSingleton(getActivity());
//        m_monthList = da.getUserRecordSymptom_DistinctMonth();
//        if (m_monthList==null || m_monthList.size()==0){
//        	m_tvNoData.setVisibility(View.VISIBLE);
//        	historyViewPager.setVisibility(View.INVISIBLE);
//        }else{
//        	m_tvNoData.setVisibility(View.INVISIBLE);
//        	historyViewPager.setVisibility(View.VISIBLE);
//        	monthAdapter = new HistoryMonthAdapter(getChildFragmentManager(), m_monthList, this);
//            historyViewPager.setAdapter(monthAdapter);
//        }
        
//        if (m_monthList!=null && m_monthList.size()>0){
//        	//这种方法几种情况都可以，但是会闪一下
////        	historyViewPager.post(new Runnable() {
////				@Override
////				public void run() {
////					int lastItemPos = monthAdapter.getCount()-1;
////		        	moveToThePage(lastItemPos);
////		        	setTitleWithPager(lastItemPos);
////				}
////			});
//        	
//        	//用这种方式，在move到last后，还会有莫名其妙的OnPageChangeListener.onPageSelected(0)被调用(即使是在之后加这个listener)，
//        	//导致title是位置0页的，但是数据却是last的数据。但是这是在以前有一条数据且点进历史页后，再造之前的数据，再点进历史页发生的。
//        	//如果以前没有点进过历史页，则是正常。
////        	int lastItemPos = monthAdapter.getCount()-1;
////        	moveToThePage(lastItemPos);
////        	setTitleWithPager(lastItemPos);
//        	
//        	int firstItemPos = 0;
//        	int lastItemPos = monthAdapter.getCount()-1;
//        	if (firstItemPos==lastItemPos){
//        		moveToThePage(lastItemPos);
//        	}else{
//        		moveToThePage(firstItemPos);
//        		moveToThePage(lastItemPos);
//        	}
//        	setTitleWithPager(lastItemPos);
//    	}
    }
    
    void setViewEventHandlers(){
        m_btnPrev.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                int currentItemIndex = historyViewPager.getCurrentItem();
                Log.d(LogTag, "btnPrev.onClick currentItemIndex="+currentItemIndex);
                moveToThePage(currentItemIndex-1);
            }
        });

        m_btnNext.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                int currentItemIndex = historyViewPager.getCurrentItem();
                Log.d(LogTag, "btnNext.onClick currentItemIndex="+currentItemIndex);
                moveToThePage(currentItemIndex+1);
            }
        });
        
        historyViewPager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
			@Override
			public void onPageSelected(int position) {
				Log.d(LogTag, "onPageSelected position="+position);
				setTitleWithPager(position);
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
        setNavButtonEnableState();
    }
    void setViewsState(){
    	DataAccess da = DataAccess.getSingleton(getActivity());
        m_monthList = da.getUserRecordSymptom_DistinctMonth();
        if (m_monthList==null || m_monthList.size()==0){
        	m_tvNoData.setVisibility(View.VISIBLE);
        	historyViewPager.setVisibility(View.INVISIBLE);
        }else{
        	m_tvNoData.setVisibility(View.INVISIBLE);
        	historyViewPager.setVisibility(View.VISIBLE);
        	monthAdapter = new HistoryMonthAdapter(getChildFragmentManager(), m_monthList, this);
            historyViewPager.setAdapter(monthAdapter);
            
            historyViewPager.destroyDrawingCache();
            
            
            monthAdapter.notifyDataSetChanged();
            
        }
        
        if (m_monthList!=null && m_monthList.size()>0){
        	int lastItemPos = monthAdapter.getCount()-1;
        	moveToThePage(lastItemPos);
        	setTitleWithPager(lastItemPos);
    	}
    }

    void moveToThePage(int pageIdx){
    	Log.d(LogTag, "moveToThePage pageIdx="+pageIdx);
    	if (pageIdx>=0 && pageIdx<monthAdapter.getCount());{
	    	historyViewPager.setCurrentItem(pageIdx, false);//seemed will cause OnPageChangeListener.onPageSelected
	//        setTitleWithPager(pageIdx);
    	}
        setNavButtonEnableState();
    }
    void setTitleWithPager(int pageIdx){
    	Log.d(LogTag, "setTitleWithPager pageIdx="+pageIdx);
    	if (monthAdapter != null){
    		m_currentTitle = monthAdapter.getPageTitle(pageIdx).toString();
    		title.setText(m_currentTitle);
    	}else{
    		
    	}
    }

    public static V3HistoryFragment newInstance(int tabId) {
        V3HistoryFragment fragment = new V3HistoryFragment();
        Bundle args = new Bundle();
//        args.putInt("tab_id", tabId);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    protected void setHeader() {
    }
    
    void setNavButtonEnableState(){
    	if (m_monthList==null || m_monthList.size()<=1){
    		m_btnPrev.setEnabled(false);
    		m_btnNext.setEnabled(false);
    	}else{
    		int currentItemIndex = historyViewPager.getCurrentItem();
        	if (currentItemIndex>0){
        		m_btnPrev.setEnabled(true);
        	} else {
        		m_btnPrev.setEnabled(false);
			}
        	if (currentItemIndex==m_monthList.size()-1){
        		m_btnNext.setEnabled(false);
        	}else{
        		m_btnNext.setEnabled(true);
        	}
    	}
    }
}
