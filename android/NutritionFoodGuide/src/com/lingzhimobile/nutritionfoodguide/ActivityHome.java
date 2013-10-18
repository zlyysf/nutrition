package com.lingzhimobile.nutritionfoodguide;



import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

import com.lingzhimobile.nutritionfoodguide.ActivityFoodCombinationList.FoodCombinationAdapter.OnClickListenerToDeleteRow;
import com.umeng.analytics.MobclickAgent;
import com.umeng.update.UmengUpdateAgent;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;
import android.widget.AdapterView.OnItemClickListener;

public class ActivityHome extends Activity{

    static final String LogTag = "ActivityHome";
    
    static final String Key_ItemImage = "ItemImage";
    static final String Key_ItemText = "ItemText";
    
    static final int[] menuItemImageResIds = new int[]{R.drawable.menu_item_2x_searchfood, R.drawable.menu_item_2x_nutrient,
    	R.drawable.menu_item_2x_foodlist, R.drawable.menu_item_2x_userinfo 
    	 };
    //static final String[] menuItemTexts = new String[]{"膳食清单","个人信息","营养元素","食物查询"};
    static final int[] menuItemTextResIds = new int[]{R.string.title_searchfood, R.string.title_nutrients, 
    	R.string.title_foodCombinationList, R.string.title_userinfo};
    
    static final int Position_searchfood = 0;
    static final int Position_nutrient = 1;
    static final int Position_foodlist = 2;
    static final int Position_userinfo = 3;
    
    String m_currentTitle;
    
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
		Log.d(LogTag, "onCreate savedInstanceState="+savedInstanceState);
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_home);
		
//		MobclickAgent.setDebugMode( true );
		UmengUpdateAgent.update(this);
		
		
		Button btnReset = (Button) findViewById(R.id.btnTopRight);
		btnReset.setVisibility(View.GONE);
        Button btnCancel = (Button) findViewById(R.id.btnCancel);
        btnCancel.setVisibility(View.GONE);
        
        m_currentTitle = getResources().getString(R.string.app_name);
        TextView tvTitle = (TextView) findViewById(R.id.tvTitle);
        tvTitle.setText(m_currentTitle);
		
        Button btnTempMain = (Button) findViewById(R.id.btnTempMain);
//        btnTempMain.setVisibility(View.GONE);
        btnTempMain.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Intent intent = new Intent(ActivityHome.this, MainActivity.class);
				startActivity(intent);
				
			}
		});
        
		GridView gridView1 = (GridView) findViewById(R.id.gridView1);
		
		ArrayList<HashMap<String, Object>> meumList = new ArrayList<HashMap<String, Object>>();
		for(int i=0; i<menuItemImageResIds.length; i++)
		{
		    HashMap<String, Object> map = new HashMap<String, Object>();
		    map.put(Key_ItemImage, menuItemImageResIds[i]);
		    //map.put(Key_ItemText, menuItemTexts[i]);
		    
		    map.put(Key_ItemText, getResources().getString(menuItemTextResIds[i]) );
		    meumList.add(map);
		}
		SimpleAdapter SimpleAdapter1 = new SimpleAdapter(this,meumList,R.layout.grid_cell_square_image_text, 
		          new String[]{Key_ItemImage,Key_ItemText}, new int[]{R.id.imageView1,R.id.textView1}); 
		gridView1.setAdapter(SimpleAdapter1);
		gridView1.setOnItemClickListener(new OnItemClickListener(){
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				LinearLayout cellLayout = (LinearLayout)view.findViewById(R.id.cellLayout);
				ImageView imageView1 = (ImageView)view.findViewById(R.id.imageView1);
				
				Log.d(LogTag, "position="+position+", id="+id
						+", imageView1 w="+imageView1.getWidth()+", h="+imageView1.getHeight()
						+", cellLayout w="+cellLayout.getWidth()+", h="+cellLayout.getHeight()
						);
				
				Intent intent = null;
				switch (position) {
				case Position_foodlist:
					intent = new Intent(ActivityHome.this, ActivityFoodCombinationList.class);
					intent.putExtra(Constants.IntentParamKey_BackButtonTitle, m_currentTitle);
					startActivity(intent);
					break;
				case Position_userinfo:
					intent = new Intent(ActivityHome.this, ActivityUserProfile.class);
					intent.putExtra(Constants.IntentParamKey_BackButtonTitle, m_currentTitle);
					startActivity(intent);
					break;
				case Position_nutrient:
					intent = new Intent(ActivityHome.this, ActivityNutrients.class);
					intent.putExtra(Constants.IntentParamKey_BackButtonTitle, m_currentTitle);
					startActivity(intent);
					break;
				case Position_searchfood:
//					intent = new Intent(ActivityHome.this, ActivitySearchFoodCustom.class);
//					startActivity(intent);
					
					intent = new Intent(ActivityHome.this, ActivitySearchFoodCustom.class);
					intent.putExtra(Constants.IntentParamKey_BackButtonTitle, m_currentTitle);
					intent.putExtra(Constants.IntentParamKey_InvokerType, Constants.InvokerType_FromSearchFood);
					startActivity(intent);
					break;
				default:
					break;
				}
			}//onItemClick
		});//setOnItemClickListener
		
		dealParamIntent();

	}


	@Override
    protected void onNewIntent(Intent intent){
		Log.d(LogTag, "onNewIntent intent="+intent);
    	super.onNewIntent(intent);
    	setIntent(intent);
    	
    	dealParamIntent();
    }
	
	void dealParamIntent(){
		Tool.printActivityStack(this);
		
		Intent paramIntent = getIntent();
		Log.d(LogTag, "dealParamIntent paramIntent="+paramIntent);
		if (paramIntent != null){
			long collocationId = paramIntent.getLongExtra(Constants.COLUMN_NAME_CollocationId, -1);
			String foodId = paramIntent.getStringExtra(Constants.COLUMN_NAME_NDB_No);
			double foodAmount = paramIntent.getDoubleExtra(Constants.Key_Amount, 0);
			setIntent(null);
			Log.d(LogTag, "dealParamIntent collocationId="+collocationId+", foodId="+foodId+", foodAmount="+foodAmount);
			if (foodId != null && foodId.length()>0 ){
				Intent intent2 = new Intent(ActivityHome.this, ActivityFoodCombinationList.class);
				intent2.putExtra(ActivityFoodCombinationList.IntentKey_aim,ActivityFoodCombinationList.IntentValue_aim_EditItem);
				intent2.putExtra(Constants.COLUMN_NAME_CollocationId, collocationId);
				intent2.putExtra(Constants.COLUMN_NAME_NDB_No, foodId);
		    	intent2.putExtra(Constants.Key_Amount, foodAmount);
				startActivity(intent2);
			}
		}
	}
    
}
