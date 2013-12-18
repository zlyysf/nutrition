package com.lingzhimobile.nutritionfoodguide;


import java.nio.charset.Charset;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.json.JSONException;
import org.json.JSONObject;

import android.R.bool;
import android.content.Context;
import android.util.Log;


import com.lingzhimobile.nutritionfoodguide.Tool.JustCallback;
import com.parse.FindCallback;
import com.parse.ParseException;
import com.parse.ParseFile;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseUser;

public class ToolParse {
	static final String LogTag = "ToolParse";
	
	public static ParseObject newParseObjectByCurrentDeviceForUserRecord(Context ctx, String fileContent){
		ParseObject parseObj = new ParseObject(Constants.ParseObject_UserRecord);
		parseObj.put(Constants.ParseObjectKey_UserRecord_deviceId, Tool.getAndroidUniqueID(ctx));

		updateParseObject_UserRecord(parseObj,fileContent);
				
		return parseObj;
	}
	
	public static void updateParseObject_UserRecord(ParseObject parseObjUserRecord, String fileContent){
		byte[] fileData = Tool.getUtf8Byte(fileContent);
		ParseFile pfile = new ParseFile("UserRecord.txt", fileData);
		parseObjUserRecord.put(Constants.ParseObjectKey_UserRecord_attachFile, pfile);
	}
	
	public static ParseQuery<ParseObject> getParseQueryByCurrentDeviceForUserRecord(Context ctx){
		ParseQuery<ParseObject> query = ParseQuery.getQuery(Constants.ParseObject_UserRecord);
		query.whereEqualTo(Constants.ParseObjectKey_UserRecord_deviceId, Tool.getAndroidUniqueID(ctx));
		return query;
	}
	
	
	public static ParseObject getToSaveParseObject_UserRecordSymptom(Context ctx, int dayLocal,Date updateTimeUTC,HashMap<String, Object> inputNameValuePairsData,String Note, HashMap<String, Object> calculateNameValuePairsData)
	{
		HashMap<String, Object> hmData = StoredConfigTool.getParseObjectInfo_CurrentUserRecordSymptom(ctx);
		String parseObjId = (String)hmData.get(Constants.ParseObjectKey_objectId);
		Integer intObj_dayLocal = (Integer)hmData.get(Constants.COLUMN_NAME_DayLocal);
		
		String parseObjIdValid = null;
		if (parseObjId != null && parseObjId.length()>0 && intObj_dayLocal!=null){
			if (intObj_dayLocal.intValue() == dayLocal){
				parseObjIdValid = parseObjId;//stored value is valid
			}else{
//				StoredConfigTool.saveParseObjectInfo_CurrentUserRecordSymptom(ctx,null);//stored value is old , clear
			}
		}
		
		ParseObject parseObj = null;
		if (parseObjIdValid==null)
			parseObj = new ParseObject(Constants.ParseObject_UserRecordSymptom);
		else
			parseObj = ParseObject.createWithoutData(Constants.ParseObject_UserRecordSymptom, parseObjIdValid);
		
		parseObj.put(Constants.ParseObjectKey_UserRecord_deviceId, Tool.getAndroidUniqueID(ctx));

		parseObj.put(Constants.COLUMN_NAME_DayLocal, Integer.valueOf(dayLocal));
		
		long lUpdateTimeUTC = updateTimeUTC.getTime();
		parseObj.put(Constants.COLUMN_NAME_UpdateTimeUTC, Long.valueOf(lUpdateTimeUTC));
		
		JSONObject jsonObj_inputNameValuePairsData = Tool.HashMapToJsonObject(inputNameValuePairsData);
		String jsonString_inputNameValuePairs = jsonObj_inputNameValuePairsData.toString();
		parseObj.put(Constants.COLUMN_NAME_inputNameValuePairs, jsonString_inputNameValuePairs);
		
		parseObj.put(Constants.COLUMN_NAME_Note, Note);
		
		JSONObject jsonObj_calculateNameValuePairsData = Tool.HashMapToJsonObject(calculateNameValuePairsData);
		String jsonString_calculateNameValuePairs = jsonObj_calculateNameValuePairsData.toString();
		parseObj.put(Constants.COLUMN_NAME_calculateNameValuePairs, jsonString_calculateNameValuePairs);
		
		return parseObj;
	}
	public static ParseQuery<ParseObject> getParseQueryByCurrentDeviceForUserRecordSymptom(Context ctx, int dayLocal){
		ParseQuery<ParseObject> query = ParseQuery.getQuery(Constants.ParseObject_UserRecordSymptom);
		query.whereEqualTo(Constants.ParseObjectKey_UserRecord_deviceId, Tool.getAndroidUniqueID(ctx));
		query.whereEqualTo(Constants.COLUMN_NAME_DayLocal,dayLocal);
		return query;
	}
	
	public static ParseQuery<ParseObject> getParseQueryByCurrentDeviceForUserRecordSymptom(Context ctx){
		ParseQuery<ParseObject> query = ParseQuery.getQuery(Constants.ParseObject_UserRecordSymptom);
		query.whereEqualTo(Constants.ParseObjectKey_UserRecord_deviceId, Tool.getAndroidUniqueID(ctx));
		query.addAscendingOrder(Constants.COLUMN_NAME_DayLocal);
		return query;
	}
	
//	static HashMap<String, Object> parseParseObjectToHashMap_UserRecordSymptom(ParseObject parseObj)
//	{
//		if (parseObj == null)
//			return null;
//		HashMap<String, Object> dataDict = new HashMap<String, Object>();
//	    
//	    String key;
//	    Object val;
//	    key = Constants.COLUMN_NAME_DayLocal;
//	    int dayLocal = parseObj.getInt(key);
//	    dataDict.put(key, dayLocal);
//	    
//	    key = Constants.COLUMN_NAME_UpdateTimeUTC;
//	    long lUpdateTimeUTC = parseObj.getLong(key);
//	    Date UpdateTimeUTC = new Date(lUpdateTimeUTC);
//	    dataDict.put(key, UpdateTimeUTC);
//	    
//	    key = Constants.COLUMN_NAME_Note;
//	    val = parseObj.getString(key);
//	    if (val != null){
//	    	dataDict.put(key, val);
//	    }
//	    
//	    key = Constants.COLUMN_NAME_inputNameValuePairs;
//	    String jsonString = parseObj.getString(key);
//	    if (jsonString != null){
//	        JSONObject jsonObj = null;
//	        try {
//				jsonObj = new JSONObject(jsonString);
//				HashMap<String, Object> hmObj = Tool.JsonToHashMap(jsonObj);
//				dataDict.put(key, hmObj);
//			} catch (JSONException e) {
//				Log.e(LogTag, "new JSONObject(inputNameValuePairsString) err:"+e.getMessage(),e);
//			}
//	    }
//	    
//	    key = Constants.COLUMN_NAME_calculateNameValuePairs;
//	    jsonString = parseObj.getString(key);
//	    if (jsonString != null){
//	        JSONObject jsonObj = null;
//	        try {
//				jsonObj = new JSONObject(jsonString);
//				HashMap<String, Object> hmObj = Tool.JsonToHashMap(jsonObj);
//				dataDict.put(key, hmObj);
//			} catch (JSONException e) {
//				Log.e(LogTag, "new JSONObject(calculateNameValuePairsString) err:"+e.getMessage(),e);
//			}
//	    }
//	    	    
//	    return dataDict;
//	}
	
	static HashMap<String, Object> parseParseObjectToHashMapRawRow_UserRecordSymptom(ParseObject parseObj)
	{
		if (parseObj == null)
			return null;
		HashMap<String, Object> dataDict = new HashMap<String, Object>();
	    
	    String key;
	    Object val;
	    key = Constants.COLUMN_NAME_DayLocal;
	    int dayLocal = parseObj.getInt(key);
	    dataDict.put(key, dayLocal);
	    
	    key = Constants.COLUMN_NAME_UpdateTimeUTC;
	    long lUpdateTimeUTC = parseObj.getLong(key);
	    Date UpdateTimeUTC = new Date(lUpdateTimeUTC);
	    dataDict.put(key, UpdateTimeUTC);
	    
	    key = Constants.COLUMN_NAME_Note;
	    val = parseObj.getString(key);
	    if (val != null){
	    	dataDict.put(key, val);
	    }
	    
	    key = Constants.COLUMN_NAME_inputNameValuePairs;
	    val = parseObj.getString(key);
	    if (val != null){
	    	dataDict.put(key, val);
	    }
	    
	    key = Constants.COLUMN_NAME_calculateNameValuePairs;
	    val = parseObj.getString(key);
	    if (val != null){
	    	dataDict.put(key, val);
	    }
	    	    
	    return dataDict;
	}
	
	
	
	public static void syncRemoteDataToLocal(Context ctx,JustCallback justCallback){
		final Context cCtx = ctx;
		final JustCallback c_myCbFun = justCallback;
		if (StoredConfigTool.getFlagAlreadyLoadFromRemote(cCtx)){
			if (c_myCbFun!=null)
				c_myCbFun.cbFun(true);
			return;
		}
		
		ParseQuery<ParseObject> queryRemote = getParseQueryByCurrentDeviceForUserRecordSymptom(ctx);
		
		queryRemote.findInBackground(new FindCallback<ParseObject>() {
			@Override
			public void done(List<ParseObject> parseObjs, ParseException e) {
				String msg=null;
				boolean succeeded = (e == null);
				if (succeeded) {
					if (parseObjs == null || parseObjs.size()==0){
						msg = "No data in remote.";
					}else{
						msg = "rows "+parseObjs.size()+" in remote.";
						DataAccess da = DataAccess.getSingleton(cCtx);
						for(int i=0; i<parseObjs.size(); i++){
							ParseObject parseObj = parseObjs.get(i);//有可能dayLocal有重复的，这里暂且不管
							HashMap<String, Object> hmRawRow = parseParseObjectToHashMapRawRow_UserRecordSymptom(parseObj);
							da.insertUserRecordSymptom_withRawData(hmRawRow);
							if(i==parseObjs.size()-1){
								Integer dayLocalObj = (Integer)hmRawRow.get(Constants.COLUMN_NAME_DayLocal);
								StoredConfigTool.saveParseObjectInfo_CurrentUserRecordSymptom(cCtx, parseObj.getObjectId(), dayLocalObj.intValue());
							}
						}//for
					}
					StoredConfigTool.setFlagAlreadyLoadFromRemote(cCtx);
					
				} else {
					msg = "Error: "+ e.getMessage();
				}
				Log.d(LogTag, "getParseRowObj msg:"+msg);
				
				if (c_myCbFun!=null)
					c_myCbFun.cbFun(succeeded);
			}//done
		});//findInBackground
	}
	
	
}















