package com.lingzhimobile.nutritionfoodguide;



import java.io.IOException;
import java.util.ArrayList;



import android.app.Activity;
import android.content.Intent;
import android.database.*;
import android.os.*;
import android.util.Log;
import android.view.View;
import android.widget.*;
import android.widget.AdapterView.*;


public class Activity_GroupList extends Activity
implements OnItemSelectedListener,OnItemClickListener
{
	ArrayList<String> mGroups = null;
	
	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		//setContentView(R.layout.activity_grouplist);
		setContentView(R.layout.activity_grouplist_style1);

		DataAccess da = DataAccess.getSingleton(this);
		
		Cursor csGroups = da.getDiseaseGroupInfo_byType("wizard");
		ArrayList<String> alGroup = Tool.getDataFromCursor(csGroups, 0);
		csGroups.close();
		mGroups = alGroup;
		
//			@SuppressWarnings("deprecation")
//			SimpleCursorAdapter simpleCursorAdapter1 = new SimpleCursorAdapter(this,
//					android.R.layout.simple_expandable_list_item_1, csGroups,
//					new String[]
//					{"DiseaseGroup" }, new int[]
//					{ android.R.id.text1});
		
		ArrayAdapter<String> aryAdapterGroup = new ArrayAdapter<String>(this,android.R.layout.simple_list_item_1, alGroup);
		
		ListView listview1 = (ListView) findViewById(R.id.listView1);
		listview1.setAdapter(aryAdapterGroup);
		listview1.setOnItemClickListener(this);
		listview1.setOnItemSelectedListener(this);

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
	}
	
	@Override
	public void onItemClick(AdapterView<?> parent, View view, int position, long id)
	{
		String curItem = mGroups.get(position);
		Log.d("onItemClick", "position=" + position + " ,id="+id+", item="+curItem);
		
		onClickOrSelectItem(position,id);
	}
	
	void onClickOrSelectItem(int position, long id){
		String curItem = mGroups.get(position);
		Intent intent = new Intent(this, Activity_DiseaseList.class);
		intent.putExtra("groupName", curItem);
		startActivity(intent);
	}

	@Override
	public void onItemSelected(AdapterView<?> parent, View view, int position, long id)
	{
		String curItem = mGroups.get(position);
		Log.d("onItemSelected", "position=" + position + " ,id="+id+", item="+curItem);
		
		onClickOrSelectItem(position,id);
	}

	@Override
	public void onNothingSelected(AdapterView<?> parent)
	{
		Log.d("nothingselected", "nothing selected");

	}
	

}
