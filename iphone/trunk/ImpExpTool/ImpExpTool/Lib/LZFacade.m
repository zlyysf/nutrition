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

+(void)testMain
{
    [LZFacade test1];
//    [LZFacade test2];
//    [LZFacade test_withSomeExist];
}



+(void)test1{
    
    LZReadExcel *workRe = [[LZReadExcel alloc]init];
    
    NSString *destDbFileName = @"data1.dat";
    [workRe myInitDBConnectionWithFilePath:destDbFileName andIfNeedClear:true];
    
    //    [workRe convertExcelToSqlite_USDA_ABBREV_withDebugFlag:true];
    //    //[workRe convertExcelToSqlite_USDA_ABBREV_withDebugFlag:false];//生成正式的数据应该用这个
    
//    [workRe convertDRIFemaleDataFromExcelToSqlite];
//    [workRe convertDRIMaleDataFromExcelToSqlite];
//    [workRe convertDRIULFemaleDataFromExcelToSqlite];
//    [workRe convertDRIULMaleDataFromExcelToSqlite];
//    [workRe dealDRIandULdataFromExcelToSqliteForFemale];
//    [workRe dealDRIandULdataFromExcelToSqliteForMale];
//    [workRe generateCustomUSDASqliteDataFromFullSqliteDataAndExcelDigestData_V2];
//    [workRe convertExcelToSqlite_FoodLimit];
//    [workRe convertExcelToSqlite_FoodCnDescription];
//    [workRe convertExcelToSqlite_NutritionInfo];
//    [workRe convertExcelToSqlite_FoodPicPath];
//    [workRe convertExcelToSqlite_CustomRichFood];
//    [workRe convertExcelToSqlite_CustomRichFood2];
    
//    [workRe convertExcelToSqlite_NutrientDisease];
////    [workRe readNutrientDiseaseSheet_withDepartment:3];
//    [workRe convertExcelToSqlite_TranslationItem];
    
    [workRe convertExcelToSqlite_SimptomNutrientIllnessSummarySheet];
//    [workRe checkIllnessInferenceTxtdoc];
    
    [[workRe getDBconnection] convertIllnessSuggestionToCsv:@"IllnessSuggestion1.csv"];
    
////    [workRe convertExcelToSqlite_IllnessSuggestionTxtdoc];
    
//    [workRe readSymptomTranslateData];
    
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

+(void)test_withSomeExist
{
    NSString *resFileName = @"CustomDB.dat";
    NSString *destDbFileName = @"CustomDBt2.dat";
    NSString *destDbFilePath = [LZUtility copyResourceToDocumentWithResFileName:resFileName andDestFileName:destDbFileName];
    if (destDbFilePath == nil){
        NSLog(@"generateInitialDataToAllInOne fail, destDbFilePath == nil");
        return;
    }
    LZReadExcel *workRe = [[LZReadExcel alloc]init];
    [workRe myInitDBConnectionWithFilePath:destDbFilePath andIfNeedClear:FALSE];
//    LZDBAccess *db = [workRe getDBconnection];
    
//    [workRe dealExcelAndSqlite_FoodCustomT2];
    
//    [workRe mergeFoodPicPathAndFoodLimitToFoodcommon];
    
}

+(void)runSomeTool
{
    LZReadExcel *workRe = [[LZReadExcel alloc]init];
//    [workRe checkExcelForFoodPicPath];
//    [workRe checkExcelForUnSynchronizedFoodFullEnName];
    
    LZDBAccess *db = [LZDBAccess singletonCustomDB];
    [db.da getFoodCnTypes];
    [db getFoodSingleItemUnitNames];
    
}

+(void)generateVariousCsv_withDBFilePath:(NSString *)dbFilePath
{
    NSString *dbFilePath1 = dbFilePath;
    if (dbFilePath1==nil){
        NSString *resFileName = @"CustomDB.dat";
        NSString *resFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:resFileName];
        dbFilePath1 = resFilePath;
    }
    
    LZDBAccess *db = [[LZDBAccess alloc]init];
    [db myInitWithDbFilePath:dbFilePath1 andIfNeedClear:FALSE];
    [db convertFood_Supply_DRI_AmountWithExtraInfoToCsv:@"Food_Supply_DRI_Amount_Extra.csv"];
    [db convertCnFoodNutritionWithExtraInfoToCsv:@"FoodNutritionCustomByJoin.csv"];
    
//    [db convertRichFoodsOfEveryNutrientsToCsv_withCsvFileName:@"RichFoodsOfEveryNutrients.csv"];
    [db convertRichFoodsOfEveryNutrientsToCsv_withCsvFileName:@"CustomRichFood.csv"];
    
    [db convertFood_Supply_DRIUL_AmountWithExtraInfoToCsv:@"Food_Supply_DRIUL_Amount_Extra.csv"];
    
    [db convertSymptomTypeInfoToCsv:@"SymptomType.csv"];
    [db convertSymptomInfoToCsv:@"Symptom.csv"];
    [db convertIllnessInfoToCsv:@"Illness.csv"];
    [db convertIllnessSuggestionToCsv:@"IllnessSuggestion.csv"];
    
    LZReadExcel *workRe = [[LZReadExcel alloc]init];
    [workRe myInitDBConnectionWithFilePath:dbFilePath1 andIfNeedClear:FALSE];
//    LZDBAccess *db2 = [workRe getDBconnection];
    
    [workRe generateCsv_ToMerge_FoodCustomnAndDRIULAmount_withCsvFileName:@"ToMerge_FoodCustomAndDRIULAmount.csv"];

}


///*
// 生成食物营养推荐算法所需的各个数据表，依赖于USDAFullDataInSqlite.dat和其他所有的*.xls文件。
// 生成后的数据所在的文件的路径见log中的输出信息，可以用于更新算法所需的CustomDB.dat文件。
// 由于 generateCustomUSDASqliteDataFromFullSqliteDataAndExcelDigestData_V2 等已经被别的取代，这里不能再达到产生完整数据的效果了。
// */
//+(void)generateInitialData
//{
//    NSString *destDbFileName = @"data1.dat";
//    LZReadExcel *workRe = [[LZReadExcel alloc]init];
//    [workRe myInitDBConnectionWithFilePath:destDbFileName andIfNeedClear:true];
//    [self.class generateInitialDataWithFileNameOrPath:workRe];
//
//}
//
//+(void)generateInitialDataWithFileNameOrPath:(LZReadExcel *)workRe
//{
//
////    [workRe convertDRIFemaleDataFromExcelToSqlite];
////    [workRe convertDRIMaleDataFromExcelToSqlite];
////    [workRe convertDRIULFemaleDataFromExcelToSqlite];
////    [workRe convertDRIULMaleDataFromExcelToSqlite];
//
//    [workRe dealDRIandULdataFromExcelToSqliteForFemale];
//    [workRe dealDRIandULdataFromExcelToSqliteForMale];
//    
//    [workRe generateCustomUSDASqliteDataFromFullSqliteDataAndExcelDigestData_V2];
//    [workRe convertExcelToSqlite_FoodCnDescription];
//    [workRe convertExcelToSqlite_FoodLimit];
//    [workRe convertExcelToSqlite_NutritionInfo];
//    [workRe convertExcelToSqlite_FoodPicPath];
//
//    LZDBAccess *db = [workRe getDBconnection];
//    [db generateDataTable_Food_Supply_DRI_Common_withIfNeedClearTable:true];
//    [db generateDataTable_Food_Supply_DRI_Amount_withIfNeedClearTable:true];
//}

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
    LZDBAccess *db = [workRe getDBconnection];
    
    if (![workRe checkExcelForFoodPicPath]){
        return;
    }
    
    [workRe convertExcelToSqlite_FoodCustom_v1_3];
    [db createView_FoodNutritionCustom_andIfNeedDrop:true];
    
    [db createEmptyTables_andIfNeedDrop:true];
    
    [workRe dealDRIandULdataFromExcelToSqliteForFemale];
    [workRe dealDRIandULdataFromExcelToSqliteForMale];
    
    [workRe convertExcelToSqlite_NutritionInfo];
    [workRe convertExcelToSqlite_CustomRichFood];
    [workRe convertExcelToSqlite_CustomRichFood2];
    
    [workRe convertExcelToSqlite_NutrientDisease];
    [workRe convertExcelToSqlite_TranslationItem];
    
    [workRe convertExcelToSqlite_SimptomNutrientIllnessSummarySheet];
////    [workRe convertExcelToSqlite_IllnessSuggestionTxtdoc];
    
    [db generateTableAndData_Food_Supply_DRI_Common_withIfNeedClearTable:true];
    [db generateTableAndData_Food_Supply_DRI_Amount_withIfNeedClearTable:true];
    [db generateTableAndData_Food_Supply_DRIUL_Amount_withIfNeedClearTable:true];
    
//    NSMutableArray *foodAmountAry;
//    foodAmountAry = [NSMutableArray array];
//    [foodAmountAry addObject:[NSArray arrayWithObjects:@"01152",[NSNumber numberWithDouble:150], nil]];//牛奶 
//    [foodAmountAry addObject:[NSArray arrayWithObjects:@"01256",[NSNumber numberWithDouble:100], nil]];//酸奶
//    [foodAmountAry addObject:[NSArray arrayWithObjects:@"13359",[NSNumber numberWithDouble:60], nil]];//牛肉
//    [foodAmountAry addObject:[NSArray arrayWithObjects:@"11024",[NSNumber numberWithDouble:50], nil]];//苦瓜
//    [foodAmountAry addObject:[NSArray arrayWithObjects:@"11695",[NSNumber numberWithDouble:150], nil]];//西红柿
//    [foodAmountAry addObject:[NSArray arrayWithObjects:@"09003",[NSNumber numberWithDouble:200], nil]];//苹果
//    [foodAmountAry addObject:[NSArray arrayWithObjects:@"09040",[NSNumber numberWithDouble:200], nil]];//香蕉 
//    [foodAmountAry addObject:[NSArray arrayWithObjects:@"11090",[NSNumber numberWithDouble:100], nil]];//西兰花
//    [db insertFoodCollocationData_withCollocationName:@"减肥瘦身" andFoodAmount2LevelArray:foodAmountAry];
//    
//    foodAmountAry = [NSMutableArray array];
//    [foodAmountAry addObject:[NSArray arrayWithObjects:@"12154",[NSNumber numberWithDouble:50], nil]];//核桃
//    [foodAmountAry addObject:[NSArray arrayWithObjects:@"09146",[NSNumber numberWithDouble:50], nil]];//枣
//    [foodAmountAry addObject:[NSArray arrayWithObjects:@"11167",[NSNumber numberWithDouble:80], nil]];//玉米
//    [foodAmountAry addObject:[NSArray arrayWithObjects:@"18035",[NSNumber numberWithDouble:50], nil]];//面包
//    [foodAmountAry addObject:[NSArray arrayWithObjects:@"05018",[NSNumber numberWithDouble:80], nil]];//鸡皮
//    [foodAmountAry addObject:[NSArray arrayWithObjects:@"09003",[NSNumber numberWithDouble:250], nil]];//苹果
//    [db insertFoodCollocationData_withCollocationName:@"美容养颜" andFoodAmount2LevelArray:foodAmountAry];
    
    [self generateVariousCsv_withDBFilePath:destDbFilePath];
}








@end


























