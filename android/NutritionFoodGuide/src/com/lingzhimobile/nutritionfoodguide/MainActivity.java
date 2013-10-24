package com.lingzhimobile.nutritionfoodguide;



import java.io.IOException;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class MainActivity extends Activity implements OnClickListener{

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        Button button1 = (Button)findViewById(R.id.btnButton1);
        button1.setOnClickListener(this);
        button1 = (Button)findViewById(R.id.buttonGroups);
        button1.setOnClickListener(this);
        button1 = (Button)findViewById(R.id.buttonWizard);
        button1.setOnClickListener(this);
        button1 = (Button)findViewById(R.id.btnTestCases);
        button1.setOnClickListener(this);
        
        button1 = (Button)findViewById(R.id.btnDiscomfort);
        button1.setOnClickListener(this);
        button1 = (Button)findViewById(R.id.btnFoodCombination);
        button1.setOnClickListener(this);
        button1 = (Button)findViewById(R.id.btnFoodCombinationList);
        button1.setOnClickListener(this);
        
        button1 = (Button)findViewById(R.id.btnSearchFood);
        button1.setOnClickListener(this);
        button1 = (Button)findViewById(R.id.btnSearchFoodSingleTop);
        button1.setOnClickListener(this);
        
        button1 = (Button)findViewById(R.id.btnUserProfile);
        button1.setOnClickListener(this);
        
        

    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }
    
    
    @Override
	public void onClick(View view)
	{
//    	this.getSharedPreferences(name, mode)
//    	this.openFileOutput(name, mode)
//    	this.getFilesDir()
    	
		Intent intent = null;
		switch (view.getId())
		{
			case R.id.btnButton1:	
				intent = new Intent(this, ActivityT1.class);
				startActivity(intent);
				break;
			case R.id.buttonGroups:	
				intent = new Intent(this, Activity_GroupList.class);
				startActivity(intent);
				break;
			case R.id.buttonWizard:
				intent = new Intent(this, ActivityDiseaseNutrientWizard.class);
				startActivity(intent);
				break;
			case R.id.btnTestCases:	
				intent = new Intent(this, ActivityTestCases.class);
				startActivity(intent);
				break;
			case R.id.btnDiscomfort:	
				intent = new Intent(this, ActivityDiscomfort.class);
				startActivity(intent);
				break;
			case R.id.btnFoodCombination:	
				intent = new Intent(this, ActivityFoodCombination.class);
				startActivity(intent);
				break;
			case R.id.btnFoodCombinationList:	
				intent = new Intent(this, ActivityFoodCombinationList.class);
				startActivity(intent);
				break;
			case R.id.btnSearchFood:	
//				intent = new Intent(this, ActivitySearchFoodT1.class);
//				intent.putExtra("from", "from Main");
////				intent.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);//no use here
//				startActivity(intent);
				break;
			case R.id.btnSearchFoodSingleTop:	
//				//设置了 android:launchMode="singleTop" 也没成功
//				intent = new Intent(this, ActivitySearchFoodT1SingleTop.class);
//				intent.putExtra("from", "from Main2");
//				startActivity(intent);
				break;
			case R.id.btnUserProfile:	
				intent = new Intent(this, ActivityUserProfile.class);
				startActivity(intent);
				break;
		}
		
	}
    
}
