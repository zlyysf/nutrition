package com.lingzhimobile.nutritionfoodguide;

import java.io.*;
import java.lang.reflect.Array;
import java.util.*;

import org.apache.commons.lang3.StringUtils;
import org.json.JSONException;
import org.json.JSONObject;

import com.lingzhimobile.nutritionfoodguide.R.string;

import android.R.bool;
import android.content.*;
import android.database.*;
import android.database.sqlite.*;
import android.util.*;


public class DataAccess {
	
	static DataAccess m_singleton = null;
	public static DataAccess getSingleton(Context ctx){
		if (m_singleton == null){
			m_singleton = new DataAccess(ctx.getApplicationContext());
		}
		return m_singleton;
		
	}
	public static DataAccess getSingleton(){
		if (m_singleton == null){
			throw new RuntimeException("NO singleton dataAccess instance");
		}
		return m_singleton;
	}
	
	static final String LogTag = "DataAccess";
//	public static final int RawResIdForDB = R.raw.custom_db_dat;//zip
//	public static final int RawResIdForNormalDB = R.raw.customdb_dat;//change ext name to avoid file 1M size limit
	public static final int RawResIdForZipDB = R.raw.custom_db_dat_zip;//zip and change ext name to improve install-apk performance when debug
	public static final String DBfileName = "CustomDB.dat";
	public static final String DBfileDir = "NutritionData";
	
	SQLiteDatabase mDBcon = null;
//	Context mCtx = null;//只在一开始与文件打交道的时候有用
	
//	public static String getDBfileDirPath(){
//		String dirPath = android.os.Environment.getExternalStorageDirectory().getAbsolutePath();
//		dirPath += File.separator + DBfileDir ;
//		
//		File dir = new File(dirPath);
//		if (!dir.exists()){
//			dir.mkdir();
//		}
//		
//		Log.d("DataAccess", "getDBfileDirPath ret:"+dirPath);
//		return dirPath;
//	}
	public static String getDBfileDirPath(Context ctx){
		String dirPath = ctx.getExternalFilesDir(null).getAbsolutePath();//这个目录可以在app卸载时被删掉，从而可以防止删掉app再装app也还是用的是老数据文件的问题
		dirPath += File.separator + DBfileDir ;

		File dir = new File(dirPath);
		if (!dir.exists()){
			dir.mkdir();
		}
		
		Log.d(LogTag, "getDBfileDirPath ret:"+dirPath);
		return dirPath;
	}
	
	public static String getDBfilePath(Context ctx){
		String filePath = getDBfileDirPath(ctx) + File.separator + DBfileName;
		Log.d(LogTag, "getDBfilePath ret:"+filePath);
		return filePath;
	}
	
	private boolean prepareDB(Context ctx) {
		Log.d(LogTag, "prepareDB enter");
		String dbFilePath = getDBfilePath(ctx);
		File dbFile = new File(dbFilePath);
		if (!dbFile.exists()){
			Log.d(LogTag, "prepareDB .if (!dbFile.exists()).");
			//Tool.unzipRawFileToSDCardFile(ctx, RawResIdForDB, dbFilePath);
//			Tool.copyRawFileToSDCardFile(ctx, RawResIdForNormalDB, dbFilePath);//ok
			Tool.unzipRawFileToSDCardFile(ctx, RawResIdForZipDB, dbFilePath);
			StoredConfigTool.setDBalreadyUpdated(ctx);
		}else{
			if (!StoredConfigTool.getDBalreadyUpdated(ctx)){
				if (dbFile.delete()){
					Log.d(LogTag, "prepareDB .else (!dbFile.exists()). if (!StoredConfigTool.getDBalreadyUpdated(ctx)). if (dbFile.delete()).");
					Tool.unzipRawFileToSDCardFile(ctx, RawResIdForZipDB, dbFilePath);
					StoredConfigTool.setDBalreadyUpdated(ctx);
				}else{
					Log.d(LogTag, "prepareDB .else (!dbFile.exists()). else (!StoredConfigTool.getDBalreadyUpdated(ctx)). else (dbFile.delete())--something WRONG.");
				}
				
			}else{
				Log.d(LogTag, "prepareDB .else (!dbFile.exists()). else (!StoredConfigTool.getDBalreadyUpdated(ctx)). do nothing.");
			}
		}
		return true;
	}
	
	public DataAccess(Context ctx){
//		assert(ctx!=null);
//		mCtx = ctx;
		prepareDB(ctx);
		openDB(ctx);
	}
	
	public boolean openDB(Context ctx){
//		if (!this.prepareDB()){
//			return false;
//		}
		if (mDBcon == null){
			mDBcon = SQLiteDatabase.openDatabase(getDBfilePath(ctx), null, SQLiteDatabase.OPEN_READWRITE);
		}
		return true;
	}
	
//	public void closeDB(){
//		if (mDBcon != null){
//			mDBcon.close();
//			mDBcon = null;
//		}
//	}
	
	//------------------------------------------------------------------------------------------
	
	
	public static String generatePlaceholderPartForIn(int count){
		if (count==0)
			return "";
		String[] sAry = new String[count];
		String placeholder = "?";
		for(int i=0; i<sAry.length; i++)
			sAry[i] = placeholder;
		String placeholderPart = StringUtils.join(sAry,",");
		return placeholderPart;
	}
	
	//------------------------------------------------------------------------------------------
	
	
	public HashMap<String, Double> getStandardDRIs_considerLoss(int sex,int age,double weight,double height,int activityLevel, boolean needConsiderLoss)
	{
		HashMap<String,Double> hmDRIp1 = NutritionTool.getStandardDRIForSex(sex, age, weight, height, activityLevel);
	    String gender = Constants.Gender_male;
	    if (sex != 0) gender = Constants.Gender_female;
	    
	    HashMap<String,Double> hmDRIp2 = this.getDRIbyGender(gender,age);
	    
	    HashMap<String,Double> hmDRI = new HashMap<String, Double>();
	    hmDRI.putAll(hmDRIp1);
	    hmDRI.putAll(hmDRIp2);

	    if (needConsiderLoss){
	    	hmDRI = letDRIConsiderLoss(hmDRI);
	    }
	    Log.d(LogTag, "getStandardDRIs_considerLoss ret:"+hmDRI.toString());
	    return hmDRI;
	}
	public HashMap<String, Double> getStandardDRIULs_considerLoss(int sex,int age,double weight,double height,int activityLevel, boolean needConsiderLoss)
	{
		HashMap<String,Double> hmDRIp1 = NutritionTool.getStandardDRIULForSex(sex, age, weight, height, activityLevel);
	    String gender = Constants.Gender_male;
	    if (sex != 0) gender = Constants.Gender_female;
	    
	    HashMap<String,Double> hmDRIp2 = this.getDRIULbyGender(gender,age);
	    
	    HashMap<String,Double> hmDRI = new HashMap<String, Double>();
	    hmDRI.putAll(hmDRIp1);
	    hmDRI.putAll(hmDRIp2);

	    if (needConsiderLoss){
	    	hmDRI = letDRIULConsiderLoss(hmDRI);
	    }
	    Log.d(LogTag, "getStandardDRIULs_considerLoss ret:"+hmDRI.toString());
	    return hmDRI;
	}
	
	
	Cursor getDRIbyGender_cs(String gender,int age){
		String tableName = Constants.TABLE_NAME_DRIMale;
		if (Constants.Gender_female.equalsIgnoreCase(gender)){
			tableName = Constants.TABLE_NAME_DRIFemale;
		}
		StringBuffer sbQuery = new StringBuffer();
		sbQuery.append("SELECT * FROM ");
		sbQuery.append(tableName);
		sbQuery.append(" WHERE Start <= ? ORDER BY Start desc LIMIT 1");
		String[] args = new String[]{age+""}; 
		Cursor cs = mDBcon.rawQuery(sbQuery.toString(),args);
		return cs;
	}
	public HashMap<String, Double> getDRIbyGender(String gender,int age){
		Cursor cs = getDRIbyGender_cs(gender, age);
		ArrayList<HashMap<String, Double>> rows = Tool.getRowsWithDoubleTypeFromCursor(cs);
		cs.close();
		assert(rows.size()==1);
		HashMap<String, Double> row = rows.get(0);
		row.remove("Start");
		row.remove("End");
		Log.d(LogTag, "getDRIbyGender ret:"+row.toString());
		return row;
	}
	
	Cursor getDRIULbyGender_cs(String gender,int age){
		String tableName = Constants.TABLE_NAME_DRIULMale;
		if (Constants.Gender_female.equalsIgnoreCase(gender)){
			tableName = Constants.TABLE_NAME_DRIULFemale;
		}
		StringBuffer sbQuery = new StringBuffer();
		sbQuery.append("SELECT * FROM ");
		sbQuery.append(tableName);
		sbQuery.append(" WHERE Start <= ? ORDER BY Start desc LIMIT 1");
		String[] args = new String[]{age+""}; 
		Cursor cs = mDBcon.rawQuery(sbQuery.toString(),args);
		return cs;
	}
	public HashMap<String, Double> getDRIULbyGender(String gender,int age){
		Cursor cs = getDRIULbyGender_cs(gender, age);
		ArrayList<HashMap<String, Double>> rows = Tool.getRowsWithDoubleTypeFromCursor(cs);
		cs.close();
		assert(rows.size()==1);
		HashMap<String, Double> row = rows.get(0);
		row.remove("Start");
		row.remove("End");
		Log.d(LogTag, "getDRIULbyGender ret:"+row.toString());
		return row;
	}
	
	public HashMap<String, Double> getStandardDRIs_withUserInfo(HashMap<String, Object> userInfo,HashMap<String, Object> options){
		//int sex,int age,double weight,double height,int activityLevel
		Log.d(LogTag, "getStandardDRIs_withUserInfo enter, userInfo=:"+userInfo+"  options="+options);
		assert(userInfo!=null);
		Integer intObj_sex = (Integer)userInfo.get(Constants.ParamKey_sex);
		Integer intObj_age = (Integer)userInfo.get(Constants.ParamKey_age);
		Double dblObj_weight = (Double)userInfo.get(Constants.ParamKey_weight);
		Double dblObj_height = (Double)userInfo.get(Constants.ParamKey_height);
		Integer intObj_activityLevel = (Integer)userInfo.get(Constants.ParamKey_activityLevel);
		assert(intObj_sex!=null);
		assert(intObj_age!=null);
		assert(dblObj_weight!=null);
		assert(dblObj_height!=null);
		assert(intObj_activityLevel!=null);
		int sex = intObj_sex.intValue();
		int age = intObj_age.intValue();
		double weight = dblObj_weight.doubleValue();
		double height = dblObj_height.doubleValue();
		int activityLevel = intObj_activityLevel.intValue();
		
		boolean needConsiderNutrientLoss = Constants.Config_needConsiderNutrientLoss;
	    if(options != null){
	    	Boolean flag_needConsiderNutrientLoss = (Boolean)options.get(Constants.LZSettingKey_needConsiderNutrientLoss);
	        if (flag_needConsiderNutrientLoss != null)
	            needConsiderNutrientLoss = flag_needConsiderNutrientLoss.booleanValue();
	    }
		return getStandardDRIs_considerLoss(sex,age,weight,height,activityLevel,needConsiderNutrientLoss);
	}
	public HashMap<String, Double> getStandardDRIULs_withUserInfo(HashMap<String, Object> userInfo,HashMap<String, Object> options){
		//int sex,int age,double weight,double height,int activityLevel
		Log.d(LogTag, "getStandardDRIULs_withUserInfo enter, userInfo=:"+userInfo+"  options="+options);
		assert(userInfo!=null);
		Integer intObj_sex = (Integer)userInfo.get(Constants.ParamKey_sex);
		Integer intObj_age = (Integer)userInfo.get(Constants.ParamKey_age);
		Double dblObj_weight = (Double)userInfo.get(Constants.ParamKey_weight);
		Double dblObj_height = (Double)userInfo.get(Constants.ParamKey_height);
		Integer intObj_activityLevel = (Integer)userInfo.get(Constants.ParamKey_activityLevel);
		assert(intObj_sex!=null);
		assert(intObj_age!=null);
		assert(dblObj_weight!=null);
		assert(dblObj_height!=null);
		assert(intObj_activityLevel!=null);
		int sex = intObj_sex.intValue();
		int age = intObj_age.intValue();
		double weight = dblObj_weight.doubleValue();
		double height = dblObj_height.doubleValue();
		int activityLevel = intObj_activityLevel.intValue();
		
		boolean needConsiderNutrientLoss = Constants.Config_needConsiderNutrientLoss;
	    if(options != null){
	    	Boolean flag_needConsiderNutrientLoss = (Boolean)options.get(Constants.LZSettingKey_needConsiderNutrientLoss);
	        if (flag_needConsiderNutrientLoss != null)
	            needConsiderNutrientLoss = flag_needConsiderNutrientLoss.booleanValue();
	    }
		return getStandardDRIULs_considerLoss(sex,age,weight,height,activityLevel,needConsiderNutrientLoss);
	}

	
	HashMap<String, Double> letDRIConsiderLoss(HashMap<String, Double> DRIdict)
	{
	    if (DRIdict == null)
	        return null;
	    HashMap<String, Double> DRIdict2 = new HashMap<String, Double>();
	    DRIdict2.putAll(DRIdict);
	    
	    HashMap<String, HashMap<String, Object>> nutrientInfos = getNutrientInfoAs2LevelDictionary_withNutrientIds(null);
	    Object[] keys = DRIdict2.keySet().toArray();
	    
	    for(int i=0; i<keys.length; i++){
	        String key = (String)keys[i];
	        assert(key!=null);
	        Double driVal = DRIdict2.get(key);
	        HashMap<String, Object> nutrientInfo = nutrientInfos.get(key);
	        assert(nutrientInfo!=null);
	        Double dblObj_LossRate = (Double)nutrientInfo.get(Constants.COLUMN_NAME_LossRate);
	
	        double driV2 = driVal.doubleValue();
	        if (dblObj_LossRate.doubleValue()>0)
	            driV2 = driVal.doubleValue() / (1.0-dblObj_LossRate.doubleValue());
	        
	        DRIdict2.put(key, Double.valueOf(driV2));
	    }
	    Log.d(LogTag, "letDRIConsiderLoss ret:"+DRIdict2.toString());
	    return DRIdict2;
	}
	HashMap<String, Double> letDRIULConsiderLoss(HashMap<String, Double> DRIdict)
	{
	    if (DRIdict == null)
	        return null;
	    HashMap<String, Double> DRIdict2 = new HashMap<String, Double>();
	    DRIdict2.putAll(DRIdict);
	    
	    HashMap<String, HashMap<String, Object>> nutrientInfos = getNutrientInfoAs2LevelDictionary_withNutrientIds(null);
	    Object[] keys = DRIdict2.keySet().toArray();
	    
	    for(int i=0; i<keys.length; i++){
	        String key = (String)keys[i];
	        assert(key!=null);
	        Double driVal = DRIdict2.get(key);
	        HashMap<String, Object> nutrientInfo = nutrientInfos.get(key);
	        assert(nutrientInfo!=null);
	        Double dblObj_LossRate = (Double)nutrientInfo.get(Constants.COLUMN_NAME_LossRate);
	
	        double driV2 = driVal.doubleValue();
	        if (driVal.doubleValue()>0){
	        	if (dblObj_LossRate.doubleValue()>0)
		            driV2 = driVal.doubleValue() / (1.0-dblObj_LossRate.doubleValue());
	        }
	        
	        DRIdict2.put(key, Double.valueOf(driV2));
	    }
	    Log.d(LogTag, "letDRIULConsiderLoss ret:"+DRIdict2.toString());
	    return DRIdict2;
	}
	
	//------------------------------------------------------------------------------------------
	
	
	/*
	 options contain: flag varBeParamWay(contrary is varDirectInSql)
	 filters contain:
	   includeOR AND (cond1 OR cond2 OR cond3 ...)
	     expressionItemsArray
	       column1 op1 values1
	       column2 op2 values2
	   includeAND AND cond1 AND cond2 AND cond3 ...
	     expressionItemsArray
	       column1 op1 values1
	       column2 op2 values2
	   exclude --  AND NOT cond1 AND NOT cond2 AND NOT cond3 ...
	     expressionItemsArray
	       column1 op1 values1
	       column2 op2 values2
	 
	 op can be = , like, in
	 */
	public ArrayList<HashMap<String, Object>> getRowsByQuery(String strQuery,HashMap<String, Object> filters ,boolean ifWhereExistInQuery,String afterWherePart,HashMap<String, Object> options)
	{
		HashMap<String, Object> filtersDict = new HashMap<String, Object>();
		filtersDict.putAll(filters);
		filtersDict.put("needWhereWord", Boolean.valueOf(!ifWhereExistInQuery));
		
		HashMap<String, Object> conditionData = getConditionsPart_withFilters(filtersDict,options);
    	String strCondition = (String) conditionData.get("strCondition");
    	@SuppressWarnings("unchecked")
		ArrayList<String> sqlParams = (ArrayList<String>)(conditionData.get("sqlParams"));
    	StringBuffer sbWholeQuery = new StringBuffer();
    	sbWholeQuery.append(strQuery);
    	sbWholeQuery.append(strCondition);
	    if (afterWherePart!= null && afterWherePart.length()>0) 
	    	sbWholeQuery.append(afterWherePart);

	    String[] sqlParamAry = Tool.convertToStringArray(sqlParams.toArray());
	    Log.d(LogTag, "getRowsByQuery sbWholeQuery="+sbWholeQuery+",\nsqlParamAry="+sqlParamAry);
	    Cursor cs = mDBcon.rawQuery(sbWholeQuery.toString(),sqlParamAry);
	    ArrayList<HashMap<String, Object>> dataAry = Tool.getRowsWithTypeFromCursor(cs);
	    cs.close();
	    Log.d(LogTag, "getRowsByQuery ret:"+dataAry);
	    return dataAry;
	}
	
	/*
	 options contain: flag varBeParamWay(contrary is varDirectInSql)
	 filters contain:
	   flag needWhereWord
	   includeOR AND (cond1 OR cond2 OR cond3 ...)
	     expressionItemsArray
	       column1 op1 values1
	       column2 op2 values2
	   includeAND AND cond1 AND cond2 AND cond3 ...
	     expressionItemsArray
	       column1 op1 values1
	       column2 op2 values2
	   exclude --  AND NOT cond1 AND NOT cond2 AND NOT cond3 ...
	     expressionItemsArray
	       column1 op1 values1
	       column2 op2 values2
	 
	 op can be = , like, in
	 */
	HashMap<String, Object> getConditionsPart_withFilters(HashMap<String, Object> filters ,HashMap<String, Object> options)
	{
		Log.d(LogTag, "getConditionsPart_withFilters enter, filters="+filters+", options="+options);
		assert (filters != null);
			
	    Boolean obj_needWhereWord = (Boolean)filters.get("needWhereWord");
	    boolean needWhereWord = false;
	    if (obj_needWhereWord!=null)
	        needWhereWord = obj_needWhereWord.booleanValue();
	    StringBuffer sbConditions = new StringBuffer(10000);
	    ArrayList<String> sqlParams = new ArrayList<String>(100);
	    if (needWhereWord){
	    	sbConditions.append("\n WHERE 1=1");
	    }
	    @SuppressWarnings("unchecked")
	    ArrayList<ArrayList<Object>> includeORdata = (ArrayList<ArrayList<Object>>) (filters.get("includeOR")) ;
	    @SuppressWarnings("unchecked")
	    ArrayList<ArrayList<Object>> includeANDdata = (ArrayList<ArrayList<Object>>)( filters.get("includeAND") );
	    @SuppressWarnings("unchecked")
	    ArrayList<ArrayList<Object>> excludeData = (ArrayList<ArrayList<Object>>)( filters.get("exclude") );

	    if (includeORdata!=null && includeORdata.size()>0){
	    	Boolean obj_NotFlag = Boolean.valueOf(false);
	    	ArrayList<ArrayList<Object>> expressionItemsArray = new ArrayList<ArrayList<Object>>(includeORdata.size());
	    	for(int i=0; i<includeORdata.size(); i++){
	    		ArrayList<Object> expressionItems = includeORdata.get(i);
	    		ArrayList<Object> expressionItems2 = new ArrayList<Object>(expressionItems.size()+1);
	    		expressionItems2.add(obj_NotFlag);
	    		expressionItems2.addAll(expressionItems);
	    		expressionItemsArray.add(expressionItems2);
	    	}//for i
	    	HashMap<String, Object> unitConditionData = getBigUnitCondition_withExpressionItems(expressionItemsArray,"OR",options);
	    	String unitCondition = (String) unitConditionData.get("strCondition");
	    	@SuppressWarnings("unchecked")
	    	ArrayList<String> localSqlParams = (ArrayList<String>)(unitConditionData.get("sqlParams"));
	    	sbConditions.append(" AND ("+unitCondition+")");
	    	sqlParams.addAll(localSqlParams);
	    }
	    
	    if (includeANDdata!=null && includeANDdata.size()>0){
	    	Boolean obj_NotFlag = Boolean.valueOf(false);
	    	ArrayList<ArrayList<Object>> expressionItemsArray = new ArrayList<ArrayList<Object>>(includeANDdata.size());
	    	for(int i=0; i<includeANDdata.size(); i++){
	    		ArrayList<Object> expressionItems = includeANDdata.get(i);
	    		ArrayList<Object> expressionItems2 = new ArrayList<Object>(expressionItems.size()+1);
	    		expressionItems2.add(obj_NotFlag);
	    		expressionItems2.addAll(expressionItems);
	    		expressionItemsArray.add(expressionItems2);
	    	}//for i
	    	HashMap<String, Object> unitConditionData = getBigUnitCondition_withExpressionItems(expressionItemsArray,"AND",options);
	    	String unitCondition = (String) unitConditionData.get("strCondition");
	    	@SuppressWarnings("unchecked")
	    	ArrayList<String> localSqlParams = (ArrayList<String>)(unitConditionData.get("sqlParams"));
	    	sbConditions.append(" AND ("+unitCondition+")");
	    	sqlParams.addAll(localSqlParams);
	    }
	    
	    if (excludeData!=null && excludeData.size()>0){
	    	Boolean obj_NotFlag = Boolean.valueOf(true);
	    	ArrayList<ArrayList<Object>> expressionItemsArray = new ArrayList<ArrayList<Object>>(excludeData.size());
	    	for(int i=0; i<excludeData.size(); i++){
	    		ArrayList<Object> expressionItems = excludeData.get(i);
	    		ArrayList<Object> expressionItems2 = new ArrayList<Object>(expressionItems.size()+1);
	    		expressionItems2.add(obj_NotFlag);
	    		expressionItems2.addAll(expressionItems);
	    		expressionItemsArray.add(expressionItems2);
	    	}//for i
	    	HashMap<String, Object> unitConditionData = getBigUnitCondition_withExpressionItems(expressionItemsArray,"AND",options);
	    	String unitCondition = (String) unitConditionData.get("strCondition");
	    	@SuppressWarnings("unchecked")
	    	ArrayList<String> localSqlParams = (ArrayList<String>)(unitConditionData.get("sqlParams"));
	    	sbConditions.append(" AND ("+unitCondition+")");
	    	sqlParams.addAll(localSqlParams);
	    }

	    HashMap<String, Object> hmRet = new HashMap<String, Object>();
	    hmRet.put("strCondition", sbConditions.toString());
	    hmRet.put("sqlParams", sqlParams);
	    
	    Log.d(LogTag, "getConditionsPart_withFilters ret:"+hmRet);
	    return hmRet;
	}

	/*
	 options contain: flag varBeParamWay(contrary is varDirectInSql)
	 expressionItemsArray format:  [notFlag1 column1 op1 values1],[notFlag1 column1 op1 values1]
	 */
	HashMap<String, Object> getBigUnitCondition_withExpressionItems(ArrayList<ArrayList<Object>> expressionItemsArray,String joinBoolOp,HashMap<String, Object> options)
	{
		Log.d(LogTag, "getBigUnitCondition_withExpressionItems enter, expressionItemsArray="+expressionItemsArray+", joinBoolOp="+joinBoolOp);
//		boolean varBeParamWay = false;
//		if (options!=null){
//			Boolean obj_varBeParamWay = (Boolean)options.get("varBeParamWay");
//			if (obj_varBeParamWay != null)
//				varBeParamWay = obj_varBeParamWay.booleanValue();
//		}
	    
	    assert(joinBoolOp!=null && joinBoolOp.length()>0);
	    assert(expressionItemsArray.size()>0);
	    StringBuffer sbCondition = new StringBuffer(1000);
	    ArrayList<String> sqlParams = new ArrayList<String>(100);

	    boolean firstInnerConditionAdd = false;
	    for(int i=0; i<expressionItemsArray.size(); i++){
	    	ArrayList<Object> expressionItems = expressionItemsArray.get(i);
	        assert(expressionItems.size()==4);
	        HashMap<String, Object> unitConditionData = getMediumUnitCondition_withExpressionItems(expressionItems ,joinBoolOp ,options);
	        String unitCondition = (String) unitConditionData.get("strCondition");
	        @SuppressWarnings("unchecked")
	    	ArrayList<String> localSqlParams = (ArrayList<String>)(unitConditionData.get("sqlParams"));
	        if (firstInnerConditionAdd){
	        	sbCondition.append(" "+joinBoolOp+" ");
	        }else{
	            firstInnerConditionAdd = true;
	        }
	        sbCondition.append("("+unitCondition+")");
	        sqlParams.addAll(localSqlParams);
	    }
	    HashMap<String, Object> hmRet = new HashMap<String, Object>();
	    hmRet.put("strCondition", sbCondition.toString());
	    hmRet.put("sqlParams", sqlParams);
	    
	    Log.d(LogTag, "getBigUnitCondition_withExpressionItems ret:"+hmRet);
	    return hmRet;
	}
	
	/*
	 notFlag1 column1 op1 values1
	 */
	@SuppressWarnings("unchecked")
	HashMap<String, Object> getMediumUnitCondition_withExpressionItems(ArrayList<Object> expressionItems,String joinBoolOp ,HashMap<String, Object> options)
	{
		Log.d(LogTag, "getMediumUnitCondition_withExpressionItems enter, expressionItems="+expressionItems+", joinBoolOp="+joinBoolOp);
		
//		boolean varBeParamWay = false;
//		if (options!=null){
//			Boolean obj_varBeParamWay = (Boolean)options.get("varBeParamWay");
//			if (obj_varBeParamWay != null)
//				varBeParamWay = obj_varBeParamWay.booleanValue();
//		}
	    
	    assert(expressionItems.size()==4);
	    Boolean objNotFlag = (Boolean)expressionItems.get(0);
	    String strColumn = (String)expressionItems.get(1);
	    String strOp = (String)expressionItems.get(2);
	    Object valObj = expressionItems.get(3);
	    ArrayList<Object> values = null;
	    if (valObj instanceof Object[]){
	    	Object[] valAry = (Object[])valObj;
	    	values = Tool.convertFromArrayToList(valAry);
	    }else if(valObj instanceof String[]){
	    	String[] valStrAry = (String[])valObj;
	    	ArrayList<String> valStrList = Tool.convertFromArrayToList(valStrAry);
	    	values = new ArrayList<Object>();
	    	values.addAll(valStrList);
	    }else{
	    	values = (ArrayList<Object>) valObj;
	    }
	    assert(objNotFlag!=null);
	    assert(joinBoolOp!=null && joinBoolOp.length()>0);
	    assert(strColumn!=null && strColumn.length()>0);
	    assert(strOp!=null && strOp.length()>0);
	    assert(values != null && values.size() > 0);
	    
	    StringBuffer sbCondition = new StringBuffer(100);
	    ArrayList<String> sqlParams = new ArrayList<String>(10);
	    boolean firstInnerConditionAdd = false;
	    if ("IN".equalsIgnoreCase(strOp)){
	    	HashMap<String, Object> unitConditionData = getUnitCondition_withColumn(strColumn,strOp,values,objNotFlag.booleanValue(),options);
	    	String unitCondition = (String) unitConditionData.get("strCondition");
	    	@SuppressWarnings("unchecked")
	    	ArrayList<String> localSqlParams = (ArrayList<String>)(unitConditionData.get("sqlParams"));
	    	sbCondition.append(unitCondition);
	    	sqlParams.addAll(localSqlParams);
	    }else{
	        for(int i=0 ; i<values.size(); i++){
	            valObj = values.get(i);
	            HashMap<String, Object> unitConditionData = getUnitCondition_withColumn(strColumn,strOp,valObj,objNotFlag.booleanValue(),options);
		    	String unitCondition = (String) unitConditionData.get("strCondition");
		    	@SuppressWarnings("unchecked")
		    	ArrayList<String> localSqlParams = (ArrayList<String>)(unitConditionData.get("sqlParams"));
	            if (firstInnerConditionAdd){
	            	sbCondition.append(" "+joinBoolOp+" ");
	            }else{
	                firstInnerConditionAdd = true;
	            }
	            sbCondition.append(unitCondition);
		    	sqlParams.addAll(localSqlParams);
	        }//for
	    }
	    HashMap<String, Object> hmRet = new HashMap<String, Object>();
	    hmRet.put("strCondition", sbCondition.toString());
	    hmRet.put("sqlParams", sqlParams);
	    
	    Log.d(LogTag, "getMediumUnitCondition_withExpressionItems ret:"+hmRet);
	    return hmRet;
	}

	/*
	 注意columnName可能为 T1.columnName 的形式，而且如果columnName含有特殊字符，需在传入前自行处理，如 T1.[columnName]。
	 result contain :(NSString*) strCondition, (NSArray*)sqlParams(only 1 item at max)
	 */
	HashMap<String, Object> getUnitCondition_withColumn(String columnName,String operator,Object valObj , boolean notFlag ,HashMap<String, Object> options)
	{
		Log.d(LogTag, "getUnitCondition_withColumn enter, columnName="+columnName+", operator="+operator+", valObj="+valObj+", notFlag="+notFlag);
		
		boolean varBeParamWay = false;
		if (options!=null){
			Boolean obj_varBeParamWay = (Boolean)options.get("varBeParamWay");
			if (obj_varBeParamWay != null)
				varBeParamWay = obj_varBeParamWay.booleanValue();
		}
	    
	    assert(columnName!=null);
	    assert(operator!=null);
	    assert(valObj!=null);
	    StringBuffer sbCondition = new StringBuffer(100);
	    ArrayList<String> sqlParams = new ArrayList<String>(10);

	    if (notFlag)
	    	sbCondition.append("NOT ");
	    sbCondition.append(" "+columnName+" "+operator+" ");
//	    sbCondition.append(" ["+columnName+"] "+operator+" ");//let param deal it
	    if (varBeParamWay){
	    	sbCondition.append("?");
	    	sqlParams.add(valObj.toString());
	    }else{
	    	if (valObj instanceof Double){
	    		Double valDouble = (Double)valObj;
	    		sbCondition.append(valDouble);//TODO when "LIKE"
	    	}else{
	    		String strVal = valObj.toString();
	    		strVal = strVal.replace("'", "''");
	    		if ("LIKE".equalsIgnoreCase(operator)){
	    			sbCondition.append("'"+strVal+"%'");
	    		}else{
	    			sbCondition.append("'"+strVal+"'");
	    		}

	    	}
	    }
	    
	    HashMap<String, Object> hmRet = new HashMap<String, Object>();
	    hmRet.put("strCondition", sbCondition.toString());
	    hmRet.put("sqlParams", sqlParams);
	    
	    Log.d(LogTag, "getUnitCondition_withColumn ret:"+hmRet);
	    return hmRet;
	}
	/*
	 注意columnName可能为 T1.columnName 的形式，而且如果columnName含有特殊字符，需在传入前自行处理，如 T1.[columnName]。
	 result contain :(NSString*) strCondition, (NSArray*)sqlParams
	 */
	HashMap<String, Object> getUnitCondition_withColumn(String columnName,String operator ,ArrayList<Object> values ,boolean notFlag ,HashMap<String, Object> options)
	{
		Log.d(LogTag, "getUnitCondition_withColumn enter, columnName="+columnName+", operator="+operator+", values="+values+", notFlag="+notFlag);
		
		boolean varBeParamWay = false;
		if (options!=null){
			Boolean obj_varBeParamWay = (Boolean)options.get("varBeParamWay");
			if (obj_varBeParamWay != null)
				varBeParamWay = obj_varBeParamWay.booleanValue();
		}
	    
	    assert(columnName!=null);
	    assert(operator!=null);
	    assert(values!=null && values.size()>0);
	    assert("IN".equalsIgnoreCase(operator));
	    
	    StringBuffer sbCondition = new StringBuffer(100);
	    ArrayList<String> sqlParams = new ArrayList<String>(10);
	    if (notFlag) 
	    	sbCondition.append("NOT ");
	    sbCondition.append(" "+columnName+" "+operator+" ");
//	    sbCondition.append(" ["+columnName+"] "+operator+" ");//let param deal it
	    
	    
	    if(varBeParamWay){
	    	String placeholdersStr = generatePlaceholderPartForIn(values.size());
	    	sbCondition.append("("+placeholdersStr+")");
	    	ArrayList<String> alStrValue = Tool.convertToStringArrayList(values);
	    	sqlParams.addAll(alStrValue);
	    }else{
	    	String[] strValues = Tool.convertToStringArray(values.toArray());
	        Object valObj0 = values.get(0);
	        if (valObj0 instanceof Double){
	            //assert(![columnName isEqualToString:COLUMN_NAME_NDB_No]);// 存在情况 columnName 含 NDB_No
	        	//strValues = Tool.convertToStringArray(values.toArray());
	        }else{
	            for(int i=0; i<strValues.length; i++){
	                String strVal = strValues[i];
	                strVal = strVal.replace("'", "''");
	                strVal = "'" + strVal + "'";
	                strValues[i]= strVal; 
	            }//for i
	        }
	        sbCondition.append("("+StringUtils.join(strValues,",")+")");
	    }
	    
	    HashMap<String, Object> hmRet = new HashMap<String, Object>();
	    hmRet.put("strCondition", sbCondition.toString());
	    hmRet.put("sqlParams", sqlParams);
	    
	    Log.d(LogTag, "getUnitCondition_withColumn ret:"+hmRet);
	    return hmRet;
	    
	}

	//------------------------------------------------------------------------------------------
	
	
	

	/*
	 * 这里 orderByPart 不带 ORDER BY
	 * 这里不对 _like 中的值做特殊处理。 getRowsByQuery 中会对_like的值的后面加上%。如果想在前面加%，需要自行在传入值中预先设置。
	 * columnValue_sPairs_equal和columnValue_sPairs_like 中的item可以是Object[]，也可以是ArrayList. 而column所对应的value可以是Object,Object[],ArrayList。
	 */
	public ArrayList<HashMap<String, Object>> selectTableByEqualFilter_withTableName(String tableName,
			ArrayList<Object> columnValue_sPairs_equal, ArrayList<Object> columnValue_sPairs_like, 
			String[] selectColumns, String orderByPart, boolean needDistinct)
	{
		Log.d(LogTag, "selectTableByEqualFilter_withTableName enter");
		
		String columnsPart = "*";
	    if (selectColumns!=null && selectColumns.length>0){
	        columnsPart = StringUtils.join(selectColumns,",");
	    }
	    String distinctPart = "";
	    if ( needDistinct )
	        distinctPart = "DISTINCT";
	    
	    StringBuffer sbSql = new StringBuffer(1000*1);
	    sbSql.append("SELECT "+distinctPart+" "+columnsPart+" FROM "+tableName+" ");
	    
	    String afterWherePart = "";
	    if (orderByPart!=null && orderByPart.length()>0)
	    	afterWherePart += " ORDER BY "+orderByPart;

		ArrayList<ArrayList<Object>> exprIncludeANDdata = new ArrayList<ArrayList<Object>>();
		
		String strColumn, strOp;
		Object valOrValues;
		ArrayList<Object> expr, values;
	    if (columnValue_sPairs_equal!=null){
	    	for(int i=0; i<columnValue_sPairs_equal.size(); i++){
	    		Object columnValue_sPair = columnValue_sPairs_equal.get(i);
	    		if (columnValue_sPair instanceof ArrayList){
	    			ArrayList<Object> columnValue_sPair_al = (ArrayList<Object>)columnValue_sPair;
	    			strColumn = (String)columnValue_sPair_al.get(0);
		    		valOrValues = columnValue_sPair_al.get(1);
	    		}else{
	    			Object[] columnValue_sPair_ary = (Object[])columnValue_sPair;
	    			strColumn = (String)columnValue_sPair_ary[0];
		    		valOrValues = columnValue_sPair_ary[1];
	    		}
	    		
	    		if (valOrValues instanceof ArrayList){
	    			strOp = "IN";
	    			values = new ArrayList<Object>();
	    			values.addAll((ArrayList)valOrValues);
	    		}else if (valOrValues instanceof Object[]){
	    			strOp = "IN";
	    			values = new ArrayList<Object>();
	    			Object[] vals = (Object[])valOrValues;
	    			for(int j=0; j<vals.length; j++){
	    				values.add(vals[j]);
	    			}
	    		}else{
	    			strOp = "=";
	    			values = new ArrayList<Object>();
			        values.add(valOrValues);
	    		}
	    		
		        expr = new ArrayList<Object>(3);
		        expr.add(strColumn);
		        expr.add(strOp);
		        expr.add(values);
		        exprIncludeANDdata.add(expr);
	    	}
	    }

	    if (columnValue_sPairs_like!=null){
	    	for(int i=0; i<columnValue_sPairs_like.size(); i++){
	    		Object columnValue_sPair = columnValue_sPairs_like.get(i);
	    		strOp = "LIKE";
	    		
	    		if (columnValue_sPair instanceof ArrayList){
	    			ArrayList<Object> columnValue_sPair_al = (ArrayList<Object>)columnValue_sPair;
	    			strColumn = (String)columnValue_sPair_al.get(0);
		    		valOrValues = columnValue_sPair_al.get(1);
	    		}else{
	    			Object[] columnValue_sPair_ary = (Object[])columnValue_sPair;
	    			strColumn = (String)columnValue_sPair_ary[0];
		    		valOrValues = columnValue_sPair_ary[1];
	    		}
	    		
	    		values = new ArrayList<Object>();
	    		if (valOrValues instanceof ArrayList){
	    			values.addAll((ArrayList)valOrValues);
	    		}else if (valOrValues instanceof Object[]){
	    			Object[] vals = (Object[])valOrValues;
	    			for(int j=0; j<vals.length; j++){
	    				values.add(vals[j]);
	    			}
	    		}else{
			        values.add(valOrValues);
	    		}
	    		
		        expr = new ArrayList<Object>(3);
		        expr.add(strColumn);
		        expr.add(strOp);
		        expr.add(values);
		        exprIncludeANDdata.add(expr);
	    	}
	    }
	    
	    HashMap<String, Object> filters = new HashMap<String, Object>();
	    filters.put("includeAND", exprIncludeANDdata);

	    HashMap<String, Object> localOptions = new HashMap<String, Object>();
	    localOptions.put("varBeParamWay", Boolean.valueOf(false));
	    ArrayList<HashMap<String, Object>> dataAry = getRowsByQuery(sbSql.toString(), filters, false, afterWherePart, localOptions);
	    Log.d(LogTag, "selectTableByEqualFilter_withTableName return");
	    return dataAry;
	}
	
	/*
	 fieldOpValuePairs 中的op可以是 = , IN , LIKE , 比较运算符; 其中的Value 可以是单个值也可以是数组。
	 orderByPart 不带 ORDER BY 部分。
	 */
	public ArrayList<HashMap<String, Object>> selectTable_byFieldOpValuePairs(ArrayList<Object> fieldOpValuePairs, String tableName,
			String[] selectColumns, String orderByPart, boolean needDistinct)
	{
		Log.d(LogTag, "selectTable_byFieldOpValuePairs enter");
		
		String columnsPart = "*";
	    if (selectColumns!=null && selectColumns.length>0){
	        columnsPart = StringUtils.join(selectColumns,",");
	    }
	    String distinctPart = "";
	    if ( needDistinct )
	        distinctPart = "DISTINCT";
	    
	    StringBuffer sbSql = new StringBuffer(1000*1);
	    sbSql.append("SELECT "+distinctPart+" "+columnsPart+" FROM "+tableName+" ");
	    
	    String afterWherePart = "";
	    if (orderByPart!=null && orderByPart.length()>0)
	    	afterWherePart += " ORDER BY "+orderByPart;

		ArrayList<ArrayList<Object>> exprIncludeANDdata = new ArrayList<ArrayList<Object>>();
		
		String strColumn, strOp;
		Object valOrValues;
		ArrayList<Object> expr, values;
	    if (fieldOpValuePairs!=null){
	    	for(int i=0; i<fieldOpValuePairs.size(); i++){
	    		Object fieldOpValuePair = fieldOpValuePairs.get(i);
	    		if (fieldOpValuePair instanceof ArrayList){
	    			ArrayList<Object> fieldOpValuePair_al = (ArrayList<Object>)fieldOpValuePair;
	    			strColumn = (String)fieldOpValuePair_al.get(0);
	    			strOp = (String)fieldOpValuePair_al.get(1);
		    		valOrValues = fieldOpValuePair_al.get(2);
	    		}else{
	    			Object[] fieldOpValuePair_ary = (Object[])fieldOpValuePair;
	    			strColumn = (String)fieldOpValuePair_ary[0];
	    			strOp = (String)fieldOpValuePair_ary[1];
		    		valOrValues = fieldOpValuePair_ary[2];
	    		}
	    		
	    		if (valOrValues instanceof ArrayList){
	    			values = new ArrayList<Object>();
	    			values.addAll((ArrayList)valOrValues);
	    		}else if (valOrValues instanceof Object[]){
	    			values = new ArrayList<Object>();
	    			Object[] vals = (Object[])valOrValues;
	    			for(int j=0; j<vals.length; j++){
	    				values.add(vals[j]);
	    			}
	    		}else{
	    			values = new ArrayList<Object>();
			        values.add(valOrValues);
	    		}
	    		
		        expr = new ArrayList<Object>(3);
		        expr.add(strColumn);
		        expr.add(strOp);
		        expr.add(values);
		        exprIncludeANDdata.add(expr);
	    	}
	    }
	    
	    HashMap<String, Object> filters = new HashMap<String, Object>();
	    filters.put("includeAND", exprIncludeANDdata);

	    HashMap<String, Object> localOptions = new HashMap<String, Object>();
	    localOptions.put("varBeParamWay", Boolean.valueOf(false));
	    ArrayList<HashMap<String, Object>> dataAry = getRowsByQuery(sbSql.toString(), filters, false, afterWherePart, localOptions);
	    Log.d(LogTag, "selectTable_byFieldOpValuePairs return");
	    return dataAry;
	}


	
	
	public HashMap<String, Object> getOneRichNutritionFood(String nutrientAsColumnName,String includeFoodClass,String excludeFoodClass,String[] includeFoodIds,String[] excludeFoodIds,String getStrategy,boolean ifNeedCustomDefinedFoods)
	{
		ArrayList<HashMap<String, Object>> foodAry = getRichNutritionFood(nutrientAsColumnName,includeFoodClass,excludeFoodClass,includeFoodIds,excludeFoodIds,0 ,ifNeedCustomDefinedFoods);
	    if (foodAry==null || foodAry.size() == 0)
	        return null;
	    if (Constants.Strategy_random.equalsIgnoreCase(getStrategy) && foodAry.size()>1){
	    	int idx = Tool.getRandObj().nextInt(foodAry.size());
	    	return foodAry.get(idx);
	    }else{
	    	return foodAry.get(0);
	    }
	}
	public ArrayList<HashMap<String, Object>> getFoodsOfRichNutritionAndIntersectGivenSet_withNutrient(String nutrientAsColumnName,String[] givenFoodIds,boolean ifNeedCustomDefinedFoods)
	{
	    Log.d(LogTag, "getFoodsOfRichNutritionAndIntersectGivenSet_withNutrient enter");
	    if (givenFoodIds==null || givenFoodIds.length == 0)
	        return null;
	    return getRichNutritionFood(nutrientAsColumnName,null,null,givenFoodIds,null,0,ifNeedCustomDefinedFoods);
	}
	
	public ArrayList<HashMap<String, Object>> getRichNutritionFoodForNutrient(String nutrientName,double nutrientAmount,boolean ifNeedCustomDefinedFoods)
	{
		ArrayList<HashMap<String, Object>> foods = getRichNutritionFood(nutrientName,0,ifNeedCustomDefinedFoods);
	    
	    for(int i=0; i<foods.size(); i++){
	    	HashMap<String, Object> food = foods.get(i);
	        Double dObj_foodNutrientStandard =  (Double)food.get(nutrientName);
	        if (dObj_foodNutrientStandard.doubleValue()!=0.0){
	            double dFoodAmount = nutrientAmount/ dObj_foodNutrientStandard.doubleValue() * 100.0;
	            food.put(Constants.Key_Amount, Double.valueOf(dFoodAmount));
	        }else{
	            //do nothing, then get will obtain null, though should not
	        }
	    }
	    return foods;
	}
	
	public ArrayList<HashMap<String, Object>> getRichNutritionFood2_withAmount_ForNutrient(String nutrientName,double nutrientAmount)
	{
		ArrayList<HashMap<String, Object>> foods = getRichNutritionFood2(nutrientName);
	    
	    for(int i=0; i<foods.size(); i++){
	    	HashMap<String, Object> food = foods.get(i);
	        Double dObj_foodNutrientStandard =  (Double)food.get(nutrientName);
	        if (dObj_foodNutrientStandard.doubleValue()!=0.0){
	            double dFoodAmount = nutrientAmount/ dObj_foodNutrientStandard.doubleValue() * 100.0;
	            food.put(Constants.Key_Amount, Double.valueOf(dFoodAmount));
	        }else{
	            //do nothing, then get will obtain null, though should not
	        }
	    }
//	    Log.d(LogTag, "getRichNutritionFood2_withAmount_ForNutrient return="+Tool.getIndentFormatStringOfObject(foods,0));
	    return foods;
	}
	public ArrayList<HashMap<String, Object>> getRichNutritionFood2(String nutrientAsColumnName)
	{
		Log.d(LogTag, "getRichNutritionFood2 enter, nutrientAsColumnName="+nutrientAsColumnName);
		StringBuffer sbSql = new StringBuffer(1000);
		//看来如果sql语句中用了view，会有FL.[Lower_Limit(g)]等某些列整个成为列名,而且就算是[Lower_Limit(g)]，也还会保留[].而如果没有用到view，则Lower_Limit(g)是列名
		sbSql.append("SELECT F.*,CnCaption,CnType,classify ,FC.[Lower_Limit(g)],FC.[Upper_Limit(g)],FC.normal_value,FC.first_recommend,FC.increment_unit,FC.PicPath, SingleItemUnitName,SingleItemUnitWeight");
		sbSql.append("\n  FROM FoodNutrition F join FoodCustom FC on F.NDB_No=FC.NDB_No ");
//		sbSql.append("\n    JOIN Food_Supply_DRI_Amount D on F.NDB_No=D.NDB_No ");
		sbSql.append("\n    JOIN CustomRichFood2 CRF ON FC.NDB_No=CRF.NDB_No AND CRF.NutrientId='"+nutrientAsColumnName+"' \n");
		
		ArrayList<ArrayList<Object>> exprIncludeORdata = new ArrayList<ArrayList<Object>>();
		ArrayList<ArrayList<Object>> exprIncludeANDdata = new ArrayList<ArrayList<Object>>();
		ArrayList<ArrayList<Object>> exprExcludedata = new ArrayList<ArrayList<Object>>();
		String strColumn, strOp;
		ArrayList<Object> expr, values;
	    
//	    strColumn = "D.["+nutrientAsColumnName+"]";
//	    strOp = ">";
//	    expr = new ArrayList<Object>(3);
//	    expr.add(strColumn);
//	    expr.add(strOp);
//	    values = new ArrayList<Object>();
//	    values.add(Integer.valueOf(0));
//	    expr.add(values);
//	    exprIncludeANDdata.add(expr);
//
//	    strColumn = "D.["+nutrientAsColumnName+"]";
//	    strOp = "<";
//	    expr = new ArrayList<Object>(3);
//	    expr.add(strColumn);
//	    expr.add(strOp);
//	    values = new ArrayList<Object>();
//	    values.add(Integer.valueOf(1000));
//	    expr.add(values);
//	    exprIncludeANDdata.add(expr);

	    StringBuffer sb_afterWherePart = new StringBuffer();
//	    sb_afterWherePart.append("\n ORDER BY D.["+nutrientAsColumnName+"] ASC");
	    
	    HashMap<String, Object> filters = new HashMap<String, Object>();
	    filters.put("includeOR", exprIncludeORdata);
	    filters.put("includeAND", exprIncludeANDdata);
	    filters.put("exclude", exprExcludedata);
	    HashMap<String, Object> localOptions = new HashMap<String, Object>();
	    localOptions.put("varBeParamWay", Boolean.valueOf(false));
	    ArrayList<HashMap<String, Object>> dataAry = getRowsByQuery(sbSql.toString(), filters, false, sb_afterWherePart.toString(), localOptions);
	    Log.d(LogTag, "getRichNutritionFood return");
	    return dataAry;
	}
	
	/*
	 取富含某种营养素的前n个食物的清单
	 */
	public ArrayList<HashMap<String, Object>> getRichNutritionFood(String nutrientAsColumnName, int topN, boolean ifNeedCustomDefinedFoods)
	{
	    return getRichNutritionFood(nutrientAsColumnName,null,null,null,null,topN,ifNeedCustomDefinedFoods);
	}
	
	/*
	 取富含某种营养素的前n个食物的清单
	 注意food的class是一个树结构
	 */
	public ArrayList<HashMap<String, Object>> getRichNutritionFood(String nutrientAsColumnName, String includeFoodClass, String excludeFoodClass,
			String[] includeFoodIds, String[] excludeFoodIds, int topN, boolean ifNeedCustomDefinedFoods)
	{
		Log.d(LogTag, "getRichNutritionFood enter, nutrientAsColumnName="+nutrientAsColumnName+", includeFoodClass="+includeFoodClass+", excludeFoodClass="+excludeFoodClass
				+", includeFoodIds="+includeFoodIds+", excludeFoodIds="+excludeFoodIds);
		StringBuffer sbSql = new StringBuffer(1000);
		//看来如果sql语句中用了view，会有FL.[Lower_Limit(g)]等某些列整个成为列名,而且就算是[Lower_Limit(g)]，也还会保留[].而如果没有用到view，则Lower_Limit(g)是列名
		sbSql.append("SELECT F.*,CnCaption,CnType,classify ,FC.[Lower_Limit(g)],FC.[Upper_Limit(g)],FC.normal_value,FC.first_recommend,FC.increment_unit,FC.PicPath, SingleItemUnitName,SingleItemUnitWeight, ");
		sbSql.append("\n D.["+nutrientAsColumnName+"] AS RichLevel ");
		sbSql.append("\n  FROM FoodNutrition F join FoodCustom FC on F.NDB_No=FC.NDB_No JOIN Food_Supply_DRI_Amount D on F.NDB_No=D.NDB_No ");
		if (ifNeedCustomDefinedFoods){
			sbSql.append("\n    JOIN CustomRichFood CRF ON FC.NDB_No=CRF.NDB_No AND CRF.NutrientId='"+nutrientAsColumnName+"' \n");
		}

		ArrayList<ArrayList<Object>> exprIncludeORdata = new ArrayList<ArrayList<Object>>();
		ArrayList<ArrayList<Object>> exprIncludeANDdata = new ArrayList<ArrayList<Object>>();
		ArrayList<ArrayList<Object>> exprExcludedata = new ArrayList<ArrayList<Object>>();
		String strColumn, strOp;
		ArrayList<Object> expr, values;
	    
	    strColumn = "D.["+nutrientAsColumnName+"]";
	    strOp = ">";
	    expr = new ArrayList<Object>(3);
	    expr.add(strColumn);
	    expr.add(strOp);
	    values = new ArrayList<Object>();
	    values.add(Integer.valueOf(0));
	    expr.add(values);
	    exprIncludeANDdata.add(expr);

	    strColumn = "D.["+nutrientAsColumnName+"]";
	    strOp = "<";
	    expr = new ArrayList<Object>(3);
	    expr.add(strColumn);
	    expr.add(strOp);
	    values = new ArrayList<Object>();
	    values.add(Integer.valueOf(1000));
	    expr.add(values);
	    exprIncludeANDdata.add(expr);

	    if (includeFoodClass!=null && includeFoodClass.length()>0){
	    	strColumn = Constants.COLUMN_NAME_classify;
		    strOp = "LIKE";
		    expr = new ArrayList<Object>(3);
		    expr.add(strColumn);
		    expr.add(strOp);
		    values = new ArrayList<Object>();
		    values.add(includeFoodClass);
		    expr.add(values);
		    exprIncludeANDdata.add(expr);
	    }

	    if (excludeFoodClass!=null && excludeFoodClass.length() > 0){
	    	strColumn = Constants.COLUMN_NAME_classify;
		    strOp = "LIKE";
		    expr = new ArrayList<Object>(3);
		    expr.add(strColumn);
		    expr.add(strOp);
		    values = new ArrayList<Object>();
		    values.add(excludeFoodClass);
		    expr.add(values);
		    exprExcludedata.add(expr);
	    }

	    if (includeFoodIds!=null && includeFoodIds.length>0){
	    	strColumn = "F.NDB_No";
		    strOp = "IN";
		    expr = new ArrayList<Object>(3);
		    expr.add(strColumn);
		    expr.add(strOp);
		    values = new ArrayList<Object>();
		    values.addAll(Tool.convertFromArrayToList(includeFoodIds));
		    expr.add(values);
		    exprIncludeANDdata.add(expr);
	    }
	    if (excludeFoodIds!=null && excludeFoodIds.length>0){
	    	strColumn = "F.NDB_No";
		    strOp = "IN";
		    expr = new ArrayList<Object>(3);
		    expr.add(strColumn);
		    expr.add(strOp);
		    values = new ArrayList<Object>();
		    values.addAll(Tool.convertFromArrayToList(excludeFoodIds));
		    expr.add(values);
		    exprExcludedata.add(expr);
	    }

	    StringBuffer sb_afterWherePart = new StringBuffer();
	    sb_afterWherePart.append("\n ORDER BY D.["+nutrientAsColumnName+"] ASC");
	    if (topN > 0){
	    	sb_afterWherePart.append("\n LIMIT "+topN);
	    }
	    
	    HashMap<String, Object> filters = new HashMap<String, Object>();
	    filters.put("includeOR", exprIncludeORdata);
	    filters.put("includeAND", exprIncludeANDdata);
	    filters.put("exclude", exprExcludedata);
	    HashMap<String, Object> localOptions = new HashMap<String, Object>();
	    localOptions.put("varBeParamWay", Boolean.valueOf(false));
	    ArrayList<HashMap<String, Object>> dataAry = getRowsByQuery(sbSql.toString(), filters, false, sb_afterWherePart.toString(), localOptions);
	    Log.d(LogTag, "getRichNutritionFood return");
	    return dataAry;
	}
	

	ArrayList<String> getFoodIdsByFilters_withIncludeFoodClassAry(String[] includeFoodClassAry,String[] excludeFoodClassAry,String[] includeEqualFoodClassAry,String[] includeFoodIds,String[] excludeFoodIds)
	{
		StringBuffer sbSql = new StringBuffer(1000);
		sbSql.append("SELECT F.NDB_No \n");
		sbSql.append("  FROM FoodNutrition F join FoodCustom FC on F.NDB_No=FC.NDB_No \n");
		
		ArrayList<ArrayList<Object>> exprIncludeORdata = new ArrayList<ArrayList<Object>>();
		ArrayList<ArrayList<Object>> exprIncludeANDdata = new ArrayList<ArrayList<Object>>();
		ArrayList<ArrayList<Object>> exprExcludedata = new ArrayList<ArrayList<Object>>();
		String strColumn, strOp;
		ArrayList<Object> expr, values;
	    
	    if (includeFoodClassAry==null && includeFoodClassAry.length > 0){
	        strColumn = Constants.COLUMN_NAME_classify;
	        strOp = "LIKE";
	        for(int i=0; i<includeFoodClassAry.length; i++){
	            String includeFoodClass = includeFoodClassAry[i];
	            expr = new ArrayList<Object>(3);
	            expr.add(strColumn);
	            expr.add(strOp);
	            values = new ArrayList<Object>();
	            values.add(includeFoodClass);
	            expr.add(values);
	            exprIncludeORdata.add(expr);
	        }
	    }
	    if (includeEqualFoodClassAry!=null && includeEqualFoodClassAry.length > 0){
	    	strColumn = Constants.COLUMN_NAME_classify;
	        strOp = "=";
	        for(int i=0; i<includeEqualFoodClassAry.length; i++){
	            String includeFoodClass = includeEqualFoodClassAry[i];
	            expr = new ArrayList<Object>(3);
	            expr.add(strColumn);
	            expr.add(strOp);
	            values = new ArrayList<Object>();
	            values.add(includeFoodClass);
	            expr.add(values);
	            exprIncludeORdata.add(expr);
	        }
	    }

	    if (includeFoodIds!=null && includeFoodIds.length>0){
	        strColumn = "F.NDB_No";
	        strOp = "IN";
	        expr = new ArrayList<Object>(3);
	        expr.add(strColumn);
	        expr.add(strOp);
	        values = new ArrayList<Object>();
	        values.addAll(Tool.convertFromArrayToList(includeFoodIds));
	        expr.add(values);
	        exprIncludeANDdata.add(expr);
	    }

	    if (excludeFoodClassAry!=null && excludeFoodClassAry.length > 0){
	        strColumn = Constants.COLUMN_NAME_classify;
	        strOp = "LIKE";
	        for(int i=0; i<excludeFoodClassAry.length; i++){
	            String excludeFoodClass = excludeFoodClassAry[i];
	            expr = new ArrayList<Object>(3);
	            expr.add(strColumn);
	            expr.add(strOp);
	            values = new ArrayList<Object>();
	            values.add(excludeFoodClass);
	            expr.add(values);
	            exprExcludedata.add(expr);
	        }
	    }
	    if (excludeFoodIds!=null && excludeFoodIds.length>0){
	        strColumn = "F.NDB_No";
	        strOp = "IN";
	        expr = new ArrayList<Object>(3);
	        expr.add(strColumn);
	        expr.add(strOp);
	        values = new ArrayList<Object>();
	        values.addAll(Tool.convertFromArrayToList(excludeFoodIds));
	        expr.add(values);
	        exprExcludedata.add(expr);
	    }
	    
	    HashMap<String, Object> filters = new HashMap<String, Object>();
	    filters.put("includeOR", exprIncludeORdata);
	    filters.put("includeAND", exprIncludeANDdata);
	    filters.put("exclude", exprExcludedata);
	    HashMap<String, Object> localOptions = new HashMap<String, Object>();
	    localOptions.put("varBeParamWay", Boolean.valueOf(false));
	    ArrayList<HashMap<String, Object>> dataAry = getRowsByQuery(sbSql.toString(), filters, false, null, localOptions);
	    ArrayList<Object> foodIdLst = Tool.getPropertyArrayListFromDictionaryArray_withPropertyName(Constants.COLUMN_NAME_NDB_No,dataAry);
	    ArrayList<String> foodIdStrLst = Tool.convertToStringArrayList(foodIdLst);
	    Log.d(LogTag, "getFoodIdsByFilters_withIncludeFoodClass ret:"+foodIdStrLst);
	    
	    return foodIdStrLst;
	}


	private HashMap<String, Object> _generateFiltersForFood(String includeFoodClass,String excludeFoodClass,String equalClass,
			String[] includeFoodIds,String[] excludeFoodIds)
	{
		ArrayList<ArrayList<Object>> exprIncludeORdata = new ArrayList<ArrayList<Object>>();
		ArrayList<ArrayList<Object>> exprIncludeANDdata = new ArrayList<ArrayList<Object>>();
		ArrayList<ArrayList<Object>> exprExcludedata = new ArrayList<ArrayList<Object>>();
		String strColumn, strOp;
		ArrayList<Object> expr, values;
	    
	    
	    if (includeFoodClass!=null && includeFoodClass.length()>0){
	        strColumn = Constants.COLUMN_NAME_classify;
	        strOp = "LIKE";
	        expr = new ArrayList<Object>(3);
	        expr.add(strColumn);
	        expr.add(strOp);
	        values = new ArrayList<Object>();
	        values.add(includeFoodClass);
	        expr.add(values);
	        exprIncludeANDdata.add(expr);
	    }
	    if (equalClass!=null && equalClass.length()>0){
	    	strColumn = Constants.COLUMN_NAME_classify;
	        strOp = "=";
	        expr = new ArrayList<Object>(3);
	        expr.add(strColumn);
	        expr.add(strOp);
	        values = new ArrayList<Object>();
	        values.add(equalClass);
	        expr.add(values);
	        exprIncludeANDdata.add(expr);
	    }
	    if (includeFoodIds!=null && includeFoodIds.length>0){
	    	strColumn = "F.NDB_No";
		    strOp = "IN";
		    expr = new ArrayList<Object>(3);
		    expr.add(strColumn);
		    expr.add(strOp);
		    values = new ArrayList<Object>();
		    values.addAll(Tool.convertFromArrayToList(includeFoodIds));
		    expr.add(values);
		    exprIncludeANDdata.add(expr);
	    }
	    
	    if (excludeFoodClass!=null && excludeFoodClass.length() > 0){
	    	strColumn = Constants.COLUMN_NAME_classify;
	        strOp = "LIKE";
	        expr = new ArrayList<Object>(3);
	        expr.add(strColumn);
	        expr.add(strOp);
	        values = new ArrayList<Object>();
	        values.add(excludeFoodClass);
	        expr.add(values);
	        exprExcludedata.add(expr);
	    }
	    if (excludeFoodIds!=null && excludeFoodIds.length>0){
	    	strColumn = "F.NDB_No";
		    strOp = "IN";
		    expr = new ArrayList<Object>(3);
		    expr.add(strColumn);
		    expr.add(strOp);
		    values = new ArrayList<Object>();
		    values.addAll(Tool.convertFromArrayToList(excludeFoodIds));
		    expr.add(values);
		    exprExcludedata.add(expr);
	    }
	    
	    HashMap<String, Object> filters = new HashMap<String, Object>();
	    filters.put("includeOR", exprIncludeORdata);
	    filters.put("includeAND", exprIncludeANDdata);
	    filters.put("exclude", exprExcludedata);
	    
		return filters;
	}
	public ArrayList<HashMap<String, Object>> getFoodsByShowingPart(String cnNamePart,String enNamePart, String cnType)
	{
		ArrayList<ArrayList<Object>> columnValuesPairs_like = new ArrayList<ArrayList<Object>>();
		if (cnNamePart!=null && cnNamePart.length()>0){
			ArrayList<Object> columnValuesPair = new ArrayList<Object>();
			columnValuesPair.add(Constants.COLUMN_NAME_CnCaption);
			columnValuesPair.add(cnNamePart);
			columnValuesPairs_like.add(columnValuesPair);
		}
		if (enNamePart!=null && enNamePart.length()>0){
			ArrayList<Object> columnValuesPair = new ArrayList<Object>();
			columnValuesPair.add(Constants.COLUMN_NAME_FoodNameEn);
			columnValuesPair.add(enNamePart);
			columnValuesPairs_like.add(columnValuesPair);
		}
		
		ArrayList<ArrayList<Object>> columnValuesPairs_equal = new ArrayList<ArrayList<Object>>();
		if (cnType!=null && cnType.length()>0){
			ArrayList<Object> columnValuesPair = new ArrayList<Object>();
			columnValuesPair.add(Constants.COLUMN_NAME_CnType);
			columnValuesPair.add(cnType);
			columnValuesPairs_equal.add(columnValuesPair);
		}
		
		return getFoodsByColumnValuePairFilter(null,columnValuesPairs_equal,null,columnValuesPairs_like);
	}


//	public ArrayList<String> getFoodCnTypesByFilters_withIncludeFoodClass(String includeFoodClass,String excludeFoodClass,String equalClass,
//			String[] includeFoodIds,String[] excludeFoodIds)
//	{
//		StringBuffer sbSql = new StringBuffer(1000*1);
//		sbSql.append("SELECT DISTINCT CnType \n");
//		sbSql.append("  FROM FoodNutrition F join FoodCustom FC on F.NDB_No=FC.NDB_No \n");
//		HashMap<String, Object> filters = _generateFiltersForFood(includeFoodClass, excludeFoodClass, equalClass, includeFoodIds, excludeFoodIds);
//	    HashMap<String, Object> localOptions = new HashMap<String, Object>();
//	    localOptions.put("varBeParamWay", Boolean.valueOf(false));
//	    ArrayList<HashMap<String, Object>> dataAry = getRowsByQuery(sbSql.toString(), filters, false, null, localOptions);
//	    ArrayList<Object> propLst = Tool.getPropertyArrayListFromDictionaryArray_withPropertyName("CnType", dataAry);
//	    ArrayList<String> strPropLst = Tool.convertToStringArrayList(propLst);
//	    Log.d(LogTag, "getFoodCnTypesByFilters_withIncludeFoodClass return");
//	    return strPropLst;
//	}
	public ArrayList<String> getFoodCnTypes()
	{
		StringBuffer sbSql = new StringBuffer(1000*1);
		sbSql.append("SELECT distinct CnType FROM FoodCustom FC  ORDER BY CnType");
		
		Cursor cs = mDBcon.rawQuery(sbSql.toString(),null);
	    ArrayList<String> cnTypes = Tool.getDataFromCursor(cs, 0);
	    cs.close();
	    
	    Log.d(LogTag, "getFoodCnTypes ret:"+cnTypes);
	    return cnTypes;
//	    ArrayList<HashMap<String, Object>> dataAry = getRowsByQuery(sbSql.toString(), null, false, null, null);
//	    ArrayList<Object> propLst = Tool.getPropertyArrayListFromDictionaryArray_withPropertyName("CnType", dataAry);
//	    ArrayList<String> strPropLst = Tool.convertToStringArrayList(propLst);
//	    Log.d(LogTag, "getFoodCnTypesByFilters_withIncludeFoodClass return");
//	    return strPropLst;
	}
	
	public ArrayList<HashMap<String, Object>> getFoodAttributesByIds(String[] idAry)
	{
		Log.d(LogTag, "getFoodAttributesByIds begin");
	    if (idAry==null || idAry.length ==0)
	        return null;

	    return getFoodsByFilters_withIncludeFoodClass(null,null,null,idAry,null);
	}
	
	public ArrayList<HashMap<String, Object>> getAllFood()
	{
		Log.d(LogTag, "getAllFood begin");
	    return getFoodsByFilters_withIncludeFoodClass(null,null,null,null,null);
	}




	public ArrayList<HashMap<String, Object>> getFoodsByFilters_withIncludeFoodClass(String includeFoodClass,String excludeFoodClass,String equalClass,
			String[] includeFoodIds,String[] excludeFoodIds)
	{
//	    if (includeFoodClass == null && excludeFoodClass == null)
//	        return null;
		StringBuffer sbSql = new StringBuffer(1000*1);
	    //看来如果sql语句中用了view，会有FL.[Lower_Limit(g)]等某些列整个成为列名,而且就算是[Lower_Limit(g)]，也还会保留[].而如果没有用到view，则Lower_Limit(g)是列名
		sbSql.append("SELECT F.*,CnCaption,CnType,classify ,FC.[Lower_Limit(g)],FC.[Upper_Limit(g)],FC.normal_value,FC.first_recommend,FC.increment_unit, FC.PicPath, SingleItemUnitName,SingleItemUnitWeight \n");
		sbSql.append("  FROM FoodNutrition F join FoodCustom FC on F.NDB_No=FC.NDB_No \n");
		
		HashMap<String, Object> filters = _generateFiltersForFood(includeFoodClass, excludeFoodClass, equalClass, includeFoodIds, excludeFoodIds);
		
	    HashMap<String, Object> localOptions = new HashMap<String, Object>();
	    localOptions.put("varBeParamWay", Boolean.valueOf(false));
	    ArrayList<HashMap<String, Object>> dataAry = getRowsByQuery(sbSql.toString(), filters, false, null, localOptions);
	    Log.d(LogTag, "getFoodsByFilters_withIncludeFoodClass return");
	    return dataAry;
	}

	HashMap<String, Object> getOneFoodByFilters_withIncludeFoodClass(String includeFoodClass,String excludeFoodClass,String equalClass,String[] includeFoodIds,String[] excludeFoodIds)
	{
	    ArrayList<HashMap<String, Object>> foods = getFoodsByFilters_withIncludeFoodClass(includeFoodClass,excludeFoodClass,equalClass,includeFoodIds,excludeFoodIds);
	    if(foods== null || foods.size()==0)
	        return null;
	    if(foods.size()==1)
	        return foods.get(0);
	    int idx = Tool.getRandObj().nextInt(foods.size()) ;
	    return foods.get(idx);
	}
	HashMap<String, Object> getOneFoodByFilters_withIncludeFoodClass(String includeFoodClass,String excludeFoodClass,String[] includeFoodIds,String[] excludeFoodIds)
	{
//		ArrayList<HashMap<String, Object>> foods = getFoodsByFilters_withIncludeFoodClass(includeFoodClass,excludeFoodClass,null,includeFoodIds,excludeFoodIds);
//		if(foods== null || foods.size()==0)
//	        return null;
//	    if(foods.size()==1)
//	        return foods.get(0);
//	    int idx = Tool.getRandObj().nextInt(foods.size()) ;
//	    return foods.get(idx);
		return getOneFoodByFilters_withIncludeFoodClass(includeFoodClass,excludeFoodClass,null,includeFoodIds,excludeFoodIds);
	}


	/*
	 * 这里的like是会给val前面加%，里层的函数默认会给val后面加%，这样val的前后都有%
	 */
	public ArrayList<HashMap<String, Object>> getFoodsByColumnValuePairFilter(String[][] columnValuePairs_equal,ArrayList<ArrayList<Object>> columnValuesPairs_equal, 
			String[][] columnValuePairs_like,ArrayList<ArrayList<Object>> columnValuesPairs_like)
	{
		Log.d(LogTag, "getFoodsByColumnValuePairFilter enter");
		StringBuffer sbSql = new StringBuffer(1000*1);
		sbSql.append("SELECT F.*,CnCaption,CnType,classify ,FC.[Lower_Limit(g)],FC.[Upper_Limit(g)],FC.normal_value,FC.first_recommend,FC.increment_unit, FC.PicPath, SingleItemUnitName,SingleItemUnitWeight \n");
		sbSql.append("  FROM FoodNutrition F join FoodCustom FC on F.NDB_No=FC.NDB_No \n");

		ArrayList<ArrayList<Object>> exprIncludeANDdata = new ArrayList<ArrayList<Object>>();
		
		String strColumn, strOp;
		ArrayList<Object> expr, values;
	    if (columnValuePairs_equal!=null){
	    	for(int i=0; i<columnValuePairs_equal.length; i++){
	    		String[] columnValuePair = columnValuePairs_equal[i];
	    		
	    		strColumn = columnValuePair[0];
		        strOp = "=";
		        String val = columnValuePair[1];
		        expr = new ArrayList<Object>(3);
		        expr.add(strColumn);
		        expr.add(strOp);
		        values = new ArrayList<Object>();
		        values.add(val);
		        expr.add(values);
		        exprIncludeANDdata.add(expr);
	    	}
	    }
	    if (columnValuesPairs_equal!=null){
	    	for(int i=0; i<columnValuesPairs_equal.size(); i++){
	    		ArrayList<Object> columnValuesPair = columnValuesPairs_equal.get(i);
	    		
	    		strColumn = (String)columnValuesPair.get(0);
	    		Object valOrValues = columnValuesPair.get(1);
	    		if (valOrValues instanceof ArrayList){
	    			strOp = "IN";
	    			values = new ArrayList<Object>();
	    			values.addAll((ArrayList)valOrValues);
	    		}else{
	    			strOp = "=";
	    			values = new ArrayList<Object>();
			        values.add(valOrValues);
	    		}
	    		
		        expr = new ArrayList<Object>(3);
		        expr.add(strColumn);
		        expr.add(strOp);
		        expr.add(values);
		        exprIncludeANDdata.add(expr);
	    	}
	    }
	    if (columnValuePairs_like !=null){
	    	for(int i=0; i<columnValuePairs_like.length; i++){
	    		String[] columnValuePair = columnValuePairs_like[i];
	    		
	    		strColumn = columnValuePair[0];
		        strOp = "LIKE";
		        String val = columnValuePair[1];
		        expr = new ArrayList<Object>(3);
		        expr.add(strColumn);
		        expr.add(strOp);
		        values = new ArrayList<Object>();
		        values.add("%"+val);
		        expr.add(values);
		        exprIncludeANDdata.add(expr);
	    	}
	    }
	    
	    if (columnValuesPairs_like!=null){
	    	for(int i=0; i<columnValuesPairs_like.size(); i++){
	    		ArrayList<Object> columnValuesPair = columnValuesPairs_like.get(i);
	    		strOp = "LIKE";
	    		
	    		strColumn = (String)columnValuesPair.get(0);
	    		Object valOrValues = columnValuesPair.get(1);
	    		values = new ArrayList<Object>();
	    		if (valOrValues instanceof ArrayList){
//	    			values.addAll((ArrayList)valOrValues);
	    			ArrayList alVal = (ArrayList)valOrValues;
	    			for(int j=0; j<alVal.size(); j++){
	    				Object itemVal = alVal.get(i);
	    				values.add("%"+itemVal);
	    			}
	    		}else{
			        values.add("%"+valOrValues);
	    		}
	    		
		        expr = new ArrayList<Object>(3);
		        expr.add(strColumn);
		        expr.add(strOp);
		        expr.add(values);
		        exprIncludeANDdata.add(expr);
	    	}
	    }
	    
	    HashMap<String, Object> filters = new HashMap<String, Object>();
	    filters.put("includeAND", exprIncludeANDdata);

	    HashMap<String, Object> localOptions = new HashMap<String, Object>();
	    localOptions.put("varBeParamWay", Boolean.valueOf(false));
	    ArrayList<HashMap<String, Object>> dataAry = getRowsByQuery(sbSql.toString(), filters, false, null, localOptions);
	    Log.d(LogTag, "getFoodsByColumnValuePairFilter return");
	    return dataAry;
	}
	
	/*
	 * 这里是按食物内部类别排序
	 */
	public ArrayList<String> getOrderedFoodIds(String[] idAry)
	{
		Log.d(LogTag, "getOrderedFoodIds begin");
		if (idAry==null || idAry.length ==0)
	        return null;
		String placeholdersStr = generatePlaceholderPartForIn(idAry.length);
		StringBuffer sbSql = new StringBuffer(1000*100);
		sbSql.append("SELECT "+Constants.COLUMN_NAME_NDB_No+"  FROM FoodCustom \n");
		sbSql.append("  WHERE NDB_No in (" + placeholdersStr + ")\n");
		sbSql.append("  ORDER BY "+Constants.COLUMN_NAME_classify);

		Log.d(LogTag, "getOrderedFoodIds sbSql="+sbSql);
	    
		Cursor cs = mDBcon.rawQuery(sbSql.toString(),idAry);
//	    ArrayList<HashMap<String, Object>> dataAry = Tool.getRowsWithTypeFromCursor(cs);
//	    cs.close();
//	    Object[] orderedIdObjAry = Tool.getPropertyArrayFromDictionaryArray_withPropertyName(Constants.COLUMN_NAME_NDB_No, dataAry);
//	    String[] orderedIdAry = Tool.convertToStringArray(orderedIdObjAry);
//	    ArrayList<String> orderedIdAl = Tool.convertFromArrayToList(orderedIdAry);
	    
	    ArrayList<String> orderedIdAl = Tool.getDataFromCursor(cs, 0);
	    cs.close();
	    
	    Log.d(LogTag, "getOrderedFoodIds ret:"+orderedIdAl);
	    return orderedIdAl;
	}
	public <T> ArrayList<String> getOrderedFoodIds(HashMap<String, T> hmIdAsKey){
		if (hmIdAsKey==null || hmIdAsKey.size()==0)
			return null;
		String[] idAry = new String[hmIdAsKey.size()];
		idAry = hmIdAsKey.keySet().toArray(idAry);
		return getOrderedFoodIds(idAry);
	}

	
	
	
	
	
	
	/*
	 用以支持得到nutrients的信息数据，并可以通过普通的nutrient的列名取到相应的nutrient信息。
	 */
	public HashMap<String, HashMap<String, Object>> getNutrientInfoAs2LevelDictionary_withNutrientIds(String[] nutrientIds)
	{
		Log.d(LogTag, "getNutrientInfoAs2LevelDictionary_withNutrientIds enter, nutrientIds="+nutrientIds);
		StringBuffer sbQuery = new StringBuffer();
		sbQuery.append("SELECT * FROM NutritionInfo");
		if (nutrientIds != null && nutrientIds.length > 0){
			String placeholdersStr = generatePlaceholderPartForIn(nutrientIds.length);
			sbQuery.append("  WHERE NutrientID in (");
			sbQuery.append(placeholdersStr);
			sbQuery.append(")");
		}
		Cursor cs = mDBcon.rawQuery(sbQuery.toString(),nutrientIds);
		ArrayList<HashMap<String, Object>> dataAry =  Tool.getRowsWithTypeFromCursor(cs);
		cs.close();
		Log.d(LogTag, "in getNutrientInfoAs2LevelDictionary_withNutrientIds,dataAry="+dataAry);
		
		HashMap<String, HashMap<String, Object>> dic2Level = Tool.dictionaryArrayTo2LevelDictionary_withKeyName(Constants.COLUMN_NAME_NutrientID,dataAry);
		Log.d(LogTag, "getNutrientInfoAs2LevelDictionary_withNutrientIds ret:"+dic2Level.toString());
	    return dic2Level;
	}	
	
	
	
	
	/*
	 单条语句暂且不管transaction的问题，假定不抛exception，在返回false值后让外层判断来rollback
	 return auto increment id value
	 */
	long insertFoodCollocation_withName(String collationName)
	{
		java.util.Date dtNow = new java.util.Date();
		long llms = dtNow.getTime();

	    ContentValues values = new ContentValues();
	    values.put(Constants.COLUMN_NAME_CollocationName, collationName);
	    values.put(Constants.COLUMN_NAME_CollocationCreateTime, llms);
	    long rowId = mDBcon.insert(Constants.TABLE_NAME_FoodCollocation, null, values);//TODO check rowId be same as CollocationId
	    return rowId;
	    
//		String insertSql = "INSERT INTO FoodCollocation (CollocationName, CollocationCreateTime) VALUES (?,?);";
//		Object[] bindArgs = new Object[]{collationName,llms};
//	    mDBcon.execSQL(insertSql, bindArgs);
	    
	}
	/*
	 单条语句暂且不管transaction的问题，假定不抛exception，在返回false值后让外层判断来rollback
	 */
	int updateFoodCollocationName(String collationName,long nmCollocationId)
	{
//	    String updSql = "UPDATE FoodCollocation SET CollocationName=? WHERE CollocationId=?;";
//	    Object[] bindArgs = new Object[]{collationName,nmCollocationId};
//	    mDBcon.execSQL(updSql, bindArgs);
		
		ContentValues values = new ContentValues();
	    values.put(Constants.COLUMN_NAME_CollocationName, collationName);
	    String whereClause = "CollocationId=?";
	    String[] whereArgs = new String[]{""+nmCollocationId};
		int rowCount = mDBcon.update(Constants.TABLE_NAME_FoodCollocation, values, whereClause, whereArgs);
	    return rowCount;
	}
	int updateFoodCollocationTime(long collationTime, long nmCollocationId)
	{
//		String updSql = "UPDATE FoodCollocation SET CollocationCreateTime=? WHERE CollocationId=?;";
//		Object[] bindArgs = new Object[]{collationTime,nmCollocationId};
		ContentValues values = new ContentValues();
	    values.put(Constants.COLUMN_NAME_CollocationCreateTime, collationTime);
	    String whereClause = "CollocationId=?";
	    String[] whereArgs = new String[]{""+nmCollocationId};
		int rowCount = mDBcon.update(Constants.TABLE_NAME_FoodCollocation, values, whereClause, whereArgs);
	    return rowCount;
	}
	int deleteFoodCollocationById(long nmCollocationId)
	{
		String whereClause = "CollocationId=?";
		String[] whereArgs = new String[]{""+nmCollocationId};
		return mDBcon.delete(Constants.TABLE_NAME_FoodCollocation, whereClause, whereArgs);
	}
	/*
	 单条语句暂且不管transaction的问题，假定不抛exception，在返回false值后让外层判断来rollback
	 */
	HashMap<String, Object> getFoodCollocationById(long nmCollocationId)
	{
		Cursor cs = mDBcon.query(Constants.TABLE_NAME_FoodCollocation, null, "CollocationId=?", new String[]{""+nmCollocationId}, null, null, null);
		cs.moveToFirst();
		HashMap<String, Object> rowDict = Tool.get1RowDataWithTypeFromCursorCurrentPosition(cs);
		cs.close();
	    return rowDict;
	}
	
	public ArrayList<HashMap<String, Object>> getAllFoodCollocation()
	{
		Cursor cs = mDBcon.query(Constants.TABLE_NAME_FoodCollocation, null, null, null, null, null, null);
		ArrayList<HashMap<String, Object>> rows = Tool.getRowsWithTypeFromCursor(cs);
		cs.close();
		Log.d(LogTag, Tool.getIndentFormatStringOfObject(rows, 0));
	    return rows;
	}

	public ArrayList<HashMap<String, Object>> getCollocationFoodData_withCollocationId(long nmCollocationId)
	{
		String[] columns = new String[]{Constants.COLUMN_NAME_FoodId, Constants.COLUMN_NAME_FoodAmount};
		Cursor cs = mDBcon.query(Constants.TABLE_NAME_CollocationFood, columns, "CollocationId=?", new String[]{""+nmCollocationId}, null, null, null);
		ArrayList<HashMap<String, Object>> rows = Tool.getRowsWithTypeFromCursor(cs);
		cs.close();
	    return rows;
	}
	/*
	 单条语句暂且不管transaction的问题，假定不抛exception，在返回false值后让外层判断来rollback
	 */
	int deleteCollocationFoodData_withCollocationId(long nmCollocationId)
	{
		String whereClause = Constants.COLUMN_NAME_CollocationId+"=?";
		String[] whereArgs = new String[]{""+nmCollocationId};
		return mDBcon.delete(Constants.TABLE_NAME_CollocationFood, whereClause, whereArgs);
	}

	/*
	 单条语句暂且不管transaction的问题，假定不抛exception，在返回false值后让外层判断来rollback
	 */
	void insertCollocationFood_withCollocationId(long nmCollocationId, String foodId, double foodAmount)
	{
	    ContentValues values = new ContentValues();
	    values.put(Constants.COLUMN_NAME_CollocationId, nmCollocationId);
	    values.put(Constants.COLUMN_NAME_FoodId, foodId);
	    values.put(Constants.COLUMN_NAME_FoodAmount, foodAmount);
	    long rowId = mDBcon.insert(Constants.TABLE_NAME_CollocationFood, null, values);//TODO check rowId be no use //try-catch?
	}

	
	public void insertCollocationFoods_withCollocationId(long nmCollocationId ,ArrayList<Object[]> foodAmount2LevelArray)
	{
		if (foodAmount2LevelArray == null || foodAmount2LevelArray.size()==0)
			return;
		
//		boolean outerTransactionExist = mDBcon.inTransaction();// as the doc says: Transactions can be nested . so need not care if outerTransactionExist 
		mDBcon.beginTransaction();
		try {
		    for(int i=0; i<foodAmount2LevelArray.size(); i++){
		    	Object[] foodAndAmount = foodAmount2LevelArray.get(i);
		    	assert(foodAndAmount!=null && foodAndAmount.length==2);
		        String foodId = (String) foodAndAmount[0];
		        Double nmFoodAmount = (Double) foodAndAmount[1];
		        insertCollocationFood_withCollocationId(nmCollocationId,foodId,nmFoodAmount.doubleValue());//try-catch?
		    }
			
			mDBcon.setTransactionSuccessful();
		} finally {
			mDBcon.endTransaction();
		}
	    return ;
	}


	public long insertFoodCollocationData_withCollocationName(String collationName, ArrayList<Object[]> foodAmount2LevelArray)
	{
		mDBcon.beginTransaction();
		try {
			long nmCollocationId = insertFoodCollocation_withName(collationName);
		    insertCollocationFoods_withCollocationId(nmCollocationId,foodAmount2LevelArray);
			mDBcon.setTransactionSuccessful();
			return nmCollocationId;
		} finally {
			mDBcon.endTransaction();
		}
	}


	/*
	 如果 collocationName 为nil，则不改name。
	 */
	public void updateFoodCollocationData_withCollocationId(long nmCollocationId,String new_collocationName, ArrayList<Object[]> foodAmount2LevelArray)
	{
		mDBcon.beginTransaction();
		try {
			if (new_collocationName!=null)
				updateFoodCollocationName(new_collocationName,nmCollocationId);
			deleteCollocationFoodData_withCollocationId(nmCollocationId);
			insertCollocationFoods_withCollocationId(nmCollocationId,foodAmount2LevelArray);
			java.util.Date dtNow = new java.util.Date();
			long llmsNow = dtNow.getTime();
			updateFoodCollocationTime(llmsNow,nmCollocationId);
			mDBcon.setTransactionSuccessful();
		} finally {
			mDBcon.endTransaction();
		}
	}

	public HashMap<String, Object> getFoodCollocationData_withCollocationId(long nmCollocationId)
	{
		HashMap<String, Object> rowFoodCollocation = getFoodCollocationById(nmCollocationId);
		ArrayList<HashMap<String, Object>> foodAndAmountArray = getCollocationFoodData_withCollocationId(nmCollocationId);
		HashMap<String, Object> retDict = new HashMap<String, Object>();
	    if (rowFoodCollocation!=null)
	    	retDict.put("rowFoodCollocation", rowFoodCollocation);
	    if (foodAndAmountArray!=null)
	    	retDict.put("foodAndAmountArray", foodAndAmountArray);

	    Log.d(LogTag, "getFoodCollocationData_withCollocationId "+nmCollocationId+" ret:"+Tool.getIndentFormatStringOfObject(retDict, 0));
	    return retDict;
	}

	public void deleteFoodCollocationData_withCollocationId(long nmCollocationId)
	{
		mDBcon.beginTransaction();
		try {
			deleteFoodCollocationById(nmCollocationId);
		    deleteCollocationFoodData_withCollocationId(nmCollocationId);

			mDBcon.setTransactionSuccessful();
		} finally {
			mDBcon.endTransaction();
		}
	}

	
	
	
	
	
	
	
	
	
	
	
	//TODO delete it
	public Cursor getDiseaseGroupInfo_byType_old(String groupType){
		String query = "SELECT DISTINCT DiseaseGroup FROM DiseaseGroup WHERE dsGroupType=? ORDER BY dsGroupWizardOrder";
		String[] args = new String[]{groupType}; 
		Cursor cs = mDBcon.rawQuery(query,args);
		return cs;
	}
	//TODO delete it
	public Cursor getDiseaseNamesOfGroup(String groupName){
		String query = "SELECT Disease FROM DiseaseInGroup WHERE DiseaseGroup=?";
		String[] args = new String[]{groupName}; 
		Cursor cs = mDBcon.rawQuery(query,args);
		return cs;
	}
	
	public ArrayList<HashMap<String, Object>> getDiseaseGroupInfo_byType(String groupType){
		String query = "SELECT * FROM DiseaseGroup WHERE dsGroupType=?";
		String[] args = new String[]{groupType}; 
		Cursor cs = mDBcon.rawQuery(query,args);
		ArrayList<HashMap<String, Object>> dataAry = Tool.getRowsWithTypeFromCursor(cs);
	    cs.close();
		return dataAry;
	}
	public String getDiseaseGroupId_byType(String groupType){
		ArrayList<HashMap<String, Object>> diseaseGroupInfoAry = getDiseaseGroupInfo_byType(groupType);
		String groupId = null;
		if (diseaseGroupInfoAry != null && diseaseGroupInfoAry.size()>0){
			HashMap<String, Object> diseaseGroupInfo = diseaseGroupInfoAry.get(0);
			groupId = (String)diseaseGroupInfo.get(Constants.COLUMN_NAME_DiseaseGroup);
		}
		return groupId;
	}
	
	
	ArrayList<String> getDiseaseIdsOfGroup(String groupName, String department, String diseaseType, String timeType)
	{
	    Log.d(LogTag, "getDiseaseIdsOfGroup enter, groupName="+groupName+", department="+department+", diseaseType="+diseaseType+", timeType="+timeType );
	    ArrayList<Object> columnValuePairs_equal = new ArrayList<Object>();
	    if (groupName != null){
	    	Object[] columnValuePair = {Constants.COLUMN_NAME_DiseaseGroup,groupName};
	    	columnValuePairs_equal.add(columnValuePair);
	    }
	    if (department != null){
	    	Object[] columnValuePair = {Constants.COLUMN_NAME_DiseaseDepartment,department};
	    	columnValuePairs_equal.add(columnValuePair);
	    }
	    if (diseaseType != null){
	    	Object[] columnValuePair = {Constants.COLUMN_NAME_DiseaseType,diseaseType};
	    	columnValuePairs_equal.add(columnValuePair);
	    }
	    if (timeType != null){
	    	Object[] columnValuePair = {Constants.COLUMN_NAME_DiseaseTimeType,timeType};
	    	columnValuePairs_equal.add(columnValuePair);
	    }
	    
	    String destColumn = Constants.COLUMN_NAME_Disease;
	    String[] selectColumns = {destColumn};
	    ArrayList<HashMap<String, Object>> diseaseInfoAry = selectTableByEqualFilter_withTableName(Constants.TABLE_NAME_DiseaseInGroup, 
	    		columnValuePairs_equal, null, selectColumns, null, false);
	    ArrayList<Object> diseaseIdObjAry = Tool.getPropertyArrayListFromDictionaryArray_withPropertyName(destColumn, diseaseInfoAry);
	    ArrayList<String> diseaseIdAry = Tool.convertToStringArrayList(diseaseIdObjAry);

	    Log.d(LogTag, "getDiseaseIdsOfGroup return="+diseaseIdAry);
	    return diseaseIdAry;
	}
	
	ArrayList<HashMap<String, Object>> getDiseaseInfosOfGroup(String groupName, String department, String diseaseType, String timeType)
	{
		Log.d(LogTag, "getDiseaseInfosOfGroup enter, groupName="+groupName+", department="+department+", diseaseType="+diseaseType+", timeType="+timeType );
		ArrayList<Object> columnValuePairs_equal = new ArrayList<Object>();
	    if (groupName != null){
	    	Object[] columnValuePair = {Constants.COLUMN_NAME_DiseaseGroup,groupName};
	    	columnValuePairs_equal.add(columnValuePair);
	    }
	    if (department != null){
	    	Object[] columnValuePair = {Constants.COLUMN_NAME_DiseaseDepartment,department};
	    	columnValuePairs_equal.add(columnValuePair);
	    }
	    if (diseaseType != null){
	    	Object[] columnValuePair = {Constants.COLUMN_NAME_DiseaseType,diseaseType};
	    	columnValuePairs_equal.add(columnValuePair);
	    }
	    if (timeType != null){
	    	Object[] columnValuePair = {Constants.COLUMN_NAME_DiseaseTimeType,timeType};
	    	columnValuePairs_equal.add(columnValuePair);
	    }
	    
	    ArrayList<HashMap<String, Object>> diseaseInfoAry = selectTableByEqualFilter_withTableName(Constants.TABLE_NAME_DiseaseInGroup, 
	    		columnValuePairs_equal, null, null, null, false);
	    Log.d(LogTag, "getDiseaseInfosOfGroup return="+Tool.getIndentFormatStringOfObject(diseaseInfoAry, 0));
	    return diseaseInfoAry;
	}
	
	HashMap<String, ArrayList<HashMap<String, Object>>> getDiseaseNutrientRows_ByDiseaseIds(ArrayList<String> diseaseIds, String groupName)
	{
		Log.d(LogTag, "getDiseaseNutrientRows_ByDiseaseIds enter, groupName="+groupName+", diseaseIds="+diseaseIds );
		ArrayList<Object> columnValue_sPairs_equal = new ArrayList<Object>();
	    if (groupName != null){
	    	Object[] columnValuePair = {Constants.COLUMN_NAME_DiseaseGroup,groupName};
	    	columnValue_sPairs_equal.add(columnValuePair);
	    }
	    if (diseaseIds != null && diseaseIds.size()>0){
	    	Object[] columnValuesPair = {Constants.COLUMN_NAME_Disease,diseaseIds};
	    	columnValue_sPairs_equal.add(columnValuesPair);
	    }
	    
	    String[] selectColumns = {Constants.COLUMN_NAME_Disease,Constants.COLUMN_NAME_NutrientID,Constants.COLUMN_NAME_LackLevelMark};
	    ArrayList<HashMap<String, Object>> diseaseNutrientRows = selectTableByEqualFilter_withTableName(Constants.TABLE_NAME_DiseaseNutrient, 
	    		columnValue_sPairs_equal, null, selectColumns, null, true);
	    Log.d(LogTag, "getDiseaseNutrientRows_ByDiseaseIds , diseaseNutrientRows="+Tool.getIndentFormatStringOfObject(diseaseNutrientRows, 0) );
	    
	    HashMap<String, ArrayList<HashMap<String, Object>>> diseaseNutrientInfosByDiseaseDict = new HashMap<String, ArrayList<HashMap<String, Object>>>();
	    if (diseaseNutrientRows!=null){
	    	for(int i=0; i<diseaseNutrientRows.size(); i++){
	    		HashMap<String, Object> diseaseNutrientRow = diseaseNutrientRows.get(i);
	    		String diseaseId = (String)diseaseNutrientRow.get(Constants.COLUMN_NAME_Disease);
	    		Tool.addItemToListHash(diseaseNutrientRow, diseaseId, diseaseNutrientInfosByDiseaseDict);
		    }
	    }
	    Log.d(LogTag, "getDiseaseNutrientRows_ByDiseaseIds ret="+Tool.getIndentFormatStringOfObject(diseaseNutrientInfosByDiseaseDict, 0));
	    return diseaseNutrientInfosByDiseaseDict;
	}
	
	
	/*
	 * 返回值是一个hashmap，key为diseaseName，value为一个ArrayList，其item为NutrientId。
	 * to be deleted after ActivityDiseaseNutrientWizard be deleted
	 */
	@SuppressWarnings("rawtypes")
	public HashMap getDiseaseNutrients_ByDiseaseNames(String[] diseaseNames){
		if (diseaseNames == null || diseaseNames.length==0)
			return null;
		String placeholderPart = generatePlaceholderPartForIn(diseaseNames.length);
		StringBuffer sbQuery = new StringBuffer();
		sbQuery.append("SELECT Disease,NutrientID FROM DiseaseNutrient WHERE Disease in (");
		sbQuery.append(placeholderPart);
		sbQuery.append(")");
		Cursor cs = mDBcon.rawQuery(sbQuery.toString(),diseaseNames);
		HashMap lstHm = new HashMap();
		cs.moveToFirst();
		while(!cs.isAfterLast()){
			String diseaseName = cs.getString(0);
			String nutrientId = cs.getString(1);
			Tool.addItemToListHash(nutrientId, diseaseName, lstHm);
			cs.moveToNext();
		}
		cs.close();
		return lstHm;
	}
	
	@SuppressWarnings("rawtypes")
	public HashMap getDiseasesOrganizedByDepartment_OfGroup(String groupName){
		String query = "SELECT Disease,DiseaseDepartment FROM DiseaseInGroup WHERE DiseaseGroup=?";
		String[] args = new String[]{groupName}; 
		Cursor cs = mDBcon.rawQuery(query,args);
		
		HashMap lstHm = new HashMap();
		cs.moveToFirst();
		while(!cs.isAfterLast()){
			String diseaseName = cs.getString(0);
			String diseaseDepartment = cs.getString(1);
			Tool.addItemToListHash(diseaseName, diseaseDepartment, lstHm);
			cs.moveToNext();
		}
		cs.close();
		return lstHm;
	}
	
	//to be deleted after ActivityDiseaseNutrientWizard be deleted
	@SuppressWarnings("rawtypes")
	public String[] getUniqueNutrients_ByDiseaseNames(String[] diseaseNames){
		HashMap lstHm = getDiseaseNutrients_ByDiseaseNames(diseaseNames);
		if (lstHm == null)
			return null;
		HashSet<String> hsetNutrient = new HashSet<String>();
		Iterator iter = lstHm.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();
			Object key = entry.getKey();
			Object val = entry.getValue();
			ArrayList alNutrient = (ArrayList)val;
			for(int i=0; i<alNutrient.size(); i++){
				hsetNutrient.add((String)alNutrient.get(i));
			}
		}
		Object[] nutrientIdObjs = hsetNutrient.toArray();
		String[] nutrientIds = Tool.convertToStringArray(nutrientIdObjs);
		return nutrientIds;
	}
	
//	public ArrayList getDiseaseGroupInfo_byType2(String groupType){
//		String query = "SELECT DiseaseGroup FROM DiseaseGroup WHERE dsGroupType=? ORDER BY dsGroupWizardOrder";
//		String[] args = new String[]{groupType}; 
//		Cursor cs = mDBcon.rawQuery(query,args);
//		ArrayList alData = new ArrayList();
//		cs.moveToFirst();
//		while(!cs.isAfterLast()){
//			String diseaseGroup = cs.getString(0);
//			alData.add(diseaseGroup);
//			cs.moveToNext();
//		}
//		cs.close();
//		return alData;
//	}

	//------------------------------------------------------------------------------------------
	
	
	

	public ArrayList<HashMap<String, Object>> getSymptomTypeRows_withForSex(String forSex)
	{
	    Log.d(LogTag, "getSymptomTypeRows_withForSex enter, forSex="+forSex);
	    ArrayList<Object> columnValuePairs_equal = new ArrayList<Object>();
	    if (forSex == null || Constants.ForSex_both.equalsIgnoreCase(forSex)){
//	    	Object[] columnValuePair = {Constants.COLUMN_NAME_ForSex,Constants.ForSex_both};
//	    	columnValuePairs_equal.add(columnValuePair);
	    }else{
	    	Object[] values = {Constants.ForSex_both,forSex};
	    	Object[] columnValuePair = {Constants.COLUMN_NAME_ForSex,values};
	    	columnValuePairs_equal.add(columnValuePair);
	    }

	    ArrayList<HashMap<String, Object>> rows = selectTableByEqualFilter_withTableName(Constants.TABLE_NAME_SymptomType, 
	    		columnValuePairs_equal, null, null, Constants.COLUMN_NAME_DisplayOrder, false);
	    Log.d(LogTag, "getSymptomTypeRows_withForSex return="+Tool.getIndentFormatStringOfObject(rows,0));
	    return rows;
	}
	
	public ArrayList<HashMap<String, Object>> getSymptomRows_BySymptomTypeIds(ArrayList<String> symptomTypeIds)
	{
		Log.d(LogTag, "getSymptomRows_BySymptomTypeIds enter");
		ArrayList<Object> columnValuePairs_equal = new ArrayList<Object>();
		if (symptomTypeIds != null){
			if (symptomTypeIds.size() == 0){
				return null;
			}
	    	Object[] columnValuePair = {Constants.COLUMN_NAME_SymptomTypeId,symptomTypeIds};
	    	columnValuePairs_equal.add(columnValuePair);
		}

		ArrayList<HashMap<String, Object>> rows = selectTableByEqualFilter_withTableName(Constants.TABLE_NAME_Symptom, 
	    		columnValuePairs_equal, null, null, Constants.COLUMN_NAME_DisplayOrder, false);
		String logMsg = "getSymptomRows_BySymptomTypeIds row count="+rows.size()+",\nrows="+Tool.getIndentFormatStringOfObject(rows,0);
		Log.d(LogTag, logMsg);
		Tool_microlog4android.logDebug(logMsg);
	    return rows;
	    
	}
	
	public ArrayList<HashMap<String, Object>> getSymptomRows_BySymptomIds(ArrayList<String> symptomIds)
	{
		Log.d(LogTag, "getSymptomRows_BySymptomIds enter");
		ArrayList<Object> columnValuePairs_equal = new ArrayList<Object>();
		if (symptomIds != null){
			if (symptomIds.size() == 0){
				return null;
			}
	    	Object[] columnValuePair = {Constants.COLUMN_NAME_SymptomId,symptomIds};
	    	columnValuePairs_equal.add(columnValuePair);
		}

		ArrayList<HashMap<String, Object>> rows = selectTableByEqualFilter_withTableName(Constants.TABLE_NAME_Symptom, 
	    		columnValuePairs_equal, null, null, Constants.COLUMN_NAME_DisplayOrder, false);
		String logMsg = "getSymptomRows_BySymptomIds rows="+Tool.getIndentFormatStringOfObject(rows,0);
		Log.d(LogTag, logMsg);
		Tool_microlog4android.logDebug(logMsg);
	    return rows;
	    
	}

	
	public HashMap<String,ArrayList<HashMap<String, Object>>> getSymptomRowsByTypeDict_BySymptomTypeIds(ArrayList<String> symptomTypeIds)
	{
		Log.d(LogTag, "getSymptomRowsByTypeDict_BySymptomTypeIds enter");
		ArrayList<HashMap<String, Object>> symptomRows = getSymptomRows_BySymptomTypeIds(symptomTypeIds);
		HashMap<String, ArrayList<HashMap<String, Object>>> symptomsByTypeDict = Tool.groupBy(Constants.COLUMN_NAME_SymptomTypeId, symptomRows);
		String logMsg = "getSymptomRowsByTypeDict_BySymptomTypeIds return=" + Tool.getIndentFormatStringOfObject(symptomsByTypeDict, 0);
		Log.d(LogTag, logMsg);
		Tool_microlog4android.logDebug(logMsg);
	    return symptomsByTypeDict;
	}

	public ArrayList<HashMap<String, Object>> getSymptomNutrientRows_BySymptomIds(ArrayList<String> symptomIds)
	{
		Log.d(LogTag, "getSymptomNutrientRows_BySymptomIds enter");
		ArrayList<Object> columnValuePairs_equal = new ArrayList<Object>();
		if (symptomIds != null){
			if (symptomIds.size() == 0){
				return null;
			}
	    	Object[] columnValuePair = {Constants.COLUMN_NAME_SymptomId,symptomIds};
	    	columnValuePairs_equal.add(columnValuePair);
		}

		String[] selectColumns = {Constants.COLUMN_NAME_SymptomId,Constants.COLUMN_NAME_NutrientID};
		ArrayList<HashMap<String, Object>> rows = selectTableByEqualFilter_withTableName(Constants.TABLE_NAME_SymptomNutrient, 
	    		columnValuePairs_equal, null, selectColumns, "SymptomTypeId,SymptomId", false);
		String logMsg = "getSymptomNutrientRows_BySymptomIds row count="+rows.size()+",\nrows="+Tool.getIndentFormatStringOfObject(rows,0);
		Log.d(LogTag, logMsg);
		Tool_microlog4android.logDebug(logMsg);
	    return rows;
	    
	}
	
	public ArrayList<String> getSymptomNutrientDistinctIds_BySymptomIds(ArrayList<String> symptomIds)
	{
		Log.d(LogTag, "getSymptomNutrientDistinctIds_BySymptomIds enter");
		ArrayList<Object> columnValuePairs_equal = new ArrayList<Object>();
		if (symptomIds != null){
			if (symptomIds.size() == 0){
				return null;
			}
	    	Object[] columnValuePair = {Constants.COLUMN_NAME_SymptomId,symptomIds};
	    	columnValuePairs_equal.add(columnValuePair);
		}

		String[] selectColumns = {Constants.COLUMN_NAME_NutrientID};
		ArrayList<HashMap<String, Object>> rows = selectTableByEqualFilter_withTableName(Constants.TABLE_NAME_SymptomNutrient, 
	    		columnValuePairs_equal, null, selectColumns, null, true);
		ArrayList<Object> nutrientIdObjs = Tool.getPropertyArrayListFromDictionaryArray_withPropertyName(Constants.COLUMN_NAME_NutrientID, rows);
		ArrayList<String> nutrientIds = Tool.convertToStringArrayList(nutrientIdObjs);
		
		String logMsg = "getSymptomNutrientDistinctIds_BySymptomIds nutrientIds="+Tool.getIndentFormatStringOfObject(nutrientIds,0);
		Log.d(LogTag, logMsg);
		
	    return nutrientIds;
	}
	
	public ArrayList<String> getSymptomNutrientIdsWithDisplaySort_BySymptomIds(ArrayList<String> symptomIds)
	{
		Log.d(LogTag, "getSymptomNutrientIdsWithDisplaySort_BySymptomIds enter");
		if (symptomIds==null || symptomIds.size()==0)
			return null;
		
		StringBuffer sbQuery = new StringBuffer();
		String placeholdersStr = generatePlaceholderPartForIn(symptomIds.size());

		sbQuery.append("SELECT NutrientID, sum(NutrientID) FROM SymptomNutrient"+
				" WHERE SymptomId IN ("+placeholdersStr+")"+
				" GROUP BY NutrientID"+
				" ORDER BY sum(NutrientID) desc;");
	   
		Cursor cs = mDBcon.rawQuery(sbQuery.toString(),symptomIds.toArray(new String[symptomIds.size()]));
	    ArrayList<HashMap<String, Object>> rows = Tool.getRowsWithTypeFromCursor(cs);
	    cs.close();
	    
	    ArrayList<Object> nutrientIdsAsOBj = Tool.getPropertyArrayListFromDictionaryArray_withPropertyName(Constants.COLUMN_NAME_NutrientID, rows);
	    ArrayList<String> nutrientIds = Tool.convertToStringArrayList(nutrientIdsAsOBj);
	    
	    Log.d(LogTag, "getSymptomNutrientIdsWithDisplaySort_BySymptomIds ret:"+Tool.getIndentFormatStringOfObject(nutrientIds,0) );
	    return nutrientIds;
	}
	
	public double getSymptomHealthMarkSum_BySymptomIds(String[] symptomIds)
	{
		Log.d(LogTag, "getSymptomHealthMark_BySymptomIds enter");
	    if (symptomIds==null || symptomIds.length==0)
	        return 0;
	    
	    String sqlStr = "SELECT sum(HealthMark) as HealthMark FROM Symptom";
	    

	    ArrayList<ArrayList<Object>> exprIncludeANDdata = new ArrayList<ArrayList<Object>>();
	    ArrayList<Object> expr = new ArrayList<Object>(3);
        expr.add(Constants.COLUMN_NAME_SymptomId);
        expr.add("IN");
        expr.add(symptomIds);
        exprIncludeANDdata.add(expr);
		
	    HashMap<String, Object> filters = new HashMap<String, Object>();
	    filters.put("includeAND", exprIncludeANDdata);

	    HashMap<String, Object> localOptions = new HashMap<String, Object>();
	    localOptions.put("varBeParamWay", Boolean.valueOf(true));
	    ArrayList<HashMap<String, Object>> dataAry = getRowsByQuery(sqlStr, filters, false, null, localOptions);


	    HashMap<String, Object> row = dataAry.get(0);
	    Double nmHealthMark = (Double)row.get(Constants.COLUMN_NAME_HealthMark);
	    double dHealthMark = nmHealthMark.doubleValue();
	    
	    Log.d(LogTag, "getSymptomHealthMark_BySymptomIds ret="+ dHealthMark);
	    return dHealthMark;
	}
	
	public ArrayList<String> getIllnessSuggestionDistinctIds_ByIllnessIds(ArrayList<String> illnessIds)
	{
		Log.d(LogTag, "getIllnessSuggestionDistinctIds_ByIllnessIds enter");
		ArrayList<Object> columnValuePairs_equal = new ArrayList<Object>();
		if (illnessIds != null){
			if (illnessIds.size() == 0){
				return null;
			}
	    	Object[] columnValuePair = {Constants.COLUMN_NAME_IllnessId,illnessIds};
	    	columnValuePairs_equal.add(columnValuePair);
		}

		String[] selectColumns = {Constants.COLUMN_NAME_SuggestionId};
		ArrayList<HashMap<String, Object>> rows = selectTableByEqualFilter_withTableName(Constants.TABLE_NAME_IllnessToSuggestion, 
	    		columnValuePairs_equal, null, selectColumns, Constants.COLUMN_NAME_DisplayOrder, true);
		ArrayList<Object> suggestionIdObjs = Tool.getPropertyArrayListFromDictionaryArray_withPropertyName(Constants.COLUMN_NAME_SuggestionId, rows);
		ArrayList<String> suggestionIds = Tool.convertToStringArrayList(suggestionIdObjs);
		
		String logMsg = "getIllnessSuggestionDistinctIds_ByIllnessIds suggestionIds="+Tool.getIndentFormatStringOfObject(suggestionIds,0);
		Log.d(LogTag, logMsg);
		
	    return suggestionIds;
	}
	
	public ArrayList<HashMap<String, Object>> getIllnessSuggestions_BySuggestionIds(ArrayList<String> suggestionIds)
	{
		Log.d(LogTag, "getIllnessSuggestions_BySuggestionIds enter");
		ArrayList<Object> columnValuePairs_equal = new ArrayList<Object>();
		if (suggestionIds != null){
			if (suggestionIds.size() == 0){
				return null;
			}
	    	Object[] columnValuePair = {Constants.COLUMN_NAME_SuggestionId,suggestionIds};
	    	columnValuePairs_equal.add(columnValuePair);
		}

		ArrayList<HashMap<String, Object>> rows = selectTableByEqualFilter_withTableName(Constants.TABLE_NAME_IllnessSuggestion, 
	    		columnValuePairs_equal, null, null, null, false);
		String logMsg = "getIllnessSuggestions_BySuggestionIds row count="+rows.size()+",\nrows="+Tool.getIndentFormatStringOfObject(rows,0);
		Log.d(LogTag, logMsg);
		Tool_microlog4android.logDebug(logMsg);
	    return rows;
	    
	}
	
	public ArrayList<HashMap<String, Object>> getIllnessSuggestionsDistinct_ByIllnessIds(ArrayList<String> illnessIds)
	{
		Log.d(LogTag, "getIllnessSuggestionsDistinct_ByIllnessIds enter");
		ArrayList<String> suggestionIds = getIllnessSuggestionDistinctIds_ByIllnessIds(illnessIds);
	    if (suggestionIds == null || suggestionIds.size() == 0)
	        return null;
	    ArrayList<HashMap<String, Object>> rows = getIllnessSuggestions_BySuggestionIds(suggestionIds);
	    Log.d(LogTag, "getIllnessSuggestionsDistinct_ByIllnessIds rows="+Tool.getIndentFormatStringOfObject(rows,0) );
	    return rows;
	}
	
	public ArrayList<HashMap<String, Object>> getIllnessSuggestions_ByIllnessId(String illnessId)
	{
		Log.d(LogTag, "getIllnessSuggestions_ByIllnessId enter");
		ArrayList<String> illnessIds = new ArrayList<String>();
		illnessIds.add(illnessId);
		
		ArrayList<String> suggestionIds = getIllnessSuggestionDistinctIds_ByIllnessIds(illnessIds);
		if (suggestionIds==null || suggestionIds.size()==0)
			return null;

		ArrayList<HashMap<String, Object>> rows = getIllnessSuggestions_BySuggestionIds(suggestionIds);
		Log.d(LogTag, "getIllnessSuggestions_ByIllnessId rows="+Tool.getIndentFormatStringOfObject(rows,0) );
	    return rows;
	}

	public ArrayList<HashMap<String, Object>> getAllIllness()
	{
		Log.d(LogTag, "getAllIllness enter");
		ArrayList<HashMap<String, Object>> rows = selectTableByEqualFilter_withTableName(Constants.TABLE_NAME_Illness,null,null,null,Constants.COLUMN_NAME_DisplayOrder,false);
		Log.d(LogTag, "getAllIllness ret="+Tool.getIndentFormatStringOfObject(rows,0) );
	    return rows;
	}
	
	public ArrayList<HashMap<String, Object>> getIllness_ByIllnessIds(ArrayList<String> illnessIds)
	{
		Log.d(LogTag, "getIllness_ByIllnessIds enter");
		ArrayList<Object> columnValuePairs_equal = new ArrayList<Object>();
		if (illnessIds != null){
			if (illnessIds.size() == 0){
				return null;
			}
	    	Object[] columnValuePair = {Constants.COLUMN_NAME_IllnessId,illnessIds};
	    	columnValuePairs_equal.add(columnValuePair);
		}

		ArrayList<HashMap<String, Object>> rows = selectTableByEqualFilter_withTableName(Constants.TABLE_NAME_Illness, 
	    		columnValuePairs_equal, null, null, null, false);
		String logMsg = "getIllness_ByIllnessIds row count="+rows.size()+",\nrows="+Tool.getIndentFormatStringOfObject(rows,0);
		Log.d(LogTag, logMsg);
//		Tool_microlog4android.logDebug(logMsg);
	    return rows;
	}

	
	/*
	 dayLocal 是 8位整数,如  20120908
	 */
	public void insertUserRecordSymptom_withDayLocal(int dayLocal,Date updateTimeUTC,String inputNameValuePairs,String Note,String calculateNameValuePairs)
	{
		Log.d(LogTag, "insertUserRecordSymptom_withDayLocal enter");
		long lUpdateTimeUTC = updateTimeUTC.getTime();
		String insertSql = "INSERT INTO UserRecordSymptom (DayLocal, UpdateTimeUTC, inputNameValuePairs, Note, calculateNameValuePairs) VALUES (?,?,?,?,?);";
		Object[] bindArgs = new Object[]{Integer.valueOf(dayLocal),lUpdateTimeUTC,inputNameValuePairs,Note,calculateNameValuePairs};
		mDBcon.execSQL(insertSql, bindArgs);
	}
	public void insertUserRecordSymptom_withRawData(HashMap<String, Object> hmRawData)
	{
		Log.d(LogTag, "insertUserRecordSymptom_withRawData enter");
		if (hmRawData == null)
			return;
		String key;
	    key = Constants.COLUMN_NAME_DayLocal;
	    Integer dayLocalObj = (Integer)hmRawData.get(key);
	    int dayLocal = dayLocalObj.intValue();
	    
	    key = Constants.COLUMN_NAME_UpdateTimeUTC;
	    Date UpdateTimeUTC = (Date)hmRawData.get(key);
	    
	    key = Constants.COLUMN_NAME_Note;
	    String note = (String)hmRawData.get(key);
	    
	    key = Constants.COLUMN_NAME_inputNameValuePairs;
	    String jsonStr_inputNameValuePairs =  (String)hmRawData.get(key);
	    
	    key = Constants.COLUMN_NAME_calculateNameValuePairs;
	    String jsonStr_calculateNameValuePairs =  (String)hmRawData.get(key);

	    insertUserRecordSymptom_withDayLocal(dayLocal,UpdateTimeUTC,jsonStr_inputNameValuePairs,note,jsonStr_calculateNameValuePairs);
	}
	public void updateUserRecordSymptom_withDayLocal(int dayLocal,Date updateTimeUTC,String inputNameValuePairs,String Note,String calculateNameValuePairs)
	{
		Log.d(LogTag, "updateUserRecordSymptom_withDayLocal enter");
		long lUpdateTimeUTC = updateTimeUTC.getTime();
		String updateSql = "UPDATE UserRecordSymptom SET UpdateTimeUTC=?, inputNameValuePairs=?, Note=?, calculateNameValuePairs=? WHERE DayLocal=? ;";
		Object[] bindArgs = new Object[]{lUpdateTimeUTC, inputNameValuePairs, Note, calculateNameValuePairs, Integer.valueOf(dayLocal)};
		mDBcon.execSQL(updateSql, bindArgs);
	}
	
	/*
	 what are contained in inputNameValuePairsData and calculateNameValuePairsData: to see below those been commentted
	 */
	public void insertUserRecordSymptom_withDayLocal(int dayLocal,Date updateTimeUTC,HashMap<String, Object> inputNameValuePairsData,String Note, HashMap<String, Object> calculateNameValuePairsData)
	{
//	    NSArray* Symptoms = [inputNameValuePairsData objectForKey: Key_Symptoms];
//	    NSNumber *nmTemperature = [inputNameValuePairsData objectForKey: Key_Temperature];
//	    NSNumber *nmWeight = [inputNameValuePairsData objectForKey: Key_Weight];
//	    NSNumber *nmHeartRate = [inputNameValuePairsData objectForKey: Key_HeartRate];
//	    NSNumber *nmBloodPressureLow = [inputNameValuePairsData objectForKey: Key_BloodPressureLow];
//	    NSNumber *nmBloodPressureHigh = [inputNameValuePairsData objectForKey: Key_BloodPressureHigh];
//	    NSNumber *nmBMI = [calculateNameValuePairsData objectForKey: Key_BMI];
//	    NSNumber *nmHealthMark = [calculateNameValuePairsData objectForKey: Key_HealthMark];
//	    NSArray* InferIllnesses = [calculateNameValuePairsData objectForKey: Key_InferIllnesses];
//	    NSArray* Suggestions = [calculateNameValuePairsData objectForKey: Key_Suggestions];
//	    NSDictionary* NutrientsWithFoodAndAmounts = [calculateNameValuePairsData objectForKey: Key_NutrientsWithFoodAndAmounts];//String -> Dictionary{String -> double}
		
		JSONObject jsonObj_inputNameValuePairsData = Tool.HashMapToJsonObject(inputNameValuePairsData);
		String jsonString_inputNameValuePairs = jsonObj_inputNameValuePairsData.toString();
		
		JSONObject jsonObj_calculateNameValuePairsData = Tool.HashMapToJsonObject(calculateNameValuePairsData);
		String jsonString_calculateNameValuePairs = jsonObj_calculateNameValuePairsData.toString();
		
		Log.d(LogTag, "insertUserRecordSymptom_withDayLocal , jsonString_inputNameValuePairs="+jsonString_inputNameValuePairs);
		Log.d(LogTag, "insertUserRecordSymptom_withDayLocal , jsonString_calculateNameValuePairs="+jsonString_calculateNameValuePairs);
	    
		insertUserRecordSymptom_withDayLocal(dayLocal, updateTimeUTC, jsonString_inputNameValuePairs, Note, jsonString_calculateNameValuePairs);
	}
	public void updateUserRecordSymptom_withDayLocal(int dayLocal,Date updateTimeUTC,HashMap<String, Object> inputNameValuePairsData,String Note, HashMap<String, Object> calculateNameValuePairsData)
	{
		JSONObject jsonObj_inputNameValuePairsData = Tool.HashMapToJsonObject(inputNameValuePairsData);
		String jsonString_inputNameValuePairs = jsonObj_inputNameValuePairsData.toString();
		
		JSONObject jsonObj_calculateNameValuePairsData = Tool.HashMapToJsonObject(calculateNameValuePairsData);
		String jsonString_calculateNameValuePairs = jsonObj_calculateNameValuePairsData.toString();
		
	    updateUserRecordSymptom_withDayLocal(dayLocal, updateTimeUTC, jsonString_inputNameValuePairs, Note, jsonString_calculateNameValuePairs);
	}
	
	public int deleteUserRecordSymptomByByDayLocal(int dayLocal)
	{
		String whereClause = Constants.COLUMN_NAME_DayLocal+"=?";
		String[] whereArgs = new String[]{""+dayLocal};
		return mDBcon.delete(Constants.TABLE_NAME_UserRecordSymptom, whereClause, whereArgs);
	}
	

	/*
	 单条语句暂且不管transaction的问题，假定不抛exception，在返回false值后让外层判断来rollback
	 注意这里的返回值里面的含有复杂对象的列的值是json string.
	 */
	public HashMap<String, Object> getUserRecordSymptomRawRowByDayLocal(int dayLocal)
	{
		ArrayList<Object> columnValuePairs_equal = new ArrayList<Object>();
    	Object[] columnValuePair = {Constants.COLUMN_NAME_DayLocal,dayLocal};
    	columnValuePairs_equal.add(columnValuePair);
	    
    	ArrayList<HashMap<String, Object>> rows = selectTableByEqualFilter_withTableName(Constants.TABLE_NAME_UserRecordSymptom,columnValuePairs_equal,null,null,null,false);
    	HashMap<String, Object> rowDict = null;
    	if (rows!=null && rows.size()>0){
    		rowDict = rows.get(0);
    	}
    	Log.d(LogTag, "getUserRecordSymptomRawRowByDayLocal ret="+Tool.getIndentFormatStringOfObject(rowDict,0) );
	    return rowDict;
	}

	/*
	 xxxDayLocal 是 8位整数,如  20120908
	 the range is [StartDayLocal , EndDayLocal). if xxxDayLocal==0 , means not limited
	 按DayLocal升序排序
	 */
	public ArrayList<HashMap<String, Object>> getUserRecordSymptomRawRowsByRange_withStartDayLocal(int StartDayLocal,int EndDayLocal,int StartMonthLocal,int EndMonthLocal)
	{
		ArrayList<Object> FieldOpValuePairs = new ArrayList<Object>();
		Object[] FieldOpValuePair = null;

	    if (StartDayLocal>0){
	    	FieldOpValuePair = new Object[] {Constants.COLUMN_NAME_DayLocal,">=",StartDayLocal};
	    	FieldOpValuePairs.add(FieldOpValuePair);
	    }
	    if (EndDayLocal>0){
	    	FieldOpValuePair = new Object[] {Constants.COLUMN_NAME_DayLocal,"<",EndDayLocal};
	    	FieldOpValuePairs.add(FieldOpValuePair);
	    }
	    if (StartMonthLocal>0){
	    	FieldOpValuePair = new Object[] {Constants.COLUMN_NAME_DayLocal,">=",StartMonthLocal*100};
	    	FieldOpValuePairs.add(FieldOpValuePair);
	    }
	    if (EndMonthLocal>0){
	    	FieldOpValuePair = new Object[] {Constants.COLUMN_NAME_DayLocal,"<",EndMonthLocal*100};
	    	FieldOpValuePairs.add(FieldOpValuePair);
	    }
	    ArrayList<HashMap<String, Object>> rows = selectTable_byFieldOpValuePairs(FieldOpValuePairs,Constants.TABLE_NAME_UserRecordSymptom,null,Constants.COLUMN_NAME_DayLocal,false);
	    Log.d(LogTag, "getUserRecordSymptomRawRowsByRange_withStartDayLocal ret="+Tool.getIndentFormatStringOfObject(rows,0) );
	    return rows;
	}

	static HashMap<String, Object> parseUserRecordSymptomRawRow(HashMap<String, Object> rawRowDict)
	{
		if (rawRowDict == null)
			return null;
		HashMap<String, Object> dataDict = new HashMap<String, Object>();
	    
	    String key;
	    Object val;
	    key = Constants.COLUMN_NAME_DayLocal;
	    dataDict.put(key, rawRowDict.get(key));
	    
	    key = Constants.COLUMN_NAME_UpdateTimeUTC;
	    Long nmUpdateTimeUTC = Tool.convertToLong(rawRowDict.get(key));//Double
	    Date UpdateTimeUTC = new Date(nmUpdateTimeUTC.longValue());
	    dataDict.put(key, UpdateTimeUTC);
	    
	    key = Constants.COLUMN_NAME_Note;
	    val = rawRowDict.get(key);
	    if (val != null){
	    	dataDict.put(key, val);
	    }
	    
	    key = Constants.COLUMN_NAME_inputNameValuePairs;
	    val = rawRowDict.get(key);
	    if (val != null){
	        String jsonString = (String)val;
	        JSONObject jsonObj = null;
	        try {
				jsonObj = new JSONObject(jsonString);
				HashMap<String, Object> hmObj = Tool.JsonToHashMap(jsonObj);
				dataDict.put(key, hmObj);
			} catch (JSONException e) {
				Log.e(LogTag, "new JSONObject(string) err:"+e.getMessage(),e);
			}
	    }
	    
	    key = Constants.COLUMN_NAME_calculateNameValuePairs;
	    val = rawRowDict.get(key);
	    if (val != null){
	        String jsonString = (String)val;
	        JSONObject jsonObj = null;
	        try {
				jsonObj = new JSONObject(jsonString);
				HashMap<String, Object> hmObj = Tool.JsonToHashMap(jsonObj);
				dataDict.put(key, hmObj);
			} catch (JSONException e) {
				Log.e(LogTag, "new JSONObject(string) err:"+e.getMessage(),e);
			}
	    }
	    	    
	    return dataDict;
	}

	

	/*
	 与 getUserRecordSymptomRawRowByDayLocal 相比，json string的列已经被转换为 HashMap
	 */
	public HashMap<String, Object> getUserRecordSymptomDataByDayLocal(int dayLocal)
	{
		HashMap<String, Object> rowRaw = getUserRecordSymptomRawRowByDayLocal(dayLocal);
		HashMap<String, Object> rowData = parseUserRecordSymptomRawRow(rowRaw);
		Log.d(LogTag, "getUserRecordSymptomDataByDayLocal ret:"+Tool.getIndentFormatStringOfObject(rowData,0) );
	    return rowData;
	}
	
	/*
	 按DayLocal升序排序
	 */
	public ArrayList<HashMap<String, Object>> getUserRecordSymptomDataByRange_withStartDayLocal(int StartDayLocal,int EndDayLocal,int StartMonthLocal,int EndMonthLocal)
	{
		ArrayList<HashMap<String, Object>> rowsRaw = getUserRecordSymptomRawRowsByRange_withStartDayLocal(StartDayLocal,EndDayLocal,StartMonthLocal,EndMonthLocal);
		if (rowsRaw == null) return null;
		ArrayList<HashMap<String, Object>> rows = new ArrayList<HashMap<String,Object>>();
	    for(int i=0; i<rowsRaw.size(); i++){
	    	HashMap<String, Object> rowRaw = rowsRaw.get(i);
	    	HashMap<String, Object> rowData = parseUserRecordSymptomRawRow(rowRaw);
	        rows.add(rowData);
	    }
	    Log.d(LogTag, "getUserRecordSymptomDataByRange_withStartDayLocal ret:"+Tool.getIndentFormatStringOfObject(rows,0) );
	    return rows;
	}
	
	/*
	 按升序排序
	 */
	public ArrayList<Integer> getUserRecordSymptom_DistinctMonth()
	{
		StringBuffer sbQuery = new StringBuffer();
		sbQuery.append("SELECT distinct (DayLocal/100) as MonthLocal FROM UserRecordSymptom ORDER BY DayLocal/100 ;");
	   
		Cursor cs = mDBcon.rawQuery(sbQuery.toString(),null);
	    ArrayList<HashMap<String, Object>> rows = Tool.getRowsWithTypeFromCursor(cs);
	    cs.close();
	    
	    ArrayList<Object> monthDblAry = Tool.getPropertyArrayListFromDictionaryArray_withPropertyName("MonthLocal", rows);
	    ArrayList<Integer> monthIntAry = Tool.convertFromArrayList(monthDblAry);
	    
	    Log.d(LogTag, "getUserRecordSymptom_DistinctMonth ret:"+Tool.getIndentFormatStringOfObject(monthIntAry,0) );
	    return monthIntAry;
	}


	
	
	
}

































