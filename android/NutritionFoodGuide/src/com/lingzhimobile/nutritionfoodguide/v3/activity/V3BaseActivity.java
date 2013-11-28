package com.lingzhimobile.nutritionfoodguide.v3.activity;

import com.lingzhimobile.nutritionfoodguide.R;

import android.support.v4.app.FragmentActivity;
import android.widget.Button;
import android.widget.TextView;

public class V3BaseActivity  extends FragmentActivity{

    public Button leftButton, rightButton;
    public TextView title;

    private void initHeaderLayout(){
        title = (TextView) findViewById(R.id.titleText);
        leftButton = (Button) findViewById(R.id.leftButton);
        rightButton = (Button) findViewById(R.id.rightButton);
    }

    @Override
    public void setContentView(int layoutResID) {
        super.setContentView(layoutResID);
        initHeaderLayout();
    }
}
