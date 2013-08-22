//
//  LZReadExcel.h
//  tExcelToSqlite
//
//  Created by Yasofon on 13-4-26.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHxlsReaderIOS.h"
#import "LZDBAccess.h"
@interface LZReadExcel : NSObject{
    LZDBAccess *dbCon;
}

-(void)myInitDBConnectionWithFilePath: (NSString *)dbFileNameOrPath andIfNeedClear:(BOOL) needClear;
-(LZDBAccess*)getDBconnection;

-(void)convertExcelToSqlite_USDA_ABBREV_withDebugFlag : (BOOL)ifDebug;


//-(void)generateCustomUSDASqliteDataFromFullSqliteDataAndExcelDigestData_V2;
//-(void)convertExcelToSqlite_FoodCnDescription;
//-(void)convertExcelToSqlite_FoodCustom;
-(void)convertExcelToSqlite_FoodCustom_v1_3;


-(BOOL)checkExcelForFoodPicPath;
-(void)convertExcelToSqlite_CustomRichFood;


-(void)convertDRIFemaleDataFromExcelToSqlite;
-(void)convertDRIMaleDataFromExcelToSqlite;
-(void)convertDRIULFemaleDataFromExcelToSqlite;
-(void)convertDRIULMaleDataFromExcelToSqlite;

-(void)dealDRIandULdataFromExcelToSqliteForFemale;
-(void)dealDRIandULdataFromExcelToSqliteForMale;


//-(void)convertExcelToSqlite_FoodLimit;

-(void)convertExcelToSqlite_NutritionInfo;

//-(void)convertExcelToSqlite_FoodPicPath;




//-(void)dealExcelAndSqlite_FoodCustomT2;
//-(void)mergeFoodPicPathAndFoodLimitToFoodcommon;

-(NSString*)generateCsv_ToMerge_FoodCustomnAndDRIULAmount_withCsvFileName:(NSString*)csvFileName;

-(void)convertExcelToSqlite_NutrientDisease;
-(NSDictionary *)readNutrientDiseaseSheet_withDepartment:(int)sheetIndex;


@end










