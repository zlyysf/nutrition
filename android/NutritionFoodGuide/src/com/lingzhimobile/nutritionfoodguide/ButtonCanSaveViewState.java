package com.lingzhimobile.nutritionfoodguide;


import android.content.Context;
import android.os.*;
import android.util.AttributeSet;
import android.util.Log;
import android.widget.Button;

//http://stackoverflow.com/questions/3542333/how-to-prevent-custom-views-from-losing-state-across-screen-orientation-changes/

public class ButtonCanSaveViewState extends Button {
	
	public static final String StateKey_Enabled = "StateEnabled";
	public static final String StateKey_SuperInstance = "SuperInstance";
	
	static final String LogTag = ButtonCanSaveViewState.class.getSimpleName();

	public ButtonCanSaveViewState(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
	}

	public ButtonCanSaveViewState(Context context, AttributeSet attrs) {
		super(context, attrs);
	}

	public ButtonCanSaveViewState(Context context) {
		super(context);
	}
	
	@Override
	public Parcelable onSaveInstanceState() {
		Log.d(LogTag, "onSaveInstanceState");
//		Tool.printStackTrace(LogTag);
		/*
at com.lingzhimobile.nutritionfoodguide.Tool.printStackTrace(Tool.java:1770)
at com.lingzhimobile.nutritionfoodguide.ButtonCanSaveViewState.onSaveInstanceState(ButtonCanSaveViewState.java:34)
at android.view.View.dispatchSaveInstanceState(View.java:9872)
at android.view.ViewGroup.dispatchSaveInstanceState(ViewGroup.java:2296)
at android.view.ViewGroup.dispatchSaveInstanceState(ViewGroup.java:2296)
at android.view.View.saveHierarchyState(View.java:9855)
at android.support.v4.app.FragmentManagerImpl.saveFragmentViewState(FragmentManager.java:1574)
at android.support.v4.app.FragmentManagerImpl.moveToState(FragmentManager.java:977)
at android.support.v4.app.FragmentManagerImpl.removeFragment(FragmentManager.java:1185)
at android.support.v4.app.BackStackRecord.run(BackStackRecord.java:639)
at android.support.v4.app.FragmentManagerImpl.execPendingActions(FragmentManager.java:1444)
at android.support.v4.app.FragmentManagerImpl$1.run(FragmentManager.java:429)
at android.os.Handler.handleCallback(Handler.java:605)
at android.os.Handler.dispatchMessage(Handler.java:92)
at android.os.Looper.loop(Looper.java:137)
at android.app.ActivityThread.main(ActivityThread.java:4424)
at java.lang.reflect.Method.invokeNative(Native Method)
at java.lang.reflect.Method.invoke(Method.java:511)
at com.android.internal.os.ZygoteInit$MethodAndArgsCaller.run(ZygoteInit.java:787)
at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:554)
at dalvik.system.NativeStart.main(Native Method)
		 */
	    Bundle bundle = new Bundle();
	    bundle.putParcelable(StateKey_SuperInstance, super.onSaveInstanceState());
	    bundle.putBoolean(StateKey_Enabled, isEnabled());
	    return bundle;
	}
	
	@Override
	public void onRestoreInstanceState(Parcelable state) {
		Log.d(LogTag, "onRestoreInstanceState");
	    if (state instanceof Bundle) {
	      Bundle bundle = (Bundle) state;
	      boolean StateEnabled = bundle.getBoolean(StateKey_Enabled);
	      Parcelable stateSuperInstance = bundle.getParcelable(StateKey_SuperInstance);
	      super.onRestoreInstanceState(stateSuperInstance);
	    }else {
	    	super.onRestoreInstanceState(state);
		}
	    
	}

}
