package com.lingzhimobile.nutritionfoodguide;



import java.util.List;


import com.lingzhimobile.nutritionfoodguide.test.TestCaseDA;
import com.lingzhimobile.nutritionfoodguide.test.TestCaseRecommendFood;
import com.parse.FindCallback;
import com.parse.GetDataCallback;
import com.parse.ParseException;
import com.parse.ParseFile;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.SaveCallback;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class ActivityTestCases extends Activity implements OnClickListener{
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_testcases);
        
        Tool_microlog4android.init(this);
        
        Button button1 = (Button)findViewById(R.id.btnTestDA1);
        button1.setOnClickListener(this);
        button1 = (Button)findViewById(R.id.btnTestRF1);
        button1.setOnClickListener(this);
        
        button1 = (Button)findViewById(R.id.btnParseNew);
        button1.setOnClickListener(this);
        button1 = (Button)findViewById(R.id.btnParseGet);
        button1.setOnClickListener(this);
        button1 = (Button)findViewById(R.id.btnParseUpdate);
        button1.setOnClickListener(this);
      
    }
    
    @Override
	public void onClick(View view)
	{

    	
//		Intent intent = null;
		switch (view.getId())
		{
			case R.id.btnTestDA1:	
//				intent = new Intent(this, ActivityT1.class);
//				startActivity(intent);
				TestCaseDA.testMain(this);
				break;
			case R.id.btnTestRF1:
				TestCaseRecommendFood.testMain(this);
				break;

			case R.id.btnParseNew:
				saveParseObj();
				break;
			case R.id.btnParseGet:
				getParseObj();
				break;
			case R.id.btnParseUpdate:
				updateParseObj();
				break;
		}
		
	}
    
    ParseObject mParseObject;
    void saveParseObj(){
    	String s1 = "3333OpenUDID在iOS 5发布时，uniqueIdentifier被弃用了，这引起了广大开发者需要寻找一个可以替代UDID，并且不受苹果控制的方案。由此OpenUDID成为了当时使用最广泛的开源UDID替代方案。OpenUDID在工程中实现起来非常简单，并且还支持一系列的广告提供商。";
    	ParseObject parseObjUserRecord = ToolParse.newParseObjectByCurrentDeviceForUserRecord(this, s1);
    	mParseObject = parseObjUserRecord;
    	parseObjUserRecord.saveInBackground(new SaveCallback() {
			@Override
			public void done(ParseException e) {
				String msg;
				if (e != null){
					msg = "ERR: "+e.getMessage();
				}else{
					msg = "Save OK."+ mParseObject.getObjectId();
				}
				Log.d("ActivityTestCases", "saveParseObj msg:"+msg);
			}
		});//saveInBackground
    }
    void getParseObj(){
    	ParseQuery<ParseObject> query = ToolParse.getParseQueryByCurrentDeviceForUserRecord(this);
    	query.findInBackground(new FindCallback<ParseObject>() {
			@Override
			public void done(List<ParseObject> parseObjs, ParseException e) {
				String msg=null;
				if (e == null) {
					if (parseObjs == null || parseObjs.size()==0){
						msg = "Error: NOT GET any parse obj ";
					}else{
						mParseObject = parseObjs.get(0);
						msg = "Get OK." + mParseObject.getObjectId();
						
						ParseFile pfile = mParseObject.getParseFile(Constants.ParseObjectKey_UserRecord_attachFile);
						if (pfile == null){
							msg+="  But file is null";
						}else{
							msg+="  and have file";
							pfile.getDataInBackground(new GetDataCallback() {
								@Override
								public void done(byte[] retFileData, ParseException e) {
									String msg;
									if (e!=null){
										msg = "pfile.getDataInBackground FAIL:"+e.getMessage();
									}else{
										msg = "pfile.getDataInBackground OK.";
										String sFileContent = Tool.getStringFromUtf8Byte(retFileData);
										msg += "\n" + sFileContent;
									}
									Log.d("ActivityTestCases", "getParseFile msg:"+msg);
								}//done
							});//getDataInBackground
						}
					}
				} else {
					msg = "Error: "+ e.getMessage();
				}
				Log.d("ActivityTestCases", "getParseObj msg:"+msg);
			}//done
		});//findInBackground
    }
    void updateParseObj(){
    	if (mParseObject == null){
    		Log.d("ActivityTestCases", "updateParseObj mParseObject == null");
    		return;
    	}
    	String s1 = "3333我们融资的时候是 VC 先找的我们。早期国内的基金都是美元基金，VC 会在国内外往返。然后穷游做的是出境游，很多女合伙人也经常用穷游，就主动找到我们。";
    	
    	ToolParse.updateParseObject_UserRecord(mParseObject, s1);

    	mParseObject.saveInBackground(new SaveCallback() {
			@Override
			public void done(ParseException e) {
				String msg;
				if (e != null){
					msg = "ERR: "+e.getMessage();
				}else{
					msg = "Save OK."+ mParseObject.getObjectId();
				}
				Log.d("ActivityTestCases", "updateParseObj msg:"+msg);
			}
		});//saveInBackground
    }
}
