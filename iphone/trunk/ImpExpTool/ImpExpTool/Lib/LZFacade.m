//
//  LZFacade.m
//  ImpExpTool
//
//  Created by Yasofon on 13-5-14.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import "LZFacade.h"

#import "LZUtility.h"
#import "LZReadExcel.h"
#import "LZDBAccess.h"

@implementation LZFacade

+(void)test1{
    
    LZReadExcel *workRe = [[LZReadExcel alloc]init];
    
    NSString *destDbFileName = @"data1.dat";
    [workRe myInitDBConnectionWithFilePath:destDbFileName andIfNeedClear:true];
    
    //    [workRe convertExcelToSqlite_USDA_ABBREV_withDebugFlag:true];
    //    //[workRe convertExcelToSqlite_USDA_ABBREV_withDebugFlag:false];//生成正式的数据应该用这个
    
//    [workRe convertDRIFemaleDataFromExcelToSqlite];
//    [workRe convertDRIMaleDataFromExcelToSqlite];
    [workRe generateCustomUSDASqliteDataFromFullSqliteDataAndExcelDigestData_V2];
//    [workRe convertExcelToSqlite_FoodLimit];
//    [workRe convertExcelToSqlite_FoodCnDescription];
//    [workRe convertExcelToSqlite_NutritionInfo];
//    [workRe convertExcelToSqlite_FoodPicPath];
    
    
//    //    LZDBAccess *db = [LZDBAccess singletonCustomDB];
//    LZDBAccess *db = [workRe getDBconnection];
//    [db generateDataTable_Food_Supply_DRI_Common_withIfNeedClearTable:true];
    
    

}

+(void)test2{
    NSString *resFileName = @"CustomDB.dat";
    NSString *destDbFileName = @"CustomDBt1.dat";
    NSString *destDbFilePath = [LZUtility copyResourceToDocumentWithResFileName:resFileName andDestFileName:destDbFileName];
    if (destDbFilePath == nil){
        NSLog(@"test2 fail, destDbFilePath == nil");
        return;
    }

    LZDBAccess *db = [[LZDBAccess alloc]init];
    [db myInitWithDbFilePath:destDbFilePath andIfNeedClear:FALSE];
//    [db generateDataTable_Food_Supply_DRI_Common_withIfNeedClearTable:true];
//    [db generateDataTable_Food_Supply_DRI_Amount_withIfNeedClearTable:true];
    [db convertFood_Supply_DRI_AmountWithExtraInfoToCsv:@"Food_Supply_DRI_Amount_Extra.csv"];

}


+(void)generateVariousCsv
{
    NSString *resFileName = @"CustomDB.dat";
    NSString *destDbFileName = @"CustomDBt1.dat";
    NSString *destDbFilePath = [LZUtility copyResourceToDocumentWithResFileName:resFileName andDestFileName:destDbFileName];
    if (destDbFilePath == nil){
        NSLog(@"generateVariousCsv fail, destDbFilePath == nil");
        return;
    }
    LZDBAccess *db = [[LZDBAccess alloc]init];
    [db myInitWithDbFilePath:destDbFilePath andIfNeedClear:FALSE];
    [db convertFood_Supply_DRI_AmountWithExtraInfoToCsv:@"Food_Supply_DRI_Amount_Extra.csv"];
    
    
    NSString *resFileName2 = @"dataAll.dat";
    NSString *destDbFileName2 = @"dataAllt1.dat";
    NSString *destDbFilePath2 = [LZUtility copyResourceToDocumentWithResFileName:resFileName2 andDestFileName:destDbFileName2];
    if (destDbFilePath2 == nil){
        NSLog(@"generateVariousCsv fail, destDbFilePath2 == nil");
        return;
    }
    LZDBAccess *db2 = [[LZDBAccess alloc]init];
    [db2 myInitWithDbFilePath:destDbFilePath2 andIfNeedClear:FALSE];
    [db2 convertCnFoodNutritionWithExtraInfoToCsv:@"FoodNutritionCustomByJoin.csv"];
}


/*
 生成食物营养推荐算法所需的各个数据表，依赖于USDAFullDataInSqlite.dat和其他所有的*.xls文件。
 生成后的数据所在的文件的路径见log中的输出信息，可以用于更新算法所需的CustomDB.dat文件。
 */
+(void)generateInitialData
{
    NSString *destDbFileName = @"data1.dat";
    LZReadExcel *workRe = [[LZReadExcel alloc]init];
    [workRe myInitDBConnectionWithFilePath:destDbFileName andIfNeedClear:true];
    [self.class generateInitialDataWithFileNameOrPath:workRe];

}

+(void)generateInitialDataWithFileNameOrPath:(LZReadExcel *)workRe
{

    [workRe convertDRIFemaleDataFromExcelToSqlite];
    [workRe convertDRIMaleDataFromExcelToSqlite];
    [workRe generateCustomUSDASqliteDataFromFullSqliteDataAndExcelDigestData_V2];
    [workRe convertExcelToSqlite_FoodLimit];
    [workRe convertExcelToSqlite_FoodCnDescription];
    [workRe convertExcelToSqlite_NutritionInfo];
    [workRe convertExcelToSqlite_FoodPicPath];

    LZDBAccess *db = [workRe getDBconnection];
    [db generateDataTable_Food_Supply_DRI_Common_withIfNeedClearTable:true];
    [db generateDataTable_Food_Supply_DRI_Amount_withIfNeedClearTable:true];
}

/*
 与generateInitialData相比，多了合并USDAFullDataInSqlite.dat中的数据，这样形成一个包括所有数据的sqlite文件。
 */
+(void)generateInitialDataToAllInOne
{
    NSString *resFileName = @"USDAFullDataInSqlite.dat";
    NSString *destDbFileName = @"data2all.dat";
    NSString *destDbFilePath = [LZUtility copyResourceToDocumentWithResFileName:resFileName andDestFileName:destDbFileName];
    if (destDbFilePath == nil){
        NSLog(@"generateInitialDataToAllInOne fail, destDbFilePath == nil");
        return;
    }
    LZReadExcel *workRe = [[LZReadExcel alloc]init];
    [workRe myInitDBConnectionWithFilePath:destDbFilePath andIfNeedClear:FALSE];
    
    [self.class generateInitialDataWithFileNameOrPath:workRe];

}








@end
