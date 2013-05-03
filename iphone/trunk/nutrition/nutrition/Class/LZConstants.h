//
//  LZConstants.h
//  nutrition
//
//  Created by liu miao on 4/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#ifndef nutrition_LZConstants_h
#define nutrition_LZConstants_h
#define kFatFactor 1/9 //means 1g fat contains 9Kcal energy
#define kCarbFactor 1/4 //means 1g carbohydrt contains 4Kcal energy
#define LZUserSexKey @"LZUserSexKey" //int 0 means male 1 means female
#define LZUserAgeKey @"LZUserAgeKey" //int 
#define LZUserHeightKey @"LZUserHeightKey"//float cm
#define LZUserWeightKey @"LZUserWeightKey"//float kg
#define LZUserActivityLevelKey @"LZUserActivityLevelKey"//int 0 means Sedentary,1 means Low Active,2 means Active,3 means Very Active
#define LZUserDailyIntakeKey @"LZUserDailyIntakeKey" //a dictionary for user daily intake

#endif
