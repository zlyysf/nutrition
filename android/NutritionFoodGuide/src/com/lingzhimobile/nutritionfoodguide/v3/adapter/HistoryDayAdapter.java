package com.lingzhimobile.nutritionfoodguide.v3.adapter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import android.app.Activity;
import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.lingzhimobile.nutritionfoodguide.R;

public class HistoryDayAdapter extends BaseAdapter {

    Context mContext;
    ArrayList<HashMap<String, Object>> mRecords;

    public HistoryDayAdapter(Context context,
            ArrayList<HashMap<String, Object>> records) {
        mContext = context;
        mRecords = records;
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

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if (convertView == null) {
            convertView = ((Activity) mContext).getLayoutInflater().inflate(
                    R.layout.v3_history_day_cell, null);
        }
        TextView contextTextView = (TextView) convertView
                .findViewById(R.id.contentTextView);
        contextTextView.setText(getItem(position).toString());

        DayRecord record = new DayRecord(getItem(position));

        TextView dayTextView = (TextView) convertView
                .findViewById(R.id.dayTextView);
        TextView weekdayTextView = (TextView) convertView
                .findViewById(R.id.weekdayTextView);
        TextView bmiTextView = (TextView) convertView
                .findViewById(R.id.bmiTextView);
        TextView illnessTextView = (TextView) convertView
                .findViewById(R.id.illnessTextView);
        TextView temperatureTextView = (TextView) convertView
                .findViewById(R.id.temperatureTextView);
        TextView weightTextView = (TextView) convertView
                .findViewById(R.id.weightTextView);
        TextView bloodPressureTextView = (TextView) convertView
                .findViewById(R.id.bloodPressureTextView);
        TextView heartRateTextView = (TextView) convertView
                .findViewById(R.id.heartRateTextView);
        TextView noteTextView = (TextView) convertView
                .findViewById(R.id.noteTextView);
        TextView nutrient1TextView = (TextView) convertView
        .findViewById(R.id.nutrient1TextView);
        TextView nutrient2TextView = (TextView) convertView
        .findViewById(R.id.nutrient2TextView);
        TextView nutrient3TextView = (TextView) convertView
        .findViewById(R.id.nutrient3TextView);
        TextView nutrient4TextView = (TextView) convertView
        .findViewById(R.id.nutrient4TextView);
        TextView []nutrientTextViews = new TextView[]{nutrient1TextView,nutrient2TextView,nutrient3TextView,nutrient4TextView};
        for(int i = 0;i< nutrientTextViews.length;i++){
            if ( i < record.nutrientList.size()){
                nutrientTextViews[i].setText(record.nutrientList.get(i));
                nutrientTextViews[i].setVisibility(View.VISIBLE);
            } else {
                nutrientTextViews[i].setVisibility(View.INVISIBLE);
            }
        }
        
        dayTextView.setText(record.day);
        weekdayTextView.setText(record.weekday);
        bmiTextView.setText(String.valueOf(record.bmi));
        illnessTextView.setText(record.illnessList.toString().subSequence(1, record.illnessList.toString().length()-1));
        temperatureTextView.setText(String.valueOf(record.temperature)+"C");
        weightTextView.setText(String.valueOf(record.weight)+"kg");
        bloodPressureTextView.setText(record.bloodPressureHigh + "/"
                + record.bloodPressureLow);
        heartRateTextView.setText(String.valueOf(record.heartRate)+"bpm");
        noteTextView.setText(record.note);

        return convertView;
    }

    class DayRecord {
        String day, weekday;
        String note;
        double temperature;
        int bloodPressureLow, bloodPressureHigh;
        double weight;
        int heartRate;
        double bmi;
        List<String> nutrientList;
        List<String> illnessList;

        DayRecord(HashMap<String, Object> record) {
            day = "11月12日";
            weekday = "周五";
            note = "TODO";// (String) record.get("Note");
            Map inputNameValuePairs = (Map) record.get("inputNameValuePairs");
            temperature = (Double) inputNameValuePairs.get("Temperature");
            bloodPressureLow = (Integer) inputNameValuePairs
                    .get("BloodPressureLow");
            bloodPressureHigh = (Integer) inputNameValuePairs
                    .get("BloodPressureHigh");
            weight = (Double) inputNameValuePairs.get("Weight");
            heartRate = (Integer) inputNameValuePairs.get("HeartRate");
            Map calculateNameValuePairs = (Map) record
                    .get("calculateNameValuePairs");
            bmi = (Double) calculateNameValuePairs.get("BMI");
            
            Map lackNutrientsAndFoods = (Map) calculateNameValuePairs
                .get("LackNutrientsAndFoods");
            Set keySet = lackNutrientsAndFoods.keySet();
            Iterator keyIter = keySet.iterator();
            nutrientList = new ArrayList<String>();
            while (keyIter.hasNext()) {
                nutrientList.add((String) keyIter.next());
            }
    
            Map inferIllnessesAndSuggestions = (Map) calculateNameValuePairs
                    .get("InferIllnessesAndSuggestions");
            keySet = inferIllnessesAndSuggestions.keySet();
            keyIter = keySet.iterator();
            illnessList = new ArrayList<String>();
            while (keyIter.hasNext()) {
                illnessList.add((String) keyIter.next());
            }
        }
    }
}
