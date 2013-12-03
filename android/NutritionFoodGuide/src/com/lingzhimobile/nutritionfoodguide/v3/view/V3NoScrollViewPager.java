package com.lingzhimobile.nutritionfoodguide.v3.view;

import android.content.Context;
import android.support.v4.view.ViewPager;
import android.util.AttributeSet;

public class V3NoScrollViewPager extends ViewPager {

    private boolean isCanScroll = false; 
    
    public void setScanScroll(boolean isCanScroll){  
        this.isCanScroll = isCanScroll;  
    }  
  
    public V3NoScrollViewPager(Context context) {
        super(context);
    }

    public V3NoScrollViewPager(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    @Override
    public void scrollTo(int x, int y) {
        if (isCanScroll){  
            super.scrollTo(x, y);  
        }  
    }

    @Override
    public void setCurrentItem(int item, boolean smoothScroll) {
        // TODO Auto-generated method stub
        isCanScroll = true;
        super.setCurrentItem(item, smoothScroll);
        isCanScroll = false;
    }

}
