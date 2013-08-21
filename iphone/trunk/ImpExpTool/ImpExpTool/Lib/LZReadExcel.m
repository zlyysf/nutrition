//
//  LZReadExcel.m
//  tExcelToSqlite
//
//  Created by Yasofon on 13-4-26.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

//#import "LZConst.h"
#import "LZConstants.h"
#import "LZUtility.h"
#import "LZReadExcel.h"
#import "LZRecommendFood.h"

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
                assert(cell.type != cellBlank);
                if (cell.type == cellString){
                    //[rowData addObject:cell.str];
                    [rowData addObject:[NSNumber numberWithInt:[cell.str intValue]]];
                }else{
                    NSNumber *nmVd = (NSNumber*)cell.val;
                    NSNumber *nmVi = [NSNumber numberWithInt:[nmVd intValue]];
                    [rowData addObject:nmVi];
                }
            }else{
                if (cell.type == cellBlank){
                    //[rowData addObject:@"0"];
                    [rowData addObject:[NSNumber numberWithInt:0]];
                }else if (cell.type == cellString){
                    //[rowData addObject:cell.str];
                    [rowData addObject:[NSNumber numberWithDouble:[cell.str doubleValue]]];
                }else{
                    NSNumber *nmVd = (NSNumber*)cell.val;
                    assert(nmVd!=nil);
                    [rowData addObject:nmVd];
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
 其作用是把Male的DRI数据，即Female_DRI.xls中的数据导入到sqlite中，对应的表名为DRIFemale。
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

-(void)dealDRIandULdataFromExcelToSqliteForFemale
{
    [self dealDRIandULdataFromExcelToSqliteWithDRIfileName:@"Female_DRI.xls" andULfileName:@"Female_UL.xls" andTableNameDRI:TABLE_NAME_DRIFemale andTableNameUL:TABLE_NAME_DRIULFemale andTableNameULvsDRI:TABLE_NAME_DRIULrateFemale];
}
-(void)dealDRIandULdataFromExcelToSqliteForMale
{
    [self dealDRIandULdataFromExcelToSqliteWithDRIfileName:@"Male_DRI.xls" andULfileName:@"Male_UL.xls" andTableNameDRI:TABLE_NAME_DRIMale andTableNameUL:TABLE_NAME_DRIULMale andTableNameULvsDRI:TABLE_NAME_DRIULrateMale];
}

-(void)dealDRIandULdataFromExcelToSqliteWithDRIfileName:(NSString *)fileNameDRI andULfileName:(NSString *)fileNameUL andTableNameDRI:(NSString *)tableNameDRI andTableNameUL:(NSString *)tableNameUL andTableNameULvsDRI:(NSString *)tableNameULvsDRI
{
    NSDictionary *dataDRI = [self readDRIdata_fromExcelFile:fileNameDRI];
    NSArray *columnsDRI = [dataDRI objectForKey:@"columns"];
    NSArray *rows2dDRI = [dataDRI objectForKey:@"rows2D"];
    
    NSDictionary *dataUL = [self readDRIdata_fromExcelFile:fileNameUL];
    NSArray *columnsUL = [dataUL objectForKey:@"columns"];
    NSArray *rows2dUL = [dataUL objectForKey:@"rows2D"];

    assert(dbCon!=nil);
    LZDBAccess *db = dbCon;
    NSString *tableName;
    NSArray *columns ,*rows2D;
    tableName = tableNameDRI;
    columns = columnsDRI;
    rows2D = rows2dDRI;
    [db createDRItable:tableName andColumnNames:columns];
    [db insertToDRItable:tableName andColumnNames:columns andData:rows2D];
    tableName = tableNameUL;
    columns = columnsUL;
    rows2D = rows2dUL;
    [db createDRItable:tableName andColumnNames:columns];
    [db insertToDRItable:tableName andColumnNames:columns andData:rows2D];
    
    assert(columnsDRI.count>0);
    assert(columnsDRI.count==columnsUL.count);
    for(int i=0; i<columnsDRI.count; i++){
        NSString *colNameDRI = columnsDRI[i];
        NSString *colNameUL = columnsUL[i];
        assert([colNameDRI isEqualToString:colNameUL]);
    }
    
    assert(rows2dDRI.count>0);
    assert(rows2dDRI.count==rows2dUL.count);
    NSMutableArray *rows2dULvsDRI = [NSMutableArray arrayWithCapacity:rows2dDRI.count];
    for(int i=0; i<rows2dDRI.count; i++){
        NSArray *rowDRI = rows2dDRI[i];
        NSArray *rowUL = rows2dUL[i];
        NSMutableArray *rowULvsDRI = [NSMutableArray arrayWithCapacity:rowDRI.count];
        assert(rowDRI.count>0);
        assert(rowDRI.count==rowUL.count);
        for(int j=0; j<rowDRI.count; j++){
            NSString *colName = columnsDRI[j];
            NSNumber *nmCellDRI = (NSNumber*)rowDRI[j];
            NSNumber *nmCellUL = (NSNumber*)rowUL[j];
            NSNumber *nmCellULvsDRI;
            if (j<2){
                nmCellULvsDRI = nmCellDRI;
            }else{
                if ([nmCellUL doubleValue]<0){//对应于没有上限的情况
                    nmCellULvsDRI = [NSNumber numberWithInt:-1];
                }else if([nmCellUL doubleValue]==0){//对应于上限值不明确的情况
                    nmCellULvsDRI = [NSNumber numberWithInt:0];
                }else{//([nmCellFemaleUL doubleValue]>0)//有上限值时
                    assert([nmCellDRI doubleValue]>0);
                    double vs;
                    if ([colName isEqualToString:@"Magnesium_(mg)"]){
                        vs = ([nmCellUL doubleValue]+[nmCellDRI doubleValue]) / [nmCellDRI doubleValue];
                    }else{
                        vs = [nmCellUL doubleValue] / [nmCellDRI doubleValue];
                    }
                    nmCellULvsDRI = [NSNumber numberWithDouble:vs];
                }
            }
            [rowULvsDRI addObject:nmCellULvsDRI];
        }//for j
        [rows2dULvsDRI addObject:rowULvsDRI];
    }//for i
    
    tableName = tableNameULvsDRI;
    columns = columnsUL;
    rows2D = rows2dULvsDRI;
    [db createDRItable:tableName andColumnNames:columns];
    [db insertToDRItable:tableName andColumnNames:columns andData:rows2D];
}

-(void)convertDRIULFemaleDataFromExcelToSqlite
{
    NSDictionary *data = [self readDRIdata_fromExcelFile:@"Female_UL.xls"];
    NSArray *columns = [data objectForKey:@"columns"];
    NSArray *rows2D = [data objectForKey:@"rows2D"];
    
    NSString *tableName = TABLE_NAME_DRIULFemale;// @"DRIULFemale";
    
    assert(dbCon!=nil);
    LZDBAccess *db = dbCon;
    [db createDRItable:tableName andColumnNames:columns];
    [db insertToDRItable:tableName andColumnNames:columns andData:rows2D];
}
-(void)convertDRIULMaleDataFromExcelToSqlite
{
    NSDictionary *data = [self readDRIdata_fromExcelFile:@"Male_UL.xls"];
    NSArray *columns = [data objectForKey:@"columns"];
    NSArray *rows2D = [data objectForKey:@"rows2D"];
    
    NSString *tableName = TABLE_NAME_DRIULMale;// @"DRIULMale";
    
    assert(dbCon!=nil);
    LZDBAccess *db = dbCon;
    
    [db createDRItable:tableName andColumnNames:columns];
    [db insertToDRItable:tableName andColumnNames:columns andData:rows2D];
}

///*
//// USDAtable 是特指美国农业部的那份以excel格式存在的数据库的唯一一个各食物营养成分表。
//// 目前我们具体使用时，是根据常见的中国食物取了一些行，并加上了中文描述列。目前是这个文件customUSDAdata.xls 。
//// 但是这个文件的原始来源数据由于在google doc中使用了隐藏列，再拷贝行从最原始数据到google doc出现数据错位的错误。
//// 所以不能直接用里面的数据，而只能用其中的id和中文描述列。
// 
// 与ABBREV.xlsx中的数据很相似，只是多了两个中文描述性列在最前面。
// 不过为了防止或尽量减少手工带来的错误，不直接用excel档中的数据，而只用其中的id列和中文描述列，
// 并结合ABBREV已经被导入到sqlite的全数据来生成。
// 返回的Dictionary包括这3列的数据，key分别是ids,ChineseCaptions,ChineseTypes
// */
//-(NSDictionary *)readCustomUSDAdata_V2
//{
//    NSLog(@"readCustomUSDAdata_V2 begin");
//    //NSString *xlsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"customUSDAdataV2.xls"];
////    NSString *xlsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Food.xls"];
//    NSString *xlsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Food_common.xls"];
//    NSLog(@"in readCustomUSDAdata_V2, xlsPath=%@",xlsPath);
//    DHxlsReader *reader = [DHxlsReader xlsReaderFromFile:xlsPath];
//	assert(reader);
//    
//    NSMutableArray * idAry = [NSMutableArray arrayWithCapacity:1000];
//    NSMutableArray * cnCaptionAry = [NSMutableArray arrayWithCapacity:1000];
//    NSMutableArray * cnTypeAry = [NSMutableArray arrayWithCapacity:1000];
//    NSMutableArray * classifyAry = [NSMutableArray arrayWithCapacity:1000];
//    int idxRow=2, colIdxCnCaption=1, colIdxCnType=2, colIdxId=3, colIdxClassify=4 ;
//    DHcell *cellCnCaption,*cellCnType, *cellId, *cellClassify;
//    cellCnCaption = [reader cellInWorkSheetIndex:0 row:idxRow col:colIdxCnCaption];
//    cellCnType = [reader cellInWorkSheetIndex:0 row:idxRow col:colIdxCnType];
//    cellId = [reader cellInWorkSheetIndex:0 row:idxRow col:colIdxId];
//    cellClassify = [reader cellInWorkSheetIndex:0 row:idxRow col:colIdxClassify];
//    NSLog(@"dealing row, %d, %@, %@, %@, %@",idxRow, cellId.str,cellCnCaption.str,cellCnType.str, cellClassify.str);
//    while (cellId.type!=cellBlank || cellCnCaption.type!=cellBlank || cellCnType.type!=cellBlank || cellClassify.type!=cellBlank) {
//        if (cellId.type!=cellBlank && cellCnCaption.type!=cellBlank && cellCnType.type!=cellBlank && cellClassify.type!=cellBlank){
//            assert(cellId.type == cellString);
//            [idAry addObject:cellId.str];
//            
////            if (cellCnCaption.type == cellBlank){
////                [cnCaptionAry addObject:@""];
////            }else if (cellCnCaption.type == cellString){
////                [cnCaptionAry addObject:cellCnCaption.str];
////            }else{
////                [cnCaptionAry addObject:@""];
////            }
//            [cnCaptionAry addObject:cellCnCaption.str];
//            
//            [cnTypeAry addObject:cellCnType.str];
//            
//            [classifyAry addObject:cellClassify.str];
//            
//            NSLog(@"GOODrow, %d",idxRow);
////            NSLog(@"GOODrow, %d, %@, %@, %@",idxRow, cellId.str,cellCnCaption.str,cellCnType.str);
//        }else{
//            NSLog(@"bad row, %d",idxRow);
////            NSLog(@"bad row, %d, %@, %@, %@",idxRow, cellId.str,cellCnCaption.str,cellCnType.str);
//        }
//        
//        idxRow++;
//        cellCnCaption = [reader cellInWorkSheetIndex:0 row:idxRow col:colIdxCnCaption];
//        cellCnType = [reader cellInWorkSheetIndex:0 row:idxRow col:colIdxCnType];
//        cellId = [reader cellInWorkSheetIndex:0 row:idxRow col:colIdxId];
//        cellClassify = [reader cellInWorkSheetIndex:0 row:idxRow col:colIdxClassify];
//        NSLog(@"dealing row, %d, %@, %@, %@, %@",idxRow, cellId.str,cellCnCaption.str,cellCnType.str, cellClassify.str);
//
//    }
////    NSLog(@"in readCustomUSDAdata_V2, idAry=%d, %@, cnCaptionAry=%d, %@, cnTypeAry=%d, %@",idAry.count,idAry,cnCaptionAry.count,cnCaptionAry,cnTypeAry.count,cnTypeAry);
//    
//    NSMutableDictionary *retData = [NSMutableDictionary dictionaryWithCapacity:2];
//    [retData setObject:idAry forKey:@"ids"];
//    [retData setObject:cnCaptionAry forKey:@"ChineseCaptions"];
//    [retData setObject:cnTypeAry forKey:@"ChineseTypes"];
//    [retData setObject:classifyAry forKey:COLUMN_NAME_classify];
//    return retData;
//}
//
///*
// 这是导增加了额外信息的食物营养成分数据。
// 其作用是把Food.xls中包含的食物的中文描述数据，结合已经导入到sqlite的USDAFullDataInSqlite.dat的全部食物的营养成分表的数据，生成一份包含部分食物但附加了中文信息的数据，对应表为FoodNutritionCustom。
// 这个FoodNutritionCustom表其实可以通过 FoodNutrition 和 FoodCnDescription 经过join得到，甚至根本用不着这个表。但由于历史原因，目前实际使用的是它。
// */
//-(void)generateCustomUSDASqliteDataFromFullSqliteDataAndExcelDigestData_V2
//{
//    NSLog(@"generateCustomUSDASqliteDataFromFullSqliteDataAndExcelDigestData_V2 begin");
//    
//    NSString *fullDataDbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"USDAFullDataInSqlite.dat"];
//    LZDBAccess *dbSrc = [[LZDBAccess alloc]init];
//    [dbSrc myInitWithDbFilePath:fullDataDbPath andIfNeedClear:false];
//    
//    NSDictionary *customData = [self readCustomUSDAdata_V2];
//    NSArray *idAry = [customData objectForKey:@"ids"];
////    NSArray *cnCaptionAry = [customData objectForKey:@"ChineseCaptions"];
////    NSArray *cnTypeAry = [customData objectForKey:@"ChineseTypes"];
//    
//    NSMutableDictionary * queryDataByIds = [dbSrc queryUSDADataByIds:idAry];
//    NSMutableArray *columnNamesOfABBREV = [queryDataByIds objectForKey:@"columnNames"];
//    
//    assert(dbCon!=nil);
//    LZDBAccess *dbDest = dbCon;
//    [dbDest createCustomUSDAtable_V2:columnNamesOfABBREV andIfNeedDropTable:true];
//    [dbDest insertToCustomUSDAtable_V2:customData andRowsAndColumns:queryDataByIds andIfNeedClearTable:true];
//
//}


/*
 这个工具用来比对定义的食物上限和计算出的阀值（ 单个食物供给每个营养素到上限的量的最小值 ）的情况。并且行的顺序与Food_common.xls完全一致。这样方便人工比对修改。 
 */
-(NSString*)generateCsv_ToMerge_FoodCustomnAndDRIULAmount_withCsvFileName:(NSString*)csvFileName
{
    NSArray *rows2DFoodIdName = [self readFoodIds_FromFoodCustom_WithOriginalRowPos_ForManualMergeOtherColumn];
    assert(dbCon!=nil);
    LZDBAccess *db = dbCon;
    NSDictionary * dataFoodSupplyDRIul = [db getAllDataOfTable:TABLE_NAME_Food_Supply_DRIUL_Amount];
    NSArray *rowsFoodSupplyDRIul = dataFoodSupplyDRIul[@"rows"];
    NSDictionary *dict2levelFoodSupplyDRIul = [LZUtility dictionaryArrayTo2LevelDictionary_withKeyName:COLUMN_NAME_NDB_No andDicArray:rowsFoodSupplyDRIul];
    
    NSMutableArray *rows2D = [NSMutableArray arrayWithCapacity:rows2DFoodIdName.count];
    for(int i=0 ; i<rows2DFoodIdName.count ; i++){
        NSMutableArray *row = [NSMutableArray arrayWithCapacity:10];
        [row addObjectsFromArray:rows2DFoodIdName[i]];
        NSString *foodId = row[0];
        NSNumber *nm_normal_value = row[2];
        NSNumber *nm_Upper_Limit = row[3];
        NSDictionary * dictFoodSupplyDRIul = dict2levelFoodSupplyDRIul[foodId];
        if (dictFoodSupplyDRIul != nil){
            NSNumber *nm_MinUpperAmount = dictFoodSupplyDRIul[COLUMN_NAME_MinUpperAmount];
            [row addObject:nm_MinUpperAmount];
            [row addObject:dictFoodSupplyDRIul[COLUMN_NAME_NutrientID]];
            if ([nm_MinUpperAmount doubleValue]<[nm_normal_value doubleValue]){
                [row addObject:@"<"];
            }else{
                [row addObject:@""];
            }
            if ([nm_MinUpperAmount doubleValue]<[nm_Upper_Limit doubleValue]){
                [row addObject:@"<"];
            }else{
                [row addObject:@""];
            }
        }else{
            [row addObject:@""];
            [row addObject:@""];
            [row addObject:@""];
            [row addObject:@""];
        }
        [rows2D addObject:row ];
    }
    return [LZUtility convert2DArrayToCsv:csvFileName withColumnNames:nil andRows2D:rows2D];
}


-(NSArray*)readFoodIds_FromFoodCustom_WithOriginalRowPos_ForManualMergeOtherColumn
{
    NSLog(@"readFoodIds_FromFoodCustom_WithOriginalRowPos_ForManualMergeOtherColumn begin");
    NSString *xlsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Food_common.xls"];
    NSLog(@"in readFoodIds_FromFoodCustom_WithOriginalRowPos_ForManualMergeOtherColumn, xlsPath=%@",xlsPath);
    DHxlsReader *reader = [DHxlsReader xlsReaderFromFile:xlsPath];
	assert(reader);
    int idxInXls_Id = 2, idxInXls_CnCaption = 3, idxInXls_normal_value=11, idxInXls_Upper_Limit=12;
    int idxRow=1;
    NSMutableArray *rows2D = [NSMutableArray arrayWithCapacity:1000];
    NSMutableArray *row;
    DHcell *cell_Id, *cell_CnCaption, *cell_normal_value, *cell_Upper_Limit;
    
    bool allImportantRowCellBlank;
    do {
        cell_Id = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_Id];
        cell_CnCaption = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_CnCaption];
        cell_normal_value = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_normal_value];
        cell_Upper_Limit = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_Upper_Limit];
       
        allImportantRowCellBlank = true;//注意cell_SingleItemUnitName 和 cell_SingleItemUnitWeight是可填项，不像其他的是必填项
        allImportantRowCellBlank = (cell_Id.type==cellBlank && cell_CnCaption.type==cellBlank );
        if(allImportantRowCellBlank)
            break;
        if(cell_Id.type!=cellBlank || cell_CnCaption.type!=cellBlank){
            row = [NSMutableArray arrayWithCapacity:2];
            NSString *foodId = @"";
            if (cell_Id.str != nil)
                foodId = cell_Id.str;
            NSString *foodName = @"";
            if (cell_CnCaption.str != nil)
                foodName = cell_CnCaption.str;
            
            NSNumber *nm_normal_value = [NSNumber numberWithDouble:0];
            if (cell_normal_value.val != nil)
                nm_normal_value = cell_normal_value.val;
            
            NSNumber *nm_Upper_Limit = [NSNumber numberWithDouble:0];
            if (cell_Upper_Limit.val != nil)
                nm_Upper_Limit = cell_Upper_Limit.val;
            
            [row addObject:foodId];
            [row addObject:foodName];
            [row addObject:nm_normal_value];
            [row addObject:nm_Upper_Limit];
            
            [rows2D addObject:row];
        }//if(allRowCellNotBlank)
        idxRow++;
    } while (!allImportantRowCellBlank);
    
    NSLog(@"in readFoodIds_FromFoodCustom_WithOriginalRowPos_ForManualMergeOtherColumn, rows2D=\n%@",rows2D);
    return rows2D;
}


/*
 目前 Food_common.xls 的数据已经包含了原有的 Food_common.xls 和 Food_PicPath.xls 和 Food_Limit.xls 中的数据。
 返回值是一个dictionary，包括 以columnNames为key的一维数组和 以rows2D为key的二维数组
 */
-(NSDictionary *)readFoodCustom_v1_3
{
    NSLog(@"readFoodCustom_v1_3 begin");
    NSString *xlsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Food_common.xls"];
    NSLog(@"in readFoodCustom_v1_3, xlsPath=%@",xlsPath);
    DHxlsReader *reader = [DHxlsReader xlsReaderFromFile:xlsPath];
	assert(reader);
    NSMutableArray *columnNames = [NSMutableArray arrayWithObjects: COLUMN_NAME_NDB_No
                                   , COLUMN_NAME_CnCaption,COLUMN_NAME_CnType,COLUMN_NAME_classify
                                   , COLUMN_NAME_PicPath
                                   , COLUMN_NAME_Lower_Limit,COLUMN_NAME_increment_unit,COLUMN_NAME_first_recommend,COLUMN_NAME_normal_value,COLUMN_NAME_Upper_Limit
                                   , COLUMN_NAME_SingleItemUnitName,COLUMN_NAME_SingleItemUnitWeight
                                   , nil];
    
    int idxInXls_Id = 2, idxInXls_CnCaption = 3, idxInXls_CnType = 5, idxInXls_Classify=6,
        idxInXls_PicPath = 7,
        idxInXls_Lower_Limit=8, idxInXls_increment_unit=9, idxInXls_first_recommend=10, idxInXls_normal_value=11, idxInXls_Upper_Limit=12,
        idxInXls_Enable=13,
        idxInXls_SingleItemUnitName = 14, idxInXls_SingleItemUnitWeight = 15;
    int idxRow=2;
    
    NSMutableArray *rows2D = [NSMutableArray arrayWithCapacity:1000];
    NSMutableArray *row;
    DHcell *cell_Id, *cell_CnCaption, *cell_CnType, *cell_Classify,
        *cell_PicPath, *cell_Lower_Limit, *cell_Upper_Limit, *cell_normal_value, *cell_first_recommend, *cell_increment_unit,
        *cell_Enable,
        *cell_SingleItemUnitName, *cell_SingleItemUnitWeight;
    bool allRowCellBlank;
    do {
        cell_Id = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_Id];
        cell_CnCaption = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_CnCaption];
        cell_CnType = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_CnType];
        cell_Classify = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_Classify];
        cell_PicPath = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_PicPath];
        cell_Lower_Limit = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_Lower_Limit];
        cell_Upper_Limit = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_Upper_Limit];
        cell_normal_value = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_normal_value];
        cell_first_recommend = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_first_recommend];
        cell_increment_unit = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_increment_unit];
        cell_Enable = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_Enable];
        cell_SingleItemUnitName = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_SingleItemUnitName];
        cell_SingleItemUnitWeight = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_SingleItemUnitWeight];
        allRowCellBlank = true;//注意cell_SingleItemUnitName 和 cell_SingleItemUnitWeight是可填项，不像其他的是必填项
        allRowCellBlank = (cell_Id.type==cellBlank && cell_CnCaption.type==cellBlank && cell_CnType.type==cellBlank && cell_Classify.type==cellBlank
                           && cell_PicPath.type==cellBlank
                           && cell_Lower_Limit.type==cellBlank && cell_Upper_Limit.type==cellBlank && cell_normal_value.type==cellBlank && cell_first_recommend.type==cellBlank && cell_increment_unit.type==cellBlank
                           && cell_Enable.type==cellBlank
                           );
        if(allRowCellBlank)
            break;
        bool allRowCellNotBlank = false;
        allRowCellNotBlank = (cell_Id.type!=cellBlank && cell_CnCaption.type!=cellBlank && cell_CnType.type!=cellBlank && cell_Classify.type!=cellBlank
                              && cell_PicPath.type!=cellBlank
                              && cell_Lower_Limit.type!=cellBlank && cell_Upper_Limit.type!=cellBlank && cell_normal_value.type!=cellBlank && cell_first_recommend.type!=cellBlank && cell_increment_unit.type!=cellBlank
                              && cell_Enable.type!=cellBlank
                              );
        if(allRowCellNotBlank){
            bool allRowCellNotEmpty = false;
            allRowCellNotEmpty = (cell_Id.str.length>0 && cell_CnCaption.str.length>0 && cell_CnType.str.length>0 && cell_Classify.str.length>0
                                  && cell_PicPath.str.length>0 && cell_Lower_Limit.str.length>0 && cell_Upper_Limit.str.length>0 && cell_normal_value.str.length>0 && cell_first_recommend.str.length>0 && cell_increment_unit.str.length>0
                                  && cell_Enable.str.length>0
                                  );
            if (allRowCellNotEmpty){
                if ([cell_Enable.val integerValue]==1){
                    row = [NSMutableArray arrayWithCapacity:15];
                    NSString *strId = cell_Id.str;
                    assert(strId.length==5);
                    [row addObject:strId];
                    [row addObject:cell_CnCaption.str];
                    [row addObject:cell_CnType.str];
                    [row addObject:cell_Classify.str];
                    [row addObject:cell_PicPath.str];
                    [row addObject:cell_Lower_Limit.val];
                    [row addObject:cell_increment_unit.val];
                    [row addObject:cell_first_recommend.val];
                    [row addObject:cell_normal_value.val];
                    [row addObject:cell_Upper_Limit.val];
                    if(cell_SingleItemUnitName.type!=cellBlank){
                        [row addObject:cell_SingleItemUnitName.str];
                    }else{
                        [row addObject:@""];
                    }
                    if(cell_SingleItemUnitWeight.type!=cellBlank){
                        [row addObject:cell_SingleItemUnitWeight.val];
                    }else{
                        [row addObject:[NSNumber numberWithInt:0]];
                    }
                    [rows2D addObject:row];
                }//if ([cell_Enable.val integerValue]==1)
            }//if (allRowCellNotEmpty)
        }//if(allRowCellNotBlank)
        idxRow++;
    } while (!allRowCellBlank);
    
    NSLog(@"in readFoodCustom_v1_3, columnNames=%@, rows2D=\n%@",columnNames,rows2D);
    
    NSMutableDictionary *retData = [NSMutableDictionary dictionaryWithCapacity:2];
    [retData setObject:columnNames forKey:@"columnNames"];
    [retData setObject:rows2D forKey:@"rows2D"];
    return retData;
}
-(void)convertExcelToSqlite_FoodCustom_v1_3
{
    NSDictionary *data = [self readFoodCustom_v1_3];
    NSArray *columnNames = [data objectForKey:@"columnNames"];
    NSArray *rows2D = [data objectForKey:@"rows2D"];
    
    assert(dbCon!=nil);
    LZDBAccess *db = dbCon;
    NSString *tableName = TABLE_NAME_FoodCustom;
    NSString *primaryKey = COLUMN_NAME_NDB_No;
    [db.da createTable_withTableName:tableName withColumnNames:columnNames withRows2D:rows2D withPrimaryKey:primaryKey andIfNeedDropTable:true];
    [db.da insertToTable_withTableName:tableName withColumnNames:columnNames andRows2D:rows2D andIfNeedClearTable:true];
}

-(BOOL)checkExcelForFoodPicPath
{
    BOOL retval = TRUE;
    NSDictionary *data = [self readFoodCustom_v1_3];
    NSArray *columnNames = [data objectForKey:@"columnNames"];
    NSArray *rows2D = [data objectForKey:@"rows2D"];
    
    int idx_foodId = 0;
    int idx_picPath = -1, idx_foodName = -1;
    for(int i=0; i<columnNames.count; i++){
        NSString * columnName = columnNames[i];
        if ( [COLUMN_NAME_PicPath isEqualToString:columnName]){
            idx_picPath = i;
        }
        if ( [COLUMN_NAME_CnCaption isEqualToString:columnName]){
            idx_foodName = i;
        }
    }//for
    assert(idx_picPath>0);
    NSLog(@"in checkExcelForFoodPicPath, the problems are as below:");
    NSString *picDirPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"foodDealed"];
    for(int i=0; i<rows2D.count; i++){
        NSArray *row = rows2D[i];
        NSString *foodId = row[idx_foodId];
        NSString *picPath = row[idx_picPath];
        NSString *foodName = row[idx_foodName];
        NSString *fullPicPath = [picDirPath stringByAppendingPathComponent:picPath];
        
        NSFileManager * defFileManager = [NSFileManager defaultManager];
        BOOL fileExists = [defFileManager fileExistsAtPath:fullPicPath];
        if (!fileExists){
            retval = FALSE;
            NSString *errMsg = [NSString stringWithFormat:@"%@ %@ %@",foodId,foodName,picPath];
            NSLog(@"%@",errMsg);
        }
    }//for
    NSLog(@"checkExcelForFoodPicPath ret:%d",retval);
    return retval;
}

//-(NSDictionary *)readFoodCustomT2
//{
//    NSLog(@"readFoodCustomT2 begin");
//    NSString *xlsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Food_common.xls"];
//    NSLog(@"in readFoodCustomT2, xlsPath=%@",xlsPath);
//    DHxlsReader *reader = [DHxlsReader xlsReaderFromFile:xlsPath];
//	assert(reader);
//    
//    int idxInXls_Id = 1, idxInXls_CnCaption = 3, idxInXls_CnType = 5, idxInXls_Classify=6 ;
//    NSMutableArray *columnNames = [NSMutableArray arrayWithObjects: COLUMN_NAME_NDB_No, COLUMN_NAME_CnCaption,COLUMN_NAME_CnType,COLUMN_NAME_classify, nil];
//    NSMutableArray *rows2D = [NSMutableArray arrayWithCapacity:1000];
//    
//    int idxRow=2;
//    DHcell *cellId, *cellCnCaption, *cellCnType, *cellClassify;
//    cellId = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_Id];
//    cellCnCaption = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_CnCaption];
//    cellCnType = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_CnType];
//    cellClassify = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_Classify];
//    while (cellId.type!=cellBlank || cellCnCaption.type!=cellBlank || cellCnType.type!=cellBlank || cellClassify.type!=cellBlank) {
//        if (cellId.type!=cellBlank && cellCnCaption.type!=cellBlank && cellCnType.type!=cellBlank && cellClassify.type!=cellBlank){
//            assert(cellId.type == cellString);
//            NSString *strId = cellId.str;
//            assert(strId.length==5);
//            NSMutableArray *row = [NSMutableArray arrayWithCapacity:3];
//            [row addObject:strId];
//            [row addObject:cellCnCaption.str];
//            [row addObject:cellCnType.str];
//            [row addObject:cellClassify.str];
//            [rows2D addObject:row];
//        }
//        idxRow++;
//        cellId = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_Id];
//        cellCnCaption = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_CnCaption];
//        cellCnType = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_CnType];
//        cellClassify = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_Classify];
//    }
//    
//    NSLog(@"in readFoodCustomT2, columnNames=%@, rows2D=\n%@",columnNames,rows2D);
//    
//    NSMutableDictionary *retData = [NSMutableDictionary dictionaryWithCapacity:2];
//    [retData setObject:columnNames forKey:@"columnNames"];
//    [retData setObject:rows2D forKey:@"rows2D"];
//    return retData;
//}
//
//-(void)dealExcelAndSqlite_FoodCustomT2
//{
//    NSDictionary *data = [self readFoodCustomT2];
//    NSArray *columnNames = [data objectForKey:@"columnNames"];
//    NSArray *rows2D = [data objectForKey:@"rows2D"];
//    
//    assert(dbCon!=nil);
//    LZDBAccess *db = dbCon;
//    NSString *tableName = @"FoodCustomT2" ;
//    NSString *primaryKey = COLUMN_NAME_NDB_No;
//    [db createTable_withTableName:tableName withColumnNames:columnNames withRows2D:rows2D withPrimaryKey:primaryKey andIfNeedDropTable:true];
//    [db insertToTable_withTableName:tableName withColumnNames:columnNames andRows2D:rows2D andIfNeedClearTable:true];
//    
//    [db getDifferenceFromFoodCustomAndFoodCustomT2];
//
//}

//
//-(void)mergeFoodPicPathAndFoodLimitToFoodcommon
//{
//    NSDictionary *dataFoodCustomT2 = [self readFoodCustomT2];
//    NSArray *rows2DFoodCustomT2 = [dataFoodCustomT2 objectForKey:@"rows2D"];
//    NSArray *columnNamesFoodCustomT2 = [dataFoodCustomT2 objectForKey:@"columnNames"];
//    NSMutableArray *idsFoodCustomT2 = [NSMutableArray array];
//    for(int i=0; i<rows2DFoodCustomT2.count; i++){
//        NSArray *rowFoodCustomT2 = rows2DFoodCustomT2[i];
//        NSString *foodId = rowFoodCustomT2[0];
//        [idsFoodCustomT2 addObject:foodId];
//    }
//    
//    NSDictionary *dataFoodPicPath = [self readFoodPicPath];
//    NSArray *rows2DFoodPicPath = [dataFoodPicPath objectForKey:@"rows2D"];
//    NSArray *columnNamesFoodPicPath = [dataFoodPicPath objectForKey:@"columnNames"];
//    NSMutableArray *idsFoodPicPath = [NSMutableArray array];
//    NSMutableDictionary *rowDictFoodPicPath = [NSMutableDictionary dictionary];
//    for(int i=0; i<rows2DFoodPicPath.count; i++){
//        NSArray *rowFoodPicPath = rows2DFoodPicPath[i];
//        NSString *foodId = rowFoodPicPath[0];
//        [idsFoodPicPath addObject:foodId];
//        [rowDictFoodPicPath setObject:rowFoodPicPath forKey:foodId];
//    }
//    
//    NSDictionary *dataFoodLimit = [self readFoodLimit];
//    NSArray *rows2DFoodLimit = [dataFoodLimit objectForKey:@"rows2D"];
//    NSArray *columnNamesFoodLimit = [dataFoodLimit objectForKey:@"columnNames"];
//    NSMutableArray *idsFoodLimit = [NSMutableArray array];
//    NSMutableDictionary *rowDictFoodLimit = [NSMutableDictionary dictionary];
//    for(int i=0; i<rows2DFoodLimit.count; i++){
//        NSArray *rowFoodLimit = rows2DFoodLimit[i];
//        NSString *foodId = rowFoodLimit[0];
//        [idsFoodLimit addObject:foodId];
//        [rowDictFoodLimit setObject:rowFoodLimit forKey:foodId];
//    }
//    
//    assert([LZUtility arrayContainArrayInSetWay_withOuterArray:idsFoodCustomT2 andInnerArray:idsFoodPicPath]);
//    assert([LZUtility arrayEqualArrayInSetWay_withArray1:idsFoodPicPath andArray2:idsFoodLimit]);
//    
////    NSString *resFileName = @"Food_common.xls";
////    NSString *destDbFileName = @"Food_commonE1.xls";
////    NSString *destDbFilePath = [LZUtility copyResourceToDocumentWithResFileName:resFileName andDestFileName:destDbFileName];
//    
//    NSArray *rows2DFoodCommonOld1 = [self readFoodCommonOld1];
//    for (int i=0; i<rows2DFoodCommonOld1.count; i++){
//        NSMutableArray *row = rows2DFoodCommonOld1[i];
//        if (i==0){
//            [row addObject:columnNamesFoodPicPath[1]];
//            [row addObject:columnNamesFoodLimit[1]];
//            [row addObject:columnNamesFoodLimit[2]];
//            [row addObject:columnNamesFoodLimit[3]];
//        }else{
//            NSString *foodId = row[0];
//            bool addedContent = false;
//            if (foodId.length>0){
//                NSArray *rowFoodLimit = [rowDictFoodLimit objectForKey:foodId];
//                NSArray *rowFoodPicPath = [rowDictFoodPicPath objectForKey:foodId];
//                if (rowFoodLimit!=nil){
//                    assert(rowFoodPicPath!=nil);
//                    addedContent = true;
//                    [row addObject:rowFoodPicPath[1]];
//                    [row addObject:rowFoodLimit[1]];
//                    [row addObject:rowFoodLimit[2]];
//                    [row addObject:rowFoodLimit[3]];
//                }
//            }
//            if (!addedContent){
//                [row addObject:@""];
//                [row addObject:@""];
//                [row addObject:@""];
//                [row addObject:@""];
//            }
//        }
//    }//for
//    
//    NSString *csvFileName = @"FoodCommonE1.csv";
//
//    NSString *csvFilePath = [LZUtility convert2DArrayToCsv:csvFileName withColumnNames:nil andRows2D:rows2DFoodCommonOld1];
//    NSLog(@"csvFilePath= %@",csvFilePath);
//}


-(NSMutableArray *)readFoodCommonOld1// TODO 按照8列读下来
{
    NSLog(@"readFoodCommonOld1 begin");
    NSString *xlsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Food_common.xls"];
    NSLog(@"in readFoodCommonOld1, xlsPath=%@",xlsPath);
    DHxlsReader *reader = [DHxlsReader xlsReaderFromFile:xlsPath];
	assert(reader);
    
    int columnCount = 8;
    int idxRow=1;

    NSMutableArray *rows2D = [NSMutableArray arrayWithCapacity:1000];
    
    NSMutableArray *row;
    DHcell *cell;
    bool allRowCellEmpty;
    
    do {
        allRowCellEmpty = true;
        row = [NSMutableArray arrayWithCapacity:columnCount];
        for(int i=1; i<=columnCount; i++){
            cell = [reader cellInWorkSheetIndex:0 row:idxRow col:i];
            if (cell.type!=cellBlank){
                NSString *cellStr = cell.str;
                [row addObject:cellStr];
                if (cellStr.length > 0){
                    allRowCellEmpty = false;
                }
            }else{
                [row addObject:@""];
            }
        }
        
        if (!allRowCellEmpty) {
            [rows2D addObject:row];
            idxRow++;
        }
    } while (!allRowCellEmpty);
    
    NSLog(@"in readFoodCommonOld1, rows2D=\n%@",rows2D);
    return rows2D;
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
            if (cell.type != cellBlank){
                [rowData addObject:cell.str];
            }else{
                [rowData addObject:@""];
            }
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
    [db.da createTable_withTableName:tableName withColumnNames:columns withRows2D:rows2D withPrimaryKey:COLUMN_NAME_NutrientID andIfNeedDropTable:true];
    [db.da insertToTable_withTableName:tableName withColumnNames:columns andRows2D:rows2D andIfNeedClearTable:true];
}







-(NSDictionary *)readCustomRichFood
{
    NSString *fileName = @"CustomRichFood.xls";
    NSString *xlsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    NSLog(@"in readCustomRichFood, xlsPath=%@",xlsPath);
    DHxlsReader *reader = [DHxlsReader xlsReaderFromFile:xlsPath];
	assert(reader);
    
    NSMutableArray *columnNames = [NSMutableArray arrayWithObjects: COLUMN_NAME_NutrientID, COLUMN_NAME_NDB_No, nil];
    NSArray * fullNutrients = [LZRecommendFood getDRItableNutrientsWithSameOrder];
    NSSet *fullNutrientSet = [NSSet setWithArray:fullNutrients];
    int idxInXls_NutrientId = 1, idxInXls_NutrientName = 2;
    int idxInXls_FoodId = 1, idxInXls_FoodName = 2, idxInXls_choose = 6;
    int idxRow=1;
    

    int continueEmptyRowCount = 0;
    int continueEmptyRowLimit = 10;
    
    NSMutableDictionary *nutrientHaveFoodIdDict = [NSMutableDictionary dictionary];
    NSMutableArray *rows2D = [NSMutableArray arrayWithCapacity:1000];
    NSMutableArray *row;
    DHcell *cell_NutrientId, *cell_NutrientName,
            *cell_FoodId, *cell_FoodName, *cell_choose;
    do {
        continueEmptyRowCount = 0;
        BOOL nutrientIdGot = false;
        NSString *nutrientId = nil;
        do {
            cell_NutrientId = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_NutrientId];
            cell_NutrientName = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_NutrientName];
            idxRow++;
            if (cell_NutrientId.type!=cellBlank){
                nutrientIdGot = true;
                nutrientId = cell_NutrientId.str;
                assert(nutrientId.length > 0);
                assert( [fullNutrientSet containsObject:nutrientId] );
                NSLog(@"current nutrientId:%@",nutrientId);
                continueEmptyRowCount = 0;
            }else{
                continueEmptyRowCount ++;
            }
        } while (continueEmptyRowCount<continueEmptyRowLimit && !nutrientIdGot);
        if (!nutrientIdGot){
            break;
        }
        
        
        
        bool foundEmptyRow = false;
        do{
            cell_FoodId = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_FoodId];
            cell_FoodName = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_FoodName];
            cell_choose = [reader cellInWorkSheetIndex:0 row:idxRow col:idxInXls_choose];
            idxRow++;
            if (cell_FoodId.type!=cellBlank || cell_FoodName.type!=cellBlank || cell_choose.type!=cellBlank){
                if ([COLUMN_NAME_NDB_No isEqualToString:cell_FoodId.str]){
                    continue;
                }else{
                    
                    int iChoose = 0;
                    if (cell_choose.type!=cellBlank){
                        NSNumber *nmChoose = cell_choose.val;
                        iChoose = [nmChoose intValue];
                    }
                    if (iChoose == 1){
                        NSString *foodId = nil;
                        if (cell_FoodId.type == cellString){
                            foodId = cell_FoodId.str;
                        }else{
                            NSNumber *nmFoodId = cell_FoodId.val;
                            foodId = [LZUtility convertNumberToFoodIdStr:nmFoodId];
                        }
                        NSMutableArray *row = [NSMutableArray arrayWithCapacity:2];
                        [row addObject:nutrientId];
                        [row addObject:foodId];
                        [nutrientHaveFoodIdDict setObject:[NSNumber numberWithInt:1] forKey:nutrientId];
                        [rows2D addObject:row];
                        NSLog(@"%@ %@, %@ %@",nutrientId,cell_NutrientName.str,foodId,cell_FoodName.str);
                    }
                }
            }else{
                foundEmptyRow = true;
            }
        }while (!foundEmptyRow);
    } while (continueEmptyRowCount < continueEmptyRowLimit);
    
    NSArray *customNutrients = [LZRecommendFood getCustomNutrients:nil];
    for(int i=0 ; i<customNutrients.count; i++){
        NSString * nutrient = customNutrients[i];
        NSNumber *nmHaveFoodId = nutrientHaveFoodIdDict[nutrient];
        assert([nmHaveFoodId intValue]>0);
    }
    
//    NSLog(@"in readCustomRichFood, columnNames=%@, rows2D=\n%@",columnNames,rows2D);
    NSMutableDictionary *retData = [NSMutableDictionary dictionaryWithCapacity:2];
    [retData setObject:columnNames forKey:@"columnNames"];
    [retData setObject:rows2D forKey:@"rows2D"];
    return retData;
}



-(void)convertExcelToSqlite_CustomRichFood
{
    NSDictionary *data = [self readCustomRichFood];
    NSArray *columns = [data objectForKey:@"columnNames"];
    NSArray *rows2D = [data objectForKey:@"rows2D"];
    
    NSString *tableName = TABLE_NAME_CustomRichFood;
    
    assert(dbCon!=nil);
    LZDBAccess *db = dbCon;
    [db.da createTable_withTableName:tableName withColumnNames:columns withRows2D:rows2D withPrimaryKey:nil andIfNeedDropTable:true];
    [db.da insertToTable_withTableName:tableName withColumnNames:columns andRows2D:rows2D andIfNeedClearTable:true];
}





/*
 目前只是一个临时版本，因为 benefits_nutrition_mapping.xls 的格式尚未定下来
 */
//-(NSDictionary *)readNutrientDisease
//{
//    NSString *fileName = @"benefits_nutrition_mapping.xls";
//    NSString *xlsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
//    NSLog(@"in readNutrientDisease, xlsPath=%@",xlsPath);
//    DHxlsReader *reader = [DHxlsReader xlsReaderFromFile:xlsPath];
//	assert(reader);
//    
//    NSMutableArray *columnNames = [NSMutableArray arrayWithObjects: COLUMN_NAME_Disease, COLUMN_NAME_NutrientID, nil];
//    int startColumnPos = 2, startRowPos = 2;
//    DHcell *cell;
//    cell = [reader cellInWorkSheetIndex:0 row:startColumnPos col:startRowPos];
//    assert(cell.type==cellBlank);
//
//    cell = [reader cellInWorkSheetIndex:0 row:startColumnPos+1 col:startRowPos];
//    assert(cell.type!=cellBlank);
//    cell = [reader cellInWorkSheetIndex:0 row:startColumnPos col:startRowPos+1];
//    assert(cell.type!=cellBlank);
//
//    
//    NSMutableArray *diseaseNames = [NSMutableArray arrayWithCapacity:100];
//    NSMutableArray *nutrientDescs = [NSMutableArray arrayWithCapacity:40];
//    
//    
//    int idxRow,idxCol;
//    
//    idxRow=startRowPos+1;
//    int columnPos_diseaseName = startColumnPos;
//    BOOL existDiseaseRow = false;
//    do {
//        cell = [reader cellInWorkSheetIndex:0 row:idxRow col:columnPos_diseaseName];
//        existDiseaseRow = (cell.type!=cellBlank && cell.str.length>0);
//        if (existDiseaseRow){
//            NSString *diseaseName = cell.str;
//            NSLog(@"diseaseName: %@ [%d]",diseaseName,idxRow);
//            [diseaseNames addObject:diseaseName];
//        }
//        idxRow++;
//    } while (existDiseaseRow);
//    
//    idxCol = startColumnPos +1;
//    int rowPos_nutrientDesc = startRowPos;
//    BOOL existNutrientDesc = false;
//    do {
//        cell = [reader cellInWorkSheetIndex:0 row:rowPos_nutrientDesc col:idxCol];
//        existNutrientDesc = (cell.type!=cellBlank && cell.str.length>0);
//        if (existNutrientDesc){
//            NSString *nutrientDesc = cell.str;
//            NSLog(@"nutrientDesc: %@ [%d]",nutrientDesc,idxCol);
//            [nutrientDescs addObject:nutrientDesc];
//        }
//        idxCol++;
//    } while (existNutrientDesc);
//    
//    NSMutableArray * diseaseNutrientAry = [NSMutableArray arrayWithCapacity:2000];
//    for(int iCol=0 ; iCol<nutrientDescs.count ; iCol++){
//        NSString *nutrientDesc = nutrientDescs[iCol];
//        for(int iRow=0 ; iRow<diseaseNames.count ; iRow++){
//            NSString *diseaseName = diseaseNames[iRow];
//            
//            int idxRow = startRowPos+1+iRow;
//            int idxCol = startColumnPos+1+iCol;
////            NSLog(@"[%d,%d]",idxRow,idxCol);
//            DHcell *cellFlag = [reader cellInWorkSheetIndex:0 row:idxRow col:idxCol];
//            if (cellFlag.type!=cellBlank && cellFlag.val!=nil && [cellFlag.val intValue]==1){
//                NSArray *diseaseNutrient = [NSArray arrayWithObjects: diseaseName, nutrientDesc, nil];
//                NSLog(@"diseaseNutrient: %@ %@ [%d,%d]",diseaseName,nutrientDesc,idxRow,idxCol);
//                [diseaseNutrientAry addObject:diseaseNutrient];
//            }
//        }//for j
//    }//for i
//
////    NSLog(@"in readNutrientDisease, columnNames=%@, rows2D=\n%@",columnNames,diseaseNutrientAry);
//    NSMutableDictionary *retData = [NSMutableDictionary dictionaryWithCapacity:2];
//    [retData setObject:columnNames forKey:@"columnNames"];
//    [retData setObject:diseaseNutrientAry forKey:@"rows2D"];
//    return retData;
//}

-(void)convertExcelToSqlite_NutrientDisease
{
    NSDictionary * dataInSheet0 = [self readNutrientDiseaseSheet:0];
    NSDictionary * dataInSheet1 = [self readNutrientDiseaseSheet:1];
    NSDictionary * dataInSheet2 = [self readNutrientDiseaseSheet:2];
    NSDictionary * dataInSheet3 = [self readNutrientDiseaseSheet:3];
    
    NSMutableArray *columnNames_DiseaseNutrient = [NSMutableArray arrayWithObjects: COLUMN_NAME_Disease, COLUMN_NAME_NutrientID, nil];
    NSMutableArray *columnNames_DiseaseGroup = [NSMutableArray arrayWithObjects: COLUMN_NAME_DiseaseGroup, COLUMN_NAME_dsGroupType, COLUMN_NAME_dsGroupWizardOrder, nil];
    NSMutableArray *columnNames_DiseaseInGroup = [NSMutableArray arrayWithObjects: COLUMN_NAME_DiseaseGroup, COLUMN_NAME_Disease, nil];
    
    NSMutableArray * diseaseNutrientAry = [NSMutableArray arrayWithCapacity:2000];
    NSMutableArray * diseaseGroupAry = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray * diseaseInGroupAry = [NSMutableArray arrayWithCapacity:200];

    [diseaseNutrientAry addObjectsFromArray:dataInSheet0[@"rows2D"]];
    [diseaseNutrientAry addObjectsFromArray:dataInSheet1[@"rows2D"]];
    [diseaseNutrientAry addObjectsFromArray:dataInSheet2[@"rows2D"]];
    [diseaseNutrientAry addObjectsFromArray:dataInSheet3[@"rows2D"]];
    
    [diseaseGroupAry addObject: [NSArray arrayWithObjects:dataInSheet0[@"DiseaseGroup"],DiseaseGroupType_wizard,[NSNumber numberWithInt:0], nil]];
    [diseaseGroupAry addObject: [NSArray arrayWithObjects:dataInSheet1[@"DiseaseGroup"],DiseaseGroupType_wizard,[NSNumber numberWithInt:1], nil]];
    [diseaseGroupAry addObject: [NSArray arrayWithObjects:dataInSheet2[@"DiseaseGroup"],DiseaseGroupType_wizard,[NSNumber numberWithInt:2], nil]];
    [diseaseGroupAry addObject: [NSArray arrayWithObjects:dataInSheet3[@"DiseaseGroup"],DiseaseGroupType_illness,[NSNumber numberWithInt:0], nil]];
    
    NSMutableArray* (^generateGroupDiseaseRelationsBlockVar)(NSString *sDiseaseGroup,NSArray *diseaseNames) ;
    generateGroupDiseaseRelationsBlockVar = ^(NSString *sDiseaseGroup,NSArray *diseaseNames){
        NSMutableArray * diseaseInGroupAry = [NSMutableArray arrayWithCapacity:diseaseNames.count];
        for(int i=0; i<diseaseNames.count; i++){
            [diseaseInGroupAry addObject:[NSArray arrayWithObjects:sDiseaseGroup,diseaseNames[i], nil] ];
        }
        return diseaseInGroupAry;
    };
    [diseaseInGroupAry addObjectsFromArray:generateGroupDiseaseRelationsBlockVar(dataInSheet0[@"DiseaseGroup"],dataInSheet0[@"validDiseaseNames"])];
    [diseaseInGroupAry addObjectsFromArray:generateGroupDiseaseRelationsBlockVar(dataInSheet1[@"DiseaseGroup"],dataInSheet1[@"validDiseaseNames"])];
    [diseaseInGroupAry addObjectsFromArray:generateGroupDiseaseRelationsBlockVar(dataInSheet2[@"DiseaseGroup"],dataInSheet2[@"validDiseaseNames"])];
    [diseaseInGroupAry addObjectsFromArray:generateGroupDiseaseRelationsBlockVar(dataInSheet3[@"DiseaseGroup"],dataInSheet3[@"validDiseaseNames"])];
    
    
    
    assert(dbCon!=nil);
    LZDBAccess *db = dbCon;
    NSString *tableName;
    tableName = TABLE_NAME_DiseaseGroup;
    [db.da createTable_withTableName:tableName withColumnNames:columnNames_DiseaseGroup withRows2D:diseaseGroupAry withPrimaryKey:nil andIfNeedDropTable:true];
    [db.da insertToTable_withTableName:tableName withColumnNames:columnNames_DiseaseGroup andRows2D:diseaseGroupAry andIfNeedClearTable:true];
    
    tableName = TABLE_NAME_DiseaseInGroup;
    [db.da createTable_withTableName:tableName withColumnNames:columnNames_DiseaseInGroup withRows2D:diseaseInGroupAry withPrimaryKey:nil andIfNeedDropTable:true];
    [db.da insertToTable_withTableName:tableName withColumnNames:columnNames_DiseaseInGroup andRows2D:diseaseInGroupAry andIfNeedClearTable:true];

    tableName = TABLE_NAME_DiseaseNutrient;
    [db.da createTable_withTableName:tableName withColumnNames:columnNames_DiseaseNutrient withRows2D:diseaseNutrientAry withPrimaryKey:nil andIfNeedDropTable:true];
    [db.da insertToTable_withTableName:tableName withColumnNames:columnNames_DiseaseNutrient andRows2D:diseaseNutrientAry andIfNeedClearTable:true];

}

-(NSDictionary *)readNutrientDiseaseSheet:(int)sheetIndex
{
    NSString *fileName = @"benefits_nutrition_mapping.xls";
    NSString *xlsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    NSLog(@"in readNutrientDisease, xlsPath=%@",xlsPath);
    DHxlsReader *reader = [DHxlsReader xlsReaderFromFile:xlsPath];
	assert(reader);
    
//    NSMutableArray *columnNames = [NSMutableArray arrayWithObjects: COLUMN_NAME_Disease, COLUMN_NAME_NutrientID, nil];
    int startColumnPos = 1, startRowPos = 2;
    DHcell *cell;
    cell = [reader cellInWorkSheetIndex:0 row:startColumnPos col:startRowPos];
    assert(cell.type==cellBlank);
    cell = [reader cellInWorkSheetIndex:0 row:startColumnPos+1 col:startRowPos];
    assert(cell.type!=cellBlank);
    cell = [reader cellInWorkSheetIndex:0 row:startColumnPos+1 col:startRowPos+1];
    assert(cell.type!=cellBlank);
    
    NSDictionary *nutrientDescToIdDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"Vit_A_RAE",@"维生素A",
                                          @"Vit_C_(mg)",@"维生素C",
                                          @"Vit_D_(µg)",@"维生素D",
                                          @"Vit_E_(mg)",@"维生素E",
                                          @"Riboflavin_(mg)",@"B2, 核黄素, Riboflavin",
                                          @"Vit_B6_(mg)",@"B6, 吡哆素, Pyridoxine",
                                          @"Folate_Tot_(µg)",@"B9, 叶酸",
                                          @"Vit_B12_(µg)",@"B12, 钴胺素, cobalamin",
                                          @"Calcium_(mg)",@"钙",
                                          @"Iron_(mg)",@"铁",
                                          @"Zinc_(mg)",@"锌",
                                          @"Fiber_TD_(g)",@"纤维素",
                                          @"Protein_(g)",@"蛋白质",
                                          nil];
    
    
    NSMutableArray *diseaseNames = [NSMutableArray arrayWithCapacity:100];
    NSMutableArray *nutrientDescs = [NSMutableArray arrayWithCapacity:40];
    
    
    int idxRow,idxCol;
    
    idxRow=startRowPos+1;
    int columnPos_diseaseName = startColumnPos+1;
    BOOL existDiseaseRow = false;
    do {
        cell = [reader cellInWorkSheetIndex:sheetIndex row:idxRow col:columnPos_diseaseName];
        existDiseaseRow = (cell.type!=cellBlank && cell.str.length>0);
        if (existDiseaseRow){
            NSString *diseaseName = cell.str;
            NSLog(@"diseaseName: %@ [%d]",diseaseName,idxRow);
            [diseaseNames addObject:diseaseName];
        }
        idxRow++;
    } while (existDiseaseRow);
    
    idxCol = startColumnPos +2;
    int rowPos_nutrientDesc = startRowPos;
    BOOL existNutrientDesc = false;
    do {
        cell = [reader cellInWorkSheetIndex:sheetIndex row:rowPos_nutrientDesc col:idxCol];
        existNutrientDesc = (cell.type!=cellBlank && cell.str.length>0);
        if (existNutrientDesc){
            NSString *nutrientDesc = cell.str;
            NSLog(@"nutrientDesc: %@ [%d]",nutrientDesc,idxCol);
            [nutrientDescs addObject:nutrientDesc];
        }
        idxCol++;
    } while (existNutrientDesc);
    [nutrientDescs removeLastObject];
    for(int i=0; i<nutrientDescs.count; i++){
        assert(nutrientDescToIdDict[nutrientDescs[i]]!=nil);
    }
    
    DHcell *cellDiseaseGroup = [reader cellInWorkSheetIndex:sheetIndex row:startRowPos col:startColumnPos+1];
    NSString *sDiseaseGroup = [cellDiseaseGroup str];
    assert(sDiseaseGroup.length>0);
    NSLog(@"sDiseaseGroup: %@",sDiseaseGroup);
    
    NSMutableArray * diseaseNutrientAry = [NSMutableArray arrayWithCapacity:2000];
    NSMutableArray * validDiseaseNames = [NSMutableArray arrayWithCapacity:diseaseNames.count];
    for(int iRow=0 ; iRow<diseaseNames.count ; iRow++){
        int idxRow = startRowPos+1+iRow;
        NSString *diseaseName = diseaseNames[iRow];
        DHcell *cellDiseaseDisabled = [reader cellInWorkSheetIndex:sheetIndex row:idxRow col:startColumnPos];
        if (cellDiseaseDisabled.type!=cellBlank && cellDiseaseDisabled.val!=nil && [cellDiseaseDisabled.val intValue]==1){
            continue;
        }
        [validDiseaseNames addObject:diseaseName];
        
        for(int iCol=0 ; iCol<nutrientDescs.count ; iCol++){
            NSString *nutrientDesc = nutrientDescs[iCol];
            NSString *nutrientId = nutrientDescToIdDict[nutrientDesc];
            
            int idxCol = startColumnPos+2+iCol;
            //            NSLog(@"[%d,%d]",idxRow,idxCol);
            DHcell *cellFlag = [reader cellInWorkSheetIndex:sheetIndex row:idxRow col:idxCol];
            if (cellFlag.type!=cellBlank && cellFlag.val!=nil && [cellFlag.val intValue]==1){
                NSArray *diseaseNutrient = [NSArray arrayWithObjects: diseaseName, nutrientId, nil];
                NSLog(@"diseaseNutrient: %@ %@ %@ [%d,%d]",diseaseName,nutrientId,nutrientDesc,idxRow,idxCol);
                [diseaseNutrientAry addObject:diseaseNutrient];
            }
        }//for iCol
    }//for iRow
    
    
    
    //    NSLog(@"in readNutrientDisease, columnNames=%@, rows2D=\n%@",columnNames,diseaseNutrientAry);
    NSMutableDictionary *retData = [NSMutableDictionary dictionaryWithCapacity:2];
//    [retData setObject:columnNames forKey:@"columnNames"];
    [retData setObject:diseaseNutrientAry forKey:@"rows2D"];
    [retData setObject:sDiseaseGroup forKey:@"DiseaseGroup"];
    [retData setObject:validDiseaseNames forKey:@"validDiseaseNames"];
    return retData;
}








@end











































