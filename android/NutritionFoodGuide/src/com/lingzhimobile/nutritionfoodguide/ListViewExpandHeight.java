package com.lingzhimobile.nutritionfoodguide;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.*;

/*
 * 参考 http://blog.csdn.net/liangguo03/article/details/7382002
 * 作用是把嵌入在scrollview的gridview撑到最大（最高）
 */
public class ListViewExpandHeight extends ListView {

	public ListViewExpandHeight(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
	}

	public ListViewExpandHeight(Context context, AttributeSet attrs) {
		super(context, attrs);
	}

	public ListViewExpandHeight(Context context) {
		super(context);
	}

	public void onMeasure(int widthMeasureSpec, int heightMeasureSpec)  
    {  
        int expandSpec = MeasureSpec.makeMeasureSpec(Integer.MAX_VALUE >> 2, MeasureSpec.AT_MOST);  
        super.onMeasure(widthMeasureSpec, expandSpec);  
    }  

}
