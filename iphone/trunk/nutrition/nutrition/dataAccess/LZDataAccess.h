//
//  LZDataAccess.h
//  tSql
//
//  Created by Yasofon on 13-2-4.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "LZDataAccess.h"

#define cDbFile    @"CustomDB.dat"


@interface LZDataAccess : NSObject{
    FMDatabase *dbfm;
}
+(LZDataAccess *)singleton;

+ (NSString *)dbFilePath;

- (id)initDBConnection;


-(NSString *)replaceForSqlText:(NSString *)origin;
+(NSDictionary *)findRowByKey:(NSArray *)rows andKeyName:(NSString *)keyname andKeyValue:(NSString *)keyvalue;
+(NSArray *)FMResultSetToDictionaryArray:(FMResultSet *)rs;
- (NSArray *)selectAllForTable:(NSString *)tableName;
- (NSArray *)selectTableByEqualFilter:(NSString *)tableName andField:(NSString *)fieldName andValue:(NSObject*)fieldValue;

- (NSDictionary *)getDRIbyGender:(NSString*)gender andAge:(int)age ;
-(NSArray *) getRichNutritionFood:(NSString *)nutrientAsColumnName andTopN:(int)topN;

-(NSArray *) getAllFood;


@end
