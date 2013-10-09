package com.lingzhimobile.nutritionfoodguide;


import android.view.*;

public abstract class OnClickListenerInExpandListItem implements View.OnClickListener {
    static public class Data2LevelPosition {
		public int groupPos;
		public int childPos;
	}
    
    Data2LevelPosition m_Data2LevelPosition ;
	public void initInputData(Data2LevelPosition data2LevelPos){
		m_Data2LevelPosition = data2LevelPos;
	}
	public void initInputData(int groupPosition,int childPosition){
		m_Data2LevelPosition = new Data2LevelPosition();
		m_Data2LevelPosition.groupPos = groupPosition;
		m_Data2LevelPosition.childPos = childPosition;
	}
}
