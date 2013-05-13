
//
//  Created by Yasofon on 13-4-26.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"



@interface LZDBAccess : NSObject

//+(LZDBAccess *)singleton;
+(LZDBAccess *)singletonCustomDB ;

- (FMDatabase *)db;


- (void)doSome;

-(void)myInitWithDbFilePath: (NSString *)dbFilePath andIfNeedClear:(BOOL) needClear;

-(NSMutableDictionary *)queryUSDADataByIds:(NSArray *)idAry;

-(void)createTableUSDA_ABBREV_withColumnNames : (NSArray*)columnNames andIfNeedDropTable:(BOOL)needDrop;
-(void)insertToTable_USDA_ABBREV_withColumnNames: (NSArray*)columnNames andRows:(NSArray*)rows andIfNeedClearTable:(BOOL)needClear;

-(void)createDRItable:(NSString*)tableName andColumnNames:(NSArray*)columnNames;
-(void)insertToDRItable:(NSString*)tableName andColumnNames:(NSArray*)columnNames andData:(NSArray*)rows;

//-(void)createCustomUSDAtable_V1 : (NSArray*)columnNamesForUSDA;
//-(void)insertToCustomUSDAtable_V1 :(NSArray *)idAry andCnCaptionArray:(NSArray*)cnCaptionAry andDictForRowsAndColumns:(NSMutableDictionary *)dictRowsCols;

-(void)createCustomUSDAtable_V2 : (NSArray*)columnNamesOfABBREV andIfNeedDropTable:(BOOL)needDrop;
-(void)insertToCustomUSDAtable_V2 :(NSDictionary *)customData andRowsAndColumns:(NSMutableDictionary *)dictRowsCols andIfNeedClearTable:(BOOL)needClear;


//- (NSDictionary *)getDRIbyGender:(NSString*)gender andAge:(int)age;
//-(void)initTable_Food_Supply_DRIWithGender :(NSString *)gender andAge:(int)age;

-(void)createTable_Food_Supply_DRI_Common_withIfNeedDropTable:(BOOL)needDrop;
-(void)initTable_Food_Supply_DRI_Common_withIfNeedClearTable:(BOOL)needClear;
-(void)generateDataTable_Food_Supply_DRI_Common_withIfNeedClearTable:(BOOL)needClear;



@end















