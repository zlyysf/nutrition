
//
//  Created by Yasofon on 13-4-26.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

#import "LZDataAccess.h"
#import "LZDataAccessUtil.h"



@interface LZDBAccess : NSObject

//+(LZDBAccess *)singleton;
+(LZDBAccess *)singletonCustomDB ;

- (FMDatabase *)db;
-(LZDataAccess*)da;


//- (void)doSome;

-(void)myInitWithDbFilePath: (NSString *)dbFilePath andIfNeedClear:(BOOL) needClear;





-(NSMutableDictionary *)queryUSDADataByIds:(NSArray *)idAry;

-(void)createEmptyTables_andIfNeedDrop:(BOOL)needDrop;
-(void)createView_FoodNutritionCustom_andIfNeedDrop:(BOOL)needDrop;
-(void)createTableUSDA_ABBREV_withColumnNames : (NSArray*)columnNames andIfNeedDropTable:(BOOL)needDrop;
-(void)insertToTable_USDA_ABBREV_withColumnNames: (NSArray*)columnNames andRows2D:(NSArray*)rows2D andIfNeedClearTable:(BOOL)needClear;

-(void)createDRItable:(NSString*)tableName andColumnNames:(NSArray*)columnNames;
-(void)insertToDRItable:(NSString*)tableName andColumnNames:(NSArray*)columnNames andData:(NSArray*)rows;

//-(void)createCustomUSDAtable_V1 : (NSArray*)columnNamesForUSDA;
//-(void)insertToCustomUSDAtable_V1 :(NSArray *)idAry andCnCaptionArray:(NSArray*)cnCaptionAry andDictForRowsAndColumns:(NSMutableDictionary *)dictRowsCols;





//-(void)initTable_Food_Supply_DRIWithGender :(NSString *)gender andAge:(int)age;




-(void)generateTableAndData_Food_Supply_DRI_Common_withIfNeedClearTable:(BOOL)needClear;
-(void)generateTableAndData_Food_Supply_DRI_Amount_withIfNeedClearTable:(BOOL)needClear;

-(void)generateTableAndData_Food_Supply_DRIUL_Amount_withIfNeedClearTable:(BOOL)needClear;


-(NSString*)convertFood_Supply_DRI_AmountWithExtraInfoToCsv:(NSString*)csvFileName;
-(NSString*)convertCnFoodNutritionWithExtraInfoToCsv:(NSString*)csvFileName;
-(NSString *)convertRichFoodsOfEveryNutrientsToCsv_withCsvFileName:(NSString*)csvFileName;

-(NSString*)convertFood_Supply_DRIUL_AmountWithExtraInfoToCsv:(NSString*)csvFileName;



-(NSArray *)getFoodOriginalAttributesByIds:(NSArray *)idAry;


-(void)getDifferenceFromFoodCustomAndFoodCustomT2;



@end















