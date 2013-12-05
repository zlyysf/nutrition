package com.lingzhimobile.nutritionfoodguide;


import java.nio.charset.Charset;

import android.content.Context;


import com.parse.ParseFile;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseUser;

public class ToolParse {
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
}
