package com.lingzhimobile.nutritionfoodguide;

import java.util.HashMap;
import android.os.AsyncTask;
import android.os.Message;
import android.util.Log;

public class AsyncTaskDoRecommend extends AsyncTask<Void, Void, HashMap<String, Object>> {
    private static final String LogTag = "AsyncTaskDoRecommend";

    private final HashMap<String, Object> m_paramData;
    private final Message m_msg;

    public AsyncTaskDoRecommend(HashMap<String, Object> paramData, Message msg){
    	m_paramData = paramData;
        m_msg = msg;
    }

    @Override
    protected HashMap<String, Object> doInBackground(Void... params) {
    	Log.d(LogTag, "doInBackground");
    	RecommendFood rf = (RecommendFood)m_paramData.get("RecommendFood");
    	HashMap<String, Double> takenFoodAmountDict = (HashMap<String, Double>)m_paramData.get("takenFoodAmountDict");
    	HashMap<String, Object> userInfo = (HashMap<String, Object>)m_paramData.get("userInfo");
    	HashMap<String, Object> options = (HashMap<String, Object>)m_paramData.get("options");
    	HashMap<String, Object> lparams = (HashMap<String, Object>)m_paramData.get("params");

	    HashMap<String, Object> retDict = rf.recommendFoodBySmallIncrementWithPreIntakeOut(takenFoodAmountDict,userInfo,options,lparams);
        return retDict;
    }

    @Override
    protected void onPostExecute(HashMap<String, Object> result) {
        super.onPostExecute(result);
        Log.d(LogTag, "onPostExecute");
        m_msg.what = Constants.MessageID_OK;
        m_msg.obj = result;
        m_msg.sendToTarget();
    }

    @Override
    protected void onCancelled() {
        super.onCancelled();
        Log.d(LogTag, "onCancelled");
    }

}
