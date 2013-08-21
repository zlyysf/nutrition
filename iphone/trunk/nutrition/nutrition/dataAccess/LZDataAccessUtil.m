//
//  LZDataAccessUtil.m
//  nutrition
//
//  Created by Yasofon on 13-8-21.
//  Copyright (c) 2013年 lingzhi mobile. All rights reserved.
//

#import "LZDataAccessUtil.h"

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
    return [self selectTableByEqualFilter_withTableName:tableName andField:fieldName andValue:fieldValue andColumns:nil andOrderByPart:nil];
}

- (NSArray *)selectTableByEqualFilter_withTableName:(NSString *)tableName andField:(NSString *)fieldName andValue:(NSObject*)fieldValue andColumns:(NSArray*)columns andOrderByPart:(NSString*)orderByPart
{
    NSString *columnsPart = @"*";
    if (columns.count>0){
        columnsPart = [columns componentsJoinedByString:@","];
    }
    NSMutableString *query = [NSMutableString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=:fieldValue",columnsPart,tableName,fieldName];
    if (orderByPart.length>0)
        [query appendFormat:@" ORDER BY %@",orderByPart];
    NSDictionary *dictQueryParam = [NSDictionary dictionaryWithObjectsAndKeys:fieldValue, @"fieldValue", nil];
    NSLog(@"selectTableByEqualFilter_withTableName query=%@",query);
    FMResultSet *rs = [dbfm executeQuery:query withParameterDictionary:dictQueryParam];
    //    NSArray *ary = [[self class] FMResultSetToDictionaryArray:rs];
    NSArray *ary = [LZDataAccess FMResultSetToDictionaryArray:rs];
    return ary;
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

- (BOOL)deleteTableByEqualFilter_withTableName:(NSString *)tableName andField:(NSString *)fieldName andValue:(NSObject*)fieldValue
{
    NSString *query = [NSString stringWithFormat: @"DELETE FROM %@ WHERE %@=:fieldValue",tableName,fieldName];
    NSDictionary *dictQueryParam = [NSDictionary dictionaryWithObjectsAndKeys:fieldValue, @"fieldValue", nil];
    BOOL dbopState = [dbfm executeUpdate:query error:nil withParameterDictionary:dictQueryParam];
    return dbopState;
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
    NSLog(@"getUnitCondition_withColumn %@ %@ %@ %d ret:\n %@",columnName,operator,valObj,notFlag,retDict);
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
    NSLog(@"getUnitCondition_withColumn %@ %@ %@ %d ret:\n %@",columnName,operator,values,notFlag,retDict);
    return retDict;
}

/*
 notFlag1 column1 op1 values1
 */
+(NSDictionary*)getMediumUnitCondition_withExpressionItems:(NSArray*)expressionItems andJoinBoolOp:(NSString*)joinBoolOp andOptions:(NSDictionary*)options
{
    NSLog(@"getMediumUnitCondition_withExpressionItems enter, %@ . %@ . %@",expressionItems,joinBoolOp,options);
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
    NSLog(@"getMediumUnitCondition_withExpressionItems %@ %@ ret:\n %@",expressionItems,joinBoolOp,retDict);
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
    NSLog(@"getBigUnitCondition_withExpressionItems %@ %@ ret:\n %@",expressionItemsArray,joinBoolOp,retDict);
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





@end
