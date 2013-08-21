//
//  LZDataAccessUtil.h
//  nutrition
//
//  Created by Yasofon on 13-8-21.
//  Copyright (c) 2013年 lingzhi mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZDataAccess.h"

@interface LZDataAccess(Util)

+(NSArray *)FMResultSetToDictionaryArray:(FMResultSet *)rs;

+(NSDictionary *)findRowByKey:(NSArray *)rows andKeyName:(NSString *)keyname andKeyValue:(NSString *)keyvalue;
-(NSString *)replaceForSqlText:(NSString *)origin;
- (NSArray *)selectAllForTable:(NSString *)tableName andOrderBy:(NSString *)partOrderBy;
- (NSArray *)selectTableByEqualFilter_withTableName:(NSString *)tableName andField:(NSString *)fieldName andValue:(NSObject*)fieldValue;
- (NSArray *)selectTableByEqualFilter_withTableName:(NSString *)tableName andField:(NSString *)fieldName andValue:(NSObject*)fieldValue andColumns:(NSArray*)columns andOrderByPart:(NSString*)orderByPart;
- (NSArray *)selectTableByInFilter_withTableName:(NSString *)tableName andField:(NSString *)fieldName andValues:(NSArray*)fieldValues andColumns:(NSArray*)columns andOrderByPart:(NSString*)orderByPart;
- (BOOL)deleteTableByEqualFilter_withTableName:(NSString *)tableName andField:(NSString *)fieldName andValue:(NSObject*)fieldValue;



+(NSDictionary*)getConditionsPart_withFilters:(NSDictionary*)filters andOptions:(NSDictionary*)options;
-(NSArray *)getRowsByQuery:(NSString*)strQuery andFilters:(NSDictionary*)filters andWhereExistInQuery:(BOOL)ifWhereExistInQuery andAfterWherePart:(NSString*)afterWherePart andOptions:options;



@end


























