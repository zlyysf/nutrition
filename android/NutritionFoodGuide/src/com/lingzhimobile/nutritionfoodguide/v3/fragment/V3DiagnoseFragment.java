package com.lingzhimobile.nutritionfoodguide.v3.fragment;

import java.util.ArrayList;
import java.util.HashMap;

import org.apmem.tools.layouts.FlowLayout;

import android.app.Activity;
import android.content.Intent;
import android.graphics.drawable.ShapeDrawable;
import android.graphics.drawable.StateListDrawable;
import android.graphics.drawable.shapes.RoundRectShape;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.provider.SyncStateContract.Columns;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.util.SparseBooleanArray;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;

import com.lingzhimobile.nutritionfoodguide.ActivityTestCases;
import com.lingzhimobile.nutritionfoodguide.AsyncTaskDoRecommend;
import com.lingzhimobile.nutritionfoodguide.Constants;
import com.lingzhimobile.nutritionfoodguide.DataAccess;
import com.lingzhimobile.nutritionfoodguide.R;
import com.lingzhimobile.nutritionfoodguide.StoredConfigTool;
import com.lingzhimobile.nutritionfoodguide.Tool;
import com.lingzhimobile.nutritionfoodguide.myProgressDialog;
import com.lingzhimobile.nutritionfoodguide.v3.activity.V3ActivityReport;

public class V3DiagnoseFragment extends V3BaseHeadFragment {
	static final String LogTag = V3DiagnoseFragment.class.getSimpleName();
	
	static final int[] checkboxColorCheckedResIds = {R.color.red, R.color.green, R.color.blue};
	static final int checkboxColorNormalResId = R.color.gray;
	
	Button m_btnSubmit;
	EditText m_etNote, m_etBodyTemperature, m_etWeight, m_etHeartRate, m_etBloodPressureHigh, m_etBloodPressureLow;
	ListView m_listView1;
	SymptomAdapter m_ListAdapter_LevelTop; 
	
//	myProgressDialog m_prgressDialog;
//	private AsyncTaskDoRecommend m_AsyncTaskDoRecommend;
	
	ArrayList<HashMap<String, Object>> m_symptomTypeRows;
    ArrayList<String> symptomTypeIds;
    HashMap<String,ArrayList<HashMap<String, Object>>> m_SymptomRowsByTypeDict;
    
    HashMap<String,SparseBooleanArray> m_symptomCheckedFlagsByTypeHm;

//    public Handler myHandler = new Handler() {
//        @Override
//        public void handleMessage(Message msg) {
//            super.handleMessage(msg);
//            if (m_prgressDialog!=null)
//            	m_prgressDialog.dismiss();
//            switch (msg.what) {
//            case Constants.MessageID_OK:
//                break;
//            }
//        }
//    };

	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

	@Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
	    View view = inflater.inflate(R.layout.v3_fragment_diagnose, container, false);
	    initHeaderLayout(view);
        initViewHandles(inflater, view);
        initViewsContent();
        setViewEventHandlers();
        setViewsContent();
        return view;
    }

    void initViewHandles(LayoutInflater inflater, View view){
        leftButton = (Button) view.findViewById(R.id.leftButton);
        rightButton = (Button) view.findViewById(R.id.rightButton);
        m_btnSubmit = rightButton;
        m_listView1 = (ListView)view.findViewById(R.id.listView1);
        View headerView = inflater.inflate(R.layout.v3_symptom_header, null, false);
        View footerView = inflater.inflate(R.layout.v3_symptom_footer, null, false);
        m_etNote = (EditText)footerView.findViewById(R.id.etNote);
        m_etBodyTemperature = (EditText)footerView.findViewById(R.id.etBodyTemperature);
        m_etWeight = (EditText)footerView.findViewById(R.id.etWeight);
        m_etHeartRate = (EditText)footerView.findViewById(R.id.etHeartRate);
        m_etBloodPressureHigh = (EditText)footerView.findViewById(R.id.etBloodPressureHigh);
        m_etBloodPressureLow = (EditText)footerView.findViewById(R.id.etBloodPressureLow);
        

        m_listView1.addHeaderView(headerView);
        m_listView1.addFooterView(footerView);
	}
    
	void initViewsContent(){
	    DataAccess da = DataAccess.getSingleton(getActivity());
        
        m_symptomTypeRows = da.getSymptomTypeRows_withForSex(Constants.ForSex_male);
        ArrayList<Object> symptomTypeIdObjs = Tool.getPropertyArrayListFromDictionaryArray_withPropertyName(Constants.COLUMN_NAME_SymptomTypeId, m_symptomTypeRows);
        symptomTypeIds = Tool.convertToStringArrayList(symptomTypeIdObjs);
        Log.d(LogTag, "symptomTypeIds="+Tool.getIndentFormatStringOfObject(symptomTypeIds, 0));
        m_SymptomRowsByTypeDict = da.getSymptomRowsByTypeDict_BySymptomTypeIds(symptomTypeIds);
        
        m_symptomCheckedFlagsByTypeHm = new HashMap<String, SparseBooleanArray>();
        for(int i=0; i<symptomTypeIds.size(); i++){
        	String symptomTypeId = symptomTypeIds.get(i);
        	m_symptomCheckedFlagsByTypeHm.put(symptomTypeId, new SparseBooleanArray(m_SymptomRowsByTypeDict.get(symptomTypeId).size()));
        }
	}

	void setViewEventHandlers(){
		leftButton.setOnClickListener(new OnClickListener() {
            
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(getActivity(), ActivityTestCases.class);
                getActivity().startActivity(intent);
            }
        });

		m_btnSubmit.setOnClickListener(new OnClickListener() {
            
            @Override
            public void onClick(View v) {
            	ArrayList<String> selectedSymptomIds = new ArrayList<String>();
            	for(int i=0; i<m_symptomTypeRows.size(); i++){
            		HashMap<String, Object> symptomTypeRow = m_symptomTypeRows.get(i);
            		String symptomTypeId = (String)symptomTypeRow.get(Constants.COLUMN_NAME_SymptomTypeId);
            		ArrayList<HashMap<String, Object>> SymptomRowsByType = m_SymptomRowsByTypeDict.get(symptomTypeId);
            		SparseBooleanArray symptomCheckedFlagsByType = m_symptomCheckedFlagsByTypeHm.get(symptomTypeId);
            		for(int j=0; j<SymptomRowsByType.size(); j++){
            			if (symptomCheckedFlagsByType.get(j)){
            				HashMap<String, Object> SymptomRow = SymptomRowsByType.get(j);
                			String symptomId = (String)SymptomRow.get(Constants.COLUMN_NAME_SymptomId);
                			selectedSymptomIds.add(symptomId);
            			}
            		}	
            	}
            	Log.d(LogTag, "selectedSymptomIds="+selectedSymptomIds);
            	
            	double BodyTemperature = Double.parseDouble(m_etBodyTemperature.getText().toString());
            	double Weight = Double.parseDouble(m_etWeight.getText().toString());
            	int HeartRate = Integer.parseInt(m_etHeartRate.getText().toString());
            	int BloodPressureLow = Integer.parseInt(m_etBloodPressureLow.getText().toString());
            	int BloodPressureHigh = Integer.parseInt(m_etBloodPressureHigh.getText().toString());
            	
            	if (Weight>0){
            		HashMap<String, Object> userInfo = new HashMap<String, Object>();
            		userInfo.put(Constants.Key_Weight, Double.valueOf(Weight));
            		StoredConfigTool.saveUserInfo_withPartItems(getActivity(), userInfo);
            	}
            	
                Intent intent = new Intent(getActivity(), V3ActivityReport.class);
                intent.putStringArrayListExtra(Constants.COLUMN_NAME_SymptomId, selectedSymptomIds);
                intent.putExtra(Constants.Key_BodyTemperature, BodyTemperature);
                intent.putExtra(Constants.Key_Weight, Weight);
                intent.putExtra(Constants.Key_HeartRate, HeartRate);
                intent.putExtra(Constants.Key_BloodPressureLow, BloodPressureLow);
                intent.putExtra(Constants.Key_BloodPressureHigh, BloodPressureHigh);
                
                getActivity().startActivity(intent);
            }
        });
	}

	void setViewsContent(){
        m_ListAdapter_LevelTop = new SymptomAdapter();
        m_listView1.setAdapter(m_ListAdapter_LevelTop);
	}

	public class SymptomAdapter extends BaseAdapter
	{
		public SymptomAdapter(){
		}
		
		@Override
		public int getCount() {
			return symptomTypeIds.size();
		}
		@Override
		public String getItem(int position) {
			return symptomTypeIds.get(position);
		}
		@Override
		public long getItemId(int position) {
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
		    if (convertView == null){
		        convertView = getActivity().getLayoutInflater().inflate(R.layout.v3_diagnose_item, null);
		    }
		    TextView diagnoseTitle = (TextView) convertView.findViewById(R.id.diagnoseTitle);
		    FlowLayout diagnoseFlow = (FlowLayout) convertView.findViewById(R.id.diagnoseFlow);
		    diagnoseFlow.removeAllViews();
		    String diagnoseTitleStr = getItem(position);
		    diagnoseTitle.setText(diagnoseTitleStr);
		    
		    ArrayList<HashMap<String, Object>> SymptomRows = m_SymptomRowsByTypeDict.get(diagnoseTitleStr);
		    for (int i=0; i<SymptomRows.size(); i++) {
		    	HashMap<String, Object> symptomRow = SymptomRows.get(i);
		        String symptomId = (String) symptomRow.get(Constants.COLUMN_NAME_SymptomId);
		        View cellView = getActivity().getLayoutInflater().inflate(R.layout.v3_grid_cell_symptom, null);
		        CheckBox cb = (CheckBox) cellView.findViewById(R.id.cbSymptom);
		        changeCheckboxBackgroundWithSelector(getActivity(), cb, checkboxColorNormalResId, checkboxColorCheckedResIds[position%checkboxColorCheckedResIds.length]);
		        cb.setText(symptomId);
		        diagnoseFlow.addView(cellView);
		        
		        OnCheckedChangeListener_Symptom OnCheckedChangeListener_Symptom1 = (OnCheckedChangeListener_Symptom)cb.getTag();
		        if (OnCheckedChangeListener_Symptom1 == null){
		        	OnCheckedChangeListener_Symptom1 = new OnCheckedChangeListener_Symptom(position, i);
		        	cb.setOnCheckedChangeListener(OnCheckedChangeListener_Symptom1);
		        	cb.setTag(OnCheckedChangeListener_Symptom1);
		        }else{
		        	OnCheckedChangeListener_Symptom1.initInputData(position, i);
		        }
		        
		    }
		    
			return convertView;
		}
		
		class OnCheckedChangeListener_Symptom implements CompoundButton.OnCheckedChangeListener{
			int m_symptomTypePos, m_symptomPos;
			public OnCheckedChangeListener_Symptom(int symptomTypePos, int symptomPos){
				initInputData(symptomTypePos,symptomPos);
			}
			
			public void initInputData(int symptomTypePos, int symptomPos){
				m_symptomTypePos = symptomTypePos;
				m_symptomPos = symptomPos;
			}
			
			@Override
			public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
				HashMap<String, Object> symptomTypeRow = m_symptomTypeRows.get(m_symptomTypePos);
				String symptomTypeId = (String)symptomTypeRow.get(Constants.COLUMN_NAME_SymptomTypeId);
				SparseBooleanArray symptomCheckedFlags = m_symptomCheckedFlagsByTypeHm.get(symptomTypeId);
				symptomCheckedFlags.put(m_symptomPos, isChecked);
			}
		}
		
		public void notifyDataSetChanged(){
			super.notifyDataSetChanged();
		}
	}//class ExpandableListAdapter_DiagnoseResult
	
	
	
	static void changeViewBackground(Activity curActv, View vw, int bgColorResId){
		final float[] roundedCorners = new float[] { 5, 5, 5, 5, 5, 5, 5, 5 };
		RoundRectShape roundRectShape1 = new RoundRectShape(roundedCorners, null,null);
		ShapeDrawable roundShape_bgColor = new ShapeDrawable(roundRectShape1);
		roundShape_bgColor.getPaint().setColor(curActv.getResources().getColor(bgColorResId));
		vw.setBackgroundDrawable(roundShape_bgColor);
	}

	
	//http://stackoverflow.com/questions/8308871/define-selector-in-code
	static void changeCheckboxBackgroundWithSelector(Activity curActv, CompoundButton cb, int normalColorResId, int checkedColorResId){
//		ColorDrawable normalColorDrawable = new ColorDrawable(curActv.getResources().getColor(normalColorResId));
//		ColorDrawable checkedColorDrawable = new ColorDrawable(curActv.getResources().getColor(checkedColorResId));
//		StateListDrawable statesDrawable = new StateListDrawable();
//		statesDrawable.addState(new int[] {android.R.attr.state_checked},checkedColorDrawable);
//		statesDrawable.addState(new int[] { },normalColorDrawable);
		
		final float[] roundedCorners = new float[] { 5, 5, 5, 5, 5, 5, 5, 5 };
		RoundRectShape roundRectShape1 = new RoundRectShape(roundedCorners, null,null);
		
		ShapeDrawable roundShape_checkedColor = new ShapeDrawable(roundRectShape1);
		roundShape_checkedColor.getPaint().setColor(curActv.getResources().getColor(checkedColorResId));
		
		ShapeDrawable roundShape_normalColor = new ShapeDrawable(roundRectShape1);
		roundShape_normalColor.getPaint().setColor(curActv.getResources().getColor(normalColorResId));
		
		StateListDrawable statesDrawable = new StateListDrawable();
		statesDrawable.addState(new int[] {android.R.attr.state_checked},roundShape_checkedColor);
		statesDrawable.addState(new int[] { },roundShape_normalColor);
		
//		cb.setBackground(statesDrawable);
		cb.setBackgroundDrawable(statesDrawable);
//		cb.setButtonDrawable(statesDrawable);
	}
	
    public static Fragment newInstance(int arg0) {
        Fragment diagnoseFragment = new V3DiagnoseFragment();
        return diagnoseFragment;
    }

    @Override
    protected void setHeader() {
        
        
        
    }
}
