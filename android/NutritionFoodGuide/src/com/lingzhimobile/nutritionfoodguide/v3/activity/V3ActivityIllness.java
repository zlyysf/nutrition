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
	
	TextView m_tvTitle;
	Button m_btnBack;
	WebView m_webView1;
	
	String m_IllnessId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.v3_activity_illness);
        
        initViewHandles();
        initViewsContent();
        setViewEventHandlers();
        setViewsContent();
    }
    
    void initViewHandles(){
    	Button rightButton = (Button) findViewById(R.id.rightButton);
    	rightButton.setVisibility(View.GONE);
    	m_btnBack = (Button) findViewById(R.id.leftButton);
    	m_webView1 = (WebView)findViewById(R.id.webView1);
    	m_tvTitle = (TextView) findViewById(R.id.titleText);
    	
	}
    
    void initViewsContent(){
    	Intent intent = getIntent();
        m_IllnessId = intent.getStringExtra(Constants.COLUMN_NAME_IllnessId);
        
        
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
    	m_tvTitle.setText(illnessCaption);
    	
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
