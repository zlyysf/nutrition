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
    
    [workRe convertDRIFemaleDataFromExcelToSqlite];
    [workRe convertDRIMaleDataFromExcelToSqlite];
    [workRe generateCustomUSDASqliteDataFromFullSqliteDataAndExcelDigestData_V2];
    
    
    //    LZDBAccess *db = [LZDBAccess singletonCustomDB];
    LZDBAccess *db = [workRe getDBconnection];
    [db generateDataTable_Food_Supply_DRI_Common_withIfNeedClearTable:true];
    
    

}




+(void)generateInitialData{
    
    LZReadExcel *workRe = [[LZReadExcel alloc]init];
    
    NSString *destDbFileName = @"data1.dat";
    [workRe myInitDBConnectionWithFilePath:destDbFileName andIfNeedClear:true];
    
    [workRe convertDRIFemaleDataFromExcelToSqlite];
    [workRe convertDRIMaleDataFromExcelToSqlite];
    [workRe generateCustomUSDASqliteDataFromFullSqliteDataAndExcelDigestData_V2];

    LZDBAccess *db = [workRe getDBconnection];
    [db generateDataTable_Food_Supply_DRI_Common_withIfNeedClearTable:true];

}











@end
