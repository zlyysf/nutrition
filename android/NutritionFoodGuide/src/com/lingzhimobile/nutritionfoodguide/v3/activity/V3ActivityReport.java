package com.lingzhimobile.nutritionfoodguide.v3.activity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.util.Pair;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.lingzhimobile.nutritionfoodguide.Constants;
import com.lingzhimobile.nutritionfoodguide.DataAccess;
import com.lingzhimobile.nutritionfoodguide.R;
import com.lingzhimobile.nutritionfoodguide.Tool;
import com.lingzhimobile.nutritionfoodguide.v3.fragment.V3RecommentFoodFragment;

public class V3ActivityReport extends V3BaseActivity {

    LinearLayout elementLinearLayout;
    LinearLayout recommendViewPager;
    ListView diseaseAttentionListView;
    LinearLayout attentionLinearLayout;

    int heartRate;
    int bloodPressureHigh, bloodPressureLow;
    double bodyTemperature;

    String[] elements;
    List<Pair<String, String>> recommentFoods;

    List<String> diseaseList = new ArrayList<String>();
    List<List<String>> attentionList = new ArrayList<List<String>>();

    DiseaseAttentionAdapter diseaseAttentionAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.v3_activity_report);
        leftButton.setText("健康记录");
        title.setText("健康报告");
        rightButton.setVisibility(View.GONE);

        // get data from intent
        Intent intent = getIntent();
        heartRate = intent.getIntExtra(Constants.Key_HeartRate, 101);
        bloodPressureHigh = intent.getIntExtra(Constants.Key_BloodPressureHigh,
                150);
        bloodPressureLow = intent.getIntExtra(Constants.Key_BloodPressureLow,
                130);
        bodyTemperature = intent.getDoubleExtra(Constants.Key_BodyTemperature,
                38.4);

        // TODO
        elements = new String[] { "维生素A", "锌", "维生素B12" };
        recommentFoods = new ArrayList<Pair<String, String>>();
        recommentFoods.add(new Pair<String, String>("鸡蛋", "2个"));
        recommentFoods.add(new Pair<String, String>("开心果", "50克"));
        recommentFoods.add(new Pair<String, String>("生蚝", "2个"));
        recommentFoods.add(new Pair<String, String>("西兰花", "100克"));
        recommentFoods.add(new Pair<String, String>("鸡蛋", "2个"));
        recommentFoods.add(new Pair<String, String>("开心果", "50克"));
        recommentFoods.add(new Pair<String, String>("生蚝", "2个"));
        recommentFoods.add(new Pair<String, String>("西兰花", "100克"));

        elementLinearLayout = (LinearLayout) findViewById(R.id.elementLinearLayout);
        for (String element : elements) {
            View view = LayoutInflater.from(this).inflate(
                    R.layout.v3_element_cell, null);
            TextView elementTextView = (TextView) view
                    .findViewById(R.id.elementTextView);
            elementTextView.setText(element);

            recommendViewPager = (LinearLayout) view
                    .findViewById(R.id.recommendViewPager);
            for (Pair<String, String> recommentFood : recommentFoods) {
                View viewPager = LayoutInflater.from(this).inflate(
                        R.layout.v3_recomment_food_cell, null);
                TextView foodNameTextView = (TextView) viewPager
                        .findViewById(R.id.foodNameTextView);
                TextView foodCountTextView = (TextView) viewPager
                        .findViewById(R.id.foodCountTextView);
                foodNameTextView.setText(recommentFood.first);
                foodCountTextView.setText(recommentFood.second);
                recommendViewPager.addView(viewPager);
            }

            elementLinearLayout.addView(view);
        }

        diseaseAttentionListView = (ListView) findViewById(R.id.diseaseAttentionListView);
        diseaseAttentionAdapter = new DiseaseAttentionAdapter();
        diseaseAttentionListView.setAdapter(diseaseAttentionAdapter);

        GetDiseaseAttentionTask getDiseaseAttentionTask = new GetDiseaseAttentionTask();
        getDiseaseAttentionTask.execute();
    }

    class GetDiseaseAttentionTask extends AsyncTask<Void, Void, Void> {

        @Override
        protected Void doInBackground(Void... arg0) {
            //TODO
            String[] symptomIds = { "咽喉发痒", "咽喉灼热", "咳嗽", "咳痰", "喘息", "食欲不振",
                    "恶心", "呕吐", "上腹痛" };
            HashMap<String, Object> measureData = new HashMap<String, Object>();
            measureData.put(Constants.Key_HeartRate, heartRate);
            measureData.put(Constants.Key_BloodPressureHigh,
                    bloodPressureHigh);
            measureData.put(Constants.Key_BloodPressureLow,
                    bloodPressureLow);
            measureData
                    .put(Constants.Key_BodyTemperature, bodyTemperature);

            diseaseList = Tool.inferIllnesses_withSymptoms(
                    Tool.convertFromArrayToList(symptomIds), measureData);

            DataAccess da = DataAccess.getSingleton(V3ActivityReport.this);

            for (String disease : diseaseList) {
                ArrayList<String> tempList = new ArrayList<String>();
                tempList.add(disease);
                ArrayList<HashMap<String, Object>> result = da
                        .getIllnessSuggestionsDistinct_ByIllnessIds(tempList);
                List<String> attention = new ArrayList<String>();
                if (result != null) {
                    for (HashMap<String, Object> map : result) {
                        attention.add(map.get("SuggestionId").toString());
                    }
                }
                attentionList.add(attention);
            }

            return null;
        }

        @Override
        protected void onPostExecute(Void result) {
            super.onPostExecute(result);
            diseaseAttentionAdapter.notifyDataSetChanged();
        }

    }

    class DiseaseAttentionAdapter extends BaseAdapter {

        @Override
        public int getCount() {
            return diseaseList.size();
        }

        @Override
        public Object getItem(int arg0) {
            return diseaseList.get(arg0);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            if (convertView == null) {
                convertView = getLayoutInflater().inflate(
                        R.layout.v3_disease_cell, null);
            }
            TextView diseaseTextView = (TextView) convertView
                    .findViewById(R.id.diseaseTextView);
            diseaseTextView.setText(diseaseList.get(position));

            attentionLinearLayout = (LinearLayout) convertView
                    .findViewById(R.id.attentionLinearLayout);
            attentionLinearLayout.removeAllViews();

            for (String attention : attentionList.get(position)) {
                View view = getLayoutInflater().inflate(
                        R.layout.v3_attention_cell, null);
                TextView attentionTextView = (TextView) view
                        .findViewById(R.id.attentionTextView);
                attentionTextView.setText(attention);
                attentionLinearLayout.addView(view);
            }

            return convertView;
        }

    }

    class RecommentFoodAdapter extends FragmentPagerAdapter {

        String[] mRecommentFoods;

        public RecommentFoodAdapter(FragmentManager fm, String[] recommentFoods) {
            super(fm);
            mRecommentFoods = recommentFoods;
        }

        @Override
        public V3RecommentFoodFragment getItem(int arg0) {
            return V3RecommentFoodFragment.newInstance();
        }

        @Override
        public int getCount() {
            return mRecommentFoods.length;
        }

    }
}
