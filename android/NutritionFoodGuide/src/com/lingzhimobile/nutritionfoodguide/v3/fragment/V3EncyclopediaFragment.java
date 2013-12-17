package com.lingzhimobile.nutritionfoodguide.v3.fragment;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ListView;
import android.widget.TextView;

import com.lingzhimobile.nutritionfoodguide.GridViewExpandHeight;
import com.lingzhimobile.nutritionfoodguide.ListViewExpandHeight;
import com.lingzhimobile.nutritionfoodguide.R;

public class V3EncyclopediaFragment extends V3BaseHeadFragment {
    static final String LogTag = V3EncyclopediaFragment.class.getSimpleName();

    GridView foodGridView;

    String[] foods = new String[] { "蛋类", "主食", "五谷", "奶制品", "水产", "水果", "肉类",
            "菌类", "蔬菜", "调味品", "豆制品", "干果" };

    ListView commonDiseaseListView;

    String[] diseases = new String[] { "急性咽炎", "关节炎", "流行性感冒", "急性胃炎" };

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.v3_fragment_encyclopedia,
                container, false);
        initHeaderLayout(view);
        foodGridView = (GridViewExpandHeight) view.findViewById(R.id.foodCell);
        FoodCellAdapter foodCellAdapter = new FoodCellAdapter();
        foodGridView.setAdapter(foodCellAdapter);
        
        commonDiseaseListView = (ListViewExpandHeight) view.findViewById(R.id.commonDiseaseListView);
        DiseaseAdapter diseaseAdapter = new DiseaseAdapter();
        commonDiseaseListView.setAdapter(diseaseAdapter);
        
        return view;
    }

    public static Fragment newInstance(int arg0) {
        Fragment encyclopediaFragment = new V3EncyclopediaFragment();
        return encyclopediaFragment;
    }

    class DiseaseAdapter extends BaseAdapter {

        @Override
        public int getCount() {
            return diseases.length;
        }

        @Override
        public Object getItem(int arg0) {
            return diseases[arg0];
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            if (convertView == null) {
                convertView = getActivity().getLayoutInflater().inflate(
                        R.layout.v3_list_cell_disease, null);
            }
            TextView foodName = (TextView) convertView.findViewById(R.id.diseaseName);
            foodName.setText(diseases[position]);
            return convertView;
        }

    }

    class FoodCellAdapter extends BaseAdapter {

        @Override
        public int getCount() {
            return foods.length;
        }

        @Override
        public Object getItem(int arg0) {
            return foods[arg0];
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            if (convertView == null) {
                convertView = getActivity().getLayoutInflater().inflate(
                        R.layout.v3_grid_cell_food, null);
            }
            TextView foodName = (TextView) convertView.findViewById(R.id.foodName);
            foodName.setText(foods[position]);
            return convertView;
        }

    }

    @Override
    protected void setHeader() {
        // TODO Auto-generated method stub
        
    }
}
