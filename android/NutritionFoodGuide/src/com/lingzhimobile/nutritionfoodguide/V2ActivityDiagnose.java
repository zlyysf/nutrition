package com.lingzhimobile.nutritionfoodguide;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

import org.apache.commons.lang3.StringUtils;


import com.lingzhimobile.nutritionfoodguide.ActivityDiagnoseResult.GridAdapter_Nutrients.OnClickListenerInGrid;
import com.lingzhimobile.nutritionfoodguide.ActivityFoodByClass.ListAdapterForFood;
import com.lingzhimobile.nutritionfoodguide.ActivityFoodCombination.ExpandableListAdapter_FoodNutrition.OnClickListenerToAddFoodByNutrient;
import com.lingzhimobile.nutritionfoodguide.ActivityFoodCombination.ExpandableListAdapter_FoodNutrition.OnClickListenerToEditFoodAmount;
import com.lingzhimobile.nutritionfoodguide.ActivityFoodCombination.ExpandableListAdapter_FoodNutrition.OnClickListenerToShowNutrientDescription;
import com.lingzhimobile.nutritionfoodguide.ActivityFoodCombinationList.FoodCombinationAdapter.OnClickListenerToDeleteRow;
import com.lingzhimobile.nutritionfoodguide.DialogHelperSimpleInput.InterfaceWhenConfirmInput;
import com.lingzhimobile.nutritionfoodguide.OnClickListenerInExpandListItem.Data2LevelPosition;
import com.umeng.analytics.MobclickAgent;



import android.R.integer;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.database.DataSetObserver;
import android.graphics.Color;
import android.graphics.PorterDuff.Mode;
import android.graphics.drawable.ClipDrawable;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.LayerDrawable;
import android.graphics.drawable.ShapeDrawable;
import android.graphics.drawable.StateListDrawable;
import android.graphics.drawable.shapes.RoundRectShape;

import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import android.os.DropBoxManager.Entry;
import android.os.Handler;
import android.os.Message;
import android.support.v4.widget.SimpleCursorAdapter.ViewBinder;
import android.text.InputType;
import android.util.*;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.*;
import android.widget.LinearLayout.LayoutParams;
import android.widget.ExpandableListView.*;


@SuppressWarnings("unchecked")
public class V2ActivityDiagnose extends ActivityBase {
	static final String LogTag = "V2ActivityDiagnose";
	
	static final int[] checkboxColorCheckedResIds = {R.color.red, R.color.green, R.color.blue};
	static final int checkboxColorNormalResId = R.color.gray;
	
	Activity m_this; 
	
//	HashMap<String,HashMap<String,ArrayList<String>>> m_symptomDataBy2LevelClass;
	HashMap<String,Object> m_symptomDataBy2LevelClass;
//	ArrayList<String> m_level1classes;
	
	ListView m_listView1;
	ListAdapter_LevelTop m_ListAdapter_LevelTop; 
	
	myProgressDialog m_prgressDialog;
	private AsyncTaskDoRecommend m_AsyncTaskDoRecommend;
	
	public Handler myHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            if (m_prgressDialog!=null)
            	m_prgressDialog.dismiss();
            switch (msg.what) {
            case Constants.MessageID_OK:

                break;
            }
        }
    };
    

	public void onResume() {
		super.onResume();
		MobclickAgent.onResume(this);
	}
	public void onPause() {
		super.onPause();
		MobclickAgent.onPause(this);
	}
	


	@Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.v2_activity_diagnose);
        
        m_this = this;
      
        initViewHandles();
        initViewsContent();
        setViewEventHandlers();
        setViewsContent();
    }
	
	void initViewHandles(){
        m_listView1 = (ListView)this.findViewById(R.id.listView1);
	}
	void initViewsContent(){
		ArrayList<String> level1classes = Tool.convertFromArrayToList(new String[]{"头和五官","消化"});
        ArrayList<String> level1class1_subclasses = Tool.convertFromArrayToList(new String[]{"脸","眼睛","鼻子","耳朵"});
        ArrayList<String> level1class2_subclasses = Tool.convertFromArrayToList(new String[]{"肠","胃","肝"});
        
        ArrayList<String> symptoms1 = Tool.convertFromArrayToList(new String[]{"干燥","浮肿","裂口","堵塞","痛","眩晕"});
        ArrayList<String> symptoms2 = Tool.convertFromArrayToList(new String[]{"干燥","浮肿","裂口","堵塞","痛","眩晕"
        		,"干燥AAAA","浮肿AAAAssssssssssssssssssssssssssssssssdddddddddddddddddd","裂口AAAA","堵塞AAAA","痛AAAA","眩晕AAAA"});
        
        HashMap<String,Object> symptomDataBy2LevelClass = new HashMap<String, Object>();
        
        HashMap<String,Object> symptomDataBy1LevelClass = new HashMap<String, Object>();
        for(int i=0; i<level1class1_subclasses.size(); i++){
        	String level1class = level1class1_subclasses.get(i);
        	symptomDataBy1LevelClass.put(level1class, symptoms1);
        }
        symptomDataBy1LevelClass.put("orderedkeys", level1class1_subclasses);
        symptomDataBy2LevelClass.put(level1classes.get(0), symptomDataBy1LevelClass);
        
        symptomDataBy1LevelClass = new HashMap<String, Object>();
        for(int i=0; i<level1class2_subclasses.size(); i++){
        	String level1class = level1class2_subclasses.get(i);
        	symptomDataBy1LevelClass.put(level1class, symptoms2);
        }
        symptomDataBy1LevelClass.put("orderedkeys", level1class2_subclasses);
        symptomDataBy2LevelClass.put(level1classes.get(1), symptomDataBy1LevelClass);
        
        symptomDataBy2LevelClass.put("orderedkeys", level1classes);
        
        m_symptomDataBy2LevelClass = symptomDataBy2LevelClass;
	}
	void setViewEventHandlers(){
 
	}
	void setViewsContent(){
        m_ListAdapter_LevelTop = new ListAdapter_LevelTop(m_symptomDataBy2LevelClass);
        m_listView1.setAdapter(m_ListAdapter_LevelTop);
	}
	

	public class ListAdapter_LevelTop extends BaseAdapter
	{
		ArrayList<String> m_level2classes ;
		HashMap<String,Object> m_symptomDataBy2LevelClass;
		public ListAdapter_LevelTop(HashMap<String,Object> symptomDataBy2LevelClass){
			m_symptomDataBy2LevelClass = symptomDataBy2LevelClass;
			m_level2classes = (ArrayList<String>)m_symptomDataBy2LevelClass.get("orderedkeys");
		}
		
		@Override
		public int getCount() {
//			return 1+m_level2classes.size()*2+4;
			return 1+m_level2classes.size()*2;
		}
		@Override
		public Object getItem(int position) {
			return null;
		}
		@Override
		public long getItemId(int position) {
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			View vw;
			if (position == 0){
				vw = getLayoutInflater().inflate(R.layout.v2_row_seperator, null);
				TextView tv1 = (TextView)vw.findViewById(R.id.textView1);
				tv1.setText("今天哪里不舒服吗？点击记录一下吧。");
			}else if (position % 2 == 0){
				vw = getLayoutInflater().inflate(R.layout.v2_row_seperator, null);
			}else{
				int sectionPos = (position-1)/2;
				
				String level2class = m_level2classes.get(sectionPos);
				
				
				vw = getLayoutInflater().inflate(R.layout.v2_item_list, null);
				ListView listView1 = (ListView)vw.findViewById(R.id.listView1);
				
				ListAdapter_OfLevel2Class ListAdapter_OfLevel2Class1 = new ListAdapter_OfLevel2Class(level2class);
				listView1.setAdapter(ListAdapter_OfLevel2Class1);
				
			}
			return vw;
		}
		
		public void notifyDataSetChanged(){
			super.notifyDataSetChanged();
		}
	}//class ExpandableListAdapter_DiagnoseResult
	
	static void changeViewBackground(Activity curActv, View vw, int bgColorResId){
		final float[] roundedCorners = new float[] { 5, 5, 5, 5, 5, 5, 5, 5 };
		RoundRectShape roundRectShape1 = new RoundRectShape(roundedCorners, null,null);
		ShapeDrawable roundShape_bgColor = new ShapeDrawable(roundRectShape1);
		roundShape_bgColor.getPaint().setColor(curActv.getResources().getColor(bgColorResId));
		vw.setBackgroundDrawable(roundShape_bgColor);
//		vw.setBackground(roundShape_bgColor);
	}

	
	//http://stackoverflow.com/questions/8308871/define-selector-in-code
	static void changeCheckboxBackgroundWithSelector(Activity curActv, CompoundButton cb, int normalColorResId, int checkedColorResId){
//		ColorDrawable normalColorDrawable = new ColorDrawable(curActv.getResources().getColor(normalColorResId));
//		ColorDrawable checkedColorDrawable = new ColorDrawable(curActv.getResources().getColor(checkedColorResId));
//		StateListDrawable statesDrawable = new StateListDrawable();
//		statesDrawable.addState(new int[] {android.R.attr.state_checked},checkedColorDrawable);
//		statesDrawable.addState(new int[] { },normalColorDrawable);
		
		final float[] roundedCorners = new float[] { 5, 5, 5, 5, 5, 5, 5, 5 };
		RoundRectShape roundRectShape1 = new RoundRectShape(roundedCorners, null,null);
		
		ShapeDrawable roundShape_checkedColor = new ShapeDrawable(roundRectShape1);
		roundShape_checkedColor.getPaint().setColor(curActv.getResources().getColor(checkedColorResId));
		
		ShapeDrawable roundShape_normalColor = new ShapeDrawable(roundRectShape1);
		roundShape_normalColor.getPaint().setColor(curActv.getResources().getColor(normalColorResId));
		
		StateListDrawable statesDrawable = new StateListDrawable();
		statesDrawable.addState(new int[] {android.R.attr.state_checked},roundShape_checkedColor);
		statesDrawable.addState(new int[] { },roundShape_normalColor);
		
//		cb.setBackground(statesDrawable);
		cb.setBackgroundDrawable(statesDrawable);
//		cb.setButtonDrawable(statesDrawable);
	}
	
	class ListAdapter_OfLevel2Class extends BaseAdapter{
		
		String m_level2class ;
		HashMap<String,Object> m_symptomDataOfLevel2Class;
		ArrayList<String> m_orderedLevel1Classes ;
		
		public ListAdapter_OfLevel2Class(String level2class){
			m_level2class = level2class;
			m_symptomDataOfLevel2Class = (HashMap<String,Object>)m_symptomDataBy2LevelClass.get(level2class);
			m_orderedLevel1Classes = (ArrayList<String>)m_symptomDataOfLevel2Class.get("orderedkeys");
		}
		
		@Override
		public int getCount() {
			return m_orderedLevel1Classes.size()+1 ;
		}
		@Override
		public Object getItem(int pos) {
			return m_orderedLevel1Classes.get(pos);
		}
		@Override
		public long getItemId(int pos) {
			return pos;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			View vw;
			if (position == 0){
				vw = getLayoutInflater().inflate(R.layout.v2_row_seperator, null);
				TextView tv1 = (TextView)vw.findViewById(R.id.textView1);
				tv1.setText(m_level2class);
			}else{
//				vw = getLayoutInflater().inflate(R.layout.v2_item_symptoms_bylevel1class, null);
				vw = getLayoutInflater().inflate(R.layout.v2_item_symptoms_flow, null);
				
				String level1class = m_orderedLevel1Classes.get(position-1) ;
				
//				CheckBox cbSymptomClass = (CheckBox)vw.findViewById(R.id.cbSymptomClass);
////				cbSymptomClass.setText(level1class);
//				changeCheckboxBackgroundWithSelector(m_this, cbSymptomClass, checkboxColorNormalResId, checkboxColorCheckedResIds[position%checkboxColorCheckedResIds.length]);
				
				TextView tvSymptomClass = (TextView)vw.findViewById(R.id.tvSymptomClass);
				tvSymptomClass.setText(level1class);
				changeViewBackground(m_this, tvSymptomClass, checkboxColorCheckedResIds[position%checkboxColorCheckedResIds.length]);
				
//				GridView gridView1_Symptoms = (GridView)vw.findViewById(R.id.gridView1);
//				GridAdapter_Symptoms GridAdapter_Symptoms1 = new GridAdapter_Symptoms(m_symptomDataOfLevel2Class,level1class);
//				gridView1_Symptoms.setAdapter(GridAdapter_Symptoms1);
				
				FlowLayoutApmeM ctrlFlowLayout = (FlowLayoutApmeM)vw.findViewById(R.id.ctrlFlowLayout);
				ArrayList<String> symptomDataOfLevel1Class = (ArrayList<String>)m_symptomDataOfLevel2Class.get(level1class);
				Tool_FlowLayout_Symptoms Tool_FlowLayout_Symptoms1 = new Tool_FlowLayout_Symptoms(ctrlFlowLayout,symptomDataOfLevel1Class);
				Tool_FlowLayout_Symptoms1.addCellViews();
			}
			return vw;
		}
	}//class ListAdapter_OfLevel2Class
	
//	class GridAdapter_Symptoms extends BaseAdapter{
//		
//		HashMap<String,Object> m_symptomDataOfLevel2Class;
//		String m_level1class;
//		ArrayList<String> m_symptomDataOfLevel1Class;
//		
//		public GridAdapter_Symptoms(HashMap<String,Object> symptomDataOfLevel2Class, String level1class){
//
//			m_symptomDataOfLevel2Class = symptomDataOfLevel2Class;
//			m_level1class = level1class;
//			m_symptomDataOfLevel1Class = (ArrayList<String>)m_symptomDataOfLevel2Class.get(m_level1class);
//		}
//		
//		@Override
//		public int getCount() {
//			return m_symptomDataOfLevel1Class.size() ;
//		}
//		@Override
//		public Object getItem(int pos) {
//			return m_symptomDataOfLevel1Class.get(pos);
//		}
//		@Override
//		public long getItemId(int pos) {
//			return pos;
//		}
//
//		@Override
//		public View getView(int position, View convertView, ViewGroup parent) {
//			String symptom = m_symptomDataOfLevel1Class.get(position);
//			
//			
//			View vw = getLayoutInflater().inflate(R.layout.v2_grid_cell_symptom_frame, null);
////			View vw = getLayoutInflater().inflate(R.layout.v2_grid_cell_symptom_relative, null);
//			CheckBox cbSymptom = (CheckBox)vw.findViewById(R.id.cbSymptom);
////			cbSymptom.setText(symptom);
//			changeCheckboxBackgroundWithSelector(m_this, cbSymptom, checkboxColorNormalResId, checkboxColorCheckedResIds[position%checkboxColorCheckedResIds.length]);
//			
//			TextView tvSymptom = (TextView)vw.findViewById(R.id.tvSymptom);
//			tvSymptom.setText(symptom);
//			
//			return vw;
//		}
//	}
    
	class Tool_FlowLayout_Symptoms{
		FlowLayoutApmeM m_ctrlFlowLayout;
		//int m_cellResId, m_txtItemInCellResId;
		ArrayList<String> m_symptoms;
		ArrayList<CheckBox> m_CheckBoxs;
		
		public Tool_FlowLayout_Symptoms(FlowLayoutApmeM ctrlFlowLayout, ArrayList<String> symptoms){
			m_ctrlFlowLayout = ctrlFlowLayout;
			m_symptoms = symptoms;
			m_CheckBoxs = new ArrayList<CheckBox>();
			
		}
		
		public void addCellViews(){
//			View wholeVw = getLayoutInflater().inflate(R.layout.v2_control_flowlayout_symptoms, null);
//			FlowLayoutApmeM ctrlFlowLayout = (FlowLayoutApmeM)wholeVw.findViewById(R.id.ctrlFlowLayout);
			if (m_symptoms != null){
				for(int i=0; i<m_symptoms.size(); i++){
					String symptom = m_symptoms.get(i);
//					View vwCell = getLayoutInflater().inflate(R.layout.v2_grid_cell_symptom_frame, null);
//					View vwCell = getLayoutInflater().inflate(R.layout.v2_grid_cell_symptom_relative, null);
					View vwCell = getLayoutInflater().inflate(R.layout.v2_grid_cell_symptom_cb, null);
					
					CheckBox cbSymptom = (CheckBox)vwCell.findViewById(R.id.cbSymptom);
					changeCheckboxBackgroundWithSelector(m_this, cbSymptom, checkboxColorNormalResId, checkboxColorCheckedResIds[i%checkboxColorCheckedResIds.length]);
					m_CheckBoxs.add(cbSymptom);
					
					cbSymptom.setText(symptom);
					
//					TextView tvSymptom = (TextView)vwCell.findViewById(R.id.tvSymptom);
//					tvSymptom.setText(symptom);
					
					m_ctrlFlowLayout.addView(vwCell);
				}//for
			}
		}
		
	}
}













