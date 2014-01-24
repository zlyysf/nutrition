package com.lingzhimobile.nutritionfoodguide.v3.fragment;

import java.util.ArrayList;
import java.util.HashMap;

import org.apmem.tools.layouts.FlowLayout;
import org.json.JSONArray;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.RectF;
import android.graphics.drawable.ShapeDrawable;
import android.graphics.drawable.StateListDrawable;
import android.graphics.drawable.shapes.RoundRectShape;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.util.SparseBooleanArray;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.lingzhimobile.nutritionfoodguide.ActivityAllFoodExpandList;
import com.lingzhimobile.nutritionfoodguide.ActivityRichFood;
import com.lingzhimobile.nutritionfoodguide.ActivitySearchFoodCustom;
import com.lingzhimobile.nutritionfoodguide.ActivitySearchFoodWithClass;
import com.lingzhimobile.nutritionfoodguide.ActivityTestCases;
import com.lingzhimobile.nutritionfoodguide.Constants;
import com.lingzhimobile.nutritionfoodguide.DataAccess;
import com.lingzhimobile.nutritionfoodguide.R;
import com.lingzhimobile.nutritionfoodguide.StoredConfigTool;
import com.lingzhimobile.nutritionfoodguide.Tool;
import com.lingzhimobile.nutritionfoodguide.v3.activity.V3ActivityReport;

public class V3DiagnoseFragment extends V3BaseHeadFragment {
	static final String LogTag = V3DiagnoseFragment.class.getSimpleName();
	
	public static final int IntentRequestCode_V3ActivityReport = 100;
	
    static final int[] checkboxColorCheckedResIds = { R.color.v3_head_face,
            R.color.v3_eyes, R.color.v3_ear_nose, R.color.v3_mouth_tongue,
            R.color.v3_teeth, R.color.v3_throat, R.color.v3_respiration,
            R.color.v3_heart, R.color.v3_chest_stomach, R.color.v3_skin,
            R.color.v3_hands_feet, R.color.v3_arms_legs, R.color.v3_body,
            R.color.v3_digestion, R.color.v3_excretion, R.color.v3_movement,
            R.color.v3_psychology, R.color.v3_male, R.color.v3_female };
	static final int checkboxColorNormalResId = R.color.white;
	
	TextView m_tvTitle, m_tvNotice;
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
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		Log.d(LogTag, "onCreateView");
	    View view = inflater.inflate(R.layout.v3_fragment_diagnose, container, false);
	    initHeaderLayout(view);
        initViewHandles(inflater, view);
        initViewsContent();
        setViewEventHandlers();
        setViewsContent();
        return view;
    }
	
	@Override
    public void onActivityCreated (Bundle savedInstanceState){
		Log.d(LogTag, "onActivityCreated enter");
		super.onActivityCreated(savedInstanceState);
		Log.d(LogTag, "onActivityCreated exit");
	}
    
	
	public void onViewStateRestored (Bundle savedInstanceState){
		Log.d(LogTag, "onViewStateRestored enter");
		super.onViewStateRestored(savedInstanceState);
		Log.d(LogTag, "onViewStateRestored exit ");
	}
    public void onStart() {
		Log.d(LogTag, "onStart begin");
		super.onStart();
		Log.d(LogTag, "onStart exit");
	}
    public void onResume() {
    	Log.d(LogTag, "onResume begin");
		super.onResume();
		Log.d(LogTag, "onResume exit");
	}

    void initViewHandles(LayoutInflater inflater, View view){
    	m_tvTitle = (TextView) view.findViewById(R.id.titleText);
        leftButton = (Button) view.findViewById(R.id.leftButton);
//        leftButton.setVisibility(View.INVISIBLE);
        rightButton = (Button) view.findViewById(R.id.rightButton);
        rightButton.setText("查看");
        m_btnSubmit = rightButton;
        m_listView1 = (ListView)view.findViewById(R.id.listView1);
        View headerView = inflater.inflate(R.layout.v3_symptom_header, null, false);
        View footerView = inflater.inflate(R.layout.v3_symptom_footer, null, false);
        m_tvNotice = (TextView)headerView.findViewById(R.id.tvNotice);
        
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
		m_currentTitle = "选择症状";
		m_tvTitle.setText(m_currentTitle);
		
	    DataAccess da = DataAccess.getSingleton(getActivity());
        
        m_symptomTypeRows = da.getSymptomTypeRows_withForSex(Constants.ForSex_male);
        ArrayList<Object> symptomTypeIdObjs = Tool.getPropertyArrayListFromDictionaryArray_withPropertyName(Constants.COLUMN_NAME_SymptomTypeId, m_symptomTypeRows);
        symptomTypeIds = Tool.convertToStringArrayList(symptomTypeIdObjs);
        Log.d(LogTag, "symptomTypeIds="+Tool.getIndentFormatStringOfObject(symptomTypeIds, 0));
        m_SymptomRowsByTypeDict = da.getSymptomRowsByTypeDict_BySymptomTypeIds(symptomTypeIds);
        
        m_symptomCheckedFlagsByTypeHm = new HashMap<String, SparseBooleanArray>();
        resetControlsInput();
        m_btnSubmit.setEnabled(checkCanSubmit());
	}
	
	void resetControlsInput(){
		for(int i=0; i<symptomTypeIds.size(); i++){
        	String symptomTypeId = symptomTypeIds.get(i);
        	m_symptomCheckedFlagsByTypeHm.put(symptomTypeId, new SparseBooleanArray(m_SymptomRowsByTypeDict.get(symptomTypeId).size()));
        }
		m_etBodyTemperature.setText(null);
		m_etWeight.setText(null);
		m_etHeartRate.setText(null);
		m_etBloodPressureHigh.setText(null);
		m_etBloodPressureLow.setText(null);
		m_etNote.setText(null);
		
		Activity actv = getActivity();
        View curFocusedView = actv.getWindow().getCurrentFocus();
        if (curFocusedView!=null){
        	InputMethodManager imm = (InputMethodManager)actv.getSystemService(Context.INPUT_METHOD_SERVICE);
        	imm.hideSoftInputFromWindow(curFocusedView.getWindowToken(), 0);
        	curFocusedView.clearFocus();
        }
//		m_tvNotice.requestFocus();
//		m_listView1.scrollTo(0, 0);//why no use?
//		m_listView1.post(new Runnable() {//why no use?
//			@Override
//			public void run() {
//				m_listView1.scrollTo(0, 0);
//			}
//		});
	}
	boolean checkCanSubmit(){
		for(int i=0; i<symptomTypeIds.size(); i++){
        	String symptomTypeId = symptomTypeIds.get(i);
        	SparseBooleanArray boolAry = m_symptomCheckedFlagsByTypeHm.get(symptomTypeId);
        	ArrayList<HashMap<String, Object>> SymptomRowsByType = m_SymptomRowsByTypeDict.get(symptomTypeId);
        	if (boolAry!=null && SymptomRowsByType!=null){
        		for(int j=0; j<SymptomRowsByType.size(); j++){
        			if (boolAry.get(j)){
        				return true;
        			}
        		}
        	}
        }
		String sIn;
		sIn = m_etBodyTemperature.getText().toString();
		if (sIn.length() > 0){
			return true;
		}
		
		sIn = m_etWeight.getText().toString();
		if (sIn.length() > 0){
			return true;
		}
		
		sIn = m_etHeartRate.getText().toString();
		if (sIn.length() > 0){
			return true;
		}
		
		sIn = m_etBloodPressureHigh.getText().toString();
		if (sIn.length() > 0){
			return true;
		}
		
		sIn = m_etBloodPressureLow.getText().toString();
		if (sIn.length() > 0){
			return true;
		}
		
		sIn = m_etNote.getText().toString();
		if (sIn.length() > 0){
			return true;
		}
		
		return false;
	}

	void setViewEventHandlers(){
		leftButton.setOnClickListener(new OnClickListener() {
            
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(getActivity(), ActivityTestCases.class);
                getActivity().startActivity(intent);
            }
        });
		
		TextWatcher_toEnableSubmitButton watcher = new TextWatcher_toEnableSubmitButton();
		m_etBodyTemperature.addTextChangedListener(watcher);
		m_etWeight.addTextChangedListener(watcher);
		m_etHeartRate.addTextChangedListener(watcher);
		m_etBloodPressureHigh.addTextChangedListener(watcher);
		m_etBloodPressureLow.addTextChangedListener(watcher);
		m_etNote.addTextChangedListener(watcher);

		m_btnSubmit.setOnClickListener(new OnClickListener() {
            
            @Override
            public void onClick(View v) {
            	ArrayList<String> selectedSymptomIds = new ArrayList<String>();
            	ArrayList<ArrayList<Object>> symptomIdsByType = new ArrayList<ArrayList<Object>>();
            	for(int i=0; i<m_symptomTypeRows.size(); i++){
            		HashMap<String, Object> symptomTypeRow = m_symptomTypeRows.get(i);
            		String symptomTypeId = (String)symptomTypeRow.get(Constants.COLUMN_NAME_SymptomTypeId);
            		ArrayList<HashMap<String, Object>> SymptomRowsByType = m_SymptomRowsByTypeDict.get(symptomTypeId);
            		SparseBooleanArray symptomCheckedFlagsByType = m_symptomCheckedFlagsByTypeHm.get(symptomTypeId);
            		
            		ArrayList<String> selectedSymptomIdsInType = new ArrayList<String>();
            		for(int j=0; j<SymptomRowsByType.size(); j++){
            			if (symptomCheckedFlagsByType.get(j)){
            				HashMap<String, Object> SymptomRow = SymptomRowsByType.get(j);
                			String symptomId = (String)SymptomRow.get(Constants.COLUMN_NAME_SymptomId);
                			selectedSymptomIds.add(symptomId);
                			selectedSymptomIdsInType.add(symptomId);
            			}
            		}
            		if (selectedSymptomIdsInType.size()>0){
            			ArrayList<Object> selectedSymptomIdsWithType = new ArrayList<Object>();
            			selectedSymptomIdsWithType.add(symptomTypeId);
            			selectedSymptomIdsWithType.add(selectedSymptomIdsInType);
            			symptomIdsByType.add(selectedSymptomIdsWithType);
            		}
            	}
            	Log.d(LogTag, "selectedSymptomIds="+selectedSymptomIds);
            	
                Intent intent = new Intent(getActivity(), V3ActivityReport.class);
                if (selectedSymptomIds!=null && selectedSymptomIds.size()>0){
                	intent.putStringArrayListExtra(Constants.COLUMN_NAME_SymptomId, selectedSymptomIds);
                }
                
                String strBodyTemperature = m_etBodyTemperature.getText().toString();
                if (strBodyTemperature!=null && strBodyTemperature.length()>0){
                	double BodyTemperature = Double.parseDouble(strBodyTemperature);
                	intent.putExtra(Constants.Key_BodyTemperature, BodyTemperature);
                }
                
                String strWeight = m_etWeight.getText().toString();
                if (strWeight!=null && strWeight.length()>0){
                	double Weight = Double.parseDouble(strWeight);
                	intent.putExtra(Constants.Key_Weight, Weight);
                	
                	if (Weight>0){
                		HashMap<String, Object> userInfo = new HashMap<String, Object>();
                		userInfo.put(Constants.ParamKey_weight, Double.valueOf(Weight));
                		StoredConfigTool.saveUserInfo_withPartItems(getActivity(), userInfo);
                	}
                }
                
                String strHeartRate = m_etHeartRate.getText().toString();
                if (strHeartRate!=null && strHeartRate.length()>0){
                	int HeartRate = Integer.parseInt(strHeartRate);
                	intent.putExtra(Constants.Key_HeartRate, HeartRate);
                }
                
                String strBloodPressureLow = m_etBloodPressureLow.getText().toString();
                if (strBloodPressureLow!=null && strBloodPressureLow.length()>0){
                	int BloodPressureLow = Integer.parseInt(strBloodPressureLow);
                	intent.putExtra(Constants.Key_BloodPressureLow, BloodPressureLow);
                }
                
                String strBloodPressureHigh = m_etBloodPressureHigh.getText().toString();
                if (strBloodPressureHigh!=null && strBloodPressureHigh.length()>0){
                	int BloodPressureHigh = Integer.parseInt(strBloodPressureHigh);
                	intent.putExtra(Constants.Key_BloodPressureHigh, BloodPressureHigh);
                }
                
                String note = m_etNote.getText().toString();
                if (note!=null && note.length()>0){
                	intent.putExtra(Constants.COLUMN_NAME_Note, note);
                }
                
                if (symptomIdsByType!=null && symptomIdsByType.size()>0){
                	JSONArray jsonAry_symptomIdsByType = Tool.CollectionToJSONArray(symptomIdsByType);
                	String jsonString_symptomIdsByType = jsonAry_symptomIdsByType.toString();
                   	intent.putExtra(Constants.Key_SymptomsByType, jsonString_symptomIdsByType);
                }
                
                intent.putExtra(Constants.IntentParamKey_BackButtonTitle, m_currentTitle);

                getActivity().startActivityForResult(intent, IntentRequestCode_V3ActivityReport);
            }
        });
	}

	void setViewsContent(){
        m_ListAdapter_LevelTop = new SymptomAdapter();
        m_listView1.setAdapter(m_ListAdapter_LevelTop);
	}
	

    @Override
	public void onActivityResult(int requestCode, int resultCode, Intent data)
	{
    	Log.d(LogTag, "onActivityResult begin");
		super.onActivityResult(requestCode, resultCode, data);
		switch (requestCode)
		{
			case IntentRequestCode_V3ActivityReport:
				resetControlsInput();
				m_ListAdapter_LevelTop.notifyDataSetChanged();
				break;
			default:
				break;
		}
		Log.d(LogTag, "onActivityResult end");
	}

	public class SymptomAdapter extends BaseAdapter
	{
		public SymptomAdapter(){
		}
		
		public void notifyDataSetChanged(){
			super.notifyDataSetChanged();
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
		    String symptomTypeId = getItem(position);
		    diagnoseTitle.setText(symptomTypeId);
		    diagnoseTitle.setBackgroundResource(checkboxColorCheckedResIds[position]);
		    
		    ArrayList<HashMap<String, Object>> SymptomRows = m_SymptomRowsByTypeDict.get(symptomTypeId);
		    SparseBooleanArray symptomCheckedFlags = m_symptomCheckedFlagsByTypeHm.get(symptomTypeId);
		    for (int i=0; i<SymptomRows.size(); i++) {
		    	HashMap<String, Object> symptomRow = SymptomRows.get(i);
		        String symptomId = (String) symptomRow.get(Constants.COLUMN_NAME_SymptomId);
		        View cellView = getActivity().getLayoutInflater().inflate(R.layout.v3_grid_cell_symptom, null);
		        View ll = (LinearLayout) cellView.findViewById(R.id.ll);
		        CheckBox cb = (CheckBox) cellView.findViewById(R.id.cbSymptom);
		        changeCheckboxBackgroundWithSelector(getActivity(), ll, checkboxColorNormalResId, checkboxColorCheckedResIds[position%checkboxColorCheckedResIds.length]);
		        cb.setText(symptomId);
		        diagnoseFlow.addView(cellView);
		        cb.setChecked(symptomCheckedFlags.get(i));
		        
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
				
				m_btnSubmit.setEnabled(checkCanSubmit());
			}
		}
		

	}//class ExpandableListAdapter_DiagnoseResult
	
	class TextWatcher_toEnableSubmitButton implements TextWatcher{
		@Override
		public void beforeTextChanged(CharSequence s, int start, int count, int after) {
		}

		@Override
		public void onTextChanged(CharSequence s, int start, int before, int count) {
		}

		@Override
		public void afterTextChanged(Editable s) {
			m_btnSubmit.setEnabled(checkCanSubmit());
		}
	}
	
	
	
	static void changeViewBackground(Activity curActv, View vw, int bgColorResId){
		final float[] roundedCorners = new float[] { 5, 5, 5, 5, 5, 5, 5, 5 };
		RoundRectShape roundRectShape1 = new RoundRectShape(roundedCorners, null,null);
		ShapeDrawable roundShape_bgColor = new ShapeDrawable(roundRectShape1);
		roundShape_bgColor.getPaint().setColor(curActv.getResources().getColor(bgColorResId));
		vw.setBackgroundDrawable(roundShape_bgColor);
	}

	
	//http://stackoverflow.com/questions/8308871/define-selector-in-code
	static void changeCheckboxBackgroundWithSelector(Activity curActv, View cb, int normalColorResId, int checkedColorResId){
//		ColorDrawable normalColorDrawable = new ColorDrawable(curActv.getResources().getColor(normalColorResId));
//		ColorDrawable checkedColorDrawable = new ColorDrawable(curActv.getResources().getColor(checkedColorResId));
//		StateListDrawable statesDrawable = new StateListDrawable();
//		statesDrawable.addState(new int[] {android.R.attr.state_checked},checkedColorDrawable);
//		statesDrawable.addState(new int[] { },normalColorDrawable);
		
		final float[] roundedCorners = new float[] { 11, 11, 11, 11, 11, 11, 11, 11 };
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
