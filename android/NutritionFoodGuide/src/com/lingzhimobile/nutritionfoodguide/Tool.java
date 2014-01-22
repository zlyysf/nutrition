package com.lingzhimobile.nutritionfoodguide;

import java.io.*;
import java.lang.reflect.Array;
import java.nio.charset.Charset;
import java.util.*;
import java.util.zip.*;

import org.apache.commons.lang3.StringUtils;
import org.json.*;




import android.R.bool;
import android.app.Activity;
import android.app.ActivityManager;
import android.app.AlertDialog;
import android.app.ActivityManager.RunningTaskInfo;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.res.AssetManager;
import android.content.res.Resources;
import android.database.*;
import android.graphics.*;
import android.graphics.drawable.*;
import android.graphics.drawable.shapes.*;
import android.os.DropBoxManager.Entry;
import android.provider.Settings.Secure;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.view.*;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.*;
import android.widget.LinearLayout.*;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.TextView;

public class Tool {
	static final String LogTag = "Tool";
	
	public interface JustCallback{
		void cbFun(boolean succeeded);
	}
	
	public static int copyRawFileToSDCardFile(Context mCtx, int rawFileResId, String sdCardFilePath)
	{
		int mDBRawResource = rawFileResId;
		String dbPathString = sdCardFilePath;
        int len = 1024*8;//
        int readCount = 0, readSum = 0;
        byte[] buffer = new byte[len];        
        InputStream inputStream = null;
        OutputStream output = null;
        try {
            inputStream = mCtx.getResources().openRawResource(mDBRawResource); 
            output = new FileOutputStream(dbPathString);
            BufferedInputStream bufInputStream = new BufferedInputStream(inputStream);
            while ((readCount = bufInputStream.read(buffer)) != -1) {
                output.write(buffer,0,readCount);
                readSum = readSum + readCount;
            }
            output.flush();
            output.close();
            output = null;
            inputStream.close();
            inputStream = null;
        } catch (IOException e) {
            Log.e(LogTag, "copyRawFileToSDCardFile", e);
            throw new RuntimeException(e);
        } finally{
        	if (output != null){
        		try {
					output.close();
				} catch (IOException e) {
					Log.e(LogTag, "finally", e);
				}
        	}
				
        	if (inputStream != null){
        		try {
					inputStream.close();
				} catch (IOException e) {
					Log.e(LogTag, "finally", e);
				}
        	}
        		
        }
        return readSum;
	}
	
	public static int unzipRawFileToSDCardFile(Context mCtx, int rawFileResId, String sdCardFilePath)
	{
		int mDBRawResource = rawFileResId;
		String dbPathString = sdCardFilePath;
		int StreamLen = -1;

        int len = 1024*4;//

        int readCount = 0, readSum = 0;

        byte[] buffer = new byte[len];        
        InputStream inputStream = null;
        OutputStream output = null;
        try {
            inputStream = mCtx.getResources().openRawResource(mDBRawResource); 
            output = new FileOutputStream(dbPathString);

            ZipInputStream zipInputStream = new ZipInputStream(new BufferedInputStream(inputStream));
            ZipEntry zipEntry = zipInputStream.getNextEntry();
            BufferedInputStream b = new BufferedInputStream(zipInputStream);

            StreamLen = (int) zipEntry.getSize();

            while ((readCount = b.read(buffer)) != -1) {
                output.write(buffer,0,readCount);
                readSum = readSum + readCount;
            }
            output.flush();
            output.close();
            output = null;
            inputStream.close();
            inputStream = null;
        } catch (IOException e) {
            Log.e(LogTag, "unzipRawFileToSDCardFile", e);
            throw new RuntimeException(e);
        } finally{
        	if (output != null){
        		try {
					output.close();
				} catch (IOException e) {
					Log.e(LogTag, "finally", e);
				}
        	}
				
        	if (inputStream != null){
        		try {
					inputStream.close();
				} catch (IOException e) {
					Log.e(LogTag, "finally", e);
				}
        	}
        		
        }

        return StreamLen;
	}
	

	public static String getStringFromIdWithParams(Resources resources1,int resId, Object... params) {
        return resources1.getString(resId, params);
    }
	public static String getStringFromIdWithParams(Context ctx,int resId, Object... params) {
		return getStringFromIdWithParams(ctx.getResources(),resId,params);
    }
	
	static String getFoodPicPath(String foodPicName){
		//String foodPicPath = "foodpic" + File.pathSeparator + foodPicName;//FileNotFoundException: foodpic:10110_Zhugan.jpg//for linked folder of eclipse
//		String foodPicPath = "foodpic" + File.separator + foodPicName;//FileNotFoundException: foodpic/11240_Yangdujun.jpg//for linked folder of eclipse
//		String foodPicPath = "FoodPicPath" + File.separator + foodPicName;//FileNotFoundException: FoodPicPath/12096_Banli.jpg//for linked folder of eclipse
		String foodPicPath = "lnfoodpic" + File.separator + foodPicName;//OK , for system linked folder

		return foodPicPath;
	}
	public static Drawable getDrawableForFoodPic(Context ctx,String foodPicName){
		return getDrawableForFoodPic(ctx.getAssets(),foodPicName);
	}
	public static Drawable getDrawableForFoodPic(AssetManager assetMg,String foodPicName){
		InputStream istream = null;
		try {
			istream=assetMg.open(getFoodPicPath(foodPicName));
			Drawable da = Drawable.createFromStream(istream, null);
			return da;
		} catch (IOException e) {
			Log.e(LogTag, "getDrawableForFoodPic, Fail to open food pic in assets",e);
			throw new RuntimeException(e);
		}finally{
			if (istream != null){
				try {
					istream.close();
				} catch (IOException e) {
					Log.e(LogTag, "getDrawableForFoodPic, Fail to close food pic stream in assets",e);
				}
			}
		}
	}
	
	public static void travalAssets(AssetManager assetMg, String parDirOrFilePath){
		String[] dirOrFileNameAry = null;
	    try {
	    	dirOrFileNameAry = assetMg.list(parDirOrFilePath);
	    } catch (IOException e) {
	        Log.e(LogTag,"travalAssets", e);
	        throw new RuntimeException(e);
	    }
	    if (dirOrFileNameAry!=null && dirOrFileNameAry.length>0){
	    	for(int i=0; i<dirOrFileNameAry.length; i++){
	    		String dirOrFileName = dirOrFileNameAry[i];
	    		String path;
	    		if (parDirOrFilePath == null || parDirOrFilePath.length()==0){
	    			path = dirOrFileName;
	    		}else {
	    			path = parDirOrFilePath + File.separator + dirOrFileName;
				}
	    		Log.d(LogTag, "travalAssets: "+path);
	    		travalAssets(assetMg,path);
	    	}
	    }
	}
	
	public static Bitmap getBitmapForFoodPic(AssetManager assetMg,String foodPicName){
		InputStream istream = null;
		try {
			istream=assetMg.open(getFoodPicPath(foodPicName));
			Bitmap bmp= BitmapFactory.decodeStream(istream);
			return bmp;
		} catch (IOException e) {
			Log.e(LogTag, "getBitmapForFoodPic, Fail to open food pic in assets",e);
			throw new RuntimeException(e);
		}finally{
			if (istream != null){
				try {
					istream.close();
				} catch (IOException e) {
					Log.e(LogTag, "getBitmapForFoodPic, Fail to close food pic stream in assets",e);
				}
			}
		}
	}
	
	
	
	/*
	 * 注意还不能直接得到Object，而只能取到具体类型，从而这里使用Sting
	 */
	public static ArrayList<String> getDataFromCursor(Cursor cs,int colIdx){
		ArrayList<String> al = new ArrayList<String>();
		cs.moveToFirst();
		while(!cs.isAfterLast()){
			al.add(cs.getString(colIdx));
			cs.moveToNext();
		}
		return al;
	}
	
	public static HashMap<String, String> get1RowDataFromCursorCurrentPosition(Cursor cs){
		String[] colNames = cs.getColumnNames();
		HashMap<String, String> hmRow = new HashMap<String, String>();
		for(int i=0; i<colNames.length; i++){
			String colName = colNames[i];
			int colIdx = cs.getColumnIndex(colName);
			String colValStr = cs.getString(colIdx);
			hmRow.put(colName, colValStr);
		}
		return hmRow;
	}
	public static ArrayList<HashMap<String, String>> getRowsFromCursor(Cursor cs){
		ArrayList<HashMap<String, String>> alRows = new ArrayList<HashMap<String, String>>();
		cs.moveToFirst();
		while(!cs.isAfterLast()){
			HashMap<String, String> hmRow = get1RowDataFromCursorCurrentPosition(cs);
			alRows.add(hmRow);
			cs.moveToNext();
		}
		return alRows;
	}
	/*
	 * 只分string和double类型。特殊处理NDB_No列的类型为string。
	 */
	public static HashMap<String, Object> get1RowDataWithTypeFromCursorCurrentPosition(Cursor cs){
		if (cs.isBeforeFirst() || cs.isAfterLast() || cs.isClosed())
			return null;
		
		String[] colNames = cs.getColumnNames();
		HashMap<String, Object> hmRow = new HashMap<String, Object>();
		for(int i=0; i<colNames.length; i++){
			String colName = colNames[i];
			int colIdx = cs.getColumnIndex(colName);
			String colValStr = cs.getString(colIdx);
			boolean knownBeString = false;
			if (Tool.getVersionOfAndroidSDK() >= 11){
				knownBeString = (Cursor.FIELD_TYPE_STRING == cs.getType(colIdx));
			}
			if ( knownBeString ){
				hmRow.put(colName, colValStr);
			}else{
				if (Constants.COLUMN_NAME_NDB_No.equalsIgnoreCase(colName) || Constants.COLUMN_NAME_FoodId.equalsIgnoreCase(colName)){
					hmRow.put(colName, colValStr);
				}else if (colValStr==null){
					hmRow.put(colName, colValStr);
				}else{
					Object colValObj = null;
					try{
						double d_colVal = Double.parseDouble(colValStr);
						if (!Double.isNaN(d_colVal)){
							colValObj = Double.valueOf(d_colVal);
						}else{
							colValObj = colValStr;
						}
					}catch (NumberFormatException e) {
						colValObj = colValStr;
					}
					
					hmRow.put(colName, colValObj);
				}
			}
		}
		return hmRow;
	}
	public static ArrayList<HashMap<String, Object>> getRowsWithTypeFromCursor(Cursor cs){
		ArrayList<HashMap<String, Object>> alRows = new ArrayList<HashMap<String, Object>>();
		cs.moveToFirst();
		while(!cs.isAfterLast()){
			HashMap<String, Object> hmRow = get1RowDataWithTypeFromCursorCurrentPosition(cs);
			alRows.add(hmRow);
			cs.moveToNext();
		}
		return alRows;
	}
	
	public static HashMap<String, Double> get1RowDataWithDoubleTypeFromCursorCurrentPosition(Cursor cs){
		String[] colNames = cs.getColumnNames();
		HashMap<String, Double> hmRow = new HashMap<String, Double>();
		for(int i=0; i<colNames.length; i++){
			String colName = colNames[i];
			int colIdx = cs.getColumnIndex(colName);
			try{
				double d_colVal = cs.getDouble(colIdx);
				hmRow.put(colName, Double.valueOf(d_colVal));
			}catch (RuntimeException e) {
				Log.e(LogTag, "get1RowDataWithDoubleTypeFromCursorCurrentPosition meet non-double value", e);
				throw e;
			}
		}
		return hmRow;
	}
	public static ArrayList<HashMap<String, Double>> getRowsWithDoubleTypeFromCursor(Cursor cs){
		ArrayList<HashMap<String, Double>> alRows = new ArrayList<HashMap<String, Double>>();
		cs.moveToFirst();
		while(!cs.isAfterLast()){
			HashMap<String, Double> hmRow = get1RowDataWithDoubleTypeFromCursorCurrentPosition(cs);
			alRows.add(hmRow);
			cs.moveToNext();
		}
		return alRows;
	}
	
	
	
	
	
	public static Double addDoubleToDictionaryItem(double valAdd, HashMap<String, Double> data, String datakey)
	{
	    assert(data!=null);
	    assert(datakey!=null);
	    Double dObjDataVal = data.get(datakey); 
	    double sum = 0 ;
	    if (dObjDataVal!=null){
	        sum = dObjDataVal.doubleValue()+valAdd;
	    }else{
	        sum = valAdd;
	    }
	    Double dObjSum = Double.valueOf(sum);
	    data.put(datakey, dObjSum);
	    return dObjSum;
	}
	public static void addDoubleDictionaryToDictionary_withSrcAmountDictionary(HashMap<String, Double> srcAmountDict,HashMap<String, Double> destAmountDict)
	{
	    if (srcAmountDict == null || srcAmountDict.size()==0)
	        return;
	    if (destAmountDict == null)
	        return;
	    Iterator<Map.Entry<String,Double>> iter = srcAmountDict.entrySet().iterator();
	  	while (iter.hasNext()) {
	  		Map.Entry<String,Double> entry = iter.next();
	  		String key = entry.getKey();
	  		Double nmVal = entry.getValue();
	  		addDoubleToDictionaryItem(nmVal.doubleValue(),destAmountDict,key);
	  	}
	  
//	    NSArray * keys = srcAmountDict.allKeys;
//	    for(int i=0; i<keys.count; i++){
//	        NSString *key = keys[i];
//	        NSNumber *nmVal = srcAmountDict[key];
//	        [self.class addDoubleToDictionaryItem:[nmVal doubleValue] withDictionary:destAmountDict andKey:key];
//	    }
	}

	public static double getDoubleFromDictionaryItem_withDictionary(HashMap<String, Double> data,String datakey)
	{
	    assert(data!=null);
	    assert(datakey!=null);
	    Double dataVal = data.get(datakey);
	    if (dataVal==null)
	        return 0;
	    else{
	        
	        return dataVal.doubleValue();
	    }
	}
	public static int getIntFromDictionaryItem_withDictionary(HashMap<String, Integer> data,String datakey)
	{
	    assert(data!=null);
	    assert(datakey!=null);
	    Integer dataVal = data.get(datakey);
	    if (dataVal==null)
	        return 0;
	    else{
	        
	        return dataVal.intValue();
	    }
	}
	
	

//	public static void addItemToListHash(Object item, String key, HashMap<String,Object> lstHm){
//		assert(lstHm != null);
//		Object val = lstHm.get(key);
//		List<Object> lst = (List<Object>)val;
//		if (lst == null){
//			lst = new ArrayList<Object>();
//			lstHm.put(key, lst);
//		}
//		lst.add(item);
//	}
	public static <T> void addItemToListHash(T item, String key, HashMap<String,ArrayList<T>> lstHm){
		assert(lstHm != null);
		ArrayList<T> val = lstHm.get(key);
		ArrayList<T> lst = val;
		if (lst == null){
			lst = new ArrayList<T>();
			lstHm.put(key, lst);
		}
		lst.add(item);
	}
	
	public static Object[] getPropertyArrayFromDictionaryArray_withPropertyName(String propertyName, ArrayList<HashMap<String, Object>> dicAry)
	{
		if (dicAry == null || dicAry.size()==0)
			return null;
		
		Object[] propAry = new Object[dicAry.size()];
	    for(int i=0; i<dicAry.size(); i++){
	    	HashMap<String, Object> dic = dicAry.get(i);
	    	Object val = dic.get(propertyName);
	    	propAry[i] = val;
	    }
	    return propAry;
	}
	public static ArrayList<Object> getPropertyArrayListFromDictionaryArray_withPropertyName(String propertyName, ArrayList<HashMap<String, Object>> dicAry)
	{
		if (dicAry == null || dicAry.size()==0)
			return null;
		
		Object[] propAry = getPropertyArrayFromDictionaryArray_withPropertyName(propertyName,dicAry);
	    ArrayList<Object> alProp = convertFromArrayToList(propAry);
	    return alProp;
	}
	
	public static HashMap<String, HashMap<String, Object>> dictionaryArrayTo2LevelDictionary_withKeyName(String keyName, ArrayList<HashMap<String, Object>> dicArray)
	{
	    if (dicArray == null)
	        return null;
	    HashMap<String, HashMap<String, Object>> dic2Level = new HashMap<String, HashMap<String, Object>>();
	    for(int i=0; i<dicArray.size(); i++){
	    	HashMap<String, Object> dic = dicArray.get(i);
	        String keyVal = (String)dic.get(keyName);
	        assert(keyVal!=null);
	        dic2Level.put(keyVal, dic);
	    }
	    return dic2Level;
	}
	public static ArrayList<HashMap<String, Object>> getdictionaryArrayFrom2LevelDictionary(ArrayList<String> itemIds, HashMap<String, HashMap<String, Object>> dict2Level)
	{
		if (itemIds==null || dict2Level==null)
			return null;
		ArrayList<HashMap<String, Object>> dictAry = new ArrayList<HashMap<String,Object>>();
		for(int i=0; i<itemIds.size(); i++){
			String itemId = itemIds.get(i);
			dictAry.add(dict2Level.get(itemId));
		}
		return dictAry;
	}
	public static HashMap<Object, Object[]> array2DtoArrayHashMap_withKeyIndex(int keyIndex, Object[][] array2D)
	{
	    if (array2D == null)
	        return null;
	    HashMap<Object, Object[]> aryHm = new HashMap<Object, Object[]>();
	    for(int i=0; i<array2D.length; i++){
	    	Object[] ary1D = array2D[i];
	    	Object keyVal = ary1D[keyIndex];
	    	aryHm.put(keyVal, ary1D);
	    }
	    return aryHm;
	}
	
	public static HashMap<String,ArrayList<HashMap<String, Object>>> groupBy(String propertyNameToGroup, ArrayList<HashMap<String, Object>> dataCol){
		if (dataCol == null)
			return null;
		HashMap<String,ArrayList<HashMap<String, Object>>> dataColGroupedHm = new HashMap<String, ArrayList<HashMap<String,Object>>>();
		for(int i=0; i<dataCol.size(); i++){
			HashMap<String, Object> dataItem = dataCol.get(i);
			String propVal = (String)dataItem.get(propertyNameToGroup);
			Tool.addItemToListHash(dataItem, propVal, dataColGroupedHm);
		}
		return dataColGroupedHm;
	}
	
//	public static ArrayList<String> getKeysFromHashMap(HashMap<String, Object> hm){
//		if (hm==null)
//			return null;
//		ArrayList<String> keys = new ArrayList<String>();
//		Iterator<Map.Entry<String, Object>> iter = hm.entrySet().iterator();
//		while (iter.hasNext()) {
//			Map.Entry<String, Object> entry = iter.next();
//    		String key = entry.getKey();
//    		keys.add(key);
//		}
//		return keys;
//	}
	public static ArrayList<String> getKeysFromHashMap(HashMap hm){
		if (hm==null)
			return null;
		ArrayList<String> keys = new ArrayList<String>();
		Iterator iter = hm.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry)iter.next();
    		String key = (String)entry.getKey();
    		keys.add(key);
		}
		return keys;
	}
	
	public static Long convertToLong(Object item){
		if (item == null)
			return null;
		Long lObj = null;
		
		if (item instanceof Long){
			lObj = (Long)item;
		}else if (item instanceof Double){
			Double dblObj = (Double)item;
			long lVal = dblObj.longValue();
			lObj = Long.valueOf(lVal);
		}else{
			String sVal = item.toString();
			long lVal = Long.parseLong(sVal);
			lObj = Long.valueOf(lVal);
		}
		return lObj;
	}
	public static Integer convertToInteger(Object item){
		if (item == null)
			return null;
		Integer iObj = null;
		
		if (item instanceof Integer){
			iObj = (Integer)item;
		}else if (item instanceof Long){
			Long lObj = (Long)item;
			int iVal = lObj.intValue();
			iObj = Integer.valueOf(iVal);
		}else if (item instanceof Double){
			Double dblObj = (Double)item;
			int iVal = dblObj.intValue();
			iObj = Integer.valueOf(iVal);
		}else{
			String sVal = item.toString();
			int iVal = Integer.parseInt(sVal);
			iObj = Integer.valueOf(iVal);
		}
		return iObj;
	}
	public static ArrayList<Integer> convertFromArrayList(ArrayList<Object> numberAL){
		if (numberAL == null)
			return null;
		
	    ArrayList<Integer> intAL = new ArrayList<Integer>();
	    for(int i=0; i<numberAL.size(); i++){
	    	Object item = numberAL.get(i);
	    	Integer iObj = convertToInteger(item);
	    	intAL.add(iObj); 
	    }
	    
	    return intAL;
	}
	
	
	public static HashSet<String> convertToStringHashSet(String[] ary){
		HashSet<String> hs = new HashSet<String>();
		hs.addAll(Tool.convertFromArrayToList(ary));
		return hs;
	}
	
	
	public static String[] convertToStringArray(Object[] objs){
		if (objs == null)
			return null;
		String[] strAry = new String[objs.length];
		for(int i=0; i<objs.length; i++){
			Object obj = objs[i];
			if (obj instanceof String){
				strAry[i] = (String)obj;
			}else if (obj == null) {
				strAry[i] = (String)obj;
			}else{
				strAry[i] = obj.toString();
			}
			
		}
		return strAry;
	}
	
	public static String[] convertToStringArray(ArrayList<String> al){
		if (al == null)
			return null;
		return al.toArray(new String[al.size()]);
	}
	
	public static ArrayList<Object> convertFromArrayToList(Object[] ary){
		if (ary==null)
			return null;
		ArrayList<Object> al = new ArrayList<Object>();
		for(int i=0; i<ary.length; i++){
			Object item = ary[i];
			al.add(item);
		}
		return al;
	}
	public static ArrayList<String> convertFromArrayToList(String[] ary){
		if (ary==null)
			return null;
		ArrayList<String> al = new ArrayList<String>();
		for(int i=0; i<ary.length; i++){
			String item = ary[i];
			al.add(item);
		}
		return al;
	}
	
	public static ArrayList<String> convertToStringArrayList(ArrayList<Object> alObj){
		if (alObj == null)
			return null;
		ArrayList<String> alStr = new ArrayList<String>(alObj.size());
		for(int i=0; i<alObj.size(); i++){
			Object obj = alObj.get(i);
			if (obj instanceof String){
				alStr.add( (String)obj );
			}else if (obj == null) {
				alStr.add( (String)obj );
			}else{
				alStr.add( obj.toString() );
			}
			
		}
		return alStr;
	}

	public static void listAppendArray(ArrayList<String> lst,String[] ary){
		if(ary==null)
			return ;
		for(int i=0; i<ary.length; i++){
			lst.add(ary[i]);
		}
	}

	public static <T> ArrayList<T> getSubList(ArrayList<T> lst, int from, int len){
		if (lst==null || lst.size()==0)
			return lst;
		if (from >= lst.size())
			return null;
		int remainLen = lst.size() - from;
	    int minLen = remainLen > len? len : remainLen;
	    ArrayList<T> subLst = new ArrayList<T>(minLen);
	    
	    for(int i=0; i<minLen; i++){
	        T item = lst.get(from+i);
	        subLst.add(item);
	    }
	    return subLst;
	}
	
	
	/*
	 * 假定数组自身所含元素都不同
	 */
	public static ArrayList<String> arrayAddArrayInSetWay_withArray1(String[] ary1,String[] ary2){
		if (ary1 == null && ary2 == null){
			return null;
		}else if (ary1 != null && ary2 == null){
			return convertFromArrayToList(ary1);
		}else if (ary1 == null && ary2 != null){
			return convertFromArrayToList(ary2);
		}else{
			ArrayList<String> ary = convertFromArrayToList(ary1);
			HashSet<String> set1 = new HashSet<String>();
			set1.addAll(ary);
		    for(int i=0 ; i<ary2.length; i++){
		        String s1 = ary2[i];
		        if (!set1.contains(s1)){
		        	ary.add(s1);
//		        	set1.add(s1);
		        }
		    }
		    return ary;
		}
	}
	
	public static String[] arrayIntersectSet_withArray(String[] ary,HashSet<String> set)
	{
	    if (ary==null || ary.length == 0)
	        return ary;
	    if (set == null || set.size() == 0)
	        return null;
	    ArrayList<String> retLst = new ArrayList<String>();
	    for(int i=0; i<ary.length; i++){
	        String item = ary[i];
	        if (set.contains(item)){
	        	retLst.add(item);
	        }
	    }
	    return retLst.toArray(new String[retLst.size()]);
	}
	public static String[] arrayIntersectArray_withSrcArray(String[] srcAry,String[] intersectAry)
	{
	    if (intersectAry == null || intersectAry.length == 0)
	        return intersectAry;
	    if (srcAry == null || srcAry.length == 0)
	        return srcAry;
	    return arrayIntersectSet_withArray(srcAry ,convertToStringHashSet(intersectAry));
	}
	
	public static String[] arrayMinusSet_withArray(String[] srcAry,HashSet<String> minusSet)
	{
	    if (srcAry == null || srcAry.length == 0 || minusSet == null || minusSet.size() == 0)
	        return srcAry;
	    ArrayList<String> toBeMinusLst = Tool.convertFromArrayToList(srcAry);
	    for(int i=srcAry.length-1; i>=0; i--){
	        String item = toBeMinusLst.get(i);
	        if (minusSet.contains(item)){
	        	toBeMinusLst.remove(i);
	        }
	    }
	    return Tool.convertToStringArray(toBeMinusLst);
	}
	public static String[] arrayMinusArray_withSrcArray(String[] srcAry,String[] minusAry)
	{
	    if (srcAry == null || srcAry.length == 0 || minusAry == null || minusAry.length == 0)
	        return srcAry;
	    return arrayMinusSet_withArray(srcAry,Tool.convertToStringHashSet(minusAry));
	}
	public static String[] arrayMinusArray_withSrcArray(String[] srcAry,ArrayList<String> minusAry)
	{
	    if (srcAry == null || srcAry.length == 0 || minusAry == null || minusAry.size() == 0)
	        return srcAry;
	    HashSet<String> minusHs = new HashSet<String>();
	    minusHs.addAll(minusAry);
	    return arrayMinusSet_withArray(srcAry,minusHs);
	}
	
	public static boolean arrayContainArrayInSetWay_withOuterArray(String[] outerAry, String[] innerAry)
	{
	    if (innerAry == null || innerAry.length == 0)
	        return true;
	    //below innerAry.length > 0
	    if (outerAry == null || outerAry.length == 0)
	        return false;
	    //below outerAry.length > 0
	    HashSet<String> outerSet = convertToStringHashSet(outerAry);
	    HashSet<String> innerSet = convertToStringHashSet(innerAry);
	    boolean ret = outerSet.containsAll(innerSet);
	    return ret;
	}
	public static boolean arrayEqualArrayInSetWay_withArray1(String[] ary1, String[] ary2)
	{
		if (ary1==null || ary2==null){
			if (ary1==null && ary2==null){
				return true;
			}else if (ary1==null && ary2!=null){
				if(ary2.length==0)
					return true;
				else 
					return false;
			}else if (ary1!=null && ary2==null){
				if(ary1.length==0)
					return true;
				else 
					return false;
			}
		}
		//ary1!=null && ary2!=null
		HashSet<String> set1 = convertToStringHashSet(ary1);
	    HashSet<String> set2 = convertToStringHashSet(ary2);
	    boolean ret = set1.containsAll(set2) && set2.containsAll(set1);
	    return ret;
	}
	
	public static boolean[] generateContainFlags(String[] srcItems,String[] containingItems){
		if (srcItems == null)
			return null;
		boolean[] containFlags = Tool.generateArrayWithFillItem(false, srcItems.length);
		if (containingItems == null)
			return containFlags;
		HashSet<String> containingSet = new HashSet<String>();
		containingSet.addAll(Tool.convertFromArrayToList(containingItems));
		for(int i=0; i<srcItems.length; i++){
			String srcItem = srcItems[i];
			containFlags[i] = containingSet.contains(srcItem);
		}
		return containFlags;
	}
	
	public static HashMap<String, Double> generateDictionaryWithFillItem(Double fillItem,String[] keys)
	{
	    assert(fillItem!=null);
	    HashMap<String, Double> dict = new HashMap<String, Double>();
	    if (keys!=null){
	    	for(int i=0; i<keys.length; i++){
		        String key = keys[i];
		        dict.put(key, fillItem);
		    }
	    }
	    return dict;
	}
	public static String[] generateArrayWithFillItem(String fillItem, int length)
	{
		String[] ary = new String[length];
	    for(int i=0; i<length; i++){
	    	ary[i] = fillItem;
	    }
	    return ary;
	}
	public static boolean[] generateArrayWithFillItem(boolean fillItem, int length)
	{
		boolean[] ary = new boolean[length];
	    for(int i=0; i<length; i++){
	    	ary[i] = fillItem;
	    }
	    return ary;
	}
	
	

	

	
	
	
	static boolean isSimpleObjectForObject(Object obj){
		if (obj != null){
			if(obj.getClass().isArray() || obj instanceof List || obj instanceof HashMap){
				return false;
			}
		}
		return true;
	}
	static boolean containAllSimpleObject(Object[] ary){
		boolean isAllElementSimpleObject = true;
		if (ary != null && ary.length>0){
			for(int i=0; i<ary.length; i++){
				Object obj = ary[i];
				if (! isSimpleObjectForObject(obj)){
					isAllElementSimpleObject = false;
					break;
				}
			}
		}
		return isAllElementSimpleObject;
	}
	static boolean containAllSimpleObject(List lst){
		boolean isAllElementSimpleObject = true;
		if (lst != null && lst.size()>0){
			for(int i=0; i<lst.size(); i++){
				Object obj = lst.get(i);
				if (! isSimpleObjectForObject(obj)){
					isAllElementSimpleObject = false;
					break;
				}
			}
		}
		return isAllElementSimpleObject;
	}
	/*
	 * 只检查value
	 */
	static boolean containAllSimpleObject(HashMap hm){
		boolean isAllElementSimpleObject = true;
		if (hm != null && hm.size()>0){
			Iterator iter = hm.entrySet().iterator();
			while (iter.hasNext()) {
				Map.Entry entry = (Map.Entry) iter.next();
				Object key = entry.getKey();
				Object val = entry.getValue();
				if (! isSimpleObjectForObject(val)){
					isAllElementSimpleObject = false;
					break;
				}	
			}
		}
		return isAllElementSimpleObject;
	}
	
	public static String getIndentFormatStringOfObject(Object obj,int level){
		StringBuffer sb1 = new StringBuffer();
		String strIndent = "";
		if (level > 0){
			String[] indentItemAry = generateArrayWithFillItem("\t",level);
			strIndent = StringUtils.join(indentItemAry,"");
		}else{
//			strIndent = "\n";
		}
		if (obj == null){
			sb1.append("\n"+strIndent);
			sb1.append("<<null>>");
		}else if(obj.getClass().isArray() || obj instanceof List){
			if (obj instanceof Array){
				Object[] ary = (Object[])obj;
				if (containAllSimpleObject(ary)){
					sb1.append(strIndent+ary.toString());
				}else{
					sb1.append("\n"+strIndent+"[");
					for(int i=0; i<ary.length; i++){
						Object o2 = ary[i];
						String s2 = getIndentFormatStringOfObject(o2,level+1);
						sb1.append(s2);
						sb1.append(" ,");
					}
					sb1.append("\n"+strIndent+"]");
				}
			}else{
				List lst = (List)obj;
				if (containAllSimpleObject(lst)){
					sb1.append(strIndent+lst.toString());
				}else{
					sb1.append("\n"+strIndent+"(");
					for(int i=0; i<lst.size(); i++){
						Object o2 = lst.get(i);
						String s2 = getIndentFormatStringOfObject(o2,level+1);
						sb1.append(s2);
						sb1.append(" ,");
					}
					sb1.append("\n"+strIndent+")");
				}
			}
		}else if(obj instanceof HashMap){
			sb1.append("\n"+strIndent+"{");
			HashMap hm = (HashMap)obj;
			Iterator iter = hm.entrySet().iterator();
			while (iter.hasNext()) {
				Map.Entry entry = (Map.Entry) iter.next();
				Object key = entry.getKey();
				Object val = entry.getValue();
				sb1.append("\n\t"+strIndent+key.toString()+"=");
				if(val == null){
					sb1.append("<NULL>");
				}else if (isSimpleObjectForObject(val)){
					sb1.append(val.toString());
				}else{
					String s2 = getIndentFormatStringOfObject(val,level+2);
					sb1.append(s2);
				}
				
				sb1.append(" ;");
			}
			sb1.append("\n"+strIndent+"}");
			
		}else{
			sb1.append("\n"+strIndent);
			sb1.append(obj.toString());
		}
		return sb1.toString();
	}
	

	static long m_randSeed = 0;
	static Random m_randObj = null;
	public static Random getRandObj(){
		if (m_randObj == null){
			m_randObj = new Random();
			m_randSeed = 0;
		}
		return m_randObj;
	}
	public static Random getRandObj(long setSeed){
		if (m_randObj == null){
			m_randObj = new Random(setSeed);
		}else if(m_randSeed != setSeed){
			m_randObj = new Random(setSeed);
			m_randSeed = setSeed;
		}
		
		return m_randObj;
	}
	
	
	
	public static void ShowMessageByDialog(Context ctx,String message){
		new AlertDialog.Builder(ctx).setMessage(message).create().show();
	}
	public static void ShowMessageByDialog(Context ctx,int messageId){
		new AlertDialog.Builder(ctx).setMessage(messageId).create().show();
	}
	
	
	public static void printActivityStack(Context ctx){
		//SecurityException: Permission Denial: getTasks() from pid=19086, uid=10092 requires android.permission.GET_TASKS
		
		ActivityManager manager = (ActivityManager) ctx.getSystemService(Context.ACTIVITY_SERVICE);
		List<RunningTaskInfo> runningTaskInfos = manager.getRunningTasks(100);
		for(int i=0; i<runningTaskInfos.size(); i++){
			RunningTaskInfo RunningTaskInfo1 = runningTaskInfos.get(i);
			Log.d(LogTag, "i="+i+", numActivities="+RunningTaskInfo1.numActivities
					+", topActivity="+RunningTaskInfo1.topActivity.getClassName()+", baseActivity="+RunningTaskInfo1.baseActivity.getClassName());
		}
	}
	
	
	
	public static String getCurrentDiseaseTimeType()
	{
//		Date dtNow = new Date();
		Calendar calendar1 = Calendar.getInstance();
		int hour = calendar1.get(Calendar.HOUR_OF_DAY);       //获取当前小时
		int minute = calendar1.get(Calendar.MINUTE);          //获取当前分钟
		if (hour >= Constants.DiseaseTimeType_BeginHour_morning && hour<Constants.DiseaseTimeType_BeginHour_afternoon){
			return "上午";
		}else if (hour >= Constants.DiseaseTimeType_BeginHour_afternoon && hour<Constants.DiseaseTimeType_BeginHour_night){
			return "下午";
		}else{
			return "睡前";
		}
	}
	
	public static String getVersionNameOfCurrentApp(Context ctx){
		String versionName = null;
		try {
			versionName = ctx.getPackageManager().getPackageInfo(ctx.getPackageName(), 0).versionName;
		} catch (NameNotFoundException e) {
			Log.d(LogTag, e.getMessage());
		}
	    return versionName;
	}
	public static int getVersionCodeOfCurrentApp(Context ctx){
		int versionCode = -1;
		try {
			versionCode = ctx.getPackageManager().getPackageInfo(ctx.getPackageName(), 0).versionCode;
		} catch (NameNotFoundException e) {
			Log.d(LogTag, e.getMessage());
		}
	    return versionCode;
	}
	public static int getVersionOfAndroidSDK(){
		return android.os.Build.VERSION.SDK_INT;
	}
	
	public static String[] splitNutrientTitleToCnEn(String nutrientTitle){
		if (nutrientTitle == null || nutrientTitle.length()==0)
			return null;
		int cnStartIdx = -1, enStartIdx = -1;
		for(int i=0; i<nutrientTitle.length(); i++){
			char c = nutrientTitle.charAt(i);
			int charCode = (int)c;
			if (charCode <= 255){
				if (enStartIdx == -1) enStartIdx = i;
			}else{
				if (cnStartIdx == -1) cnStartIdx = i;
			}
		}
		if (cnStartIdx == -1 && enStartIdx == -1){
			return null;//impossible
		}else if(cnStartIdx == -1 || enStartIdx == -1){
			//all be cn or all be en
			return new String[]{nutrientTitle};
		}else{
			//cn and en both exist
			String cnPart , enPart;
			if (cnStartIdx == 0){
				cnPart = nutrientTitle.substring(cnStartIdx, enStartIdx);
				enPart = nutrientTitle.substring(enStartIdx);
			}else{
				assert(enStartIdx == 0);
				enPart = nutrientTitle.substring(enStartIdx, cnStartIdx);
				cnPart = nutrientTitle.substring(cnStartIdx);
			}
			return new String[]{cnPart,enPart};
		}
	}
	
	/*
	 when atLeastN<=0, it means at least ALL. item is of string type.
	 toBeCheckedAry and fullCol can be String[] or ArrayList<String>
	 
	 */
	public static boolean existAtLeastN_withToBeCheckedCollection(Object toBeCheckedCol,Object fullCol,int atLeastN)
	{
	    if (fullCol == null)
	        return true;
	    if (toBeCheckedCol == null)
	        return false;
	    
	    HashSet<String> fullSet = new HashSet<String>();

	    if (fullCol instanceof  String[]){
	    	String[] fullAry = (String[])fullCol;
	    	fullSet.addAll(Tool.convertFromArrayToList(fullAry));
	    }else if(fullCol instanceof ArrayList<?>){
	    	ArrayList<String> fullList = (ArrayList<String>)fullCol;
	    	fullSet.addAll(fullList);
	    }else{
	    	fullSet = (HashSet<String>)fullCol;
	    }
	    
	    String[] toBeCheckedAry = null;
	    ArrayList<String> toBeCheckedList = null;
	    if (toBeCheckedCol instanceof  String[]){
	    	toBeCheckedAry = (String[])toBeCheckedCol;
	    }else{
	    	toBeCheckedList = (ArrayList<String>)toBeCheckedCol;
	    }

	    if (fullSet.size()==0)
	        return true;
	    if (toBeCheckedAry!=null && toBeCheckedAry.length==0 || toBeCheckedList!=null && toBeCheckedList.size()==0)
	        return false;
	    int toBeCheckedColSize = 0;
	    toBeCheckedColSize = toBeCheckedAry==null? toBeCheckedColSize : toBeCheckedAry.length;
	    toBeCheckedColSize = toBeCheckedList==null? toBeCheckedColSize : toBeCheckedList.size();
	    if (atLeastN <=0 ){
	        atLeastN = toBeCheckedColSize;
	    }
	    
	    int inCount = 0;
	    
	    for(int i=0; i<toBeCheckedColSize; i++){
	        String toBeCheckedItem = null;
	        if (toBeCheckedAry!=null)
	        	toBeCheckedItem = toBeCheckedAry[i];
	        else if(toBeCheckedList!=null)
	        	toBeCheckedItem = toBeCheckedList.get(i);
	        if (fullSet.contains(toBeCheckedItem)){
	        	inCount ++;
	        }
	    }
	    if (inCount >= atLeastN)
	        return true;
	    else
	        return false;

	}
	
	/*
	 weight unit is kg
	 height unit is cm
	 */
	public static double getBMI_withWeight(double weight,double height)
	{
	    double BMI = weight * 10000 / (height*height);// *10000 is because height unit is cm
	    return BMI;
	}
	
	/*
	 symptomIds 是待分析的症状集合
	 measureData 可能需要如下key： Key_HeartRate, Key_BloodPressureLow,Key_BloodPressureHigh, Key_BodyTemperature
	 返回值 是一个可能的疾病Id的集合
	 */
	public static ArrayList<String> inferIllnesses_withSymptoms(ArrayList<String> symptomIds,HashMap<String, Object> measureData)
	{
		ArrayList<String> inferIllnessAry = new ArrayList<String>();
		

	    
	    if (measureData != null) {
	    	Integer nmHeartRate = (Integer)measureData.get(Constants.Key_HeartRate);
	        if (nmHeartRate != null){
	            int heartRate = nmHeartRate.intValue();
	            if (heartRate >0 && heartRate < 60){
	                inferIllnessAry.add("窦性心动过缓");
	            }else if(heartRate > 100){
	                inferIllnessAry.add("窦性心动过速");
	            }
	        }
	        
	        Integer nmBloodPressureLow = (Integer)measureData.get(Constants.Key_BloodPressureLow);
	        Integer nmBloodPressureHigh = (Integer)measureData.get(Constants.Key_BloodPressureHigh); 
	        if (nmBloodPressureLow!=null && nmBloodPressureHigh!=null){
	            int bloodPressureLow =  nmBloodPressureLow.intValue();
	            int bloodPressureHigh =  nmBloodPressureHigh.intValue();
	            if (bloodPressureHigh>=180 && bloodPressureLow>=110){
	                inferIllnessAry.add("重度高血压");
	            } else if (bloodPressureHigh>=160 && bloodPressureLow>=100){
	                inferIllnessAry.add("中度高血压");
	            } else if (bloodPressureHigh>=140 && bloodPressureLow>=90){
	                inferIllnessAry.add("轻度高血压");
	            }
	        }
	        
	        Double nmBodyTemperature = (Double)measureData.get(Constants.Key_BodyTemperature);
	        if (nmBodyTemperature != null){
	            double bodyTemperature = nmBodyTemperature.doubleValue();
	            if (bodyTemperature >= 40.0){
	                inferIllnessAry.add("超高热");
	            }else if (bodyTemperature >= 39.0){
	                inferIllnessAry.add("高热");
	            }else if (bodyTemperature >= 38.0){
	                inferIllnessAry.add("中热");
	            }else if (bodyTemperature >= 37.5){
	                inferIllnessAry.add("低热");
	            }else if (bodyTemperature < 36.5){
	            	inferIllnessAry.add("体温过低");
	            }
	        }
	    }
	    
		if (symptomIds==null || symptomIds.size()==0){
			return inferIllnessAry;
		}
		HashSet<String> symptomSet = new HashSet<String>();
		symptomSet.addAll(symptomIds);

	    String[] ganMao_SymptomsFull1 = {"鼻塞","清鼻涕","鼻后滴漏","喷嚏"};
	    String[] ganMao_SymptomsFull4 = {"发热","畏寒","味觉迟钝","头痛","易流泪",
	                                     "听力减退","咽喉发痒","咽喉灼热","咽喉疼痛","咽干",
	                                     "呼吸不畅","咳嗽","声嘶"};
	    HashSet<String> ganMao_SymptomSetFull1 = new HashSet<String>();
	    ganMao_SymptomSetFull1.addAll(Tool.convertFromArrayToList(ganMao_SymptomsFull1));
	    HashSet<String> ganMao_SymptomSetFull4 = new HashSet<String>();
	    ganMao_SymptomSetFull4.addAll(Tool.convertFromArrayToList(ganMao_SymptomsFull4));
	    if (existAtLeastN_withToBeCheckedCollection(symptomIds,ganMao_SymptomSetFull1,1)
	        && existAtLeastN_withToBeCheckedCollection(symptomIds,ganMao_SymptomSetFull4,4))
	    {
	        inferIllnessAry.add("感冒");
	    }
	    
	    String[] yanYan_SymptomsFull2 = {"咽喉发痒","咽喉灼热"};
	    HashSet<String> yanYan_SymptomSetFull2 = new HashSet<String>();
	    yanYan_SymptomSetFull2.addAll(Tool.convertFromArrayToList(yanYan_SymptomsFull2));
	    if (existAtLeastN_withToBeCheckedCollection(symptomIds,yanYan_SymptomSetFull2,2)
	        && !symptomSet.contains("咳嗽")){
	        inferIllnessAry.add("急性病毒性咽炎");
	    }
	    
	    String[] houYan_SymptomsFull2 = {"声嘶","讲话困难"};
	    HashSet<String> houYan_SymptomSetFull2 = new HashSet<String>();
	    houYan_SymptomSetFull2.addAll(Tool.convertFromArrayToList(houYan_SymptomsFull2));
	    if (existAtLeastN_withToBeCheckedCollection(symptomIds,houYan_SymptomSetFull2,2)){
	        inferIllnessAry.add("急性病毒性喉炎");
	    }
	    
	    String[] bianTaoTi_SymptomsFull1 = {"扁桃体肿大"};
	    HashSet<String> bianTaoTi_SymptomSetFull1 = new HashSet<String>();
	    bianTaoTi_SymptomSetFull1.addAll(Tool.convertFromArrayToList(bianTaoTi_SymptomsFull1));
	    if (existAtLeastN_withToBeCheckedCollection(symptomIds,bianTaoTi_SymptomSetFull1,1)){
	        inferIllnessAry.add("急性扁桃体炎");
	    }
	    
	    String[] biYan_SymptomsFull3 = {"鼻塞","鼻痒","清鼻涕","连续喷嚏"};
	    HashSet<String> biYan_SymptomSetFull3 = new HashSet<String>();
	    biYan_SymptomSetFull3.addAll(Tool.convertFromArrayToList(biYan_SymptomsFull3));
	    if (existAtLeastN_withToBeCheckedCollection(symptomIds,biYan_SymptomSetFull3,3)
	        && !symptomSet.contains("咳嗽") && !symptomSet.contains("发热") ){
	        inferIllnessAry.add("过敏性鼻炎");
	    }
	    
	    String[] zhiQiGuanYan_SymptomsFull1 = {"咳痰","痰中带血"};
	    String[] zhiQiGuanYan_SymptomsFull2 = {"咳嗽","喘息"};
	    HashSet<String> zhiQiGuanYan_SymptomSetFull1 = new HashSet<String>();
	    zhiQiGuanYan_SymptomSetFull1.addAll(Tool.convertFromArrayToList(zhiQiGuanYan_SymptomsFull1));
	    HashSet<String> zhiQiGuanYan_SymptomSetFull2 = new HashSet<String>();
	    zhiQiGuanYan_SymptomSetFull2.addAll(Tool.convertFromArrayToList(zhiQiGuanYan_SymptomsFull2));
	    if (existAtLeastN_withToBeCheckedCollection(symptomIds,zhiQiGuanYan_SymptomSetFull1,1)
	        && existAtLeastN_withToBeCheckedCollection(symptomIds,zhiQiGuanYan_SymptomSetFull2,2) ){
	        inferIllnessAry.add("慢性支气管炎");
	    }
	    
	    String[] xiaoChuan_SymptomsFull2 = {"呼吸不畅","哮鸣音"};
	    HashSet<String> xiaoChuan_SymptomSetFull2 = new HashSet<String>();
	    xiaoChuan_SymptomSetFull2.addAll(Tool.convertFromArrayToList(xiaoChuan_SymptomsFull2));
	    if (existAtLeastN_withToBeCheckedCollection(symptomIds,xiaoChuan_SymptomSetFull2,2) ){
	        inferIllnessAry.add("支气管哮喘");
	    }
	    
	    String[] feiJieHe_SymptomsFull2in2 = {"咳嗽","发热"};
	    String[] feiJieHe_SymptomsFull1in2a = {"咳痰","痰中带血"};
	    String[] feiJieHe_SymptomsFull1in2b = {"胸痛","呼吸不畅"};
	    HashSet<String> feiJieHe_SymptomSetFull2in2 = new HashSet<String>();
	    feiJieHe_SymptomSetFull2in2.addAll(Tool.convertFromArrayToList(feiJieHe_SymptomsFull2in2));
	    HashSet<String> feiJieHe_SymptomSetFull1in2a = new HashSet<String>();
	    feiJieHe_SymptomSetFull1in2a.addAll(Tool.convertFromArrayToList(feiJieHe_SymptomsFull1in2a));
	    HashSet<String> feiJieHe_SymptomSetFull1in2b = new HashSet<String>();
	    feiJieHe_SymptomSetFull1in2b.addAll(Tool.convertFromArrayToList(feiJieHe_SymptomsFull1in2b));
	    if (existAtLeastN_withToBeCheckedCollection(symptomIds,feiJieHe_SymptomSetFull2in2,2)
	        && existAtLeastN_withToBeCheckedCollection(symptomIds,feiJieHe_SymptomSetFull1in2a,1)
	        && existAtLeastN_withToBeCheckedCollection(symptomIds,feiJieHe_SymptomSetFull1in2b,1)){
	        inferIllnessAry.add("肺结核");
	    }
	    
	    String[] jiXingWeiYan_SymptomsFull1in2 = {"食欲不振","恶心"};
	    String[] jiXingWeiYan_SymptomsFullPart1in2 = {"腹胀满","上腹痛"};
	    String[] jiXingWeiYan_SymptomsFullPart2in2 = {"呕血","黑便"};
	    HashSet<String> jiXingWeiYan_SymptomSetFull1in2 = new HashSet<String>();
	    jiXingWeiYan_SymptomSetFull1in2.addAll(Tool.convertFromArrayToList(jiXingWeiYan_SymptomsFull1in2));
	    HashSet<String> jiXingWeiYan_SymptomSetFullPart1in2 = new HashSet<String>();
	    jiXingWeiYan_SymptomSetFullPart1in2.addAll(Tool.convertFromArrayToList(jiXingWeiYan_SymptomsFullPart1in2));
	    HashSet<String> jiXingWeiYan_SymptomSetFullPart2in2 = new HashSet<String>();
	    jiXingWeiYan_SymptomSetFullPart2in2.addAll(Tool.convertFromArrayToList(jiXingWeiYan_SymptomsFullPart2in2));
	    if (existAtLeastN_withToBeCheckedCollection(symptomIds,jiXingWeiYan_SymptomSetFull1in2,1)
	        && symptomSet.contains("呕吐")
	        &&
	        (existAtLeastN_withToBeCheckedCollection(symptomIds,jiXingWeiYan_SymptomSetFullPart1in2,1)
	          ||existAtLeastN_withToBeCheckedCollection(symptomIds,jiXingWeiYan_SymptomSetFullPart2in2,2))
	    ){
	        inferIllnessAry.add("急性胃炎");
	    }
	    
	    String[] manXingWeiYan_SymptomsFull2in4 = {"食欲不振","恶心","打嗝","泛酸"};
	    String[] manXingWeiYan_SymptomsFull1in2 = {"腹胀满","烧灼状腹痛"};
	    HashSet<String> manXingWeiYan_SymptomSetFull2in4 = new HashSet<String>();
	    manXingWeiYan_SymptomSetFull2in4.addAll(Tool.convertFromArrayToList(manXingWeiYan_SymptomsFull2in4));
	    HashSet<String> manXingWeiYan_SymptomSetFull1in2 = new HashSet<String>();
	    manXingWeiYan_SymptomSetFull1in2.addAll(Tool.convertFromArrayToList(manXingWeiYan_SymptomsFull1in2));
	    if (existAtLeastN_withToBeCheckedCollection(symptomIds,manXingWeiYan_SymptomSetFull2in4,2)
	        && existAtLeastN_withToBeCheckedCollection(symptomIds,manXingWeiYan_SymptomSetFull1in2,1) ){
	        inferIllnessAry.add("慢性胃炎");
	    }
	    
	    String[] xiaoHuaBuLiang_SymptomsFull1in2 = {"餐后腹胀","餐后腹痛"};
	    String[] xiaoHuaBuLiang_SymptomsFull2in6 = {"食欲不振","恶心","打嗝","早饱感", "上腹痛","烧灼状腹痛"};
	    HashSet<String> xiaoHuaBuLiang_SymptomSetFull1in2 = new HashSet<String>();
	    xiaoHuaBuLiang_SymptomSetFull1in2.addAll(Tool.convertFromArrayToList(xiaoHuaBuLiang_SymptomsFull1in2));
	    HashSet<String> xiaoHuaBuLiang_SymptomSetFull2in6 = new HashSet<String>();
	    xiaoHuaBuLiang_SymptomSetFull2in6.addAll(Tool.convertFromArrayToList(xiaoHuaBuLiang_SymptomsFull2in6));
	    if (existAtLeastN_withToBeCheckedCollection(symptomIds,xiaoHuaBuLiang_SymptomSetFull1in2,1)
	        && existAtLeastN_withToBeCheckedCollection(symptomIds,xiaoHuaBuLiang_SymptomSetFull2in6,2) ){
	        inferIllnessAry.add("功能性消化不良");
	    }
	    
	    String[] changBing_SymptomsFull1in2 = {"腹泻","黏液脓血便"};
	    String[] changBing_SymptomsFull1in5 = {"腹胀满","食欲不振","恶心","呕吐", "发热"};
	    HashSet<String> changBing_SymptomSetFull1in2 = new HashSet<String>();
	    changBing_SymptomSetFull1in2.addAll(Tool.convertFromArrayToList(changBing_SymptomsFull1in2));
	    HashSet<String> changBing_SymptomSetFull1in5 = new HashSet<String>();
	    changBing_SymptomSetFull1in5.addAll(Tool.convertFromArrayToList(changBing_SymptomsFull1in5));
	    if (existAtLeastN_withToBeCheckedCollection(symptomIds,changBing_SymptomSetFull1in2,1)
	        && existAtLeastN_withToBeCheckedCollection(symptomIds,changBing_SymptomSetFull1in5,1)
	        && (symptomSet.contains("左下或下腹痛") || symptomSet.contains("下腹痛"))){
	        inferIllnessAry.add("炎症性肠病");
	    }

	    String[] shenYan_SymptomsFull2in2 = {"眼睑水肿","下肢水肿"};
	    HashSet<String> shenYan_SymptomSetFull2in2 = new HashSet<String>();
	    shenYan_SymptomSetFull2in2.addAll(Tool.convertFromArrayToList(shenYan_SymptomsFull2in2));
	    if (existAtLeastN_withToBeCheckedCollection(symptomIds,shenYan_SymptomSetFull2in2,2)
	        || symptomSet.contains("血尿")){
	        inferIllnessAry.add("急性肾小球肾炎");
	    }
	    
	    String[] pinXue_SymptomsFull8 = {"乏力","倦怠萎靡","体力耐力下降","烦躁","易怒","注意力分散",
	                                     "口唇干裂","口腔溃疡","舌发炎/红包","吞咽困难","气短","心慌",
	                                     "皮肤干燥","皮肤皱纹","头晕","头痛","头发干枯","头发脱落","脸色苍白",
	                                     "视觉模糊","耳鸣","指甲缺乏光泽","指甲脆薄易裂","指甲变平","指甲勺状下凹"};
	    HashSet<String> pinXue_SymptomSetFull8 = new HashSet<String>();
	    pinXue_SymptomSetFull8.addAll(Tool.convertFromArrayToList(pinXue_SymptomsFull8));
	    if (existAtLeastN_withToBeCheckedCollection(symptomIds,pinXue_SymptomSetFull8,8) ){
	        inferIllnessAry.add("缺铁性贫血");
	    }
	    
	    String[] jiaKang_SymptomsFull2in2 = {"食欲亢进","甲状腺肿大"};
	    HashSet<String> jiaKang_SymptomSetFull2in2 = new HashSet<String>();
	    jiaKang_SymptomSetFull2in2.addAll(Tool.convertFromArrayToList(jiaKang_SymptomsFull2in2));
	    if (existAtLeastN_withToBeCheckedCollection(symptomIds,jiaKang_SymptomSetFull2in2,2)
	        || symptomSet.contains("突眼")){
	        inferIllnessAry.add("甲状腺功能亢进");
	    }
	    
	    String[] jiaJian_SymptomsFull7 = {"头发干枯","头发脱落","脸色苍白","乏力","皮肤干燥",
	                                      "颜面水肿","表情呆滞","眼睑水肿","听力减退","舌肿胀/有齿痕",
	                                      "声嘶","心跳过慢","脱皮屑","姜黄肤色","手脚冰凉",
	                                      "四肢肿胀","关节疼痛","少汗","体重增加","畏寒",
	                                      "便秘","反应迟钝","健忘","嗜睡","月经过多",
	                                      "月经不调"};
	    HashSet<String> jiaJian_SymptomSetFull7 = new HashSet<String>();
	    jiaJian_SymptomSetFull7.addAll(Tool.convertFromArrayToList(jiaJian_SymptomsFull7));
	    if (existAtLeastN_withToBeCheckedCollection(symptomIds,jiaJian_SymptomSetFull7,7) ){
	        inferIllnessAry.add("甲状腺功能减退");
	    }
	    
	    String[] tangNiaoBing_SymptomsFull3 = {"多饮","多尿","视觉模糊","食欲亢进","体重减少"};
	    HashSet<String> tangNiaoBing_SymptomSetFull3 = new HashSet<String>();
	    tangNiaoBing_SymptomSetFull3.addAll(Tool.convertFromArrayToList(tangNiaoBing_SymptomsFull3));
	    if (existAtLeastN_withToBeCheckedCollection(symptomIds,tangNiaoBing_SymptomSetFull3,3)){
	        inferIllnessAry.add("糖尿病");
	    }
	    
	    String[] diXueTang_SymptomsFull6 = {"乏力","脸色苍白","烦躁","易怒","注意力分散",
	                                      "心慌","头晕","视觉模糊","手脚冰凉","反应迟钝",
	                                      "嗜睡","流口水","心跳过速","手脚震颤","多汗",
	                                      "易饥饿","步态不稳","紧张焦虑"};
	    HashSet<String> diXueTang_SymptomSetFull6 = new HashSet<String>();
	    diXueTang_SymptomSetFull6.addAll(Tool.convertFromArrayToList(diXueTang_SymptomsFull6));
	    if (existAtLeastN_withToBeCheckedCollection(symptomIds,diXueTang_SymptomSetFull6,6) ){
	        inferIllnessAry.add("低血糖");
	    }

	    String[] guanJieYan_SymptomsFull2 = {"关节疼痛","关节肿胀","关节僵硬"};
	    HashSet<String> guanJieYan_SymptomSetFull2 = new HashSet<String>();
	    guanJieYan_SymptomSetFull2.addAll(Tool.convertFromArrayToList(guanJieYan_SymptomsFull2));
	    if (existAtLeastN_withToBeCheckedCollection(symptomIds,guanJieYan_SymptomSetFull2,2)
	        || symptomSet.contains("晨僵")){
	        inferIllnessAry.add("骨关节炎");
	    }
	    
	    String[] guZhiShuSong_SymptomsFull1in2 = {"乏力","负重能力下降"};
	    HashSet<String> guZhiShuSong_SymptomSetFull1in2 = new HashSet<String>();
	    guZhiShuSong_SymptomSetFull1in2.addAll(Tool.convertFromArrayToList(guZhiShuSong_SymptomsFull1in2));
	    if (symptomSet.contains("弥漫性骨痛")
	        || (existAtLeastN_withToBeCheckedCollection(symptomIds,guZhiShuSong_SymptomSetFull1in2,1)
	            && symptomSet.contains("腰背疼痛")) ){
	        inferIllnessAry.add("骨质疏松");
	    }
	    
	    return inferIllnessAry;
	}
	
	public static String getBMIStatusId(double bmiVal){
		if (bmiVal<18.5){
			return "过轻";
		}else if(bmiVal<25){
			return "正常";
		}else if(bmiVal<30){
			return "过重";
		}else{
			return "肥胖";
		}
	}
	
	public static JSONObject HashMapToJsonObject(HashMap<String, Object> hmObj){
		if (hmObj == null)
			return null;
		HashMap<String, Object> hmObj2 = new HashMap<String, Object>();
		hmObj2.putAll(hmObj);
		
		Iterator<Map.Entry<String,Object>> iter = hmObj.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry<String,Object> entry = iter.next();
			String key = entry.getKey();
			Object val = entry.getValue();
			if (val instanceof Object[] || val instanceof ArrayList<?>){
				JSONArray jsonAry = CollectionToJSONArray(val);
				hmObj2.put(key, jsonAry);
			}else if (val instanceof HashMap<?, ?>){
				JSONObject jsonObjItem = HashMapToJsonObject((HashMap<String, Object>)val);
				hmObj2.put(key, jsonObjItem);
			}else{
				//do nothing
			}
		}
		JSONObject jsonObj = new JSONObject(hmObj2);
		return jsonObj;
	}
	public static JSONArray CollectionToJSONArray(Object col){
		if (col == null)
			return null;
		ArrayList<Object> list = null;
		if (col instanceof Object[]){
			Object[] ary= (Object[])col;
			list = convertFromArrayToList(ary);
		}else if (col instanceof ArrayList<?>){
			list = (ArrayList<Object>)col;
		}
		for(int i=0; i<list.size(); i++){
			Object item = list.get(i);
			if (item instanceof Object[] || item instanceof ArrayList<?>){
				JSONArray jsonArySub1 = CollectionToJSONArray(item);
				list.set(i, jsonArySub1);
			}else if (item instanceof HashMap<?, ?>){
				JSONObject jsonObjSub1 = HashMapToJsonObject((HashMap<String, Object>) item);
				list.set(i, jsonObjSub1);
			}else{
				//do nothing
			}
		}
		JSONArray jsonAry = new JSONArray(list);
		return jsonAry;
	}


	public static HashMap<String, Object> JsonToHashMap(JSONObject jsonData)
	{
		if (jsonData == null){
			return null;
		}
		HashMap<String, Object> hm = new HashMap<String, Object>();
		
		Iterator<String> IteratorJson = jsonData.keys();
		while (IteratorJson.hasNext()){
			String key = IteratorJson.next();
			Object valObj = null;
			try {
				valObj = jsonData.get(key);
			} catch (JSONException e) {
				Log.e(LogTag, "JsonToHashMap jsonData.get Err"+e.getMessage(),e);
				throw new RuntimeException(e);
			}
			if (valObj != null){
				if (valObj instanceof JSONObject){
					JSONObject jsonValObj = (JSONObject)valObj;
					HashMap<String, Object> hmSub = JsonToHashMap(jsonValObj);
					hm.put(key, hmSub);
				}else if (valObj instanceof JSONArray){
					ArrayList<Object> alSub = JsonToArrayList((JSONArray)valObj);
					hm.put(key, alSub);
				}else if (JSONObject.NULL.equals(valObj)){
					hm.put(key, null);
				}else{
					hm.put(key, valObj);
				}
			}
		}//while
		
        return hm;
  
    }  
  
    public static ArrayList<Object> JsonToArrayList(JSONArray jsonAry) {
    	if (jsonAry == null)
    		return null;
    	ArrayList<Object> al = new ArrayList<Object>();
    	for(int i=0; i<jsonAry.length(); i++){
    		Object item = null;
			try {
				item = jsonAry.get(i);
			} catch (JSONException e) {
				Log.e(LogTag, "JsonToArrayList jsonAry.get Err"+e.getMessage(),e);
				throw new RuntimeException(e);
			}
			if (item!=null){
				if (item instanceof JSONObject){
	    			HashMap<String, Object> itemHm = JsonToHashMap((JSONObject)item);
	    			al.add(itemHm);
	    		}else if (item instanceof JSONArray){
	    			ArrayList<Object> itemAl = JsonToArrayList((JSONArray)item);
	    			al.add(itemAl);
	    		}else if (JSONObject.NULL.equals(item)){
	    			al.add(null);
	    		}else{
	    			al.add(item);
	    		}
			}
    	}//for
    	return al;
    }  
  
    public static String getAndroidUniqueID(Context context) {
        TelephonyManager tm = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
        String deviceId = tm.getDeviceId();
        if (deviceId == null)//pad has no deviceId
            deviceId = Secure.getString(context.getContentResolver(),Secure.ANDROID_ID);
        Log.d(LogTag, "getAndroidUniqueID ret:"+deviceId);
        return deviceId;
    }
    
    public static byte[] getUtf8Byte(String dataString){
    	if (dataString == null)
    		return null;
    	Charset utf8charset = Charset.forName("UTF-8");
		byte[] dataByte = dataString.getBytes(utf8charset);
		return dataByte;
    }
	public static String getStringFromUtf8Byte(byte[] dataByte){
		if (dataByte==null)
			return null;
		Charset utf8charset = Charset.forName("UTF-8");
		String dataString = new String(dataByte, utf8charset);
		return dataString;
	}
	
	public static Date getDateFromYearMonthDay(int yearMonthDay){
		int day = yearMonthDay % 100;
		int yearMonth = yearMonthDay / 100;
		int month = yearMonth % 100;
		int year = yearMonth / 100;
		GregorianCalendar greCalendar = new GregorianCalendar(year, month-1, day);
		return greCalendar.getTime();
	}
	
	private static class MyWebViewClient extends WebViewClient
    {
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url)
        {
        	view.loadUrl(url);
            return true;
        }
    }
	
	public static void setWebViewBasicHere(WebView webView1){
		webView1.getSettings().setJavaScriptEnabled(true); //需要Enable JavaScript，不然webview只会加载一部分页面，往下滑到末尾不会继续加载，出现一个 点击加载更多的按钮 也点不动。
    	
		MyWebViewClient MyWebViewClient1 = new MyWebViewClient();
		webView1.setWebViewClient(MyWebViewClient1);//防止在 loadUrl 弹出选择系统中的浏览器的界面 http://www.myexception.cn/web/971082.html
    	
		//另外需要在各个activity中设置 onKeyDown 处理back键
	}
	
	public static void changeBackground_NutritionButton(Context curActv, View vwNutrition, String nutrientId, boolean needBgEffect){
		//todo , search android color blend function or android color mix function
		class OnTouchListenerForPressEffect implements View.OnTouchListener {
			int m_overlapColor;
			public OnTouchListenerForPressEffect(int overlapColor){
				m_overlapColor = overlapColor;
			}
			
			@Override
			public boolean onTouch(View v, MotionEvent event) {
				int eventAction = event.getAction();
//				float eX = event.getX();
//				float eY = event.getY();
////				float vX = v.getX();
////				float vY = v.getY();
//				int vLeft = v.getLeft();
//				int vRight = v.getRight();
//				int vTop = v.getTop();
//				int vBottom = v.getBottom();
////				Log.d(LogTag, "eX,eY="+eX+","+eY+". vX,vY="+vX+","+vY+". vLTRB="+vLeft+","+vTop+","+vRight+","+vBottom);
//				Log.d(LogTag, "eX,eY="+eX+","+eY+". vLTRB="+vLeft+","+vTop+","+vRight+","+vBottom);

				//目前有个bug是按住按钮然后移动到外面，按钮颜色变了不能恢复 TODO
				if (eventAction == MotionEvent.ACTION_DOWN) {
					ColorFilter cf = new ColorFilter();
		            v.getBackground().setColorFilter(m_overlapColor,PorterDuff.Mode.SRC_OVER);//can not DST_OVER 
		            return false;
		        } else if (eventAction == MotionEvent.ACTION_UP || eventAction == MotionEvent.ACTION_OUTSIDE) {
//		            v.getBackground().setColorFilter(Color.argb(0, 0, 0, 0),PorterDuff.Mode.SRC_OVER);
		        	v.getBackground().clearColorFilter();
		            return false;
		        }
		        return false;
			}
		}
		
		HashMap<String, Integer> nutrientColorMapping = NutritionTool.getNutrientColorMapping();
		Integer nutrientColorResId = nutrientColorMapping.get(nutrientId);
		final float[] roundedCorners = new float[] { 11, 11, 11, 11, 11, 11, 11, 11 };
		RoundRectShape RoundRectShape1 = new RoundRectShape(roundedCorners, null,null);
		
		ShapeDrawable ShapeDrawable1 = new ShapeDrawable(RoundRectShape1);
//		ShapeDrawable1.getPaint().setColor(Color.parseColor("#FF0000"));
		ShapeDrawable1.getPaint().setColor(curActv.getResources().getColor(nutrientColorResId));
		ShapeDrawable1.setPadding(16, 14, 16, 14);
		
		ShapeDrawable ShapeDrawable21 = new ShapeDrawable(RoundRectShape1);
		ShapeDrawable21.getPaint().setColor(curActv.getResources().getColor(nutrientColorResId));
		ShapeDrawable21.setPadding(16, 14, 16, 14);
		
		int overlapColor = curActv.getResources().getColor(R.color.v3_addClickEffect);
		ShapeDrawable ShapeDrawable22 = new ShapeDrawable(RoundRectShape1);
		ShapeDrawable22.getPaint().setColor(overlapColor);
		ShapeDrawable22.setPadding(16, 14, 16, 14);
		

		StateListDrawable states = new StateListDrawable();
		
//		Drawable[] layers = new Drawable[2];
//		layers[0] = ShapeDrawable21;
//		layers[1] = ShapeDrawable22;
//		LayerDrawable layerDrawable1 = new LayerDrawable(layers);
//		//layerDrawable1.setLayerInset(0, 16, 14, 16, 14);
//		//layerDrawable1.setLayerInset(1, 16, 14, 16, 14);
//		if (needBgEffect){
//			states.addState(new int[] {android.R.attr.state_pressed}, layerDrawable1);//这里需要颜色叠加.但是使用了padding就出问题了
//		}

		//all fail
//		if (needBgEffect){
////			ShapeDrawable21.setColorFilter(overlapColor, PorterDuff.Mode.SRC_OVER);//fail
////			ShapeDrawable21.setColorFilter(overlapColor, PorterDuff.Mode.DST_OVER);//fail
////			ShapeDrawable21.setColorFilter(overlapColor, PorterDuff.Mode.OVERLAY);//fail
////			PorterDuffColorFilter overColorFilter = new PorterDuffColorFilter(overlapColor, PorterDuff.Mode.SRC_OVER);//fail
////			PorterDuffColorFilter overColorFilter = new PorterDuffColorFilter(overlapColor, PorterDuff.Mode.DST_OVER);//fail
////			ShapeDrawable21.getPaint().setColorFilter(overColorFilter);
////			states.addState(new int[] {android.R.attr.state_pressed}, ShapeDrawable21);
//		}
		
		//ok
		if (needBgEffect){
			vwNutrition.setOnTouchListener(new OnTouchListenerForPressEffect(overlapColor));
		}else{
			vwNutrition.setOnTouchListener(null);
		}
			
		states.addState(new int[] { }, ShapeDrawable1);

		if (Tool.getVersionOfAndroidSDK() >= 16){//运行时获取Android API版本来判断
			vwNutrition.setBackground(states);//android 2.3 not have this method
		}else{
			vwNutrition.setBackgroundDrawable(states);//deprecated in API level 16.
		}
		

	}
	
	
	public static void setListViewExpandHeightByCalculateChildren(ListView lv){
		int totalHeight = 0;    
		ListAdapter adapter = lv.getAdapter();
		int childCount = adapter.getCount();

		for (int i = 0; i < childCount; i++) {
	        View vwChild = adapter.getView(i, null, lv);
	        vwChild.measure(0, 0); //计算子项View 的宽高    
	        totalHeight += vwChild.getMeasuredHeight(); //统计所有子项的总高度    
	    }    
	    ViewGroup.LayoutParams params = lv.getLayoutParams();    
	    params.height = totalHeight + lv.getDividerHeight() * (childCount - 1);    
	    lv.setLayoutParams(params);
	}
	
	public static void setGridViewFromTooHighToJustExpandHeight(GridView gv){
		class OnGlobalLayoutListener_GV implements OnGlobalLayoutListener{
			GridView m_gv;
			public OnGlobalLayoutListener_GV(GridView gv){
				m_gv = gv;
			}

			@Override
			public void onGlobalLayout() {
				if (Tool.getVersionOfAndroidSDK() >= 16){
					m_gv.getViewTreeObserver().removeOnGlobalLayoutListener(this);
				}else{
					m_gv.getViewTreeObserver().removeGlobalOnLayoutListener( this );
				}
				
                View lastChild = m_gv.getChildAt( m_gv.getChildCount() - 1 );
                int height2 = lastChild.getBottom();
//                LinearLayout.LayoutParams params = new LinearLayout.LayoutParams( LayoutParams.MATCH_PARENT, height2 );
                ViewGroup.LayoutParams params = m_gv.getLayoutParams();
                params.height = height2;
                m_gv.setLayoutParams(params);
			}
		}
		gv.getViewTreeObserver().addOnGlobalLayoutListener(new OnGlobalLayoutListener_GV(gv));
	}
	
	
	
	//no use because childCount being 0
	public static void setGridViewExpandHeightByCalculateChildren(GridView gv){
//		int totalHeight = 0;
//		int childCount = gv.getChildCount();
//		int columnCount = 0;
//		if (Tool.getVersionOfAndroidSDK() >= 11) columnCount = gv.getNumColumns();
//		else ???
//		int rowCount = childCount % columnCount == 0 ? childCount / columnCount : childCount / columnCount + 1;
//		// gv.getHorizontalSpacing();
//		// gv.getPaddingTop();
//		// gv.getPaddingBottom();
//		for(int i=0; i<rowCount; i++){
//			int rowHeight = 0;
//			for(int j=0; j<columnCount; j++){
//				int idx = i*columnCount + j;
//				if (idx <= childCount-1){
//					View vwChild = gv.getChildAt(idx);
//					vwChild.measure(0, 0);
//					int cellHeight = vwChild.getMeasuredHeight();
//					if (rowHeight < cellHeight){
//						rowHeight = cellHeight;
//					}
//				}
//			}
//			totalHeight += rowHeight;
//		}
//		ViewGroup.LayoutParams params = gv.getLayoutParams();
////		params.height = totalHeight + gv.getHorizontalSpacing()*(rowCount-1)+gv.getPaddingTop()+gv.getPaddingBottom();
//		params.height = totalHeight +gv.getPaddingTop()+gv.getPaddingBottom();
//		gv.setLayoutParams(params);
	}
	
	public static String formatFloatOrInt(double val, int decimalDigitLen){
		int ival = (int)val;
		if (val == ival){
			return ""+ival;
		}else{
			String formatPattern = "%."+decimalDigitLen+"f";
			String s = String.format(formatPattern, val);
			return s;
		}
	}
	
	public static void printStackTrace(String logTag){
		Throwable throwable1 = new Throwable("just show stack");
		Log.d(logTag, Log.getStackTraceString(throwable1));
		
//		android.os.Debug.dumpHprofData(fileName)
	}
}

















