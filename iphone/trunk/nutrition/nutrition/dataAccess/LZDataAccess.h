//
//  LZDataAccess.h
//  tSql
//
//  Created by Yasofon on 13-2-4.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "LZDataAccess.h"


#define cDbFile    @"CustomDB.dat"


@interface LZDataAccess : NSObject{
    FMDatabase *dbfm;
}
+(LZDataAccess *)singleton;

//+ (NSString *)dbFilePath;

//- (id)initDBConnection;
- (id)init_withDBcon:(FMDatabase *)innerDBCon;
-(void)openDB_withFilePath: (NSString *)dbFilePath;
-(void)closeDB;



//-(NSDictionary*)getStandardDRIForSex:(int )sex age:(int)age weight:(float)weight height:(float)height activityLevel:(int )activityLevel;
//-(NSDictionary*)getStandardDRIs:(int)sex age:(int)age weight:(float)weight height:(float)height activityLevel:(int )activityLevel;
-(NSDictionary*)getStandardDRIs:(int)sex age:(int)age weight:(float)weight height:(float)height activityLevel:(int)activityLevel considerLoss:(BOOL)needConsiderLoss;
-(NSDictionary*)getStandardDRIULs:(int)sex age:(int)age weight:(float)weight height:(float)height activityLevel:(int)activityLevel considerLoss:(BOOL)needConsiderLoss;
-(NSDictionary*)getStandardDRIs_withUserInfo:(NSDictionary*)userInfo andOptions:(NSDictionary*)options;
-(NSDictionary*)getStandardDRIULs_withUserInfo:(NSDictionary*)userInfo andOptions:(NSDictionary*)options;



- (NSDictionary *)getDRIbyGender:(NSString*)gender andAge:(int)age ;
- (NSDictionary *)getDRIULbyGender:(NSString*)gender andAge:(int)age ;
//-(NSDictionary*)getAbstractPersonDRIs;
-(NSDictionary*)getAbstractPersonDRIsWithConsiderLoss : (BOOL)needConsiderLoss;
-(NSDictionary*)getAbstractPersonDRIULsWithConsiderLoss : (BOOL)needConsiderLoss;

-(NSDictionary*)getCustomRichFood_SetDict;

-(NSArray *)getRichFoodForNutrientAmount_withNutrient:(NSString *)nutrientAsColumnName andNutrientSupplyAmount:(double)nutrientSupplyAmount andTopN:(int)topN andIfNeedCustomDefinedFoods:(BOOL)ifNeedCustomDefinedFoods andUpperLimitType:(NSString*)upperLimitType;

-(NSArray *) getRichNutritionFood:(NSString *)nutrientAsColumnName andTopN:(int)topN andIfNeedCustomDefinedFoods:(BOOL) ifNeedCustomDefinedFoods;
-(NSArray *) getRichNutritionFoodForNutrient:(NSString *)nutrientName andNutrientAmount:(NSNumber*)nutrientAmount andIfNeedCustomDefinedFoods:(BOOL) ifNeedCustomDefinedFoods;
//-(NSArray *) getRichNutritionFood:(NSString *)nutrientAsColumnName andIncludeFoodClass:(NSString*)includeFoodClass andExcludeFoodClass:(NSString*)excludeFoodClass andTopN:(int)topN;
-(NSArray *) getRichNutritionFood:(NSString *)nutrientAsColumnName andIncludeFoodClass:(NSString*)includeFoodClass andExcludeFoodClass:(NSString*)excludeFoodClass andIncludeFoodIds:(NSArray*)includeFoodIds  andExcludeFoodIds:(NSArray*)excludeFoodIds andTopN:(int)topN andIfNeedCustomDefinedFoods:(BOOL) ifNeedCustomDefinedFoods;
//-(NSDictionary *) getOneRichNutritionFood:(NSString *)nutrientAsColumnName andIncludeFoodClass:(NSString*)includeFoodClass andExcludeFoodClass:(NSString*)excludeFoodClass andGetStrategy:(NSString*)getStrategy;
-(NSDictionary *) getOneRichNutritionFood:(NSString *)nutrientAsColumnName andIncludeFoodClass:(NSString*)includeFoodClass andExcludeFoodClass:(NSString*)excludeFoodClass  andIncludeFoodIds:(NSArray*)includeFoodIds andExcludeFoodIds:(NSArray*)excludeFoodIds andGetStrategy:(NSString*)getStrategy andIfNeedCustomDefinedFoods:(BOOL) ifNeedCustomDefinedFoods;


//-(NSArray *) getFoodIdsByFilters_withIncludeFoodClassAry:(NSArray*)includeFoodClassAry andExcludeFoodClassAry:(NSArray*)excludeFoodClassAry andEqualFoodClass:(NSString*)equalFoodClass andIncludeFoodIds:(NSArray*)includeFoodIds andExcludeFoodIds:(NSArray*)excludeFoodIds;
-(NSArray *) getFoodIdsByFilters_withIncludeFoodClassAry:(NSArray*)includeFoodClassAry andExcludeFoodClassAry:(NSArray*)excludeFoodClassAry andIncludeEqualFoodClassAry:(NSArray*)includeEqualFoodClassAry andIncludeFoodIds:(NSArray*)includeFoodIds andExcludeFoodIds:(NSArray*)excludeFoodIds;

-(NSArray *) getFoodsByFilters_withIncludeFoodClass:(NSString*)includeFoodClass andExcludeFoodClass:(NSString*)excludeFoodClass andEqualClass:(NSString*)equalClass andIncludeFoodIds:(NSArray*)includeFoodIds  andExcludeFoodIds:(NSArray*)excludeFoodIds;
-(NSDictionary *) getOneFoodByFilters_withIncludeFoodClass:(NSString*)includeFoodClass andExcludeFoodClass:(NSString*)excludeFoodClass andIncludeFoodIds:(NSArray*)includeFoodIds  andExcludeFoodIds:(NSArray*)excludeFoodIds;
-(NSDictionary *) getOneFoodByFilters_withIncludeFoodClass:(NSString*)includeFoodClass andExcludeFoodClass:(NSString*)excludeFoodClass andEqualClass:(NSString*)equalClass andIncludeFoodIds:(NSArray*)includeFoodIds  andExcludeFoodIds:(NSArray*)excludeFoodIds;

-(NSArray *) getAllFood;
//-(NSArray *)getFoodByIds:(NSArray *)idAry;
-(NSArray *)getFoodAttributesByIds:(NSArray *)idAry;
-(NSArray *)getOrderedFoodIds:(NSArray *)idAry;

-(NSArray *) getFoodsByColumnValuePairFilter_withColumnValuePairs_equal:(NSArray*)columnValuePairs_equal andColumnValuesPairs_equal:(NSArray*)columnValuesPairs_equal andColumnValuePairs_like:(NSArray*)columnValuePairs_like andColumnValuesPairs_like:(NSArray*)columnValuesPairs_like;
-(NSArray *) getFoodsByShowingPart:(NSString*)cnNamePart andEnNamePart:(NSString*)enNamePart andCnType:(NSString*)cnType;
-(NSArray *)getFoodCnTypes;

-(NSMutableDictionary*)getNutrientInfoAs2LevelDictionary_withNutrientIds:(NSArray*)nutrientIds;
-(NSDictionary*)getNutrientInfo:(NSString*)nutrientId;

-(NSArray *) getFoodsOfRichNutritionAndIntersectGivenSet_withNutrient:(NSString *)nutrientAsColumnName andGivenFoodIds:(NSArray*)givenFoodIds andIfNeedCustomDefinedFoods:(BOOL) ifNeedCustomDefinedFoods;
//-(bool) existAnyGivenFoodsBeRichOfNutrition:(NSString *)nutrientAsColumnName andGivenFoodIds:(NSArray*)givenFoodIds;


-(NSArray *) getRichNutritionFood2_withAmount_ForNutrient:(NSString *)nutrientName andNutrientAmount:(NSNumber*)nutrientAmount;


-(BOOL)updateFoodCollocationName:(NSString*)collationName byId:(NSNumber*)nmCollocationId;
-(NSArray*)getAllFoodCollocation;
-(NSArray*)getCollocationFoodData_withCollocationId:(NSNumber*)nmCollocationId;
-(NSDictionary*)getFoodCollocationData_withCollocationId:(NSNumber*)nmCollocationId;
-(NSNumber *)insertFoodCollocationData_withCollocationName:(NSString*)collationName andFoodAmount2LevelArray:(NSArray*)foodAmount2LevelArray;
-(BOOL)updateFoodCollocationData_withCollocationId:(NSNumber*)nmCollocationId andNewCollocationName:(NSString*)collocationName andFoodAmount2LevelArray:(NSArray*)foodAmount2LevelArray;
-(BOOL)deleteFoodCollocationData_withCollocationId:(NSNumber*)nmCollocationId;

-(NSArray*)getDiseaseGroupInfo_byType:(NSString*)groupType;
//-(NSArray*)getDiseaseNamesOfGroup:(NSString*)groupName andDepartment:(NSString*)department andDiseaseType:(NSString*)diseaseType andTimeType:(NSString*)timeType;
-(NSArray*)getDiseaseIdsOfGroup:(NSString*)groupName andDepartment:(NSString*)department andDiseaseType:(NSString*)diseaseType andTimeType:(NSString*)timeType;
-(NSArray*)getDiseaseInfosOfGroup:(NSString*)groupName andDepartment:(NSString*)department andDiseaseType:(NSString*)diseaseType andTimeType:(NSString*)timeType;

//-(NSDictionary*)getDiseasesOrganizedByColumn:(NSString*)organizedByColumn andFilters_Group:(NSString*)groupName andDepartment:(NSString*)department andDiseaseType:(NSString*)diseaseType andTimeType:(NSString*)timeType;
-(NSDictionary*)getDiseaseInfosOrganizedByColumn:(NSString*)organizedByColumn andFilters_Group:(NSString*)groupName andDepartment:(NSString*)department andDiseaseType:(NSString*)diseaseType andTimeType:(NSString*)timeType;

//-(NSDictionary*)getDiseaseNutrientRows_ByDiseaseNames:(NSArray*)diseaseNames andDiseaseGroup:(NSString*)groupName;
-(NSDictionary*)getDiseaseNutrientRows_ByDiseaseIds:(NSArray*)diseaseIds andDiseaseGroup:(NSString*)groupName;

-(NSArray*)getUserCheckDiseaseRecord_withDay:(int)day andTimeType:(int)TimeType;
-(BOOL)saveUserCheckDiseaseRecord_withDay:(int)day andTimeType:(int)TimeType UpdateTime:(NSDate*)UpdateTime andDiseases:(NSArray*)Diseases andLackNutrientIDs:(NSArray*)LackNutrientIDs andHealthMark:(int)HealthMark;

-(NSDictionary*)getTranslationItemsDictionaryByType:(NSString*)itemType;

-(NSArray*)getSymptomTypeRows_withForSex:(NSString*)forSex;
-(NSArray*)getSymptomRows_BySymptomTypeIds:(NSArray*)symptomTypeIds;
-(NSMutableDictionary*)getSymptomRowsByTypeDict_BySymptomTypeIds:(NSArray*)symptomTypeIds;

-(NSArray*)getSymptomNutrientRows_BySymptomIds:(NSArray*)symptomIds;
-(NSArray*)getSymptomNutrientDistinctIds_BySymptomIds:(NSArray*)symptomIds;

-(double)getSymptomHealthMarkSum_BySymptomIds:(NSArray*)symptomIds;

-(NSArray*)getIllnessSuggestionDistinctIds_ByIllnessIds:(NSArray*)illnessIds;
-(NSArray*)getIllnessSuggestions_BySuggestionIds:(NSArray*)suggestionIds;
-(NSArray*)getIllnessSuggestionsDistinct_ByIllnessIds:(NSArray*)illnessIds;

-(NSArray*)getIllnessIds;
-(NSArray*)getAllIllness;
-(NSArray*)getIllness_ByIllnessIds:(NSArray*)illnessIds;

-(BOOL)insertUserRecordSymptom_withDayLocal:(int)dayLocal andUpdateTimeUTC:(NSDate*)updateTimeUTC andInputNameValuePairs:(NSString*)inputNameValuePairs andNote:(NSString*)Note andCalculateNameValuePairs:(NSString*)calculateNameValuePairs;
-(BOOL)insertUserRecordSymptom_withRawData:(NSDictionary*)hmRawData;
-(BOOL)insertUserRecordSymptom_withDayLocal:(int)dayLocal andUpdateTimeUTC:(NSDate*)updateTimeUTC andInputNameValuePairsData:(NSDictionary*)inputNameValuePairsData andNote:(NSString*)Note andCalculateNameValuePairsData:(NSDictionary*)calculateNameValuePairsData;
-(BOOL)updateUserRecordSymptom_withDayLocal:(int)dayLocal andUpdateTimeUTC:(NSDate*)updateTimeUTC andInputNameValuePairsData:(NSDictionary*)inputNameValuePairsData andNote:(NSString*)Note andCalculateNameValuePairsData:(NSDictionary*)calculateNameValuePairsData;
-(BOOL)deleteUserRecordSymptomByByDayLocal:(int)dayLocal;
-(NSDictionary*)getUserRecordSymptomDataByDayLocal:(int)dayLocal;
-(NSArray*)getUserRecordSymptomRawRowsByRange_withStartDayLocal:(int)StartDayLocal andEndDayLocal:(int)EndDayLocal andStartMonthLocal:(int)StartMonthLocal andEndMonthLocal:(int)EndMonthLocal;
-(NSArray*)getUserRecordSymptomDataByRange_withStartDayLocal:(int)StartDayLocal andEndDayLocal:(int)EndDayLocal andStartMonthLocal:(int)StartMonthLocal andEndMonthLocal:(int)EndMonthLocal;
-(NSArray*)getUserRecordSymptom_DistinctMonth;

@end




























