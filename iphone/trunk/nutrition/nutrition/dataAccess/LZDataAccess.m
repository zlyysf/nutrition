//
//  LZDataAccess.m
//  tSql
//
//  Created by Yasofon on 13-2-4.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import "LZDataAccess.h"
#import "LZConstants.h"
#import "LZUtility.h"

@implementation LZDataAccess

+(LZDataAccess *)singleton {
    static dispatch_once_t pred;
    static LZDataAccess *shared;
    // Will only be run once, the first time this is called
    dispatch_once(&pred, ^{
        shared = [[LZDataAccess alloc] initDBConnection];
    });
    return shared;
}

+ (NSString *)dbFilePath {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:cDbFile];
    
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:cDbFile];
    NSLog(@"dbFilePath=%@",filePath);
    return filePath;
}


- (id)initDBConnection{
    self = [super init];
    if (self) {
        NSString *dbFilePath = [self.class dbFilePath];
        
        NSFileManager * defFileManager = [NSFileManager defaultManager];
        BOOL fileExists,isDir;
        fileExists = [defFileManager fileExistsAtPath:dbFilePath isDirectory:&isDir];
        if (!fileExists){            
            NSLog(@"INFO in initDBConnection, db file not exist: %@",dbFilePath);
        }else{
            NSLog(@"INFO in initDBConnection, db file exist: %@",dbFilePath);
        }
        
        dbfm = [FMDatabase databaseWithPath:dbFilePath];
        if (![dbfm open]) {
            //[dbfm release];
            NSLog(@"initDBConnection, FMDatabase databaseWithPath failed, %@", dbFilePath);
        }
    }
    return self;
}











/*
 sex:0 for male.  weight kg, height cm
 */
-(NSDictionary*)getStandardDRIForSex:(int )sex age:(int)age weight:(float)weight height:(float)height activityLevel:(int )activityLevel
{
    float PA;
    float heightM = height/100.f;
    int energyStandard;
    int carbohydrtStandard;
    int fatStandard;
    int proteinStandard;
    if (sex == 0)//male
    {
        if (age>=1 && age<3)
        {
            energyStandard = 89*weight-100+20;
        }
        else if (age>=3 && age<9)
        {
            switch (activityLevel) {
                case 0:
                    PA = 1.0;
                    break;
                case 1:
                    PA = 1.13;
                    break;
                case 2:
                    PA = 1.26;
                    break;
                case 3:
                    PA = 1.42;
                    break;
                default:
                    PA = 1.0;
                    break;
            }
            energyStandard = 88.5 - 61.9*age +PA*(26.7 *weight +903*heightM)+20;
        }
        else if (age>=9 && age<19)
        {
            switch (activityLevel) {
                case 0:
                    PA = 1.0;
                    break;
                case 1:
                    PA = 1.13;
                    break;
                case 2:
                    PA = 1.26;
                    break;
                case 3:
                    PA = 1.42;
                    break;
                default:
                    PA = 1.0;
                    break;
            }
            
            energyStandard = 88.5 - 61.9*age +PA*(26.7 *weight +903*heightM)+25;
        }
        else
        {
            switch (activityLevel) {
                case 0:
                    PA = 1.0;
                    break;
                case 1:
                    PA = 1.11;
                    break;
                case 2:
                    PA = 1.25;
                    break;
                case 3:
                    PA = 1.48;
                    break;
                default:
                    PA = 1.0;
                    break;
            }
            
            energyStandard = 662 - 9.53*age +PA*(15.91 *weight +539.6*heightM);
        }
        
    }
    else//female
    {
        if (age>=1 && age<3)
        {
            energyStandard = 89*weight-100+20;
        }
        else if (age>=3 && age<9)
        {
            switch (activityLevel) {
                case 0:
                    PA = 1.0;
                    break;
                case 1:
                    PA = 1.16;
                    break;
                case 2:
                    PA = 1.31;
                    break;
                case 3:
                    PA = 1.56;
                    break;
                default:
                    PA = 1.0;
                    break;
            }
            
            energyStandard = 135.3 - 30.8*age +PA*(10 *weight +934*heightM)+20;
        }
        else if (age>=9 && age<19)
        {
            switch (activityLevel) {
                case 0:
                    PA = 1.0;
                    break;
                case 1:
                    PA = 1.16;
                    break;
                case 2:
                    PA = 1.31;
                    break;
                case 3:
                    PA = 1.56;
                    break;
                default:
                    PA = 1.0;
                    break;
            }
            
            energyStandard = 135.3 - 30.8*age +PA*(10 *weight +934*heightM)+25;
        }
        else
        {
            switch (activityLevel) {
                case 0:
                    PA = 1.0;
                    break;
                case 1:
                    PA = 1.12;
                    break;
                case 2:
                    PA = 1.27;
                    break;
                case 3:
                    PA = 1.45;
                    break;
                default:
                    PA = 1.0;
                    break;
            }
            
            energyStandard = 354 - 6.91*age +PA*(9.36 *weight +726*heightM);
        }
        
        
    }
    //self.energyStandardLabel.text = [NSString stringWithFormat:@"%d kcal",energyStandard];
    
    carbohydrtStandard = (int)(energyStandard*0.45*kCarbFactor+0.5);//(int)(energyStandard*0.65*kCarbFactor+0.5);
    
    if (age>=1 && age<4)
    {
        fatStandard = 0;//[NSString stringWithFormat:@"0 ~ %d", (int)(energyStandard*0.4*kFatFactor+0.5)];
    }
    else
    {
        if(age >= 4 && age<19)
        {
            fatStandard = (int)(energyStandard*0.25*kFatFactor+0.5);//, (int)(energyStandard*0.35*kFatFactor+0.5)];
        }
        else
        {
            fatStandard = (int)(energyStandard*0.2*kFatFactor+0.5);//, (int)(energyStandard*0.35*kFatFactor+0.5)];
        }
    }
    
    float proteinFactor;
    
    if (age>=1 && age<4)
    {
        proteinFactor = 1.05;
    }
    else if (age>=4 && age<14)
    {
        proteinFactor = 0.95;
    }
    else if (age>=14 && age<19)
    {
        proteinFactor =0.85;
    }
    else
    {
        proteinFactor = 0.8;
    }
    
    proteinStandard =(int)( weight*proteinFactor+0.5);
    NSLog(@"getStandardDRIForSex ret: energyStandard : %d \n Carbohydrt : %d \n Fat : %d \n Protein : %d",energyStandard,carbohydrtStandard,fatStandard,proteinStandard);
    NSDictionary *standardResult = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:energyStandard],@"Energ_Kcal",[NSNumber numberWithInt:carbohydrtStandard],@"Carbohydrt_(g)",[NSNumber numberWithInt:fatStandard],@"Lipid_Tot_(g)",[NSNumber numberWithInt:proteinStandard],@"Protein_(g)",nil];
    return standardResult;
}


-(NSDictionary*)getStandardDRIs:(int)sex age:(int)age weight:(float)weight height:(float)height activityLevel:(int )activityLevel
{
    NSDictionary *part1 = [self getStandardDRIForSex:sex age:age weight:weight height:height activityLevel:activityLevel];
    LZDataAccess *da = [LZDataAccess singleton];
    NSString *gender = @"male";
    if (sex !=0)
        gender = @"female";
    NSDictionary *part2 = [da getDRIbyGender:gender andAge:age];
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithDictionary:part1];
    [ret addEntriesFromDictionary:part2];
    NSLog(@"getStandardDRIs ret:\n%@",ret);
    return ret;
}


-(NSDictionary*)getAbstractPersonDRIs
{
    NSDictionary *maleDRIs = [self getStandardDRIs:0 age:25 weight:70 height:175 activityLevel:1];
    NSDictionary *femaleDRIs = [self getStandardDRIs:1 age:25 weight:70 height:175 activityLevel:1];
    NSMutableDictionary *personDRIs = [NSMutableDictionary dictionaryWithCapacity:maleDRIs.count];
    NSArray *keys = maleDRIs.allKeys;
    for(int i=0; i<keys.count; i++){
        NSString* key = keys[i];
        NSNumber *nmM = [maleDRIs objectForKey:key];
        NSNumber *nmF = [femaleDRIs objectForKey:key];
        double avg = ([nmM doubleValue]+[nmF doubleValue])/2.0;
        [personDRIs setObject:[NSNumber numberWithDouble:avg] forKey:key];
    }
    NSLog(@"getAbstractPersonDRIs ret:\n%@",personDRIs);
    return personDRIs;
}











+(NSArray *)FMResultSetToDictionaryArray:(FMResultSet *)rs
{
    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:10];
    while ([rs next]) {
        NSDictionary *rowDict = rs.resultDictionary;
        [ary addObject:rowDict];
    }
    return ary;
}

+(NSDictionary *)findRowByKey:(NSArray *)rows andKeyName:(NSString *)keyname andKeyValue:(NSString *)keyvalue
{
    for(int i=0; i<rows.count; i++){
        NSDictionary *row = rows[i];
        NSString *columnVal = [row objectForKey:keyname];
        if ([columnVal isEqualToString:keyvalue]){
            return row;
        }
    }
    return nil;
}

-(NSString *)replaceForSqlText:(NSString *)origin
{
    return [origin stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
}


- (NSArray *)selectAllForTable:(NSString *)tableName
{
    NSString *query = [NSString stringWithFormat: @"SELECT * FROM %@",tableName];
    FMResultSet *rs = [dbfm executeQuery:query];
    NSArray *ary = [[self class] FMResultSetToDictionaryArray:rs];
    return ary;
}

- (NSArray *)selectTableByEqualFilter:(NSString *)tableName andField:(NSString *)fieldName andValue:(NSObject*)fieldValue
{
    NSString *query = [NSString stringWithFormat: @"SELECT * FROM %@ WHERE %@=:fieldValue",tableName,fieldName];
    NSDictionary *dictQueryParam = [NSDictionary dictionaryWithObjectsAndKeys:fieldValue, @"fieldValue", nil];
    FMResultSet *rs = [dbfm executeQuery:query withParameterDictionary:dictQueryParam];
    NSArray *ary = [[self class] FMResultSetToDictionaryArray:rs];
    return ary;
}










- (NSDictionary *)getDRIbyGender:(NSString*)gender andAge:(int)age {
    NSString *tableName = @"DRIMale";
    if ([@"female" isEqualToString:gender]){
        tableName = @"DRIFemale";
    }
    
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*1];
    [sqlStr appendString:@"SELECT * FROM "];
    [sqlStr appendString:tableName];
    [sqlStr appendString:@" WHERE Start <= ? "];
    [sqlStr appendString:@" ORDER BY Start desc"];
    
    NSArray * argAry = [NSArray arrayWithObjects:[NSNumber numberWithInt:age], nil];
    NSDictionary *rowDict = nil;
    FMResultSet *rs = [dbfm executeQuery:sqlStr withArgumentsInArray:argAry];
    if ([rs next]) {
        rowDict = rs.resultDictionary;
    }
    NSLog(@"getDRIbyGender get:\n%@",rowDict);
    NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithDictionary:rowDict];
    [retDict removeObjectForKey:@"Start"];
    [retDict removeObjectForKey:@"End"];
    NSLog(@"getDRIbyGender ret:\n%@",retDict);
    return retDict;
}



//-(NSArray *) getRichNutritionFood:(NSString *)nutrientAsColumnName andTopN:(int)topN
//{
//    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*1];
//    [sqlStr appendString:@"SELECT * FROM FoodNutritionCustom"];
//    [sqlStr appendString:@" ORDER BY "];
//    //[sqlStr appendString:@"'"];
//    [sqlStr appendString:@"["];
//    [sqlStr appendString:nutrientAsColumnName];
//    //[sqlStr appendString:@"' desc"];
//    [sqlStr appendString:@"] desc"];
//    [sqlStr appendString:@" LIMIT "];
//    [sqlStr appendString:[[NSNumber numberWithInt:topN] stringValue]];
//    NSLog(@"getRichNutritionFood sqlStr=%@",sqlStr);
//
//    FMResultSet *rs = [dbfm executeQuery:sqlStr];
//    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];
//    assert(dataAry.count > 0);
//    NSLog(@"getRichNutritionFood ret:\n%@",dataAry);
//    return dataAry;
//}

-(NSArray *) getRichNutritionFood:(NSString *)nutrientAsColumnName andTopN:(int)topN
{
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*1];
    [sqlStr appendString:@"SELECT F.* ,FL.[Lower_Limit(g)],FL.[Upper_Limit(g)], \n"];
    [sqlStr appendString:@"D.["];
    [sqlStr appendString:nutrientAsColumnName];
    [sqlStr appendString:@"] AS RichLevel \n"];

    [sqlStr appendString:@"  FROM FoodNutritionCustom F join Food_Supply_DRI_Common D on F.NDB_No=D.NDB_No \n"];
    [sqlStr appendString:@"    LEFT OUTER JOIN FoodLimit FL ON F.NDB_No=FL.NDB_No \n"];
    [sqlStr appendString:@" WHERE "];
    [sqlStr appendString:@"D.["];
    [sqlStr appendString:nutrientAsColumnName];
    [sqlStr appendString:@"]"];
    [sqlStr appendString:@">0"];
    
    [sqlStr appendString:@"\n ORDER BY "];
    [sqlStr appendString:@"D.["];
    [sqlStr appendString:nutrientAsColumnName];
    [sqlStr appendString:@"] ASC"];
    
    [sqlStr appendString:@"\n LIMIT "];
    [sqlStr appendString:[[NSNumber numberWithInt:topN] stringValue]];
    NSLog(@"getRichNutritionFood sqlStr=%@",sqlStr);
    
    FMResultSet *rs = [dbfm executeQuery:sqlStr];
    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];
    assert(dataAry.count > 0);
    NSLog(@"getRichNutritionFood ret:\n%@",dataAry);
    return dataAry;
}


-(NSArray *) getAllFood
{
    NSString *query = @""
    "SELECT * FROM FoodNutritionCustom"
    " ORDER BY CnType, NDB_No"
    ;

    FMResultSet *rs = [dbfm executeQuery:query];
    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];
    assert(dataAry.count > 0);
    //NSLog(@"getAllFood ret:\n%@",dataAry);
    return dataAry;
}




/*
 idAry 的元素需要是字符串类型。
 返回值是array。
 */
-(NSArray *)getFoodByIds:(NSArray *)idAry
{
    NSLog(@"getFoodByIds begin");
    if (idAry==nil || idAry.count ==0)
        return nil;
    NSMutableArray *placeholderAry = [NSMutableArray arrayWithCapacity:idAry.count];
    for(int i=0; i<idAry.count; i++){
        [placeholderAry addObject:@"?"];
    }
    NSString *placeholdersStr = [placeholderAry componentsJoinedByString:@","];
    
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*100];
    [sqlStr appendString:@"SELECT * FROM FoodNutritionCustom WHERE NDB_No in ("];
    [sqlStr appendString:placeholdersStr];
    [sqlStr appendString:@")"];
    
    FMResultSet *rs = [dbfm executeQuery:sqlStr withArgumentsInArray:idAry];
    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];
    assert(dataAry.count > 0);
    NSLog(@"getFoodByIds ret:\n%@",dataAry);
    return dataAry;
}

/*
 idAry 的元素需要是字符串类型。
 返回值是array。
 */
-(NSArray *)getFoodAttributesByIds:(NSArray *)idAry
{
    NSLog(@"getFoodAttributesByIds begin");
    if (idAry==nil || idAry.count ==0)
        return nil;
    NSMutableArray *placeholderAry = [NSMutableArray arrayWithCapacity:idAry.count];
    for(int i=0; i<idAry.count; i++){
        [placeholderAry addObject:@"?"];
    }
    NSString *placeholdersStr = [placeholderAry componentsJoinedByString:@","];
    
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*100];
    [sqlStr appendString:@"SELECT FNC.*,FL.[Lower_Limit(g)],FL.[Upper_Limit(g)]\n"];
    [sqlStr appendString:@"  FROM FoodNutritionCustom FNC LEFT OUTER JOIN FoodLimit FL ON FNC.NDB_No=FL.NDB_No\n"];
    [sqlStr appendString:@"  WHERE FNC.NDB_No in ("];
    [sqlStr appendString:placeholdersStr];
    [sqlStr appendString:@")"];
    NSLog(@"getFoodAttributesByIds sqlStr=%@",sqlStr);
    FMResultSet *rs = [dbfm executeQuery:sqlStr withArgumentsInArray:idAry];
    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];
    assert(dataAry.count > 0);
    NSLog(@"getFoodAttributesByIds ret:\n%@",dataAry);
    return dataAry;
}


/*
 用以支持得到nutrients的信息数据，并可以通过普通的nutrient的列名取到相应的nutrient信息。
 */
-(NSMutableDictionary*)getNutrientInfoAs2LevelDictionary_withNutrientIds:(NSArray*)nutrientIds
{
    NSLog(@"getNutrientInfoAs2LevelDictionary_withNutrientIds begin");
    if (nutrientIds==nil || nutrientIds.count ==0)
        return nil;
    NSMutableArray *placeholderAry = [NSMutableArray arrayWithCapacity:nutrientIds.count];
    for(int i=0; i<nutrientIds.count; i++){
        [placeholderAry addObject:@"?"];
    }
    NSString *placeholdersStr = [placeholderAry componentsJoinedByString:@","];
    
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*100];
    [sqlStr appendString:@"SELECT * FROM NutritionInfo WHERE NutrientID in ("];
    [sqlStr appendString:placeholdersStr];
    [sqlStr appendString:@")"];
    
    FMResultSet *rs = [dbfm executeQuery:sqlStr withArgumentsInArray:nutrientIds];
    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];
    NSMutableDictionary *dic2Level = [LZUtility dictionaryArrayTo2LevelDictionary_withKeyName:@"NutrientID" andDicArray:dataAry];

    NSLog(@"getNutrientInfoAs2LevelDictionary_withNutrientIds ret:\n%@",dic2Level);
    return dic2Level;
}



















@end




























