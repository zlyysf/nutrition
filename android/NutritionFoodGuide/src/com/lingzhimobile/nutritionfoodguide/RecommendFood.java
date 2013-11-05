package com.lingzhimobile.nutritionfoodguide;

import java.io.IOException;
import java.lang.reflect.Array;
import java.sql.Date;
import java.util.*;


import org.apache.commons.lang3.StringUtils;

import android.content.Context;
import android.util.Log;

public class RecommendFood {
	static final String LogTag = "DataAccess";
	
	Context mContext;
//	DataAccess mDataAccess ;
	public RecommendFood(Context ctx){
		mContext = ctx;
	}
	DataAccess getDataAccess(){
//		if (mDataAccess==null){
//			mDataAccess = new DataAccess(mContext);
//		}
//		return mDataAccess;
		return DataAccess.getSingleton(mContext);
	}
//	public void close(){
//		if (mDataAccess!=null){
//			mDataAccess.closeDB();
//			mDataAccess = null;
//		}
//	}

	/*
	 参数有 Key_DRI , Key_userInfo , "FoodAttrs" , "FoodAmount", "allShowNutrients" , "nutrientInfoDict2Level".
	 其中 "FoodAttrs" , "FoodAmount" 是必填项 . Key_DRI , Key_userInfo 两者必填其一。
	 其他是可选参数。当可选参数没有传入时，代码中会取得生成并传出。
	 返回值是食物补充各个营养素百分比的数组。
	 */
	public ArrayList<HashMap<String, Object>> calculateGiveFoodSupplyNutrientAndFormatForUI(HashMap<String, Object> inOutParamsDict)
	{
		Log.d(LogTag, "calculateGiveFoodSupplyNutrientAndFormatForUI enter");

		HashMap<String, Object> foodAttrs = (HashMap<String, Object>)(inOutParamsDict.get("FoodAttrs"));
		Double dObj_FoodAmount = (Double)inOutParamsDict.get("FoodAmount");
	    assert(foodAttrs!=null);
	    assert(dObj_FoodAmount!=null);
	    inOutParamsDict.put("dynamicFoodAttrs", foodAttrs);
	    inOutParamsDict.put("dynamicFoodAmount", dObj_FoodAmount);
	    return calculateGiveStaticFoodsDynamicFoodSupplyNutrientAndFormatForUI(inOutParamsDict);   
	}

	/*

	 其他是可选参数。当可选参数没有传入时，代码中会取得生成并传出。
	 返回值是食物补充各个营养素百分比的数组。
	 */
	public ArrayList<HashMap<String, Object>> calculateGiveStaticFoodsDynamicFoodSupplyNutrientAndFormatForUI(HashMap<String, Object> inOutParamsDict)
	{
		Log.d(LogTag, "calculateGiveStaticFoodsDynamicFoodSupplyNutrientAndFormatForUI enter");
		
		HashMap<String, Double> DRIsDict = (HashMap<String, Double>)(inOutParamsDict.get(Constants.Key_DRI));
		HashMap<String, Object> userInfo = (HashMap<String, Object>)(inOutParamsDict.get(Constants.Key_userInfo));
		
		HashMap<String, Object> dynamicFoodAttrs = (HashMap<String, Object>)(inOutParamsDict.get("dynamicFoodAttrs"));
		Double dObj_dynamicFoodAmount = (Double)inOutParamsDict.get("dynamicFoodAmount");
	    
		HashMap<String, HashMap<String, Object>> staticFoodAttrsDict2Level = (HashMap<String, HashMap<String, Object>>)(inOutParamsDict.get("staticFoodAttrsDict2Level"));
		HashMap<String, Double> staticFoodAmountDict = (HashMap<String, Double>)(inOutParamsDict.get("staticFoodAmountDict"));
		HashMap<String, Double> staticFoodSupplyNutrientDict = (HashMap<String, Double>)(inOutParamsDict.get("staticFoodSupplyNutrientDict"));
		
		String[] allShowNutrients = (String[])inOutParamsDict.get("allShowNutrients");
		HashMap<String, HashMap<String, Object>> nutrientInfoDict2Level = (HashMap<String, HashMap<String, Object>>)(inOutParamsDict.get("nutrientInfoDict2Level"));
	    
		DataAccess da = getDataAccess();
		if (DRIsDict == null){
			assert(userInfo != null);
			DRIsDict = da.getStandardDRIs_withUserInfo(userInfo, null);
			inOutParamsDict.put(Constants.Key_DRI, DRIsDict);
		}
	    
	    if (allShowNutrients==null){
	        String[] customNutrients = NutritionTool.getCustomNutrients(null);// 显示时将显示我们预定义的全部营养素，从而这里不用 getCalculationNutrientsForSmallIncrementLogic_withDRI ..
	        String[] onlyToShowNutrients = NutritionTool.getOnlyToShowNutrients();
	        ArrayList<String> allShowNutrientAl = Tool.arrayAddArrayInSetWay_withArray1(customNutrients,onlyToShowNutrients);
	        allShowNutrients = Tool.convertToStringArray(allShowNutrientAl);
	        inOutParamsDict.put("allShowNutrients", allShowNutrients);
	    }
	    if (nutrientInfoDict2Level == null){
	        nutrientInfoDict2Level = da.getNutrientInfoAs2LevelDictionary_withNutrientIds(allShowNutrients);
	        inOutParamsDict.put("nutrientInfoDict2Level", nutrientInfoDict2Level);
	    }
	    
	    HashMap<String, Double> nutrientSupplyDict = null;
	    if (staticFoodSupplyNutrientDict == null){
	    	nutrientSupplyDict = Tool.generateDictionaryWithFillItem(Double.valueOf(0),allShowNutrients);
	    	
	        if (staticFoodAmountDict!=null && staticFoodAmountDict.size() > 0){
	            assert(staticFoodAttrsDict2Level.size()>=staticFoodAmountDict.size());
	            //在没有缓存的情况下先计算 不变的那些食物提供的营养素的量，并在后面存入缓存
	            foodsSupplyNutrients_withAmounts(staticFoodAmountDict,staticFoodAttrsDict2Level,nutrientSupplyDict,allShowNutrients,null);
	        }
	        staticFoodSupplyNutrientDict = new HashMap<String, Double>();
	        staticFoodSupplyNutrientDict.putAll(nutrientSupplyDict);
	        inOutParamsDict.put("staticFoodSupplyNutrientDict", staticFoodSupplyNutrientDict);
	    }else{
	        //有已计算的值时直接利用以提高效率
	    	nutrientSupplyDict = new HashMap<String, Double>();
	    	nutrientSupplyDict.putAll(staticFoodSupplyNutrientDict);
	    }
	    
	    if (dObj_dynamicFoodAmount != null){
	        assert(dynamicFoodAttrs!=null);
	        oneFoodSupplyNutrients(dynamicFoodAttrs,dObj_dynamicFoodAmount.doubleValue(),nutrientSupplyDict,allShowNutrients,null);
	    }
	    
	    HashMap<String, HashMap<String, Object>> allFoodAttrsDict2Level = new HashMap<String, HashMap<String, Object>>();
	    if (staticFoodAttrsDict2Level != null){
	    	allFoodAttrsDict2Level.putAll(staticFoodAttrsDict2Level);
	    }else{
	    }
	    if (dynamicFoodAttrs!=null){
	        String foodId = (String)dynamicFoodAttrs.get(Constants.COLUMN_NAME_NDB_No);
	        assert(foodId != null);
	        allFoodAttrsDict2Level.put(foodId, dynamicFoodAttrs);
	    }
	    
	    ArrayList<HashMap<String, Object>> supplyNutrientInfoArray = new ArrayList<HashMap<String,Object>>(allShowNutrients.length);
	    for(int j=0; j<allShowNutrients.length; j++){
	        String nutrientId = allShowNutrients[j];
	    
	        Double dObj_DRI = DRIsDict.get(nutrientId);
	        Double dObj_supplyNutrientAmount = nutrientSupplyDict.get(nutrientId);
	        double supplyRate = dObj_supplyNutrientAmount.doubleValue() / dObj_DRI.doubleValue() ;
	        
	        HashMap<String, Object> nutrientInfoDict = nutrientInfoDict2Level.get(nutrientId);
	        String nutrientCnCaption = (String)nutrientInfoDict.get(Constants.COLUMN_NAME_NutrientCnCaption);
	        String nutrientNutrientEnUnit = (String)nutrientInfoDict.get(Constants.COLUMN_NAME_NutrientEnUnit);
	        
	        HashMap<String, Object> supplyNutrientInfo = new HashMap<String, Object>();
	        supplyNutrientInfo.put(Constants.COLUMN_NAME_NutrientID, nutrientId);
	        supplyNutrientInfo.put(Constants.Key_supplyNutrientAmount, dObj_supplyNutrientAmount);
	        supplyNutrientInfo.put(Constants.Key_food1Supply1NutrientAmount, dObj_supplyNutrientAmount);
	        supplyNutrientInfo.put(Constants.Key_nutrientTotalDRI, dObj_DRI);
	        supplyNutrientInfo.put(Constants.Key_supplyNutrientRate, Double.valueOf(supplyRate));
	        supplyNutrientInfo.put(Constants.Key_1foodSupply1NutrientRate, Double.valueOf(supplyRate));
	        supplyNutrientInfo.put(Constants.Key_Name, nutrientCnCaption);
	        supplyNutrientInfo.put(Constants.Key_Unit, nutrientNutrientEnUnit);
	        
	        supplyNutrientInfoArray.add(supplyNutrientInfo);
	    }//for j
	    Log.d(LogTag, "calculateGiveStaticFoodsDynamicFoodSupplyNutrientAndFormatForUI ret:"+Tool.getIndentFormatStringOfObject(supplyNutrientInfoArray,0));
	    return supplyNutrientInfoArray;
	}

	void foodsSupplyNutrients_withAmounts(HashMap<String, Double> foodAmountDict ,HashMap<String, HashMap<String, Object>> foodInfoDict, HashMap<String, Double> destNutrientSupplyDict, String[] nutrients, HashMap<String, Object> otherParams)
	{
		HashMap<String, HashMap<String, Object>> destFoodInfoDict = null;
	    if (otherParams != null){
	        destFoodInfoDict = (HashMap<String, HashMap<String, Object>>)(otherParams.get("destFoodInfoDict"));
	    }
	    if (foodAmountDict!=null && foodAmountDict.size() > 0){
	        assert(foodInfoDict!=null && foodInfoDict.size() >= foodAmountDict.size());
	        //已经吃了的各食物的各营养的量加到supply中
	        
	        Object[] foodIds = foodAmountDict.keySet().toArray();
	        for(int i=0; i<foodIds.length; i++){
	            String foodId = (String) foodIds[i];
	            HashMap<String, Object> foodInfo = (HashMap<String, Object>)foodInfoDict.get(foodId);
	            assert(foodInfo != null);
	            Double dObjFoodAmount = foodAmountDict.get(foodId);
	            assert(dObjFoodAmount != null);
	            double dFoodAmount = dObjFoodAmount.doubleValue();
	            if (destFoodInfoDict!=null){//食物信息顺便放到一个集中的dict，以便后面使用
	            	destFoodInfoDict.put(foodId, foodInfo);
	            }
	            
	            //这个食物的各营养的量加到supply中
	            oneFoodSupplyNutrients(foodInfo,dFoodAmount,destNutrientSupplyDict,nutrients,null);
	        }//for i
	    }
	}
	
	void oneFoodSupplyNutrients(HashMap<String, Object> foodInfo, double foodAmount, HashMap<String, Double> destNutrientSupplyDict, String[] nutrients, HashMap<String, Object> otherParams)
	{
		assert(foodInfo!=null);
		String foodId = (String)foodInfo.get(Constants.COLUMN_NAME_NDB_No);
	    assert(foodId!=null);
	    //这个食物的各营养的量加到supply中
	    String[] nutrientsToSupply = nutrients;
	    if (nutrientsToSupply==null) nutrientsToSupply = Tool.convertToStringArray(destNutrientSupplyDict.keySet().toArray());
	    for(int j=0; j<nutrientsToSupply.length; j++){
	        String nutrient = nutrientsToSupply[j];
	        Double dObjNutrientContentOfFood = (Double)foodInfo.get(nutrient);
	        assert(dObjNutrientContentOfFood != null);
	        if (dObjNutrientContentOfFood.doubleValue() != 0.0){
	            double addedNutrientAmount = dObjNutrientContentOfFood.doubleValue()*(foodAmount/100.0);
	            Tool.addDoubleToDictionaryItem(addedNutrientAmount,destNutrientSupplyDict,nutrient);
	        }
	    }//for j
	}
	void foodsSupplyNutrients(ArrayList<HashMap<String, Object>> foodInfoAry,HashMap<String, Double> foodAmountDict,HashMap<String, Double> destNutrientSupplyDict,String[] nutrients,HashMap<String, Object> otherParams)
	{
		HashMap<String, HashMap<String, Object>> foodInfoDict = Tool.dictionaryArrayTo2LevelDictionary_withKeyName(Constants.COLUMN_NAME_NDB_No,foodInfoAry);
	    foodsSupplyNutrients_withAmounts(foodAmountDict,foodInfoDict,destNutrientSupplyDict,nutrients,otherParams);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	/*
	 options 里面用到了 needLimitNutrients 的key，现在虽然用了。但，有错未解决..这错应该是跟 getCustomNutrients 中注释掉的相关
	 这里的输出的营养素只是用于计算的。显示的目前使用 getCustomNutrients 的即可。
	 当givenNutrients不为nil时，将使用givenNutrients来限制要计算的营养素，由于在实际上一些需要排除计算的营养素已经在传入givenNutrients前就排除了，这里实际的作用是将givenNutrients排序。
	 
	 */
	HashMap<String,	Object> getCalculationNutrientsForSmallIncrementLogic_withDRI(HashMap<String, Double> DRIsDict, HashMap<String, Object> options, HashMap<String, Object> params)
	{
	    boolean needLimitNutrients = true;//是否要根据需求限制计算的营养素集合    
//	    if(options != null){
//	        Boolean flag_needLimitNutrients = (Boolean)options.get(Constants.LZSettingKey_needLimitNutrients);
//	        if (flag_needLimitNutrients != null)
//	            needLimitNutrients = flag_needLimitNutrients.booleanValue();
//	    }
	    
	    String[] givenNutrients = null;
	    if (params!=null){
	        givenNutrients = (String[])params.get(Constants.Key_givenNutrients); //这些营养素的意义在于只要求这些要补足，即只有它们用于计算。注意这应该是getCustomNutrients的子集
	    }
	    
	    String[] customNutrients = NutritionTool.getCustomNutrients(options);
	    
	    assert(Tool.arrayContainArrayInSetWay_withOuterArray(customNutrients,givenNutrients));
	    
	    //这里列出的营养素有专门而简单的食物补充，通过我们预置的那些食物反而不好补充
	    String[] nutrientArrayNotCal =new String[]{"Water_(g)", "Sodium_(mg)"};
	    
//	    //这里的营养素最后再计算补充
//	    //    Choline_Tot_ (mg) 胆碱 最少需要187g的蛋来补充或475g黄豆，都有悖常识，似乎是极难补充
//	    //    Vit_D_(µg) 只有鲤鱼等4种才有效补充
//	    //    Fiber_TD_(g) 最适合的只有豆角一种 151g，其次是豆类中的绿豆 233g，蔬菜水果类中的其次是藕 776g，都有些离谱了。不过，如果固定用蔬菜水果类来补，每天3斤的量，还说得过去。另外，不同书籍对其需要量及补充食物的含量都有区别。
//	    //    Calcium_(mg) 能补的食物种类虽多，但是量比较大--不过经试验特殊对待并无显著改进
//	    NSMutableArray *nutrientArrayLastCal = [NSMutableArray arrayWithObjects: @"Vit_D_(µg)",@"Choline_Tot_ (mg)",@"Fiber_TD_(g)", @"Carbohydrt_(g)",@"Energ_Kcal", null];
	    
	    String[] normalNutrientsToCal = null;
	    //这是一个营养素的全集
	    String[] nutrientNamesOrdered = NutritionTool.getFullAndOrderedNutrients();
	    String[] nutrientsInDRI = DRIsDict.keySet().toArray(new String[DRIsDict.size()]);
	    assert(Tool.arrayEqualArrayInSetWay_withArray1(nutrientNamesOrdered,nutrientsInDRI));
	    normalNutrientsToCal = nutrientNamesOrdered;
	    
	    if (true){//(needLimitNutrients){//如果需要使用限制集中的营养素的话
	        //normalNutrientsToCal = [NSMutableArray arrayWithArray: customNutrients];//这里不使用这条语句主要是由于要利用nutrientNamesOrdered中的顺序以供后面计算用
	    	normalNutrientsToCal = Tool.arrayIntersectArray_withSrcArray(normalNutrientsToCal,customNutrients);
	    }
	    
	    if(givenNutrients!=null && givenNutrients.length > 0){
	    	normalNutrientsToCal = Tool.arrayIntersectArray_withSrcArray(normalNutrientsToCal,givenNutrients);
	    }
	    normalNutrientsToCal = Tool.arrayMinusArray_withSrcArray(normalNutrientsToCal, nutrientArrayNotCal);//去掉不应计算的营养素，虽然在前面那些限制性的营养素集合中可能已经去掉了
	    
	    //对以前那些需最后计算的营养素暂且不管，因为算法已经改变
	    HashMap<String,	Object> retData = new HashMap<String, Object>();
	    retData.put("normalNutrientsToCal", normalNutrientsToCal);
	    return retData;
	}
	
	HashMap<String, ArrayList<HashMap<String, Object>>> arrangeFoodsToNutrientRichFoods(HashMap<String, Object> paramData ,HashMap<String, ArrayList<HashMap<String, Object>>> oldRichFoodInfoAryDict)
	{
		HashMap<String, HashMap<String, Object>> foodInfoDict = (HashMap<String, HashMap<String, Object>>)paramData.get("foodInfoDict");
	    String[] nutrientNameAryToCal = (String[])paramData.get("nutrientNameAryToCal");
	    ArrayList<ArrayList<Object>> getFoodsLogs = (ArrayList<ArrayList<Object>>)paramData.get("Out_getFoodsLogs");
	    String logDesc = (String)paramData.get("logDesc");
	    Boolean flagNeedAssertExistRichFood = (Boolean)paramData.get("NeedAssertExistRichFood");
	    assert(foodInfoDict!=null && nutrientNameAryToCal!=null && getFoodsLogs!=null && logDesc!=null && flagNeedAssertExistRichFood!=null);
	    ArrayList<String> nutrientsWithoutRichFood = (ArrayList<String>)paramData.get("Out_nutrientsWithoutRichFood");
	    
	    String logDescNoExist = logDesc + " NoExist";

	    HashMap<String, ArrayList<HashMap<String, Object>>> richFoodInfoAryDict = new HashMap<String, ArrayList<HashMap<String,Object>>>();
	    DataAccess da = getDataAccess();
	    String[] incFoodIds = foodInfoDict.keySet().toArray(new String[foodInfoDict.size()]);
	    for(int i=0; i<nutrientNameAryToCal.length; i++){
	    	String nutrient = nutrientNameAryToCal[i];

	        //暂不对维生素D特殊处理，因为调整了一下鱼的普通上限，试试看
//	        if ([NutrientId_VD isEqualToString:nutrient]){
//	            //对维生素D目前特殊处理，因为在前面专门找了鱼类来补，有某种鱼对应维生素D
//	            if (oldRichFoodInfoAryDict.count > 0){
//	                NSArray *richFoodInfoAry = [oldRichFoodInfoAryDict.get(NutrientId_VD];
//	                assert(richFoodInfoAry.count > 0);
//	                [richFoodInfoAryDict setObject:richFoodInfoAry forKey:nutrient];
//	                continue;
//	            }
//	        }
	        
	        //看看每个普通营养素是否都存在一个富含该成分的食物
	    	ArrayList<HashMap<String, Object>> richFoodInfoAry = da.getFoodsOfRichNutritionAndIntersectGivenSet_withNutrient(nutrient,incFoodIds,false);//这里由于只是检查，不必用自定义的富含食物来限制
	        if (flagNeedAssertExistRichFood.booleanValue()){
	            assert(richFoodInfoAry!=null && richFoodInfoAry.size()>0);
	        }
	        ArrayList<Object> getFoodsLog;
	        if (richFoodInfoAry!=null && richFoodInfoAry.size()>0){
	        	richFoodInfoAryDict.put(nutrient, richFoodInfoAry);

	            getFoodsLog = new ArrayList<Object>();
	            getFoodsLog.add(logDesc);
	            getFoodsLog.add(nutrient);
	            for(int j=0; j<richFoodInfoAry.size(); j++){
	            	HashMap<String, Object> foodInfo = richFoodInfoAry.get(j);
	            	getFoodsLog.add(foodInfo.get(Constants.COLUMN_NAME_NDB_No));
	            	getFoodsLog.add(foodInfo.get(Constants.COLUMN_NAME_CnCaption));
	            }
	            getFoodsLogs.add(getFoodsLog);
	        }else{
	            if (nutrientsWithoutRichFood!=null)
	            	nutrientsWithoutRichFood.add(nutrient);
	            getFoodsLog = new ArrayList<Object>();
	            getFoodsLog.add(logDescNoExist);
	            getFoodsLog.add(nutrient);
	            getFoodsLogs.add(getFoodsLog);
	        }
	    }//for i
	    return richFoodInfoAryDict;
	}


	/*
	 从不同指定类别中选出一种食物取并集
	 如从现有的绝大部分内部类中选 谷类及制品, 干豆类及制品, 蔬菜类及制品, 水果类及制品, "坚果、种子类",泛肉类除鱼类,乳类及制品,蛋类及制品
	 中各选一个食物出来，并考虑VD、VC，然后取并集(9--10种食物)。
	 然后再对每个普通营养素检查，如果存在有某个营养素的富含食物不在已选取的食物集合中出现的，则补充一种这样的富含食物。
	 这样，可选食物集合与全集相比差别不大。也省去了出现多种同某些小类食物而让人感觉不合理的可能。
	 
	 蔬菜类分得不够细，可能选到一个不含vc的蔬菜，目前还没有特殊处理。因为如何能在一个蔬菜和一个水果中推荐好它们各自合适的量，还是个问题。
	 
	 返回值是一个总括型的dictionary，各个细项值才是具体的一些返回结果。
	 */
	HashMap<String, Object> getSomeFoodsToSupplyNutrientsCalculated2_withParams(HashMap<String, Object> paramData,HashMap<String, Object> options)
	{
	    boolean needUseNormalLimitWhenSmallIncrementLogic = Constants.Config_needUseNormalLimitWhenSmallIncrementLogic;
	    if(options != null){
	        Boolean flag_needUseNormalLimitWhenSmallIncrementLogic = (Boolean)options.get(Constants.LZSettingKey_needUseNormalLimitWhenSmallIncrementLogic);
	        if (flag_needUseNormalLimitWhenSmallIncrementLogic != null)
	            needUseNormalLimitWhenSmallIncrementLogic = flag_needUseNormalLimitWhenSmallIncrementLogic.booleanValue();
	    }
	    
	    boolean ifNeedCustomDefinedFoods = Constants.Config_ifNeedCustomDefinedFoods;
	    
	    String[] excludeFoodIds = (String[])paramData.get("excludeFoodIds");
	    String[] nutrientNameAryToCal = (String[])paramData.get("nutrientNameAryToCal");
	    HashMap<String, Double> DRIsDict = (HashMap<String, Double>)paramData.get(Constants.Key_DRI);
	    assert(nutrientNameAryToCal.length>0);
	    assert(DRIsDict.size()>0);
	    
	    ArrayList<ArrayList<Object>> getFoodsLogs = new ArrayList<ArrayList<Object>>(100);
	    ArrayList<Object> getFoodsLog;
	    
	    String[] foodClassAry = new String[]{ Constants.FoodClassify_gulei, Constants.FoodClassify_gandoulei, Constants.FoodClassify_shucai, 
	    		Constants.FoodClassify_shuiguo, Constants.FoodClassify_ganguo, Constants.FoodClassify_nailei, Constants.FoodClassify_danlei};
	    //这里需要对 FoodClassify_shucai 特殊处理，特指植物型蔬菜.目前在数据中把 FoodClassify_shucai 对应的作为植物型蔬菜
	    //另外，要不要每种营养素有至少2个富含食物呢？属于猜
	    //另外，要不要预算富含食物的某个上限值的量都不能满足DRI的情况，属于定量分析  TODO 从而，下面的食物的量也得考虑上限值
	    HashMap<String, Object> foodInfo_shucai, foodInfo_shuiguo = null;
	    DataAccess da = getDataAccess();
	    HashMap<String, HashMap<String, Object>> foodInfoDict = new HashMap<String, HashMap<String,Object>>();
	    for(int i=0; i<foodClassAry.length; i++){
	        String foodClass = foodClassAry[i];
	        HashMap<String, Object> foodInfo = da.getOneFoodByFilters_withIncludeFoodClass(foodClass,null,null,null,excludeFoodIds);
	        assert(foodInfo!=null);
	        if (Constants.FoodClassify_shuiguo.equalsIgnoreCase(foodClass)){
	        	foodInfo_shuiguo = foodInfo;
	        }
	        String foodId = (String)foodInfo.get(Constants.COLUMN_NAME_NDB_No);
	        foodInfoDict.put(foodId, foodInfo);
	        getFoodsLog = new ArrayList<Object>();
	        getFoodsLog.add("getByClass");
	        getFoodsLog.add(foodClass);
	        getFoodsLog.add(foodId);
	        getFoodsLog.add(foodInfo.get(Constants.COLUMN_NAME_CnCaption));
	        getFoodsLogs.add(getFoodsLog);
	    }
	    
	    //蔬菜取两种,一种特意取普通蔬菜,在比较class时用=方式
	    HashMap<String, Object> foodInfo;
	    String foodClass, foodId, nutrient;
	    ArrayList<String> exFoodIds = new ArrayList<String>();
	    String[] excFoodIds, incFoodIds;
	    foodClass = Constants.FoodClassify_shucai;
	    exFoodIds.addAll( foodInfoDict.keySet() ); //foodInfoDict.keySet().toArray(new String[foodInfoDict.size()]);
	    if (excludeFoodIds!=null && excludeFoodIds.length>0) 
	    	Tool.listAppendArray(exFoodIds, excludeFoodIds);
	    foodInfo = da.getOneFoodByFilters_withIncludeFoodClass(null,null,foodClass,null,Tool.convertToStringArray(exFoodIds));
	    assert(foodInfo!=null);
	    foodInfo_shucai = foodInfo;
	    foodId = (String)foodInfo.get(Constants.COLUMN_NAME_NDB_No);
	    foodInfoDict.put(foodId, foodInfo);
	    getFoodsLog = new ArrayList<Object>();
	    getFoodsLog.add("getBy=Class");
	    getFoodsLog.add(foodClass);
	    getFoodsLog.add(foodId);
	    getFoodsLog.add(foodInfo.get(Constants.COLUMN_NAME_CnCaption));
	    getFoodsLogs.add(getFoodsLog);
	    
	    foodInfo = da.getOneFoodByFilters_withIncludeFoodClass(Constants.FoodClassify_rou,Constants.FoodClassify_rou_shui_yu,null,null,excludeFoodIds);
	    assert(foodInfo!=null);
	    foodId = (String)foodInfo.get(Constants.COLUMN_NAME_NDB_No);
	    foodInfoDict.put(foodId, foodInfo);
	    getFoodsLog = new ArrayList<Object>();
	    getFoodsLog.add("getByClass_Exclude");
	    getFoodsLog.add(Constants.FoodClassify_rou);
	    getFoodsLog.add(foodId);
	    getFoodsLog.add(foodInfo.get(Constants.COLUMN_NAME_CnCaption));
	    getFoodsLogs.add(getFoodsLog);
	    
	    //补维生素D中只有鱼类最适合，故特殊处理。从而上面选肉类的时候排除鱼类，避免一次推荐包含多种鱼。
	    nutrient = Constants.NutrientId_VD;
	    foodClass = Constants.FoodClassify_rou_shui_yu;
	    foodInfo = da.getOneRichNutritionFood(nutrient,foodClass,null,null,excludeFoodIds,Constants.Strategy_random,ifNeedCustomDefinedFoods);
	    assert(foodInfo!=null);
	    foodId = (String)foodInfo.get(Constants.COLUMN_NAME_NDB_No);
	    foodInfoDict.put(foodId, foodInfo);
	    getFoodsLog = new ArrayList<Object>();
	    getFoodsLog.add("specialForVD");
	    getFoodsLog.add(nutrient);
	    getFoodsLog.add(foodId);
	    getFoodsLog.add(foodInfo.get(Constants.COLUMN_NAME_CnCaption));
	    getFoodsLogs.add(getFoodsLog);
	    
	    HashMap<String, HashMap<String, Object>> firstBatchFoodInfoDict = (HashMap<String, HashMap<String, Object>>) foodInfoDict.clone();
	    nutrient = Constants.NutrientId_Fiber;
	    foodClass = Constants.FoodClassify_shucai;
	    incFoodIds = foodInfoDict.keySet().toArray(new String[foodInfoDict.size()]);
	    foodInfo = da.getOneRichNutritionFood(nutrient,foodClass,null,incFoodIds,excludeFoodIds,Constants.Strategy_random,ifNeedCustomDefinedFoods);
	    if (foodInfo==null){
	        excFoodIds = foodInfoDict.keySet().toArray(new String[foodInfoDict.size()]);
	        foodInfo = da.getOneRichNutritionFood(nutrient,foodClass,null,null,excludeFoodIds,Constants.Strategy_random,ifNeedCustomDefinedFoods);
	        foodId = (String)foodInfo.get(Constants.COLUMN_NAME_NDB_No);
	        foodInfoDict.put(foodId, foodInfo);
	        getFoodsLog = new ArrayList<Object>();
	        getFoodsLog.add("specialForFiber");
	        getFoodsLog.add(nutrient);
	        getFoodsLog.add(foodId);
	        getFoodsLog.add(foodInfo.get(Constants.COLUMN_NAME_CnCaption));
	        getFoodsLogs.add(getFoodsLog);
	    }
	
	
	    HashMap<String, ArrayList<HashMap<String, Object>>> richFoodInfoAryDict = new HashMap<String, ArrayList<HashMap<String,Object>>>();//每个营养素都记录一组富含食物,以营养素为key
	    ArrayList<String> nutrientsWithoutRichFood = new ArrayList<String>();
	    //看看每个营养素是否都存在一个富含该成分的食物
	    HashMap<String, Object> arrangeParams = new HashMap<String, Object>();
	    arrangeParams.put("foodInfoDict", foodInfoDict);
	    arrangeParams.put("nutrientNameAryToCal", nutrientNameAryToCal);
	    arrangeParams.put("Out_getFoodsLogs", getFoodsLogs);
	    arrangeParams.put("logDesc", "getFoods1 RichFor");
	    arrangeParams.put("NeedAssertExistRichFood", Boolean.valueOf(false));
	    arrangeParams.put("Out_nutrientsWithoutRichFood", nutrientsWithoutRichFood);
	    richFoodInfoAryDict = arrangeFoodsToNutrientRichFoods( arrangeParams,richFoodInfoAryDict);
	    
	    boolean needRearrangeRichFood = false;
	    if(nutrientsWithoutRichFood.size() > 0){
	        //如果存在某些营养素没有富含食物，则补充对应食物
	        needRearrangeRichFood = true;
	        for(int i=0; i<nutrientsWithoutRichFood.size(); i++){
	            nutrient = nutrientsWithoutRichFood.get(i);
	            foodInfo = da.getOneRichNutritionFood(nutrient,null,null,null,excludeFoodIds,Constants.Strategy_random,ifNeedCustomDefinedFoods);
	            assert(foodInfo!=null);
	            foodId = (String)foodInfo.get(Constants.COLUMN_NAME_NDB_No);
	            assert(foodInfoDict.get(foodId)==null);
	            foodInfoDict.put(foodId, foodInfo);
	            Tool.addItemToListHash(foodInfo, nutrient, richFoodInfoAryDict);
	            getFoodsLog = new ArrayList<Object>();
	            getFoodsLog.add("getForNutrient");
	            getFoodsLog.add(nutrient);
	            getFoodsLog.add(foodId);
	            getFoodsLog.add(foodInfo.get(Constants.COLUMN_NAME_CnCaption));
	            getFoodsLogs.add(getFoodsLog);
	        }
	    }
	    if (needRearrangeRichFood){
	        //再整理一遍使营养素对应富含食物，由于补充了几个食物进来，这几个食物也可能是别的营养素的富含食物
	    	arrangeParams = new HashMap<String, Object>();
	        arrangeParams.put("foodInfoDict", foodInfoDict);
	        arrangeParams.put("nutrientNameAryToCal", nutrientNameAryToCal);
	        arrangeParams.put("Out_getFoodsLogs", getFoodsLogs);
	        arrangeParams.put("logDesc", "getFoods2 RichFor");
	        arrangeParams.put("NeedAssertExistRichFood", Boolean.valueOf(true));
	        richFoodInfoAryDict = arrangeFoodsToNutrientRichFoods(arrangeParams,richFoodInfoAryDict);
	    }
	    
	    //检查富含食物考虑到某种上限量的限制能否满足DRI
	    int whileCount = 1;
	    while(true){
	        ArrayList<String> nutrientsLackFood = new ArrayList<String>();
	        //    NSMutableArray *nutrientsLackAmount = [NSMutableArray array];
	        //找出把食物用到某种上限也没法补充够DRI的营养素
	        for(int i=0; i<nutrientNameAryToCal.length; i++){
	            nutrient = nutrientNameAryToCal[i];
	            ArrayList<HashMap<String, Object>> richFoodInfoAry = richFoodInfoAryDict.get(nutrient);
	            assert(richFoodInfoAry!=null && richFoodInfoAry.size()>0);
	            Double nmDRI = DRIsDict.get(nutrient);
	            
	            double dFoodSupplyNutrientSum = 0;
	            for(int j=0; j<richFoodInfoAry.size(); j++){
	                foodInfo = richFoodInfoAry.get(j);
	                Double nmNutrientContent = (Double)foodInfo.get(nutrient);
	                Double nmFoodUpperLimit = (Double)foodInfo.get(Constants.COLUMN_NAME_Upper_Limit);
	                Double nmFoodNormalLimit = (Double)foodInfo.get(Constants.COLUMN_NAME_normal_value);
	                assert(nmFoodUpperLimit!=null && nmFoodNormalLimit!=null);
	                double dFoodLimit = nmFoodUpperLimit.doubleValue();
	                if (needUseNormalLimitWhenSmallIncrementLogic){
	                    dFoodLimit = nmFoodNormalLimit.doubleValue();
	                }
	                double dSupply = nmNutrientContent.doubleValue()*dFoodLimit/100.0;
	                dFoodSupplyNutrientSum += dSupply;
	            }//for j
	            if (dFoodSupplyNutrientSum < nmDRI.doubleValue()){
	            	nutrientsLackFood.add(nutrient);
	            }
	        }//for i
	        if (nutrientsLackFood.size() > 0){
	            //如果存在补充不够的营养素，再给这些营养素补充食物
	        	exFoodIds = new ArrayList<String>();
	        	exFoodIds.addAll(foodInfoDict.keySet());
	            if (excludeFoodIds!=null && excludeFoodIds.length>0)
	            	Tool.listAppendArray(exFoodIds, excludeFoodIds);
	            for(int i=0; i<nutrientsLackFood.size(); i++){
	                nutrient = nutrientsLackFood.get(i);
	                foodInfo = da.getOneRichNutritionFood(nutrient,null,null,null,Tool.convertToStringArray(exFoodIds),Constants.Strategy_random,ifNeedCustomDefinedFoods);
	                assert(foodInfo!=null);
	                foodId = (String)foodInfo.get(Constants.COLUMN_NAME_NDB_No);
	//                assert([foodInfoDict.get(foodId]==null);//由于同一个食物可能富含多种营养素，从而可能根据不同营养素选到同一个食物，从而不能做这个assert
	                foodInfoDict.put(foodId, foodInfo);
	
	                String logDesc = "add for lack Nutrient "+whileCount+".";
	                getFoodsLog = new ArrayList<Object>();
	                getFoodsLog.add(logDesc);
	                getFoodsLog.add(nutrient);
	                getFoodsLog.add(foodId);
	                getFoodsLog.add(foodInfo.get(Constants.COLUMN_NAME_CnCaption));
	                getFoodsLogs.add(getFoodsLog);
	            }
	            
	            //再整理一遍使营养素对应富含食物，由于补充了几个食物进来，这几个食物也可能是别的营养素的富含食物
	            String logDesc = "getFoods-addForLack "+whileCount+".";
	            arrangeParams = new HashMap<String, Object>();
	            arrangeParams.put("foodInfoDict", foodInfoDict);
	            arrangeParams.put("nutrientNameAryToCal", nutrientNameAryToCal);
	            arrangeParams.put("Out_getFoodsLogs", getFoodsLogs);
	            arrangeParams.put("logDesc", logDesc);
	            arrangeParams.put("NeedAssertExistRichFood", Boolean.valueOf(true));
	            richFoodInfoAryDict = arrangeFoodsToNutrientRichFoods(arrangeParams,richFoodInfoAryDict);
	        }else{
	            break;
	        }
	        whileCount++;
	    }//while(true)
	    
	    HashMap<String, Object> retData = new HashMap<String, Object>();
	    retData.put("foodInfoDict", foodInfoDict);//包含所有食物
	    retData.put("richFoodInfoAryDict", richFoodInfoAryDict);//把所有食物按照各个营养素做了一下整理，每个营养素对应到其中的富含食物
	    retData.put("getFoodsLogs", getFoodsLogs);
	    retData.put("foodInfo_shucai", foodInfo_shucai);
	    retData.put("foodInfo_shuiguo", foodInfo_shuiguo);
	    retData.put("firstBatchFoodInfoDict", firstBatchFoodInfoDict);
	    return retData;
	}
	
	/*
	 need flag Config_needConsiderNutrientLoss for getStandardDRIs_withUserInfo ..
	 options contain flag LZSettingKey_needLimitNutrients, LZSettingKey_randSeed
	 params contain Key_givenNutrients
	 */
	public HashMap<String, Object> recommendFoodBySmallIncrementWithPreIntakeOut(HashMap<String, Double> givenFoodAmountDict,
			HashMap<String, Object> userInfo,HashMap<String, Object> options,HashMap<String, Object> params)
	{
	    String[] givenNutrients = null;
	    if (params!=null){
	        givenNutrients = (String[])params.get(Constants.Key_givenNutrients);
	    }
//	    if (givenNutrients!=null && givenNutrients.length>0 && givenNutrients.length<=3){
//	        //这是一个特例处理，当给定的营养素集合包含条目的数量<=3时，让推荐的食物尽可能少，这里通过现有的渐进增量算法不好解决，于是使用以前的尽量一次补满的算法 及搭配特定参数来处理
//	        boolean notAllowSameFood = true;
//	        boolean randomSelectFood = true;
//	        int randomRangeSelectFood = 0;
////	        boolean needLimitNutrients = FALSE;
//	        int limitRecommendFoodCount = 0;
//	        boolean needUseFoodLimitTableWhenCal = true;
//	        boolean needUseLessAsPossibleFood = true;
//	        String upperLimitTypeForSupplyAsPossible = Constants.COLUMN_NAME_Upper_Limit;
//	        if (options == null) options = new HashMap<String, Object>();
//	        options.put(Constants.LZSettingKey_notAllowSameFood, Boolean.valueOf(notAllowSameFood));
//	        options.put(Constants.LZSettingKey_randomSelectFood, Boolean.valueOf(randomSelectFood));
//	        options.put(Constants.LZSettingKey_randomRangeSelectFood, Integer.valueOf(randomRangeSelectFood) );
////	        options.put(Constants.LZSettingKey_needLimitNutrients, Boolean.valueOf(needLimitNutrients) );
//	        options.put("limitRecommendFoodCount", Integer.valueOf(limitRecommendFoodCount));
//	        options.put(Constants.LZSettingKey_needUseFoodLimitTableWhenCal,Boolean.valueOf(needUseFoodLimitTableWhenCal) );
//	        options.put(Constants.LZSettingKey_upperLimitTypeForSupplyAsPossible,Boolean.valueOf(upperLimitTypeForSupplyAsPossible) );
//	        options.put(Constants.LZSettingKey_needUseLessAsPossibleFood, Boolean.valueOf(needUseLessAsPossibleFood));
//	        HashMap<String, Object> retDict = [self recommendFood4SupplyAsPossibleWithPreIntake:givenFoodAmountDict andUserInfo:userInfo andParams:params andOptions:options];
//	        return retDict;
//	    }

	    DataAccess da = getDataAccess();
	    HashMap<String, Double> DRIsDict = da.getStandardDRIs_withUserInfo(userInfo,options);
	    HashMap<String, Double> DRIULsDict = da.getStandardDRIULs_withUserInfo(userInfo,options);

	    HashMap<String, HashMap<String, Double>> DRIdata = new HashMap<String, HashMap<String,Double>>();
	    DRIdata.put(Constants.Key_DRI, DRIsDict);
	    DRIdata.put(Constants.Key_DRIUL, DRIULsDict);
	    		
	    HashMap<String, Object> retData = recommendFoodBySmallIncrementWithPreIntake(givenFoodAmountDict,DRIdata,options,params);
	    retData.put(Constants.Key_userInfo, userInfo);
	    return retData;
	}


	HashMap<String, Object> recommendFoodBySmallIncrementWithPreIntake(HashMap<String, Double> givenFoodAmountDict, 
			HashMap<String, HashMap<String, Double>> DRIdata, HashMap<String, Object> options, HashMap<String, Object> params)
	{
	    boolean needLimitNutrients = Constants.Config_needLimitNutrients;//是否要根据需求限制计算的营养素集合
//	    boolean needUseFoodLimitTableWhenCal = true;
	    boolean needUseDefinedIncrementUnit = Constants.Config_needUseDefinedIncrementUnit;// 食物的增量是使用下限值还是通用的1g的增量
	    boolean needUseNormalLimitWhenSmallIncrementLogic = Constants.Config_needUseNormalLimitWhenSmallIncrementLogic; //对于食物的限量是使用普通限制还是使用上限限制
	    boolean needUseFirstRecommendWhenSmallIncrementLogic = Constants.Config_needUseFirstRecommendWhenSmallIncrementLogic; //食物第一次的增量是否使用最初推荐量
	    boolean needFirstSpecialForShucaiShuiguo = Constants.Config_needFirstSpecialForShucaiShuiguo; //对于最开始选出来的蔬菜水果，在最开始使用最初推荐量。这被 needSpecialForFirstBatchFoods 所覆盖。
	    boolean needSpecialForFirstBatchFoods = Constants.Config_needSpecialForFirstBatchFoods; //第一批选出的食物在最开始时使用到各自的最初推荐量
	    boolean alreadyChoosedFoodHavePriority = Constants.Config_alreadyChoosedFoodHavePriority;//是否已经用过的食物优先使用
	    boolean needPriorityFoodToSpecialNutrient = Constants.Config_needPriorityFoodToSpecialNutrient; //对于某些营养素，优先使用某些种类的食物，如蔬菜
	    
	    boolean needSpecialForFirstBatchFoods_applied = false;
	    
	    long randSeed = (new java.util.Date()).getTime();
	    
	    if(options != null){
	    	Boolean flag_needLimitNutrients = (Boolean)options.get(Constants.LZSettingKey_needLimitNutrients); 
	        if (flag_needLimitNutrients != null)
	            needLimitNutrients = flag_needLimitNutrients.booleanValue();
	        
	        Boolean flag_needUseDefinedIncrementUnit = (Boolean)options.get(Constants.LZSettingKey_needUseDefinedIncrementUnit);
	        if (flag_needUseDefinedIncrementUnit != null)
	            needUseDefinedIncrementUnit = flag_needUseDefinedIncrementUnit.booleanValue();

	        Boolean flag_needUseNormalLimitWhenSmallIncrementLogic = (Boolean)options.get(Constants.LZSettingKey_needUseNormalLimitWhenSmallIncrementLogic);
	        if (flag_needUseNormalLimitWhenSmallIncrementLogic != null)
	            needUseNormalLimitWhenSmallIncrementLogic = flag_needUseNormalLimitWhenSmallIncrementLogic.booleanValue();
	        
	        Boolean flag_needUseFirstRecommendWhenSmallIncrementLogic = (Boolean)options.get(Constants.LZSettingKey_needUseFirstRecommendWhenSmallIncrementLogic);
	        if (flag_needUseFirstRecommendWhenSmallIncrementLogic != null)
	            needUseFirstRecommendWhenSmallIncrementLogic = flag_needUseFirstRecommendWhenSmallIncrementLogic.booleanValue();
	        
	        Boolean flag_needFirstSpecialForShucaiShuiguo = (Boolean)options.get(Constants.LZSettingKey_needFirstSpecialForShucaiShuiguo);
	        if (flag_needFirstSpecialForShucaiShuiguo != null)
	            needFirstSpecialForShucaiShuiguo = flag_needFirstSpecialForShucaiShuiguo.booleanValue();
	        
	        Boolean flag_needSpecialForFirstBatchFoods = (Boolean)options.get(Constants.LZSettingKey_needSpecialForFirstBatchFoods);
	        if (flag_needSpecialForFirstBatchFoods != null)
	            needSpecialForFirstBatchFoods = flag_needSpecialForFirstBatchFoods.booleanValue();
	        
	        Boolean flag_alreadyChoosedFoodHavePriority = (Boolean)options.get(Constants.LZSettingKey_alreadyChoosedFoodHavePriority);
	        if (flag_alreadyChoosedFoodHavePriority != null)
	            alreadyChoosedFoodHavePriority = flag_alreadyChoosedFoodHavePriority.booleanValue();
	        
	        Boolean flag_needPriorityFoodToSpecialNutrient = (Boolean)options.get(Constants.LZSettingKey_needPriorityFoodToSpecialNutrient);
	        if (flag_needPriorityFoodToSpecialNutrient != null)
	            needPriorityFoodToSpecialNutrient = flag_needPriorityFoodToSpecialNutrient.booleanValue();
	        
	        Long nm_randSeed =  (Long)options.get(Constants.LZSettingKey_randSeed);
	        if (nm_randSeed != null && nm_randSeed.longValue() > 0)
	            randSeed = nm_randSeed.longValue();
	        else
	        	options.put(Constants.LZSettingKey_randSeedOut, nm_randSeed);
	    }
	    Log.d(LogTag, "in recommendFoodBySmallIncrementWithPreIntake, randSeed="+randSeed);//如果某次情况需要调试，通过这个seed的设置应该可以重复当时情况
	    Tool.getRandObj(randSeed);
	    
	    
	    int defFoodIncreaseUnit = Constants.Config_defaultFoodIncreaseUnit;
	    
	    HashMap<String, Double> DRIsDict = DRIdata.get(Constants.Key_DRI);
	    HashMap<String, Double> DRIULsDict = DRIdata.get(Constants.Key_DRIUL); 
	    
	    DataAccess da = getDataAccess();
	    
	    ArrayList<ArrayList<Object>> calculationLogs = new ArrayList<ArrayList<Object>>(1000);
	    ArrayList<Object> calculationLog;
	    String logMsg;
	    
	    //算出需要计算的营养素清单及预置一定的顺序
	    HashMap<String,	Object> calNutrientsData = getCalculationNutrientsForSmallIncrementLogic_withDRI(DRIsDict,options,params);
	    String[] normalNutrientsToCal = (String[])calNutrientsData.get("normalNutrientsToCal");
	    String[] originalNutrientNameAryToCal = normalNutrientsToCal;

	    logMsg = "normalNutrientsToCal, cnt="+normalNutrientsToCal.length+" "+StringUtils.join(normalNutrientsToCal,"," );
	    Log.d(LogTag, logMsg);

	    calculationLog = new ArrayList<Object>();
	    calculationLog.add("normalNutrientsToCal begin,cnt=");
	    calculationLog.add(normalNutrientsToCal.length);
	    calculationLog.addAll(Tool.convertFromArrayToList(normalNutrientsToCal));
	    
	    //提前选定一些食物用于补足各项营养素，下面只是计算各个食物的量
	    HashMap<String, Object> paramDataForChooseFoods = new HashMap<String, Object>();
	    paramDataForChooseFoods.put("nutrientNameAryToCal", originalNutrientNameAryToCal);
	    paramDataForChooseFoods.put(Constants.Key_DRI, DRIsDict);
	    if (givenFoodAmountDict!=null && givenFoodAmountDict.size() > 0)
	    	paramDataForChooseFoods.put("excludeFoodIds", givenFoodAmountDict.keySet().toArray(new String[givenFoodAmountDict.size()]));
	    HashMap<String, Object> preChooseFoodsData = getSomeFoodsToSupplyNutrientsCalculated2_withParams(paramDataForChooseFoods,options);
	    HashMap<String, HashMap<String, Object>> preChooseFoodInfoDict = (HashMap<String, HashMap<String, Object>>)preChooseFoodsData.get("foodInfoDict");
	    HashMap<String, ArrayList<HashMap<String, Object>>> preChooseRichFoodInfoAryDict = (HashMap<String, ArrayList<HashMap<String, Object>>>)preChooseFoodsData.get("richFoodInfoAryDict");
	    ArrayList<ArrayList<Object>> getFoodsLogs = (ArrayList<ArrayList<Object>>)preChooseFoodsData.get("getFoodsLogs");
	    HashMap<String, Object> preChooseFoodInfo_shucai = (HashMap<String, Object>) preChooseFoodsData.get("foodInfo_shucai");
	    HashMap<String, Object> preChooseFoodInfo_shuiguo = (HashMap<String, Object>)preChooseFoodsData.get("foodInfo_shuiguo");
	    HashMap<String, HashMap<String, Object>> firstBatchFoodInfoDict = (HashMap<String, HashMap<String, Object>>)preChooseFoodsData.get("firstBatchFoodInfoDict");

	    
	    //预先为计算 这种食物针对目标营养素补充导致的营养素A的超量指数 准备一些可以预先计算的数据，
	    //这种食物导致的营养素A的超量比例 = 增加单位量这种食物导致的营养素A的增量 / (营养素A的上限 - DRI_Of营养素A)
	    //这种食物导致的dest营养素的增长比例 = 增加单位量这种食物导致的dest营养素的增量 / DRI_Ofdest营养素
	    HashMap<String, HashMap<String, Double>> foodsCauseNutrientsExceedRateDict = new HashMap<String, HashMap<String,Double>>();
	    HashMap<String, HashMap<String, Double>> foodsCauseNutrientsAddRateDict = new HashMap<String, HashMap<String,Double>>();
	    String[] preChooseFoodIdAry = preChooseFoodInfoDict.keySet().toArray(new String[preChooseFoodInfoDict.size()]);
	    for(int i=0; i<preChooseFoodIdAry.length; i++){
	        String foodId = preChooseFoodIdAry[i];
	        HashMap<String, Object> foodInfo = preChooseFoodInfoDict.get(foodId);
	        HashMap<String, Double> foodCauseNutrientsExceedRateDict = new HashMap<String, Double>();
	        HashMap<String, Double> foodCauseNutrientsAddRateDict = new HashMap<String, Double>();
	        for(int j=0; j<normalNutrientsToCal.length; j++){
	            String nutrient = normalNutrientsToCal[j];
	            Double nmDRI = (Double)DRIsDict.get(nutrient);
	            Double nmDRIul = (Double)DRIULsDict.get(nutrient);
	            Double foodNutrientContent = (Double)foodInfo.get(nutrient);
	            assert(nmDRI!=null);
	            assert(nmDRIul!=null);
	            assert(foodNutrientContent!=null);
	            if(nmDRIul.doubleValue()>Constants.Config_nearZero && nmDRI.doubleValue()>Constants.Config_nearZero && foodNutrientContent.doubleValue()>Constants.Config_nearZero){
	                //此营养素的DRI推荐值和上限值存在，并且食物对于此营养素的含量不为0
	                //对于镁，表中标注的上限值仅表示从药理学的角度得出的摄入值，而并不包括从食物和水中摄入的量。  The ULs for magnesium represent intake from a pharmacological agent only and do not include intake from food and water.
	                if (! Constants.NutrientId_Magnesium.equalsIgnoreCase(nutrient)){//对于镁元素由于源数据的原因得特殊处理
	                    assert(nmDRIul.doubleValue()>nmDRI.doubleValue());
	                    double nutrientExceedRate = foodNutrientContent.doubleValue() / (nmDRIul.doubleValue() - nmDRI.doubleValue());
	                    foodCauseNutrientsExceedRateDict.put(nutrient, Double.valueOf(nutrientExceedRate));
	                }else{
	                    double nutrientExceedRate = foodNutrientContent.doubleValue() / (nmDRIul.doubleValue()+nmDRI.doubleValue() - nmDRI.doubleValue());
	                    foodCauseNutrientsExceedRateDict.put(nutrient, Double.valueOf(nutrientExceedRate));
	                }
	            }
	            if(nmDRI.doubleValue()>Constants.Config_nearZero && foodNutrientContent.doubleValue()>Constants.Config_nearZero){
	                //此营养素的DRI推荐值存在，并且食物对于此营养素的含量不为0
	                double nutrientAddRate = foodNutrientContent.doubleValue() / nmDRIul.doubleValue();
	                foodCauseNutrientsAddRateDict.put(nutrient, Double.valueOf(nutrientAddRate));
	            }
	        }//for j
	        foodsCauseNutrientsExceedRateDict.put(foodId, foodCauseNutrientsExceedRateDict);
	        foodsCauseNutrientsAddRateDict.put(foodId, foodCauseNutrientsAddRateDict);
	    }//for i
	    
	    
	    String[] takenFoodIDs = null;
	    if (givenFoodAmountDict!=null && givenFoodAmountDict.size()>0)
	        takenFoodIDs = givenFoodAmountDict.keySet().toArray(new String[givenFoodAmountDict.size()]) ;
	    ArrayList<HashMap<String, Object>> takenFoodAttrAry = da.getFoodAttributesByIds(takenFoodIDs);
	    
	    HashMap<String, Double> recommendFoodAmountDict = new HashMap<String, Double>();//key is NDB_No
//	    NSMutableDictionary *recommendFoodAttrDict = [NSMutableDictionary dictionaryWithCapacity:100];//key is NDB_No
	    HashMap<String, Double> foodSupplyAmountDict = new HashMap<String, Double>();
	    if (givenFoodAmountDict != null)//putAll can not deal null param
	    	foodSupplyAmountDict.putAll(givenFoodAmountDict);//包括takenFoodAmountDict 和 recommendFoodAmountDict。与nutrientSupplyDict对应。
	    HashMap<String, Double> nutrientSupplyDict = Tool.generateDictionaryWithFillItem(Double.valueOf(0),DRIsDict.keySet().toArray(new String[DRIsDict.size()]));
//	    NSMutableDictionary *nutrientSupplyDict = [NSMutableDictionary dictionaryWithDictionary:DRIsDict];
//	    NSArray *nutrientNames1 = [nutrientSupplyDict allKeys];
//	    for (int i=0; i<nutrientNames1.count; i++) {//初始化supply集合
//	        [nutrientSupplyDict setObject:[NSNumber numberWithDouble:0.0] forKey:nutrientNames1[i]];
//	    }
	    
	    HashMap<String, HashMap<String, Object>> takenFoodAttrDict = new HashMap<String, HashMap<String,Object>>();//key is NDB_No
	    if (takenFoodAttrAry != null ){//已经吃了的各食物的各营养的量加到supply中
	    	HashMap<String, Object> paramsDict = new HashMap<String, Object>();
	    	paramsDict.put("destFoodInfoDict", takenFoodAttrDict);
	        foodsSupplyNutrients(takenFoodAttrAry,givenFoodAmountDict,nutrientSupplyDict,nutrientSupplyDict.keySet().toArray(new String[nutrientSupplyDict.size()]),paramsDict);
	    }//if (takenFoodAttrAry != null )
	    
	    HashMap<String, Double> nutrientInitialSupplyDict = new HashMap<String, Double>();
	    nutrientInitialSupplyDict.putAll(nutrientSupplyDict);//记录already taken food提供的营养素的量
	    ArrayList<String> nutrientNameAryToCal = Tool.convertFromArrayToList(normalNutrientsToCal);
	    

	    ArrayList<String> nutrientNameArySupplyEnough = new ArrayList<String>();
	    ArrayList<String> nutrientNameAryToUpperLimit = new ArrayList<String>();
	    ArrayList<ArrayList<Object>>  foodSupplyNutrientSeqs = new ArrayList<ArrayList<Object>>();
	    ArrayList<String> alreadyReachUpperLimitFoodIds = new ArrayList<String>();
	    ArrayList<String> alreadyReachNormalLimitFoodIds = new ArrayList<String>();
	    
	    if (needSpecialForFirstBatchFoods){
	        if ((givenFoodAmountDict==null || givenFoodAmountDict.size()==0) && originalNutrientNameAryToCal.length>=6){
	            //如果有预选食物，由于难以判断预选的多少，所以干脆认为多而不特殊的批量加上第一批。
	            //如果营养素太少，又使用了第一批批量的话，可能造成即使选了1个营养素也有约6个食物来补，使人不符常理。
	            needSpecialForFirstBatchFoods_applied = true;
	            String[] foodIds = firstBatchFoodInfoDict.keySet().toArray(new String[firstBatchFoodInfoDict.size()]);
	            HashMap<String, Double> firstBatchFoodAmountDict = new HashMap<String, Double>();
	            for(int i=0; i<foodIds.length; i++){
	                String foodId = foodIds[i];
	                HashMap<String, Object> foodInfo = firstBatchFoodInfoDict.get(foodId);
	                Double nmFood_first_recommend = (Double)foodInfo.get(Constants.COLUMN_NAME_first_recommend);
	                assert(nmFood_first_recommend!=null && nmFood_first_recommend.doubleValue()>0);
	                firstBatchFoodAmountDict.put(foodId, nmFood_first_recommend);
	                
	                ArrayList<Object> foodSupplyNutrientSeq = new ArrayList<Object>();
	                foodSupplyNutrientSeq.add("");
	                foodSupplyNutrientSeq.add("special first batch food");
	                foodSupplyNutrientSeq.add(foodInfo.get(Constants.COLUMN_NAME_CnCaption));
	                foodSupplyNutrientSeq.add(foodId);
	                foodSupplyNutrientSeq.add(nmFood_first_recommend);
	                foodSupplyNutrientSeq.add(foodInfo.get("Shrt_Desc"));
	                foodSupplyNutrientSeq.add("");
	                foodSupplyNutrientSeqs.add(foodSupplyNutrientSeq);
	                logMsg = "supply food:" + StringUtils.join(foodSupplyNutrientSeq.toArray()," , ");
	                Log.d(LogTag, logMsg);

	                calculationLog = new ArrayList<Object>();
	                calculationLog.add("supply food:");
	                calculationLog.addAll(foodSupplyNutrientSeq);
	                calculationLogs.add(calculationLog);
	            }//for
	            foodsSupplyNutrients_withAmounts(firstBatchFoodAmountDict,preChooseFoodInfoDict,nutrientSupplyDict,null,null);//营养量累加
	            Tool.addDoubleDictionaryToDictionary_withSrcAmountDictionary(firstBatchFoodAmountDict,recommendFoodAmountDict);//推荐量累加
	            Tool.addDoubleDictionaryToDictionary_withSrcAmountDictionary(firstBatchFoodAmountDict,foodSupplyAmountDict);//供给量累加
	        }//if (givenFoodAmountDict.count == 0 && originalNutrientNameAryToCal.count>=6)
	    }//if (needSpecialForFirstBatchFoods)
	    
	    if (needFirstSpecialForShucaiShuiguo && !needSpecialForFirstBatchFoods_applied){
	        if (originalNutrientNameAryToCal.length>=4){//为了避免所选营养素太少而推荐食物相对感觉太多的情况
	            double dSupplyVC = Tool.getDoubleFromDictionaryItem_withDictionary(nutrientSupplyDict,Constants.NutrientId_VC);
	            if (dSupplyVC == 0 ){
	                //由于存在少数不富含任何一种营养素的食物，这里只选富含食物就会把它们漏了。这里从返回结果中直接取。
	            	HashMap<String, Object> food_shucai = preChooseFoodInfo_shucai;
	            	HashMap<String, Object> food_shuiguo = preChooseFoodInfo_shuiguo;
	                if (food_shucai != null){
	                    String nutrientNameToCal = Constants.NutrientId_VC;
	                    HashMap<String, Object> foodToSupplyOneNutrient = food_shucai;
	                    String foodIdToSupply = (String)foodToSupplyOneNutrient.get(Constants.COLUMN_NAME_NDB_No);
	                    Double nmFood_first_recommend = (Double)foodToSupplyOneNutrient.get(Constants.COLUMN_NAME_first_recommend);
	                    assert(nmFood_first_recommend!=null);
	                    double dFoodIncreaseUnit = nmFood_first_recommend.doubleValue();
	                    
	                    oneFoodSupplyNutrients(foodToSupplyOneNutrient,dFoodIncreaseUnit,nutrientSupplyDict,null,null);//营养量累加
	                    Tool.addDoubleToDictionaryItem(dFoodIncreaseUnit,recommendFoodAmountDict,foodIdToSupply);//推荐量累加
	                    Tool.addDoubleToDictionaryItem(dFoodIncreaseUnit,foodSupplyAmountDict,foodIdToSupply);//供给量累加
	                    
	                    ArrayList<Object> foodSupplyNutrientSeq = new ArrayList<Object>();
	                    foodSupplyNutrientSeq.add(nutrientNameToCal);
	                    foodSupplyNutrientSeq.add("special first for VC");
	                    foodSupplyNutrientSeq.add(foodToSupplyOneNutrient.get(Constants.COLUMN_NAME_CnCaption));
	                    foodSupplyNutrientSeq.add(foodIdToSupply);
	                    foodSupplyNutrientSeq.add(Double.valueOf(dFoodIncreaseUnit));
	                    foodSupplyNutrientSeq.add(foodToSupplyOneNutrient.get("Shrt_Desc"));
	                    foodSupplyNutrientSeq.add(Constants.FoodClassify_shucai);
	                    foodSupplyNutrientSeqs.add(foodSupplyNutrientSeq);
	                    logMsg = "supply food:"+StringUtils.join(foodSupplyNutrientSeq," , ");
	                    Log.d(LogTag, logMsg);

	                    calculationLog = new ArrayList<Object>();
	                    calculationLog.add("supply food:");
	                    calculationLog.addAll(foodSupplyNutrientSeq);
	                    calculationLogs.add(calculationLog);
	                }
	                if (food_shuiguo != null){
	                    String nutrientNameToCal = Constants.NutrientId_VC;
	                    HashMap<String, Object> foodToSupplyOneNutrient = food_shuiguo;
	                    String foodIdToSupply = (String)foodToSupplyOneNutrient.get(Constants.COLUMN_NAME_NDB_No);
	                    Double nmFood_first_recommend = (Double)foodToSupplyOneNutrient.get(Constants.COLUMN_NAME_first_recommend);
	                    assert(nmFood_first_recommend!=null);
	                    double dFoodIncreaseUnit = nmFood_first_recommend.doubleValue();
	                    
	                    oneFoodSupplyNutrients(foodToSupplyOneNutrient,dFoodIncreaseUnit,nutrientSupplyDict,null,null);//营养量累加
	                    Tool.addDoubleToDictionaryItem(dFoodIncreaseUnit,recommendFoodAmountDict,foodIdToSupply);//推荐量累加
	                    Tool.addDoubleToDictionaryItem(dFoodIncreaseUnit,foodSupplyAmountDict,foodIdToSupply);//供给量累加
	                    
	                    ArrayList<Object> foodSupplyNutrientSeq = new ArrayList<Object>();
	                    foodSupplyNutrientSeq.add(nutrientNameToCal);
	                    foodSupplyNutrientSeq.add("special first for VC");
	                    foodSupplyNutrientSeq.add(foodToSupplyOneNutrient.get(Constants.COLUMN_NAME_CnCaption));
	                    foodSupplyNutrientSeq.add(foodIdToSupply);
	                    foodSupplyNutrientSeq.add(Double.valueOf(dFoodIncreaseUnit));
	                    foodSupplyNutrientSeq.add(foodToSupplyOneNutrient.get("Shrt_Desc"));
	                    foodSupplyNutrientSeq.add(Constants.FoodClassify_shuiguo);
	                    foodSupplyNutrientSeqs.add(foodSupplyNutrientSeq);
	                    logMsg = "supply food:"+StringUtils.join(foodSupplyNutrientSeq," , ");
	                    Log.d(LogTag, logMsg);

	                    calculationLog = new ArrayList<Object>();
	                    calculationLog.add("supply food:");
	                    calculationLog.addAll(foodSupplyNutrientSeq);
	                    calculationLogs.add(calculationLog);
	                    
	                }
	            }//if (dSupplyVC == 0)
	        }//if (originalNutrientNameAryToCal.count>=4)
	    }//needFirstSpecialForShucaiShuiguo

	    //对每个还需补足的营养素进行计算
	    while (true) {
	        String nutrientNameToCal = null;
	        int idxOfNutrientNameToCal = 0;
//	        String typeOfNutrientNamesToCal = null;
	        double maxNutrientLackRatio = Constants.Config_nearZero;
	        String maxLackNutrientName = null;
	        if (nutrientNameAryToCal != null && nutrientNameAryToCal.size() > 0){
	            for(int i=nutrientNameAryToCal.size()-1; i>=0; i--){//先去掉已经补满的
	                String nutrientName = nutrientNameAryToCal.get(i);
	                Double nmSupplied = nutrientSupplyDict.get(nutrientName);
	                Double nmTotalNeed1Unit = DRIsDict.get(nutrientName);
	                Double nmDRIul = DRIULsDict.get(nutrientName);
	                double toAdd = nmTotalNeed1Unit.doubleValue() - nmSupplied.doubleValue();
	                if (toAdd <= Constants.Config_nearZero){
	                    nutrientNameAryToCal.remove(i);
	                    nutrientNameArySupplyEnough.add(nutrientName);
	                    if (nmDRIul.doubleValue()>0)
	                        nutrientNameAryToUpperLimit.add(nutrientName);
	                    logMsg = "Already Full for "+nutrientName+", removed";
	                    Log.d(LogTag, logMsg);
	                    calculationLog = new ArrayList<Object>();
	                    calculationLog.add(logMsg);
	                    calculationLogs.add(calculationLog);
	                }
	            }
	            if (nutrientNameAryToCal.size() > 0){
	            	logMsg = "nutrientNameAryToCal cal-ing,cnt="+nutrientNameAryToCal.size()+", "+StringUtils.join(nutrientNameAryToCal,",");
                    Log.d(LogTag, logMsg);
                    calculationLog = new ArrayList<Object>();
                    calculationLog.add("nutrientNameAryToCal cal-ing,cnt=");
                    calculationLog.add(nutrientNameAryToCal.size());
                    calculationLog.addAll(nutrientNameAryToCal);
                    calculationLogs.add(calculationLog);
	                
	                maxNutrientLackRatio = Constants.Config_nearZero;
	                maxLackNutrientName = null;
	                calculationLog = new ArrayList<Object>();
                    calculationLog.add("nutrients lack rates:");
	                for(int i=0; i<nutrientNameAryToCal.size(); i++){//先找出最需要补的营养素,即缺乏比例最大的
	                    String nutrientName = nutrientNameAryToCal.get(i);
	                    Double nmSupplied = nutrientSupplyDict.get(nutrientName);
	                    Double nmTotalNeed1Unit = DRIsDict.get(nutrientName);
	                    double toAdd = nmTotalNeed1Unit.doubleValue()-nmSupplied.doubleValue();
	                    assert(toAdd > Constants.Config_nearZero);
	                    double lackRatio = toAdd/(nmTotalNeed1Unit.doubleValue());
	                    calculationLog.add(nutrientName);
	                    calculationLog.add(lackRatio);
	                    if (lackRatio > maxNutrientLackRatio){
	                        maxLackNutrientName = nutrientName;
	                        maxNutrientLackRatio = lackRatio;
	                        idxOfNutrientNameToCal = i;
	                    }
	                }
	                Log.d(LogTag, StringUtils.join(calculationLog,","));
	                calculationLogs.add(calculationLog);
	                
	                logMsg = "maxLackNutrientName="+maxLackNutrientName+", maxNutrientLackRatio="+maxNutrientLackRatio+", idxOfNutrientNameToCal="+idxOfNutrientNameToCal;
                    Log.d(LogTag, logMsg);
                    calculationLog = new ArrayList<Object>();
                    calculationLog.add("maxLackNutrientName=");
                    calculationLog.add(maxLackNutrientName);
                    calculationLog.add("maxNutrientLackRatio=");
                    calculationLog.add(maxNutrientLackRatio);
                    calculationLog.add("idxOfNutrientNameToCal=");
                    calculationLog.add(idxOfNutrientNameToCal);
                    calculationLog.addAll(nutrientNameAryToCal);
                    calculationLogs.add(calculationLog);
	                
	                nutrientNameToCal = maxLackNutrientName;//已经取到待计算的营养素，但不从待计算集合中去掉，因为一次计算未必能够补充满这种营养素，由于有上限表之类的限制。并且注意下次找到的最需补充的营养素不一定是现在这个了。
//	                typeOfNutrientNamesToCal = Type_normalSet;
	            }//if (nutrientNameAryToCal.count > 0) L2
	        }//if (nutrientNameAryToCal.count > 0) L1
	        
	        if (nutrientNameToCal==null){
	            assert(nutrientNameAryToCal.size()==0);
	            break;
	        }
	        
	        //当前有需要计算的营养素
//	        Double nmSupplied = nutrientSupplyDict[nutrientNameToCal];
//	        Double nmTotalNeed1Unit = DRIsDict[nutrientNameToCal];
//	        double toAddForNutrient = [nmTotalNeed1Unit.doubleValue()-[nmSupplied.doubleValue();
//	        assert(toAddForNutrient>Config_nearZero);
	        
	        
	        ArrayList<HashMap<String, Object>> foodsToSupplyOneNutrient = preChooseRichFoodInfoAryDict.get(nutrientNameToCal);//找一些对于这种营养素含量最高的食物
	        assert(foodsToSupplyOneNutrient!=null && foodsToSupplyOneNutrient.size()>0);
	        HashMap<String, Object> foodToSupplyOneNutrient = null;
	        String foundFoodWay = null;
	        if (foodsToSupplyOneNutrient.size() == 1){//只有一种富含食物时，只能选它
	            foodToSupplyOneNutrient = foodsToSupplyOneNutrient.get(0);
	            foundFoodWay = "only 1 food for nutrient";
	        }else{//foodsToSupplyOneNutrient.count > 1//富含食物超过一种时，需要选一种合适的
	        	String[] foodIdsToSupplyOneNutrient = Tool.convertToStringArray( Tool.getPropertyArrayFromDictionaryArray_withPropertyName(Constants.COLUMN_NAME_NDB_No,foodsToSupplyOneNutrient) );
	            if (needUseNormalLimitWhenSmallIncrementLogic){
	            	foodIdsToSupplyOneNutrient = Tool.arrayMinusArray_withSrcArray(foodIdsToSupplyOneNutrient,alreadyReachNormalLimitFoodIds);
	            }else{
	            	foodIdsToSupplyOneNutrient = Tool.arrayMinusArray_withSrcArray(foodIdsToSupplyOneNutrient,alreadyReachUpperLimitFoodIds);
	            }
	            
	            String[] foodIdsNotReachUpperLimit = foodIdsToSupplyOneNutrient;
	            assert(foodIdsNotReachUpperLimit.length>0);//否则是前面的计算有误，因为在选食物时考虑了上限的问题
	            if (foodIdsNotReachUpperLimit.length==1){
	                String foodIdToSupplyOneNutrient = foodIdsToSupplyOneNutrient[0];
	                foodToSupplyOneNutrient = preChooseFoodInfoDict.get(foodIdToSupplyOneNutrient);
	                foundFoodWay = "only 1 food notReach ULimit";
	                assert(foodToSupplyOneNutrient!=null);
	            }else{//foodIdsNotReachUpperLimit.count > 1
	                //从多种富含此营养素的且未超数量上限的食物中选出最合适的一种
	                boolean doneUsePriorityFoodToSpecialNutrient = false;//表示是否已经取到食物了
	                if (alreadyChoosedFoodHavePriority){
	                    String[] foodIdsNotReachUpperLimit_local = foodIdsNotReachUpperLimit;
	                    String[] recommendFoodIds = recommendFoodAmountDict.keySet().toArray(new String[recommendFoodAmountDict.size()]);
	                    String[] foodIds_recommended_NotReachUpperLimit = Tool.arrayIntersectArray_withSrcArray(foodIdsNotReachUpperLimit_local,recommendFoodIds);
	                    if (foodIds_recommended_NotReachUpperLimit!=null && foodIds_recommended_NotReachUpperLimit.length > 0){
	                        int idx = 0;
	                        long randval = 0;
	                        if (foodIds_recommended_NotReachUpperLimit.length>1){
	                        	idx = Tool.getRandObj().nextInt(foodIds_recommended_NotReachUpperLimit.length);
	                        }
	                        String foodId = foodIds_recommended_NotReachUpperLimit[idx];
	                        foodToSupplyOneNutrient = preChooseFoodInfoDict.get(foodId);
	                        assert(foodToSupplyOneNutrient!=null);
	                        foundFoodWay = "priorityFoodForAlready,"+randval+" "+foodIds_recommended_NotReachUpperLimit.length+" "+idx+".";
	                        doneUsePriorityFoodToSpecialNutrient = true;
	                    }
	                }
	                
	                if (!doneUsePriorityFoodToSpecialNutrient){
	                    //其次优先使用蔬菜水果来补，但是脂肪除外
	                    
	                    boolean canUsePriorityFoodToSpecialNutrient = false;
	                    
	                    //一般以蔬菜水果优先，但脂肪排除在外；另外当是纤维素时，以蔬菜水果豆类优先
	                    if (needPriorityFoodToSpecialNutrient){
	                        
	                        HashSet<String> nutrientsNeedNoPriorityFood = new HashSet<String>();
	                        nutrientsNeedNoPriorityFood.add(Constants.NutrientId_Lipid);//目前脂肪不该用蔬菜水果优先补充
	                        nutrientsNeedNoPriorityFood.add(Constants.NutrientId_Folate);
	                        canUsePriorityFoodToSpecialNutrient = ! nutrientsNeedNoPriorityFood.contains(nutrientNameToCal);
	                        if (canUsePriorityFoodToSpecialNutrient){
	                            if (Constants.NutrientId_Fiber.equalsIgnoreCase(nutrientNameToCal)){//当是纤维素时，以蔬菜水果豆类优先
	                                ArrayList<String> foodIdsOfPriority = da.getFoodIdsByFilters_withIncludeFoodClassAry(
	                                		new String[]{Constants.FoodClassify_shuiguo,Constants.FoodClassify_gandoulei},null,
	                                		new String[]{Constants.FoodClassify_shucai},foodIdsNotReachUpperLimit,null
	                                		);
	                                if (foodIdsOfPriority!=null && foodIdsOfPriority.size() >0){
	                                    int idx = 0;
	                                    if (foodIdsOfPriority.size()>1){
	                                    	idx = Tool.getRandObj().nextInt(foodIdsOfPriority.size());
	                                    }
	                                    String foodId = foodIdsOfPriority.get(idx);
	                                    foodToSupplyOneNutrient = preChooseFoodInfoDict.get(foodId);
	                                    assert(foodToSupplyOneNutrient!=null);
	                                    foundFoodWay = "priorityFoodForFiber, "+foodIdsOfPriority.size()+" "+idx+".";
	                                    doneUsePriorityFoodToSpecialNutrient= true;
	                                }
	                            }else{//一般以蔬菜水果优先补充普通营养素,脂肪已排除在外
	                            	ArrayList<String> foodIdsOfShucaiShuiguo = da.getFoodIdsByFilters_withIncludeFoodClassAry(
	                            			new String[]{Constants.FoodClassify_shuiguo},null,new String[]{Constants.FoodClassify_shucai},foodIdsNotReachUpperLimit,null
	                            			);
	                                if (foodIdsOfShucaiShuiguo!=null && foodIdsOfShucaiShuiguo.size() >0){
	                                    int idx = 0;
	                                    if (foodIdsOfShucaiShuiguo.size()>1){
	                                    	idx = Tool.getRandObj().nextInt(foodIdsOfShucaiShuiguo.size());
	                                    }
	                                    String foodId = foodIdsOfShucaiShuiguo.get(idx);
	                                    foodToSupplyOneNutrient = preChooseFoodInfoDict.get(foodId);
	                                    assert(foodToSupplyOneNutrient!=null);
	                                    foundFoodWay = "priorityShucaiShuiguo, "+foodIdsOfShucaiShuiguo.size()+" "+idx+".";
	                                    doneUsePriorityFoodToSpecialNutrient= true;
	                                }
	                            }
	                        }//if (isGoodToFirstUseShucaiShuiguiToSupply)
	                    }//if (needFirstUseShucaiShuiguiToSupply)
	                }//if (!doneUsePriorityFoodToSpecialNutrient)

	                if ( ! doneUsePriorityFoodToSpecialNutrient ){
	                    //前面使用优先食物来补的条件不具备
	                    if (alreadyChoosedFoodHavePriority){
	                        //这种情况下简单点，随机选
	                        int idx = Tool.getRandObj().nextInt(foodIdsNotReachUpperLimit.length);
	                        String foodId = foodIdsNotReachUpperLimit[idx];
	                        foodToSupplyOneNutrient = preChooseFoodInfoDict.get(foodId);
	                        foundFoodWay = "m foods, 1stChooseAlreadyFood, random get, "+foodIdsNotReachUpperLimit.length+" "+idx+".";
	                    }else{// if (alreadyChoosedFoodHavePriority)
	                        //先看看是否存在某种营养素已经超量
	                        ArrayList<String> exceedDRINutrients = nutrientNameAryToUpperLimit;
	                        if (exceedDRINutrients.size() == 0){//目前不存在任何一种营养素的量已经超过DRI的情况，可以任取一种富含食物
	                        	int idx = Tool.getRandObj().nextInt(foodIdsNotReachUpperLimit.length);
	                            String foodId = foodIdsNotReachUpperLimit[idx];
	                            foodToSupplyOneNutrient = preChooseFoodInfoDict.get(foodId);
	                            foundFoodWay = "m foods, no exceed, random get, "+foodIdsNotReachUpperLimit.length+" "+idx+".";
	                        }else {//exceedDRINutrients.count > 0 //存在有多种营养素超量，得选一种合适的富含食物
	                            /*
	                             取到 这种食物导致的dest营养素的增长比例 = 增加单位量这种食物导致的dest营养素的增量 / DRI_Ofdest营养素
	                             取到 这种食物导致的营养素A的超量比例 = 增加单位量这种食物导致的营养素A的增量 / (营养素A的上限 - DRI_Of营养素A)
	                             计算 这种食物针对目标营养素补充导致的营养素A的超量指数 = 这种食物导致的营养素A的超量比例 / 这种食物导致的dest营养素的增长比例
	                             找出 这种食物针对目标营养素补充导致的营养素A的超量指数 的最大值
	                             再找出 最大值中的最小值，取最小值对应的食物。
	                             这些计算值目前可以预算，如果效率很低，可以考虑预算而提高效率 TODO
	                             */
	                            double dMinOfMaxAddCauseExceedRateForFoods = 0;
	                            int foodIdx_MinAddCauseExceedRate = -1;
	                            ArrayList<Double> valAry_MaxAddCauseExceedRateForFood = new ArrayList<Double>();
	                            ArrayList<Integer> foodIdxAry_MinOfMaxAddCauseExceedRateForFood = new ArrayList<Integer>();
	                            for(int i=0; i<foodIdsNotReachUpperLimit.length; i++){
	                                String foodId = foodIdsNotReachUpperLimit[i];
//	                                NSDictionary *foodInfoToSupplyOneNutrient = [preChooseFoodInfoDict.get(foodId];
	                                //                        String foodId = [foodInfoToSupplyOneNutrient.get(COLUMN_NAME_NDB_No];
	                                //                        assert(foodId!=null);
	                                HashMap<String, Double> foodCauseNutrientsExceedRateDict = foodsCauseNutrientsExceedRateDict.get(foodId);
	                                HashMap<String, Double> foodCauseNutrientsAddRateDict = foodsCauseNutrientsAddRateDict.get(foodId);
	                                Double nmFoodCauseDestNutrientAddRate = foodCauseNutrientsAddRateDict.get(nutrientNameToCal);
	                                double dMaxAddCauseExceedRateForOneFood = 0;
	                                if (nmFoodCauseDestNutrientAddRate != null){//此种食物含目标营养素
	                                    for(int j=0; j<exceedDRINutrients.size(); j++){
	                                        String exceedDRINutrient = exceedDRINutrients.get(j);
	                                        Double nmFoodCauseNutrientExceedRate = foodCauseNutrientsExceedRateDict.get(exceedDRINutrient);
	                                        if(nmFoodCauseNutrientExceedRate != null){//当前营养素存在上限。不存在上限时认为下面的计算值为0，由于要求max，从而不必再继续计算当前营养素。
	                                            assert(nmFoodCauseNutrientExceedRate.doubleValue()!=0);
	                                            double dFoodAddCauseExceedRate = nmFoodCauseNutrientExceedRate.doubleValue() / nmFoodCauseDestNutrientAddRate.doubleValue();
	                                            if (dMaxAddCauseExceedRateForOneFood < dFoodAddCauseExceedRate){
	                                                dMaxAddCauseExceedRateForOneFood = dFoodAddCauseExceedRate;
	                                            }
	                                        }
	                                    }//for j
	                                }
	                                valAry_MaxAddCauseExceedRateForFood.add(Double.valueOf(dMaxAddCauseExceedRateForOneFood));
	                                if (i == 0){
	                                    dMinOfMaxAddCauseExceedRateForFoods = dMaxAddCauseExceedRateForOneFood;
	                                    foodIdx_MinAddCauseExceedRate = i;
	                                }else{
	                                    if (dMinOfMaxAddCauseExceedRateForFoods < dMaxAddCauseExceedRateForOneFood){
	                                        dMinOfMaxAddCauseExceedRateForFoods = dMaxAddCauseExceedRateForOneFood;
	                                        foodIdx_MinAddCauseExceedRate = i;
	                                    }
	                                }
	                            }//for i
	                            //最小值对应的食物不排除有多个的情况。把这些食物找出来
	                            for(int i=0; i<valAry_MaxAddCauseExceedRateForFood.size(); i++){
	                                Double nmMaxAddCauseExceedRateForOneFood = valAry_MaxAddCauseExceedRateForFood.get(i);
	                                if (dMinOfMaxAddCauseExceedRateForFoods == nmMaxAddCauseExceedRateForOneFood.doubleValue()){
	                                    foodIdxAry_MinOfMaxAddCauseExceedRateForFood.add(Integer.valueOf(i));
	                                }
	                            }
	                            assert(foodIdxAry_MinOfMaxAddCauseExceedRateForFood.size() > 0);
	                            if (foodIdxAry_MinOfMaxAddCauseExceedRateForFood.size() == 1){
	                            	Integer nmFoodIdx = foodIdxAry_MinOfMaxAddCauseExceedRateForFood.get(0);
	                                String foodId = foodIdsNotReachUpperLimit[nmFoodIdx.intValue()];
	                                foodToSupplyOneNutrient = preChooseFoodInfoDict.get(foodId);
	                                //                        foodToSupplyOneNutrient = [foodsToSupplyOneNutrient objectAtIndex:[nmFoodIdx.intValue()];
	                                foundFoodWay = "m foods, have exceed, min 1";
	                            }else{
	                            	int idx = Tool.getRandObj().nextInt(foodIdxAry_MinOfMaxAddCauseExceedRateForFood.size());
	                                Integer nmFoodIdx = foodIdxAry_MinOfMaxAddCauseExceedRateForFood.get(idx);
	                                String foodId = foodIdsNotReachUpperLimit[nmFoodIdx.intValue()];
	                                foodToSupplyOneNutrient = preChooseFoodInfoDict.get(foodId);
	                                //                        foodToSupplyOneNutrient = [foodsToSupplyOneNutrient objectAtIndex:[nmFoodIdx.intValue()];
	                                foundFoodWay = "m foods, have exceed, min m, random get  "+foodIdxAry_MinOfMaxAddCauseExceedRateForFood.size()+" "+idx+".";
	                            }
	                        }//else exceedDRINutrients.count > 0 //存在有多种营养素超量，得选一种合适的富含食物
	                    }//not if (alreadyChoosedFoodHavePriority)
	                }//if ( ! doneUsePriorityFoodToSpecialNutrient )
	            }//foodIdsNotReachUpperLimit.count > 1
	        }//else foodsToSupplyOneNutrient.count > 1 //富含食物超过一种时，需要选一种合适的
	        //在上面的为某种营养素找一种食物的计算过程中，当有多种食物可选时，暂且不考虑食物的上限限制
	        assert(foodToSupplyOneNutrient!=null);

	        //取到一个food，来计算补这种营养素，以及顺便补其他营养素
	        String foodIdToSupply = (String)foodToSupplyOneNutrient.get(Constants.COLUMN_NAME_NDB_No);
	        
	        Double nmNutrientContentOfFood = (Double)foodToSupplyOneNutrient.get(nutrientNameToCal);
	        assert(nmNutrientContentOfFood.doubleValue()>0.0);//确认选出的这个食物含这种营养素
	        double dFoodIncreaseUnit = defFoodIncreaseUnit;
	        if (needUseDefinedIncrementUnit){
	            Double nmFoodIncrementUnit = (Double)foodToSupplyOneNutrient.get(Constants.COLUMN_NAME_increment_unit);
	            assert(nmFoodIncrementUnit!=null);
	            dFoodIncreaseUnit = nmFoodIncrementUnit.doubleValue();
	        }
	        double foodAlreadyAmount = Tool.getDoubleFromDictionaryItem_withDictionary(foodSupplyAmountDict,foodIdToSupply);
	        if (foodAlreadyAmount == 0){
	            if(needUseFirstRecommendWhenSmallIncrementLogic && (givenFoodAmountDict==null || givenFoodAmountDict.size() == 0) ){
	            	Double nmFood_first_recommend = (Double)foodToSupplyOneNutrient.get(Constants.COLUMN_NAME_first_recommend);
	                assert(nmFood_first_recommend!=null);
	                dFoodIncreaseUnit = nmFood_first_recommend.doubleValue();
	            }else{
	            	Double nmFood_Lower_Limit = (Double)foodToSupplyOneNutrient.get(Constants.COLUMN_NAME_Lower_Limit);
	                assert(nmFood_Lower_Limit!=null);//这里还不能保证食物的量不低于lower limit，因为后面还有减量算法
	                dFoodIncreaseUnit = nmFood_Lower_Limit.doubleValue();
	            }
	        }
	        
	        //这个食物的各营养的量加到supply中
	        oneFoodSupplyNutrients(foodToSupplyOneNutrient,dFoodIncreaseUnit,nutrientSupplyDict,null,null);
	    
	        Tool.addDoubleToDictionaryItem(dFoodIncreaseUnit,recommendFoodAmountDict,foodIdToSupply);//推荐量累加
	        Tool.addDoubleToDictionaryItem(dFoodIncreaseUnit,foodSupplyAmountDict,foodIdToSupply);//供给量累加
	        Double nmAmountOfCurrentRecFood = recommendFoodAmountDict.get(foodIdToSupply);
	        Double nmUpperLimitOfCurrentRecFood = (Double)foodToSupplyOneNutrient.get(Constants.COLUMN_NAME_Upper_Limit);
	        double dCurrentToUpperLimit = nmUpperLimitOfCurrentRecFood.doubleValue()- nmAmountOfCurrentRecFood.doubleValue();
	        if (dCurrentToUpperLimit < Constants.Config_nearZero){
	            alreadyReachUpperLimitFoodIds.add(foodIdToSupply);
	        }
	        Double nmNormalLimitOfCurrentRecFood = (Double)foodToSupplyOneNutrient.get(Constants.COLUMN_NAME_normal_value);
	        double dCurrentToNormalLimit = nmNormalLimitOfCurrentRecFood.doubleValue()- nmAmountOfCurrentRecFood.doubleValue();
	        if (dCurrentToNormalLimit < Constants.Config_nearZero){
	            alreadyReachNormalLimitFoodIds.add(foodIdToSupply);
	        }
	    
	        ArrayList<Object> foodSupplyNutrientSeq = new ArrayList<Object>();
	        foodSupplyNutrientSeq.add(nutrientNameToCal);
	        foodSupplyNutrientSeq.add(maxNutrientLackRatio);;
	        foodSupplyNutrientSeq.add(foodToSupplyOneNutrient.get(Constants.COLUMN_NAME_CnCaption));
	        foodSupplyNutrientSeq.add(foodIdToSupply);
	        foodSupplyNutrientSeq.add(dFoodIncreaseUnit);
	        foodSupplyNutrientSeq.add(foodToSupplyOneNutrient.get("Shrt_Desc"));
	        foodSupplyNutrientSeq.add(foundFoodWay);
	        foodSupplyNutrientSeqs.add(foodSupplyNutrientSeq);
	        logMsg = "supply food:"+StringUtils.join(foodSupplyNutrientSeq," , ");
	        Log.d(LogTag, logMsg);
	        calculationLog = new ArrayList<Object>();
	        calculationLog.add("supply food:");
	        calculationLog.addAll(foodSupplyNutrientSeq);
	        calculationLogs.add(calculationLog);
	        
	    }//while (nutrientNameAryToCal.count > 0)
	    
	    Iterator<Map.Entry<String, Double>> iter = recommendFoodAmountDict.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry<String, Double> entry =  iter.next();
			String key = entry.getKey();
			Double nmRecAmount = entry.getValue();
			assert(nmRecAmount.doubleValue()>0);
		}
	    
		Log.d(LogTag, "recommendFoodForEnoughNuitrition foodSupplyNutrientSeqs=\n"+foodSupplyNutrientSeqs);
		Log.d(LogTag, "recommendFoodForEnoughNuitrition nutrientSupplyDict=\n"+nutrientSupplyDict+", recommendFoodAmountDict=\n"+recommendFoodAmountDict);
	    
	    HashMap<String, Object> retDict = new HashMap<String, Object>();
	    retDict.put(Constants.Key_DRI, DRIsDict);//nutrient name as key, also column name
	    retDict.put(Constants.Key_DRIUL, DRIULsDict);
	    retDict.put("nutrientInitialSupplyDict", nutrientInitialSupplyDict);
	    retDict.put(Constants.Key_nutrientSupplyDict, nutrientSupplyDict);
	    retDict.put("foodSupplyAmountDict", foodSupplyAmountDict);
	    retDict.put(Constants.Key_recommendFoodAmountDict, recommendFoodAmountDict);
	    
	    retDict.put(Constants.Key_preChooseFoodInfoDict, preChooseFoodInfoDict);
	    retDict.put(Constants.Key_preChooseRichFoodInfoAryDict, preChooseRichFoodInfoAryDict);
	    retDict.put("getFoodsLogs", getFoodsLogs);
	    
	    retDict.put(Constants.Key_originalNutrientNameAryToCal, originalNutrientNameAryToCal);
	    
	    retDict.put(Constants.Key_optionsDict, options);
	    retDict.put("foodSupplyNutrientSeqs", foodSupplyNutrientSeqs);
	    retDict.put("calculationLogs", calculationLogs);
	    
	    if (givenFoodAmountDict != null && givenFoodAmountDict.size()>0){
	    	retDict.put(Constants.Key_TakenFoodAmount, givenFoodAmountDict);
	    	retDict.put(Constants.Key_TakenFoodAttr, takenFoodAttrDict);
	    }
	    
	    reduceFoodsToNotExceed_ecommendFoodBySmallIncrement(retDict);
	    
	    return retDict;
	}
	
	
	/*
	减量算法的主要逻辑是
	    找出超过DRI的上限的那些营养素。后来也包括超过DRI的营养素，不过优先级靠后。
	    对每个这样的营养素，尝试对其富含的那些食物的每个食物进行计算，
	        计算其能否被减少，最多能减多少
	        目前的策略是一次减到底
	        有可以减的食物，则减去计算出的量，再循环，全部重新计算。直到没有一个食物能够减量，此时计算结束。
	 
	 */
	void reduceFoodsToNotExceed_ecommendFoodBySmallIncrement(HashMap<String, Object> recmdDict)
	{
	    HashMap<String, Double> DRIsDict = (HashMap<String, Double>)recmdDict.get(Constants.Key_DRI);//nutrient name as key, also column name
	    HashMap<String, Double> DRIULsDict = (HashMap<String, Double>)recmdDict.get(Constants.Key_DRIUL);
	    String[] originalNutrientNameAryToCal = (String[])recmdDict.get(Constants.Key_originalNutrientNameAryToCal);
//	    NSSet *originalNutrientNameSetToCal = [NSSet setWithArray:originalNutrientNameAryToCal];
	    
	    HashMap<String, Double> nutrientSupplyDict = (HashMap<String, Double>)recmdDict.get(Constants.Key_nutrientSupplyDict);//nutrient name as key, also column name
	    //    NSDictionary *nutrientInitialSupplyDict = recmdDict.get(@"nutrientInitialSupplyDict"];
	    HashMap<String, Double> foodSupplyAmountDict = (HashMap<String, Double>)recmdDict.get("foodSupplyAmountDict");
	    HashMap<String, Double> recommendFoodAmountDict = (HashMap<String, Double>)recmdDict.get(Constants.Key_recommendFoodAmountDict);//food NO as key
	    //    NSDictionary *recommendFoodAttrDict = recmdDict.get(@"FoodAttr"];//food NO as key
//	    NSDictionary *preChooseFoodInfoDict = recmdDict.get(Key_preChooseFoodInfoDict];
	    HashMap<String, ArrayList<HashMap<String, Object>>> preChooseRichFoodInfoAryDict = (HashMap<String, ArrayList<HashMap<String, Object>>>)recmdDict.get(Constants.Key_preChooseRichFoodInfoAryDict);
//	    NSArray *getFoodsLogs = recmdDict.get(@"getFoodsLogs"];
	    
	    //    NSArray *userInfos = recmdDict.get(@"UserInfo"];
//	    NSDictionary *userInfo = recmdDict.get(Key_userInfo];
	    HashMap<String, Object> options = (HashMap<String, Object>)recmdDict.get(Constants.Key_optionsDict);
	    //    NSDictionary *params = recmdDict.get(@"paramsDict"];
//	    NSArray *otherInfos = recmdDict.get(@"OtherInfo"];
	    
	    ArrayList<ArrayList<Object>> foodSupplyNutrientSeqs = (ArrayList<ArrayList<Object>>)recmdDict.get("foodSupplyNutrientSeqs");//2D array
	    ArrayList<ArrayList<Object>> calculationLogs = (ArrayList<ArrayList<Object>>)recmdDict.get("calculationLogs");//2D array
	    
//	    NSDictionary *takenFoodAmountDict = recmdDict.get(Key_TakenFoodAmount];//food NO as key
//	    NSDictionary *takenFoodAttrDict = recmdDict.get(Key_TakenFoodAttr];//food NO as key
	    
//	    boolean needLimitNutrients = true;
//	    boolean needUseNormalLimitWhenSmallIncrementLogic = Config_needUseNormalLimitWhenSmallIncrementLogic;
//	    boolean needUseFirstRecommendWhenSmallIncrementLogic = Config_needUseFirstRecommendWhenSmallIncrementLogic;
	    boolean needFirstSpecialForShucaiShuiguo = Constants.Config_needFirstSpecialForShucaiShuiguo;
//	    boolean needSpecialForFirstBatchFoods = Config_needSpecialForFirstBatchFoods;
//	    boolean alreadyChoosedFoodHavePriority = Config_alreadyChoosedFoodHavePriority;
//	    boolean needPriorityFoodToSpecialNutrient = Config_needPriorityFoodToSpecialNutrient;
	    
	    if(options != null){
//	        Double nmFlag_needLimitNutrients = [options.get(LZSettingKey_needLimitNutrients];
//	        if (nmFlag_needLimitNutrients != null)
//	            needLimitNutrients = [nmFlag_needLimitNutrients boolValue];
//	        
//	        Double nmFlag_needUseNormalLimitWhenSmallIncrementLogic = [options.get(LZSettingKey_needUseNormalLimitWhenSmallIncrementLogic];
//	        if (nmFlag_needUseNormalLimitWhenSmallIncrementLogic != null)
//	            needUseNormalLimitWhenSmallIncrementLogic = [nmFlag_needUseNormalLimitWhenSmallIncrementLogic boolValue];
//	        
//	        Double nmFlag_needUseFirstRecommendWhenSmallIncrementLogic = [options.get(LZSettingKey_needUseFirstRecommendWhenSmallIncrementLogic];
//	        if (nmFlag_needUseFirstRecommendWhenSmallIncrementLogic != null)
//	            needUseFirstRecommendWhenSmallIncrementLogic = [nmFlag_needUseFirstRecommendWhenSmallIncrementLogic boolValue];

	        Boolean nmFlag_needFirstSpecialForShucaiShuiguo = (Boolean)options.get(Constants.LZSettingKey_needFirstSpecialForShucaiShuiguo);
	        if (nmFlag_needFirstSpecialForShucaiShuiguo != null)
	            needFirstSpecialForShucaiShuiguo = nmFlag_needFirstSpecialForShucaiShuiguo.booleanValue();

//	        Double nmFlag_needSpecialForFirstBatchFoods = [options.get(LZSettingKey_needSpecialForFirstBatchFoods];
//	        if (nmFlag_needSpecialForFirstBatchFoods != null)
//	            needSpecialForFirstBatchFoods = [nmFlag_needSpecialForFirstBatchFoods boolValue];
//	        
//	        Double nmFlag_alreadyChoosedFoodHavePriority = [options.get(LZSettingKey_alreadyChoosedFoodHavePriority];
//	        if (nmFlag_alreadyChoosedFoodHavePriority != null)
//	            alreadyChoosedFoodHavePriority = [nmFlag_alreadyChoosedFoodHavePriority boolValue];
//	        
//	        Double nmFlag_needPriorityFoodToSpecialNutrient = [options.get(LZSettingKey_needPriorityFoodToSpecialNutrient];
//	        if (nmFlag_needPriorityFoodToSpecialNutrient != null)
//	            needPriorityFoodToSpecialNutrient = [nmFlag_needPriorityFoodToSpecialNutrient boolValue];
	        
	    }

	    
	    HashMap<String, Double> recommendFoodAmountDictOld = new HashMap<String, Double>();
	    recommendFoodAmountDictOld.putAll(recommendFoodAmountDict);
	    HashMap<String, Double> foodSupplyAmountDictOld = new HashMap<String, Double>();
	    foodSupplyAmountDictOld.putAll(foodSupplyAmountDict);
	    HashMap<String, Double> nutrientSupplyDictOld = new HashMap<String, Double>();
	    nutrientSupplyDictOld.putAll(nutrientSupplyDict);
	    recmdDict.put("recommendFoodAmountDictOld", recommendFoodAmountDictOld);
	    recmdDict.put("foodSupplyAmountDictOld", foodSupplyAmountDictOld);
	    recmdDict.put("nutrientSupplyDictOld", nutrientSupplyDictOld);
	    
	    String logMsg;
	    ArrayList<Object> calculationLog;
	    boolean haveReducedFood;
	    while(true){
	        haveReducedFood = false;
	        
	        ArrayList<HashMap<String, Object>> exceedDRIrateInfoAry = new ArrayList<HashMap<String, Object>>(originalNutrientNameAryToCal.length);
	        ArrayList<HashMap<String, Object>> exceedULrateInfoAry = new ArrayList<HashMap<String, Object>>(originalNutrientNameAryToCal.length);
	        //找出超过UL和DRI的营养素集合。注意只在要计算的那些营养素找，这里作这样一个限制，是对应着只管要计算的那些营养素的思想。
	        for(int i=0; i<originalNutrientNameAryToCal.length; i++){
	            String nutrient = originalNutrientNameAryToCal[i];
	            Double nmSupply = nutrientSupplyDict.get(nutrient);
	            Double nmDRI = DRIsDict.get(nutrient);
	            Double nmUL = DRIULsDict.get(nutrient);
	            assert(nmSupply!=null);
	            assert(nmDRI!=null);
	            assert(nmUL!=null);
	            if (nmUL.doubleValue()>0 && nmSupply.doubleValue()>nmUL.doubleValue()){
	                double rateSupplyVsUL = nmSupply.doubleValue() / nmUL.doubleValue();
	                HashMap<String, Object> rateInfo = new HashMap<String, Object>();
	                rateInfo.put("rate", Double.valueOf(rateSupplyVsUL));
	                rateInfo.put("nutrient", nutrient);
	                exceedULrateInfoAry.add(rateInfo);
	            }else if (nmSupply.doubleValue()>nmDRI.doubleValue()){
	                if ( needFirstSpecialForShucaiShuiguo && Constants.NutrientId_VC.equalsIgnoreCase(nutrient)){
	                    //此时对于 VC 特殊处理，因为这个flag是特意多补蔬菜水果，而蔬菜水果主要与VC相关。VC如果只超过DRI就不用减食物了，免得特意加上的蔬菜水果又被减掉。
	                }else{
	                    double rateSupplyVsDRI = nmSupply.doubleValue() / nmDRI.doubleValue();
	                    HashMap<String, Object> rateInfo = new HashMap<String, Object>();
	                    rateInfo.put("rate", Double.valueOf(rateSupplyVsDRI));
	                    rateInfo.put("nutrient", nutrient);
	                    exceedDRIrateInfoAry.add(rateInfo);
	                }
	            }
	        }//for
	        
	        Comparator<HashMap<String, Object>> compareBlockVar = new Comparator<HashMap<String, Object>>(){
	        	   public int compare(HashMap<String, Object> o1, HashMap<String, Object> o2) {
	        		   HashMap<String, Object> rateInfo1 = (HashMap<String, Object>)o1;
	        		   HashMap<String, Object> rateInfo2 = (HashMap<String, Object>)o2;
	        		   Double nmRate1 = (Double)rateInfo1.get("rate");
	        		   Double nmRate2 = (Double)rateInfo2.get("rate");
	        		   return nmRate1.compareTo(nmRate2);
	        		   //顺序是ascending
	        	   }
	        }; 
	        
	        if (exceedULrateInfoAry.size() > 0){
	            //有超过UL的营养素，升序排序降序处理
	        	Collections.sort(exceedULrateInfoAry, compareBlockVar);
	        }
	        if (exceedDRIrateInfoAry.size() > 0){
	            //有超过UL的营养素，升序排序降序处理
	        	Collections.sort(exceedDRIrateInfoAry, compareBlockVar);
	        }
	        
	        while (exceedULrateInfoAry.size() > 0 || exceedDRIrateInfoAry.size() > 0){
	            //对每个超过UL的营养素,尝试着减食物的量,从超得最多的来处理
	        	String nutrientExceedType = null;
	        	String exceedNutrient = null;
	            Double nmRate = null;
	            if (exceedULrateInfoAry.size() > 0){
	            	HashMap<String, Object> exceedNutrientInfo = exceedULrateInfoAry.get(exceedULrateInfoAry.size()-1);
	            	exceedULrateInfoAry.remove(exceedULrateInfoAry.size()-1);
	                nutrientExceedType = "exceedUL";
	                exceedNutrient = (String)exceedNutrientInfo.get("nutrient");
	                nmRate = (Double)exceedNutrientInfo.get("rate");
	            }else if (exceedDRIrateInfoAry.size() > 0){
	            	HashMap<String, Object> exceedNutrientInfo = exceedDRIrateInfoAry.get(exceedDRIrateInfoAry.size()-1);
	            	exceedDRIrateInfoAry.remove(exceedDRIrateInfoAry.size()-1);
	                nutrientExceedType = "exceedDRI";
	                exceedNutrient = (String)exceedNutrientInfo.get("nutrient");
	                nmRate = (Double)exceedNutrientInfo.get("rate");
	            }
	            assert(exceedNutrient!=null);
	            String nutrient = exceedNutrient;

	            ArrayList<HashMap<String, Object>> richFoodInfoAry = preChooseRichFoodInfoAryDict.get(nutrient);
	            assert(richFoodInfoAry!=null && richFoodInfoAry.size()>0);
	            ArrayList<Integer> idxAry = new ArrayList<Integer>(richFoodInfoAry.size());
	            for(int i=0; i<richFoodInfoAry.size(); i++){
	            	idxAry.add(Integer.valueOf(i));
	            }//for
	            //对当前的超过UL或DRI的营养素的每个富含食物，进行尝试减量。 这里是随机找出某种富含食物来减。至于如何找到最合适的食物来减，目前没想到合适的规则。
	            while (idxAry.size()>0) {
	                int chooseIdx = -1;
	                if (idxAry.size()==1){
	                    Integer nmIdx = idxAry.get(0);
	                    chooseIdx = nmIdx.intValue();
	                    idxAry.remove(0);
	                }else{
	                	int idx1 = Tool.getRandObj().nextInt(idxAry.size());
	                    Integer nmIdx2 = idxAry.get(idx1);
	                    chooseIdx = nmIdx2.intValue();
	                    idxAry.remove(idx1);
	                }
	                HashMap<String, Object> foodInfo = richFoodInfoAry.get(chooseIdx);
	                String foodId = (String)foodInfo.get(Constants.COLUMN_NAME_NDB_No);
	                Double nmFoodLowerLimit = (Double)foodInfo.get(Constants.COLUMN_NAME_Lower_Limit);
	                assert(nmFoodLowerLimit != null);
	                Double nmFoodAmount = recommendFoodAmountDict.get(foodId);
	                if (nmFoodAmount!=null && nmFoodAmount.doubleValue() > Constants.Config_nearZero){//这种食物的使用量大于0，才有可能减它
	                    double maxDeltaFoodAmount = 0;
	                    //对于当前的食物，对每个营养素算最多能减的数量，这为各个值中的最小值
	                    for(int j=0; j<originalNutrientNameAryToCal.length; j++){
	                        String nutrientL1 = originalNutrientNameAryToCal[j];
	                        Double nmSupply = nutrientSupplyDict.get(nutrientL1);
	                        Double nmDRI = DRIsDict.get(nutrientL1);
	                        
	                        Double nmFoodStandardSupplyNutrient = (Double)foodInfo.get(nutrientL1);
	                        if (nmFoodStandardSupplyNutrient.doubleValue()>0){//当前food含有当前这种营养素
	                            if (nmSupply.doubleValue()-nmDRI.doubleValue()<=Constants.Config_nearZero){
	                                //此时这种营养素已经为DRI值，不能再往下减这种食物了
	                                maxDeltaFoodAmount = 0;
	                                break;
	                            }else{
	                                double deltaFoodAmount = (nmSupply.doubleValue()-nmDRI.doubleValue())*100.0/nmFoodStandardSupplyNutrient.doubleValue();
	                                if (maxDeltaFoodAmount == 0)
	                                    maxDeltaFoodAmount = deltaFoodAmount;
	                                else if (maxDeltaFoodAmount > deltaFoodAmount)
	                                    maxDeltaFoodAmount = deltaFoodAmount;
	                            }
	                        }
	                    }//for j
	                    if (maxDeltaFoodAmount >= nmFoodAmount.doubleValue()){//这种食物能够减少的上限是它的使用量
	                        maxDeltaFoodAmount = nmFoodAmount.doubleValue();
	                    }else{//now maxDeltaFoodAmount < [nmFoodAmount.doubleValue()
	                        if(nmFoodAmount.doubleValue() - maxDeltaFoodAmount < Constants.Config_nearZero){// 可以认为 [nmFoodAmount.doubleValue() == maxDeltaFoodAmount
	                            maxDeltaFoodAmount = nmFoodAmount.doubleValue();
	                        }else if(nmFoodAmount.doubleValue() - maxDeltaFoodAmount < 1){
//	                            maxDeltaFoodAmount = [nmFoodAmount.doubleValue() - 1;//避免显示时四舍五入为0的情况。
	                            maxDeltaFoodAmount = nmFoodAmount.doubleValue() - nmFoodLowerLimit.doubleValue();
	                            if (maxDeltaFoodAmount < 0){//此时说明 [nmFoodAmount.doubleValue() < 1 ,但是这种情况应该不会发生(除去微小的误差情况)。因为最开始它>=1，之后减的话，要么彻底减掉，要么间距至少为1，这样保证减掉之后得到的值仍>=1
	                                maxDeltaFoodAmount = 0;
	                            }
	                        }else{//[nmFoodAmount.doubleValue() - maxDeltaFoodAmount >= 1
	                            if (nmFoodAmount.doubleValue() - maxDeltaFoodAmount < nmFoodLowerLimit.doubleValue()){
	                                maxDeltaFoodAmount = nmFoodAmount.doubleValue() - nmFoodLowerLimit.doubleValue();
	                            }
	                        }
	                    }
	                    if (maxDeltaFoodAmount < Constants.Config_nearZero){
	                        maxDeltaFoodAmount = 0;
	                    }
	                    if (maxDeltaFoodAmount > 0){//可以减少这种食物
	                        double reduceFoodAmount = -1 * maxDeltaFoodAmount;//这里暂且一减到底
	                        oneFoodSupplyNutrients(foodInfo,reduceFoodAmount,nutrientSupplyDict,null,null);//营养量累加
	                        Tool.addDoubleToDictionaryItem(reduceFoodAmount,recommendFoodAmountDict,foodId);//推荐量累加
	                        Tool.addDoubleToDictionaryItem(reduceFoodAmount,foodSupplyAmountDict,foodId);//供给量累加
	                        
	                        ArrayList<Object> foodSupplyNutrientSeq = new ArrayList<Object>();
	                        foodSupplyNutrientSeq.add(nutrient);
	                        foodSupplyNutrientSeq.add(nmRate);
	                        foodSupplyNutrientSeq.add(foodInfo.get(Constants.COLUMN_NAME_CnCaption));
	                        foodSupplyNutrientSeq.add(foodId);
	                        foodSupplyNutrientSeq.add(Double.valueOf(reduceFoodAmount));
	                        foodSupplyNutrientSeq.add(foodInfo.get("Shrt_Desc"));
	                        foodSupplyNutrientSeq.add(nutrientExceedType);
	                        foodSupplyNutrientSeqs.add(foodSupplyNutrientSeq);

	                        logMsg = "reduce food:"+StringUtils.join(foodSupplyNutrientSeq," , ");
	                        Log.d(LogTag, logMsg);

	                        calculationLog = new ArrayList<Object>();
	                        calculationLog.add("reduce food");
	                        calculationLog.addAll(foodSupplyNutrientSeq);
	                        calculationLogs.add(calculationLog);
	                        
	                        haveReducedFood = true;
	                        break;
	                    }//if (minReduceFoodAmount > 0)
	                }//if ([nmFoodAmount.doubleValue() > Config_nearZero)
	            }//while (idxAry.count>0)
	            if (haveReducedFood){
	                break;
	            }

	        }//while (exceedULrateInfoAry.count > 0 || exceedDRIrateInfoAry.count > 0)
	        if (!haveReducedFood){
	            break;//由于上面的计算是完全遍历，如果一个食物都没减量，说明确实是没有食物可以减量了，计算完成。
	        }
	    }//while true
	    
//	    Iterator<Map.Entry<String, Double>> iter = recommendFoodAmountDict.entrySet().iterator();
//		while (iter.hasNext()) {
//			Map.Entry<String, Double> entry =  iter.next();
//			String key = entry.getKey();
//			Double nmRecAmount = entry.getValue();
//			if(nmRecAmount.doubleValue() < Constants.Config_nearZero){
//				recommendFoodAmountDict.remove(key); //会导致异常，就是不能修改hash
//			}else{
//				assert(nmRecAmount.doubleValue() >= 1);
//			}
//		}
		String[] keys = recommendFoodAmountDict.keySet().toArray(new String[recommendFoodAmountDict.size()]); 
		for(int i=0; i<keys.length; i++){
			String key = keys[i];
			Double nmRecAmount = recommendFoodAmountDict.get(key);
			if(nmRecAmount.doubleValue() < Constants.Config_nearZero){
				recommendFoodAmountDict.remove(key);
			}else{
				assert(nmRecAmount.doubleValue() >= 1);
			}
		}
	}


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


}













