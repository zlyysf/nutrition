package com.lingzhimobile.nutritionfoodguide;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.GridView;

/*
 * 参考 http://blog.csdn.net/liangguo03/article/details/7382002
 * 作用是把嵌入在scrollview的gridview撑到最大（最高）
 */
public class GridViewExpandHeight extends GridView {

	public GridViewExpandHeight(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
	}

	public GridViewExpandHeight(Context context, AttributeSet attrs) {
		super(context, attrs);
	}

	public GridViewExpandHeight(Context context) {
		super(context);
	}
	
	public void onMeasure(int widthMeasureSpec, int heightMeasureSpec)  
    {  
        int expandSpec = MeasureSpec.makeMeasureSpec(Integer.MAX_VALUE >> 2, MeasureSpec.AT_MOST);  
        super.onMeasure(widthMeasureSpec, expandSpec);  
    }  

}
