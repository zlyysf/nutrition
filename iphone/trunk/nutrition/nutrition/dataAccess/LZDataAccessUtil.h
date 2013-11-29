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
+(NSDictionary *)FMResultSetToDictionaryRowsAndCols:(FMResultSet *)rs;

+(NSDictionary *)findRowByKey:(NSArray *)rows andKeyName:(NSString *)keyname andKeyValue:(NSString *)keyvalue;
-(NSString *)replaceForSqlText:(NSString *)origin;

-(void)executeSql:(NSString*)strSql;
-(void)dropTable:(NSString*)tableName;
-(void)deleteFromTable:(NSString*)tableName;
- (BOOL)deleteTableByEqualFilter_withTableName:(NSString *)tableName andField:(NSString *)fieldName andValue:(NSObject*)fieldValue;
-(void)createTable_withTableName:(NSString*)tableName withColumnNames:(NSArray*)columnNames withPrimaryKey:(NSString*)primaryKey andIfNeedDropTable:(BOOL)needDrop;
-(void)createTable_withTableName:(NSString*)tableName withColumnNames:(NSArray*)columnNames withRows2D:(NSArray*)rows2D withPrimaryKey:(NSString*)primaryKey andIfNeedDropTable:(BOOL)needDrop;
-(NSString *)generateInsertSqlForTable:(NSString*)tableName andColumnNames:(NSArray*)columnNames;
-(void)insertToTable_withTableName:(NSString*)tableName withColumnNames:(NSArray*)columnNames andRows2D:(NSArray*)rows2D andIfNeedClearTable:(BOOL)needClear;


-(NSDictionary*)queryDataAndMetaDataBySelectSql:(NSString*)sqlSelect;

- (NSDictionary *)getAllDataOfTable:(NSString *)tableName;


- (NSArray *)selectAllForTable:(NSString *)tableName andOrderBy:(NSString *)partOrderBy;
- (NSArray *)selectTableByEqualFilter_withTableName:(NSString *)tableName andField:(NSString *)fieldName andValue:(NSObject*)fieldValue;
//- (NSArray *)selectTableByEqualFilter_withTableName:(NSString *)tableName andField:(NSString *)fieldName andValue:(NSObject*)fieldValue andColumns:(NSArray*)columns andOrderByPart:(NSString*)orderByPart;
- (NSArray *)selectTableByEqualFilter_withTableName:(NSString *)tableName andField:(NSString *)fieldName andValue:(NSObject*)fieldValue andColumns:(NSArray*)columns andOrderByPart:(NSString*)orderByPart andNeedDistinct:(BOOL)needDistinct;
- (NSArray *)selectTableByEqualFilter_withTableName:(NSString *)tableName andFieldValuePairs:(NSArray *)fieldValuePairs andSelectColumns:(NSArray*)selectColumns andOrderByPart:(NSString*)orderByPart andNeedDistinct:(BOOL)needDistinct;
- (NSArray *)selectTableByInFilter_withTableName:(NSString *)tableName andField:(NSString *)fieldName andValues:(NSArray*)fieldValues andColumns:(NSArray*)columns andOrderByPart:(NSString*)orderByPart;

- (NSArray *)selectTable_byFieldOpValuePairs:(NSArray *)fieldOpValuePairs andTableName:(NSString *)tableName andSelectColumns:(NSArray*)selectColumns andOrderByPart:(NSString*)orderByPart andNeedDistinct:(BOOL)needDistinct;


+(NSDictionary*)getConditionsPart_withFilters:(NSDictionary*)filters andOptions:(NSDictionary*)options;
-(NSArray *)getRowsByQuery:(NSString*)strQuery andFilters:(NSDictionary*)filters andWhereExistInQuery:(BOOL)ifWhereExistInQuery andAfterWherePart:(NSString*)afterWherePart andOptions:options;


-(NSString *)convertSelectSqlToCsv_withSelectSql:(NSString*)sqlSelect andCsvFileName:(NSString*)csvFileName;



@end


























