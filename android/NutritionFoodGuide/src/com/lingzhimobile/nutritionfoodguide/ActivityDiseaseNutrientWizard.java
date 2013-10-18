package com.lingzhimobile.nutritionfoodguide;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.lang3.StringUtils;

import com.umeng.analytics.MobclickAgent;


import android.app.*;
import android.content.*;
import android.os.Bundle;
import android.support.v4.app.*;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.util.Log;
import android.util.SparseBooleanArray;
import android.view.*;
import android.view.ViewGroup.*;
import android.widget.*;


public class ActivityDiseaseNutrientWizard extends FragmentActivity {
	static final String LogTag = "ActivityDiseaseNutrientWizard";
	private ViewPager mVpWizard;
    private ArrayList<View> mLstPagerView;
    private DiseaseWizardPagerAdapter mWizardPageAdapter;
    private LinearLayout mPagePointLLayout;
    Button mBtnCancel ;
    Button mBtnReset ;
//    Button mBtnPrev ;
//	Button mBtnNext ;
	ImageButton mImgBtnPrev;
	ImageButton mImgBtnNext;
	int mCurrentWizardItemIndex = 0;
	
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
        setContentView(R.layout.activity_disease_nutrient_wizard);
        mVpWizard = (ViewPager) findViewById(R.id.vpWizard);
        mLstPagerView = new ArrayList<View>();
        mBtnCancel = (Button) findViewById(R.id.btnCancel);
        mBtnReset = (Button) findViewById(R.id.btnTopRight);
//        mBtnPrev = (Button) findViewById(R.id.btnPrev);
//    	mBtnNext = (Button) findViewById(R.id.btnNext);
    	mImgBtnPrev = (ImageButton) findViewById(R.id.imgBtnPrev);
    	mImgBtnNext = (ImageButton) findViewById(R.id.imgBtnNext);
        
        try {
			GlobalVar.InitDiseaseAndGroupData(this);
		} catch (IOException e) {
			Log.e(LogTag, "InitDiseaseAndGroupData err", e);
		}
        
        for(int i=0; i<3; i++){
        	View vwItem = createWizardViewItem(i);
            mLstPagerView.add(vwItem);
        }
        View vwItem = this.getLayoutInflater().inflate(R.layout.wizarditem_disease_nutrient_sum, null);
        mLstPagerView.add(vwItem);
        
        mWizardPageAdapter = new DiseaseWizardPagerAdapter(mLstPagerView);
        mVpWizard.setAdapter(mWizardPageAdapter);
        
        mPagePointLLayout = (LinearLayout) findViewById(R.id.pagePointLLayout);
//        for(int j=0;j<mLstPagerView.size();j++){
//            ImageView item = new ImageView(this);
////            item.setBackgroundResource(R.drawable.page_point);
////            item.setBackgroundResource(R.drawable.page_dot);
//            item.setImageResource(R.drawable.page_dot);
//            mPagePointLLayout.addView(item, j);
//        }
        for(int j=0;j<mLstPagerView.size();j++){
        	View vwPageDot = this.getLayoutInflater().inflate(R.layout.page_dot, null);
            mPagePointLLayout.addView(vwPageDot, j);
        }
        
        
        
        mVpWizard.setOnPageChangeListener(new OnPageChangeListener() {
            @Override
            public void onPageSelected(int arg0) {
            	mCurrentWizardItemIndex = arg0;
            	setWizardItemIndexRelated(mCurrentWizardItemIndex);
            }
            @Override
            public void onPageScrolled(int arg0, float arg1, int arg2) {

            }
            @Override
            public void onPageScrollStateChanged(int arg0) {

            }
        });
        
        
        mBtnCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	finish();
            }
        });
        mBtnReset.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	for(int i=0; i<mLstPagerView.size()-1; i++){
            		View vwItem = mLstPagerView.get(i);
            		ListView listview1 = (ListView)vwItem.findViewById(R.id.listView1);
                	SparseBooleanArray posAry = listview1.getCheckedItemPositions();
                	for(int j=0; j<posAry.size(); j++){
                		listview1.setItemChecked(j, false);
                	}
            	}
            	mVpWizard.setCurrentItem(0);
            }
        });
//        mBtnPrev.setOnClickListener(new View.OnClickListener() {
        mImgBtnPrev.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	mVpWizard.setCurrentItem(mCurrentWizardItemIndex-1);
            }
        });
//        mBtnNext.setOnClickListener(new View.OnClickListener() {
        mImgBtnNext.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            	if (mCurrentWizardItemIndex < mLstPagerView.size()-1){
            		mVpWizard.setCurrentItem(mCurrentWizardItemIndex+1);
            	}else{
            		finish();
            	}
            	
            }
        });
        
        mCurrentWizardItemIndex = 0;
        setWizardItemIndexRelated(mCurrentWizardItemIndex);
    }
    
    void setWizardItemIndexRelated(int wizardIdx){
    	setButtonsState(wizardIdx);
    	setPointView(wizardIdx);
//    	View curWizardItemView = mLstPagerView.get(wizardIdx) ;
//    	curWizardItemView.refreshDrawableState();
    	if (wizardIdx == mLstPagerView.size()-1){
    		doSum();
    	}
    }
    
    void setButtonsState(int wizardIdx){
    	
    	if (wizardIdx == 0){
//    		mBtnPrev.setVisibility(View.INVISIBLE);
//    		mBtnNext.setVisibility(View.VISIBLE);
    		mImgBtnPrev.setVisibility(View.INVISIBLE);
    		mImgBtnNext.setVisibility(View.VISIBLE);
    	}else if (wizardIdx == mLstPagerView.size()-1){
//    		mBtnPrev.setVisibility(View.VISIBLE);
//    		mBtnNext.setVisibility(View.INVISIBLE);
    		mImgBtnPrev.setVisibility(View.VISIBLE);
    		mImgBtnNext.setVisibility(View.INVISIBLE);

    	}else{
//    		mBtnPrev.setVisibility(View.VISIBLE);
//    		mBtnNext.setVisibility(View.VISIBLE);
    		mImgBtnPrev.setVisibility(View.VISIBLE);
    		mImgBtnNext.setVisibility(View.VISIBLE);
    	}
    }
    void setPointView(int wizardIdx){
        int pointCount = mPagePointLLayout.getChildCount();
        for (int i = 0; i < pointCount; i++) {
//            ImageView v = (ImageView) mPagePointLLayout.getChildAt(i);
        	View v = (View) mPagePointLLayout.getChildAt(i);
//            if (i == wizardIdx) {
//                v.setEnabled(true);
//            } else {
//                v.setEnabled(false);
//            }
            ImageView iv = (ImageView)v.findViewById(R.id.imageView1);
            if (i == wizardIdx) {
                iv.setEnabled(true);
            } else {
                iv.setEnabled(false);
            }
        }
    }
    
    View createWizardViewItem(int wizardIdx){
    	ArrayList<String> alDisease = GlobalVar.DiseasesOfGroup_Collection.get(wizardIdx);
        //ArrayAdapter<String> aryAdapterDisease = new ArrayAdapter<String>(this,android.R.layout.simple_list_item_multiple_choice, alDisease);
    	ArrayAdapter<String> aryAdapterDisease = new ArrayAdapter<String>(this,R.layout.simple_list_item_multiple_choice, alDisease);
        View vwItem = this.getLayoutInflater().inflate(R.layout.wizarditem_disease, null);
        TextView tvTitle = (TextView)vwItem.findViewById(R.id.tvTitle);
        tvTitle.setText(GlobalVar.DiseaseGroups.get(wizardIdx));
        ListView listview1 = (ListView)vwItem.findViewById(R.id.listView1);
		listview1.setAdapter(aryAdapterDisease);
		listview1.setChoiceMode(ListView.CHOICE_MODE_MULTIPLE);
		return vwItem;
    }
    
    void doSum(){
    	ArrayList<String> lstDiseaseChosen = new ArrayList<String>();
    	for(int i=0; i<mLstPagerView.size()-1; i++){
    		View vwItem = mLstPagerView.get(i);
    		ListView listview1 = (ListView)vwItem.findViewById(R.id.listView1);
    		ArrayList<String> diseasesOn1WizardItem = GlobalVar.DiseasesOfGroup_Collection.get(i);

        	SparseBooleanArray posAry = listview1.getCheckedItemPositions();
        	for(int j=0; j<diseasesOn1WizardItem.size(); j++){
        		if (posAry.get(j)){
        			lstDiseaseChosen.add(diseasesOn1WizardItem.get(j));
        		}
        	}
    	}
    	Object[] objAryDiseaseObjChosen = lstDiseaseChosen.toArray();
    	String[] strAryDiseaseObjChosen = Tool.convertToStringArray(objAryDiseaseObjChosen);
    	
    	String msgDiseasesChosen = StringUtils.join(strAryDiseaseObjChosen,",");
    	View vwSum = mLstPagerView.get(mLstPagerView.size()-1);
    	TextView tvDiseases = (TextView)vwSum.findViewById(R.id.tvDiseases);
    	tvDiseases.setText(msgDiseasesChosen);
    	
    	DataAccess da = DataAccess.getSingleton(this);
		String[] nutrientIds = da.getUniqueNutrients_ByDiseaseNames(strAryDiseaseObjChosen);
		HashMap<String, HashMap<String, Object>> nutrientInfosHm = da.getNutrientInfoAs2LevelDictionary_withNutrientIds(null);

		
		ArrayList<String> alNutrientName = new ArrayList<String>();
		for(int i=0; i<nutrientIds.length; i++){
			String nutrientId = nutrientIds[i];
			HashMap<String, Object> nutrientInfoHm = nutrientInfosHm.get(nutrientId);
			String nutrientName = (String)nutrientInfoHm.get(Constants.COLUMN_NAME_NutrientCnCaption);
			alNutrientName.add(nutrientName);
		}
		
		String msgNutrients = StringUtils.join(nutrientIds,",") + "    " + StringUtils.join(alNutrientName.toArray(),",");
		TextView tvNutrients = (TextView)vwSum.findViewById(R.id.tvNutrients);
		tvNutrients.setText(msgNutrients);
    	
    }


    
    public class DiseaseWizardPagerAdapter extends PagerAdapter {
        private List<View> mListViews;

        public List<View> getmListViews() {
            return mListViews;
        }

        public void setmListViews(List<View> mListViews) {
            this.mListViews = mListViews;
        }

        public DiseaseWizardPagerAdapter(List<View> mListViews) {
            this.mListViews = mListViews;
        }

        @Override
        public int getCount() {
            return mListViews.size();
        }

        @Override
        public int getItemPosition(Object object) {
            return POSITION_NONE;
        }

        @Override
        public boolean isViewFromObject(View arg0, Object arg1) {
            return (arg0 == arg1);
        }

        @Override
        public void destroyItem(View arg0, int arg1, Object arg2) {
            if (arg1 < mListViews.size()) {
                ((ViewPager) arg0).removeView(mListViews.get(arg1));
            }
        }

        @Override
        public Object instantiateItem(View container, int position) {
            View fv = mListViews.get(position);
            ViewGroup parent = (ViewGroup) fv.getParent();
            if (parent!=null){
                parent.removeView(fv);
            }
            ((ViewPager) container).addView(fv, 0);
            return mListViews.get(position);

        }


    }//DiseaseWizardPagerAdapter
    
    public class DiseaseAdapter extends BaseAdapter{

        Context mContext;
        LayoutInflater mInflater;
        List<String> mDiseases;

        public DiseaseAdapter(Context context, List<String> lstDisease) {
            this.mContext = context;
            this.mDiseases = lstDisease;
            mInflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        }

		@Override
		public int getCount() {
			return mDiseases.size();
		}

		@Override
		public Object getItem(int position) {
			return mDiseases.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			ViewHolder viewHolder;
			if (convertView == null) {
	            //convertView = inflater.inflate(R.layout.xxxxxxxxxxxx, null);
	            viewHolder = new ViewHolder();
//	            viewHolder.tvDisease = (TextView) convertView.findViewById(R.id.tvDisease);
	            convertView.setTag(viewHolder);
	        } else {
	            viewHolder = (ViewHolder) convertView.getTag();
	        }
	        viewHolder.tvDisease.setText(mDiseases.get(position));
			return null;
		}
		
		class ViewHolder {
		    public TextView tvDisease;
		}
    	
    }//DiseaseAdapter

}
