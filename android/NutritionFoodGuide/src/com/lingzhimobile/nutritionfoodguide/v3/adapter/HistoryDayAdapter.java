package com.lingzhimobile.nutritionfoodguide.v3.adapter;

import java.util.ArrayList;
import java.util.HashMap;

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
    
    public HistoryDayAdapter(Context context, ArrayList<HashMap<String, Object>> records) {
        mContext = context;
        mRecords = records;
    }

    @Override
    public int getCount() {
        return mRecords.size();
    }

    @Override
    public Object getItem(int position) {
        return mRecords.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if (convertView == null) {
            convertView = ((Activity)mContext).getLayoutInflater().inflate(
                    R.layout.v3_history_day_cell, null);
        }
        TextView contextTextView = (TextView) convertView.findViewById(R.id.contentTextView);
        contextTextView.setText(getItem(position).toString());
        return convertView;
    }

}
