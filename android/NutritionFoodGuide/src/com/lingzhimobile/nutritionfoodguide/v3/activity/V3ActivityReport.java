package com.lingzhimobile.nutritionfoodguide.v3.activity;

import java.util.ArrayList;
import java.util.List;

import android.os.Bundle;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.util.Pair;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.lingzhimobile.nutritionfoodguide.R;
import com.lingzhimobile.nutritionfoodguide.v3.fragment.RecommentFoodFragment;

public class V3ActivityReport extends V3BaseActivity {

    LinearLayout elementLinearLayout;
    LinearLayout recommendViewPager;
    LinearLayout diseaseLinearLayout;
    LinearLayout attentionLinearLayout;

    String[] elements;
    List<Pair<String, String>> recommentFoods;
    String[] diseases;
    String[] attentions;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.v3_activity_report);
        leftButton.setText("健康记录");
        title.setText("健康报告");
        rightButton.setVisibility(View.GONE);

        elements = new String[]{"维生素A","锌","维生素B12"};
        recommentFoods = new ArrayList<Pair<String, String>>();
        recommentFoods.add(new Pair<String, String>("鸡蛋","2个"));
        recommentFoods.add(new Pair<String, String>("开心果","50克"));
        recommentFoods.add(new Pair<String, String>("生蚝","2个"));
        recommentFoods.add(new Pair<String, String>("西兰花","100克"));
        recommentFoods.add(new Pair<String, String>("鸡蛋","2个"));
        recommentFoods.add(new Pair<String, String>("开心果","50克"));
        recommentFoods.add(new Pair<String, String>("生蚝","2个"));
        recommentFoods.add(new Pair<String, String>("西兰花","100克"));

        elementLinearLayout = (LinearLayout) findViewById(R.id.elementLinearLayout);
        for (String element : elements){
            View view = LayoutInflater.from(this).inflate(R.layout.v3_element_cell, null);
            TextView elementTextView = (TextView)view.findViewById(R.id.elementTextView);
            elementTextView.setText(element);

            recommendViewPager = (LinearLayout) view.findViewById(R.id.recommendViewPager);
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

        diseases = new String[] { "急性咽炎", "关节炎", "流行性感冒" };
        attentions = new String[] { "1. 少吃熏制，腌制，富含硝酸盐的食品", "2. 避免大量饮酒，吸烟",
                "3. 充分睡眠", "4. 多饮水，保持室内空气流通" };

        diseaseLinearLayout = (LinearLayout) findViewById(R.id.diseaseLinearLayout);
        for (String disease : diseases){
            View diseaseCell = LayoutInflater.from(this).inflate(R.layout.v3_disease_cell, null);
            TextView diseaseTextView = (TextView)diseaseCell.findViewById(R.id.diseaseTextView);
            diseaseTextView.setText(disease);
            
            attentionLinearLayout = (LinearLayout) diseaseCell.findViewById(R.id.attentionLinearLayout);
            for (String attention : attentions){
                View view = LayoutInflater.from(this).inflate(R.layout.v3_attention_cell, null);
                TextView attentionTextView = (TextView)view.findViewById(R.id.attentionTextView);
                attentionTextView.setText(attention);
                attentionLinearLayout.addView(view);
            }

            diseaseLinearLayout.addView(diseaseCell);
        }

    }

    class RecommentFoodAdapter extends FragmentPagerAdapter {

        String[] mRecommentFoods;
        public RecommentFoodAdapter(FragmentManager fm, String[] recommentFoods) {
            super(fm);
            mRecommentFoods = recommentFoods;
        }

        @Override
        public RecommentFoodFragment getItem(int arg0) {
            return RecommentFoodFragment.newInstance();
        }

        @Override
        public int getCount() {
            return mRecommentFoods.length;
        }
        
    }
}
