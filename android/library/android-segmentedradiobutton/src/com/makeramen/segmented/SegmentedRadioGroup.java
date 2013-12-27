/*
 * Copyright (C) 2011 Make Ramen, LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.makeramen.segmented;



import android.content.Context;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import android.widget.RadioGroup;

public class SegmentedRadioGroup extends RadioGroup {
	
	int m_segment_radio_left = com.makeramen.segmented.R.drawable.segment_radio_left;
	int m_segment_radio_middle = com.makeramen.segmented.R.drawable.segment_radio_middle;
	int m_segment_radio_right = com.makeramen.segmented.R.drawable.segment_radio_right;
	int m_segment_button = com.makeramen.segmented.R.drawable.segment_button;

	public SegmentedRadioGroup(Context context) {
		super(context);
		this.readStyleParameters(context, null);
	}

	public SegmentedRadioGroup(Context context, AttributeSet attrs) {
		super(context, attrs);
		this.readStyleParameters(context, attrs);
	}
	
	private void readStyleParameters(Context context, AttributeSet attributeSet) {
        TypedArray a = context.obtainStyledAttributes(attributeSet, R.styleable.SegmentedRadioGroup);
        try {
        	m_segment_radio_left = a.getResourceId(R.styleable.SegmentedRadioGroup_segment_radio_left, m_segment_radio_left);
        	m_segment_radio_middle = a.getResourceId(R.styleable.SegmentedRadioGroup_segment_radio_middle, m_segment_radio_middle);
        	m_segment_radio_right = a.getResourceId(R.styleable.SegmentedRadioGroup_segment_radio_right, m_segment_radio_right);
        	m_segment_button = a.getResourceId(R.styleable.SegmentedRadioGroup_segment_button, m_segment_button);
        } finally {
            a.recycle();
        }
    }
	

	@Override
	protected void onFinishInflate() {
		super.onFinishInflate();
		changeButtonsImages();
	}

	private void changeButtonsImages(){
		int count = super.getChildCount();

		if(count > 1){
			super.getChildAt(0).setBackgroundResource(m_segment_radio_left);
			for(int i=1; i < count-1; i++){
				super.getChildAt(i).setBackgroundResource(m_segment_radio_middle);
			}
			super.getChildAt(count-1).setBackgroundResource(m_segment_radio_right);
		}else if (count == 1){
			super.getChildAt(0).setBackgroundResource(m_segment_button);
		}
	}
}