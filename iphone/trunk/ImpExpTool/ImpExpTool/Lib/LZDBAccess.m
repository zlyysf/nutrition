
//
//  Created by Yasofon on 13-4-26.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import "LZConst.h"

#import "LZDBAccess.h"
#import "LZUtility.h"
#import "LZConstants.h"
#import "LZRecommendFood.h"

@implementation LZDBAccess{
    NSString * _dbFilePath;
    NSString * _dbFileFullPath;
    FMDatabase *_db;
}

+(LZDBAccess *)singletonCustomDB {
    static dispatch_once_t predCustomDB;
    static LZDBAccess *sharedCustomDB;
    // Will only be run once, the first time this is called
    dispatch_once(&predCustomDB, ^{
        sharedCustomDB = [[LZDBAccess alloc] init];
        NSString *fullDataDbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"CustomDB.dat"];
        [sharedCustomDB myInitWithDbFilePath:fullDataDbPath andIfNeedClear:false];

    });
    return sharedCustomDB;
}


- (FMDatabase *)db{
    return _db;
}

- (void)close
{
    if (_db != nil)
        [_db close];

}

- (BOOL)executeUpdate:(NSString*)sql, ... {
    
    va_list args;
    va_start(args, sql);
    
    BOOL result = [_db executeUpdate:sql error:nil withArgumentsInArray:nil orDictionary:nil orVAList:args];
    
    va_end(args);
    return result;
}

//+(LZDBAccess *)singleton {
//    static dispatch_once_t pred;
//    static LZDBAccess *shared;
//    // Will only be run once, the first time this is called
//    dispatch_once(&pred, ^{
//        shared = [[LZDBAccess alloc] init];
//    });
//    return shared;
//}



//- (id)init
//{
//    self = [self initWithPath:@"data.dat" andIfNeedClear:false];
//    return self;
//}
//
//- (id)initWithPath: (NSString *)dbFilePath andIfNeedClear:(BOOL) needClear
//{
//    if (self = [super init]){
//        [self myInitWithDbFilePath:dbFilePath andIfNeedClear:needClear];
//    }
//    return self;
//}

/*
 dbFilePath 可以是绝对路径，也可以是一个文件名，此时目录是NSDocumentDirectory所指的那个。
 */
-(void)myInitWithDbFilePath: (NSString *)dbFilePath andIfNeedClear:(BOOL) needClear
{
    if ([dbFilePath isEqualToString:[dbFilePath lastPathComponent]]){
        _dbFilePath = dbFilePath;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:_dbFilePath];
        _dbFileFullPath = path;
    }else{
        _dbFilePath = dbFilePath;
        _dbFileFullPath = dbFilePath;
    }
    
    NSLog(@"dbFileFullPath=%@",_dbFileFullPath);
    
    if (needClear){
        NSFileManager * defFileManager = [NSFileManager defaultManager];
        BOOL fileExists = [defFileManager fileExistsAtPath:_dbFileFullPath];
        if (fileExists){
            NSError *err = nil;
            [defFileManager removeItemAtPath:_dbFileFullPath error:&err];
            if (err!=nil){
                NSLog(@"LZDBAccess init, removeItemAtPath err:%@",err);
            }
        }
    }
    
    _db = [FMDatabase databaseWithPath:_dbFileFullPath];
    if (![_db open]) {
        _db = nil;
        //[db release];
        //return;
    }
}


-(void)dropTable:(NSString*)tableName
{
    NSMutableString *sqlDrop = [NSMutableString stringWithCapacity:100];
    [sqlDrop appendString:@"DROP TABLE IF EXISTS "];
    [sqlDrop appendString:tableName];
    [_db executeUpdate:sqlDrop];
}
-(void)deleteFromTable:(NSString*)tableName
{
    NSMutableString *sqlDelete = [NSMutableString stringWithCapacity:100];
    [sqlDelete appendString:@"DELETE FROM "];
    [sqlDelete appendString:tableName];
    [_db executeUpdate:sqlDelete];
}

- (BOOL)deleteTableByEqualFilter_withTableName:(NSString *)tableName andField:(NSString *)fieldName andValue:(NSObject*)fieldValue
{
    NSString *query = [NSString stringWithFormat: @"DELETE FROM %@ WHERE %@=:fieldValue",tableName,fieldName];
    NSDictionary *dictQueryParam = [NSDictionary dictionaryWithObjectsAndKeys:fieldValue, @"fieldValue", nil];
    BOOL dbopState = [_db executeUpdate:query error:nil withParameterDictionary:dictQueryParam];
    return dbopState;
}


-(void)createTable_withTableName:(NSString*)tableName withColumnNames:(NSArray*)columnNames withPrimaryKey:(NSString*)primaryKey andIfNeedDropTable:(BOOL)needDrop
{
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

-(void)createEmptyTables_andIfNeedDrop:(BOOL)needDrop
{
    if (needDrop){
        NSString *strDrop = @"DROP TABLE IF EXISTS FoodCollocation;";
        [_db executeUpdate:strDrop];
        strDrop = @"DROP TABLE IF EXISTS CollocationFood;";
        [_db executeUpdate:strDrop];
        strDrop = @"DROP TABLE IF EXISTS FoodCollocationParam;";
        [_db executeUpdate:strDrop];
    }
    NSString *strCreate = @"CREATE TABLE FoodCollocation(CollocationId INTEGER PRIMARY KEY AUTOINCREMENT, CollocationName TEXT, CollocationCreateTime INTEGER);";
    [_db executeUpdate:strCreate];
    strCreate = @"CREATE TABLE CollocationFood(CollocationId INTEGER, FoodId TEXT, FoodAmount REAL);";
    [_db executeUpdate:strCreate];
    strCreate = @"CREATE TABLE FoodCollocationParam(CollocationId INTEGER, ParamName TEXT, ParamValue TEXT);";
    [_db executeUpdate:strCreate];
}


/*
 这个view在实际使用中发现一些跟sqlite相关的问题，主要是使用了view会导致列名前面的修饰符也会和单纯的列名一起成为实际的列名或key值，而导致使用上不便。
 从而只在很小的地方使用。
 注意目前没有把FoodCustom中的列用完，只用了一些显示性的列
 */
-(void)createView_FoodNutritionCustom_andIfNeedDrop:(BOOL)needDrop
{
    if (needDrop){
        NSString *strDropView = @"DROP VIEW IF EXISTS FoodNutritionCustom";
        [_db executeUpdate:strDropView];
    }
    NSString *strCreateView = @"CREATE VIEW IF NOT EXISTS FoodNutritionCustom AS Select CnCaption,CnType,classify,PicPath, FN.* From FoodNutrition FN join FoodCustom FC on FN.NDB_No=FC.NDB_No";
    [_db executeUpdate:strCreateView];
}

/*
 USDA_ABBREV
 USDAtable 是特指美国农业部的那份以excel格式存在的数据库的唯一一个各食物营养成分表。这里暂定其表名为FoodNutrition。
 美国农业部（http://ndb.nal.usda.gov/  USDA National Nutrient Database）
 */
-(void)createTableUSDA_ABBREV_withColumnNames : (NSArray*)columnNames andIfNeedDropTable:(BOOL)needDrop
{
    NSString *tableName = TABLE_NAME_USDA_ABBREV;//FoodNutrition
    NSString *primaryKey = COLUMN_NAME_NDB_No;
    [self createTable_withTableName:tableName withColumnNames:columnNames withPrimaryKey:primaryKey andIfNeedDropTable:needDrop];
}

/*
 USDAtable 是特指美国农业部的那份以excel格式存在的数据库的唯一一个各食物营养成分表。这里暂定其表名为FoodNutrition。
 其中对于每个列名两头加了单引号以作为显式的字符串列名以防止其中的特殊字符导致出错。
 rows是一个二维数组。其中的每个单个row的位置都对应columnNames。
 */
-(void)insertToTable_USDA_ABBREV_withColumnNames: (NSArray*)columnNames andRows2D:(NSArray*)rows2D andIfNeedClearTable:(BOOL)needClear
{
    NSString *tableName = TABLE_NAME_USDA_ABBREV;//FoodNutrition
    [self insertToTable_withTableName:tableName withColumnNames:columnNames andRows2D:rows2D andIfNeedClearTable:needClear];
}




-(void)createDRItable:(NSString*)tableName andColumnNames:(NSArray*)columnNames
{
    assert(columnNames.count > 2);
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*100];
    NSString *s1;
    [sqlStr appendString:@"CREATE TABLE "];
    [sqlStr appendString:tableName];
    [sqlStr appendString:@" ("];
    s1 = [NSString stringWithFormat:@"'%@' INTEGER",columnNames[0]];
    [sqlStr appendString:s1];
    s1 = [NSString stringWithFormat:@",'%@' INTEGER",columnNames[1]];
    [sqlStr appendString:s1];
    for(int i=2; i<columnNames.count; i++){
        s1 = [NSString stringWithFormat:@",'%@' REAL",columnNames[i]];
        [sqlStr appendString:s1];
    }
    [sqlStr appendString:@")"];
    [_db executeUpdate:sqlStr];
}
-(void)insertToDRItable:(NSString*)tableName andColumnNames:(NSArray*)columnNames andData:(NSArray*)rows
{
    if (rows.count == 0)
        return;
    assert(columnNames.count > 0);
    NSString * insertSql = [self generateInsertSqlForDRItable:tableName andColumnNames:columnNames];
    
    for(int i=0; i<rows.count; i++){
        NSArray *row = rows[i];
        assert(columnNames.count == row.count);
        
        [_db executeUpdate:insertSql error:nil withArgumentsInArray:row];
    }
}

-(NSString *)generateInsertSqlForDRItable:(NSString*)tableName andColumnNames:(NSArray*)columnNames{
    NSString *sqlStr = [self generateInsertSqlForTable:tableName andColumnNames:columnNames];
    return sqlStr;
}








/*
 idAry 的元素需要是字符串类型。
 返回值是dictionary，包含一个一维数组columnNames和一个二维数组rows。
 */
-(NSMutableDictionary *)queryUSDADataByIds:(NSArray *)idAry
{
    NSLog(@"queryUSDADataByIds begin");
    if (idAry.count ==0)
        return nil;
    NSMutableArray *placeholderAry = [NSMutableArray arrayWithCapacity:idAry.count];
    for(int i=0; i<idAry.count; i++){
        [placeholderAry addObject:@"?"];
    }
    NSString *placeholdersStr = [placeholderAry componentsJoinedByString:@","];
    
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*100];
    [sqlStr appendString:@"SELECT * FROM FoodNutrition WHERE NDB_No in ("];
    [sqlStr appendString:placeholdersStr];
    [sqlStr appendString:@")"];
    
    NSMutableArray *rowAry = [NSMutableArray arrayWithCapacity:1000];
    NSMutableArray *columnNames = nil;
    FMResultSet *rs = [_db executeQuery:sqlStr withArgumentsInArray:idAry];
    while ([rs next]) {
        if (columnNames == nil){
            //取固定顺序的所有列名
            columnNames = rs.columnNameArray;
        }
        NSArray *row = rs.resultArray;
        [rowAry addObject:row];
    }
    NSLog(@"queryUSDADataByIds ret:\n%@",rowAry);
    
    NSMutableDictionary *retData = [NSMutableDictionary dictionaryWithCapacity:5];
    [retData setObject:columnNames forKey:@"columnNames"];
    [retData setObject:rowAry forKey:@"rows"];
    
    return retData;
}

/*
 这里主要是加了自定义列，中文描述列。这里把自定义列加到了最后
 */
//-(NSArray *)getColumnsForCustomUSDAtable_V1 : (NSArray*)columnNamesForUSDA{
//    assert(columnNamesForUSDA.count > 1);
//    NSString *columnNameForCnCaption = @"CnCaption";
//    NSMutableArray *columnNamesCustom = [NSMutableArray arrayWithArray:columnNamesForUSDA];
//    [columnNamesCustom addObject:columnNameForCnCaption];
//    return columnNamesCustom;
//}
//
//-(void)createCustomUSDAtable_V1 : (NSArray*)columnNamesForUSDA{
//    NSLog(@"createCustomUSDAtable_V1 begin");
//
//    assert(columnNamesForUSDA.count > 1);
//    NSArray *columnNamesCustom = [self getColumnsForCustomUSDAtable_V1:columnNamesForUSDA];
//    
//    NSMutableString *sqlStr = [self generateSqlForCreateCustomUSDAtable:columnNamesCustom];
//    [_db executeUpdate:sqlStr];
//}

-(void)getDifferenceFromFoodCustomAndFoodCustomT2
{
    NSString *sqlQuery = @"select * from FoodCustomT2 where not NDB_No in (select NDB_No from FoodCustom)";
    NSString* csvfilePath = [self convertSelectSqlToCsv_withSelectSql:sqlQuery andCsvFileName:@"diffFoodCustomT2.csv"];
    NSLog(@"getDifferenceFromFoodCustomAndFoodCustomT2 diffFilePath = %@",csvfilePath);
}

//-------------------------------------------------

//-(NSArray *) getAllFood
//{
//    NSString *query = @""
//    "SELECT * FROM FoodNutritionCustom"
//    " ORDER BY CnType, NDB_No"
//    ;
//    
//    FMResultSet *rs = [_db executeQuery:query];
//    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];
//    assert(dataAry.count > 0);
//    //NSLog(@"getAllFood ret:\n%@",dataAry);
//    return dataAry;
//}

- (NSDictionary *)getDRIbyGender:(NSString*)gender andAge:(int)age {
    NSString *tableName = @"DRIMale";
    if ([@"female" isEqualToString:gender]){
        tableName = @"DRIFemale";
    }
    
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*1];
    [sqlStr appendString:@"SELECT * FROM "];
    [sqlStr appendString:tableName];
    [sqlStr appendString:@" WHERE Start <= ? "];
    [sqlStr appendString:@" ORDER BY Start desc"];
    
    NSArray * argAry = [NSArray arrayWithObjects:[NSNumber numberWithInt:age], nil];
    NSDictionary *rowDict = nil;
    FMResultSet *rs = [_db executeQuery:sqlStr withArgumentsInArray:argAry];
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

- (NSDictionary *)getAllDataOfTable:(NSString *)tableName
{
    NSString *query = [NSString stringWithFormat: @"SELECT * FROM %@",tableName];
    FMResultSet *rs = [_db executeQuery:query];
    NSDictionary *retDict = [[self class] FMResultSetToDictionaryRowsAndCols:rs];
    return retDict;
}

-(NSArray *) getAllNutrientColumns
{
    NSArray * allNutrientAry = [NSArray arrayWithObjects: @"Water_(g)",@"Energ_Kcal",@"Protein_(g)",@"Lipid_Tot_(g)",@"Ash_(g)",@"Carbohydrt_(g)",@"Fiber_TD_(g)",@"Sugar_Tot_(g)",@"Calcium_(mg)",@"Iron_(mg)",@"Magnesium_(mg)",@"Phosphorus_(mg)",@"Potassium_(mg)",@"Sodium_(mg)",@"Zinc_(mg)",@"Copper_(mg)",@"Manganese_(mg)",@"Selenium_(µg)",@"Vit_C_(mg)",@"Thiamin_(mg)",@"Riboflavin_(mg)",@"Niacin_(mg)",@"Panto_Acid_mg)",@"Vit_B6_(mg)",@"Folate_Tot_(µg)",@"Folic_Acid_(µg)",@"Food_Folate_(µg)",@"Folate_DFE_(µg)",@"Choline_Tot_ (mg)",@"Vit_B12_(µg)",@"Vit_A_IU",@"Vit_A_RAE",@"Retinol_(µg)",@"Alpha_Carot_(µg)",@"Beta_Carot_(µg)",@"Beta_Crypt_(µg)",@"Lycopene_(µg)",@"Lut+Zea_ (µg)",@"Vit_E_(mg)",@"Vit_D_(µg)",@"Vit_D_(IU)",@"Vit_K_(µg)",@"FA_Sat_(g)",@"FA_Mono_(g)",@"FA_Poly_(g)",@"Cholestrl_(mg)", nil];
    return allNutrientAry;

}





/*
 生成Food_Supply_DRI_Common表中的数据，参考readme
 */
-(void)generateTableAndData_Food_Supply_DRI_Common_withIfNeedClearTable:(BOOL)needClear
{
    NSString *tableName = TABLE_NAME_Food_Supply_DRI_Common;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"originalAndUpLimit",@"supplyAmountType",
                             [NSNumber numberWithBool:TRUE],@"needAmountToLevel", nil];
    NSDictionary *data = [self generateData_Food_Supply_DRI_Various_withTableName:tableName andOptions:options];
    NSArray *columnNames = [data objectForKey:@"columnNames"];
    NSArray *rows2D = [data objectForKey:@"rows2D"];
    
    NSString *primaryKey = COLUMN_NAME_NDB_No;
    [self createTable_withTableName:tableName withColumnNames:columnNames withRows2D:rows2D withPrimaryKey:primaryKey andIfNeedDropTable:needClear];
    [self insertToTable_withTableName:tableName withColumnNames:columnNames andRows2D:rows2D andIfNeedClearTable:needClear];
}

/*
 生成Food_Supply_DRI_Amount表中的数据，参考readme
 */
-(void)generateTableAndData_Food_Supply_DRI_Amount_withIfNeedClearTable:(BOOL)needClear
{
    NSString *tableName = TABLE_NAME_Food_Supply_DRI_Amount;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"original",@"supplyAmountType",
                             [NSNumber numberWithBool:FALSE],@"needAmountToLevel", nil];
    NSDictionary *data = [self generateData_Food_Supply_DRI_Various_withTableName:tableName andOptions:options];
    NSArray *columnNames = [data objectForKey:@"columnNames"];
    NSArray *rows2D = [data objectForKey:@"rows2D"];

    NSString *primaryKey = COLUMN_NAME_NDB_No;
    [self createTable_withTableName:tableName withColumnNames:columnNames withRows2D:rows2D withPrimaryKey:primaryKey andIfNeedDropTable:needClear];
    [self insertToTable_withTableName:tableName withColumnNames:columnNames andRows2D:rows2D andIfNeedClearTable:needClear];
}


-(NSMutableDictionary*)generateData_Food_Supply_DRI_Various_withTableName:(NSString*)tableName andOptions:(NSDictionary*)options
{

    NSString * supplyAmountType = @"originalAndUpLimit"; // @"original"; // @"originalAndUpLimit"
    BOOL needAmountToLevel = TRUE;
    BOOL needRoundAmount = TRUE;
    if (options != nil){
        id valObj = [options objectForKey:@"supplyAmountType"];
        if (valObj!=nil){
            supplyAmountType = valObj;
        }
        
        valObj = [options objectForKey:@"needAmountToLevel"];
        if (valObj != nil){
            NSNumber *nmVal = valObj;
            needAmountToLevel = [nmVal boolValue];
        }
    }
    
    NSArray * allNutrientAry = [self getAllNutrientColumns];
    NSMutableArray *allColumns = [NSMutableArray arrayWithObjects:COLUMN_NAME_NDB_No, nil];
    if (!needAmountToLevel){
        [allColumns addObjectsFromArray:[NSArray arrayWithObjects:
                                         COLUMN_NAME_MinAdequateAmount,COLUMN_NAME_NutrientID_min,
                                         COLUMN_NAME_MaxAdequateAmount,COLUMN_NAME_NutrientID_max,
                                         nil]];
    }
    [allColumns addObjectsFromArray:allNutrientAry];
    
    NSDictionary *foodNutritionData = [self getAllDataOfTable:VIEW_NAME_FoodNutritionCustom];
    NSArray *foodNutritionDataCols = [foodNutritionData objectForKey:@"cols"];
    NSArray *foodNutritionDataRows = [foodNutritionData objectForKey:@"rows"];
    assert(foodNutritionDataRows.count>100);//>0

    NSDictionary *DRIdata = [self.class getStandardDRIs:0 age:19 weight:75 height:175 activityLevel:0 andDBcon:self];
    
    NSMutableArray *rows2D = [NSMutableArray arrayWithCapacity:foodNutritionDataRows.count];
    for(int i=0; i<foodNutritionDataRows.count; i++){
        NSDictionary *foodNutritionDataRowDict = foodNutritionDataRows[i];
        NSMutableArray *fsdRow = [NSMutableArray arrayWithCapacity:foodNutritionDataCols.count];
        [fsdRow addObject:[foodNutritionDataRowDict objectForKey:COLUMN_NAME_NDB_No]];
        if (!needAmountToLevel){
            [fsdRow addObject:[NSNumber numberWithDouble:0]];
            [fsdRow addObject:@""];
            [fsdRow addObject:[NSNumber numberWithDouble:0]];
            [fsdRow addObject:@""];
        }

        double dMaxFoodAdequateAmount = 0;
        NSString *nutrientToMaxFoodAdequateAmount = nil;
        double dMinFoodAdequateAmount = 0;
        NSString *nutrientToMinFoodAdequateAmount = nil;
        for(int j=0; j<allNutrientAry.count; j++){
            NSString *columnNameNutrient = allNutrientAry[j];
            id nutrientDRI = [DRIdata objectForKey:columnNameNutrient];
            if (nutrientDRI == nil){
                [fsdRow addObject:[NSNumber numberWithInt:0]];//没有DRI，没法计算
            }else{//NOT if (nutrientDRI == nil)
                NSNumber *nmNutrientDRI = (NSNumber*)nutrientDRI;
                 NSNumber *nmFoodNutrientAmount = [foodNutritionDataRowDict objectForKey:columnNameNutrient];
                if ([nmFoodNutrientAmount doubleValue ]==0.0){//food的营养成分含量为0，也没法计算
                    [fsdRow addObject:[NSNumber numberWithInt:0]];
                }else{
                   
                    double dFoodSupplyAmount = [nmNutrientDRI doubleValue]/[nmFoodNutrientAmount doubleValue] * 100.0;
                    if ([@"originalAndUpLimit" isEqualToString:supplyAmountType]){
                        if (dFoodSupplyAmount >= Config_foodUpperLimit){
                            dFoodSupplyAmount = 0;
                        }else{
                            //do nothing
                        }
                    }else{//@"original"
                        //do nothing
                    }
                    if (needAmountToLevel){
                        if (dFoodSupplyAmount > 0){
                            dFoodSupplyAmount = round((dFoodSupplyAmount + 100) / 100.0);
                        }else{
                            //when foodSupplyAmount be 0, not right to convert to level value
                        }
                    }else{
                        //do nothing
                    }
                    if (needRoundAmount){
                        dFoodSupplyAmount = round(dFoodSupplyAmount);
                    }
                    
                    if (!needAmountToLevel){
                        if (dMaxFoodAdequateAmount == 0){
                            if (dFoodSupplyAmount > 0 && dFoodSupplyAmount <= Config_foodUpperLimit){
                                dMaxFoodAdequateAmount = dFoodSupplyAmount;
                                nutrientToMaxFoodAdequateAmount = columnNameNutrient;
                                
                                dMinFoodAdequateAmount = dFoodSupplyAmount;
                                nutrientToMinFoodAdequateAmount = columnNameNutrient;
                            }
                        }else{//dMaxFoodAdequateAmount > 0
                            if (dFoodSupplyAmount > 0 && dFoodSupplyAmount <= Config_foodUpperLimit){
                                if (dMaxFoodAdequateAmount < dFoodSupplyAmount){
                                    dMaxFoodAdequateAmount = dFoodSupplyAmount;
                                    nutrientToMaxFoodAdequateAmount = columnNameNutrient;
                                }
                                if (dMinFoodAdequateAmount > dFoodSupplyAmount){
                                    dMinFoodAdequateAmount = dFoodSupplyAmount;
                                    nutrientToMinFoodAdequateAmount = columnNameNutrient;
                                }
                            }
                        }
                    }
                    
                    [fsdRow addObject:[NSNumber numberWithDouble:dFoodSupplyAmount]];
                }
            }//NOT if (nutrientDRI == nil)
        }//for j
        if (!needAmountToLevel){
            if (nutrientToMaxFoodAdequateAmount != nil){
                assert(dMaxFoodAdequateAmount>0);
                fsdRow[1] = [NSNumber numberWithDouble:dMinFoodAdequateAmount];
                fsdRow[2] = nutrientToMinFoodAdequateAmount;
                fsdRow[3] = [NSNumber numberWithDouble:dMaxFoodAdequateAmount];
                fsdRow[4] = nutrientToMaxFoodAdequateAmount;
            }
        }
        [rows2D addObject:fsdRow];
    }//for i
    
    NSMutableDictionary *retData = [NSMutableDictionary dictionaryWithCapacity:2];
    [retData setObject:allColumns forKey:@"columnNames"];
    [retData setObject:rows2D forKey:@"rows2D"];
    return retData;
}



-(void)generateTableAndData_Food_Supply_DRIUL_Amount_withIfNeedClearTable:(BOOL)needClear
{
    NSDictionary *data = [self generateData_Food_Supply_DRIUL_Amount];
    NSArray *columnNames = [data objectForKey:@"columnNames"];
    NSArray *rows2D = [data objectForKey:@"rows2D"];
    NSString *tableName = TABLE_NAME_Food_Supply_DRIUL_Amount;
    NSString *primaryKey = COLUMN_NAME_NDB_No;
    [self createTable_withTableName:tableName withColumnNames:columnNames withRows2D:rows2D withPrimaryKey:primaryKey andIfNeedDropTable:needClear];
    [self insertToTable_withTableName:tableName withColumnNames:columnNames andRows2D:rows2D andIfNeedClearTable:needClear];
}
/*
 这个工具用来生成每个食物要供给每个营养素到上限的量，并找出单个食物供给每个营养素到上限的量的最小值，这个最小值的作用是如果这个食物的供给量不超过这个值时，就不会导致任一营养素超上限。
 */
-(NSMutableDictionary*)generateData_Food_Supply_DRIUL_Amount
{
    BOOL needRoundAmount = TRUE;

    NSArray * allNutrientAry = [self getAllNutrientColumns];
    NSMutableArray *allColumns = [NSMutableArray arrayWithObjects:COLUMN_NAME_NDB_No,COLUMN_NAME_MinUpperAmount,COLUMN_NAME_NutrientID, nil];
    [allColumns addObjectsFromArray:allNutrientAry];
    

    NSDictionary *foodNutritionData = [self getAllDataOfTable:VIEW_NAME_FoodNutritionCustom];
    NSArray *foodNutritionDataCols = [foodNutritionData objectForKey:@"cols"];
    NSArray *foodNutritionDataRows = [foodNutritionData objectForKey:@"rows"];
    assert(foodNutritionDataRows.count>100);
   
    
    NSDictionary *DRIULdata = [self.class getStandardDRIULs:0 age:19 weight:75 height:175 activityLevel:0 andDBcon:self];
    
    NSMutableArray *rows2D = [NSMutableArray arrayWithCapacity:foodNutritionDataRows.count];
    for(int i=0; i<foodNutritionDataRows.count; i++){
        NSDictionary *foodNutritionDataRowDict = foodNutritionDataRows[i];
        NSMutableArray *fsdRow = [NSMutableArray arrayWithCapacity:foodNutritionDataCols.count];
        [fsdRow addObject:[foodNutritionDataRowDict objectForKey:COLUMN_NAME_NDB_No]];
        [fsdRow addObject:[NSNumber numberWithDouble:0]];
        [fsdRow addObject:@""];

        double dMinFoodSupplyAmount = 0;
        NSString *nutrientToMinFood = @"";
        for(int j=0; j<allNutrientAry.count; j++){
            NSString *columnNameNutrient = allNutrientAry[j];
            
            id nutrientDRIUL = [DRIULdata objectForKey:columnNameNutrient];
            if (nutrientDRIUL == nil){
                [fsdRow addObject:[NSNumber numberWithInt:0]];//没有 DRI ul，没法计算
            }else{//NOT if (nutrientDRIUL == nil)
                NSNumber *nmNutrientDRIUL = (NSNumber*)nutrientDRIUL;
                if ([nmNutrientDRIUL doubleValue]<=0){
                    [fsdRow addObject:[NSNumber numberWithInt:0]];//没有 DRI ul，没法计算
                }else{//NOT if ([nmNutrientDRIUL doubleValue]<=0)
                    NSNumber *nmFoodNutrientAmount = [foodNutritionDataRowDict objectForKey:columnNameNutrient];
                    assert(nmFoodNutrientAmount!=nil);
                    if ([nmFoodNutrientAmount doubleValue]==0.0){//food的营养成分含量为0，也没法计算
                        [fsdRow addObject:[NSNumber numberWithInt:0]];
                    }else{
                        double dFoodSupplyAmount = [nmNutrientDRIUL doubleValue]/[nmFoodNutrientAmount doubleValue] * 100.0;
                        if (dFoodSupplyAmount >= 10000)
                            dFoodSupplyAmount = 0;//这个食物要10000g才能超过营养素的上限，不用担心了。
                        if (needRoundAmount){
                            dFoodSupplyAmount = round(dFoodSupplyAmount);
                        }
                        if (![NutrientId_Magnesium isEqualToString:columnNameNutrient]){
                            if (dMinFoodSupplyAmount == 0){
                                dMinFoodSupplyAmount = dFoodSupplyAmount;
                                nutrientToMinFood = columnNameNutrient;
                            }else if (dFoodSupplyAmount > 0 && dMinFoodSupplyAmount > dFoodSupplyAmount){
                                dMinFoodSupplyAmount = dFoodSupplyAmount;
                                nutrientToMinFood = columnNameNutrient;
                            }
                        }
                        [fsdRow addObject:[NSNumber numberWithDouble:dFoodSupplyAmount]];
                    }
                }//NOT if ([nmNutrientDRIUL doubleValue]<=0)
            }//NOT if (nutrientDRIUL == nil)
        }//for j
        fsdRow[1] = [NSNumber numberWithDouble:dMinFoodSupplyAmount];
        fsdRow[2] = nutrientToMinFood;
        [rows2D addObject:fsdRow];
    }//for i
    
    NSMutableDictionary *retData = [NSMutableDictionary dictionaryWithCapacity:2];
    [retData setObject:allColumns forKey:@"columnNames"];
    [retData setObject:rows2D forKey:@"rows2D"];
    return retData;

}











/*
 sex:0 for male.  weight kg, height cm
 */
+(NSDictionary*)getStandardDRIForSex:(int )sex age:(int)age weight:(float)weight height:(float)height activityLevel:(int )activityLevel
{
    float PA;
    float heightM = height/100.f;
    int energyStandard;
    int carbohydrtStandard;
    int fatStandard;
    int proteinStandard;
    if (sex == 0)//male
    {
        if (age>=1 && age<3)
        {
            energyStandard = 89*weight-100+20;
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
            energyStandard = 88.5 - 61.9*age +PA*(26.7 *weight +903*heightM)+20;
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
            
            energyStandard = 88.5 - 61.9*age +PA*(26.7 *weight +903*heightM)+25;
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
            
            energyStandard = 662 - 9.53*age +PA*(15.91 *weight +539.6*heightM);
        }
        
    }
    else//female
    {
        if (age>=1 && age<3)
        {
            energyStandard = 89*weight-100+20;
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
            
            energyStandard = 135.3 - 30.8*age +PA*(10 *weight +934*heightM)+20;
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
            
            energyStandard = 135.3 - 30.8*age +PA*(10 *weight +934*heightM)+25;
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
            
            energyStandard = 354 - 6.91*age +PA*(9.36 *weight +726*heightM);
        }
        
        
    }
    //self.energyStandardLabel.text = [NSString stringWithFormat:@"%d kcal",energyStandard];
    
    carbohydrtStandard = (int)(energyStandard*0.45*kCarbFactor+0.5);//(int)(energyStandard*0.65*kCarbFactor+0.5);
    
    if (age>=1 && age<4)
    {
        fatStandard = 0;//[NSString stringWithFormat:@"0 ~ %d", (int)(energyStandard*0.4*kFatFactor+0.5)];
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
    
    float proteinFactor;
    
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
    NSLog(@"getStandardDRIForSex ret: energyStandard : %d \n Carbohydrt : %d \n Fat : %d \n Protein : %d",energyStandard,carbohydrtStandard,fatStandard,proteinStandard);
    NSDictionary *standardResult = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:energyStandard],@"Energ_Kcal",[NSNumber numberWithInt:carbohydrtStandard],@"Carbohydrt_(g)",[NSNumber numberWithInt:fatStandard],@"Lipid_Tot_(g)",[NSNumber numberWithInt:proteinStandard],@"Protein_(g)",nil];
    return standardResult;
}


+(NSDictionary*)getStandardDRIs:(int)sex age:(int)age weight:(float)weight height:(float)height activityLevel:(int )activityLevel andDBcon:(LZDBAccess *)da
{
    NSDictionary *part1 = [self getStandardDRIForSex:sex age:age weight:weight height:height activityLevel:activityLevel];
    //LZDBAccess *da = self;
    NSString *gender = @"male";
    if (sex !=0)
        gender = @"female";
    NSDictionary *part2 = [da getDRIbyGender:gender andAge:age];
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithDictionary:part1];
    [ret addEntriesFromDictionary:part2];
    NSLog(@"getStandardDRIs ret:\n%@",ret);
    return ret;
}




/*
 范围数值参考5_Summary Table Tables 1-4.pdf 也就是Dietary Reference Intakes: The Essential Guide to Nutrient Requirements（http://nal.usda.gov/fnic/DRI/Essential_Guide/DRIEssentialGuideNutReq.pdf）的PART II ENERGY, MACRONUTRIENTS,WATER, AND PHYSICAL ACTIVITY
 验证正确性是在http://fnic.nal.usda.gov/fnic/interactiveDRI/ usda的DRI计算器
 先计算出energy摄入推荐量，然后根据数值范围得出 碳水化合物和脂肪的上限值，蛋白质和能量的上限值暂时设为-1
 */


+(NSDictionary*)getStandardDRIULForSex:(int )sex age:(int)age weight:(float)weight height:(float)height activityLevel:(int )activityLevel
{
    float PA;
    float heightM = height/100.f;
    int energyStandard;
    int energyUL = -1;
    int proteinUL = -1;
    int carbohydrtUL;
    int fatUL;
    if (sex == 0)//male
    {
        if (age>=1 && age<3)
        {
            energyStandard = 89*weight-100+20;
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
            energyStandard = 88.5 - 61.9*age +PA*(26.7 *weight +903*heightM)+20;
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
            
            energyStandard = 88.5 - 61.9*age +PA*(26.7 *weight +903*heightM)+25;
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
            
            energyStandard = 662 - 9.53*age +PA*(15.91 *weight +539.6*heightM);
        }
        
    }
    else//female
    {
        if (age>=1 && age<3)
        {
            energyStandard = 89*weight-100+20;
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
            
            energyStandard = 135.3 - 30.8*age +PA*(10 *weight +934*heightM)+20;
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
            
            energyStandard = 135.3 - 30.8*age +PA*(10 *weight +934*heightM)+25;
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
            
            energyStandard = 354 - 6.91*age +PA*(9.36 *weight +726*heightM);
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
    
    NSLog(@"getStandardUL : energyStandard : %d \n Carbohydrt : %d \n Fat : %d \n Protein : %d",energyUL,carbohydrtUL,fatUL,proteinUL);
    NSDictionary *ULResult = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:energyUL],@"Energ_Kcal",[NSNumber numberWithInt:carbohydrtUL],@"Carbohydrt_(g)",[NSNumber numberWithInt:fatUL],@"Lipid_Tot_(g)",[NSNumber numberWithInt:proteinUL],@"Protein_(g)",nil];
    return ULResult;
}




- (NSDictionary *)getDRIULbyGender:(NSString*)gender andAge:(int)age {
    NSString *tableName = TABLE_NAME_DRIULMale;
    if ([@"female" isEqualToString:gender]){
        tableName = TABLE_NAME_DRIULFemale;
    }
    
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*1];
    [sqlStr appendString:@"SELECT * FROM "];
    [sqlStr appendString:tableName];
    [sqlStr appendString:@" WHERE Start <= ? "];
    [sqlStr appendString:@" ORDER BY Start desc"];
    
    NSArray * argAry = [NSArray arrayWithObjects:[NSNumber numberWithInt:age], nil];
    NSDictionary *rowDict = nil;
    FMResultSet *rs = [_db executeQuery:sqlStr withArgumentsInArray:argAry];
    if ([rs next]) {
        rowDict = rs.resultDictionary;
    }
    //    NSLog(@"getDRIULbyGender get:\n%@",rowDict);
    NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithDictionary:rowDict];
    [retDict removeObjectForKey:@"Start"];
    [retDict removeObjectForKey:@"End"];
    NSLog(@"getDRIULbyGender ret:\n%@",retDict);
    return retDict;
}




+(NSDictionary*)getStandardDRIULs:(int)sex age:(int)age weight:(float)weight height:(float)height activityLevel:(int)activityLevel andDBcon:(LZDBAccess *)da
{
    NSDictionary *part1 = [self getStandardDRIULForSex:sex age:age weight:weight height:height activityLevel:activityLevel];
//    LZDataAccess *da = [LZDataAccess singleton];
    NSString *gender = @"male";
    if (sex !=0)
        gender = @"female";
    NSDictionary *part2 = [da getDRIULbyGender:gender andAge:age];
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithDictionary:part1];
    [ret addEntriesFromDictionary:part2];
    
//    if (needConsiderLoss){
//        ret = [self letDRIULConsiderLoss:ret];
//    }
    
    NSLog(@"getStandardDRIULs ret:\n%@",ret);
    return ret;
}



//------------------------

/*
 用以支持得到nutrients的信息数据，并可以通过普通的nutrient的列名取到相应的nutrient信息。
 */
-(NSMutableDictionary*)getNutrientInfoAs2LevelDictionary_withNutrientIds:(NSArray*)nutrientIds
{
    NSLog(@"getNutrientInfoAs2LevelDictionary_withNutrientIds begin");
    
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*100];
    [sqlStr appendString:@"SELECT * FROM NutritionInfo"];
    if (nutrientIds!=nil && nutrientIds.count >0){
        NSMutableArray *placeholderAry = [NSMutableArray arrayWithCapacity:nutrientIds.count];
        for(int i=0; i<nutrientIds.count; i++){
            [placeholderAry addObject:@"?"];
        }
        NSString *placeholdersStr = [placeholderAry componentsJoinedByString:@","];
        
        [sqlStr appendString:@"  WHERE NutrientID in ("];
        [sqlStr appendString:placeholdersStr];
        [sqlStr appendString:@")"];
    }
    
    FMResultSet *rs = [_db executeQuery:sqlStr withArgumentsInArray:nutrientIds];
    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];
    NSMutableDictionary *dic2Level = [LZUtility dictionaryArrayTo2LevelDictionary_withKeyName:@"NutrientID" andDicArray:dataAry];
    
    NSLog(@"getNutrientInfoAs2LevelDictionary_withNutrientIds ret:\n%@",dic2Level);
    return dic2Level;
}

-(NSMutableArray*) getFoods_withColumns_richOfNutrient:(NSString *)nutrientAsColumnName
{
    NSLog(@"getRichNutritionFood enter");
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*1];
    //看来如果sql语句中用了view，会有FL.[Lower_Limit(g)]等某些列整个成为列名,而且就算是[Lower_Limit(g)]，也还会保留[].而如果没有用到view，则Lower_Limit(g)是列名
    [sqlStr appendFormat:@"SELECT a.NDB_No, c.CnCaption, f.Shrt_Desc, f.[%@], a.[%@] as Amount ",nutrientAsColumnName,nutrientAsColumnName];
    [sqlStr appendString:@"\n  FROM Food_Supply_DRI_Amount a "];
    [sqlStr appendString:@"\n      join FoodCustom c on a.NDB_No=c.NDB_No "];
    [sqlStr appendString:@"\n      join FoodNutrition f on c.NDB_No=f.NDB_No "];
    
    [sqlStr appendString:@"\n  WHERE "];
    [sqlStr appendFormat:@"\n    a.[%@]>0 AND a.[%@]<=1000",nutrientAsColumnName,nutrientAsColumnName];
    
    [sqlStr appendFormat:@"\n  ORDER BY a.[%@] ASC",nutrientAsColumnName];
    
    NSLog(@"getRichNutritionFood sqlStr=%@",sqlStr);
    
    NSDictionary *retData = [self queryDataAndMetaDataBySelectSql:sqlStr];
    NSMutableArray *columnNames = retData[@"columnNames"];
    NSMutableArray *rows2D = retData[@"rows2D"];
    if (columnNames.count > 0)    [rows2D insertObject:columnNames atIndex:0];
    return rows2D;
}

- (NSArray *)selectAllForTable:(NSString *)tableName andOrderBy:(NSString *)partOrderBy
{
    NSMutableString *query = [NSMutableString stringWithFormat: @"SELECT * FROM %@",tableName];
    if (partOrderBy.length > 0){
        [query appendFormat:@" %@",partOrderBy ];
    }
    FMResultSet *rs = [_db executeQuery:query];
    NSArray *ary = [[self class] FMResultSetToDictionaryArray:rs];
    return ary;
}
-(NSSet*)getCustomRichFood_1LevelSet
{
    NSArray *rows = [self selectAllForTable:TABLE_NAME_CustomRichFood andOrderBy:nil];
    NSMutableSet * set1Level = [NSMutableSet set];
    for(int i=0; i<rows.count; i++){
        NSDictionary *row = rows[i];
        NSString *nutrientId = row[COLUMN_NAME_NutrientID];
        NSString *foodId = row[COLUMN_NAME_NDB_No];
        assert(nutrientId.length>0 && foodId.length>0);
        NSString *key = [NSString stringWithFormat:@"%@:%@",nutrientId,foodId];
        [set1Level addObject:key];
    }//for
    return set1Level;
}

-(NSMutableArray*) getFoods_withColumns_richOfNutrientOfAll
{
    NSArray * nutrients = [LZRecommendFood getDRItableNutrientsWithSameOrder];
    NSDictionary * nutrientInfoDict = [self getNutrientInfoAs2LevelDictionary_withNutrientIds:nutrients];
    NSSet * richFoodSet = [self getCustomRichFood_1LevelSet];
    
    int columnCount= 5;
    NSMutableArray *rowForInit = [NSMutableArray arrayWithCapacity:columnCount];
    for(int i=0; i<columnCount; i++){
        [rowForInit addObject:[NSNull null]];
    }
    
    NSMutableArray* row;
    NSMutableArray *rows2Dall = [NSMutableArray arrayWithCapacity:1000];
    row = [NSMutableArray arrayWithArray:rowForInit];
    row[4] = @"choose";
    [rows2Dall addObject:row ];
    for(int i=0 ; i<nutrients.count; i++){
        NSString *nutrient = nutrients[i];
        NSDictionary *nutrientInfo = nutrientInfoDict[nutrient];
        row = [NSMutableArray arrayWithArray:rowForInit];
        row[0] = nutrient;
        if (nutrientInfo != nil) row[1] = nutrientInfo[COLUMN_NAME_NutrientCnCaption];
        [rows2Dall addObject:row ];
        
        NSArray *rows2D = [self getFoods_withColumns_richOfNutrient:nutrient];
        if (rows2D.count > 0){
//            [rows2Dall addObjectsFromArray:rows2D];
            assert(rows2D.count>=2);
            row = rows2D[0];
            NSMutableArray *row2 = [NSMutableArray arrayWithArray:row];
            [row2 addObject:@"choose"];
            [rows2Dall addObject:row2];
            
            for(int j=1; j<rows2D.count; j++){
                row = rows2D[j];
                assert(row.count==columnCount);
                NSString *foodId = row[0];
                NSMutableArray *row2 = [NSMutableArray arrayWithArray:row];

                NSString *key = [NSString stringWithFormat:@"%@:%@",nutrient,foodId];
                if ([richFoodSet containsObject:key]){
                    [row2 addObject:@"1"];
                }else{
                    [row2 addObject:@""];
                }
                [rows2Dall addObject:row2];
            }//for
        }
        [rows2Dall addObject:rowForInit];
    }
    return rows2Dall;
}



-(NSDictionary*)queryDataAndMetaDataBySelectSql:(NSString*)sqlSelect
{
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


-(NSString *)convertRichFoodsOfEveryNutrientsToCsv_withCsvFileName:(NSString*)csvFileName
{
    NSArray *rows2D = [self getFoods_withColumns_richOfNutrientOfAll];
    return [LZUtility convert2DArrayToCsv:csvFileName withColumnNames:nil andRows2D:rows2D];
}


-(NSString *)convertSelectSqlToCsv_withSelectSql:(NSString*)sqlSelect andCsvFileName:(NSString*)csvFileName
{
    NSDictionary* data = [self queryDataAndMetaDataBySelectSql:sqlSelect];
    NSArray *columnNames = [data objectForKey:@"columnNames"];
    NSArray *rows2D = [data objectForKey:@"rows2D"];
    
    return [LZUtility convert2DArrayToCsv:csvFileName withColumnNames:columnNames andRows2D:rows2D];
}

/*
 把Food_Supply_DRI_Amount中的内容，以及食物的中文描述导出成一个csv文件。
 注意调用前需要Food_Supply_DRI_Amount表中已经有数据。
 虽然似乎可以通过sqlite的客户端工具进行，但是时不时出程序死掉的问题，还是自己做了个工具。
 */
-(NSString*)convertFood_Supply_DRI_AmountWithExtraInfoToCsv:(NSString*)csvFileName
{
    NSString *sqlQuery = @""
    "select c.classify, c.CnType, c.CnCaption, fn.Shrt_Desc, a.*"
    "  from Food_Supply_DRI_Amount a join FoodCustom c on a.NDB_No=c.NDB_No"
    "    join FoodNutrition fn on a.NDB_No=fn.NDB_No"
    "  order by a.NDB_No"
    ;
    return [self convertSelectSqlToCsv_withSelectSql:sqlQuery andCsvFileName:csvFileName];
}

-(NSString*)convertFood_Supply_DRIUL_AmountWithExtraInfoToCsv:(NSString*)csvFileName
{
    NSString *sqlQuery = @""
    "select c.classify, c.CnType, c.CnCaption, fn.Shrt_Desc, a.*"
    "  from Food_Supply_DRIUL_Amount a join FoodCustom c on a.NDB_No=c.NDB_No"
    "    join FoodNutrition fn on a.NDB_No=fn.NDB_No"
    "  order by a.NDB_No"
    ;
    return [self convertSelectSqlToCsv_withSelectSql:sqlQuery andCsvFileName:csvFileName];
}

/*
 //结合FoodCustom和FoodNutrition表中的内容导出成一个csv文件。这个文件的数据实际上与Food.xls相同。
 现在可以通过FoodNutritionCustom 的view来得到了。
 这需要先做工作保证那两张表在同一个sqlite文件中。
 有了这个工具后，Food.xls就只需提供FoodCustom所需列，而不必担心看FoodNutrition表对应的excel档缺乏中文信息了。
 虽然似乎可以通过sqlite的客户端工具进行，但是时不时出程序死掉的问题，还是自己做了个工具。
 */
-(NSString*)convertCnFoodNutritionWithExtraInfoToCsv:(NSString*)csvFileName
{
    NSString *sqlQuery = @""
//    "select c.CnCaption, c.CnType, c.classify, f.*"
//    "  from FoodNutrition f join FoodCustom c on f.NDB_No=c.NDB_No"
//    "  order by f.NDB_No"
//    ;
    "select c.*,f.* from FoodCustom c join FoodNutrition f on c.NDB_No=f.NDB_No"
    "  order by NDB_No"
    ;
    return [self convertSelectSqlToCsv_withSelectSql:sqlQuery andCsvFileName:csvFileName];
}
















/*
 单条语句暂且不管transaction的问题，假定不抛exception，在返回false值后让外层判断来rollback
 return auto increment id value
 */
-(NSNumber*)insertFoodCollocation_withName:(NSString*)collationName
{
    NSDate *dtNow = [NSDate date];
    long long llms = [LZUtility getMillisecond:dtNow];
    
    NSString *insertSql = [NSString stringWithFormat:
                           @"  INSERT INTO FoodCollocation (CollocationName, CollocationCreateTime) VALUES (?,?);"
                           ];
    NSArray *paramAry = [NSArray arrayWithObjects:collationName, [NSNumber numberWithLongLong:llms],nil];
    BOOL dbopState = [_db executeUpdate:insertSql error:nil withArgumentsInArray:paramAry];
    NSNumber *nmAutoIncrColumnValue = nil;
    if (dbopState){
        NSString *sql = @"select last_insert_rowid();";
        FMResultSet *rs = [_db executeQuery:sql];
        if ([rs next]) {
            NSArray *resultArray = rs.resultArray;
            assert(resultArray.count>0);
            nmAutoIncrColumnValue = resultArray[0];
        }
    }
    return nmAutoIncrColumnValue;
}
/*
 单条语句暂且不管transaction的问题，假定不抛exception，在返回false值后让外层判断来rollback
 */
-(BOOL)updateFoodCollocationName:(NSString*)collationName byId:(NSNumber*)nmCollocationId
{
    NSString *updSql = [NSString stringWithFormat:
                        @" UPDATE FoodCollocation SET CollocationName=? WHERE CollocationId=?;"
                        ];
    NSArray *paramAry = [NSArray arrayWithObjects:collationName, nmCollocationId,nil];
    BOOL dbopState = [_db executeUpdate:updSql error:nil withArgumentsInArray:paramAry];
    return dbopState;
}
-(BOOL)updateFoodCollocationTime:(long long)collationTime byId:(NSNumber*)nmCollocationId
{
    NSString *updSql = [NSString stringWithFormat:
                        @" UPDATE FoodCollocation SET CollocationCreateTime=? WHERE CollocationId=?;"
                        ];
    NSNumber *nm_collationTime = [NSNumber numberWithLongLong:collationTime];
    NSArray *paramAry = [NSArray arrayWithObjects:nm_collationTime, nmCollocationId,nil];
    BOOL dbopState = [_db executeUpdate:updSql error:nil withArgumentsInArray:paramAry];
    return dbopState;
}
//-(BOOL)deleteFoodCollocationById:(NSNumber*)nmCollocationId
//{
//    return [self deleteTableByEqualFilter_withTableName:TABLE_NAME_FoodCollocation andField:COLUMN_NAME_CollocationId andValue:nmCollocationId];
//}
/*
 单条语句暂且不管transaction的问题，假定不抛exception，在返回false值后让外层判断来rollback
 */
//-(NSDictionary*)getFoodCollocationById:(NSNumber*)nmCollocationId
//{
//    NSArray *rows = [self selectTableByEqualFilter_withTableName:TABLE_NAME_FoodCollocation andField:COLUMN_NAME_CollocationId andValue:nmCollocationId];
//    
//    NSDictionary *rowDict = nil;
//    if (rows.count > 0){
//        rowDict = rows[0];
//    }
//    return rowDict;
//}

//-(NSArray*)getAllFoodCollocation
//{
//    //    NSArray * rows = [self selectAllForTable:TABLE_NAME_FoodCollocation andOrderBy:@" ORDER BY CollocationCreateTime DESC"];
//    NSArray * rows = [self selectAllForTable:TABLE_NAME_FoodCollocation andOrderBy:nil];
//    return rows;
//}


//-(NSArray*)getCollocationFoodData_withCollocationId:(NSNumber*)nmCollocationId
//{
//    return [self selectTableByEqualFilter_withTableName:TABLE_NAME_CollocationFood andField:COLUMN_NAME_CollocationId andValue:nmCollocationId
//                                             andColumns:[NSArray arrayWithObjects:COLUMN_NAME_FoodId,COLUMN_NAME_FoodAmount, nil]];
//}
/*
 单条语句暂且不管transaction的问题，假定不抛exception，在返回false值后让外层判断来rollback
 */
-(BOOL)deleteCollocationFoodData_withCollocationId:(NSNumber*)nmCollocationId
{
    return [self deleteTableByEqualFilter_withTableName:TABLE_NAME_CollocationFood andField:COLUMN_NAME_CollocationId andValue:nmCollocationId];
}

/*
 单条语句暂且不管transaction的问题，假定不抛exception，在返回false值后让外层判断来rollback
 */
-(BOOL)insertCollocationFood_withCollocationId:(NSNumber*)nmCollocationId andFoodId:(NSString*)foodId andFoodAmount:(NSNumber*)foodAmount
{
    NSString *insertSql = [NSString stringWithFormat:
                           @"INSERT INTO CollocationFood (CollocationId, FoodId, FoodAmount) VALUES (?,?,?);"
                           ];
    NSArray *paramAry = [NSArray arrayWithObjects:nmCollocationId, foodId, foodAmount, nil];
    BOOL dbopState = [_db executeUpdate:insertSql error:nil withArgumentsInArray:paramAry];
    return dbopState;
}
-(BOOL)insertCollocationFoods_withCollocationId:(NSNumber*)nmCollocationId andFoodAmount2LevelArray:(NSArray*)foodAmount2LevelArray andNeedTransaction:(BOOL)needTransaction andOuterTransactionExist:(BOOL)outerTransactionExist
{
    if (needTransaction && !outerTransactionExist){
        [_db beginTransaction];//here created transaction
    }
    
    for(int i=0; i<foodAmount2LevelArray.count; i++){
        NSArray *foodAndAmount = foodAmount2LevelArray[i];
        NSString *foodId = foodAndAmount[0];
        NSNumber *nmFoodAmount = foodAndAmount[1];
        BOOL dbopState = [self insertCollocationFood_withCollocationId:nmCollocationId andFoodId:foodId andFoodAmount:nmFoodAmount];
        if (!dbopState){
            if (needTransaction){
                [_db rollback];
            }
            return false;
        }
    }
    
    if (needTransaction){
        if (!outerTransactionExist){
            [_db commit];//transaction is created here, so need commit here
        }else{
            //let outer codes commit
        }
    }
    return true;
}


-(NSNumber *)insertFoodCollocationData_withCollocationName:(NSString*)collationName andFoodAmount2LevelArray:(NSArray*)foodAmount2LevelArray andNeedTransaction:(BOOL)needTransaction andOuterTransactionExist:(BOOL)outerTransactionExist
{
    BOOL nowTransactionExist = outerTransactionExist;
    if (needTransaction){
        if (!outerTransactionExist){
            [_db beginTransaction];//here created transaction
            nowTransactionExist = true;
        }
    }
    
    
    NSNumber *nmCollocationId = [self insertFoodCollocation_withName:collationName];
    if (nmCollocationId==nil){
        if (needTransaction)
            [_db rollback];
        return nil;
    }
    BOOL dbopState =[self insertCollocationFoods_withCollocationId:nmCollocationId andFoodAmount2LevelArray:foodAmount2LevelArray andNeedTransaction:needTransaction andOuterTransactionExist:nowTransactionExist];
    if (!dbopState){
        if (needTransaction)
            //[dbfm rollback];//should not rollback here because inner codes has rollbacked.
            return nil;
    }
    
    if (needTransaction){
        if (!outerTransactionExist){
            [_db commit];//transaction is created here, so need commit here
        }else{
            //let outer codes commit
        }
    }
    return nmCollocationId;
}
-(NSNumber *)insertFoodCollocationData_withCollocationName:(NSString*)collationName andFoodAmount2LevelArray:(NSArray*)foodAmount2LevelArray
{
    assert(collationName.length > 0);
    return [self insertFoodCollocationData_withCollocationName:collationName andFoodAmount2LevelArray:foodAmount2LevelArray andNeedTransaction:true andOuterTransactionExist:false];
}

//
//-(BOOL)updateFoodCollocationData_withCollocationId:(NSNumber*)nmCollocationId andNewCollocationName:(NSString*)collocationName andFoodAmount2LevelArray:(NSArray*)foodAmount2LevelArray andNeedTransaction:(BOOL)needTransaction andOuterTransactionExist:(BOOL)outerTransactionExist
//{
//    BOOL nowTransactionExist = outerTransactionExist;
//    if (needTransaction){
//        if (!outerTransactionExist){
//            [_db beginTransaction];//here created transaction
//            nowTransactionExist = true;
//        }
//    }
//    BOOL dbopState = false;
//    if (collocationName.length > 0){
//        dbopState = [self updateFoodCollocationName:collocationName byId:nmCollocationId];
//        if (!dbopState){
//            if (needTransaction)
//                [_db rollback];
//            return false;
//        }
//    }
//    
//    dbopState = [self deleteCollocationFoodData_withCollocationId:nmCollocationId];
//    if (!dbopState){
//        if (needTransaction)
//            [_db rollback];
//        return false;
//    }
//    dbopState =[self insertCollocationFoods_withCollocationId:nmCollocationId andFoodAmount2LevelArray:foodAmount2LevelArray andNeedTransaction:needTransaction andOuterTransactionExist:nowTransactionExist];
//    if (!dbopState){
//        if (needTransaction)
//            //[dbfm rollback];//should not rollback here because inner codes has rollbacked.
//            return false;
//    }
//    
//    NSDate *dtNow = [NSDate date];
//    long long llmsNow = [LZUtility getMillisecond:dtNow];
//    dbopState = [self updateFoodCollocationTime:llmsNow byId:nmCollocationId];
//    if (!dbopState){
//        if (needTransaction)
//            [_db rollback];
//        return false;
//    }
//    
//    if (needTransaction){
//        if (!outerTransactionExist){
//            [_db commit];//transaction is created here, so need commit here
//        }else{
//            //let outer codes commit
//        }
//    }
//    return true;
//}

/*
 如果 collocationName 为nil，则不改name。
 */
//-(BOOL)updateFoodCollocationData_withCollocationId:(NSNumber*)nmCollocationId andNewCollocationName:(NSString*)collocationName andFoodAmount2LevelArray:(NSArray*)foodAmount2LevelArray
//{
//    return [self updateFoodCollocationData_withCollocationId:nmCollocationId andNewCollocationName:collocationName andFoodAmount2LevelArray:foodAmount2LevelArray andNeedTransaction:true andOuterTransactionExist:false];
//}

//-(NSDictionary*)getFoodCollocationData_withCollocationId:(NSNumber*)nmCollocationId
//{
//    NSDictionary * rowFoodCollocation = [self getFoodCollocationById:nmCollocationId];
//    NSArray *foodAndAmountArray = [self getCollocationFoodData_withCollocationId:nmCollocationId];
//    NSMutableDictionary *retDict = [NSMutableDictionary dictionary];
//    if (rowFoodCollocation!=nil)
//        [retDict setObject:rowFoodCollocation forKey:@"rowFoodCollocation"];
//    if (foodAndAmountArray!=nil)
//        [retDict setObject:foodAndAmountArray forKey:@"foodAndAmountArray"];
//    NSLog(@"getFoodCollocationData_withCollocationId %@ return:\n%@",nmCollocationId,retDict);
//    return retDict;
//}

//-(BOOL)deleteFoodCollocationData_withCollocationId:(NSNumber*)nmCollocationId
//{
//    BOOL dbopState1 = [self deleteFoodCollocationById:nmCollocationId];
//    BOOL dbopState2 = [self deleteCollocationFoodData_withCollocationId:nmCollocationId];
//    return dbopState1 && dbopState2;
//}

















@end







































