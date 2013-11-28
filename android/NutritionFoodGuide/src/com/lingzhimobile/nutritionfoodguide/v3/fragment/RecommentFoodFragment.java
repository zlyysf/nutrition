package com.lingzhimobile.nutritionfoodguide.v3.fragment;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.lingzhimobile.nutritionfoodguide.R;

public class RecommentFoodFragment extends Fragment {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.v3_recomment_food_cell,
                container, false);
        return view;
    }

    public static RecommentFoodFragment newInstance() {
        RecommentFoodFragment fragment = new RecommentFoodFragment();
        return fragment;
    }
}
