package com.lingzhimobile.nutritionfoodguide.v3.fragment;

import java.util.HashMap;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RadioGroup;

import com.lingzhimobile.nutritionfoodguide.Constants;
import com.lingzhimobile.nutritionfoodguide.R;
import com.lingzhimobile.nutritionfoodguide.StoredConfigTool;
import com.lingzhimobile.nutritionfoodguide.v3.activity.V3ActivityHome;

public class V3SettingFragment extends V3BaseHeadFragment {
    static final String LogTag = V3SettingFragment.class.getSimpleName();

    EditText birthdayTextView, heightTextView, weightTextView;
    RadioGroup genderRadioGroup, intensityRadioGroup;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.v3_fragment_setting, container,
                false);
        initHeaderLayout(view);
        birthdayTextView = (EditText) view.findViewById(R.id.birthdayTextView);
        heightTextView = (EditText) view.findViewById(R.id.heightTextView);
        weightTextView = (EditText) view.findViewById(R.id.weightTextView);
        genderRadioGroup = (RadioGroup) view.findViewById(R.id.genderRadioGroup);
        intensityRadioGroup = (RadioGroup) view.findViewById(R.id.intensityRadioGroup);
        return view;
    }

    public static Fragment newInstance(int arg0) {
        Fragment settingFragment = new V3SettingFragment();
        return settingFragment;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        HashMap<String, Object> userInfo = StoredConfigTool
                .getUserInfo(getActivity());

        birthdayTextView.setText(userInfo.get(Constants.ParamKey_age)
                .toString());
        heightTextView.setText(userInfo.get(Constants.ParamKey_height)
                .toString());
        weightTextView.setText(userInfo.get(Constants.ParamKey_weight)
                .toString());
        genderRadioGroup.check((Integer) userInfo.get(Constants.ParamKey_sex));
        intensityRadioGroup.check((Integer) userInfo.get(Constants.ParamKey_activityLevel));

    }

    @Override
    protected void setHeader() {
        rightButton.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                HashMap<String, Object> userInfo = new HashMap<String, Object>();
                userInfo.put(Constants.ParamKey_age,
                        Integer.parseInt(birthdayTextView.getText().toString()));
                userInfo.put(Constants.ParamKey_height,
                        Double.parseDouble(heightTextView.getText().toString()));
                userInfo.put(Constants.ParamKey_weight,
                        Double.parseDouble(weightTextView.getText().toString()));
                userInfo.put(Constants.ParamKey_sex, genderRadioGroup.getCheckedRadioButtonId());
                userInfo.put(Constants.ParamKey_activityLevel, intensityRadioGroup.getCheckedRadioButtonId());
                StoredConfigTool.saveUserInfo(getActivity(), userInfo);
            }
        });
    }

}
