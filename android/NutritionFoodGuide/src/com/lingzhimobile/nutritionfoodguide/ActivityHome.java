package com.lingzhimobile.nutritionfoodguide;



import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

import com.lingzhimobile.nutritionfoodguide.ActivityFoodCombinationList.FoodCombinationAdapter.OnClickListenerToDeleteRow;

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
    
    static final int[] menuItemImageResIds = new int[]{R.drawable.menu_item_2x_foodlist, R.drawable.menu_item_2x_userinfo, 
    	R.drawable.menu_item_2x_nutrient, R.drawable.menu_item_2x_searchfood};
    static final String[] menuItemTexts = new String[]{"膳食清单","个人信息","营养元素","食物查询"};
    static final int Position_foodlist = 0;
    static final int Position_userinfo = 1;
    static final int Position_nutrient = 2;
    static final int Position_searchfood = 3;

	
	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_home);
		
		Button btnReset = (Button) findViewById(R.id.btnReset);
		btnReset.setVisibility(View.GONE);
        Button btnCancel = (Button) findViewById(R.id.btnCancel);
        btnCancel.setVisibility(View.GONE);
        TextView tvTitle = (TextView) findViewById(R.id.title);
        tvTitle.setText(R.string.app_name);
		
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
		    map.put(Key_ItemText, menuItemTexts[i]);
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
					startActivity(intent);
					break;
				case Position_userinfo:
					intent = new Intent(ActivityHome.this, ActivityUserProfile.class);
					startActivity(intent);
					break;
				case Position_nutrient:
					intent = new Intent(ActivityHome.this, ActivityNutrients.class);
					startActivity(intent);
					break;
				case Position_searchfood:
					intent = new Intent(ActivityHome.this, ActivitySearchFoodCustom.class);
					startActivity(intent);
					break;
				default:
					break;
				}

			}//onItemClick
		});//setOnItemClickListener

	}


    
}
