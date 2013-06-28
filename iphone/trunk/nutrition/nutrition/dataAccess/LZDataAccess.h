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

+ (NSString *)dbFilePath;

- (id)initDBConnection;

//-(NSDictionary*)getStandardDRIForSex:(int )sex age:(int)age weight:(float)weight height:(float)height activityLevel:(int )activityLevel;
//-(NSDictionary*)getStandardDRIs:(int)sex age:(int)age weight:(float)weight height:(float)height activityLevel:(int )activityLevel;
-(NSDictionary*)getStandardDRIs:(int)sex age:(int)age weight:(float)weight height:(float)height activityLevel:(int)activityLevel considerLoss:(BOOL)needConsiderLoss;
-(NSDictionary*)getStandardDRIULs:(int)sex age:(int)age weight:(float)weight height:(float)height activityLevel:(int)activityLevel considerLoss:(BOOL)needConsiderLoss;

-(NSString *)replaceForSqlText:(NSString *)origin;
+(NSDictionary *)findRowByKey:(NSArray *)rows andKeyName:(NSString *)keyname andKeyValue:(NSString *)keyvalue;
+(NSArray *)FMResultSetToDictionaryArray:(FMResultSet *)rs;
- (NSArray *)selectAllForTable:(NSString *)tableName;
- (NSArray *)selectTableByEqualFilter:(NSString *)tableName andField:(NSString *)fieldName andValue:(NSObject*)fieldValue;

- (NSDictionary *)getDRIbyGender:(NSString*)gender andAge:(int)age ;
- (NSDictionary *)getDRIULbyGender:(NSString*)gender andAge:(int)age ;
//-(NSDictionary*)getAbstractPersonDRIs;
-(NSDictionary*)getAbstractPersonDRIsWithConsiderLoss : (BOOL)needConsiderLoss;
-(NSDictionary*)getAbstractPersonDRIULsWithConsiderLoss : (BOOL)needConsiderLoss;
-(NSArray *) getRichNutritionFood:(NSString *)nutrientAsColumnName andTopN:(int)topN;
-(NSArray *) getRichNutritionFoodForNutrient:(NSString *)nutrientName andNutrientAmount:(NSNumber*)nutrientAmount;
-(NSArray *) getRichNutritionFood:(NSString *)nutrientAsColumnName andIncludeFoodClass:(NSString*)includeFoodClass andExcludeFoodClass:(NSString*)excludeFoodClass andTopN:(int)topN;
-(NSDictionary *) getOneRichNutritionFood:(NSString *)nutrientAsColumnName andIncludeFoodClass:(NSString*)includeFoodClass andExcludeFoodClass:(NSString*)excludeFoodClass andGetStrategy:(NSString*)getStrategy;

-(NSArray *) getFoodOfIncludeClass:(NSString*)includeFoodClass andExcludeFoodClass:(NSString*)excludeFoodClass;
-(NSDictionary*) getOneFoodOfIncludeClass:(NSString*)includeFoodClass andExcludeFoodClass:(NSString*)excludeFoodClass;

-(NSArray *) getAllFood;
-(NSArray *)getFoodByIds:(NSArray *)idAry;
-(NSArray *)getFoodAttributesByIds:(NSArray *)idAry;
-(NSArray *)getOrderedFoodIds:(NSArray *)idAry;

-(NSMutableDictionary*)getNutrientInfoAs2LevelDictionary_withNutrientIds:(NSArray*)nutrientIds;
-(NSDictionary*)getNutrientInfo:(NSString*)nutrientId;

-(bool) existAnyGivenFoodsBeRichOfNutrition:(NSString *)nutrientAsColumnName andGivenFoodIds:(NSArray*)givenFoodIds;

@end
