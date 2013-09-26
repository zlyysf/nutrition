package com.lingzhimobile.nutritionfoodguide;

import java.util.*;


import android.app.Activity;
import android.database.Cursor;
import android.os.Bundle;
import android.util.*;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.*;
import android.widget.ExpandableListView.*;


public class ActivityDiscomfort extends Activity {
	
	Object[] mDiseaseDepartments = null;
	@SuppressWarnings("rawtypes")
	HashMap mDiseasesByDepartmentHm = null;
	HashMap<String,SparseBooleanArray> mFlagsForDiseaseByDepartmentHm = null ;
	Button mBtnReset;
	
    @SuppressWarnings("rawtypes")
	@Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_discomfort);
        
        DataAccess da = DataAccess.getSingleTon(this);

		
//			Cursor csGroups = da.getDiseaseGroupInfo_byType("discomfort");
		Cursor csGroups = da.getDiseaseGroupInfo_byType("illness");
		ArrayList<String> alGroup = Tool.getDataFromCursor(csGroups, 0);
		csGroups.close();
		assert(alGroup.size()==1);
		String groupName = alGroup.get(0);
		HashMap hmData = da.getDiseasesOrganizedByDepartment_OfGroup(groupName);

		mDiseasesByDepartmentHm = hmData;
		Object[] diseaseDepartments = hmData.keySet().toArray();
		mDiseaseDepartments = diseaseDepartments;
		
		ExpandableListView expandableListView1 = (ExpandableListView)this.findViewById(R.id.expandableListView1);
        ExpandableListAdapter adapter = new MyExpandableListAdapter();
        expandableListView1.setAdapter(adapter);
        //设置ExpandableListView 默认是展开的
        for (int i = 0; i < mDiseaseDepartments.length; i++) {
        	expandableListView1.expandGroup(i);
        }
        expandableListView1.setOnGroupClickListener(new OnGroupClickListener(){
        	//使点击group的项目不做折叠动作
        	@Override
        	public boolean onGroupClick(ExpandableListView parent, View v, int groupPosition, long id) { 
        		return true;
       	    }
        });
        expandableListView1.setGroupIndicator(null);//去掉ExpandableListView 默认的组上的下拉箭头
        
        mFlagsForDiseaseByDepartmentHm = new HashMap<String,SparseBooleanArray>();
        for (int i = 0; i < mDiseaseDepartments.length; i++) {
        	String diseaseDepartment = (String)mDiseaseDepartments[i];
        	SparseBooleanArray sba = new SparseBooleanArray();
        	mFlagsForDiseaseByDepartmentHm.put(diseaseDepartment, sba);
        }
        
        expandableListView1.setOnChildClickListener(new OnChildClickListener(){

			@Override
			public boolean onChildClick(ExpandableListView parent, View v, int groupPosition, int childPosition, long id) {
				CheckedTextView checkedTextView = (CheckedTextView)v.findViewById(R.id.checkedTextView1);
				boolean checked1 = checkedTextView.isChecked();
				boolean checked2 = !checked1;
				checkedTextView.setChecked(checked2);
				
				String diseaseDepartment = (String)mDiseaseDepartments[groupPosition];
				SparseBooleanArray sbaForDepartment = mFlagsForDiseaseByDepartmentHm.get(diseaseDepartment);
				sbaForDepartment.put(childPosition, checked2);
				
				return true;
			}
        });
        
        mBtnReset = (Button) findViewById(R.id.btnReset);
        mBtnReset.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	
            	
            	StringBuffer sb = new StringBuffer();
            	for (int i = 0; i < mDiseaseDepartments.length; i++) {
                	String diseaseDepartment = (String)mDiseaseDepartments[i];
                	SparseBooleanArray sbaForDepartment = mFlagsForDiseaseByDepartmentHm.get(diseaseDepartment);
                	List diseases = (List)mDiseasesByDepartmentHm.get(diseaseDepartment);
                	for(int j=0; j<diseases.size(); j++){
                		if (sbaForDepartment.get(j)){
                			String disease = (String)diseases.get(j);
                			
                			sb.append(disease+", ");
                		}
                		
                	}//for j
                }//for i
            	Log.i("ActivityDiscomfort.mBtnReset.onClick", sb.toString());
            }
        });
    }
    
    
    public class MyExpandableListAdapter extends BaseExpandableListAdapter
	{
		
		@SuppressWarnings("rawtypes")
		public Object getChild(int groupPosition, int childPosition)
		{
			Object group = mDiseaseDepartments[groupPosition];
			List diseases = (List)mDiseasesByDepartmentHm.get(group);
			Object disease = diseases.get(childPosition);
			return disease;
		}

		public long getChildId(int groupPosition, int childPosition)
		{
			return childPosition;
		}

		@SuppressWarnings("rawtypes")
		public int getChildrenCount(int groupPosition)
		{
			Object group = mDiseaseDepartments[groupPosition];
			List diseases = (List)mDiseasesByDepartmentHm.get(group);
			return diseases.size();
		}


		public View getChildView(int groupPosition, int childPosition,
				boolean isLastChild, View convertView, ViewGroup parent)
		{
			View vwItem = getLayoutInflater().inflate(R.layout.expandablelist_childitem, null);
			CheckedTextView checkedTextView = (CheckedTextView)vwItem.findViewById(R.id.checkedTextView1);
		
			checkedTextView.setText(getChild(groupPosition, childPosition).toString());
			return vwItem;
		}
		
		public View getGroupView(int groupPosition, boolean isExpanded,	View convertView, ViewGroup parent)
		{
			View vwItem = getLayoutInflater().inflate(R.layout.expandablelist_groupitem, null);
			TextView textView = (TextView)vwItem.findViewById(R.id.textView1);
			textView.setText(getGroup(groupPosition).toString());
			return vwItem;
		}

		public Object getGroup(int groupPosition)
		{
			Object group = mDiseaseDepartments[groupPosition];
			return group;
		}

		public int getGroupCount()
		{
			return mDiseaseDepartments.length;
		}

		public long getGroupId(int groupPosition)
		{
			return groupPosition;
		}



		public boolean isChildSelectable(int groupPosition, int childPosition)
		{
			return true;
		}

		public boolean hasStableIds()
		{
			return true;
		}

	}
    
    
    
}













