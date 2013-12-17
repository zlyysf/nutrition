package com.lingzhimobile.nutritionfoodguide.v3.fragment;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.lingzhimobile.nutritionfoodguide.R;

public class V3RecommentFoodFragment extends V3BaseHeadFragment {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.v3_recomment_food_cell,
                container, false);
        initHeaderLayout(view);
        return view;
    }

    public static V3RecommentFoodFragment newInstance() {
        V3RecommentFoodFragment fragment = new V3RecommentFoodFragment();
        return fragment;
    }

    @Override
    protected void setHeader() {
        // TODO Auto-generated method stub
        
    }
}
