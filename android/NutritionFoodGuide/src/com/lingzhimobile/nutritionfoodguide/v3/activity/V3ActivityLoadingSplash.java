package com.lingzhimobile.nutritionfoodguide.v3.activity;

import com.lingzhimobile.nutritionfoodguide.R;
import com.lingzhimobile.nutritionfoodguide.StoredConfigTool;
import com.lingzhimobile.nutritionfoodguide.ToolParse;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.text.TextUtils;
import android.util.Log;


public class V3ActivityLoadingSplash extends Activity {


	static final String LogTag = V3ActivityLoadingSplash.class.getSimpleName();
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.v3_activity_loadingsplash);
        
        boolean isFirstOpen = StoredConfigTool.isFirstBeOpenedAtCurrentInstall(this);
        long msDelay = 1000;
        if (isFirstOpen){
        	msDelay = 3000;
        	ToolParse.syncRemoteDataToLocal(this, null);
        }
        Log.d(LogTag, "isFirstOpen="+isFirstOpen);
        
        new CountDownTimer(msDelay, 100) {
            @Override
            public void onTick(long millisUntilFinished) {
            }

            @Override
            public void onFinish() {
                gotoMainTabActivity();
            }
        }.start();
    }

    private void gotoMainTabActivity() {
        Intent intent = new Intent();
        intent.setClass(this, V3ActivityHome.class);
        startActivity(intent);
        finish();
    }

    


}
