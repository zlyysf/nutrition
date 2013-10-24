package com.lingzhimobile.nutritionfoodguide;



import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;


import com.lingzhimobile.nutritionfoodguide.ActivityFoodByClass.ListAdapterForFood;
import com.lingzhimobile.nutritionfoodguide.DialogHelperSimpleInput.InterfaceWhenConfirmInput;
import com.umeng.analytics.MobclickAgent;

import android.os.Bundle;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.text.Editable;
import android.text.InputType;
import android.text.TextWatcher;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ExpandableListView;
import android.widget.GridView;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;
import android.widget.AdapterView.OnItemClickListener;

public class ActivitySearchFoodWithClass extends ActivityBase{
	public static final int IntentResultCode = 1000;
	public static final int IntentRequestCode_ActivitySearchFoodWithClass = 100;

    static final String LogTag = "ActivityHome";
    
    static final String Key_ItemImage = "ItemImage";
    static final String Key_ItemText = "ItemText";
    
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

    String mInvokerType = null;
    ArrayList<String> m_foodCnTypes;


    Button m_btnCancel;
    Button m_btnTopRight;
    EditText m_etSearch;
	TextView m_tvSearchTextClear;
    GridView m_gridView1;
    ListView m_listView1;
    ListAdapterForFood m_ListAdapterForFood;

	public void onResume() {
		super.onResume();
		MobclickAgent.onResume(this);
	}
	public void onPause() {
		super.onPause();
		MobclickAgent.onPause(this);
	}
	
	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_searchfood_withclass);

        initViewHandles();
        initViewsContent();
        setViewEventHandlers();
        setViewsContent();
	}
	
	void initViewHandles(){
		m_btnCancel = (Button) findViewById(R.id.btnCancel);
		m_etSearch = (EditText)findViewById(R.id.etSearch);
		m_tvSearchTextClear = (TextView)findViewById(R.id.tvSearchTextClear);
		m_gridView1 = (GridView) findViewById(R.id.gridView1);
		m_listView1 = (ListView) findViewById(R.id.listView1);
		
		
	}
	void initViewsContent(){
		Intent paramIntent = getIntent();
        mInvokerType = paramIntent.getStringExtra(Constants.IntentParamKey_InvokerType);
        String prevActvTitle = paramIntent.getStringExtra(Constants.IntentParamKey_BackButtonTitle);
        if (prevActvTitle!=null)
        	m_btnCancel.setText(prevActvTitle);
        
		m_btnTopRight = (Button) findViewById(R.id.btnTopRight);
		m_btnTopRight.setVisibility(View.GONE);
		
		m_currentTitle = getResources().getString(R.string.title_searchfood);
        TextView tvTitle = (TextView) findViewById(R.id.tvTitle);
        tvTitle.setText(m_currentTitle);
        
        DataAccess da = DataAccess.getSingleton(this);
        m_foodCnTypes = da.getFoodCnTypes();
		
	}
	void setViewEventHandlers(){
        m_btnCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	finish();
            }
        });
        
        SearchFoodTextWatcher searchFoodTextWatcher1 = new SearchFoodTextWatcher();
		
		m_etSearch.addTextChangedListener(searchFoodTextWatcher1);
		
		m_tvSearchTextClear.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				m_etSearch.setText("");
				InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
				imm.hideSoftInputFromWindow(ActivitySearchFoodWithClass.this.getCurrentFocus().getWindowToken(),0);
			}
		});
        
		m_gridView1.setOnItemClickListener(new OnItemClickListener(){
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
//				LinearLayout cellLayout = (LinearLayout)view.findViewById(R.id.cellLayout);
//				ImageView imageView1 = (ImageView)view.findViewById(R.id.imageView1);
//				Log.d(LogTag, "position="+position+", id="+id
//						+", imageView1 w="+imageView1.getWidth()+", h="+imageView1.getHeight()
//						+", cellLayout w="+cellLayout.getWidth()+", h="+cellLayout.getHeight()
//						);
				
				String foodCnType = m_foodCnTypes.get(position);
//				Log.d(LogTag, "onItemClick "+foodCnType);
				
				Intent intent = new Intent(ActivitySearchFoodWithClass.this, ActivityFoodByClass.class);
				intent.putExtra(Constants.IntentParamKey_BackButtonTitle, m_currentTitle);
				intent.putExtra(Constants.IntentParamKey_InvokerType, mInvokerType);
				intent.putExtra(Constants.COLUMN_NAME_CnType, foodCnType);
				startActivityForResult(intent,IntentRequestCode_ActivitySearchFoodWithClass);
			}//onItemClick
		});//setOnItemClickListener
		
	}
	void setViewsContent(){
        HashMap<Object, Object[]> l_FoodClassToImageIdInfoDict = getFoodClassToImageIdInfoDict();
		ArrayList<HashMap<String, Object>> meumList = new ArrayList<HashMap<String, Object>>();
		for(int i=0; i< m_foodCnTypes.size(); i++)
		{
			String foodCnType = m_foodCnTypes.get(i);
			Object[] lFoodClassToImageIdInfo = l_FoodClassToImageIdInfoDict.get(foodCnType);
			Object imageResId = null;
			if (lFoodClassToImageIdInfo!=null){
				imageResId = lFoodClassToImageIdInfo[1];
			}
			
		    HashMap<String, Object> map = new HashMap<String, Object>();
		    map.put(Key_ItemImage, imageResId);
		    map.put(Key_ItemText, foodCnType);
		    meumList.add(map);
		}
		SimpleAdapter SimpleAdapter1 = new SimpleAdapter(this,meumList,R.layout.grid_cell_square_foodclass, 
		          new String[]{Key_ItemImage,Key_ItemText}, new int[]{R.id.imageView1,R.id.textView1}); 
		m_gridView1.setAdapter(SimpleAdapter1);
		
		m_ListAdapterForFood = new ListAdapterForFood(this,null,mInvokerType);
		m_listView1.setAdapter(m_ListAdapterForFood);
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data)
	{
		super.onActivityResult(requestCode, resultCode, data);
		switch (requestCode)
		{
			case IntentRequestCode_ActivitySearchFoodWithClass:
				switch (resultCode)
				{
					case ActivityFoodByClass.IntentResultCode:
						relayResult_onActivityResult(data);
						break;
					default:
						break;
				}
				break;
			default:
				break;
		}
	}
	private void relayResult_onActivityResult(Intent data){
		String foodId = data.getStringExtra(Constants.COLUMN_NAME_NDB_No);
		int iAmount = data.getIntExtra(Constants.Key_Amount, 0);
		
		Intent intent = new Intent();
    	intent.putExtra(Constants.COLUMN_NAME_NDB_No, foodId);
    	intent.putExtra(Constants.Key_Amount, iAmount);
    	setResult(IntentResultCode, intent);
    	finish();
	}
	
	class SearchFoodTextWatcher implements TextWatcher{
		@Override
		public void beforeTextChanged(CharSequence s, int start, int count, int after) {
		}
		@Override
		public void onTextChanged(CharSequence s, int start, int before, int count) {
			Log.d(LogTag, "onTextChanged s="+s);
			if (s==null||s.length()==0){
				m_gridView1.setVisibility(View.VISIBLE);
				m_listView1.setVisibility(View.GONE);
			}else{
				m_gridView1.setVisibility(View.GONE);
				m_listView1.setVisibility(View.VISIBLE);
				DataAccess da = DataAccess.getSingleton(ActivitySearchFoodWithClass.this);
				ArrayList<HashMap<String, Object>> foodsData = da.getFoodsByShowingPart(s.toString(),null,null);
				m_ListAdapterForFood.setInputData(foodsData);
			}
		}
		@Override
		public void afterTextChanged(Editable s) {
		}
	}
    
}
