package com.lingzhimobile.nutritionfoodguide.v3.activity;

import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Map.Entry;


import org.json.JSONArray;
import org.json.JSONException;

import android.R.integer;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.util.Pair;
import android.view.*;

import android.view.View.OnClickListener;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.*;


import com.lingzhimobile.nutritionfoodguide.*;
import com.lingzhimobile.nutritionfoodguide.v3.fragment.*;

public class V3ActivityIllness extends V3BaseActivity {
	
	static final String LogTag = "V3ActivityIllness";
	
	LinearLayout m_llTop;
	TextView m_tvTitle;
	Button m_btnBack;
	WebView m_webView1;
	
	String m_IllnessId;
	String m_prevActvTitle;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.v3_activity_illness);
        
        initViewHandles();
        initViewsContent();
        setViewEventHandlers();
        setViewsContent();
    }
    
    public void onStart() {
		Log.d(LogTag, "onStart");
		super.onStart();
	}
    public void onResume() {
		Log.d(LogTag, "onResume");
		super.onResume();		
	}
    
    @Override
    public void onWindowFocusChanged (boolean hasFocus){
        super.onWindowFocusChanged(hasFocus);
        if(hasFocus){
        	//to prevent m_prevActvTitle and m_btnBack overlap
        	String title1 = m_prevActvTitle;
//			Log.d(LogTag, "m_btnBack.getRight()="+m_btnBack.getRight()+", m_tvTitle.getLeft()="+m_tvTitle.getLeft()+", title1="+title1);
//			while (m_btnBack.getRight() > m_tvTitle.getLeft()){
//	        	if (title1.length()>=2)
//	        		title1 = title1.substring(0, title1.length()/2);
//	        	else title1 = "";
//	        	m_btnBack.setText(title1);//看来设置完这个并不立即导致尺寸改变
//	        	Log.d(LogTag, "m_btnBack.getRight()="+m_btnBack.getRight()+", m_tvTitle.getLeft()="+m_tvTitle.getLeft()+", title1="+title1);
//	        }
			if (m_btnBack.getRight() > m_tvTitle.getLeft()){
				int delta = m_btnBack.getRight() - m_tvTitle.getLeft();
				float titleWidth = m_btnBack.getPaint().measureText(title1);
				if ((titleWidth/2)>=delta){
					title1 = title1.substring(0, title1.length()/2);
				}else{
					title1 = "";
				}
				m_btnBack.setText(title1);
			}
        }
    }
    
    @Override
    protected void onDestroy() {
		//fix a warning . com.lingzhimobile.nutritionfoodguide.v3.activity.V3ActivityIllness has leaked IntentReceiver com.android.qualcomm.browsermanagement.BrowserManagement$1@41cd7790 that was originally registered here. Are you missing a call to unregisterReceiver()?
    	//android.app.IntentReceiverLeaked: Activity com.lingzhimobile.nutritionfoodguide.v3.activity.V3ActivityIllness has leaked IntentReceiver com.android.qualcomm.browsermanagement.BrowserManagement$1@41cd7790 that was originally registered here. Are you missing a call to unregisterReceiver()?
    	//solved by http://angrycode.cn/archives/476
//    	m_webView1.destroy();//Error: WebView.destroy() called while still attached!
		super.onDestroy();
		//http://blog.csdn.net/geekpark/article/details/14524673
    	if (m_webView1 != null){
    		if (m_llTop != null){
    			m_llTop.removeView(m_webView1);
    		}
    		m_webView1.removeAllViews();
    		m_webView1.destroy();
    	}
	}
    
    void initViewHandles(){
    	m_llTop = (LinearLayout) findViewById(R.id.llTop);
    	
    	Button rightButton = (Button) findViewById(R.id.rightButton);
    	rightButton.setVisibility(View.GONE);
    	m_btnBack = (Button) findViewById(R.id.leftButton);
    	m_webView1 = (WebView)findViewById(R.id.webView1);
    	m_tvTitle = (TextView) findViewById(R.id.titleText);
    	
	}
    
    void initViewsContent(){
    	Intent paramIntent = getIntent();
        m_IllnessId = paramIntent.getStringExtra(Constants.COLUMN_NAME_IllnessId);
        m_prevActvTitle = paramIntent.getStringExtra(Constants.IntentParamKey_BackButtonTitle);
        
    }
    
    void setViewEventHandlers(){
    	Tool.setWebViewBasicHere(m_webView1);
    	
    	m_btnBack.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
    }
    
    void setViewsContent(){
    	HashMap<String, HashMap<String, Object>> illnessInfoDict2Level = GlobalVar.getAllIllness2LevelDict(this);
    	HashMap<String, Object> illnessInfo = illnessInfoDict2Level.get(m_IllnessId);
    	String illnessCaption = (String)illnessInfo.get(Constants.COLUMN_NAME_IllnessNameCn);
    	
    	m_currentTitle = illnessCaption;
        m_tvTitle.setText(m_currentTitle);
        
        if (m_prevActvTitle!=null)
        	m_btnBack.setText(m_prevActvTitle);
        
        
        
    	
    	String url = (String)illnessInfo.get(Constants.COLUMN_NAME_UrlCn);
    	m_webView1.loadUrl(url);
    }
    
    public boolean onKeyDown(int keyCode, KeyEvent event){  
    	if(m_webView1.canGoBack() && keyCode == KeyEvent.KEYCODE_BACK){  
    		m_webView1.goBack();
	        return true;
	    }
    	return super.onKeyDown(keyCode, event);
    }  
    

    

}
