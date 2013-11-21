package com.lingzhimobile.nutritionfoodguide.v3.fragment;

import com.lingzhimobile.nutritionfoodguide.R;
import com.lingzhimobile.nutritionfoodguide.R.id;
import com.lingzhimobile.nutritionfoodguide.R.layout;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

public class TabContentFragment extends Fragment {

    int tabId;
    String[] sectionTitles;
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Bundle arg = getArguments();
        tabId = arg.getInt("tab_id");
        
        sectionTitles = getResources().getStringArray(
                R.array.home_tab_selections);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.textfragment, container, false);
        TextView text = (TextView)view.findViewById(R.id.text);
        text.setText(sectionTitles[tabId]);
        return view;
    }

    public static TabContentFragment newInstance(int tabId) {
        TabContentFragment fragment = new TabContentFragment();
        Bundle args = new Bundle();
        args.putInt("tab_id", tabId);
        fragment.setArguments(args);
        return fragment;
    }
}
