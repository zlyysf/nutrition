package com.lingzhimobile.nutritionfoodguide;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;

import org.apache.commons.lang3.StringUtils;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;

public class StoredConfigTool {
	
	private static final String SharedPreferenceName = "userprof";
	
	private static final int Default_sex = 0;//Male 0, female 1
	private static final int Default_age = 30;
	private static final float Default_weight = 75;//kg
	private static final float Default_height = 175;//cm
	private static final int Default_activityLevel = 0;//0--3
	
	public static final String PreferenceKey_NutrientsToRecommend = "NutrientsToRecommend";
	public static final String Seperator_NutrientsToRecommend = ",,";
	
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
		int age = sharedPref.getInt(Constants.ParamKey_age, Default_age);
		double weight = sharedPref.getFloat(Constants.ParamKey_weight, Default_weight);
		double height = sharedPref.getFloat(Constants.ParamKey_height, Default_height);
		int activityLevel = sharedPref.getInt(Constants.ParamKey_activityLevel, Default_activityLevel);

		HashMap<String, Object> hmUserInfo = new HashMap<String, Object>();
		hmUserInfo.put(Constants.ParamKey_sex, Integer.valueOf(sex));
		hmUserInfo.put(Constants.ParamKey_age, Integer.valueOf(age));
		hmUserInfo.put(Constants.ParamKey_weight, Double.valueOf(weight));
		hmUserInfo.put(Constants.ParamKey_height, Double.valueOf(height));
		hmUserInfo.put(Constants.ParamKey_activityLevel, Integer.valueOf(activityLevel));
		return hmUserInfo;
	}
	public static void saveUserInfo(Context ctx, HashMap<String, Object> userInfo){
		if(userInfo==null){
			return ;
		}
		Integer intObj_sex = (Integer)userInfo.get(Constants.ParamKey_sex);
		Integer intObj_age = (Integer)userInfo.get(Constants.ParamKey_age);
		Double dblObj_weight = (Double)userInfo.get(Constants.ParamKey_weight);
		Double dblObj_height = (Double)userInfo.get(Constants.ParamKey_height);
		Integer intObj_activityLevel = (Integer)userInfo.get(Constants.ParamKey_activityLevel);
		int sex = Default_sex;
		int age = Default_age;
		double weight = Default_weight;
		double height = Default_height;
		int activityLevel = Default_activityLevel;
		
		if (intObj_sex!=null)
			sex = intObj_sex.intValue();
		if (intObj_age!=null)
			age = intObj_age.intValue();
		if (dblObj_weight!=null)
			weight = dblObj_weight.doubleValue();
		if (dblObj_height!=null)
			height = dblObj_height.doubleValue();
		if (intObj_activityLevel!=null)
			activityLevel = intObj_activityLevel.intValue();
		
		SharedPreferences sharedPref = ctx.getSharedPreferences(SharedPreferenceName,Activity.MODE_PRIVATE);
		SharedPreferences.Editor editor = sharedPref.edit();
		editor.putInt(Constants.ParamKey_sex, sex);
		editor.putInt(Constants.ParamKey_age, age);
		editor.putFloat(Constants.ParamKey_weight, (float)weight);
		editor.putFloat(Constants.ParamKey_height, (float)height);
		editor.putInt(Constants.ParamKey_activityLevel, activityLevel);
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

}
