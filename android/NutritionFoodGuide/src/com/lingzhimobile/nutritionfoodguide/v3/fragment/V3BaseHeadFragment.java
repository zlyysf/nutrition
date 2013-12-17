package com.lingzhimobile.nutritionfoodguide.v3.fragment;

import android.support.v4.app.Fragment;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.lingzhimobile.nutritionfoodguide.R;

public abstract class V3BaseHeadFragment extends Fragment {

    public Button leftButton, rightButton;
    public TextView title;

    protected void initHeaderLayout(View view) {
        title = (TextView) view.findViewById(R.id.titleText);
        leftButton = (Button) view.findViewById(R.id.leftButton);
        rightButton = (Button) view.findViewById(R.id.rightButton);
        setHeader();
    }

    protected abstract void setHeader();;
}
