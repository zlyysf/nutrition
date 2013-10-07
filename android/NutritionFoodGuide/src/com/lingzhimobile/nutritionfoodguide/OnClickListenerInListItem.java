package com.lingzhimobile.nutritionfoodguide;

import android.view.View.*;
import android.view.*;

public abstract class OnClickListenerInListItem implements View.OnClickListener {
	protected int m_rowPos ;
	public void initInputData(int rowPos){
		m_rowPos = rowPos;
	}
}
