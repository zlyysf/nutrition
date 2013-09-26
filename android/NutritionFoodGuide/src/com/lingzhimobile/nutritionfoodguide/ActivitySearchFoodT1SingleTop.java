package com.lingzhimobile.nutritionfoodguide;

import java.util.ArrayList;
import java.util.HashMap;

import android.app.Activity;
import android.app.SearchManager;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnTouchListener;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.SimpleCursorAdapter;
import android.widget.TextView;
import android.widget.AdapterView.OnItemClickListener;
public class ActivitySearchFoodT1SingleTop extends Activity {
	static final String LogTag = "ActivitySearchFoodT1SingleTop";

	
	private TextView m_textView1;
    private ListView m_listView1;
    
    private TextView m_tvFrom;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_search_foodt1);

       
    }
    
    //这个很重要 http://blog.163.com/whatwhyhow@126/blog/static/133422389201131811752268/  http://blog.sina.com.cn/s/blog_5da93c8f0101hnzx.html
    @Override
    protected void onNewIntent(Intent intent){
    	super.onNewIntent(intent);
    	setIntent(intent);
    }
    
    @Override
    protected void onResume() {
    	super.onResume();
    	 m_textView1 = (TextView) findViewById(R.id.textView1);
         m_listView1 = (ListView) findViewById(R.id.listView1);
         m_tvFrom = (TextView) findViewById(R.id.tvFrom);

         Intent intent = getIntent();
         String intentAction = intent.getAction();
         String intentDataStringAsInput = intent.getDataString();
         
         String from =  intent.getStringExtra("from");
         m_tvFrom.setText(from);
         
         Log.d(LogTag,"onResume intentAction="+intentAction+", intentDataStringAsInput="+intentDataStringAsInput);
         // onResume intentAction=null, intentDataStringAsInput=null //需要在onNewIntent 调用 setIntent 才能取到新的 intent

         //onCreate intentAction=null, intentDataStringAsInput=null //从主页按钮点进来
         //onCreate intentAction=android.intent.action.VIEW, intentDataStringAsInput=09176 //点击下拉框的某项，这会导致新出一个activity(ActivtySearchFoodT1)
         //onCreate intentAction=android.intent.action.SEARCH, intentDataStringAsInput=null //在搜索框输入过程中点击回车，这会导致新出一个activity(ActivtySearchFoodT1)
         //如果在搜索框不输入，直接敲回车，会直接调provider，但不会调到这里

         if (Intent.ACTION_VIEW.equals(intentAction)) {
             // handles a click on a search suggestion; launches activity to show word
         	
         	m_textView1.setText(intentDataStringAsInput);
         	
         	
//             Intent wordIntent = new Intent(this, WordActivity.class);
//             wordIntent.setData(intent.getData());
//             startActivity(wordIntent);
//             finish();
         	
         	//finish();//这是把新出的activity给关掉了，老的还在
         } else if (Intent.ACTION_SEARCH.equals(intentAction)) {
         	//需要敲回车
             // handles a search query
             String queryAsInput = intent.getStringExtra(SearchManager.QUERY);
             Log.d(LogTag,"onResume ACTION_SEARCH, queryAsInput="+queryAsInput);
             //onCreate ACTION_SEARCH, queryAsInput=果
             
             showResults(queryAsInput);
             //finish();//这是把新出的activity给关掉了，老的还在
         }
    }

    /**
     * Searches the dictionary and displays results for the given query.
     * @param query The search query
     */
    private void showResults(String query) {

//        Cursor cursor = managedQuery(DictionaryProvider.CONTENT_URI, null, null,
//                                new String[] {query}, null);
//
//        if (cursor == null) {
//            // There are no results
//            mTextView.setText(getString(R.string.no_results, new Object[] {query}));
//        } else {
//            // Display the number of results
//            int count = cursor.getCount();
//            String countString = getResources().getQuantityString(R.plurals.search_results,
//                                    count, new Object[] {count, query});
//            mTextView.setText(countString);
//
//            // Specify the columns we want to display in the result
//            String[] from = new String[] { DictionaryDatabase.KEY_WORD,
//                                           DictionaryDatabase.KEY_DEFINITION };
//
//            // Specify the corresponding layout elements where we want the columns to go
//            int[] to = new int[] { R.id.word,
//                                   R.id.definition };
//
//            // Create a simple cursor adapter for the definitions and apply them to the ListView
//            SimpleCursorAdapter words = new SimpleCursorAdapter(this,
//                                          R.layout.result, cursor, from, to);
//            mListView.setAdapter(words);
//            
//        }
        
        DataAccess da = DataAccess.getSingleTon(this);
        ArrayList<HashMap<String, Object>> foods = da.getFoodsByLikeCnName(query);
        ArrayList<Object> foodCnCaptionLst = Tool.getPropertyArrayListFromDictionaryArray_withPropertyName(Constants.COLUMN_NAME_CnCaption, foods);
        ArrayAdapter<Object> aryAdapterGroup = new ArrayAdapter<Object>(this,android.R.layout.simple_list_item_multiple_choice, foodCnCaptionLst);
        m_listView1.setAdapter(aryAdapterGroup);
        m_textView1.setText("get count="+foodCnCaptionLst.size());
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.search_menu, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.search:
                onSearchRequested();//这里是在当前activity出了个顶部悬浮搜索框
                return true;
            default:
                return false;
        }
    }
}