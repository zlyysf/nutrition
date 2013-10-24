package com.lingzhimobile.nutritionfoodguide;

import java.io.*;
import java.lang.reflect.Array;
import java.util.*;
import java.util.zip.*;

import org.apache.commons.lang3.StringUtils;


import android.R.bool;
import android.app.ActivityManager;
import android.app.AlertDialog;
import android.app.ActivityManager.RunningTaskInfo;
import android.content.Context;
import android.content.res.AssetManager;
import android.content.res.Resources;
import android.database.*;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Path;
import android.graphics.drawable.Drawable;
import android.os.DropBoxManager.Entry;
import android.util.Log;

public class Tool {
	static final String LogTag = "Tool";
	
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
			if (Constants.COLUMN_NAME_NDB_No.equalsIgnoreCase(colName) || Constants.COLUMN_NAME_FoodId.equalsIgnoreCase(colName)){
				hmRow.put(colName, colValStr);
			}else{
//				Object colValObj = null;
//				try{
//					double d_colVal = cs.getDouble(colIdx);
//					colValObj = Double.valueOf(d_colVal);
//				}catch (Exception e) {//NO exception, getDouble return 0.0 always
//					colValObj = cs.getString(colIdx);
//				}
				Object colValObj = null;
				try{
					double d_colVal = Double.parseDouble(colValStr);
					colValObj = Double.valueOf(d_colVal);
				}catch (NumberFormatException e) {
					colValObj = colValStr;
				}
				
				hmRow.put(colName, colValObj);
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
				if (isSimpleObjectForObject(val)){
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
	
	
	
	
	
	
	
	
}

















