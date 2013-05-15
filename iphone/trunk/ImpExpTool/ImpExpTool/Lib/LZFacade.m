//
//  LZFacade.m
//  ImpExpTool
//
//  Created by Yasofon on 13-5-14.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import "LZFacade.h"

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
//    [workRe generateCustomUSDASqliteDataFromFullSqliteDataAndExcelDigestData_V2];
//    [workRe convertExcelToSqlite_FoodLimit];
//    [workRe convertExcelToSqlite_FoodCnDescription];
    
    
//    //    LZDBAccess *db = [LZDBAccess singletonCustomDB];
//    LZDBAccess *db = [workRe getDBconnection];
//    [db generateDataTable_Food_Supply_DRI_Common_withIfNeedClearTable:true];
    
    

}

+(void)test2{
    NSString *originDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"CustomDB.dat"];
    
    NSString *destDbFileName = @"CustomDBt1.dat";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *destDbFilePath = [documentsDirectory stringByAppendingPathComponent:destDbFileName];
    
    NSFileManager * defFileManager = [NSFileManager defaultManager];
    NSError *err = nil;
    [defFileManager removeItemAtPath:destDbFilePath error:&err];
    if (err != nil){
        NSLog(@"test2, defFileManager removeItemAtPath err=%@",err);
    }
    [defFileManager copyItemAtPath:originDBPath toPath:destDbFilePath error:&err];
    if (err != nil){
        NSLog(@"test2, defFileManager copyItemAtPath err=%@",err);
        return;
    }

    LZDBAccess *db = [[LZDBAccess alloc]init];
    [db myInitWithDbFilePath:destDbFilePath andIfNeedClear:FALSE];
//    [db generateDataTable_Food_Supply_DRI_Common_withIfNeedClearTable:true];
//    [db generateDataTable_Food_Supply_DRI_Amount_withIfNeedClearTable:true];
    [db convertFood_Supply_DRI_AmountWithExtraInfoToCsv:@"Food_Supply_DRI_Amount_Extra.csv"];

}



+(void)generateInitialData{
    
    LZReadExcel *workRe = [[LZReadExcel alloc]init];
    
    NSString *destDbFileName = @"data1.dat";
    [workRe myInitDBConnectionWithFilePath:destDbFileName andIfNeedClear:true];
    
    [workRe convertDRIFemaleDataFromExcelToSqlite];
    [workRe convertDRIMaleDataFromExcelToSqlite];
    [workRe generateCustomUSDASqliteDataFromFullSqliteDataAndExcelDigestData_V2];
    [workRe convertExcelToSqlite_FoodLimit];
    [workRe convertExcelToSqlite_FoodCnDescription];

    LZDBAccess *db = [workRe getDBconnection];
    [db generateDataTable_Food_Supply_DRI_Common_withIfNeedClearTable:true];
    [db generateDataTable_Food_Supply_DRI_Amount_withIfNeedClearTable:true];

}











@end
