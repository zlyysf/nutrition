package com.lingzhimobile.nutritionfoodguide;

import java.io.*;
import java.util.*;


import android.app.*;
import android.content.*;
import android.database.*;
import android.os.Bundle;
import android.util.*;
import android.view.View;

import android.widget.*;

import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemSelectedListener;

public class Activity_DiseaseList extends Activity
implements OnItemSelectedListener,OnItemClickListener
{

	ArrayList<String> mDiseases = null;
	ListView mlistview1 = null;
	
	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_diseaselist_style1);
		
		String groupName =  getIntent().getStringExtra("groupName");
		if (groupName!=null &&groupName.length()>0){
			DataAccess da = DataAccess.getSingleTon(this);
			
			Cursor csDisease = da.getDiseaseNamesOfGroup(groupName);
			ArrayList<String> alDisease = Tool.getDataFromCursor(csDisease, 0);
			csDisease.close();
			mDiseases = alDisease;
			
//				@SuppressWarnings("deprecation")
//				SimpleCursorAdapter simpleCursorAdapter1 = new SimpleCursorAdapter(this,
//						android.R.layout.simple_expandable_list_item_1, csGroups,
//						new String[]
//						{"DiseaseGroup" }, new int[]
//						{ android.R.id.text1});
			
			ArrayAdapter<String> aryAdapterGroup = new ArrayAdapter<String>(this,android.R.layout.simple_list_item_multiple_choice, alDisease);

			ListView listview1 = (ListView) findViewById(R.id.listView1);
			mlistview1 = listview1;
			listview1.setAdapter(aryAdapterGroup);
			listview1.setChoiceMode(ListView.CHOICE_MODE_MULTIPLE);
			listview1.setOnItemClickListener(this);
			listview1.setOnItemSelectedListener(this);
		}
		
		TextView tvTitle = (TextView) findViewById(R.id.title);
		tvTitle.setText(groupName);
		
		setViewItemForBackButton();
	}
	
	void setViewItemForBackButton(){
		Button btnCancel = (Button) findViewById(R.id.btnCancel);
		btnCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
		
		Button btnNext = (Button) findViewById(R.id.btnNext);
		btnNext.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	StringBuilder sb = new StringBuilder();
            	SparseBooleanArray posAry = mlistview1.getCheckedItemPositions();
            	for(int i=0; i<mDiseases.size(); i++){
            		if (posAry.get(i)){
            			sb.append(mDiseases.get(i)+" , ");
            		}
            	}
            	Log.d("onExit", "choosed items:"+sb);
                finish();
            }
        });
	}

	@Override
	public void onItemClick(AdapterView<?> parent, View view, int position, long id)
	{
		String curItem = mDiseases.get(position);
		Log.d("onItemClick", "position=" + position + " ,id="+id+", item="+curItem);
		
	}
	
	@Override
	public void onItemSelected(AdapterView<?> parent, View view, int position, long id)
	{
		String curItem = mDiseases.get(position);
		Log.d("onItemSelected", "position=" + position + " ,id="+id+", item="+curItem);
		
	}

	@Override
	public void onNothingSelected(AdapterView<?> parent)
	{
		Log.d("nothingselected", "nothing selected");

	}
}
