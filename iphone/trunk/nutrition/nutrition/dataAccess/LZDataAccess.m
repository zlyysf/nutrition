//
//  LZDataAccess.m
//  tSql
//
//  Created by Yasofon on 13-2-4.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import "LZDataAccess.h"

@implementation LZDataAccess

+(LZDataAccess *)singleton {
    static dispatch_once_t pred;
    static LZDataAccess *shared;
    // Will only be run once, the first time this is called
    dispatch_once(&pred, ^{
        shared = [[LZDataAccess alloc] initDBConnection];
    });
    return shared;
}

+ (NSString *)dbFilePath {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:cDbFile];
    
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:cDbFile];
    NSLog(@"dbFilePath=%@",filePath);
    return filePath;
}


- (id)initDBConnection{
    self = [super init];
    if (self) {
        NSString *dbFilePath = [self.class dbFilePath];
        
        NSFileManager * defFileManager = [NSFileManager defaultManager];
        BOOL fileExists,isDir;
        fileExists = [defFileManager fileExistsAtPath:dbFilePath isDirectory:&isDir];
        if (!fileExists){            
            NSLog(@"INFO in initDBConnection, db file not exist: %@",dbFilePath);
        }else{
            NSLog(@"INFO in initDBConnection, db file exist: %@",dbFilePath);
        }
        
        dbfm = [FMDatabase databaseWithPath:dbFilePath];
        if (![dbfm open]) {
            //[dbfm release];
            NSLog(@"initDBConnection, FMDatabase databaseWithPath failed, %@", dbFilePath);
        }
    }
    return self;
}




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


- (NSArray *)selectAllForTable:(NSString *)tableName
{
    NSString *query = [NSString stringWithFormat: @"SELECT * FROM %@",tableName];
    FMResultSet *rs = [dbfm executeQuery:query];
    NSArray *ary = [[self class] FMResultSetToDictionaryArray:rs];
    return ary;
}

- (NSArray *)selectTableByEqualFilter:(NSString *)tableName andField:(NSString *)fieldName andValue:(NSObject*)fieldValue
{
    NSString *query = [NSString stringWithFormat: @"SELECT * FROM %@ WHERE %@=:fieldValue",tableName,fieldName];
    NSDictionary *dictQueryParam = [NSDictionary dictionaryWithObjectsAndKeys:fieldValue, @"fieldValue", nil];
    FMResultSet *rs = [dbfm executeQuery:query withParameterDictionary:dictQueryParam];
    NSArray *ary = [[self class] FMResultSetToDictionaryArray:rs];
    return ary;
}










- (NSDictionary *)getDRIbyGender:(NSString*)gender andAge:(int)age {
    NSString *tableName = @"DRIMale";
    if ([@"female" isEqualToString:gender]){
        tableName = @"DRIFemale";
    }
    
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*1];
    [sqlStr appendString:@"SELECT * FROM "];
    [sqlStr appendString:tableName];
    [sqlStr appendString:@" WHERE Start <= ? "];
    [sqlStr appendString:@" ORDER BY Start"];
    
    NSArray * argAry = [NSArray arrayWithObjects:[NSNumber numberWithInt:age], nil];
    NSDictionary *rowDict = nil;
    FMResultSet *rs = [dbfm executeQuery:sqlStr withArgumentsInArray:argAry];
    if ([rs next]) {
        rowDict = rs.resultDictionary;
    }
    NSLog(@"getDRIbyGender get:\n%@",rowDict);
    NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithDictionary:rowDict];
    [retDict removeObjectForKey:@"Start"];
    [retDict removeObjectForKey:@"End"];
    NSLog(@"getDRIbyGender ret:\n%@",retDict);
    return retDict;
}



-(NSArray *) getRichNutritionFood:(NSString *)nutrientAsColumnName andTopN:(int)topN
{
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*1];
    [sqlStr appendString:@"SELECT * FROM FoodNutritionCustom"];
    [sqlStr appendString:@" ORDER BY "];
    [sqlStr appendString:@"'"];
    [sqlStr appendString:nutrientAsColumnName];
    [sqlStr appendString:@"'"];
    [sqlStr appendString:@" LIMIT "];
    [sqlStr appendString:[[NSNumber numberWithInt:topN] stringValue]];
    NSLog(@"getRichNutritionFood sqlStr=%@",sqlStr);

    FMResultSet *rs = [dbfm executeQuery:sqlStr];
    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];
    assert(dataAry.count > 0);
    NSLog(@"getRichNutritionFood ret:\n%@",dataAry);
    return dataAry;
}


-(NSArray *) getAllFood
{
    NSString *query = @""
    "SELECT * FROM FoodNutritionCustom"
    " ORDER BY CnType, NDB_No"
    ;

    FMResultSet *rs = [dbfm executeQuery:query];
    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];
    assert(dataAry.count > 0);
    NSLog(@"getAllFood ret:\n%@",dataAry);
    return dataAry;
}










@end
