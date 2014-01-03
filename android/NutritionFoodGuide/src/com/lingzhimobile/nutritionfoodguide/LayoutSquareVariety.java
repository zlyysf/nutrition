package com.lingzhimobile.nutritionfoodguide;



import android.content.Context;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View.MeasureSpec;
import android.widget.LinearLayout;

public class LayoutSquareVariety extends LinearLayout{
	static final String LogTag = "LayoutSquareVariety";
	
	double m_time = 1.0;
	double m_offset = 0;
	
	public LayoutSquareVariety(Context context) {
		super(context);
		this.readStyleParameters(context, null);
	}

	public LayoutSquareVariety(Context context, AttributeSet attrs) {
		super(context, attrs);
		this.readStyleParameters(context, attrs);
	}
	
	private void readStyleParameters(Context context, AttributeSet attributeSet) {
        TypedArray a = context.obtainStyledAttributes(attributeSet, R.styleable.LayoutSquareVariety);
        try {
        	
        	m_time = a.getFloat(R.styleable.LayoutSquareVariety_time, (float)m_time);
        	m_offset = a.getDimensionPixelOffset(R.styleable.LayoutSquareVariety_offset, (int)m_offset);

        } finally {
            a.recycle();
        }
    }

	@Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
	
//		Log.d(LogTag, "paramWH("+widthMeasureSpec+","+heightMeasureSpec+")super.onMeasure("+widthMeasureSpec+","+heightMeasureSpec2+") m_time="+m_time);

		int specModeW = MeasureSpec.getMode(widthMeasureSpec);
		if (specModeW == MeasureSpec.EXACTLY){
			int specSizeW = MeasureSpec.getSize(widthMeasureSpec);
			double height2 = specSizeW * m_time + m_offset;
			int heightMeasureSpec2 = MeasureSpec.makeMeasureSpec((int)height2, MeasureSpec.EXACTLY);
			super.onMeasure(widthMeasureSpec, heightMeasureSpec2);
		}else{
			super.onMeasure(widthMeasureSpec, widthMeasureSpec);//not go here
		}

    }


}
