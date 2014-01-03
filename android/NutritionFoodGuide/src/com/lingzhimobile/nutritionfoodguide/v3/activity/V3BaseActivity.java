package com.lingzhimobile.nutritionfoodguide.v3.activity;

import android.support.v4.app.FragmentActivity;

public class V3BaseActivity  extends FragmentActivity{
	
	protected String m_currentTitle;
	
	public String getCurrentTitle(){
		return m_currentTitle;
	}

    @Override
    public void setContentView(int layoutResID) {
        super.setContentView(layoutResID);
    }
}
