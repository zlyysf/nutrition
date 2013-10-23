package com.lingzhimobile.nutritionfoodguide;


import java.util.*;

import com.umeng.analytics.MobclickAgent;


import android.R.integer;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Resources;
import android.database.Cursor;
import android.os.Bundle;
import android.text.Selection;
import android.text.Spannable;
import android.util.*;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnFocusChangeListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.*;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.RadioGroup.OnCheckedChangeListener;
import android.widget.ExpandableListView.*;


public class ActivitySetting extends Activity {
	
	static final String LogTag = "ActivitySetting";
	
	TextView m_tvTitle;
	Button m_btnCancel,m_btnTopRight;
	LinearLayout m_llFeedback;
	
	public void onResume() {
		super.onResume();
		MobclickAgent.onResume(this);
	}
	public void onPause() {
		super.onPause();
		MobclickAgent.onPause(this);
	}

	@Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_setting);
        
        initViewHandles();
        initViewsContent();
        setViewsContent();
        setViewEventHandlers();
    }
	@Override
	protected void onStart() {
        super.onStart();
    }
	
	void initViewHandles(){
		m_tvTitle = (TextView)findViewById(R.id.tvTitle);
		m_btnTopRight = (Button) findViewById(R.id.btnTopRight);
        m_btnCancel = (Button) findViewById(R.id.btnCancel);
        m_llFeedback = (LinearLayout)findViewById(R.id.llFeedback);
	}
	void initViewsContent(){

		Intent paramIntent = getIntent();
        String prevActvTitle = paramIntent.getStringExtra(Constants.IntentParamKey_BackButtonTitle);
        if (prevActvTitle!=null)
        	m_btnCancel.setText(prevActvTitle);
        
		 m_tvTitle.setText(R.string.title_setting);
		 m_btnTopRight.setVisibility(View.GONE);
	}
	void setViewEventHandlers(){

        m_btnCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	finish();
            }
        });
        m_llFeedback.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent sendEmailIntent = new Intent(Intent.ACTION_SEND);

				sendEmailIntent.putExtra(Intent.EXTRA_EMAIL, new String[]{ Constants.Email_feedback });
				//sendEmailIntent.putExtra(Intent.EXTRA_CC, new String[]{ "abc@126.com", "test@126.com" });
				sendEmailIntent.putExtra(Intent.EXTRA_SUBJECT,getResources().getString(R.string.feedbackEmailTitle));
				sendEmailIntent.putExtra(Intent.EXTRA_TEXT,
						" ");

				sendEmailIntent.setType("text/html");
				startActivity(Intent.createChooser(sendEmailIntent,	getResources().getString(R.string.feedbackEmailChooseSender)));
			}
		});
	}
	
	
	void setViewsContent(){
	}

    
}













