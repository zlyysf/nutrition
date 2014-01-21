package com.lingzhimobile.nutritionfoodguide.v3.adapter;

import java.util.*;

import android.os.Parcelable;
import android.support.v4.app.*;
import android.support.v4.view.*;

import android.text.style.SuperscriptSpan;
import android.util.Log;
import android.view.*;

import com.lingzhimobile.nutritionfoodguide.*;
import com.lingzhimobile.nutritionfoodguide.v3.fragment.*;


public class HistoryMonthAdapter extends FragmentStatePagerAdapterCustom//FragmentPagerAdapter//FragmentStatePagerAdapter 
{
	static final String LogTag = HistoryMonthAdapter.class.getSimpleName();
	ArrayList<Integer> mMonthList;
	
	V3BaseHeadFragment m_fragment;
	

    public HistoryMonthAdapter(FragmentManager fm, ArrayList<Integer> monthList, V3BaseHeadFragment fragment) {
        super(fm);
        mMonthList = monthList;
        m_fragment = fragment;
        
        
    }

    @Override
    public Fragment getItem(int arg0) {
    	Log.d(LogTag, "getItem enter "+arg0);
        int yearMonth = mMonthList.get(arg0);
        Fragment f1 = HistoryMonthFragment.newInstance(yearMonth,m_fragment);
        Log.d(LogTag, "getItem exit "+arg0+ " ret "+f1);
        return f1;
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
//        	String title = year + " 年 " + month + " 月";
        	String title = year + "." + month;
            return title;
    	}else{
    		return "";
    	}
    }

    
    //related to FragmentStatePagerAdapter
    //根据log显示就没有被调用到
    @Override
    public int getItemPosition(Object item){
//    	super.getItemPosition(item);
    	Log.d(LogTag, "getItemPosition "+item);
    	return POSITION_NONE;
    }
    
    public void startUpdate (ViewGroup container){
    	Log.d(LogTag, "startUpdate enter "+container);
    	super.startUpdate(container);
    	Log.d(LogTag, "startUpdate exit "+container);
    }
    public void startUpdate (View container){
    	Log.d(LogTag, "startUpdate enter "+container);
    	super.startUpdate(container);
    	Log.d(LogTag, "startUpdate exit "+container);
    }

    public void finishUpdate (ViewGroup container){
    	Log.d(LogTag, "finishUpdate enter "+container);
    	super.finishUpdate(container);
    	Log.d(LogTag, "finishUpdate exit "+container);
    }
    public void finishUpdate (View container){
    	Log.d(LogTag, "finishUpdate enter "+container);
    	super.finishUpdate(container);
    	Log.d(LogTag, "finishUpdate exit "+container);
    }
    public Object instantiateItem (ViewGroup container, int position){
    	Log.d(LogTag, "instantiateItem VG enter "+position+" "+container);
    	
    	boolean isUsingCache = false;
    	if (mFragments.size() > position) {
            Fragment f = mFragments.get(position);
            if (f != null) {
            	isUsingCache = true;
            }
        }
    	
    	//从log中看出 super.instantiateItem 里面会条件性调用 getItem 方法。目前是第一次调用，之后不调用，应该是用缓存。
    	HistoryMonthFragment retObj = (HistoryMonthFragment)super.instantiateItem(container, position);
    	if (isUsingCache){
    		retObj.needRefreshViews(mMonthList.get(position));//目前还有其中的listview不时变白板的问题
    	}
    	
    	
//    	//这样还不行，会导致 java.lang.IllegalStateException: Fragment HistoryMonthFragment{4189e4e8} is not currently in the FragmentManager
//    	Object retObj = getItem(position);
    	
    	Log.d(LogTag, "instantiateItem VG exit  "+position+" "+container+ ". ret="+retObj);
    	return retObj;
    }
    public Object instantiateItem (View container, int position){
    	Log.d(LogTag, "instantiateItem V enter "+position+" "+container);
    	Object retObj = super.instantiateItem(container, position);
    	Log.d(LogTag, "instantiateItem V exit  "+position+" "+container+ ". ret="+retObj);
    	return retObj;
    }
    
    public boolean isViewFromObject (View view, Object object){
    	boolean ret = super.isViewFromObject(view, object);
    	Log.d(LogTag, "isViewFromObject exit "+ret+" "+view+" , "+object);
    	return ret;
    }
    public void restoreState (Parcelable state, ClassLoader loader){
    	Log.d(LogTag, "restoreState");
    	super.restoreState(state, loader);
    }
    public void setPrimaryItem (ViewGroup container, int position, Object object){
    	Log.d(LogTag, "setPrimaryItem "+position+", "+container+" , "+object);
    	super.setPrimaryItem(container, position, object);
    }
    public void setPrimaryItem (View container, int position, Object object){
    	Log.d(LogTag, "setPrimaryItem "+position+", "+container+" , "+object);
    	super.setPrimaryItem(container, position, object);
    }
    
}
