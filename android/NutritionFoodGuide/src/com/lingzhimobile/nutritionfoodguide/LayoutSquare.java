package com.lingzhimobile.nutritionfoodguide;

import android.content.Context;
import android.util.AttributeSet;
import android.util.Log;
import android.widget.LinearLayout;

public class LayoutSquare extends LinearLayout{
	static final String LogTag = "LayoutSquare";
	
	public LayoutSquare(Context context) {
		super(context);
	}

	public LayoutSquare(Context context, AttributeSet attrs) {
		super(context, attrs);
	}

	@Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
		Log.d(LogTag, "paramWH("+widthMeasureSpec+","+heightMeasureSpec+")super.onMeasure("+widthMeasureSpec+","+widthMeasureSpec+")");
		// paramWH(1073742173,0)super.onMeasure(1073742173,1073742173)
        super.onMeasure(widthMeasureSpec, widthMeasureSpec);//OK
    }

}
