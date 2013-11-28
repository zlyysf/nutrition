package com.lingzhimobile.nutritionfoodguide.v3.activity;

import android.os.Bundle;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;

import com.lingzhimobile.nutritionfoodguide.R;
import com.lingzhimobile.nutritionfoodguide.v3.fragment.RecommentFoodFragment;

public class V3ActivityReport extends V3BaseActivity {

    LinearLayout recommendViewPager;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.v3_activity_report);
        leftButton.setText("健康记录");
        title.setText("健康报告");
        rightButton.setVisibility(View.GONE);
        
        String[] recommentFoods = new String[]{"鸡蛋","开心果","生蚝","西兰花","鸡蛋","开心果","生蚝","西兰花","鸡蛋","开心果","生蚝","西兰花"};
        recommendViewPager = (LinearLayout) findViewById(R.id.recommendViewPager);
        for (String recommentFood : recommentFoods){
            View view = LayoutInflater.from(this).inflate(R.layout.v3_recomment_food_cell, null);
            recommendViewPager.addView(view);
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
