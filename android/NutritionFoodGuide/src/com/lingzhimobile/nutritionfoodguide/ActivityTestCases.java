package com.lingzhimobile.nutritionfoodguide;



import com.lingzhimobile.nutritionfoodguide.test.TestCaseDA;
import com.lingzhimobile.nutritionfoodguide.test.TestCaseRecommendFood;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class ActivityTestCases extends Activity implements OnClickListener{
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_testcases);
        
        Button button1 = (Button)findViewById(R.id.btnTestDA1);
        button1.setOnClickListener(this);
        button1 = (Button)findViewById(R.id.btnTestRF1);
        button1.setOnClickListener(this);
      
    }
    
    @Override
	public void onClick(View view)
	{

    	
//		Intent intent = null;
		switch (view.getId())
		{
			case R.id.btnTestDA1:	
//				intent = new Intent(this, ActivityT1.class);
//				startActivity(intent);
				TestCaseDA.testMain(this);
				break;
			case R.id.btnTestRF1:
				TestCaseRecommendFood.testMain(this);
				break;

		}
		
	}
}
