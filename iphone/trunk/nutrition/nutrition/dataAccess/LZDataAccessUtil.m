//
//  LZDataAccessUtil.m
//  nutrition
//
//  Created by Yasofon on 13-8-21.
//  Copyright (c) 2013年 lingzhi mobile. All rights reserved.
//

#import "LZDataAccessUtil.h"
#import "LZUtility.h"

@implementation LZDataAccess(Util)

+(NSArray *)FMResultSetToDictionaryArray:(FMResultSet *)rs
{
    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:10];
    while ([rs next]) {
        NSDictionary *rowDict = rs.resultDictionary;
        [ary addObject:rowDict];
    }
    return ary;
}



+(NSDictionary *)FMResultSetToDictionaryRowsAndCols:(FMResultSet *)rs
{
    NSArray *columnNames = nil;
    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:10];
    while ([rs next]) {
        if (columnNames == nil){
            columnNames = rs.columnNameArray;
        }
        NSDictionary *rowDict = rs.resultDictionary;
        [ary addObject:rowDict];
    }
    NSDictionary *retDict = [NSDictionary dictionaryWithObjectsAndKeys:columnNames,@"cols", ary,@"rows", nil];
    return retDict;
}



+(NSDictionary *)findRowByKey:(NSArray *)rows andKeyName:(NSString *)keyname andKeyValue:(NSString *)keyvalue
{
    for(int i=0; i<rows.count; i++){
        NSDictionary *row = rows[i];
        NSString *columnVal = [row objectForKey:keyname];
        if ([columnVal isEqualToString:keyvalue]){
            return row;
        }
    }
    return nil;
}

-(NSString *)replaceForSqlText:(NSString *)origin
{
    return [origin stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
}







-(void)executeSql:(NSString*)strSql
{
    FMDatabase *_db = dbfm;
    [_db executeUpdate:strSql];
}



-(void)dropTable:(NSString*)tableName
{
    FMDatabase *_db = dbfm;
    NSMutableString *sqlDrop = [NSMutableString stringWithCapacity:100];
    [sqlDrop appendString:@"DROP TABLE IF EXISTS "];
    [sqlDrop appendString:tableName];
    [_db executeUpdate:sqlDrop];
}
-(void)deleteFromTable:(NSString*)tableName
{
    FMDatabase *_db = dbfm;
    NSMutableString *sqlDelete = [NSMutableString stringWithCapacity:100];
    [sqlDelete appendString:@"DELETE FROM "];
    [sqlDelete appendString:tableName];
    [_db executeUpdate:sqlDelete];
}

- (BOOL)deleteTableByEqualFilter_withTableName:(NSString *)tableName andField:(NSString *)fieldName andValue:(NSObject*)fieldValue
{
    NSString *query = [NSString stringWithFormat: @"DELETE FROM %@ WHERE %@=:fieldValue",tableName,fieldName];
    NSDictionary *dictQueryParam = [NSDictionary dictionaryWithObjectsAndKeys:fieldValue, @"fieldValue", nil];
    BOOL dbopState = [dbfm executeUpdate:query error:nil withParameterDictionary:dictQueryParam];
    return dbopState;
}


-(void)createTable_withTableName:(NSString*)tableName withColumnNames:(NSArray*)columnNames withPrimaryKey:(NSString*)primaryKey andIfNeedDropTable:(BOOL)needDrop
{
    FMDatabase *_db = dbfm;
    assert(columnNames.count > 1);
    if (needDrop){
        [self dropTable:tableName];
    }
    NSMutableDictionary *columnDict = [NSMutableDictionary dictionaryWithObjects:columnNames forKeys:columnNames];
    assert([columnDict objectForKey:primaryKey]!=nil);
    NSMutableArray *otherColumnNames = [NSMutableArray arrayWithArray:columnNames];//不能用dictionary的keys，是因为顺序乱了
    for(int i=0; i<otherColumnNames.count; i++){
        NSString *colName = otherColumnNames[i];
        if ([colName isEqualToString:primaryKey]){
            [otherColumnNames removeObjectAtIndex:i];
            break;
        }
    }
    
    NSMutableString *sqlCreate = [NSMutableString stringWithCapacity:1000*100];
    NSString *s1;
    [sqlCreate appendString:@"CREATE TABLE "];
    [sqlCreate appendString:tableName];
    [sqlCreate appendString:@" ("];
    s1 = [NSString stringWithFormat:@"'%@' TEXT PRIMARY KEY",primaryKey];
    [sqlCreate appendString:s1];
    for(int i=0; i<otherColumnNames.count; i++){
        s1 = [NSString stringWithFormat:@",'%@' REAL",otherColumnNames[i]];//对于sqlite来说，实际为text类型的列设计为real类型，也没有关系，从而省去一些判断的工作
        [sqlCreate appendString:s1];
    }
    [sqlCreate appendString:@")"];
    NSLog(@"createTable_withTableName sqlCreate=%@",sqlCreate);
    [_db executeUpdate:sqlCreate];
}

-(void)createTable_withTableName:(NSString*)tableName withColumnNames:(NSArray*)columnNames withRows2D:(NSArray*)rows2D withPrimaryKey:(NSString*)primaryKey andIfNeedDropTable:(BOOL)needDrop
{
    FMDatabase *_db = dbfm;
    assert(columnNames.count > 1);
    assert(rows2D.count > 0);
    if (needDrop){
        [self dropTable:tableName];
    }
    NSMutableDictionary *columnDict = [NSMutableDictionary dictionaryWithObjects:columnNames forKeys:columnNames];
    if (primaryKey != nil ){
        assert([columnDict objectForKey:primaryKey]!=nil);
    }
    NSArray *row = rows2D[0];
    assert(row.count==columnNames.count);
    
    NSMutableString *sqlCreate = [NSMutableString stringWithCapacity:1000*100];
    [sqlCreate appendString:@"CREATE TABLE "];
    [sqlCreate appendString:tableName];
    [sqlCreate appendString:@" ("];
    
    for(int i=0; i<columnNames.count; i++){
        NSString *columnName = columnNames[i];
        NSObject *cell = row[i];
        NSMutableString *s1 = [NSMutableString stringWithCapacity:100];
        if (i>0){
            [s1 appendString:@","];
        }
        [s1 appendFormat:@"'%@'",columnName ];
        if ([cell isKindOfClass:[NSNumber class]] && ![columnName isEqualToString:primaryKey]){
            [s1 appendString:@" REAL"];
        }else{
            [s1 appendString:@" TEXT"];
        }
        if ([columnName isEqualToString:primaryKey]){
            [s1 appendString:@" PRIMARY KEY"];
        }
        [sqlCreate appendString:s1];
    }
    [sqlCreate appendString:@")"];
    NSLog(@"createTable_withTableName sqlCreate=%@",sqlCreate);
    [_db executeUpdate:sqlCreate];
}

/*
 这里生成的insert sql语句中使用的是位置，而不是列名相关的key值，因为列名可能含有特殊字符。
 */
-(NSString *)generateInsertSqlForTable:(NSString*)tableName andColumnNames:(NSArray*)columnNames
{
    assert(columnNames.count > 0);
    
    //  INSERT INTO tblGroup (id, name, description, pkgid, seqInPkg) VALUES (101, 'tblGroup 1', 'p1g1', 1, 1);
    
    NSMutableArray *columnNames2 = [NSMutableArray arrayWithArray:columnNames];
    NSMutableArray *valuePlaceholders = [NSMutableArray arrayWithCapacity:columnNames.count];
    for(int i=0; i<columnNames2.count; i++){
        NSString *colName = [NSString stringWithFormat:@"'%@'",columnNames[i] ];//避免列名中有特殊字符
        
        //[columnNames2 replaceObjectAtIndex:i withObject:colName];
        columnNames2[i] = colName;
        valuePlaceholders[i] = @"?";
    }
    NSString *columnsStr = [columnNames2 componentsJoinedByString:@","];
    NSString *valuePlaceholdersStr = [valuePlaceholders componentsJoinedByString:@","];
    
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*100];
    [sqlStr appendString:@"INSERT INTO "];
    [sqlStr appendString:tableName];
    [sqlStr appendString:@"("];
    [sqlStr appendString:columnsStr];
    [sqlStr appendString:@") VALUES ("];
    [sqlStr appendString:valuePlaceholdersStr];
    [sqlStr appendString:@");"];
    NSLog(@"generateInsertSqlForTable sqlStr=%@",sqlStr);
    return sqlStr;
}

-(void)insertToTable_withTableName:(NSString*)tableName withColumnNames:(NSArray*)columnNames andRows2D:(NSArray*)rows2D andIfNeedClearTable:(BOOL)needClear
{
    FMDatabase *_db = dbfm;
    if (needClear){
        [self deleteFromTable:tableName];
    }
    if (rows2D.count == 0)
        return;
    assert(columnNames.count > 0);
    NSString * insertSql = [self generateInsertSqlForTable:tableName andColumnNames:columnNames];
    
    for(int i=0; i<rows2D.count; i++){
        NSArray *row = rows2D[i];
        assert(columnNames.count == row.count);
        
        [_db executeUpdate:insertSql error:nil withArgumentsInArray:row];
    }
}








-(NSDictionary*)queryDataAndMetaDataBySelectSql:(NSString*)sqlSelect
{
    FMDatabase *_db = dbfm;
    NSMutableArray *rowAry = [NSMutableArray arrayWithCapacity:1000];
    NSMutableArray *columnNames = nil;
    FMResultSet *rs = [_db executeQuery:sqlSelect];
    while ([rs next]) {
        if (columnNames == nil){
            //取固定顺序的所有列名
            columnNames = rs.columnNameArray;
        }
        NSArray *row = rs.resultArray;
        [rowAry addObject:row];
    }
    NSLog(@"queryDataAndMetaDataBySelectSql get columnNames=\n%@,\nrows=\n%@",columnNames,rowAry);
    
    NSMutableDictionary *retData = [NSMutableDictionary dictionaryWithCapacity:3];
    if (rowAry.count > 0){
        [retData setObject:columnNames forKey:@"columnNames"];
        [retData setObject:rowAry forKey:@"rows2D"];
    }
    return retData;
}






- (NSDictionary *)getAllDataOfTable:(NSString *)tableName
{
    FMDatabase *_db = dbfm;
    NSString *query = [NSString stringWithFormat: @"SELECT * FROM %@",tableName];
    FMResultSet *rs = [_db executeQuery:query];
    NSDictionary *retDict = [[self class] FMResultSetToDictionaryRowsAndCols:rs];
    return retDict;
}







- (NSArray *)selectAllForTable:(NSString *)tableName andOrderBy:(NSString *)partOrderBy
{
    NSMutableString *query = [NSMutableString stringWithFormat: @"SELECT * FROM %@",tableName];
    if (partOrderBy.length > 0){
        [query appendFormat:@" %@",partOrderBy ];
    }
    FMResultSet *rs = [dbfm executeQuery:query];
    NSArray *ary = [[self class] FMResultSetToDictionaryArray:rs];
    return ary;
}

- (NSArray *)selectTableByEqualFilter_withTableName:(NSString *)tableName andField:(NSString *)fieldName andValue:(NSObject*)fieldValue
{
    return [self selectTableByEqualFilter_withTableName:tableName andField:fieldName andValue:fieldValue andColumns:nil andOrderByPart:nil andNeedDistinct:false];
}

/*
 这里 orderByPart 不带 ORDER BY
 */
- (NSArray *)selectTableByEqualFilter_withTableName:(NSString *)tableName andField:(NSString *)fieldName andValue:(NSObject*)fieldValue andColumns:(NSArray*)columns andOrderByPart:(NSString*)orderByPart andNeedDistinct:(BOOL)needDistinct
{
    NSString *columnsPart = @"*";
    if (columns.count>0){
        columnsPart = [columns componentsJoinedByString:@","];
    }
    NSString *distinctPart = @"";
    if ( needDistinct )
        distinctPart = @"DISTINCT";
    NSMutableString *query = [NSMutableString stringWithFormat: @"SELECT %@ %@ FROM %@ WHERE %@=:fieldValue",distinctPart,columnsPart,tableName,fieldName];
    if (orderByPart.length>0)
        [query appendFormat:@" ORDER BY %@",orderByPart];
    NSDictionary *dictQueryParam = [NSDictionary dictionaryWithObjectsAndKeys:fieldValue, @"fieldValue", nil];
    NSLog(@"selectTableByEqualFilter_withTableName query=%@, dictQueryParam=%@",query,[LZUtility getObjectDescription:dictQueryParam andIndent:0]);
    FMResultSet *rs = [dbfm executeQuery:query withParameterDictionary:dictQueryParam];
    //    NSArray *ary = [[self class] FMResultSetToDictionaryArray:rs];
    NSArray *ary = [LZDataAccess FMResultSetToDictionaryArray:rs];
    return ary;
}
/*
 这里 orderByPart 不带 ORDER BY
 */
- (NSArray *)selectTableByEqualFilter_withTableName:(NSString *)tableName andFieldValuePairs:(NSArray *)fieldValuePairs andSelectColumns:(NSArray*)selectColumns andOrderByPart:(NSString*)orderByPart andNeedDistinct:(BOOL)needDistinct
{
    NSLog(@"selectTableByEqualFilter_withTableName enter");
    NSString *columnsPart = @"*";
    if (selectColumns.count>0){
        columnsPart = [selectColumns componentsJoinedByString:@","];
    }
    NSString *distinctPart = @"";
    if ( needDistinct )
        distinctPart = @"DISTINCT";
    
    NSMutableString *sqlStr = [NSMutableString stringWithFormat: @"SELECT %@ %@ FROM %@ ",distinctPart,columnsPart,tableName];
    
    NSMutableString *afterWherePart = [NSMutableString stringWithFormat:@""];
    if (orderByPart.length>0)
        [afterWherePart appendFormat:@" ORDER BY %@",orderByPart];

    NSMutableArray *exprIncludeANDdata = [NSMutableArray array];
    for(int i=0; i<fieldValuePairs.count; i++){
        NSArray* fieldValuePair = fieldValuePairs[i];
        assert(fieldValuePair.count==2);
        NSString *strColumn = fieldValuePair[0];
        NSString *strOp = @"=";
        if ([fieldValuePair[1] isKindOfClass:NSArray.class]){
            strOp = @"IN";
        }
        
        NSMutableArray *expr = [NSMutableArray arrayWithCapacity:3];
        [expr addObject:strColumn];
        [expr addObject:strOp];
        if ([fieldValuePair[1] isKindOfClass:NSArray.class]){
            [expr addObject:fieldValuePair[1] ];
        }else{
            [expr addObject:[NSArray arrayWithObjects:fieldValuePair[1], nil] ];
        }
        [exprIncludeANDdata addObject:expr];
    }

    NSDictionary *filters = [NSDictionary dictionaryWithObjectsAndKeys:
                             //exprIncludeORdata,@"includeOR",
                             exprIncludeANDdata,@"includeAND",
                             //exprExcludedata,@"exclude",
                             nil];
    NSDictionary *localOptions = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:false],@"varBeParamWay", nil];
    NSArray * dataAry = [self getRowsByQuery:sqlStr andFilters:filters andWhereExistInQuery:false andAfterWherePart:afterWherePart andOptions:localOptions];
    return dataAry;

}

- (NSArray *)selectTableByInFilter_withTableName:(NSString *)tableName andField:(NSString *)fieldName andValues:(NSArray*)fieldValues andColumns:(NSArray*)columns andOrderByPart:(NSString*)orderByPart
{
    if (fieldValues.count==0)
        return nil;
    
    //    NSString *columnsPart = @"*";
    //    if (columns.count>0){
    //        columnsPart = [columns componentsJoinedByString:@","];
    //    }
    //
    //    NSArray *placeholderAry = [LZUtility generateArrayWithFillItem:@"?" andArrayLength:fieldValues.count];
    //    NSString *placeholdersStr = [placeholderAry componentsJoinedByString:@","];
    //
    //    NSMutableString *query = [NSMutableString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@ in (%@)",columnsPart,tableName,fieldName,placeholdersStr];
    //    if (orderByPart.length>0)
    //        [query appendFormat:@" ORDER BY %@",orderByPart];
    //    NSLog(@"selectTableByInFilter_withTableName query=%@",query);
    //
    //    FMResultSet *rs = [dbfm executeQuery:query withArgumentsInArray:fieldValues];
    //    NSArray *ary = [[self class] FMResultSetToDictionaryArray:rs];
    //    return ary;
    
    NSString *columnsPart = @"*";
    if (columns.count>0){
        columnsPart = [columns componentsJoinedByString:@","];
    }
    NSMutableString *sqlStr = [NSMutableString stringWithFormat: @"SELECT %@ FROM %@ \n",columnsPart,tableName];
    
    NSMutableString *afterWherePart = [NSMutableString string ];
    if (orderByPart.length>0)
        [afterWherePart appendFormat:@"\n ORDER BY %@",orderByPart ];
    
    
    NSMutableArray *exprIncludeANDdata = [NSMutableArray array];
    NSMutableArray *expr = [NSMutableArray arrayWithObjects: fieldName, @"IN", fieldValues, nil];
    [exprIncludeANDdata addObject:expr];
    NSDictionary *filters = [NSDictionary dictionaryWithObjectsAndKeys:
                             exprIncludeANDdata,@"includeAND",
                             nil];
    NSDictionary *localOptions = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:true],@"varBeParamWay", nil];
    NSArray * dataAry = [self getRowsByQuery:sqlStr andFilters:filters andWhereExistInQuery:false andAfterWherePart:afterWherePart andOptions:localOptions];
    return dataAry;
}






/*
 注意columnName可能为 T1.columnName 的形式，而且如果columnName含有特殊字符，需在传入前自行处理，如 T1.[columnName]。
 result contain :(NSString*) strCondition, (NSArray*)sqlParams(only 1 item at max)
 */
+(NSDictionary*)getUnitCondition_withColumn:(NSString*)columnName andOp:(NSString*)operator andValue:(NSObject*)valObj andNotFlag:(BOOL)notFlag andOptions:(NSDictionary*)options
{
    NSNumber *nmVarBeParamWay = [options objectForKey:@"varBeParamWay"];
    BOOL varBeParamWay = FALSE;
    if (nmVarBeParamWay!=nil)
        varBeParamWay = [nmVarBeParamWay boolValue];
    
    assert(columnName!=nil);
    assert(operator!=nil);
    assert(valObj!=nil);
    NSMutableString *strCondition = [NSMutableString stringWithCapacity:100];
    NSMutableArray *sqlParams = [NSMutableArray array];
    if (notFlag) [strCondition appendString:@"NOT "];
    //[strCondition appendFormat:@"[%@] %@ ",columnName,operator];
    [strCondition appendFormat:@" %@ %@ ",columnName,operator];
    if (varBeParamWay){
        [strCondition appendString:@"?"];
        [sqlParams addObject:valObj];
    }else{
        if ([valObj isKindOfClass:NSNumber.class]){
            NSNumber *nmVal = (NSNumber *)valObj;
            double dval = [nmVal doubleValue];
            long lval = [nmVal longValue];
            double dlval = lval;
            long long llval = [nmVal longLongValue];
            double dllval = llval;
            if (dlval == dval){
                [strCondition appendFormat:@"%ld",lval];
            }else if(dllval == dval){
                [strCondition appendFormat:@"%lld",llval];
            }else{
                [strCondition appendFormat:@"%f",dval];
            }
        }else{
            NSString *strVal = nil;
            if ([valObj isKindOfClass:NSString.class]){
                strVal = (NSString*)valObj;
            }else{
                strVal = [NSString stringWithFormat:@"%@",valObj ];
            }
            strVal = [strVal stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            if ([@"LIKE" isEqualToString:[operator uppercaseString]]){
                [strCondition appendFormat:@"'%@%%'",strVal];
            }else{
                [strCondition appendFormat:@"'%@'",strVal];
            }
        }
    }
    
    NSDictionary *retDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             strCondition,@"strCondition",
                             sqlParams,@"sqlParams",
                             nil];
//    NSLog(@"getUnitCondition_withColumn %@ %@ %@ %d ret:\n %@",columnName,operator,valObj,notFlag,retDict);
    return retDict;
}
/*
 注意columnName可能为 T1.columnName 的形式，而且如果columnName含有特殊字符，需在传入前自行处理，如 T1.[columnName]。
 result contain :(NSString*) strCondition, (NSArray*)sqlParams
 */
+(NSDictionary*)getUnitCondition_withColumn:(NSString*)columnName andOp:(NSString*)operator andValues:(NSArray*)values andNotFlag:(BOOL)notFlag andOptions:(NSDictionary*)options
{
    NSNumber *nmVarBeParamWay = [options objectForKey:@"varBeParamWay"];
    BOOL varBeParamWay = FALSE;
    if (nmVarBeParamWay!=nil)
        varBeParamWay = [nmVarBeParamWay boolValue];
    
    assert(columnName!=nil);
    assert(operator!=nil);
    assert(values.count>0);
    assert([[operator uppercaseString] isEqualToString:@"IN"]);
    NSMutableString *strCondition = [NSMutableString stringWithCapacity:100];
    NSMutableArray *sqlParams = [NSMutableArray arrayWithCapacity:values.count];
    if (notFlag) [strCondition appendString:@"NOT "];
    //    [strCondition appendFormat:@"[%@] %@ ",columnName,operator];
    [strCondition appendFormat:@" %@ %@ ",columnName,operator];
    if(varBeParamWay){
        NSMutableArray *placeholderAry = [NSMutableArray arrayWithCapacity:values.count];
        for(int i=0; i<values.count; i++){
            [placeholderAry addObject:@"?"];
        }
        NSString *placeholdersStr = [placeholderAry componentsJoinedByString:@","];
        [strCondition appendFormat:@"(%@)",placeholdersStr];
        [sqlParams addObjectsFromArray:values];
    }else{
        NSMutableArray *strValues = [NSMutableArray arrayWithCapacity:values.count];
        NSObject *valObj0 = values[0];
        if ([valObj0 isKindOfClass:NSNumber.class]){
            //assert(![columnName isEqualToString:COLUMN_NAME_NDB_No]);// 存在情况 columnName 含 NDB_No
            for(int i=0; i<values.count; i++){
                NSNumber *nmVal = values[i];
                NSString *strVal = [NSString stringWithFormat:@"%@",nmVal];
                [strValues addObject:strVal ];
            }//for i
        }else{
            for(int i=0; i<values.count; i++){
                NSObject *objVal = values[i];
                NSString *strVal = nil;
                if ([objVal isKindOfClass:NSString.class]){
                    strVal = (NSString*)objVal;
                }else{
                    strVal = [NSString stringWithFormat:@"%@",objVal ];
                }
                strVal = [strVal stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                strVal = [NSString stringWithFormat:@"'%@'",strVal ];
                [strValues addObject:strVal ];
            }//for i
        }
        [strCondition appendFormat:@"(%@)",[strValues componentsJoinedByString:@","]];
    }
    NSDictionary *retDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             strCondition,@"strCondition",
                             sqlParams,@"sqlParams",
                             nil];
//    NSLog(@"getUnitCondition_withColumn %@ %@ %@ %d ret:\n %@",columnName,operator,values,notFlag,retDict);
    return retDict;
}

/*
 notFlag1 column1 op1 values1
 */
+(NSDictionary*)getMediumUnitCondition_withExpressionItems:(NSArray*)expressionItems andJoinBoolOp:(NSString*)joinBoolOp andOptions:(NSDictionary*)options
{
//    NSLog(@"getMediumUnitCondition_withExpressionItems enter, %@ . %@ . %@",expressionItems,joinBoolOp,options);
    NSNumber *nmVarBeParamWay = [options objectForKey:@"varBeParamWay"];
    BOOL varBeParamWay = FALSE;
    if (nmVarBeParamWay!=nil)
        varBeParamWay = [nmVarBeParamWay boolValue];
    
    assert(expressionItems.count==4);
    NSNumber *nmNotFlag = expressionItems[0];
    NSString *strColumn = expressionItems[1];
    NSString *strOp = expressionItems[2];
    NSArray *values = expressionItems[3];
    //    assert(nmNotFlag!=nil);
    assert(joinBoolOp.length>0);
    assert(strColumn.length>0);
    assert(strOp.length>0);
    assert(values.count > 0);
    
    NSMutableString *strCondition = [NSMutableString stringWithCapacity:100];
    NSMutableArray *sqlParams = [NSMutableArray arrayWithCapacity:10];
    bool firstInnerConditionAdd = false;
    
    if ([[strOp uppercaseString] isEqualToString:@"IN"]){
        NSDictionary *unitConditionData = [self getUnitCondition_withColumn:strColumn andOp:strOp andValues:values andNotFlag:[nmNotFlag boolValue] andOptions:options];
        NSString * unitCondition = [unitConditionData objectForKey:@"strCondition"];
        NSArray* localSqlParams = [unitConditionData objectForKey:@"sqlParams"];
        [strCondition appendString:unitCondition];
        [sqlParams addObjectsFromArray:localSqlParams];
    }else{
        for(int i=0 ; i<values.count; i++){
            NSObject *valObj = values[i];
            NSDictionary *unitConditionData = [self getUnitCondition_withColumn:strColumn andOp:strOp andValue:valObj andNotFlag:[nmNotFlag boolValue] andOptions:options];
            NSString * unitCondition = [unitConditionData objectForKey:@"strCondition"];
            NSArray* localSqlParams = [unitConditionData objectForKey:@"sqlParams"];
            if (firstInnerConditionAdd){
                [strCondition appendFormat:@" %@ ",joinBoolOp];
            }else{
                firstInnerConditionAdd = true;
            }
            [strCondition appendString:unitCondition];
            [sqlParams addObjectsFromArray:localSqlParams];
        }//for
    }
    NSDictionary *retDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             strCondition,@"strCondition",
                             sqlParams,@"sqlParams",
                             nil];
//    NSLog(@"getMediumUnitCondition_withExpressionItems %@ %@ ret:\n %@",expressionItems,joinBoolOp,retDict);
    return retDict;
}

/*
 options contain: flag varBeParamWay(contrary is varDirectInSql)
 [notFlag1 column1 op1 values1],[notFlag1 column1 op1 values1]
 */
+(NSDictionary*)getBigUnitCondition_withExpressionItems:(NSArray*)expressionItemsArray andJoinBoolOp:(NSString*)joinBoolOp andOptions:(NSDictionary*)options
{
    NSNumber *nmVarBeParamWay = [options objectForKey:@"varBeParamWay"];
    BOOL varBeParamWay = FALSE;
    if (nmVarBeParamWay!=nil)
        varBeParamWay = [nmVarBeParamWay boolValue];
    
    assert(joinBoolOp.length>0);
    assert(expressionItemsArray.count>0);
    NSMutableString *strCondition = [NSMutableString stringWithCapacity:1000];
    NSMutableArray *sqlParams = [NSMutableArray arrayWithCapacity:100];
    bool firstInnerConditionAdd = false;
    for(int i=0; i<expressionItemsArray.count; i++){
        NSArray *expressionItems = expressionItemsArray[i];
        assert(expressionItems.count==4);
        NSDictionary *unitConditionData = [self getMediumUnitCondition_withExpressionItems:expressionItems andJoinBoolOp:joinBoolOp andOptions:options];
        NSString * unitCondition = [unitConditionData objectForKey:@"strCondition"];
        NSArray* localSqlParams = [unitConditionData objectForKey:@"sqlParams"];
        if (firstInnerConditionAdd){
            [strCondition appendFormat:@" %@ ",joinBoolOp];
        }else{
            firstInnerConditionAdd = true;
        }
        [strCondition appendFormat:@"(%@)",unitCondition];
        [sqlParams addObjectsFromArray:localSqlParams];
    }
    NSDictionary *retDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             strCondition,@"strCondition",
                             sqlParams,@"sqlParams",
                             nil];
//    NSLog(@"getBigUnitCondition_withExpressionItems %@ %@ ret:\n %@",expressionItemsArray,joinBoolOp,retDict);
    return retDict;
}

/*
 options contain: flag varBeParamWay(contrary is varDirectInSql)
 filters contain:
 flag needWhereWord
 includeOR AND (cond1 OR cond2 OR cond3 ...)
 expressionItemsArray
 column1 op1 values1
 column2 op2 values2
 includeAND AND cond1 AND cond2 AND cond3 ...
 expressionItemsArray
 column1 op1 values1
 column2 op2 values2
 exclude --  AND NOT cond1 AND NOT cond2 AND NOT cond3 ...
 expressionItemsArray
 column1 op1 values1
 column2 op2 values2
 
 op can be = , like, in
 */
+(NSDictionary*)getConditionsPart_withFilters:(NSDictionary*)filters andOptions:(NSDictionary*)options
{
    
    NSNumber *nmNeedWhereWord = [filters objectForKey:@"needWhereWord"];
    BOOL needWhereWord = FALSE;
    if (nmNeedWhereWord!=nil)
        needWhereWord = [nmNeedWhereWord boolValue];
    
    NSMutableString *strConditions = [NSMutableString stringWithCapacity:10000];
    NSMutableArray *sqlParams = [NSMutableArray arrayWithCapacity:100];
    if (needWhereWord){
        [strConditions appendString:@"\n WHERE 1=1"];
    }
    NSArray *includeORdata = [filters objectForKey:@"includeOR"];
    NSArray *includeANDdata = [filters objectForKey:@"includeAND"];
    NSArray *excludeData = [filters objectForKey:@"exclude"];
    
    if (includeORdata.count>0){
        NSNumber *nmNotFlag = [NSNumber numberWithBool:FALSE];
        NSMutableArray * expressionItemsArray = [NSMutableArray arrayWithCapacity:includeORdata.count];
        for(int i=0; i<includeORdata.count; i++){
            NSArray *expressionItems = includeORdata[i];
            NSMutableArray *expressionItems2 = [NSMutableArray arrayWithCapacity:(expressionItems.count+1)];
            [expressionItems2 addObject:nmNotFlag];
            [expressionItems2 addObjectsFromArray:expressionItems];
            [expressionItemsArray addObject:expressionItems2];
        }
        NSDictionary *unitConditionData = [self getBigUnitCondition_withExpressionItems:expressionItemsArray andJoinBoolOp:@"OR" andOptions:options];
        NSString * unitCondition = [unitConditionData objectForKey:@"strCondition"];
        NSArray* localSqlParams = [unitConditionData objectForKey:@"sqlParams"];
        [strConditions appendFormat:@" AND (%@)",unitCondition ];
        [sqlParams addObjectsFromArray:localSqlParams];
    }//if (includeORDict!=nil)
    if (includeANDdata.count>0){
        NSNumber *nmNotFlag = [NSNumber numberWithBool:FALSE];
        NSMutableArray * expressionItemsArray = [NSMutableArray arrayWithCapacity:includeANDdata.count];
        for(int i=0; i<includeANDdata.count; i++){
            NSArray *expressionItems = includeANDdata[i];
            NSMutableArray *expressionItems2 = [NSMutableArray arrayWithCapacity:(expressionItems.count+1)];
            [expressionItems2 addObject:nmNotFlag];
            [expressionItems2 addObjectsFromArray:expressionItems];
            [expressionItemsArray addObject:expressionItems2];
        }
        NSDictionary *unitConditionData = [self getBigUnitCondition_withExpressionItems:expressionItemsArray andJoinBoolOp:@"AND" andOptions:options];
        NSString * unitCondition = [unitConditionData objectForKey:@"strCondition"];
        NSArray* localSqlParams = [unitConditionData objectForKey:@"sqlParams"];
        [strConditions appendFormat:@" AND (%@)",unitCondition ];
        [sqlParams addObjectsFromArray:localSqlParams];
    }//if (includeANDDict!=nil)
    if (excludeData.count>0){
        NSNumber *nmNotFlag = [NSNumber numberWithBool:TRUE];
        NSMutableArray * expressionItemsArray = [NSMutableArray arrayWithCapacity:excludeData.count];
        for(int i=0; i<excludeData.count; i++){
            NSArray *expressionItems = excludeData[i];
            NSMutableArray *expressionItems2 = [NSMutableArray arrayWithCapacity:(expressionItems.count+1)];
            [expressionItems2 addObject:nmNotFlag];
            [expressionItems2 addObjectsFromArray:expressionItems];
            [expressionItemsArray addObject:expressionItems2];
        }
        NSDictionary *unitConditionData = [self getBigUnitCondition_withExpressionItems:expressionItemsArray andJoinBoolOp:@"AND" andOptions:options];
        NSString * unitCondition = [unitConditionData objectForKey:@"strCondition"];
        NSArray* localSqlParams = [unitConditionData objectForKey:@"sqlParams"];
        [strConditions appendFormat:@" AND (%@)",unitCondition ];
        [sqlParams addObjectsFromArray:localSqlParams];
    }//if (excludeDict!=nil)
    NSDictionary *retDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             strConditions,@"strCondition",
                             sqlParams,@"sqlParams",
                             nil];
    NSLog(@"getBigUnitCondition_withExpressionItems %@ ret:%@",filters,retDict);
    return retDict;
}
/*
 options contain: flag varBeParamWay(contrary is varDirectInSql)
 filters contain:
 includeOR AND (cond1 OR cond2 OR cond3 ...)
 expressionItemsArray
 column1 op1 values1
 column2 op2 values2
 includeAND AND cond1 AND cond2 AND cond3 ...
 expressionItemsArray
 column1 op1 values1
 column2 op2 values2
 exclude --  AND NOT cond1 AND NOT cond2 AND NOT cond3 ...
 expressionItemsArray
 column1 op1 values1
 column2 op2 values2
 
 op can be = , like, in
 */
-(NSArray *)getRowsByQuery:(NSString*)strQuery andFilters:(NSDictionary*)filters andWhereExistInQuery:(BOOL)ifWhereExistInQuery andAfterWherePart:(NSString*)afterWherePart andOptions:options
{
    NSMutableDictionary *filtersDict = [NSMutableDictionary dictionaryWithDictionary:filters];
    [filtersDict setObject:[NSNumber numberWithBool:(!ifWhereExistInQuery)] forKey:@"needWhereWord"];
    NSDictionary *conditionData = [self.class getConditionsPart_withFilters:filtersDict andOptions:options];
    NSString *strCondition = [conditionData objectForKey:@"strCondition"];
    NSArray *sqlParams = [conditionData objectForKey:@"sqlParams"];
    NSMutableString *strWholeQuery = [NSMutableString stringWithString:strQuery];
    [strWholeQuery appendString:strCondition];
    if (afterWherePart.length>0) [strWholeQuery appendString:afterWherePart];
    
    NSLog(@"getRowsByQuery:andFilters strWholeQuery=%@, \nParams=%@",strWholeQuery,sqlParams);
    FMResultSet *rs = [dbfm executeQuery:strWholeQuery withArgumentsInArray:sqlParams];
    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];
    
    return dataAry;
}







-(NSString *)convertSelectSqlToCsv_withSelectSql:(NSString*)sqlSelect andCsvFileName:(NSString*)csvFileName
{
    NSDictionary* data = [self queryDataAndMetaDataBySelectSql:sqlSelect];
    NSArray *columnNames = [data objectForKey:@"columnNames"];
    NSArray *rows2D = [data objectForKey:@"rows2D"];
    
    return [LZUtility convert2DArrayToCsv:csvFileName withColumnNames:columnNames andRows2D:rows2D];
}
























@end
