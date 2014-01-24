package com.lingzhimobile.nutritionfoodguide.v3.fragment;

import java.util.ArrayList;
import java.util.HashMap;

import android.R.integer;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SimpleCursorAdapter.ViewBinder;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.*;
import android.widget.AdapterView.OnItemClickListener;

import com.lingzhimobile.nutritionfoodguide.*;
import com.lingzhimobile.nutritionfoodguide.v3.activity.*;
import com.umeng.analytics.MobclickAgent;


public class V3EncyclopediaFragment extends V3BaseHeadFragment {
    static final String LogTag = V3EncyclopediaFragment.class.getSimpleName();
    
    
    static final String[] nutrients_vitamin = {"Vit_A_RAE","Vit_C_(mg)","Vit_D_(µg)","Vit_E_(mg)",
        "Riboflavin_(mg)","Vit_B6_(mg)","Folate_Tot_(µg)","Vit_B12_(µg)"};
    static final String[] nutrients_mineral = {"Calcium_(mg)","Iron_(mg)","Magnesium_(mg)","Zinc_(mg)","Potassium_(mg)"};
    static final String[] nutrients_macro = {"Protein_(g)","Fiber_TD_(g)"};

    static final String Key_ItemImage = "ItemImage";
    static final String Key_ItemText = "ItemText";
    
    
//    String[] foods = new String[] { "蛋类", "主食", "五谷", "奶制品", "水产", "水果", "肉类",
//            "菌类", "蔬菜", "调味品", "豆制品", "干果" };
    static final String FoodClass_zhushi = "主食";
    static final String FoodClass_wugu = "五谷";
    static final String FoodClass_naizhipin = "奶制品";
    static final String FoodClass_ganguo = "干果";
    static final String FoodClass_shuichan = "水产";
    static final String FoodClass_shuiguo = "水果";
    static final String FoodClass_roulei = "肉类";
    static final String FoodClass_junzaolei = "菌藻类";
    static final String FoodClass_shucai = "蔬菜";
    static final String FoodClass_danlei = "蛋类";
    static final String FoodClass_tiaoweipin = "调味品";
    static final String FoodClass_douzhipin = "豆制品";
    static final String FoodClass_lingshi = "零食";
    static final String FoodClass_yinliao = "饮料";
    
    static final Object[][] FoodClassToImageIdData = {
    	{FoodClass_zhushi, R.drawable.foodclass_2x_zhushi},
    	{FoodClass_wugu, R.drawable.foodclass_2x_wugu},
    	{FoodClass_naizhipin, R.drawable.foodclass_2x_naizhipin},
    	{FoodClass_ganguo, R.drawable.foodclass_2x_ganguo},
    	{FoodClass_shuichan, R.drawable.foodclass_2x_shuichan},
    	{FoodClass_shuiguo, R.drawable.foodclass_2x_shuiguo},
    	{FoodClass_roulei, R.drawable.foodclass_2x_roulei},
    	{FoodClass_junzaolei, R.drawable.foodclass_2x_junzaolei},
    	{FoodClass_shucai, R.drawable.foodclass_2x_shucai},
    	{FoodClass_danlei, R.drawable.foodclass_2x_danlei},
    	{FoodClass_tiaoweipin, R.drawable.foodclass_2x_tiaoweipin},
    	{FoodClass_douzhipin, R.drawable.foodclass_2x_douzhipin},
    	{FoodClass_lingshi, R.drawable.foodclass_2x_lingshi},
    	{FoodClass_yinliao, R.drawable.foodclass_2x_yinliao},
    	};
    HashMap<Object, Object[]> m_FoodClassToImageIdInfoDict = null;
    HashMap<Object, Object[]> getFoodClassToImageIdInfoDict(){
    	if (m_FoodClassToImageIdInfoDict == null){
    		m_FoodClassToImageIdInfoDict = Tool.array2DtoArrayHashMap_withKeyIndex(0, FoodClassToImageIdData);
    	}
    	return m_FoodClassToImageIdInfoDict;
    }
    
//    HashMap<String, Double> m_DRIsDict ;
    Activity m_activity;


	TextView m_tvTitle;
	ScrollViewDebug m_scrollView1;
    ArrayList<TextView> m_tvNutrientVitaminList, m_tvNutrientMineralList, m_tvNutrientMacroList;
    GridView m_gvFoodType;
    
    ViewTreeObserver.OnScrollChangedListener m_ViewTreeObserver_OnScrollChangedListener1;
    
    ArrayList<String> m_foodTypeIdList;
    HashMap<String, HashMap<String, Object>> m_foodTypeTranslation2LevelDict;
    
    ListView m_lvIllness;

    ArrayList<HashMap<String, Object>> m_illnessRowList;
//    String[] diseases = new String[] { "急性咽炎", "关节炎", "流行性感冒", "急性胃炎" };

    @Override
    public void onCreate(Bundle savedInstanceState) {
    	Log.d(LogTag, "onCreate");
        super.onCreate(savedInstanceState);
        m_activity = this.getActivity();
    }
    
    public void onStart() {
		Log.d(LogTag, "onStart");
		super.onStop();
	}
    public void onStop() {
		Log.d(LogTag, "onStop");
		super.onStop();
	}
    public void onResume() {
		Log.d(LogTag, "onResume");
		super.onResume();
	}
	public void onPause() {
		Log.d(LogTag, "onPause");
		super.onPause();
		m_scrollView1.mCanScroll = false;
	}

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
    	Log.d(LogTag, "onCreateView");
        View view = inflater.inflate(R.layout.v3_fragment_encyclopedia, container, false);
        
        initViewHandles(view);
        initViewsContent();
        setViewEventHandlers();
        setViewsContent();

        return view;
    }
    void initViewHandles(View topView){

    	initHeaderLayout(topView);
    	
    	
    	m_tvTitle = (TextView) topView.findViewById(R.id.titleText);
    	Button btn1 = (Button) topView.findViewById(R.id.leftButton);
    	btn1.setVisibility(View.GONE);
    	btn1 = (Button) topView.findViewById(R.id.rightButton);
    	btn1.setVisibility(View.GONE);
        
    	m_scrollView1 = (ScrollViewDebug)topView.findViewById(R.id.scrollView1);
    	
        TextView tvNutrientVitamin1 = (TextView)topView.findViewById(R.id.tvNutrientVitamin1);
        TextView tvNutrientVitamin2 = (TextView)topView.findViewById(R.id.tvNutrientVitamin2);
        TextView tvNutrientVitamin3 = (TextView)topView.findViewById(R.id.tvNutrientVitamin3);
        TextView tvNutrientVitamin4 = (TextView)topView.findViewById(R.id.tvNutrientVitamin4);
        TextView tvNutrientVitamin5 = (TextView)topView.findViewById(R.id.tvNutrientVitamin5);
        TextView tvNutrientVitamin6 = (TextView)topView.findViewById(R.id.tvNutrientVitamin6);
        TextView tvNutrientVitamin7 = (TextView)topView.findViewById(R.id.tvNutrientVitamin7);
        TextView tvNutrientVitamin8 = (TextView)topView.findViewById(R.id.tvNutrientVitamin8);
        m_tvNutrientVitaminList = new ArrayList<TextView>();
        m_tvNutrientVitaminList.add(tvNutrientVitamin1);
        m_tvNutrientVitaminList.add(tvNutrientVitamin2);
        m_tvNutrientVitaminList.add(tvNutrientVitamin3);
        m_tvNutrientVitaminList.add(tvNutrientVitamin4);
        m_tvNutrientVitaminList.add(tvNutrientVitamin5);
        m_tvNutrientVitaminList.add(tvNutrientVitamin6);
        m_tvNutrientVitaminList.add(tvNutrientVitamin7);
        m_tvNutrientVitaminList.add(tvNutrientVitamin8);
        
        TextView tvNutrientMineral1 = (TextView)topView.findViewById(R.id.tvNutrientMineral1);
        TextView tvNutrientMineral2 = (TextView)topView.findViewById(R.id.tvNutrientMineral2);
        TextView tvNutrientMineral3 = (TextView)topView.findViewById(R.id.tvNutrientMineral3);
        TextView tvNutrientMineral4 = (TextView)topView.findViewById(R.id.tvNutrientMineral4);
        TextView tvNutrientMineral5 = (TextView)topView.findViewById(R.id.tvNutrientMineral5);
        m_tvNutrientMineralList = new ArrayList<TextView>();
        m_tvNutrientMineralList.add(tvNutrientMineral1);
        m_tvNutrientMineralList.add(tvNutrientMineral2);
        m_tvNutrientMineralList.add(tvNutrientMineral3);
        m_tvNutrientMineralList.add(tvNutrientMineral4);
        m_tvNutrientMineralList.add(tvNutrientMineral5);
        
        TextView tvNutrientMacro1 = (TextView)topView.findViewById(R.id.tvNutrientMacro1);
        TextView tvNutrientMacro2 = (TextView)topView.findViewById(R.id.tvNutrientMacro2);
        m_tvNutrientMacroList = new ArrayList<TextView>();
        m_tvNutrientMacroList.add(tvNutrientMacro1);
        m_tvNutrientMacroList.add(tvNutrientMacro2);

        m_gvFoodType = (GridView) topView.findViewById(R.id.gvFoodType);
        m_lvIllness = (ListView) topView.findViewById(R.id.lvIllness);

	}
    void initViewsContent(){
    	m_currentTitle = getResources().getString(R.string.tabCaption_encyclopedia);
        m_tvTitle.setText(m_currentTitle);
        
//    	m_DRIsDict = NutritionTool.getDRIsDictOfCurrentUser(getActivity(), null);
    }
    void setViewEventHandlers(){
    	OnClickListener_nutrient OnClickListener_nutrient1 = new OnClickListener_nutrient(getActivity(),m_currentTitle);
    	ArrayList<TextView> tvNutrientAll = new ArrayList<TextView>();
    	tvNutrientAll.addAll(m_tvNutrientVitaminList);
    	tvNutrientAll.addAll(m_tvNutrientMineralList);
    	tvNutrientAll.addAll(m_tvNutrientMacroList);
    	for(int i=0; i<tvNutrientAll.size(); i++){
    		TextView tvNutrient = tvNutrientAll.get(i);
    		tvNutrient.setOnClickListener(OnClickListener_nutrient1);
    	}

    	m_gvFoodType.setOnItemClickListener(new OnItemClickListener(){
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				if (GlobalVar.isClickedTooFast()){
					return;
				}
				String foodTypeId = m_foodTypeIdList.get(position);
//				Log.d(LogTag, "onItemClick "+foodCnType);
				
				Intent intent = new Intent(getActivity(), V3ActivityFoodsByType.class);
				intent.putExtra(Constants.IntentParamKey_BackButtonTitle, m_currentTitle);
//				intent.putExtra(Constants.IntentParamKey_InvokerType, mInvokerType);
				intent.putExtra(Constants.COLUMN_NAME_CnType, foodTypeId);
//				startActivityForResult(intent,IntentRequestCode_ActivitySearchFoodWithClass);
				startActivity(intent);
			}//onItemClick
		});//setOnItemClickListener
    	
//    	//no use
//    	m_scrollView1.getViewTreeObserver().addOnScrollChangedListener(new ViewTreeObserver.OnScrollChangedListener() {
//			@Override
//			public void onScrollChanged() {
//				String msg = "top scrollView OnScrollChanged, x,y=["+m_scrollView1.getScrollX()+","+m_scrollView1.getScrollY()+"]";
//				Log.d(LogTag, msg);
//			}
//		});
    	m_scrollView1.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				m_scrollView1.mCanScroll = true;
			}
		});
    	
    	m_ViewTreeObserver_OnScrollChangedListener1 = new ViewTreeObserver.OnScrollChangedListener() {
			@Override
			public void onScrollChanged() {
				String msg = "top scrollView OnScrollChanged in OnTouchListener, x,y=["+m_scrollView1.getScrollX()+","+m_scrollView1.getScrollY()+"]";
				Log.d(LogTag, msg);
			}
		};
		//only by this way can get OnScrollChanged event. 
		//http://stackoverflow.com/questions/4263053/android-scrollview-onscrollchanged
//    	m_scrollView1.setOnTouchListener(new View.OnTouchListener() {
//			@Override
//			public boolean onTouch(View v, MotionEvent event) {
//				m_scrollView1.getViewTreeObserver().addOnScrollChangedListener(m_ViewTreeObserver_OnScrollChangedListener1);
//				return false;
//			}
//		});
    	// but sometimes below not work, at least after added lifecycle log
    	m_scrollView1.setOnTouchListener(new View.OnTouchListener() {
			@Override
			public boolean onTouch(View v, MotionEvent event) {
				ViewTreeObserver.OnScrollChangedListener ViewTreeObserver_OnScrollChangedListener1 = (ViewTreeObserver.OnScrollChangedListener)m_scrollView1.getTag();
				if (ViewTreeObserver_OnScrollChangedListener1==null){
					m_scrollView1.setTag(m_ViewTreeObserver_OnScrollChangedListener1);
			    	m_scrollView1.getViewTreeObserver().addOnScrollChangedListener(m_ViewTreeObserver_OnScrollChangedListener1);
				}
				return false;
			}
		});
    }
    void setViewsContent(){
    	HashMap<String, HashMap<String, Object>> nutrientInfoDict2Level = GlobalVar.getAllNutrient2LevelDict(getActivity());
    	for(int i=0; i<nutrients_vitamin.length; i++){
    		String nutrientId = nutrients_vitamin[i];
    		TextView tvNutrientVitamin = m_tvNutrientVitaminList.get(i);
    		HashMap<String, Object> nutrientInfo = nutrientInfoDict2Level.get(nutrientId);
    		String nutrientCaption = (String)nutrientInfo.get(Constants.COLUMN_NAME_IconTitleCn);
    		String[] cnEnParts = Tool.splitNutrientTitleToCnEn(nutrientCaption);
    		tvNutrientVitamin.setText(cnEnParts[cnEnParts.length-1]);
    		tvNutrientVitamin.setTag(nutrientId);
    		Tool.changeBackground_NutritionButton(getActivity(), tvNutrientVitamin, nutrientId, true);
    	}
    	for(int i=0; i<nutrients_mineral.length; i++){
    		String nutrientId = nutrients_mineral[i];
    		TextView tvNutrient = m_tvNutrientMineralList.get(i);
    		HashMap<String, Object> nutrientInfo = nutrientInfoDict2Level.get(nutrientId);
    		String nutrientCaption = (String)nutrientInfo.get(Constants.COLUMN_NAME_IconTitleCn);
    		tvNutrient.setText(nutrientCaption);
    		tvNutrient.setTag(nutrientId);
    		Tool.changeBackground_NutritionButton(getActivity(), tvNutrient, nutrientId, true);
    	}
    	for(int i=0; i<nutrients_macro.length; i++){
    		String nutrientId = nutrients_macro[i];
    		TextView tvNutrient = m_tvNutrientMacroList.get(i);
    		HashMap<String, Object> nutrientInfo = nutrientInfoDict2Level.get(nutrientId);
    		String nutrientCaption = (String)nutrientInfo.get(Constants.COLUMN_NAME_IconTitleCn);
    		tvNutrient.setText(nutrientCaption);
    		tvNutrient.setTag(nutrientId);
    		Tool.changeBackground_NutritionButton(getActivity(), tvNutrient, nutrientId, true);
    	}
    	
    	DataAccess da = DataAccess.getSingleton(getActivity());
    	m_foodTypeIdList = da.getFoodCnTypes();
    	m_foodTypeTranslation2LevelDict =  da.getTranslationItemsDictionaryByType(Constants.TranslationItemType_FoodCnType);
    	
    	HashMap<Object, Object[]> l_FoodClassToImageIdInfoDict = getFoodClassToImageIdInfoDict();
		ArrayList<HashMap<String, Object>> meumList = new ArrayList<HashMap<String, Object>>();
		for(int i=0; i< m_foodTypeIdList.size(); i++)
		{
			String foodTypeId = m_foodTypeIdList.get(i);
			Object[] lFoodClassToImageIdInfo = l_FoodClassToImageIdInfoDict.get(foodTypeId);
			Object imageResId = null;
			if (lFoodClassToImageIdInfo!=null){
				imageResId = lFoodClassToImageIdInfo[1];
			}
			HashMap<String, Object> foodTypeTranslation = m_foodTypeTranslation2LevelDict.get(foodTypeId);
			String foodTypeCaption = (String)foodTypeTranslation.get(Constants.COLUMN_NAME_ItemNameCn);
			
		    HashMap<String, Object> map = new HashMap<String, Object>();
		    map.put(Key_ItemImage, imageResId);
		    map.put(Key_ItemText, foodTypeCaption);
		    meumList.add(map);
		}
    	SimpleAdapter SimpleAdapter1 = new SimpleAdapter(getActivity(), meumList, R.layout.grid_cell_square_foodclass, 
		          new String[]{Key_ItemImage,Key_ItemText}, new int[]{R.id.imageView1,R.id.textView1}); 
    	m_gvFoodType.setAdapter(SimpleAdapter1);
    	Tool.setGridViewFromTooHighToJustExpandHeight(m_gvFoodType);
    	
    	m_illnessRowList = da.getAllIllness();
        
        IllnessAdapter IllnessAdapter1 = new IllnessAdapter();
        m_lvIllness.setAdapter(IllnessAdapter1);
        
        Tool.setListViewExpandHeightByCalculateChildren(m_lvIllness);
    }

    public static Fragment newInstance(int arg0) {
        Fragment encyclopediaFragment = new V3EncyclopediaFragment();
        return encyclopediaFragment;
    }
    
    public static class OnClickListener_nutrient implements View.OnClickListener{
    	
    	Context m_ctx;
    	String m_currentTitle;
    	public OnClickListener_nutrient(Context ctx, String currentTitle){
    		m_ctx = ctx;
    		m_currentTitle = currentTitle;
    	}

		@Override
		public void onClick(View v) {
			if (GlobalVar.isClickedTooFast()){
				return;
			}
			
			String nutrientId = (String)v.getTag();
			if (nutrientId!=null){
				HashMap<String, HashMap<String, Object>> nutrientInfoDict2Level = GlobalVar.getAllNutrient2LevelDict(m_ctx);
				HashMap<String, Double> DRIsDict = NutritionTool.getDRIsDictOfCurrentUser(m_ctx, null);
				
				HashMap<String, Object> nutrientInfo = nutrientInfoDict2Level.get(nutrientId);
				Intent intent = new Intent(m_ctx, V3ActivityFoodsByNutrient.class);
				intent.putExtra(Constants.IntentParamKey_BackButtonTitle, m_currentTitle);
//				intent.putExtra(Constants.IntentParamKey_InvokerType, Constants.InvokerType_FromNutrients);
				intent.putExtra(Constants.COLUMN_NAME_NutrientID, nutrientId);
				intent.putExtra(Constants.Key_Amount, DRIsDict.get(nutrientId).doubleValue());
				m_ctx.startActivity(intent);
			}	
		}
    }

    class IllnessAdapter extends BaseAdapter {

        @Override
        public int getCount() {
            return m_illnessRowList==null?0:m_illnessRowList.size();
        }

        @Override
        public Object getItem(int arg0) {
            return m_illnessRowList.get(arg0);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            if (convertView == null) {
                convertView = getActivity().getLayoutInflater().inflate(R.layout.v3_list_cell_disease, null);
            }
            TextView tvIllness = (TextView) convertView.findViewById(R.id.tvIllness);
            HashMap<String, Object> illnessRow = m_illnessRowList.get(position);
            String illnessCaption = (String)illnessRow.get(Constants.COLUMN_NAME_IllnessNameCn);
            tvIllness.setText(illnessCaption);
            
            LinearLayout llIllness = (LinearLayout)convertView.findViewById(R.id.llIllness);
            OnClickListenerInListItem_illness OnClickListenerInListItem_illness1 = (OnClickListenerInListItem_illness)llIllness.getTag();
            if (OnClickListenerInListItem_illness1==null){
            	OnClickListenerInListItem_illness1 = new OnClickListenerInListItem_illness(getActivity(),m_currentTitle,(String)illnessRow.get(Constants.COLUMN_NAME_IllnessId));
            	OnClickListenerInListItem_illness1.initInputData(position);
            	llIllness.setOnClickListener(OnClickListenerInListItem_illness1);
            	llIllness.setTag(OnClickListenerInListItem_illness1);
            }else{
            	OnClickListenerInListItem_illness1.initInputData(position);
            }
            
            return convertView;
        }
        
        //disable click . http://stackoverflow.com/questions/13146652/how-to-disable-clicking-on-listview-in-android
        @Override
        public boolean isEnabled(int position) {
            return false;
        }

    }
    
    public static class OnClickListenerInListItem_illness extends OnClickListenerInListItem{
    	Context m_ctx;
    	String m_illnessId;
    	String m_currentTitle;
    	public OnClickListenerInListItem_illness(Context ctx, String currentTitle, String illnessId){
    		m_ctx = ctx;
    		m_illnessId = illnessId;
    		m_currentTitle = currentTitle;
    	}
    	
    	
    	@Override
		public void onClick(View v) {
    		if (GlobalVar.isClickedTooFast()){
				return;
			}
    		
    		Intent intent = new Intent(m_ctx, V3ActivityIllness.class);
    		intent.putExtra(Constants.IntentParamKey_BackButtonTitle, m_currentTitle);
			intent.putExtra(Constants.COLUMN_NAME_IllnessId, m_illnessId);
			m_ctx.startActivity(intent);
		}
    }
    

    @Override
    protected void setHeader() {
        // TODO Auto-generated method stub
        
    }
}
