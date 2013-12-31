package com.lingzhimobile.nutritionfoodguide;

import java.util.*;

import android.content.Context;

public class NutritionTool {
	public static final double kFatFactor = 1.0/9; //means 1g fat contains 9Kcal energy
	public static final double kCarbFactor = 1.0/4; //means 1g carbohydrt contains 4Kcal energy
	
	public static HashMap<String,Double> getStandardDRIULForSex(int sex,int age,double weight,double height,int activityLevel){
		double PA;
	    double heightM = height/100.f;
	    int energyStandard;
	    int energyUL = -1;
	    int proteinUL = -1;
	    int carbohydrtUL;
	    int fatUL;
	    if (sex == 0)//male
	    {
	        if (age>=1 && age<3)
	        {
	            energyStandard = (int)(89*weight-100+20);
	        }
	        else if (age>=3 && age<9)
	        {
	            switch (activityLevel) {
	                case 0:
	                    PA = 1.0;
	                    break;
	                case 1:
	                    PA = 1.13;
	                    break;
	                case 2:
	                    PA = 1.26;
	                    break;
	                case 3:
	                    PA = 1.42;
	                    break;
	                default:
	                    PA = 1.0;
	                    break;
	            }
	            energyStandard = (int)(88.5 - 61.9*age +PA*(26.7 *weight +903*heightM)+20);
	        }
	        else if (age>=9 && age<19)
	        {
	            switch (activityLevel) {
	                case 0:
	                    PA = 1.0;
	                    break;
	                case 1:
	                    PA = 1.13;
	                    break;
	                case 2:
	                    PA = 1.26;
	                    break;
	                case 3:
	                    PA = 1.42;
	                    break;
	                default:
	                    PA = 1.0;
	                    break;
	            }
	            
	            energyStandard = (int)(88.5 - 61.9*age +PA*(26.7 *weight +903*heightM)+25);
	        }
	        else
	        {
	            switch (activityLevel) {
	                case 0:
	                    PA = 1.0;
	                    break;
	                case 1:
	                    PA = 1.11;
	                    break;
	                case 2:
	                    PA = 1.25;
	                    break;
	                case 3:
	                    PA = 1.48;
	                    break;
	                default:
	                    PA = 1.0;
	                    break;
	            }
	            
	            energyStandard = (int)(662 - 9.53*age +PA*(15.91 *weight +539.6*heightM));
	        }
	        
	    }
	    else//female
	    {
	        if (age>=1 && age<3)
	        {
	            energyStandard = (int)(89*weight-100+20);
	        }
	        else if (age>=3 && age<9)
	        {
	            switch (activityLevel) {
	                case 0:
	                    PA = 1.0;
	                    break;
	                case 1:
	                    PA = 1.16;
	                    break;
	                case 2:
	                    PA = 1.31;
	                    break;
	                case 3:
	                    PA = 1.56;
	                    break;
	                default:
	                    PA = 1.0;
	                    break;
	            }
	            
	            energyStandard = (int)(135.3 - 30.8*age +PA*(10 *weight +934*heightM)+20);
	        }
	        else if (age>=9 && age<19)
	        {
	            switch (activityLevel) {
	                case 0:
	                    PA = 1.0;
	                    break;
	                case 1:
	                    PA = 1.16;
	                    break;
	                case 2:
	                    PA = 1.31;
	                    break;
	                case 3:
	                    PA = 1.56;
	                    break;
	                default:
	                    PA = 1.0;
	                    break;
	            }
	            
	            energyStandard = (int)(135.3 - 30.8*age +PA*(10 *weight +934*heightM)+25);
	        }
	        else
	        {
	            switch (activityLevel) {
	                case 0:
	                    PA = 1.0;
	                    break;
	                case 1:
	                    PA = 1.12;
	                    break;
	                case 2:
	                    PA = 1.27;
	                    break;
	                case 3:
	                    PA = 1.45;
	                    break;
	                default:
	                    PA = 1.0;
	                    break;
	            }
	            
	            energyStandard = (int)(354 - 6.91*age +PA*(9.36 *weight +726*heightM));
	        }
	        
	        
	    }
	    carbohydrtUL = (int)(energyStandard*0.65*kCarbFactor+0.5);
	    
	    if (age>=1 && age<4)
	    {
	        fatUL = (int)(energyStandard*0.40*kFatFactor+0.5);
	    }
	    else
	    {
	        if(age >= 4 && age<19)
	        {
	            fatUL = (int)(energyStandard*0.35*kFatFactor+0.5);
	        }
	        else
	        {
	            fatUL = (int)(energyStandard*0.35*kFatFactor+0.5);
	        }
	    }
	    
	    HashMap<String,Double> hmRet = new HashMap<String,Double>();
	    hmRet.put(Constants.NutrientId_Energe, Double.valueOf(energyUL));
	    hmRet.put(Constants.NutrientId_Carbohydrt, Double.valueOf(carbohydrtUL));
	    hmRet.put(Constants.NutrientId_Lipid, Double.valueOf(fatUL));
	    hmRet.put(Constants.NutrientId_Protein, Double.valueOf(proteinUL));
	    return hmRet;

	}
	
	public static HashMap<String,Double> getStandardDRIForSex(int sex,int age,double weight,double height,int activityLevel){
	    double PA;
	    double heightM = height/100.f;
	    int energyStandard;
	    int carbohydrtStandard;
	    int fatStandard;
	    int proteinStandard;
	    if (sex == 0)//male
	    {
	        if (age>=1 && age<3)
	        {
	            energyStandard = (int)(89*weight-100+20);
	        }
	        else if (age>=3 && age<9)
	        {
	            switch (activityLevel) {
	                case 0:
	                    PA = 1.0;
	                    break;
	                case 1:
	                    PA = 1.13;
	                    break;
	                case 2:
	                    PA = 1.26;
	                    break;
	                case 3:
	                    PA = 1.42;
	                    break;
	                default:
	                    PA = 1.0;
	                    break;
	            }
	            energyStandard = (int)(88.5 - 61.9*age +PA*(26.7 *weight +903*heightM)+20);
	        }
	        else if (age>=9 && age<19)
	        {
	            switch (activityLevel) {
	                case 0:
	                    PA = 1.0;
	                    break;
	                case 1:
	                    PA = 1.13;
	                    break;
	                case 2:
	                    PA = 1.26;
	                    break;
	                case 3:
	                    PA = 1.42;
	                    break;
	                default:
	                    PA = 1.0;
	                    break;
	            }
	            
	            energyStandard = (int)(88.5 - 61.9*age +PA*(26.7 *weight +903*heightM)+25);
	        }
	        else
	        {
	            switch (activityLevel) {
	                case 0:
	                    PA = 1.0;
	                    break;
	                case 1:
	                    PA = 1.11;
	                    break;
	                case 2:
	                    PA = 1.25;
	                    break;
	                case 3:
	                    PA = 1.48;
	                    break;
	                default:
	                    PA = 1.0;
	                    break;
	            }
	            
	            energyStandard = (int)(662 - 9.53*age +PA*(15.91 *weight +539.6*heightM));
	        }
	        
	    }
	    else//female
	    {
	        if (age>=1 && age<3)
	        {
	            energyStandard = (int)(89*weight-100+20);
	        }
	        else if (age>=3 && age<9)
	        {
	            switch (activityLevel) {
	                case 0:
	                    PA = 1.0;
	                    break;
	                case 1:
	                    PA = 1.16;
	                    break;
	                case 2:
	                    PA = 1.31;
	                    break;
	                case 3:
	                    PA = 1.56;
	                    break;
	                default:
	                    PA = 1.0;
	                    break;
	            }
	            
	            energyStandard = (int)(135.3 - 30.8*age +PA*(10 *weight +934*heightM)+20);
	        }
	        else if (age>=9 && age<19)
	        {
	            switch (activityLevel) {
	                case 0:
	                    PA = 1.0;
	                    break;
	                case 1:
	                    PA = 1.16;
	                    break;
	                case 2:
	                    PA = 1.31;
	                    break;
	                case 3:
	                    PA = 1.56;
	                    break;
	                default:
	                    PA = 1.0;
	                    break;
	            }
	            
	            energyStandard = (int)(135.3 - 30.8*age +PA*(10 *weight +934*heightM)+25);
	        }
	        else
	        {
	            switch (activityLevel) {
	                case 0:
	                    PA = 1.0;
	                    break;
	                case 1:
	                    PA = 1.12;
	                    break;
	                case 2:
	                    PA = 1.27;
	                    break;
	                case 3:
	                    PA = 1.45;
	                    break;
	                default:
	                    PA = 1.0;
	                    break;
	            }
	            
	            energyStandard = (int)(354 - 6.91*age +PA*(9.36 *weight +726*heightM));
	        }
	        
	        
	    }
	    //self.energyStandardLabel.text = [NSString stringWithFormat:"%d kcal",energyStandard];
	    
	    carbohydrtStandard = (int)(energyStandard*0.45*kCarbFactor+0.5);//(int)(energyStandard*0.65*kCarbFactor+0.5);
	    
	    if (age>=1 && age<4)
	    {
	        fatStandard = 0;//[NSString stringWithFormat:"0 ~ %d", (int)(energyStandard*0.4*kFatFactor+0.5)];
	    }
	    else
	    {
	        if(age >= 4 && age<19)
	        {
	            fatStandard = (int)(energyStandard*0.25*kFatFactor+0.5);//, (int)(energyStandard*0.35*kFatFactor+0.5)];
	        }
	        else
	        {
	            fatStandard = (int)(energyStandard*0.2*kFatFactor+0.5);//, (int)(energyStandard*0.35*kFatFactor+0.5)];
	        }
	    }
	    
	    double proteinFactor;
	    
	    if (age>=1 && age<4)
	    {
	        proteinFactor = 1.05;
	    }
	    else if (age>=4 && age<14)
	    {
	        proteinFactor = 0.95;
	    }
	    else if (age>=14 && age<19)
	    {
	        proteinFactor =0.85;
	    }
	    else
	    {
	        proteinFactor = 0.8;
	    }
	    
	    proteinStandard =(int)( weight*proteinFactor+0.5);
	    
	    HashMap<String,Double> hmRet = new HashMap<String,Double>();
	    hmRet.put(Constants.NutrientId_Energe, Double.valueOf(energyStandard));
	    hmRet.put(Constants.NutrientId_Carbohydrt, Double.valueOf(carbohydrtStandard));
	    hmRet.put(Constants.NutrientId_Lipid, Double.valueOf(fatStandard));
	    hmRet.put(Constants.NutrientId_Protein, Double.valueOf(proteinStandard));
	    return hmRet;
	}
	
	
	
	
	public static String[] getCustomNutrients(HashMap<String, Object> options)
	{
	    boolean needLimitNutrients = Constants.Config_needLimitNutrients;
	    if (options != null){//options param has priority
	        Boolean bObj_needLimitNutrients = (Boolean)options.get(Constants.LZSettingKey_needLimitNutrients);
	        if (bObj_needLimitNutrients != null){
	            needLimitNutrients = bObj_needLimitNutrients.booleanValue();
	            return getCustomNutrients_withFlag_needLimitNutrients(needLimitNutrients);
	        }
	    }
	    //options param not have the flag, check other conditions
	    if (!Constants.KeyIsEnvironmentDebug){
	        //just use config value
	    }else{
//	        NSDictionary *flagsDict = [[NSUserDefaults standardUserDefaults]objectForKey:KeyDebugSettingsDict];
//	        if (flagsDict.count > 0){
//	            NSNumber *nmFlag_needLimitNutrients = [flagsDict objectForKey:LZSettingKey_needLimitNutrients];
//	            if (nmFlag_needLimitNutrients != nil)
//	                needLimitNutrients = [nmFlag_needLimitNutrients boolValue];
//	        }
	    }
	    return getCustomNutrients_withFlag_needLimitNutrients(needLimitNutrients);
	}
	
	
	
	public static String[] getCustomNutrients_withFlag_needLimitNutrients(boolean needLimitNutrients)
	{
		String[] limitedNutrientsCanBeCal = null;
	    if (needLimitNutrients){
	        limitedNutrientsCanBeCal = new String[]{
	                                    "Vit_A_RAE","Vit_C_(mg)","Vit_D_(µg)","Vit_E_(mg)",
	                                    "Riboflavin_(mg)","Vit_B6_(mg)","Folate_Tot_(µg)","Vit_B12_(µg)",
	                                    "Calcium_(mg)","Iron_(mg)","Magnesium_(mg)","Zinc_(mg)","Potassium_(mg)",
	                                    "Fiber_TD_(g)",
	                                    "Protein_(g)", //"Energ_Kcal",
	        							};
	    }else{
	//        limitedNutrientsCanBeCal = [NSArray arrayWithObjects:
	//                                    "Vit_A_RAE","Vit_C_(mg)","Vit_D_(µg)","Vit_E_(mg)","Vit_K_(µg)",
	//                                    "Thiamin_(mg)","Riboflavin_(mg)","Niacin_(mg)","Vit_B6_(mg)","Folate_Tot_(µg)",
	//                                    "Vit_B12_(µg)","Panto_Acid_mg)",
	//                                    "Calcium_(mg)","Copper_(mg)","Iron_(mg)","Magnesium_(mg)","Manganese_(mg)",
	//                                    "Phosphorus_(mg)","Selenium_(µg)","Zinc_(mg)","Potassium_(mg)",
	//                                    "Protein_(g)","Lipid_Tot_(g)",
	//                                    "Fiber_TD_(g)","Choline_Tot_ (mg)", nil];
	        limitedNutrientsCanBeCal = new String[]{
	                                    "Vit_A_RAE","Vit_C_(mg)","Vit_D_(µg)","Vit_E_(mg)","Vit_K_(µg)",
	                                    "Thiamin_(mg)","Riboflavin_(mg)","Niacin_(mg)","Vit_B6_(mg)","Folate_Tot_(µg)",
	                                    "Vit_B12_(µg)","Panto_Acid_mg)",
	                                    "Calcium_(mg)","Copper_(mg)","Iron_(mg)","Magnesium_(mg)","Manganese_(mg)",
	                                    "Phosphorus_(mg)","Selenium_(µg)","Zinc_(mg)","Potassium_(mg)",
	                                    "Protein_(g)",
	                                    "Fiber_TD_(g)","Choline_Tot_ (mg)"};
	    }
	    return limitedNutrientsCanBeCal;
	}
	
	/*
	 营养素的一个全集，应该与DRI表中的营养素集合相同。顺序不一样，这个顺序用于计算，是经过特定算法的经验调整。
	 */
	public static String[] getFullAndOrderedNutrients()
	{
		String[] nutrientNamesOrdered = new String[]{
	                                     "Vit_A_RAE","Vit_C_(mg)","Vit_D_(µg)","Vit_E_(mg)","Vit_K_(µg)",
	                                     "Thiamin_(mg)","Riboflavin_(mg)","Niacin_(mg)","Vit_B6_(mg)","Folate_Tot_(µg)",
	                                     "Vit_B12_(µg)","Panto_Acid_mg)",
	                                     "Calcium_(mg)","Copper_(mg)","Iron_(mg)","Magnesium_(mg)","Manganese_(mg)",
	                                     "Phosphorus_(mg)","Selenium_(µg)","Zinc_(mg)","Potassium_(mg)","Sodium_(mg)",
	                                     "Protein_(g)","Lipid_Tot_(g)","Energ_Kcal","Carbohydrt_(g)",
	                                     "Water_(g)","Fiber_TD_(g)","Choline_Tot_ (mg)","Cholestrl_(mg)"};
	    return nutrientNamesOrdered;
	}
	/*
	 营养素的全集，与DRI表中的营养素集合相同。并且顺序也与DRI表中的顺序相同。这样在显示时比对DRI表时比较有用。
	 */
	public static String[] getDRItableNutrientsWithSameOrder()
	{
	    String[] nutrientNames = new String[]{"Energ_Kcal","Carbohydrt_(g)","Lipid_Tot_(g)","Protein_(g)",
	         "Vit_A_RAE","Vit_C_(mg)","Vit_D_(µg)","Vit_E_(mg)","Vit_K_(µg)",
	         "Thiamin_(mg)","Riboflavin_(mg)","Niacin_(mg)","Vit_B6_(mg)","Folate_Tot_(µg)",
	         "Vit_B12_(µg)","Panto_Acid_mg)",
	         "Calcium_(mg)","Copper_(mg)","Iron_(mg)","Magnesium_(mg)","Manganese_(mg)",
	         "Phosphorus_(mg)","Selenium_(µg)","Zinc_(mg)","Potassium_(mg)","Sodium_(mg)",
	         "Water_(g)","Fiber_TD_(g)","Choline_Tot_ (mg)","Cholestrl_(mg)"};
	    return nutrientNames;
	}
	
	public static String[] getOnlyToShowNutrients()
	{
		String[] ary = new String[]{"Energ_Kcal"};
	    return ary;
	}
	
		
		
	public static HashMap<String, Double> getDRIsDictOfCurrentUser(Context ctx,HashMap<String, Object> options){
		HashMap<String, Object> userInfo = StoredConfigTool.getUserInfo(ctx);
		DataAccess da = DataAccess.getSingleton(ctx);
	    HashMap<String, Double> DRIsDict = da.getStandardDRIs_withUserInfo(userInfo,options);
	    return DRIsDict;
	}
	
	static HashMap<String, Integer> m_NutrientColorMapping = null;
	public static HashMap<String, Integer> getNutrientColorMapping(){
		if (m_NutrientColorMapping==null){
			m_NutrientColorMapping = new HashMap<String, Integer>();
			m_NutrientColorMapping.put("Vit_A_RAE", R.color.v3_nutrientVA);
			m_NutrientColorMapping.put("Vit_C_(mg)", R.color.v3_nutrientVC);
			m_NutrientColorMapping.put("Vit_D_(µg)", R.color.v3_nutrientVD);
			m_NutrientColorMapping.put("Vit_E_(mg)", R.color.v3_nutrientVE);
//			m_NutrientColorMapping.put("Thiamin_(mg)", R.color.nutrientVB1);
			m_NutrientColorMapping.put("Riboflavin_(mg)", R.color.v3_nutrientVB2);
//			m_NutrientColorMapping.put("Niacin_(mg)", R.color.nutrientVB3);
			m_NutrientColorMapping.put("Vit_B6_(mg)", R.color.v3_nutrientVB6);
			m_NutrientColorMapping.put("Folate_Tot_(µg)", R.color.v3_nutrientVB9);
			m_NutrientColorMapping.put("Vit_B12_(µg)", R.color.v3_nutrientVB12);
			m_NutrientColorMapping.put("Calcium_(mg)", R.color.v3_nutrientCalcium);
			m_NutrientColorMapping.put("Iron_(mg)", R.color.v3_nutrientIron);
			m_NutrientColorMapping.put("Magnesium_(mg)", R.color.v3_nutrientMagnesium);
			m_NutrientColorMapping.put("Zinc_(mg)", R.color.v3_nutrientZinc);
			m_NutrientColorMapping.put("Potassium_(mg)", R.color.v3_nutrientPotassium);
			m_NutrientColorMapping.put("Fiber_TD_(g)", R.color.v3_nutrientFiber);
			m_NutrientColorMapping.put("Protein_(g)", R.color.v3_nutrientProtein);
			m_NutrientColorMapping.put("Energ_Kcal", R.color.black);
		}
		return m_NutrientColorMapping;
	}
	
	
	
	

}
