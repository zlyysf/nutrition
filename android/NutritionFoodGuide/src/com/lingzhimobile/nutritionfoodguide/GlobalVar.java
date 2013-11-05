package com.lingzhimobile.nutritionfoodguide;

import java.io.IOException;
import java.util.ArrayList;

import android.R.bool;
import android.content.Context;
import android.database.Cursor;
import android.util.Log;


public class GlobalVar {

	
	public static ArrayList<String> DiseaseGroups = null;
	public static ArrayList<ArrayList<String>> DiseasesOfGroup_Collection = null;
	
	
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
	
	
	

}
