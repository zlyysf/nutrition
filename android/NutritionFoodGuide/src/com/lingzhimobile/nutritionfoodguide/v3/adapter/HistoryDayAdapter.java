package com.lingzhimobile.nutritionfoodguide.v3.adapter;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.Display;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnTouchListener;
import android.widget.*;
import android.widget.LinearLayout.LayoutParams;


import com.lingzhimobile.nutritionfoodguide.Constants;
import com.lingzhimobile.nutritionfoodguide.DataAccess;
import com.lingzhimobile.nutritionfoodguide.GlobalVar;
import com.lingzhimobile.nutritionfoodguide.R;
import com.lingzhimobile.nutritionfoodguide.Tool;
import com.lingzhimobile.nutritionfoodguide.v3.activity.V3ActivityReport;
import com.lingzhimobile.nutritionfoodguide.v3.fragment.V3BaseHeadFragment;

public class HistoryDayAdapter extends BaseAdapter implements SectionIndexer {
	
	static final String LogTag = "HistoryDayAdapter";

    Context mContext;
    ArrayList<HashMap<String, Object>> mRecords;
    ArrayList<Integer> m_sectionlist_dayLocal;
    Integer[] m_sections_dayLocal;
    V3BaseHeadFragment m_fragment;
    ListView m_lv;
    LinearLayout m_llSideIndex;

    public HistoryDayAdapter(Context context, ArrayList<HashMap<String, Object>> records, V3BaseHeadFragment fragment, ListView lv, LinearLayout llSideIndex) {
        mContext = context;
        mRecords = records;
        m_fragment = fragment;
        
        m_lv = lv;
        m_llSideIndex = llSideIndex;
        
        getSectionsFromRecords();
        setContentOfSideIndex(m_lv,m_llSideIndex);
        
    }
    
    void getSectionsFromRecords(){
    	m_sectionlist_dayLocal = new ArrayList<Integer>();
        if (mRecords!=null){
        	for(int i=0; i<mRecords.size(); i++){
        		HashMap<String, Object> row = mRecords.get(i);
        		Object dayLocalObj = row.get(Constants.COLUMN_NAME_DayLocal);
        		Double dayLocalDouble = Double.parseDouble(dayLocalObj.toString());
                int dayLocal = dayLocalDouble.intValue();
                int dayInMonth = dayLocal%100;
                m_sectionlist_dayLocal.add(Integer.valueOf(dayInMonth));
        	}
        }
        m_sections_dayLocal = m_sectionlist_dayLocal.toArray(new Integer[m_sectionlist_dayLocal.size()]);
    }
    
    public void updateData(Context context, ArrayList<HashMap<String, Object>> records, V3BaseHeadFragment fragment, ListView lv, LinearLayout llSideIndex){
//    	mRecords = records;
    	
    	mContext = context;
        mRecords = records;
        m_fragment = fragment;
        m_lv = lv;//seemed will be null in cache
        m_llSideIndex = llSideIndex;
        
    	getSectionsFromRecords();
    	setContentOfSideIndex(m_lv,m_llSideIndex);
    	lv.post(new Runnable() {
			@Override
			public void run() {
				notifyDataSetChanged();
			}
		});
//    	super.notifyDataSetChanged();
    }

    @Override
    public int getCount() {
        return mRecords.size();
    }

    @Override
    public HashMap<String, Object> getItem(int position) {
        return mRecords.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @SuppressWarnings("unchecked")
	@Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if (convertView == null) {
            convertView = ((Activity) mContext).getLayoutInflater().inflate(R.layout.v3_history_day_cell, null);
        }
//        TextView contextTextView = (TextView) convertView.findViewById(R.id.contentTextView);
//        contextTextView.setText(getItem(position).toString());

        HashMap<String, Object> dataRow = getItem(position);

        LinearLayout llItemByDay = (LinearLayout)convertView.findViewById(R.id.llItemByDay);
        TextView dayTextView = (TextView) convertView.findViewById(R.id.dayTextView);
        TextView weekdayTextView = (TextView) convertView.findViewById(R.id.weekdayTextView);
//        TextView bmiTextView = (TextView) convertView.findViewById(R.id.bmiTextView);
//        TextView illnessTextView = (TextView) convertView.findViewById(R.id.illnessTextView);
        
//        TextView temperatureTextView = (TextView) convertView.findViewById(R.id.temperatureTextView);
//        TextView weightTextView = (TextView) convertView.findViewById(R.id.weightTextView);
//        TextView bloodPressureTextView = (TextView) convertView.findViewById(R.id.bloodPressureTextView);
//        TextView heartRateTextView = (TextView) convertView.findViewById(R.id.heartRateTextView);
        TextView noteTextView = (TextView) convertView.findViewById(R.id.noteTextView);
        
//        TextView tvSuggestions = (TextView) convertView.findViewById(R.id.tvSuggestions);
        
        TextView nutrient1TextView = (TextView) convertView.findViewById(R.id.nutrient1TextView);
        TextView nutrient2TextView = (TextView) convertView.findViewById(R.id.nutrient2TextView);
        TextView nutrient3TextView = (TextView) convertView.findViewById(R.id.nutrient3TextView);
        TextView nutrient4TextView = (TextView) convertView.findViewById(R.id.nutrient4TextView);
        TextView []nutrientTextViews = new TextView[]{nutrient1TextView,nutrient2TextView,nutrient3TextView,nutrient4TextView};
        
        TextView tvSymptoms = (TextView) convertView.findViewById(R.id.tvSymptoms);
//        LinearLayout llSymptomAndType = (LinearLayout)convertView.findViewById(R.id.llSymptomAndType);
        

        
        String dayStr, weekdayStr;
        
        String bmiStr;
        String illnessStr;
        
        String temperatureStr, weightStr;
        String bloodPressureStr, heartRateStr;

        
        String note;
        
//        Date UpdateTimeUTC = (Date)dataRow.get(Constants.COLUMN_NAME_UpdateTimeUTC);
        Object dayLocalObj = dataRow.get(Constants.COLUMN_NAME_DayLocal);
//        int dayLocal = Integer.parseInt(dayLocalObj.toString());
        Double dayLocalDouble = Double.parseDouble(dayLocalObj.toString());
        int dayLocal = dayLocalDouble.intValue();
//        Log.d(LogTag, "dayLocal="+dayLocal);
        Date dtLocal = Tool.getDateFromYearMonthDay(dayLocal);
    	SimpleDateFormat sdf = new SimpleDateFormat("MM月dd日");
    	SimpleDateFormat sdfWeekday = new SimpleDateFormat("E");
        dayStr = sdf.format(dtLocal);
        weekdayStr = sdfWeekday.format(dtLocal);
        dayTextView.setText(dayStr);
        weekdayTextView.setText(weekdayStr);
        
        note = (String) dataRow.get(Constants.COLUMN_NAME_Note);
        noteTextView.setText(note);
        
        HashMap<String, Object> inputNameValuePairs = (HashMap<String, Object>) dataRow.get(Constants.COLUMN_NAME_inputNameValuePairs);
        HashMap<String, Object> calculateNameValuePairs = (HashMap<String, Object>) dataRow.get(Constants.COLUMN_NAME_calculateNameValuePairs);
        
        
        
//        Object bmiObj = calculateNameValuePairs.get(Constants.Key_BMI);
//        if (bmiObj!=null){
//        	Double bmi = Double.valueOf(bmiObj.toString());
//        	String bmiStatusId = Tool.getBMIStatusId(bmi);
//            bmiStr = String.format("%.1f，%s", bmi,bmiStatusId);
//            bmiTextView.setText(bmiStr);
//        }else{
//        	bmiTextView.setText("");
//        }
        
//        Object temperatureObj = inputNameValuePairs.get(Constants.Key_BodyTemperature);
//        if (temperatureObj!=null){
//        	Double temperature = Double.valueOf(temperatureObj.toString());//temperatureObj may be integer
//        	temperatureStr = String.format("%.1fC", temperature);
//            temperatureTextView.setText(temperatureStr);
//        }else{
//        	temperatureTextView.setText("");
//        }
//        
//        Object weightObj = inputNameValuePairs.get(Constants.Key_Weight);
//        if (weightObj!=null){
//        	Double weight = Double.valueOf(weightObj.toString()); 
//            weightStr = String.format("%.1fkg", weight);
//            weightTextView.setText(weightStr);
//        }else{
//        	weightTextView.setText("");
//        }
//
//        Object bloodPressureLowObj = inputNameValuePairs.get(Constants.Key_BloodPressureLow);
//        Object bloodPressureHighObj = inputNameValuePairs.get(Constants.Key_BloodPressureHigh);
//        if (bloodPressureLowObj!=null && bloodPressureHighObj!=null){
//        	Integer bloodPressureLow = Integer.valueOf(bloodPressureLowObj.toString()); 
//        	Integer bloodPressureHigh = Integer.valueOf(bloodPressureHighObj.toString()); 
//        	bloodPressureStr = String.format("%d/%d", bloodPressureHigh,bloodPressureLow);
//        	bloodPressureTextView.setText(bloodPressureStr);
//        }else{
//        	bloodPressureTextView.setText("");
//        }
//        
//        Object heartRateObj = inputNameValuePairs.get(Constants.Key_HeartRate);
//        if (heartRateObj!=null){
//        	Integer heartRate = Integer.valueOf(heartRateObj.toString()); 
//        	heartRateStr = String.format("%dbpm", heartRate);
//        	heartRateTextView.setText(heartRateStr);
//        }else{
//        	heartRateTextView.setText("");
//        }
        
        HashMap<String, HashMap<String, Object>> allIllnessInfoDict2Level = GlobalVar.getAllIllness2LevelDict(mContext);
        HashMap<String, HashMap<String, Object>> symptomTypeInfoDict2Level = GlobalVar.getAllSymptomType2LevelDict(mContext);
        HashMap<String, HashMap<String, Object>> allSymptomInfoDict2Level = GlobalVar.getAllSymptom2LevelDict(mContext);
        HashMap<String, HashMap<String, Object>> nutrientInfoDict2Level = GlobalVar.getAllNutrient2LevelDict(mContext);
        HashMap<String, HashMap<String, Object>> allSuggestionInfoDict2Level = GlobalVar.getAllSuggestion2LevelDict(mContext);
        
//        ArrayList<Object> illnessIdObjList = (ArrayList<Object>)calculateNameValuePairs.get(Constants.Key_IllnessIds);
//        ArrayList<String> illnessIdList = null;
//        if (illnessIdObjList!=null){
//        	illnessIdList = Tool.convertToStringArrayList(illnessIdObjList);
//        }else{
//        	HashMap<String, Object> inferIllnessesAndSuggestions = (HashMap<String, Object>) calculateNameValuePairs.get(Constants.Key_InferIllnessesAndSuggestions);
//        	illnessIdList = Tool.getKeysFromHashMap(inferIllnessesAndSuggestions);
//        }
//        ArrayList<HashMap<String, Object>> illnessRowList = Tool.getdictionaryArrayFrom2LevelDictionary(illnessIdList, allIllnessInfoDict2Level);
//        ArrayList<Object> illnessCaptionList = Tool.getPropertyArrayListFromDictionaryArray_withPropertyName(Constants.COLUMN_NAME_IllnessNameCn, illnessRowList);
//        illnessStr = StringUtils.join(illnessCaptionList,"，");
//        illnessTextView.setText(illnessStr);
        
//        ArrayList<Object> distinctSuggestionIdObjList = (ArrayList<Object>)calculateNameValuePairs.get(Constants.Key_distinctSuggestionIds);
//        String suggestionsTxt = "";
//        if (distinctSuggestionIdObjList!=null && distinctSuggestionIdObjList.size()>0){
//        	ArrayList<String> distinctSuggestionIdList = Tool.convertToStringArrayList(distinctSuggestionIdObjList);
//            ArrayList<HashMap<String, Object>> distinctSuggestionRowList = Tool.getdictionaryArrayFrom2LevelDictionary(distinctSuggestionIdList, allSuggestionInfoDict2Level);
//            ArrayList<String> suggestionTxtList = new ArrayList<String>();
//            for(int i=0; i<distinctSuggestionRowList.size(); i++){
//            	HashMap<String, Object> suggestionRow = distinctSuggestionRowList.get(i);
//            	String suggestionCaption = (String)suggestionRow.get(Constants.COLUMN_NAME_SuggestionCn);
//            	String suggestionTxt = String.format("%d    %s", i+1,suggestionCaption);
//            	suggestionTxtList.add(suggestionTxt);
//            }
//            suggestionsTxt = StringUtils.join(suggestionTxtList,"\n\n");
//            
//        }
//        tvSuggestions.setText(suggestionsTxt);
        

        String symptomsStr = "";
        ArrayList<Object> allSymptomIdObjList = (ArrayList<Object>)inputNameValuePairs.get(Constants.Key_Symptoms);
        if (allSymptomIdObjList!=null && allSymptomIdObjList.size()>0){
        	ArrayList<String> allSymptomIdList = Tool.convertToStringArrayList(allSymptomIdObjList);
    		ArrayList<HashMap<String, Object>> symptomInfos = Tool.getdictionaryArrayFrom2LevelDictionary(allSymptomIdList, allSymptomInfoDict2Level);
    		ArrayList<Object> symptomStrs = Tool.getPropertyArrayListFromDictionaryArray_withPropertyName(Constants.COLUMN_NAME_SymptomNameCn, symptomInfos);
    		symptomsStr = StringUtils.join(symptomStrs,"，");
        }
        tvSymptoms.setText(symptomsStr);
        
        
        ArrayList<Object> symptomsByType3DList = (ArrayList<Object>)inputNameValuePairs.get(Constants.Key_SymptomsByType);
        ArrayList<String> symptomTypeIdList = new ArrayList<String>();
        ArrayList<String> allSymptomIdList = new ArrayList<String>();
        HashMap<String, ArrayList<String>> symptomsByTypeHm = new HashMap<String, ArrayList<String>>();
        if (symptomsByType3DList!=null){
        	for(int i=0; i<symptomsByType3DList.size(); i++){
        		ArrayList<Object> typeAndSymptoms = (ArrayList<Object>)symptomsByType3DList.get(i);
        		String symptomTypeId = (String)typeAndSymptoms.get(0);
        		ArrayList<Object> symptomIdAsObjList1 = (ArrayList<Object>)typeAndSymptoms.get(1);
        		ArrayList<String> symptomIdList1 = Tool.convertToStringArrayList(symptomIdAsObjList1);
        		symptomTypeIdList.add(symptomTypeId);
        		allSymptomIdList.addAll(symptomIdList1);
        		symptomsByTypeHm.put(symptomTypeId, symptomIdList1);
        	}
        }

//        if (llSymptomAndType.getChildCount() < symptomTypeIdList.size()){
//        	int deltaCnt = symptomTypeIdList.size() - llSymptomAndType.getChildCount();
//        	for(int i=0; i<deltaCnt; i++){
//        		View vw1 = ((Activity) mContext).getLayoutInflater().inflate(R.layout.v3_part_symptomandtype_inhistory, null);
//        		llSymptomAndType.addView(vw1);
//        	}
//        }
//        for(int i=0; i<llSymptomAndType.getChildCount(); i++){
//        	View subView1 = llSymptomAndType.getChildAt(i);
//        	if (i >= symptomTypeIdList.size()){
//        		subView1.setVisibility(View.GONE);
//        	}else{
//        		subView1.setVisibility(View.VISIBLE);
//        		TextView tvSymptomType = (TextView)subView1.findViewById(R.id.tvSymptomType);
//        		TextView tvSymptoms1 = (TextView)subView1.findViewById(R.id.tvSymptoms);
//        		String symptomTypeId = symptomTypeIdList.get(i);
//        		HashMap<String, Object> symptomTypeInfo = symptomTypeInfoDict2Level.get(symptomTypeId);
//        		ArrayList<String> symptomIdsByType = symptomsByTypeHm.get(symptomTypeId);
//        		String symptomTypeCaption = (String)symptomTypeInfo.get(Constants.COLUMN_NAME_SymptomTypeNameCn);
//        		tvSymptomType.setText(symptomTypeCaption);
//        		ArrayList<HashMap<String, Object>> symptomInfosByType = Tool.getdictionaryArrayFrom2LevelDictionary(symptomIdsByType, allSymptomInfoDict2Level);
//        		ArrayList<Object> symptomStrs = Tool.getPropertyArrayListFromDictionaryArray_withPropertyName(Constants.COLUMN_NAME_SymptomNameCn, symptomInfosByType);
//        		String symptomsStr1 = StringUtils.join(symptomStrs,"，");
//        		tvSymptoms1.setText(symptomsStr1);
//        	}
//        }
        
        HashMap<String, Object> lackNutrientsAndFoods = (HashMap<String, Object>) calculateNameValuePairs.get(Constants.Key_LackNutrientsAndFoods);
        ArrayList<String> nutrientIdList = Tool.getKeysFromHashMap(lackNutrientsAndFoods);
        for(int i = 0;i< nutrientTextViews.length;i++){
            if ( i < nutrientIdList.size()){
            	nutrientTextViews[i].setVisibility(View.VISIBLE);
            	String nutrientId = nutrientIdList.get(i);
            	HashMap<String, Object> nutrientInfo = nutrientInfoDict2Level.get(nutrientId);
            	String nutrientCaption = (String)nutrientInfo.get(Constants.COLUMN_NAME_IconTitleCn);
                nutrientTextViews[i].setText(nutrientCaption);
                Tool.changeBackground_NutritionButton(mContext, nutrientTextViews[i], nutrientId, false);
            } else {
                nutrientTextViews[i].setVisibility(View.INVISIBLE);
            }
        }
        
        llItemByDay.setOnClickListener(new DayRecordOnClickListener(dayLocal));

        return convertView;
    }
    
    class DayRecordOnClickListener implements View.OnClickListener{
    	int m_dayLocal;
    	public DayRecordOnClickListener(int dayLocal){
    		m_dayLocal = dayLocal;
    	}

		@Override
		public void onClick(View v) {
			Intent intent1 = new Intent(mContext, V3ActivityReport.class);
//			intent1.putExtra(Constants.IntentParamKey_BackButtonTitle, m_fragment.getCurrentTitle());
			intent1.putExtra(Constants.IntentParamKey_BackButtonTitle, mContext.getResources().getString(R.string.tabCaption_history));
			intent1.putExtra(Constants.IntentParamKey_IsShowingData, true);
			intent1.putExtra(Constants.COLUMN_NAME_DayLocal, m_dayLocal);
			mContext.startActivity(intent1);
			
		}
    	
    }

	@Override
	public Object[] getSections() {
		return m_sections_dayLocal;
	}

	@Override
	public int getPositionForSection(int section) {
		return section;
	}

	@Override
	public int getSectionForPosition(int position) {
		return position;
	}
	
	static class OnClickListener_ListViewIndexItem implements View.OnClickListener{
		HistoryDayAdapter m_adapter;
		ListView m_lv;
		public OnClickListener_ListViewIndexItem(HistoryDayAdapter adapter, ListView lv){
			m_adapter = adapter;
			m_lv = lv;
		}
		
		@Override
		public void onClick(View v) {
			Integer secIdxObj = (Integer)v.getTag();
			int itemPos = m_adapter.getPositionForSection(secIdxObj);
			m_lv.setSelection(itemPos);
		}
	}
	
	public void setContentOfSideIndex(final ListView lv, LinearLayout llSideIndex) {
		llSideIndex.removeAllViews();
		Object[] sections = getSections();
		if (sections!=null){
			OnClickListener_ListViewIndexItem OnClickListener_ListViewIndexItem1 = new OnClickListener_ListViewIndexItem(HistoryDayAdapter.this, lv);
			for(int i=0; i<sections.length; i++){
				Object section = sections[i];
				TextView tv  = new TextView(mContext);
				tv.setText(section.toString());
				tv.setGravity(Gravity.CENTER_HORIZONTAL| Gravity.CENTER_VERTICAL);
				
				LayoutParams params = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT, 1);
				params.topMargin = 1;
				params.bottomMargin = 1;
				tv.setLayoutParams(params);
				tv.setTag(Integer.valueOf(i));
				tv.setOnClickListener(OnClickListener_ListViewIndexItem1);
				llSideIndex.addView(tv);
			}
		}
	}

}
