package com.lingzhimobile.nutritionfoodguide;



import android.content.Context;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import android.util.Log;
import android.widget.*;

public class ScrollViewDebug extends ScrollView{
	static final String LogTag = "ScrollViewDebug";
	
	public boolean mCanScroll = false; // 为了预防activity开始显示或重新显示时，scrollview自动滚动一段距离的bug
	
	public ScrollViewDebug(Context context) {
		super(context);
	}
	public ScrollViewDebug(Context context, AttributeSet attrs) {
		super(context, attrs);
	}
	public ScrollViewDebug(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }
	
	
	public boolean arrowScroll (int direction){
		return super.arrowScroll(direction);
	}
    
	public void computeScroll (){
		super.computeScroll();
	}
    
	public boolean fullScroll (int direction){
		return super.fullScroll(direction);
	}
	
	public void fling (int velocityY){
		super.fling(velocityY);
	}
	
	public boolean pageScroll (int direction){
		return super.pageScroll(direction);
	}
	
	public void scrollTo (int x, int y){
		Log.d(LogTag, "scrollTo "+x+","+y+" mCanScroll="+mCanScroll);
		if (mCanScroll){
			super.scrollTo(x, y);
		}else{
			//keep old pos
		}
	}
	
	public void scrollBy(int x, int y){
		Log.d(LogTag, "scrollBy "+x+","+y+" mCanScroll="+mCanScroll);
		if (mCanScroll){
			super.scrollBy(x, y);
		}else{
			//keep old pos
		}
	}
	
//	public void smoothScrollBy (int dx, int dy){
//		super.smoothScrollBy(dx, dy);
//	}
	
	protected void onSizeChanged (int w, int h, int oldw, int oldh){
		super.onSizeChanged(w, h, oldw, oldh);
	}
	
	protected void onScrollChanged(int l, int t, int oldl, int oldt) {
		Log.d(LogTag, "onScrollChanged "+l+","+t+" <- "+oldl+","+oldt);
		super.onScrollChanged(l, t, oldl, oldt);
	}
	
	protected void onLayout (boolean changed, int l, int t, int r, int b){
		super.onLayout(changed, l, t, r, b);
	}
	
//	public void layout (int l, int t, int r, int b){
//		super.layout(l, t, r, b);
//	}

}
