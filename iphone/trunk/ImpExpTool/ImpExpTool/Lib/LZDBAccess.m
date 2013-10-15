
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
    LZDataAccess *_da;
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

-(LZDataAccess*)da{
    return _da;
}




- (void)close
{
    if (_db != nil)
        [_db close];

}




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
    _da = [[LZDataAccess alloc] init_withDBcon:_db];
    if (![_db open]) {
        _db = nil;
        //[db release];
        //return;
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
    [_da createTable_withTableName:tableName withColumnNames:columnNames withPrimaryKey:primaryKey andIfNeedDropTable:needDrop];
}

/*
 USDAtable 是特指美国农业部的那份以excel格式存在的数据库的唯一一个各食物营养成分表。这里暂定其表名为FoodNutrition。
 其中对于每个列名两头加了单引号以作为显式的字符串列名以防止其中的特殊字符导致出错。
 rows是一个二维数组。其中的每个单个row的位置都对应columnNames。
 */
-(void)insertToTable_USDA_ABBREV_withColumnNames: (NSArray*)columnNames andRows2D:(NSArray*)rows2D andIfNeedClearTable:(BOOL)needClear
{
    NSString *tableName = TABLE_NAME_USDA_ABBREV;//FoodNutrition
    [_da insertToTable_withTableName:tableName withColumnNames:columnNames andRows2D:rows2D andIfNeedClearTable:needClear];
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
    NSString *sqlStr = [_da generateInsertSqlForTable:tableName andColumnNames:columnNames];
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



-(void)getDifferenceFromFoodCustomAndFoodCustomT2
{
    NSString *sqlQuery = @"select * from FoodCustomT2 where not NDB_No in (select NDB_No from FoodCustom)";
    NSString* csvfilePath = [_da convertSelectSqlToCsv_withSelectSql:sqlQuery andCsvFileName:@"diffFoodCustomT2.csv"];
    NSLog(@"getDifferenceFromFoodCustomAndFoodCustomT2 diffFilePath = %@",csvfilePath);
}

//-------------------------------------------------









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
    [_da createTable_withTableName:tableName withColumnNames:columnNames withRows2D:rows2D withPrimaryKey:primaryKey andIfNeedDropTable:needClear];
    [_da insertToTable_withTableName:tableName withColumnNames:columnNames andRows2D:rows2D andIfNeedClearTable:needClear];
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
    [_da createTable_withTableName:tableName withColumnNames:columnNames withRows2D:rows2D withPrimaryKey:primaryKey andIfNeedDropTable:needClear];
    [_da insertToTable_withTableName:tableName withColumnNames:columnNames andRows2D:rows2D andIfNeedClearTable:needClear];
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
    
    NSDictionary *foodNutritionData = [_da getAllDataOfTable:VIEW_NAME_FoodNutritionCustom];
    NSArray *foodNutritionDataCols = [foodNutritionData objectForKey:@"cols"];
    NSArray *foodNutritionDataRows = [foodNutritionData objectForKey:@"rows"];
    assert(foodNutritionDataRows.count>100);//>0

    NSDictionary *DRIdata = [_da getStandardDRIs:0 age:19 weight:75 height:175 activityLevel:0 considerLoss:FALSE];
//    NSDictionary *DRIdata = [da getStandardDRIs:0 age:19 weight:75 height:175 activityLevel:0 andDBcon:self];
    
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

//        double dMaxFoodAdequateAmount = 0;
        NSNumber *nmMaxFoodAdequateAmount = nil;
        NSString *nutrientToMaxFoodAdequateAmount = nil;
//        double dMinFoodAdequateAmount = 0;
        NSNumber *nmMinFoodAdequateAmount = nil;
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
                    NSNumber *nmFoodSupplyAmount = [NSNumber numberWithDouble:dFoodSupplyAmount];
                    if (needAmountToLevel){
                        if ([nmFoodSupplyAmount doubleValue] > 0){
                            nmFoodSupplyAmount = [NSNumber numberWithDouble: round(([nmFoodSupplyAmount doubleValue] + 100) / 100.0) ];
                        }else{
                            //when foodSupplyAmount be 0, not right to convert to level value
                        }
                    }else{
                        //do nothing
                    }
                    if (needRoundAmount){
//                        dFoodSupplyAmount = round(dFoodSupplyAmount);
                        nmFoodSupplyAmount = [LZUtility getDecimalFromDouble:[nmFoodSupplyAmount doubleValue] withScale:2];
                        
                    }
                    
                    if (!needAmountToLevel){
                        if (nmMaxFoodAdequateAmount == nil){
                            if ([nmFoodSupplyAmount doubleValue] > 0 && [nmFoodSupplyAmount doubleValue] <= Config_foodUpperLimit){
                                nmMaxFoodAdequateAmount = nmFoodSupplyAmount;
                                nutrientToMaxFoodAdequateAmount = columnNameNutrient;
                                
                                nmMinFoodAdequateAmount = nmFoodSupplyAmount;
                                nutrientToMinFoodAdequateAmount = columnNameNutrient;
                            }
                        }else{//dMaxFoodAdequateAmount > 0
                            if ([nmFoodSupplyAmount doubleValue] > 0 && [nmFoodSupplyAmount doubleValue] <= Config_foodUpperLimit){
                                if ([nmMaxFoodAdequateAmount doubleValue] < [nmFoodSupplyAmount doubleValue]){
                                    nmMaxFoodAdequateAmount = nmFoodSupplyAmount;
                                    nutrientToMaxFoodAdequateAmount = columnNameNutrient;
                                }
                                if ([nmMinFoodAdequateAmount doubleValue] > [nmFoodSupplyAmount doubleValue]){
                                    nmMinFoodAdequateAmount = nmFoodSupplyAmount;
                                    nutrientToMinFoodAdequateAmount = columnNameNutrient;
                                }
                            }
                        }
                    }
                    
                    [fsdRow addObject:nmFoodSupplyAmount];
                }
            }//NOT if (nutrientDRI == nil)
        }//for j
        if (!needAmountToLevel){
            if (nutrientToMaxFoodAdequateAmount != nil){
                assert([nmMaxFoodAdequateAmount doubleValue]>0);
                fsdRow[1] = nmMinFoodAdequateAmount;
                fsdRow[2] = nutrientToMinFoodAdequateAmount;
                fsdRow[3] = nmMaxFoodAdequateAmount;
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
    [_da createTable_withTableName:tableName withColumnNames:columnNames withRows2D:rows2D withPrimaryKey:primaryKey andIfNeedDropTable:needClear];
    [_da insertToTable_withTableName:tableName withColumnNames:columnNames andRows2D:rows2D andIfNeedClearTable:needClear];
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
    

    NSDictionary *foodNutritionData = [_da getAllDataOfTable:VIEW_NAME_FoodNutritionCustom];
    NSArray *foodNutritionDataCols = [foodNutritionData objectForKey:@"cols"];
    NSArray *foodNutritionDataRows = [foodNutritionData objectForKey:@"rows"];
    assert(foodNutritionDataRows.count>100);
   
    
//    NSDictionary *DRIULdata = [self.class getStandardDRIULs:0 age:19 weight:75 height:175 activityLevel:0 andDBcon:self];
    NSDictionary *DRIULdata = [_da getStandardDRIULs:0 age:19 weight:75 height:175 activityLevel:0 considerLoss:FALSE];
    
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










//------------------------



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
    
    NSDictionary *retData = [_da queryDataAndMetaDataBySelectSql:sqlStr];
    NSMutableArray *columnNames = retData[@"columnNames"];
    NSMutableArray *rows2D = retData[@"rows2D"];
    if (columnNames.count > 0)    [rows2D insertObject:columnNames atIndex:0];
    return rows2D;
}


-(NSSet*)getCustomRichFood_1LevelSet
{
    NSArray *rows = [_da selectAllForTable:TABLE_NAME_CustomRichFood andOrderBy:nil];
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
    NSDictionary * nutrientInfoDict = [_da getNutrientInfoAs2LevelDictionary_withNutrientIds:nutrients];
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


-(NSString *)convertRichFoodsOfEveryNutrientsToCsv_withCsvFileName:(NSString*)csvFileName
{
    NSArray *rows2D = [self getFoods_withColumns_richOfNutrientOfAll];
    return [LZUtility convert2DArrayToCsv:csvFileName withColumnNames:nil andRows2D:rows2D];
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
    return [_da convertSelectSqlToCsv_withSelectSql:sqlQuery andCsvFileName:csvFileName];
}

-(NSString*)convertFood_Supply_DRIUL_AmountWithExtraInfoToCsv:(NSString*)csvFileName
{
    NSString *sqlQuery = @""
    "select c.classify, c.CnType, c.CnCaption, fn.Shrt_Desc, a.*"
    "  from Food_Supply_DRIUL_Amount a join FoodCustom c on a.NDB_No=c.NDB_No"
    "    join FoodNutrition fn on a.NDB_No=fn.NDB_No"
    "  order by a.NDB_No"
    ;
    return [_da convertSelectSqlToCsv_withSelectSql:sqlQuery andCsvFileName:csvFileName];
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
    return [_da convertSelectSqlToCsv_withSelectSql:sqlQuery andCsvFileName:csvFileName];
}




-(NSArray *)getFoodOriginalAttributesByIds:(NSArray *)idAry
{
    NSLog(@"getFoodOriginalAttributesByIds begin");
    if (idAry==nil || idAry.count ==0)
        return nil;
    
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*1];
    [sqlStr appendString:@"SELECT F.* FROM FoodNutrition F\n"];
    
    
//    NSMutableArray *exprIncludeORdata = [NSMutableArray array];
    NSMutableArray *exprIncludeANDdata = [NSMutableArray array];
//    NSMutableArray *exprExcludedata = [NSMutableArray array];
    
    if (idAry.count>0){
        NSString *strColumn = @"F.NDB_No";
        NSString *strOp = @"IN";
        NSMutableArray *expr = [NSMutableArray arrayWithCapacity:3];
        [expr addObject:strColumn];
        [expr addObject:strOp];
        [expr addObject:idAry];
        [exprIncludeANDdata addObject:expr];
    }
    
    NSDictionary *filters = [NSDictionary dictionaryWithObjectsAndKeys:
//                             exprIncludeORdata,@"includeOR",
                             exprIncludeANDdata,@"includeAND",
//                             exprExcludedata,@"exclude",
                             nil];
    NSArray * dataAry = [_da getRowsByQuery:sqlStr andFilters:filters andWhereExistInQuery:false andAfterWherePart:nil andOptions:nil];
    return dataAry;
}





















@end







































