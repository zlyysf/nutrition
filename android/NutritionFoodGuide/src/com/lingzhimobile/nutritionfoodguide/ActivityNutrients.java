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

public class ActivityNutrients extends Activity{

    static final String LogTag = "ActivityHome";
    
    static final String Key_ItemImage = "ItemImage";
    static final String Key_ItemText = "ItemText";
    
    static final int[] menuItemImageResIds = new int[]{
    	R.drawable.nutrient_vit_a_button_2x, R.drawable.nutrient_vit_c_button_2x, R.drawable.nutrient_vit_d_button_2x,
    	R.drawable.nutrient_vit_e_button_2x, R.drawable.nutrient_riboflavin_button_2x, R.drawable.nutrient_vit_b6_button_2x, 
    	R.drawable.nutrient_folate_button_2x, R.drawable.nutrient_vit_b12_button_2x, R.drawable.nutrient_calcium_button_2x, 
    	R.drawable.nutrient_iron_button_2x, R.drawable.nutrient_magnesium_button_2x, R.drawable.nutrient_zinc_button_2x, 
    	R.drawable.nutrient_fiber_button_2x, R.drawable.nutrient_protein_button_2x};
    static final String[] NutrientIds = new String[]{
    	"Vit_A_RAE","Vit_C_(mg)","Vit_D_(µg)",
    	"Vit_E_(mg)",  "Riboflavin_(mg)","Vit_B6_(mg)",
        "Folate_Tot_(µg)","Vit_B12_(µg)",  "Calcium_(mg)",
        "Iron_(mg)","Magnesium_(mg)","Zinc_(mg)",
        "Fiber_TD_(g)","Protein_(g)"};

    HashMap<String, Double> m_DRIsDict ;
    HashMap<String, HashMap<String, Object>> nutrientInfoDict2Level;

	
	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_nutrients);
		
		Button btnReset = (Button) findViewById(R.id.btnReset);
		btnReset.setVisibility(View.GONE);
        Button btnCancel = (Button) findViewById(R.id.btnCancel);
        btnCancel.setVisibility(View.GONE);
        TextView tvTitle = (TextView) findViewById(R.id.title);
        tvTitle.setText(R.string.nutrients);
        
        m_DRIsDict = NutritionTool.getDRIsDictOfCurrentUser(this, null);
        DataAccess da = DataAccess.getSingleton(this);
        nutrientInfoDict2Level = da.getNutrientInfoAs2LevelDictionary_withNutrientIds(NutrientIds);
        
		GridView gridView1 = (GridView) findViewById(R.id.gridView1);
		
		ArrayList<HashMap<String, Object>> meumList = new ArrayList<HashMap<String, Object>>();
		for(int i=0; i<menuItemImageResIds.length; i++)
		{
		    HashMap<String, Object> map = new HashMap<String, Object>();
		    map.put(Key_ItemImage, menuItemImageResIds[i]);
		    meumList.add(map);
		}
		SimpleAdapter SimpleAdapter1 = new SimpleAdapter(this,meumList,R.layout.grid_cell_square_image, 
		          new String[]{Key_ItemImage}, new int[]{R.id.imageView1}); 
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
				String nutrientId = NutrientIds[position];
				HashMap<String, Object> nutrientInfo = nutrientInfoDict2Level.get(nutrientId);
				intent = new Intent(ActivityNutrients.this, ActivityRichFood.class);
				intent.putExtra(Constants.COLUMN_NAME_NutrientID, nutrientId);
				intent.putExtra(Constants.Key_Amount, m_DRIsDict.get(nutrientId).doubleValue());
				intent.putExtra(Constants.Key_Name, (String)nutrientInfo.get(Constants.COLUMN_NAME_NutrientCnCaption));
				startActivity(intent);
			}//onItemClick
		});//setOnItemClickListener

	}


    
}
