package com.lingzhimobile.nutritionfoodguide;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

import android.R.bool;
import android.content.Context;
import android.database.Cursor;
import android.util.Log;


public class GlobalVar {
	
	public static boolean UserDiagnoseRecordHaveUpdated_forHistory = false;

	public static ArrayList<String> DiseaseGroups = null;
	public static ArrayList<ArrayList<String>> DiseasesOfGroup_Collection = null;
	
	static HashMap<String, HashMap<String, Object>> m_illnessInfoDict2Level = null;
	static HashMap<String, HashMap<String, Object>> m_symptomTypeInfoDict2Level = null;
	static HashMap<String, HashMap<String, Object>> m_symptomInfoDict2Level = null;
	static HashMap<String, HashMap<String, Object>> m_nutrientInfoDict2Level = null;
	static HashMap<String, HashMap<String, Object>> m_foodInfoDict2Level = null;
	static HashMap<String, HashMap<String, Object>> m_suggestionInfoDict2Level = null;
	
	
	public static void InitDiseaseAndGroupData(Context ctx) 
			throws IOException
	{
		if (DiseaseGroups==null && DiseasesOfGroup_Collection==null){
			DataAccess da = DataAccess.getSingleton(ctx);//throws IOException
			Cursor csGroups = da.getDiseaseGroupInfo_byType_old("wizard");
			ArrayList<String> alGroup = Tool.getDataFromCursor(csGroups, 0);
			csGroups.close();
			DiseaseGroups = alGroup;
			assert(DiseaseGroups.size()==3);
			
			DiseasesOfGroup_Collection = new ArrayList<ArrayList<String>>(DiseaseGroups.size());
			for(int i=0; i<DiseaseGroups.size(); i++){
				String groupName = DiseaseGroups.get(i);
				Cursor csDisease = da.getDiseaseNamesOfGroup(groupName);
				ArrayList<String> alDisease = Tool.getDataFromCursor(csDisease, 0);
				csDisease.close();
				assert(alDisease.size()>0);
				DiseasesOfGroup_Collection.add(alDisease);
			}
		}
	}
	
	public static HashMap<String, HashMap<String, Object>> getAllIllness2LevelDict(Context ctx){
		if (m_illnessInfoDict2Level == null){
			DataAccess da = DataAccess.getSingleton(ctx);
			ArrayList<HashMap<String, Object>> illnessRows = da.getAllIllness();
			m_illnessInfoDict2Level = Tool.dictionaryArrayTo2LevelDictionary_withKeyName(Constants.COLUMN_NAME_IllnessId,illnessRows);
		}
		return m_illnessInfoDict2Level;
	}
	
	public static HashMap<String, HashMap<String, Object>> getAllSymptomType2LevelDict(Context ctx){
		if (m_symptomTypeInfoDict2Level == null){
			DataAccess da = DataAccess.getSingleton(ctx);
			ArrayList<HashMap<String, Object>> symptomTypeRows = da.getSymptomTypeRows_withForSex(null);
			m_symptomTypeInfoDict2Level = Tool.dictionaryArrayTo2LevelDictionary_withKeyName(Constants.COLUMN_NAME_SymptomTypeId,symptomTypeRows);
		}
		return m_symptomTypeInfoDict2Level;
	}
	
	public static HashMap<String, HashMap<String, Object>> getAllSymptom2LevelDict(Context ctx){
		if (m_symptomInfoDict2Level == null){
			DataAccess da = DataAccess.getSingleton(ctx);
			ArrayList<HashMap<String, Object>> symptomRows = da.getSymptomRows_BySymptomIds(null);
			m_symptomInfoDict2Level = Tool.dictionaryArrayTo2LevelDictionary_withKeyName(Constants.COLUMN_NAME_SymptomId,symptomRows);
		}
		return m_symptomInfoDict2Level;
	}
	
	public static HashMap<String, HashMap<String, Object>> getAllNutrient2LevelDict(Context ctx){
		if (m_nutrientInfoDict2Level == null){
			DataAccess da = DataAccess.getSingleton(ctx);
			m_nutrientInfoDict2Level = da.getNutrientInfoAs2LevelDictionary_withNutrientIds(null);
		}
		return m_nutrientInfoDict2Level;
	}
	
	public static HashMap<String, HashMap<String, Object>> getAllFood2LevelDict(Context ctx){
		if (m_foodInfoDict2Level == null){
			DataAccess da = DataAccess.getSingleton(ctx);
			ArrayList<HashMap<String, Object>> foodRows = da.getAllFood();
			m_foodInfoDict2Level = Tool.dictionaryArrayTo2LevelDictionary_withKeyName(Constants.COLUMN_NAME_NDB_No,foodRows);
		}
		return m_foodInfoDict2Level;
	}
	
	public static HashMap<String, HashMap<String, Object>> getAllSuggestion2LevelDict(Context ctx){
		if (m_suggestionInfoDict2Level == null){
			DataAccess da = DataAccess.getSingleton(ctx);
			ArrayList<HashMap<String, Object>> suggestionRows = da.getIllnessSuggestions_BySuggestionIds(null);
			m_suggestionInfoDict2Level = Tool.dictionaryArrayTo2LevelDictionary_withKeyName(Constants.COLUMN_NAME_SuggestionId,suggestionRows);
		}
		return m_suggestionInfoDict2Level;
	}

}


















