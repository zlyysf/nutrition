package com.lingzhimobile.nutritionfoodguide.v3.fragment;

import java.util.ArrayList;
import java.util.HashMap;

import org.apmem.tools.layouts.FlowLayout;

import android.app.Activity;
import android.graphics.drawable.ShapeDrawable;
import android.graphics.drawable.StateListDrawable;
import android.graphics.drawable.shapes.RoundRectShape;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ListView;
import android.widget.TextView;

import com.lingzhimobile.nutritionfoodguide.AsyncTaskDoRecommend;
import com.lingzhimobile.nutritionfoodguide.Constants;
import com.lingzhimobile.nutritionfoodguide.DataAccess;
import com.lingzhimobile.nutritionfoodguide.R;
import com.lingzhimobile.nutritionfoodguide.Tool;
import com.lingzhimobile.nutritionfoodguide.myProgressDialog;

public class DiagnoseFragment extends Fragment {
	static final String LogTag = DiagnoseFragment.class.getSimpleName();
	
	static final int[] checkboxColorCheckedResIds = {R.color.red, R.color.green, R.color.blue};
	static final int checkboxColorNormalResId = R.color.gray;
	
	HashMap<String,Object> m_symptomDataBy2LevelClass;
	
	ListView m_listView1;
	SymptomAdapter m_ListAdapter_LevelTop; 
	
	myProgressDialog m_prgressDialog;
	private AsyncTaskDoRecommend m_AsyncTaskDoRecommend;
	
    ArrayList<String> symptomTypeIds;
    HashMap<String,ArrayList<HashMap<String, Object>>> symptomHashMap;

    public Handler myHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            if (m_prgressDialog!=null)
            	m_prgressDialog.dismiss();
            switch (msg.what) {
            case Constants.MessageID_OK:
                break;
            }
        }
    };

	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

	@Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
	    View view = inflater.inflate(R.layout.v2_activity_diagnose, container, false);
        initViewHandles(view);
        initViewsContent();
        setViewEventHandlers();
        setViewsContent();
        return view;
    }

    void initViewHandles(View view){
        m_listView1 = (ListView)view.findViewById(R.id.listView1);
	}
    
	void initViewsContent(){
	    DataAccess da = DataAccess.getSingleton(getActivity());
        
        ArrayList<HashMap<String, Object>> symptomTypeRows = da.getSymptomTypeRows_withForSex(Constants.ForSex_male);
        ArrayList<Object> symptomTypeIdObjs = Tool.getPropertyArrayListFromDictionaryArray_withPropertyName(Constants.COLUMN_NAME_SymptomTypeId, symptomTypeRows);
        symptomTypeIds = Tool.convertToStringArrayList(symptomTypeIdObjs);
        Log.d(LogTag, "symptomTypeIds="+Tool.getIndentFormatStringOfObject(symptomTypeIds, 0));
        symptomHashMap = da.getSymptomRowsByTypeDict_BySymptomTypeIds(symptomTypeIds);
	}

	void setViewEventHandlers(){
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
		    
		    ArrayList<HashMap<String, Object>> symptomList = symptomHashMap.get(diagnoseTitleStr);
		    for (HashMap<String, Object> symptom: symptomList) {
		        String symptomStr = (String) symptom.get("SymptomId");
		        View cellView = getActivity().getLayoutInflater().inflate(R.layout.v2_grid_cell_symptom_cb, null);
		        CheckBox cb = (CheckBox) cellView.findViewById(R.id.cbSymptom);
		        changeCheckboxBackgroundWithSelector(getActivity(), cb, checkboxColorNormalResId, checkboxColorCheckedResIds[position%checkboxColorCheckedResIds.length]);
		        cb.setText(symptomStr);
		        diagnoseFlow.addView(cellView);
		    }
		    
			return convertView;
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
        Fragment diagnoseFragment = new DiagnoseFragment();
        return diagnoseFragment;
    }
}
