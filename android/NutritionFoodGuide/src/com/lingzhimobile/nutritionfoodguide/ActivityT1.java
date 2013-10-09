package com.lingzhimobile.nutritionfoodguide;



import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.Button;

public class ActivityT1 extends Activity {
	static final String LogTag = "ActivityT1";
	
    @Override
    protected void onCreate(Bundle savedInstanceState) {
    	Log.d(LogTag, "onCreate savedInstanceState="+savedInstanceState);
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activityt1);
        
        dealParamIntent();
      
    }
    
	@Override
    protected void onNewIntent(Intent intent){
		Log.d(LogTag, "onNewIntent intent="+intent);
    	super.onNewIntent(intent);
    	setIntent(intent);
    	
    	dealParamIntent();
    }
	
	void dealParamIntent(){
		Tool.printActivityStack(this);
	}
}
