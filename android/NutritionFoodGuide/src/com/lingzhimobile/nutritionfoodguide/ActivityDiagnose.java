package com.lingzhimobile.nutritionfoodguide;


import java.util.*;

import org.apache.commons.lang3.StringUtils;


import com.umeng.analytics.MobclickAgent;



import android.app.*;

import android.content.*;
import android.os.Bundle;
import android.text.InputType;
import android.util.*;
import android.view.*;

import android.widget.*;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ExpandableListView.*;
import android.widget.RadioGroup.OnCheckedChangeListener;


public class ActivityDiagnose extends ActivityBase {
	public static final int IntentResultCode = 1000;
	
	static final String LogTag = "ActivityDiagnose";
	
	public static final String IntentParamKey_DiseaseIds = "DiseaseIds";
	
	static final String[] m_diseaseTimeTypeIds = {Constants.DiseaseTimeType_morning, Constants.DiseaseTimeType_afternoon, Constants.DiseaseTimeType_night};
	
	static final int[] m_diseaseTimeTypeDescriptionResIds = {R.string.DiseaseTimeTypeDescription_morning, R.string.DiseaseTimeTypeDescription_afternoon, R.string.DiseaseTimeTypeDescription_night};
	String[] m_diseaseTimeTypeDescriptions;
	
	static final int[] m_timeDiagnoseTitleResIds = {R.string.timeDiagnoseTitle_morning, R.string.timeDiagnoseTitle_afternoon, R.string.timeDiagnoseTitle_night};
	String[] m_timeDiagnoseTitles;
	
	HashMap<String, Integer> hmDiseaseTimeTypeIdToPos ;
	
	String mInvokerType = null;

	String m_groupNameAsId;
	String m_currentDiseaseTimeType;
	ArrayList<HashMap<String, Object>> m_diseaseInfos;
	SparseBooleanArray m_diseaseCheckedFlags;
	
	Spinner m_spinnerTitle;
	Button m_btnCancel, m_btnAlertSetting, m_btnDiagnose;
	TextView m_tvTitleInner;
	ListView m_listView1;
	ScrollView m_scrollView1;
	DiseaseAdapter m_DiseaseAdapter;
	
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
        setContentView(R.layout.activity_diagnose);
        
        initViewHandles();
        initViewsContent();
        setViewEventHandlers();
        setViewsContent();
    }
	
	void initViewHandles(){
		m_scrollView1 = (ScrollView)findViewById(R.id.scrollView1);
		m_spinnerTitle = (Spinner)findViewById(R.id.spinnerTitle);
		m_btnCancel = (Button) findViewById(R.id.btnCancel);
		m_btnAlertSetting = (Button) findViewById(R.id.btnTopRight);
		m_tvTitleInner = (TextView)findViewById(R.id.tvTitleInner);
		
		m_btnDiagnose = (Button) findViewById(R.id.btnDiagnose);

		m_listView1 = (ListView)this.findViewById(R.id.listView1);
	}
	void initViewsContent(){
		m_diseaseTimeTypeDescriptions = new String[m_diseaseTimeTypeDescriptionResIds.length];
		for(int i=0; i<m_diseaseTimeTypeDescriptionResIds.length; i++){
			m_diseaseTimeTypeDescriptions[i] = getResources().getString(m_diseaseTimeTypeDescriptionResIds[i]);
		}
		
		m_timeDiagnoseTitles = new String[m_timeDiagnoseTitleResIds.length];
		for(int i=0; i<m_timeDiagnoseTitleResIds.length; i++){
			m_timeDiagnoseTitles[i] = getResources().getString(m_timeDiagnoseTitleResIds[i]);
		}
		
		hmDiseaseTimeTypeIdToPos = new HashMap<String, Integer>();
		hmDiseaseTimeTypeIdToPos.put(Constants.DiseaseTimeType_morning, Integer.valueOf(0));
		hmDiseaseTimeTypeIdToPos.put(Constants.DiseaseTimeType_afternoon, Integer.valueOf(1));
		hmDiseaseTimeTypeIdToPos.put(Constants.DiseaseTimeType_night, Integer.valueOf(2));
		
		m_currentTitle = getResources().getString(R.string.title_diagnose);
//        TextView tvTitle = (TextView) findViewById(R.id.tvTitle);
//        tvTitle.setText(m_currentTitle);
        
		Intent paramIntent = getIntent();
        mInvokerType = paramIntent.getStringExtra(Constants.IntentParamKey_InvokerType);
        String prevActvTitle = paramIntent.getStringExtra(Constants.IntentParamKey_BackButtonTitle);
        if (prevActvTitle!=null)
        	m_btnCancel.setText(prevActvTitle);
        
        DataAccess da = DataAccess.getSingleton(this);
        m_groupNameAsId = da.getDiseaseGroupId_byType(Constants.DiseaseGroupType_DailyDiseaseDiagnose);
	}
	void setViewEventHandlers(){
		m_btnCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	finish();
            }
        });
		m_btnAlertSetting.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	Intent intent = new Intent(ActivityDiagnose.this, ActivityDiagnoseAlertSetting.class);
				intent.putExtra(Constants.IntentParamKey_BackButtonTitle, m_currentTitle);
				startActivity(intent);
            }
        });
		m_btnDiagnose.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	ArrayList<String> diseaseIds = new ArrayList<String>();
            	for(int i=0; i<m_diseaseInfos.size(); i++){
            		if (m_diseaseCheckedFlags.get(i)){
            			HashMap<String, Object> diseaseInfo = m_diseaseInfos.get(i);
            			diseaseIds.add((String)diseaseInfo.get(Constants.COLUMN_NAME_Disease));
            		}
            	}
            	Log.d(LogTag, "choosed diseaseIds="+StringUtils.join(diseaseIds));
            	if (diseaseIds.size() > 0){
            		Intent intent = new Intent(ActivityDiagnose.this, ActivityDiagnoseResult.class);
    				intent.putExtra(Constants.IntentParamKey_BackButtonTitle, m_currentTitle);
    				intent.putExtra(Constants.COLUMN_NAME_DiseaseGroup, m_groupNameAsId);
    				intent.putExtra(IntentParamKey_DiseaseIds, diseaseIds.toArray(new String[diseaseIds.size()]));
    				startActivity(intent);
            	}else{
					new AlertDialog.Builder(ActivityDiagnose.this).setMessage("恭喜，你现在的身体状况还很健康，在以后的诊断中要继续保持哦！").setPositiveButton(R.string.iKnow, null).show();
            	}
            }
        });
//		m_listView1.setOnItemClickListener(new OnItemClickListenerInListItem());//没有收到事件?


	}
	void setViewsContent(){
		m_currentDiseaseTimeType = Tool.getCurrentDiseaseTimeType();
		Log.d(LogTag, "setViewsContent m_currentDiseaseTimeType="+m_currentDiseaseTimeType);
		
		m_tvTitleInner.setText(m_timeDiagnoseTitles[hmDiseaseTimeTypeIdToPos.get(m_currentDiseaseTimeType)]);
		
		DataAccess da = DataAccess.getSingleton(this);
		
		m_diseaseInfos = da.getDiseaseInfosOfGroup(m_groupNameAsId, null, null, m_currentDiseaseTimeType);
		m_diseaseCheckedFlags = new SparseBooleanArray(m_diseaseInfos.size());
		Log.d(LogTag, "m_diseaseCheckedFlags changed in setViewsContent");
		
		m_DiseaseAdapter = new DiseaseAdapter();
		m_listView1.setAdapter(m_DiseaseAdapter);
		
		//怀疑 传入的R.layout.spinner_main_diseasetimetype 没有用上，因为 getDropDownView 是自定义的
		ArrayAdapter_Spinner_TimeType adapter1 = new ArrayAdapter_Spinner_TimeType(this, R.layout.spinner_main_diseasetimetype, m_diseaseTimeTypeDescriptions);
		m_spinnerTitle.setAdapter(adapter1);
		
		m_spinnerTitle.setOnItemSelectedListener(new OnItemSelectedListener() {
			@Override
			public void onItemSelected(AdapterView<?> parent, View view, int position, long id)
			{
				Log.d(LogTag, "spinner onItemSelected" + m_diseaseTimeTypeDescriptions[position]);
				m_currentDiseaseTimeType = m_diseaseTimeTypeIds[position];
				DataAccess da = DataAccess.getSingleton(ActivityDiagnose.this);
				m_diseaseInfos = da.getDiseaseInfosOfGroup(m_groupNameAsId, null, null, m_currentDiseaseTimeType);
				m_diseaseCheckedFlags = new SparseBooleanArray(m_diseaseInfos.size());
				Log.d(LogTag, "m_diseaseCheckedFlags changed in spinner onItemSelected");
				m_DiseaseAdapter.notifyDataSetChanged();
				
				m_tvTitleInner.setText(m_timeDiagnoseTitles[position]);
			}

			@Override
			public void onNothingSelected(AdapterView<?> parent) {
				Log.d(LogTag, "spinner onNothingSelected");
			}
		});
		
		m_spinnerTitle.setSelection(hmDiseaseTimeTypeIdToPos.get(m_currentDiseaseTimeType));
		
		m_scrollView1.scrollTo(0, 10);
		m_scrollView1.scrollTo(0, 0);
		
	}
	
	
	class ArrayAdapter_Spinner_TimeType extends ArrayAdapter<String>{
		
		String[] m_objs;
		 
        public ArrayAdapter_Spinner_TimeType(Context context, int textViewResourceId,   String[] objects) {
            super(context, textViewResourceId, objects);
            //怀疑 textViewResourceId 没有用上，因为 getDropDownView 是自定义的
            m_objs = objects;
        }
 
        @Override
        public View getDropDownView(int position, View convertView,ViewGroup parent) {
        	View vw = convertView;
        	if (vw == null){
        		LayoutInflater inflater=getLayoutInflater();
                vw=inflater.inflate(R.layout.spinner_item_diseasetimetype, parent, false);
        	}
            TextView label=(TextView)vw.findViewById(R.id.textView1);
            label.setText(m_objs[position]);
            return vw;
        }
 
        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
        	View vw = convertView;
        	if (vw == null){
        		LayoutInflater inflater=getLayoutInflater();
                vw=inflater.inflate(R.layout.spinner_main_diseasetimetype, parent, false);
        	}
            TextView label=(TextView)vw.findViewById(R.id.textView1);
            label.setText(m_objs[position]);
            return vw;
        }
	}//class ArrayAdapter_Spinner_TimeType
    

    
	class DiseaseAdapter extends BaseAdapter{
		@Override
		public int getCount() {
			return m_diseaseInfos == null? 0 : m_diseaseInfos.size();
		}

		@Override
		public Object getItem(int position) {
			return m_diseaseInfos.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}
		
		public void notifyDataSetChanged(){
			super.notifyDataSetChanged();
		}
		

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			if (convertView == null){
				convertView = getLayoutInflater().inflate(R.layout.row_disease, null);
			}
			HashMap<String, Object> diseaseInfo = (HashMap<String, Object>)getItem(position);

			TextView tvDiseaseName = (TextView)convertView.findViewById(R.id.textView1);
			tvDiseaseName.setText((String)diseaseInfo.get(Constants.COLUMN_NAME_Disease));
			CheckBox checkBox1 = (CheckBox)convertView.findViewById(R.id.checkBox1);
			checkBox1.setChecked(m_diseaseCheckedFlags.get(position));
			
			LinearLayout llRowDisease = (LinearLayout)convertView.findViewById(R.id.llRowDisease);
			OnClickListenerInListItem OnClickListenerInListItem1 = (OnClickListenerInListItem)llRowDisease.getTag();
			if (OnClickListenerInListItem1==null){
				OnClickListenerInListItem1 = new OnClickListenerInListItem();
				OnClickListenerInListItem1.initInputData(position);
				llRowDisease.setTag(OnClickListenerInListItem1);
				llRowDisease.setOnClickListener(OnClickListenerInListItem1);
				checkBox1.setOnClickListener(OnClickListenerInListItem1);
			}else{
				OnClickListenerInListItem1.initInputData(position);
			}
			
//			//在滑动到隐藏时，还有onCheckedChanged(false)的事件发生，导致问题。换用 OnClickListener解决。
//			OnCheckedChangeListenerInListItem OnCheckedChangeListenerInListItem1 = (OnCheckedChangeListenerInListItem)checkBox1.getTag();
//			if (OnCheckedChangeListenerInListItem1 == null){
//				OnCheckedChangeListenerInListItem1 = new OnCheckedChangeListenerInListItem();
//				OnCheckedChangeListenerInListItem1.initInputData(position);
//				checkBox1.setOnCheckedChangeListener(OnCheckedChangeListenerInListItem1);
//			}else{
//				OnCheckedChangeListenerInListItem1.initInputData(position);
//			}
			
			return convertView;
		}
		
//		//在滑动到隐藏时，还有onCheckedChanged(false)的事件发生，导致问题。换用 OnClickListener解决。
//		class OnCheckedChangeListenerInListItem extends ListenerBaseInListItem implements CompoundButton.OnCheckedChangeListener {
//			@Override
//			public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
//				String diseaseId = (String)m_diseaseInfos.get(m_rowPos).get(Constants.COLUMN_NAME_Disease);
//				Log.d(LogTag, "onCheckedChanged isChecked="+isChecked+", diseaseId="+diseaseId);
//				m_diseaseCheckedFlags.put(m_rowPos, isChecked);
//			}
//		}
		class OnClickListenerInListItem extends ListenerBaseInListItem implements View.OnClickListener{

			@Override
			public void onClick(View v) {
				String diseaseId = (String)m_diseaseInfos.get(m_rowPos).get(Constants.COLUMN_NAME_Disease);
				boolean prevFlag = m_diseaseCheckedFlags.get(m_rowPos);
				boolean curFlag = !prevFlag;
				m_diseaseCheckedFlags.put(m_rowPos, curFlag);
				CheckBox checkBox1 = null;
				if (v instanceof CheckBox){
					checkBox1 = (CheckBox)v;
//					Log.d(LogTag, "CheckBox. OnClickListenerInListItem onClick from "+prevFlag+" to "+curFlag+" for "+diseaseId);
				}else{
					checkBox1 = (CheckBox)v.findViewById(R.id.checkBox1);
//					Log.d(LogTag, "LinearLayout. OnClickListenerInListItem onClick from "+prevFlag+" to "+curFlag+" for "+diseaseId);
				}
				checkBox1.setChecked(curFlag);
			}
			
		}
		
	}//class DiseaseAdapter
    
//    class OnItemClickListenerInListItem implements OnItemClickListener{
//
//		@Override
//		public void onItemClick(AdapterView<?> arg0, View vw, int pos, long id) {
//			String diseaseId = (String)m_diseaseInfos.get(pos).get(Constants.COLUMN_NAME_Disease);
//			boolean prevFlag = m_diseaseCheckedFlags.get(pos);
//			boolean curFlag = !prevFlag;
//			m_diseaseCheckedFlags.put(pos, curFlag);
//			CheckBox checkBox1 = (CheckBox)vw.findViewById(R.id.checkBox1);
//			checkBox1.setChecked(curFlag);
//			Log.d(LogTag, "OnItemClickListenerInListItem onItemClick from "+prevFlag+" to "+curFlag+" for "+diseaseId);
//		}
//    }
    

    
    
    
}













