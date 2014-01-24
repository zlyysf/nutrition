package com.lingzhimobile.nutritionfoodguide;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;

import org.apache.commons.lang3.StringUtils;

import com.parse.ParseObject;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

public class StoredConfigTool {
	
	static final String LogTag = StoredConfigTool.class.getSimpleName();
	
	private static final String SharedPreferenceName = "userprof";
	
	private static final int Default_sex = 0;//Male 0, female 1
	private static final int Default_age = 30;
	private static final float Default_weight = 75;//kg
	private static final float Default_height = 175;//cm
	private static final int Default_activityLevel = 0;//0--3
	
	public static final String PreferenceKey_NutrientsToRecommend = "NutrientsToRecommend";
	public static final String Seperator_NutrientsToRecommend = ",,";
	
	public static final String PreferenceKey_alreadyLoadFromRemote = "alreadyLoadFromRemote";
	
	public static final String PreferenceKey_AppPart = "nutrientApp";
	public static String getPreferenceKey_AppWithVersionPart(Context ctx){
		int versionCode = Tool.getVersionCodeOfCurrentApp(ctx);
		return PreferenceKey_AppPart + versionCode;
	}
	
	public static String getPreferenceKey_AlertSettingAlreadyChecked_ofCurrentVersion(Context ctx){
		return getPreferenceKey_AppWithVersionPart(ctx)+"_AlertSettingAlreadyChecked";
	}
	//主要是支持app初次安装打开时设置提醒
	public static boolean getFlagAlertSettingAlreadyChecked_ofCurrentVersion(Context ctx){
		SharedPreferences sharedPref = ctx.getSharedPreferences(SharedPreferenceName,Activity.MODE_PRIVATE);
		boolean flag = sharedPref.getBoolean(getPreferenceKey_AlertSettingAlreadyChecked_ofCurrentVersion(ctx), false);
		return flag;
	}
	public static void setFlagAlertSettingAlreadyChecked_ofCurrentVersion(Context ctx){
		SharedPreferences sharedPref = ctx.getSharedPreferences(SharedPreferenceName,Activity.MODE_PRIVATE);
		SharedPreferences.Editor editor = sharedPref.edit();
		editor.putBoolean(getPreferenceKey_AlertSettingAlreadyChecked_ofCurrentVersion(ctx), true);
		editor.commit();
	}

	
	
	public static HashMap<String, Object> getUserInfo()
	{
		HashMap<String, Object> hmUserInfo = new HashMap<String, Object>();
		int sex = 0;//Male
	    int age = 25;
	    double weight=72;//kg
	    double height = 180;//cm
	    int activityLevel = 0;//0--3
		hmUserInfo.put(Constants.ParamKey_sex, Integer.valueOf(sex));
		hmUserInfo.put(Constants.ParamKey_age, Integer.valueOf(age));
		
		hmUserInfo.put(Constants.ParamKey_weight, Double.valueOf(weight));
		hmUserInfo.put(Constants.ParamKey_height, Double.valueOf(height));
		
		hmUserInfo.put(Constants.ParamKey_activityLevel, Integer.valueOf(activityLevel));
		
		return hmUserInfo;
	}
	
	public static HashMap<String, Object> getUserInfo(Context ctx)
	{
		SharedPreferences sharedPref = ctx.getSharedPreferences(SharedPreferenceName,Activity.MODE_PRIVATE);
		int sex = sharedPref.getInt(Constants.ParamKey_sex, Default_sex);
		long l_birthday = sharedPref.getLong(Constants.ParamKey_birthday, 0);
//		int age = sharedPref.getInt(Constants.ParamKey_age, Default_age);
		double weight = sharedPref.getFloat(Constants.ParamKey_weight, Default_weight);
		double height = sharedPref.getFloat(Constants.ParamKey_height, Default_height);
		int activityLevel = sharedPref.getInt(Constants.ParamKey_activityLevel, Default_activityLevel);
		
		long one = 1;
		long msInYear_ = one * 365*24*60*60*1000;
		
		Date dtNow = new Date();
		if (l_birthday == 0)
			l_birthday = dtNow.getTime() - Default_age*msInYear_;
		Date dt_birthday = new Date(l_birthday);
		long age = (dtNow.getTime() - dt_birthday.getTime()) / msInYear_;

		HashMap<String, Object> hmUserInfo = new HashMap<String, Object>();
		hmUserInfo.put(Constants.ParamKey_sex, Integer.valueOf(sex));
		hmUserInfo.put(Constants.ParamKey_birthday, dt_birthday);
		hmUserInfo.put(Constants.ParamKey_age, Integer.valueOf((int)age));
		hmUserInfo.put(Constants.ParamKey_weight, Double.valueOf(weight));
		hmUserInfo.put(Constants.ParamKey_height, Double.valueOf(height));
		hmUserInfo.put(Constants.ParamKey_activityLevel, Integer.valueOf(activityLevel));
		return hmUserInfo;
	}
	public static void saveUserInfo(Context ctx, HashMap<String, Object> userInfo){
		saveUserInfo_withPartItems(ctx,userInfo);
	}
	public static void saveUserInfo_withPartItems(Context ctx, HashMap<String, Object> userInfo){
		if(userInfo==null){
			return ;
		}
		Integer intObj_sex = (Integer)userInfo.get(Constants.ParamKey_sex);
		Date dt_birthday = (Date)userInfo.get(Constants.ParamKey_birthday);
//		Integer intObj_age = (Integer)userInfo.get(Constants.ParamKey_age);
		Double dblObj_weight = (Double)userInfo.get(Constants.ParamKey_weight);
		Double dblObj_height = (Double)userInfo.get(Constants.ParamKey_height);
		Integer intObj_activityLevel = (Integer)userInfo.get(Constants.ParamKey_activityLevel);
//		Log.d(LogTag,"in saveUserInfo_withPartItems, dblObj_weight="+dblObj_weight+", dblObj_height="+dblObj_height);
		
		
		SharedPreferences sharedPref = ctx.getSharedPreferences(SharedPreferenceName,Activity.MODE_PRIVATE);
		SharedPreferences.Editor editor = sharedPref.edit();
		
		if(intObj_sex!=null) editor.putInt(Constants.ParamKey_sex, intObj_sex.intValue());
		if (dt_birthday!=null) editor.putLong(Constants.ParamKey_birthday, dt_birthday.getTime());
//		if(intObj_age!=null) editor.putInt(Constants.ParamKey_age, intObj_age.intValue());
		if(dblObj_weight!=null) editor.putFloat(Constants.ParamKey_weight, dblObj_weight.floatValue());
		if(dblObj_height!=null) editor.putFloat(Constants.ParamKey_height, dblObj_height.floatValue());
		if(intObj_activityLevel!=null) editor.putInt(Constants.ParamKey_activityLevel, intObj_activityLevel.intValue());
		
		editor.commit();
	}
	
	
	
	public static String[] getNutrientsToRecommend(Context ctx){
		SharedPreferences sharedPref = ctx.getSharedPreferences(SharedPreferenceName,Activity.MODE_PRIVATE);
		String nutrientsStr = sharedPref.getString(PreferenceKey_NutrientsToRecommend, null);
		String[] nutrients ;
		if (nutrientsStr == null){
//			return null;
			nutrients = NutritionTool.getCustomNutrients(null);
		}else{
			nutrients = nutrientsStr.split(Seperator_NutrientsToRecommend);
		}
		return nutrients;
	}
	public static void saveNutrientsToRecommend(Context ctx, ArrayList<String> nutrientsAl){
		SharedPreferences sharedPref = ctx.getSharedPreferences(SharedPreferenceName,Activity.MODE_PRIVATE);
		if (nutrientsAl != null && nutrientsAl.size() > 0){
			String nutrientsStr = StringUtils.join(nutrientsAl, Seperator_NutrientsToRecommend);
			SharedPreferences.Editor editor = sharedPref.edit();
			editor.putString(PreferenceKey_NutrientsToRecommend, nutrientsStr);
			
			editor.commit();
		}
	}
	public static void saveNutrientsToRecommend(Context ctx, String[] nutrients){
//		SharedPreferences sharedPref = ctx.getSharedPreferences(SharedPreferenceName,Activity.MODE_PRIVATE);
//		if (nutrients != null && nutrients.length > 0){
//			String nutrientsStr = StringUtils.join(nutrients, Seperator_NutrientsToRecommend);
//			SharedPreferences.Editor editor = sharedPref.edit();
//			editor.putString(PreferenceKey_NutrientsToRecommend, nutrientsStr);
//			
//			editor.commit();
//		}
		saveNutrientsToRecommend(ctx,Tool.convertFromArrayToList(nutrients));
	}
	
	private static final String DBalreadyUpdatedKey = "DBalreadyUpdated_" + Constants.DBupdateTime;
	
	public static boolean getDBalreadyUpdated(Context ctx)
	{
		SharedPreferences sharedPref = ctx.getSharedPreferences(SharedPreferenceName,Activity.MODE_PRIVATE);
		boolean dbUpdated = sharedPref.getBoolean(DBalreadyUpdatedKey, false);
		return dbUpdated;
	}
	public static void setDBalreadyUpdated(Context ctx){
		SharedPreferences sharedPref = ctx.getSharedPreferences(SharedPreferenceName,Activity.MODE_PRIVATE);
		SharedPreferences.Editor editor = sharedPref.edit();
		editor.putBoolean(DBalreadyUpdatedKey, true);
		editor.commit();
	}
	
	private static final String Key_alreadyBeOpenedAtCurrentInstall = "alreadyBeOpenedAtCurrentInstall";
	
	public static boolean isFirstBeOpenedAtCurrentInstall(Context ctx)
	{
		SharedPreferences sharedPref = ctx.getSharedPreferences(SharedPreferenceName,Activity.MODE_PRIVATE);
		boolean alreadyBeOpened = sharedPref.getBoolean(Key_alreadyBeOpenedAtCurrentInstall, false);
		boolean firstBeOpened = !alreadyBeOpened;
		
		if (!alreadyBeOpened){
			SharedPreferences.Editor editor = sharedPref.edit();
			editor.putBoolean(Key_alreadyBeOpenedAtCurrentInstall, true);
			editor.commit();
		}
		
		return firstBeOpened;
	}

	

	
	
	
	public static HashMap<String, Object> getAlertSetting(Context ctx)
	{
		SharedPreferences sharedPref = ctx.getSharedPreferences(SharedPreferenceName,Activity.MODE_PRIVATE);
		boolean AlertSetting_EnableFlag = sharedPref.getBoolean(Constants.PreferenceKey_AlertSetting_EnableFlag, Constants.Default_AlertSetting_EnableFlag);
		int Morning_Hour = sharedPref.getInt(Constants.PreferenceKey_AlertSetting_Morning_Hour, Constants.Default_Morning_Hour);
		int Morning_Minute = sharedPref.getInt(Constants.PreferenceKey_AlertSetting_Morning_Minute, Constants.Default_Morning_Minute);
		int Afternoon_Hour = sharedPref.getInt(Constants.PreferenceKey_AlertSetting_Afternoon_Hour, Constants.Default_Afternoon_Hour);
		int Afternoon_Minute = sharedPref.getInt(Constants.PreferenceKey_AlertSetting_Afternoon_Minute, Constants.Default_Afternoon_Minute);
		int Night_Hour = sharedPref.getInt(Constants.PreferenceKey_AlertSetting_Night_Hour, Constants.Default_Night_Hour);
		int Night_Minute = sharedPref.getInt(Constants.PreferenceKey_AlertSetting_Night_Minute, Constants.Default_Night_Minute);
		
		HashMap<String, Object> hmAlertSetting = new HashMap<String, Object>();
		hmAlertSetting.put(Constants.PreferenceKey_AlertSetting_EnableFlag, Boolean.valueOf(AlertSetting_EnableFlag));
		hmAlertSetting.put(Constants.PreferenceKey_AlertSetting_Morning_Hour, Integer.valueOf(Morning_Hour));
		hmAlertSetting.put(Constants.PreferenceKey_AlertSetting_Morning_Minute, Integer.valueOf(Morning_Minute));
		hmAlertSetting.put(Constants.PreferenceKey_AlertSetting_Afternoon_Hour, Integer.valueOf(Afternoon_Hour));
		hmAlertSetting.put(Constants.PreferenceKey_AlertSetting_Afternoon_Minute, Integer.valueOf(Afternoon_Minute));
		hmAlertSetting.put(Constants.PreferenceKey_AlertSetting_Night_Hour, Integer.valueOf(Night_Hour));
		hmAlertSetting.put(Constants.PreferenceKey_AlertSetting_Night_Minute, Integer.valueOf(Night_Minute));
		return hmAlertSetting;
	}
	// value<0 means not set
	public static void saveAlertSetting(Context ctx,Boolean enableAlertSetting, Integer Morning_Hour,Integer Morning_Minute, Integer Afternoon_Hour,Integer Afternoon_Minute, Integer Night_Hour,Integer Night_Minute){
		SharedPreferences sharedPref = ctx.getSharedPreferences(SharedPreferenceName,Activity.MODE_PRIVATE);
		SharedPreferences.Editor editor = sharedPref.edit();
		if (enableAlertSetting!=null)  editor.putBoolean(Constants.PreferenceKey_AlertSetting_EnableFlag, enableAlertSetting);
		if (Morning_Hour!=null)  editor.putInt(Constants.PreferenceKey_AlertSetting_Morning_Hour, Morning_Hour);
		if (Morning_Minute!=null)  editor.putInt(Constants.PreferenceKey_AlertSetting_Morning_Minute, Morning_Minute);
		if (Afternoon_Hour!=null)  editor.putInt(Constants.PreferenceKey_AlertSetting_Afternoon_Hour, Afternoon_Hour);
		if (Afternoon_Minute!=null)  editor.putInt(Constants.PreferenceKey_AlertSetting_Afternoon_Minute, Afternoon_Minute);
		if (Night_Hour!=null)  editor.putInt(Constants.PreferenceKey_AlertSetting_Night_Hour, Night_Hour);
		if (Night_Minute!=null)  editor.putInt(Constants.PreferenceKey_AlertSetting_Night_Minute, Night_Minute);
		editor.commit();
	}
	

	public static void saveNutrientsToRecommendxx(Context ctx, ArrayList<String> nutrientsAl){
		SharedPreferences sharedPref = ctx.getSharedPreferences(SharedPreferenceName,Activity.MODE_PRIVATE);
		if (nutrientsAl != null && nutrientsAl.size() > 0){
			String nutrientsStr = StringUtils.join(nutrientsAl, Seperator_NutrientsToRecommend);
			SharedPreferences.Editor editor = sharedPref.edit();
			editor.putString(PreferenceKey_NutrientsToRecommend, nutrientsStr);
			
			editor.commit();
		}
	}

	
	public static HashMap<String, Object> getParseObjectInfo_CurrentUserRecordSymptom(Context ctx)
	{
		SharedPreferences sharedPref = ctx.getSharedPreferences(SharedPreferenceName,Activity.MODE_PRIVATE);
		String parseObjId = sharedPref.getString(Constants.ParseObjectKey_objectId, "");
		int dayLocal = sharedPref.getInt(Constants.COLUMN_NAME_DayLocal, 0);

		HashMap<String, Object> hm = new HashMap<String, Object>();
		hm.put(Constants.ParseObjectKey_objectId, parseObjId);
		hm.put(Constants.COLUMN_NAME_DayLocal, Integer.valueOf(dayLocal));
		return hm;
	}
	public static void saveParseObjectInfo_CurrentUserRecordSymptom(Context ctx, HashMap<String, Object> hmData){
		String parseObjId = null;
		int dayLocal = 0;
		if (hmData!=null){
			parseObjId = (String)hmData.get(Constants.ParseObjectKey_objectId);
			Integer intObj_dayLocal = (Integer)hmData.get(Constants.COLUMN_NAME_DayLocal);
			if (intObj_dayLocal!=null)
				dayLocal = intObj_dayLocal.intValue();
		}
		
		saveParseObjectInfo_CurrentUserRecordSymptom(ctx,parseObjId,dayLocal);
	}
	public static void saveParseObjectInfo_CurrentUserRecordSymptom(Context ctx, String parseObjId, int dayLocal){
		SharedPreferences sharedPref = ctx.getSharedPreferences(SharedPreferenceName,Activity.MODE_PRIVATE);
		SharedPreferences.Editor editor = sharedPref.edit();
		editor.putString(Constants.ParseObjectKey_objectId, parseObjId);
		editor.putInt(Constants.COLUMN_NAME_DayLocal, dayLocal);
		editor.commit();
	}
	
	public static boolean getFlagAlreadyLoadFromRemote(Context ctx){
		SharedPreferences sharedPref = ctx.getSharedPreferences(SharedPreferenceName,Activity.MODE_PRIVATE);
		boolean flag = sharedPref.getBoolean(PreferenceKey_alreadyLoadFromRemote, false);
		return flag;
	}
	public static void setFlagAlreadyLoadFromRemote(Context ctx){
		SharedPreferences sharedPref = ctx.getSharedPreferences(SharedPreferenceName,Activity.MODE_PRIVATE);
		SharedPreferences.Editor editor = sharedPref.edit();
		editor.putBoolean(PreferenceKey_alreadyLoadFromRemote, true);
		editor.commit();
	}

	
	
}
