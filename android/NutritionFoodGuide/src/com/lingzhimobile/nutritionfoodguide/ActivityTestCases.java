package com.lingzhimobile.nutritionfoodguide;



import java.util.Date;
import java.util.HashMap;
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
      
        button1 = (Button)findViewById(R.id.btnParseRowSave);
        button1.setOnClickListener(this);
        button1 = (Button)findViewById(R.id.btnParseRowGet);
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
				
			case R.id.btnParseRowSave:
				saveParseRowObj();
				break;
			case R.id.btnParseRowGet:
				getParseRowObj();
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
    
    
    
    
    
    void saveParseRowObj(){

    	int daylocal = 12345678;
    	Date dt = new Date();
    	HashMap<String, Object> inputNameValuePairsData = new HashMap<String, Object>();
    	String Note = "Note";
    	HashMap<String, Object> calculateNameValuePairsData = new HashMap<String, Object>();
    	
    	inputNameValuePairsData.put("ia1", 11122);
    	inputNameValuePairsData.put("ia2", "aaa222");
    	calculateNameValuePairsData.put("ca1", 123);

    	ParseObject parseObjUserRecord = ToolParse.getToSaveParseObject_UserRecordSymptom(this,daylocal,dt,inputNameValuePairsData,Note,calculateNameValuePairsData );

    	class T1SaveCallback extends SaveCallback{
    		ParseObject m_parseObj;
    		int m_daylocal;
    		public T1SaveCallback(ParseObject parseObj,int daylocal){
    			m_parseObj = parseObj;
    			m_daylocal = daylocal;
    		}
    		
    		@Override
			public void done(ParseException e) {
				String msg;
				if (e != null){
					msg = "ERR: "+e.getMessage();
				}else{
					msg = "Save OK."+ m_parseObj.getObjectId();
					StoredConfigTool.saveParseObjectInfo_CurrentUserRecordSymptom(ActivityTestCases.this, m_parseObj.getObjectId(), m_daylocal);
				}
				Log.d("ActivityTestCases", "saveParseRowObj msg:"+msg);
			}
    	};
    	T1SaveCallback funCallback = new T1SaveCallback(parseObjUserRecord,daylocal);
//    	parseObjUserRecord.saveInBackground(funCallback);
    	
    	parseObjUserRecord.saveEventually(funCallback);
    	Log.d("ActivityTestCases", "after saveEventually, objId="+parseObjUserRecord.getObjectId());//objId=null，看来是只有实际保存上了才有objId，这样会导致saveEventually保存多于1条的记录。这样，它也并不比saveInBackground要好多少。
    	StoredConfigTool.saveParseObjectInfo_CurrentUserRecordSymptom(ActivityTestCases.this, parseObjUserRecord.getObjectId(), daylocal);
    }
    void getParseRowObj(){
    	int daylocal = 12345678;
    	ParseQuery<ParseObject> query = ToolParse.getParseQueryByCurrentDeviceForUserRecordSymptom(this,daylocal);
    	
    	query.findInBackground(new FindCallback<ParseObject>() {
			@Override
			public void done(List<ParseObject> parseObjs, ParseException e) {
				String msg=null;
				if (e == null) {
					if (parseObjs == null || parseObjs.size()==0){
						msg = "Error: NOT GET any parse obj ";
					}else{
						mParseObject = parseObjs.get(0);
						msg = "Get OK." + mParseObject.getObjectId()
								+", daylocal="+mParseObject.getInt(Constants.COLUMN_NAME_DayLocal)
								+", inputNameValuePairs="+mParseObject.getString(Constants.COLUMN_NAME_inputNameValuePairs);
						
					}
				} else {
					msg = "Error: "+ e.getMessage();
				}
				Log.d("ActivityTestCases", "getParseRowObj msg:"+msg);
			}//done
		});//findInBackground
    }
    
    
    
    
    
    
    
    
    
    
}
