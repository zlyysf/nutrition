//
//  LZReadExcel.m
//  tExcelToSqlite
//
//  Created by Yasofon on 13-4-26.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import "LZConst.h"
#import "LZReadExcel.h"

@implementation LZReadExcel


-(void)myInitDBConnectionWithFilePath: (NSString *)dbFileNameOrPath andIfNeedClear:(BOOL) needClear{
    dbCon = [[LZDBAccess alloc]init];
    [dbCon myInitWithDbFilePath:dbFileNameOrPath andIfNeedClear:needClear];
}
-(LZDBAccess*)getDBconnection
{
    return dbCon;
}
            


/*
 USDA_ABBREV 是指美国农业部的那份以excel格式存在的各食物营养成分表，
 文件本来是ABBREV.xlsx。但这里的读excel的库不支持这种格式，只能转为2003之前的格式，即.xls的。
 美国农业部（http://ndb.nal.usda.gov/  USDA National Nutrient Database）
 这里暂定其表名为FoodNutrition。
 当程序中遇到空白cell，取到的是nil值，在后面的使用会出错，这里以"0"来代替nil值。
 看来cell的序号是从1开始的，即第一个cell是(1,1).
 关于有多少行多少列的计算，这里是从第一个cell开始，往左挨个看cell，直到第一个为空的cell，这样来算列的数量。同理算行的数量。
 返回的NSDictionary包括columns对应的列名数组和rows对应的行数组，rows是一个二维数组
 */
//-(NSDictionary *)readUSDAdata
-(NSDictionary *)readUSDA_ABBREV_withDebugFlag : (BOOL)ifDebug
{
    NSString *xlsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ABBREV.xls"];
    NSLog(@"in readUSDA_ABBREV, xlsPath=%@",xlsPath);
    DHxlsReader *reader = [DHxlsReader xlsReaderFromFile:xlsPath];
	assert(reader);

    int row=1, col=1, columnCount=0,dataRowCount=0;
    DHcell *cell = nil;
    NSMutableArray * columns = [NSMutableArray arrayWithCapacity:100];
    
    cell = [reader cellInWorkSheetIndex:0 row:row col:col];
    while (cell.type != cellBlank) {
        NSString *columnCaption = cell.str;
        [columns addObject:columnCaption];
        columnCount ++;
        col++;
        cell = [reader cellInWorkSheetIndex:0 row:row col:col];
    }
    NSLog(@"in readUSDA_ABBREV, columnCount=%d, columns=%@",columnCount,columns);
    
    row = 2, col = 1;
    NSMutableArray * idAry = [NSMutableArray arrayWithCapacity:10000];
    cell = [reader cellInWorkSheetIndex:0 row:row col:col];
    while (cell.type != cellBlank) {
        [idAry addObject:cell.str];
        dataRowCount ++;
        row++;
        cell = [reader cellInWorkSheetIndex:0 row:row col:col];
        //NSLog(@"id cell .str=%@ , .val=%@\n", cell.str, cell.val);//id cell .str=80200 , .val=80200
    }
    NSLog(@"in readUSDA_ABBREV, rowCount=%d, idAry=%@",dataRowCount,idAry);
    
    //TODO 由于读excel数据相对比较慢，几千行数据要很久。测试调试时用了下面代码限制。
    if (ifDebug)
        dataRowCount = 10 ;
    
    NSMutableArray * rows2D = [NSMutableArray arrayWithCapacity:dataRowCount];
    for(int i=0; i<dataRowCount; i++){
        NSMutableArray * rowData = [NSMutableArray arrayWithCapacity:columnCount];
        for(int j=0; j<columnCount; j++){
            row = 2+i, col = 1+j;
            NSLog(@"in readUSDA_ABBREV, row=%d, col=%d",row,col);

            cell = [reader cellInWorkSheetIndex:0 row:row col:col];
            if (cell.type == cellBlank){
                [rowData addObject:@"0"];
            }else if (cell.type == cellString){
                [rowData addObject:cell.str];
            }else{
                [rowData addObject:cell.val];
            }
        }
        [rows2D addObject:rowData];
    }
    NSLog(@"in readUSDA_ABBREV, rows2D=%@",rows2D);
    
    NSMutableDictionary *retData = [NSMutableDictionary dictionaryWithCapacity:2];
    [retData setObject:columns forKey:@"columns"];
    [retData setObject:rows2D forKey:@"rows2D"];
    return retData;
}

/*
 注意由于读excel数据相对比较慢，几千行数据要很久。测试调试时在readUSDA_ABBREV中有代码限制，这里使用了ifDebug标记来控制。
 其作用是把USDA的ABBREV.xlsx中的数据导入到sqlite中，对应的表名为FoodNutrition。而USDAFullDataInSqlite.dat是一份已经导好的数据。
 */
-(void)convertExcelToSqlite_USDA_ABBREV_withDebugFlag : (BOOL)ifDebug
{
    NSDictionary *data = [self readUSDA_ABBREV_withDebugFlag:ifDebug];
    NSArray *columns = [data objectForKey:@"columns"];
    NSArray *rows2D = [data objectForKey:@"rows2D"];
    
    assert(dbCon!=nil);
    LZDBAccess *db = dbCon;
    [db createTableUSDA_ABBREV_withColumnNames:columns andIfNeedDropTable:TRUE];
    [db insertToTable_USDA_ABBREV_withColumnNames:columns andRows2D:rows2D andIfNeedClearTable:TRUE];
    
}




-(NSDictionary *)readDRIdata_fromExcelFile:(NSString *)fileName
{
    
    NSString *xlsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    NSLog(@"in readDRIdata_fromExcelFile, xlsPath=%@",xlsPath);
    DHxlsReader *reader = [DHxlsReader xlsReaderFromFile:xlsPath];
	assert(reader);
    
    int row=1, col=1, columnCount=0,dataRowCount=0;
    DHcell *cell = nil;
    NSMutableArray * columns = [NSMutableArray arrayWithCapacity:100];
    
    cell = [reader cellInWorkSheetIndex:0 row:row col:col];
    while (cell.type != cellBlank) {
        NSString *columnCaption = cell.str;
        [columns addObject:columnCaption];
        columnCount ++;
        col++;
        cell = [reader cellInWorkSheetIndex:0 row:row col:col];
    }
    NSLog(@"in readDRIdata_fromExcelFile, columnCount=%d, columns=%@",columnCount,columns);
    
    row = 2, col = 1;
    cell = [reader cellInWorkSheetIndex:0 row:row col:col];
    while (cell.type != cellBlank) {
        dataRowCount ++;
        row++;
        cell = [reader cellInWorkSheetIndex:0 row:row col:col];
        //NSLog(@"id cell .str=%@ , .val=%@\n", cell.str, cell.val);//id cell .str=80200 , .val=80200
    }
    NSLog(@"in readDRIdata_fromExcelFile, rowCount=%d",dataRowCount);
    
    NSMutableArray * rows2D = [NSMutableArray arrayWithCapacity:dataRowCount];
    for(int i=0; i<dataRowCount; i++){
        NSMutableArray * rowData = [NSMutableArray arrayWithCapacity:columnCount];
        for(int j=0; j<columnCount; j++){
            row = 2+i, col = 1+j;
            NSLog(@"in readDRIdata_fromExcelFile, row=%d, col=%d",row,col);
            
            cell = [reader cellInWorkSheetIndex:0 row:row col:col];
            if (j==1 || j==2){
                
                if (cell.type == cellBlank){
                    [rowData addObject:@"0"];
                }else if (cell.type == cellString){
                    //[rowData addObject:[NSNumber numberWithInteger:[cell.str integerValue]]];
                    [rowData addObject:cell.str];
                }else{
                    [rowData addObject:cell.val];
                }
            }else{
                if (cell.type == cellBlank){
                    [rowData addObject:@"0"];
                }else if (cell.type == cellString){
                    [rowData addObject:cell.str];
                }else{
                    [rowData addObject:cell.val];
                }
            }
        }
        [rows2D addObject:rowData];
    }
    NSLog(@"in readDRIdata_fromExcelFile, rows2D=%@",rows2D);
    
    NSMutableDictionary *retData = [NSMutableDictionary dictionaryWithCapacity:2];
    [retData setObject:columns forKey:@"columns"];
    [retData setObject:rows2D forKey:@"rows2D"];
    return retData;
}


/*
 其作用是把female的DRI数据，即Female_DRI.xls中的数据导入到sqlite中，对应的表名为DRIFemale。
 */
-(void)convertDRIFemaleDataFromExcelToSqlite
{
    NSDictionary *data = [self readDRIdata_fromExcelFile:@"Female_DRI.xls"];
    NSArray *columns = [data objectForKey:@"columns"];
    NSArray *rows2D = [data objectForKey:@"rows2D"];
    
    NSString *tableName = TABLE_NAME_DRIFemale;// @"DRIFemale";

    assert(dbCon!=nil);
    LZDBAccess *db = dbCon;
    [db createDRItable:tableName andColumnNames:columns];
    [db insertToDRItable:tableName andColumnNames:columns andData:rows2D];    
}
/*
 其作用是把male的DRI数据，即Male_DRI.xls中的数据导入到sqlite中，对应的表名为DRIMale。
 */
-(void)convertDRIMaleDataFromExcelToSqlite
{
    NSDictionary *data = [self readDRIdata_fromExcelFile:@"Male_DRI.xls"];
    NSArray *columns = [data objectForKey:@"columns"];
    NSArray *rows2D = [data objectForKey:@"rows2D"];
    
    NSString *tableName = TABLE_NAME_DRIMale;// @"DRIMale";
    
    assert(dbCon!=nil);
    LZDBAccess *db = dbCon;

    [db createDRItable:tableName andColumnNames:columns];
    [db insertToDRItable:tableName andColumnNames:columns andData:rows2D];
}






/*
// USDAtable 是特指美国农业部的那份以excel格式存在的数据库的唯一一个各食物营养成分表。
// 目前我们具体使用时，是根据常见的中国食物取了一些行，并加上了中文描述列。目前是这个文件customUSDAdata.xls 。
// 但是这个文件的原始来源数据由于在google doc中使用了隐藏列，再拷贝行从最原始数据到google doc出现数据错位的错误。
// 所以不能直接用里面的数据，而只能用其中的id和中文描述列。
 
 与ABBREV.xlsx中的数据很相似，只是多了两个中文描述性列在最前面。
 不过为了防止或尽量减少手工带来的错误，不直接用excel档中的数据，而只用其中的id列和中文描述列，
 并结合ABBREV已经被导入到sqlite的全数据来生成。
 返回的Dictionary包括这3列的数据，key分别是ids,ChineseCaptions,ChineseTypes
 */
-(NSDictionary *)readCustomUSDAdata_V2
{
    NSLog(@"readCustomUSDAdata_V2 begin");
    //NSString *xlsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"customUSDAdataV2.xls"];
    NSString *xlsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Food.xls"];
    NSLog(@"in readCustomUSDAdata_V2, xlsPath=%@",xlsPath);
    DHxlsReader *reader = [DHxlsReader xlsReaderFromFile:xlsPath];
	assert(reader);
    
    NSMutableArray * idAry = [NSMutableArray arrayWithCapacity:1000];
    NSMutableArray * cnCaptionAry = [NSMutableArray arrayWithCapacity:1000];
    NSMutableArray * cnTypeAry = [NSMutableArray arrayWithCapacity:1000];
    int idxRow=2, colIdxCnCaption=1, colIdxCnType=2, colIdxId=3;
    DHcell *cellCnCaption,*cellCnType, *cellId;
    cellCnCaption = [reader cellInWorkSheetIndex:0 row:idxRow col:colIdxCnCaption];
    cellCnType = [reader cellInWorkSheetIndex:0 row:idxRow col:colIdxCnType];
    cellId = [reader cellInWorkSheetIndex:0 row:idxRow col:colIdxId];
    while (cellId.type != cellBlank) {
        assert(cellId.type == cellString);
        [idAry addObject:cellId.str];
        
        if (cellCnCaption.type == cellBlank){
            [cnCaptionAry addObject:@""];
        }else if (cellCnCaption.type == cellString){
            [cnCaptionAry addObject:cellCnCaption.str];
        }else{
            [cnCaptionAry addObject:@""];
        }
        
        if (cellCnType.type == cellBlank){
            [cnTypeAry addObject:@""];
        }else if (cellCnType.type == cellString){
            [cnTypeAry addObject:cellCnType.str];
        }else{
            [cnTypeAry addObject:@""];
        }

        idxRow++;
        cellCnCaption = [reader cellInWorkSheetIndex:0 row:idxRow col:colIdxCnCaption];
        cellCnType = [reader cellInWorkSheetIndex:0 row:idxRow col:colIdxCnType];
        cellId = [reader cellInWorkSheetIndex:0 row:idxRow col:colIdxId];
    }
    NSLog(@"in readCustomUSDAdata, idAry=%@, cnCaptionAry=%@, cnTypeAry=%@",idAry,cnCaptionAry,cnTypeAry);
    
    NSMutableDictionary *retData = [NSMutableDictionary dictionaryWithCapacity:2];
    [retData setObject:idAry forKey:@"ids"];
    [retData setObject:cnCaptionAry forKey:@"ChineseCaptions"];
    [retData setObject:cnTypeAry forKey:@"ChineseTypes"];
    return retData;
}

/*
 这是导增加了额外信息的食物营养成分数据。
 其作用是把Food.xls中包含的食物的中文描述数据，结合已经导入到sqlite的USDAFullDataInSqlite.dat的全部食物的营养成分表的数据，生成一份包含部分食物但附加了中文信息的数据，对应表为FoodNutritionCustom。
 这个FoodNutritionCustom表其实可以通过 FoodNutrition 和 FoodCnDescription 经过join得到，甚至根本用不着这个表。但由于历史原因，目前实际使用的是它。
 */
-(void)generateCustomUSDASqliteDataFromFullSqliteDataAndExcelDigestData_V2
{
    NSLog(@"generateCustomUSDASqliteDataFromFullSqliteDataAndExcelDigestData_V2 begin");
    
    NSString *fullDataDbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"USDAFullDataInSqlite.dat"];
    LZDBAccess *dbSrc = [[LZDBAccess alloc]init];
    [dbSrc myInitWithDbFilePath:fullDataDbPath andIfNeedClear:false];
    
    NSDictionary *customData = [self readCustomUSDAdata_V2];
    NSArray *idAry = [customData objectForKey:@"ids"];
//    NSArray *cnCaptionAry = [customData objectForKey:@"ChineseCaptions"];
//    NSArray *cnTypeAry = [customData objectForKey:@"ChineseTypes"];
    
    NSMutableDictionary * queryDataByIds = [dbSrc queryUSDADataByIds:idAry];
    NSMutableArray *columnNamesOfABBREV = [queryDataByIds objectForKey:@"columnNames"];
    
    assert(dbCon!=nil);
    LZDBAccess *dbDest = dbCon;
    [dbDest createCustomUSDAtable_V2:columnNamesOfABBREV andIfNeedDropTable:true];
    [dbDest insertToCustomUSDAtable_V2:customData andRowsAndColumns:queryDataByIds andIfNeedClearTable:true];

}


/*
 返回值是一个dictionary，包括 以columnNames为key的一维数组和 以rows2D为key的二维数组
 */
-(NSDictionary *)readFoodCnDescription
{
    NSLog(@"readFoodCnDescription begin");
    NSString *xlsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Food_Limit.xls"];
    NSLog(@"in readFoodLimit, xlsPath=%@",xlsPath);
    DHxlsReader *reader = [DHxlsReader xlsReaderFromFile:xlsPath];
	assert(reader);
    NSMutableArray *columnNames = [NSMutableArray arrayWithObjects: COLUMN_NAME_NDB_No, COLUMN_NAME_CnCaption,COLUMN_NAME_CnType, nil];
    NSMutableArray *rows2D = [NSMutableArray arrayWithCapacity:1000];
    
    int idxInXls_Id = 3, idxInXls_CnCaption = 1, idxInXls_CnType = 2;
    int idxRow=2;
    DHcell *cellId, *cellCnCaption, *cellCnType;
    cellId = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_Id];
    cellCnCaption = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_CnCaption];
    cellCnType = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_CnType];
    while (cellId.type != cellBlank) {
        assert(cellId.type == cellString);
        NSMutableArray *row = [NSMutableArray arrayWithCapacity:3];
        [row addObject:cellId.str];
        [row addObject:cellCnCaption.str];
        [row addObject:cellCnType.str];
        [rows2D addObject:row];
        idxRow++;
        cellId = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_Id];
        cellCnCaption = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_CnCaption];
        cellCnType = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_CnType];
    }
    NSLog(@"in readFoodLimit, columnNames=%@, rows2D=%@",columnNames,rows2D);
    
    NSMutableDictionary *retData = [NSMutableDictionary dictionaryWithCapacity:2];
    [retData setObject:columnNames forKey:@"columnNames"];
    [retData setObject:rows2D forKey:@"rows2D"];
    return retData;
}

/*
 其作用是把食物的中文描述信息从Food.xls导入到sqlite中，对应的表名为FoodCnDescription。
 */
-(void)convertExcelToSqlite_FoodCnDescription
{
    NSDictionary *data = [self readFoodCnDescription];
    NSArray *columnNames = [data objectForKey:@"columnNames"];
    NSArray *rows2D = [data objectForKey:@"rows2D"];
    
    assert(dbCon!=nil);
    LZDBAccess *db = dbCon;
    NSString *tableName = TABLE_NAME_FoodCnDescription;
    NSString *primaryKey = COLUMN_NAME_NDB_No;
    [db createTable_withTableName:tableName withColumnNames:columnNames withRows2D:rows2D withPrimaryKey:primaryKey andIfNeedDropTable:true];
    [db insertToTable_withTableName:tableName withColumnNames:columnNames andRows2D:rows2D andIfNeedClearTable:true];
}



/*
 返回值是一个dictionary，包括 以columnNames为key的一维数组和 以rows2D为key的二维数组
 */
-(NSDictionary *)readFoodLimit
{
    NSLog(@"readFoodLimit begin");
    NSString *xlsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Food_Limit.xls"];
    NSLog(@"in readFoodLimit, xlsPath=%@",xlsPath);
    DHxlsReader *reader = [DHxlsReader xlsReaderFromFile:xlsPath];
	assert(reader);
    
    NSMutableArray *rows2D = [NSMutableArray arrayWithCapacity:1000];
    NSMutableArray *columnNames = [NSMutableArray arrayWithCapacity:3];
    int idxInXls_Id = 3, idxInXls_LowerLimit = 5, idxInXls_UpperLimit = 6;
    
    int idxRow=1;
    DHcell *cellId, *cellLowerLimit, *cellUpperLimit;
    cellId = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_Id];
    cellLowerLimit = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_LowerLimit];
    cellUpperLimit = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_UpperLimit];
    [columnNames addObject:cellId.str];
    [columnNames addObject:cellLowerLimit.str];
    [columnNames addObject:cellUpperLimit.str];
    idxRow ++;
    cellId = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_Id];
    cellLowerLimit = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_LowerLimit];
    cellUpperLimit = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_UpperLimit];
    while (cellId.type != cellBlank) {
        assert(cellId.type == cellString);
        NSMutableArray *row = [NSMutableArray arrayWithCapacity:3];
        [row addObject:cellId.str];
        [row addObject:cellLowerLimit.val];
        [row addObject:cellUpperLimit.val];
        [rows2D addObject:row]; 
        idxRow++;
        cellId = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_Id];
        cellLowerLimit = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_LowerLimit];
        cellUpperLimit = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_UpperLimit];
    }
    NSLog(@"in readFoodLimit, columnNames=%@, rows2D=%@",columnNames,rows2D);
    
    NSMutableDictionary *retData = [NSMutableDictionary dictionaryWithCapacity:2];
    [retData setObject:columnNames forKey:@"columnNames"];
    [retData setObject:rows2D forKey:@"rows2D"];
    return retData;
}

/*
 其作用是把食物摄取的符合情理的上下限值表导入，即Food_Limit.xls中的数据导入到sqlite中，对应的表名为FoodLimit。
 */
-(void)convertExcelToSqlite_FoodLimit
{
    NSDictionary *data = [self readFoodLimit];
    NSArray *columnNames = [data objectForKey:@"columnNames"];
    NSArray *rows2D = [data objectForKey:@"rows2D"];
    
    assert(dbCon!=nil);
    LZDBAccess *db = dbCon;
    NSString *tableName = TABLE_NAME_FoodLimit;
    NSString *primaryKey = COLUMN_NAME_NDB_No;
    [db createTable_withTableName:tableName withColumnNames:columnNames withPrimaryKey:primaryKey andIfNeedDropTable:true];
    [db insertToTable_withTableName:tableName withColumnNames:columnNames andRows2D:rows2D andIfNeedClearTable:true];
}






-(NSDictionary *)readNutritionInfo
{
    NSString *fileName = @"NutrientInfo.xls";
    NSString *xlsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    NSLog(@"in readNutritionInfo, xlsPath=%@",xlsPath);
    DHxlsReader *reader = [DHxlsReader xlsReaderFromFile:xlsPath];
	assert(reader);
    
    int row=1, col=1, columnCount=0,dataRowCount=0;
    DHcell *cell = nil;
    NSMutableArray * columns = [NSMutableArray arrayWithCapacity:100];
    
    cell = [reader cellInWorkSheetIndex:0 row:row col:col];
    while (cell.type != cellBlank) {
        NSString *columnCaption = cell.str;
        [columns addObject:columnCaption];
        columnCount ++;
        col++;
        cell = [reader cellInWorkSheetIndex:0 row:row col:col];
    }
    NSLog(@"in readNutritionInfo, columnCount=%d, columns=%@",columnCount,columns);
    
    row = 2, col = 1;
    cell = [reader cellInWorkSheetIndex:0 row:row col:col];
    while (cell.type != cellBlank) {
        dataRowCount ++;
        row++;
        cell = [reader cellInWorkSheetIndex:0 row:row col:col];
    }
    NSLog(@"in readNutritionInfo, rowCount=%d",dataRowCount);
    
    NSMutableArray * rows2D = [NSMutableArray arrayWithCapacity:dataRowCount];
    for(int i=0; i<dataRowCount; i++){
        NSMutableArray * rowData = [NSMutableArray arrayWithCapacity:columnCount];
        for(int j=0; j<columnCount; j++){
            row = 2+i, col = 1+j;
            NSLog(@"in readNutritionInfo, row=%d, col=%d",row,col);
            
            cell = [reader cellInWorkSheetIndex:0 row:row col:col];
            [rowData addObject:cell.str];
        }
        [rows2D addObject:rowData];
    }
    NSLog(@"in readNutritionInfo, rows2D=%@",rows2D);
    
    NSMutableDictionary *retData = [NSMutableDictionary dictionaryWithCapacity:2];
    [retData setObject:columns forKey:@"columns"];
    [retData setObject:rows2D forKey:@"rows2D"];
    return retData;
}


-(void)convertExcelToSqlite_NutritionInfo
{
    NSDictionary *data = [self readNutritionInfo];
    NSArray *columns = [data objectForKey:@"columns"];
    NSArray *rows2D = [data objectForKey:@"rows2D"];
    
    NSString *tableName = TABLE_NAME_NutritionInfo;// @"NutritionInfo";
    
    assert(dbCon!=nil);
    LZDBAccess *db = dbCon;
    [db createTable_withTableName:tableName withColumnNames:columns withRows2D:rows2D withPrimaryKey:COLUMN_NAME_NutrientID andIfNeedDropTable:true];
    [db insertToTable_withTableName:tableName withColumnNames:columns andRows2D:rows2D andIfNeedClearTable:true];
}










/*
 返回值是一个dictionary，包括 以COLUMN_NAME_NDB_No为key的一维数组和 以COLUMN_NAME_PicPath为key的一维数组
 */
-(NSDictionary *)readFoodPicPath
{
    NSLog(@"readFoodPicPath begin");
    NSString *xlsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Food_PicPath.xls"];
    NSLog(@"in readFoodPicPath, xlsPath=%@",xlsPath);
    DHxlsReader *reader = [DHxlsReader xlsReaderFromFile:xlsPath];
	assert(reader);
    
//    NSMutableArray *foodNoAry = [NSMutableArray arrayWithCapacity:200];
//    NSMutableArray *picPathAry = [NSMutableArray arrayWithCapacity:200];
    NSMutableArray *rows2D = [NSMutableArray arrayWithCapacity:200];
    int colIdx_No = 3;
    int colIdx_PicPath = 5;

    int idxRow=2;
    DHcell *cellNo, *cellPicPath;
    cellNo = [reader cellInWorkSheetIndex:0 row:idxRow col:colIdx_No];
    cellPicPath = [reader cellInWorkSheetIndex:0 row:idxRow col:colIdx_PicPath];
    while (cellNo.type != cellBlank || cellPicPath.type != cellBlank) {
        if (cellNo.type != cellBlank && cellPicPath.type != cellBlank){
            NSMutableArray *row = [NSMutableArray arrayWithCapacity:2];
            [row addObject:cellNo.str];
            [row addObject:cellPicPath.str];
//            [foodNoAry addObject:cellNo.str];
//            [picPathAry addObject:cellPicPath.str];
            [rows2D addObject:row];
        }
    
        idxRow++;
        cellNo = [reader cellInWorkSheetIndex:0 row:idxRow col:colIdx_No];
        cellPicPath = [reader cellInWorkSheetIndex:0 row:idxRow col:colIdx_PicPath];
    }
//    NSLog(@"in readFoodPicPath, foodNoAry=%@, picPathAry=%@",foodNoAry,picPathAry);
    NSLog(@"in readFoodPicPath, rows2D=%@",rows2D);
    
    NSMutableArray *columns = [NSMutableArray arrayWithObjects: COLUMN_NAME_NDB_No,COLUMN_NAME_PicPath, nil];
    
    NSMutableDictionary *retData = [NSMutableDictionary dictionaryWithCapacity:2];
    [retData setObject:columns forKey:@"columns"];
    [retData setObject:rows2D forKey:@"rows2D"];
    return retData;
}


-(void)convertExcelToSqlite_FoodPicPath
{
    NSDictionary *data = [self readFoodPicPath];
    NSArray *columns = [data objectForKey:@"columns"];
    NSArray *rows2D = [data objectForKey:@"rows2D"];
    
    NSString *tableName = TABLE_NAME_FoodPicPath;// @"FoodPicPath";
    
    assert(dbCon!=nil);
    LZDBAccess *db = dbCon;
    [db createTable_withTableName:tableName withColumnNames:columns withRows2D:rows2D withPrimaryKey:COLUMN_NAME_NDB_No andIfNeedDropTable:true];
    [db insertToTable_withTableName:tableName withColumnNames:columns andRows2D:rows2D andIfNeedClearTable:true];
}










@end











































