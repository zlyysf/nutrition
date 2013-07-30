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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:cDbFile];
    
    //    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:cDbFile];
    
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
            NSError *err = nil;
            NSString *preDbFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:cDbFile];
            [defFileManager copyItemAtPath:preDbFilePath toPath:dbFilePath error:&err];
            if (err != nil){
                NSLog(@"initDbMain, fail to copy prepareDbFile to dbFilePath");
                return nil;
            }else{
                NSLog(@"initDbMain, init db data by to copy prepareDbFile to dbFilePath");
            }
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
 范围数值参考5_Summary Table Tables 1-4.pdf 也就是Dietary Reference Intakes: The Essential Guide to Nutrient Requirements（http://nal.usda.gov/fnic/DRI/Essential_Guide/DRIEssentialGuideNutReq.pdf）的PART II ENERGY, MACRONUTRIENTS,WATER, AND PHYSICAL ACTIVITY
 验证正确性是在http://fnic.nal.usda.gov/fnic/interactiveDRI/ usda的DRI计算器 
 先计算出energy摄入推荐量，然后根据数值范围得出 碳水化合物和脂肪的上限值，蛋白质和能量的上限值暂时设为-1
 */


-(NSDictionary*)getStandardDRIULForSex:(int )sex age:(int)age weight:(float)weight height:(float)height activityLevel:(int )activityLevel
{
    float PA;
    float heightM = height/100.f;
    int energyStandard;
    int energyUL = -1;
    int proteinUL = -1;
    int carbohydrtUL;
    int fatUL;
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
    carbohydrtUL = (int)(energyStandard*0.65*kCarbFactor+0.5);
    
    if (age>=1 && age<4)
    {
        fatUL = (int)(energyStandard*0.40*kFatFactor+0.5);
    }
    else
    {
        if(age >= 4 && age<19)
        {
            fatUL = (int)(energyStandard*0.35*kFatFactor+0.5);
        }
        else
        {
            fatUL = (int)(energyStandard*0.35*kFatFactor+0.5);
        }
    }
    
    NSLog(@"getStandardUL : energyStandard : %d \n Carbohydrt : %d \n Fat : %d \n Protein : %d",energyUL,carbohydrtUL,fatUL,proteinUL);
    NSDictionary *ULResult = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:energyUL],@"Energ_Kcal",[NSNumber numberWithInt:carbohydrtUL],@"Carbohydrt_(g)",[NSNumber numberWithInt:fatUL],@"Lipid_Tot_(g)",[NSNumber numberWithInt:proteinUL],@"Protein_(g)",nil];
    return ULResult;
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




-(NSDictionary*)getStandardDRIs:(int)sex age:(int)age weight:(float)weight height:(float)height activityLevel:(int)activityLevel considerLoss:(BOOL)needConsiderLoss
{
    NSDictionary *part1 = [self getStandardDRIForSex:sex age:age weight:weight height:height activityLevel:activityLevel];
    LZDataAccess *da = [LZDataAccess singleton];
    NSString *gender = @"male";
    if (sex !=0)
        gender = @"female";
    NSDictionary *part2 = [da getDRIbyGender:gender andAge:age];
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithDictionary:part1];
    [ret addEntriesFromDictionary:part2];
    
    if (needConsiderLoss){
        ret = [self letDRIConsiderLoss:ret];
    }
    
    NSLog(@"getStandardDRIs ret:\n%@",ret);
    return ret;
}
-(NSDictionary*)getStandardDRIULs:(int)sex age:(int)age weight:(float)weight height:(float)height activityLevel:(int)activityLevel considerLoss:(BOOL)needConsiderLoss
{
    NSDictionary *part1 = [self getStandardDRIULForSex:sex age:age weight:weight height:height activityLevel:activityLevel];
    LZDataAccess *da = [LZDataAccess singleton];
    NSString *gender = @"male";
    if (sex !=0)
        gender = @"female";
    NSDictionary *part2 = [da getDRIULbyGender:gender andAge:age];
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithDictionary:part1];
    [ret addEntriesFromDictionary:part2];
    
    if (needConsiderLoss){
        ret = [self letDRIULConsiderLoss:ret];
    }
    
    NSLog(@"getStandardDRIs ret:\n%@",ret);
    return ret;
}

-(NSDictionary*)getStandardDRIs_withUserInfo:(NSDictionary*)userInfo andOptions:(NSDictionary*)options
{
    NSNumber *nmSex = [userInfo objectForKey:ParamKey_sex];
    NSNumber *nmAge = [userInfo objectForKey:ParamKey_age];
    NSNumber *nmWeight = [userInfo objectForKey:ParamKey_weight];
    NSNumber *nmHeight = [userInfo objectForKey:ParamKey_height];
    NSNumber *nmActivityLevel = [userInfo objectForKey:ParamKey_activityLevel];
    assert(nmSex != nil);
    assert(nmAge != nil);
    assert(nmWeight != nil);
    assert(nmHeight != nil);
    assert(nmActivityLevel != nil);
    int sex = [nmSex intValue];
    int age = [nmAge intValue];
    float weight = [nmWeight floatValue];
    float height = [nmHeight floatValue];
    int activityLevel = [nmActivityLevel intValue];
    
    BOOL needConsiderNutrientLoss = Config_needConsiderNutrientLoss;
    if(options != nil){
        NSNumber *nmFlag_needConsiderNutrientLoss = [options objectForKey:LZSettingKey_needConsiderNutrientLoss];
        if (nmFlag_needConsiderNutrientLoss != nil)
            needConsiderNutrientLoss = [nmFlag_needConsiderNutrientLoss boolValue];
    }
    return [self getStandardDRIs:sex age:age weight:weight height:height activityLevel:activityLevel considerLoss:needConsiderNutrientLoss];
}
-(NSDictionary*)getStandardDRIULs_withUserInfo:(NSDictionary*)userInfo andOptions:(NSDictionary*)options
{
    NSNumber *nmSex = [userInfo objectForKey:ParamKey_sex];
    NSNumber *nmAge = [userInfo objectForKey:ParamKey_age];
    NSNumber *nmWeight = [userInfo objectForKey:ParamKey_weight];
    NSNumber *nmHeight = [userInfo objectForKey:ParamKey_height];
    NSNumber *nmActivityLevel = [userInfo objectForKey:ParamKey_activityLevel];
    assert(nmSex != nil);
    assert(nmAge != nil);
    assert(nmWeight != nil);
    assert(nmHeight != nil);
    assert(nmActivityLevel != nil);
    int sex = [nmSex intValue];
    int age = [nmAge intValue];
    float weight = [nmWeight floatValue];
    float height = [nmHeight floatValue];
    int activityLevel = [nmActivityLevel intValue];
    
    BOOL needConsiderNutrientLoss = Config_needConsiderNutrientLoss;
    if(options != nil){
        NSNumber *nmFlag_needConsiderNutrientLoss = [options objectForKey:LZSettingKey_needConsiderNutrientLoss];
        if (nmFlag_needConsiderNutrientLoss != nil)
            needConsiderNutrientLoss = [nmFlag_needConsiderNutrientLoss boolValue];
    }
    return [self getStandardDRIULs:sex age:age weight:weight height:height activityLevel:activityLevel considerLoss:needConsiderNutrientLoss];
}

-(NSDictionary*)getAbstractPersonDRIsWithConsiderLoss : (BOOL)needConsiderLoss
{
    NSDictionary *maleDRIs = [self getStandardDRIs:0 age:25 weight:70 height:175 activityLevel:1 considerLoss:needConsiderLoss];
    NSDictionary *femaleDRIs = [self getStandardDRIs:1 age:25 weight:70 height:175 activityLevel:1 considerLoss:needConsiderLoss];
    NSMutableDictionary *personDRIs = [NSMutableDictionary dictionaryWithCapacity:maleDRIs.count];
    NSArray *keys = maleDRIs.allKeys;
    for(int i=0; i<keys.count; i++){
        NSString* key = keys[i];
        NSNumber *nmM = [maleDRIs objectForKey:key];
        NSNumber *nmF = [femaleDRIs objectForKey:key];
        double avg = ([nmM doubleValue]+[nmF doubleValue])/2.0;
        [personDRIs setObject:[NSNumber numberWithDouble:avg] forKey:key];
    }
    NSMutableDictionary *retDRI = personDRIs;
    
    NSLog(@"getAbstractPersonDRIsWithConsiderLoss ret:\n%@",retDRI);
    return retDRI;
}
-(NSDictionary*)getAbstractPersonDRIULsWithConsiderLoss : (BOOL)needConsiderLoss
{
    NSDictionary *maleDRIs = [self getStandardDRIULs:0 age:25 weight:70 height:175 activityLevel:1 considerLoss:needConsiderLoss];
    NSDictionary *femaleDRIs = [self getStandardDRIULs:1 age:25 weight:70 height:175 activityLevel:1 considerLoss:needConsiderLoss];
    NSMutableDictionary *personDRIs = [NSMutableDictionary dictionaryWithCapacity:maleDRIs.count];
    NSArray *keys = maleDRIs.allKeys;
    for(int i=0; i<keys.count; i++){
        NSString* key = keys[i];
        NSNumber *nmM = [maleDRIs objectForKey:key];
        NSNumber *nmF = [femaleDRIs objectForKey:key];
        double avg = ([nmM doubleValue]+[nmF doubleValue])/2.0;
        [personDRIs setObject:[NSNumber numberWithDouble:avg] forKey:key];
    }
    NSMutableDictionary *retDRI = personDRIs;
    
    NSLog(@"getAbstractPersonDRIULsWithConsiderLoss ret:\n%@",retDRI);
    return retDRI;
}


-(NSMutableDictionary*)letDRIConsiderLoss:(NSMutableDictionary*)DRIdict
{
    if (DRIdict == nil)
        return nil;
    NSMutableDictionary* DRIdict2 = [NSMutableDictionary dictionaryWithDictionary:DRIdict];
    
    NSMutableDictionary *nutrientInfos = [self getNutrientInfoAs2LevelDictionary_withNutrientIds:nil];
    NSArray *keys = DRIdict2.allKeys;
    
    for(int i=0; i<keys.count; i++){
        NSString* key = keys[i];
        NSNumber *driVal = [DRIdict2 objectForKey:key];
        NSDictionary *nutrientInfo = [nutrientInfos objectForKey:key];
        assert(nutrientInfo!=nil);
        NSNumber *nmLossRate = [nutrientInfo objectForKey:COLUMN_NAME_LossRate];
        double driV2 = [driVal doubleValue];
        if ([nmLossRate doubleValue]>0)
            driV2 = [driVal doubleValue]/(1.0-[nmLossRate doubleValue]);
        
        [DRIdict2 setObject:[NSNumber numberWithDouble:driV2] forKey:key];
    }
    NSLog(@"letDRIConsiderLoss ret:\n%@",DRIdict2);
    return DRIdict2;
}
-(NSMutableDictionary*)letDRIULConsiderLoss:(NSMutableDictionary*)DRIdict
{
    if (DRIdict == nil)
        return nil;
    NSMutableDictionary* DRIdict2 = [NSMutableDictionary dictionaryWithDictionary:DRIdict];
    
    NSMutableDictionary *nutrientInfos = [self getNutrientInfoAs2LevelDictionary_withNutrientIds:nil];
    NSArray *keys = DRIdict2.allKeys;
    
    for(int i=0; i<keys.count; i++){
        NSString* key = keys[i];
        NSNumber *driVal = [DRIdict2 objectForKey:key];
        NSDictionary *nutrientInfo = [nutrientInfos objectForKey:key];
        assert(nutrientInfo!=nil);
        NSNumber *nmLossRate = [nutrientInfo objectForKey:COLUMN_NAME_LossRate];
        double driV2 = [driVal doubleValue];
        if([driVal doubleValue]>0){
            if ([nmLossRate doubleValue]>0)
                driV2 = [driVal doubleValue]/(1.0-[nmLossRate doubleValue]);
        }
        
        [DRIdict2 setObject:[NSNumber numberWithDouble:driV2] forKey:key];
    }
    NSLog(@"letDRIConsiderLoss ret:\n%@",DRIdict2);
    return DRIdict2;
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


- (NSArray *)selectAllForTable:(NSString *)tableName andOrderBy:(NSString *)partOrderBy
{
    NSMutableString *query = [NSMutableString stringWithFormat: @"SELECT * FROM %@",tableName];
    if (partOrderBy.length > 0){
        [query appendFormat:@" %@",partOrderBy ];
    }
    FMResultSet *rs = [dbfm executeQuery:query];
    NSArray *ary = [[self class] FMResultSetToDictionaryArray:rs];
    return ary;
}

- (NSArray *)selectTableByEqualFilter_withTableName:(NSString *)tableName andField:(NSString *)fieldName andValue:(NSObject*)fieldValue
{
    return [self selectTableByEqualFilter_withTableName:tableName andField:fieldName andValue:fieldValue andColumns:nil];
}

- (NSArray *)selectTableByEqualFilter_withTableName:(NSString *)tableName andField:(NSString *)fieldName andValue:(NSObject*)fieldValue andColumns:(NSArray*)columns
{
    NSString *columnsPart = @"*";
    if (columns.count>0){
        columnsPart = [columns componentsJoinedByString:@","];
    }
    NSString *query = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=:fieldValue",columnsPart,tableName,fieldName];
    NSDictionary *dictQueryParam = [NSDictionary dictionaryWithObjectsAndKeys:fieldValue, @"fieldValue", nil];
    FMResultSet *rs = [dbfm executeQuery:query withParameterDictionary:dictQueryParam];
    NSArray *ary = [[self class] FMResultSetToDictionaryArray:rs];
    return ary;
}

- (BOOL)deleteTableByEqualFilter_withTableName:(NSString *)tableName andField:(NSString *)fieldName andValue:(NSObject*)fieldValue
{
    NSString *query = [NSString stringWithFormat: @"DELETE FROM %@ WHERE %@=:fieldValue",tableName,fieldName];
    NSDictionary *dictQueryParam = [NSDictionary dictionaryWithObjectsAndKeys:fieldValue, @"fieldValue", nil];
    BOOL dbopState = [dbfm executeUpdate:query error:nil withParameterDictionary:dictQueryParam];
    return dbopState;
}






- (NSDictionary *)getDRIbyGender:(NSString*)gender andAge:(int)age {
    NSString *tableName = TABLE_NAME_DRIMale;
    if ([@"female" isEqualToString:gender]){
        tableName = TABLE_NAME_DRIFemale;
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
//    NSLog(@"getDRIbyGender get:\n%@",rowDict);
    NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithDictionary:rowDict];
    [retDict removeObjectForKey:@"Start"];
    [retDict removeObjectForKey:@"End"];
    NSLog(@"getDRIbyGender ret:\n%@",retDict);
    return retDict;
}



- (NSDictionary *)getDRIULbyGender:(NSString*)gender andAge:(int)age {
    NSString *tableName = TABLE_NAME_DRIULMale;
    if ([@"female" isEqualToString:gender]){
        tableName = TABLE_NAME_DRIULFemale;
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
//    NSLog(@"getDRIULbyGender get:\n%@",rowDict);
    NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithDictionary:rowDict];
    [retDict removeObjectForKey:@"Start"];
    [retDict removeObjectForKey:@"End"];
    NSLog(@"getDRIULbyGender ret:\n%@",retDict);
    return retDict;
}




/*
 取富含某种营养素的前n个食物的清单
 */
-(NSArray *) getRichNutritionFood:(NSString *)nutrientAsColumnName andTopN:(int)topN
{
    return [self getRichNutritionFood:nutrientAsColumnName andIncludeFoodClass:nil andExcludeFoodClass:nil andIncludeFoodIds:nil andExcludeFoodIds:nil andTopN:topN];
}

/*
 取富含某种营养素的前n个食物的清单
 注意food的class是一个树结构
 */
-(NSArray *) getRichNutritionFood:(NSString *)nutrientAsColumnName andIncludeFoodClass:(NSString*)includeFoodClass andExcludeFoodClass:(NSString*)excludeFoodClass andIncludeFoodIds:(NSArray*)includeFoodIds  andExcludeFoodIds:(NSArray*)excludeFoodIds andTopN:(int)topN
{
    NSLog(@"getRichNutritionFood enter");
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*1];
    //看来如果sql语句中用了view，会有FL.[Lower_Limit(g)]等某些列整个成为列名,而且就算是[Lower_Limit(g)]，也还会保留[].而如果没有用到view，则Lower_Limit(g)是列名
    [sqlStr appendString:@"SELECT F.*,CnCaption,CnType,classify ,FC.[Lower_Limit(g)],FC.[Upper_Limit(g)],FC.normal_value,FC.first_recommend,FC.PicPath, SingleItemUnitName,SingleItemUnitWeight, "];
    [sqlStr appendString:@"\n D.["];
    [sqlStr appendString:nutrientAsColumnName];
    [sqlStr appendString:@"] AS RichLevel "];
//    [sqlStr appendString:@"\n  FROM FoodNutritionCustom F JOIN Food_Supply_DRI_Amount D on F.NDB_No=D.NDB_No "];
    [sqlStr appendString:@"\n  FROM FoodNutrition F join FoodCustom FC on F.NDB_No=FC.NDB_No JOIN Food_Supply_DRI_Amount D on F.NDB_No=D.NDB_No "];
//    [sqlStr appendString:@"\n    LEFT OUTER JOIN FoodLimit FL ON F.NDB_No=FL.NDB_No \n"];
//    [sqlStr appendString:@"\n    LEFT OUTER JOIN FoodPicPath P ON F.NDB_No=P.NDB_No \n"];
    
    NSMutableArray *exprIncludeORdata = [NSMutableArray array];
    NSMutableArray *exprIncludeANDdata = [NSMutableArray array];
    NSMutableArray *exprExcludedata = [NSMutableArray array];
    
    NSString *strColumn;
    NSString *strOp;
    NSMutableArray *expr;
    strColumn = [NSString stringWithFormat:@"D.[%@]",nutrientAsColumnName];
    strOp = @">";
    expr = [NSMutableArray arrayWithCapacity:3];
    [expr addObject:strColumn];
    [expr addObject:strOp];
    [expr addObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:0], nil]];
    [exprIncludeANDdata addObject:expr];

    strColumn = [NSString stringWithFormat:@"D.[%@]",nutrientAsColumnName];
    strOp = @"<";
    expr = [NSMutableArray arrayWithCapacity:3];
    [expr addObject:strColumn];
    [expr addObject:strOp];
    [expr addObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:1000], nil]];
    [exprIncludeANDdata addObject:expr];
    
    if (includeFoodClass.length>0){
        NSString *strColumn = COLUMN_NAME_classify;
        NSString *strOp = @"LIKE";
        NSMutableArray *expr = [NSMutableArray arrayWithCapacity:3];
        [expr addObject:strColumn];
        [expr addObject:strOp];
        [expr addObject:[NSArray arrayWithObjects:includeFoodClass, nil]];
        [exprIncludeANDdata addObject:expr];
    }

    if (excludeFoodClass.length > 0){
        NSString *strColumn = COLUMN_NAME_classify;
        NSString *strOp = @"LIKE";
        NSMutableArray *expr = [NSMutableArray arrayWithCapacity:3];
        [expr addObject:strColumn];
        [expr addObject:strOp];
        [expr addObject:[NSArray arrayWithObjects:excludeFoodClass, nil]];
        [exprExcludedata addObject:expr];
    }

    if (includeFoodIds.count>0){
        NSString *strColumn = @"F.NDB_No";
        NSString *strOp = @"IN";
        NSMutableArray *expr = [NSMutableArray arrayWithCapacity:3];
        [expr addObject:strColumn];
        [expr addObject:strOp];
        [expr addObject:includeFoodIds];
        [exprIncludeANDdata addObject:expr];
    }
    if (excludeFoodIds.count>0){
        NSString *strColumn = @"F.NDB_No";
        NSString *strOp = @"IN";
        NSMutableArray *expr = [NSMutableArray arrayWithCapacity:3];
        [expr addObject:strColumn];
        [expr addObject:strOp];
        [expr addObject:excludeFoodIds];
        [exprExcludedata addObject:expr];
    }
//    [sqlStr appendString:@"\n  WHERE "];
//    [sqlStr appendString:@"\n    D.["];
//    [sqlStr appendString:nutrientAsColumnName];
//    [sqlStr appendString:@"]"];
//    [sqlStr appendString:@">0"];
//    
//    [sqlStr appendString:@"\n AND D.["];
//    [sqlStr appendString:nutrientAsColumnName];
//    [sqlStr appendString:@"]"];
//    [sqlStr appendString:@"<1000 "];
    
//    if(includeFoodClass.length > 0){
//        [sqlStr appendString:@"\n    AND "];
//        [sqlStr appendString:COLUMN_NAME_classify];
//        [sqlStr appendString:@" LIKE '"];
//        [sqlStr appendString:includeFoodClass];
//        [sqlStr appendString:@"%' "];
//    }
//    if(excludeFoodClass.length > 0){
//        [sqlStr appendString:@"\n    AND NOT "];
//        [sqlStr appendString:COLUMN_NAME_classify];
//        [sqlStr appendString:@" LIKE '"];
//        [sqlStr appendString:excludeFoodClass];
//        [sqlStr appendString:@"%' "];
//    }
    
//    NSMutableArray *allFoodIds = [NSMutableArray array];
//    if(includeFoodIds.count > 0){
//        NSMutableArray *placeholderAry = [NSMutableArray arrayWithCapacity:includeFoodIds.count];
//        for(int i=0; i<includeFoodIds.count; i++){
//            [placeholderAry addObject:@"?"];
//        }
//        NSString *placeholdersStr = [placeholderAry componentsJoinedByString:@","];
//
//        [sqlStr appendString:@"\n    AND F.NDB_No in ("];
//        [sqlStr appendString:placeholdersStr];
//        [sqlStr appendString:@") "];
//        [allFoodIds addObjectsFromArray:includeFoodIds];
//    }
//    if(excludeFoodIds.count > 0){
//        NSMutableArray *placeholderAry = [NSMutableArray arrayWithCapacity:excludeFoodIds.count];
//        for(int i=0; i<excludeFoodIds.count; i++){
//            [placeholderAry addObject:@"?"];
//        }
//        NSString *placeholdersStr = [placeholderAry componentsJoinedByString:@","];
//        [sqlStr appendString:@"\n    AND NOT F.NDB_No in ("];
//        [sqlStr appendString:placeholdersStr];
//        [sqlStr appendString:@") "];
//        [allFoodIds addObjectsFromArray:excludeFoodIds];
//    }
    
    NSMutableString *afterWherePart = [NSMutableString string ];
    
    [afterWherePart appendString:@"\n ORDER BY "];
    [afterWherePart appendString:@"D.["];
    [afterWherePart appendString:nutrientAsColumnName];
    [afterWherePart appendString:@"] ASC"];
    
    if (topN){
        [afterWherePart appendString:@"\n LIMIT "];
        [afterWherePart appendString:[[NSNumber numberWithInt:topN] stringValue]];
    }
    
    NSDictionary *filters = [NSDictionary dictionaryWithObjectsAndKeys:
                             exprIncludeORdata,@"includeOR",
                             exprIncludeANDdata,@"includeAND",
                             exprExcludedata,@"exclude",
                             nil];
    NSDictionary *localOptions = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:false],@"varBeParamWay", nil];
    NSArray * dataAry = [self getRowsByQuery:sqlStr andFilters:filters andWhereExistInQuery:false andAfterWherePart:afterWherePart andOptions:localOptions];
    return dataAry;
    
//    NSLog(@"getRichNutritionFood sqlStr=%@",sqlStr);
//    
////    FMResultSet *rs = [dbfm executeQuery:sqlStr];
//    FMResultSet *rs = [dbfm executeQuery:sqlStr withArgumentsInArray:allFoodIds];
//    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];
//
//    NSLog(@"getRichNutritionFood ret:\n%@",dataAry);
//    return dataAry;
}

-(NSDictionary *) getOneRichNutritionFood:(NSString *)nutrientAsColumnName andIncludeFoodClass:(NSString*)includeFoodClass andExcludeFoodClass:(NSString*)excludeFoodClass  andIncludeFoodIds:(NSArray*)includeFoodIds andExcludeFoodIds:(NSArray*)excludeFoodIds andGetStrategy:(NSString*)getStrategy
{
    NSArray * foodAry = [self getRichNutritionFood:nutrientAsColumnName andIncludeFoodClass:includeFoodClass andExcludeFoodClass:excludeFoodClass andIncludeFoodIds:includeFoodIds andExcludeFoodIds:excludeFoodIds andTopN:0];
    if (foodAry.count == 0)
        return nil;
    if( [Strategy_random isEqualToString:getStrategy] && (foodAry.count > 1) ){
        int idx = random() % foodAry.count;
        return foodAry[idx];
    }else{
        return foodAry[0];
    }
}


-(NSArray *) getFoodsOfRichNutritionAndIntersectGivenSet_withNutrient:(NSString *)nutrientAsColumnName andGivenFoodIds:(NSArray*)givenFoodIds
{
    NSLog(@"getFoodsOfRichNutritionAndIntersectGivenSet_withNutrient enter");
    if (givenFoodIds.count == 0)
        return nil;
    return [self getRichNutritionFood:nutrientAsColumnName andIncludeFoodClass:nil andExcludeFoodClass:nil andIncludeFoodIds:givenFoodIds andExcludeFoodIds:nil andTopN:0];
}

/*
 注意columnName可能为 T1.columnName 的形式，而且如果columnName含有特殊字符，需在传入前自行处理，如 T1.[columnName]。
 result contain :(NSString*) strCondition, (NSArray*)sqlParams(only 1 item at max)
 */
+(NSDictionary*)getUnitCondition_withColumn:(NSString*)columnName andOp:(NSString*)operator andValue:(NSObject*)valObj andNotFlag:(BOOL)notFlag andOptions:(NSDictionary*)options
{
    NSNumber *nmVarBeParamWay = [options objectForKey:@"varBeParamWay"];
    BOOL varBeParamWay = FALSE;
    if (nmVarBeParamWay!=nil)
        varBeParamWay = [nmVarBeParamWay boolValue];
    
    assert(columnName!=nil);
    assert(operator!=nil);
    assert(valObj!=nil);
    NSMutableString *strCondition = [NSMutableString stringWithCapacity:100];
    NSMutableArray *sqlParams = [NSMutableArray array];
    if (notFlag) [strCondition appendString:@"NOT "];
    //[strCondition appendFormat:@"[%@] %@ ",columnName,operator];
    [strCondition appendFormat:@" %@ %@ ",columnName,operator];
    if (varBeParamWay){
        [strCondition appendString:@"?"];
        [sqlParams addObject:valObj];
    }else{
        if ([valObj isKindOfClass:NSNumber.class]){
            NSNumber *nmVal = (NSNumber *)valObj;
            double dval = [nmVal doubleValue];
            long lval = [nmVal longValue];
            double dlval = lval;
            long long llval = [nmVal longLongValue];
            double dllval = llval;
            if (dlval == dval){
                [strCondition appendFormat:@"%ld",lval];
            }else if(dllval == dval){
                [strCondition appendFormat:@"%lld",llval];
            }else{
                [strCondition appendFormat:@"%f",dval];
            }
        }else{
            NSString *strVal = nil;
            if ([valObj isKindOfClass:NSString.class]){
                strVal = (NSString*)valObj;
            }else{
                strVal = [NSString stringWithFormat:@"%@",valObj ];
            }
            strVal = [strVal stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            if ([@"LIKE" isEqualToString:[operator uppercaseString]]){
                [strCondition appendFormat:@"'%@%%'",strVal];
            }else{
                [strCondition appendFormat:@"'%@'",strVal];
            }
        }
    }

    NSDictionary *retDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             strCondition,@"strCondition",
                             sqlParams,@"sqlParams",
                             nil];
    NSLog(@"getUnitCondition_withColumn %@ %@ %@ %d ret:\n %@",columnName,operator,valObj,notFlag,retDict);
    return retDict;
}
/*
 注意columnName可能为 T1.columnName 的形式，而且如果columnName含有特殊字符，需在传入前自行处理，如 T1.[columnName]。
 result contain :(NSString*) strCondition, (NSArray*)sqlParams
 */
+(NSDictionary*)getUnitCondition_withColumn:(NSString*)columnName andOp:(NSString*)operator andValues:(NSArray*)values andNotFlag:(BOOL)notFlag andOptions:(NSDictionary*)options
{
    NSNumber *nmVarBeParamWay = [options objectForKey:@"varBeParamWay"];
    BOOL varBeParamWay = FALSE;
    if (nmVarBeParamWay!=nil)
        varBeParamWay = [nmVarBeParamWay boolValue];
    
    assert(columnName!=nil);
    assert(operator!=nil);
    assert(values.count>0);
    assert([[operator uppercaseString] isEqualToString:@"IN"]);
    NSMutableString *strCondition = [NSMutableString stringWithCapacity:100];
    NSMutableArray *sqlParams = [NSMutableArray arrayWithCapacity:values.count];
    if (notFlag) [strCondition appendString:@"NOT "];
//    [strCondition appendFormat:@"[%@] %@ ",columnName,operator];
    [strCondition appendFormat:@" %@ %@ ",columnName,operator];
    if(varBeParamWay){
        NSMutableArray *placeholderAry = [NSMutableArray arrayWithCapacity:values.count];
        for(int i=0; i<values.count; i++){
            [placeholderAry addObject:@"?"];
        }
        NSString *placeholdersStr = [placeholderAry componentsJoinedByString:@","];
        [strCondition appendFormat:@"(%@)",placeholdersStr];
        [sqlParams addObjectsFromArray:values];
    }else{
        NSMutableArray *strValues = [NSMutableArray arrayWithCapacity:values.count];
        NSObject *valObj0 = values[0];
        if ([valObj0 isKindOfClass:NSNumber.class]){
            //assert(![columnName isEqualToString:COLUMN_NAME_NDB_No]);// 存在情况 columnName 含 NDB_No
            for(int i=0; i<values.count; i++){
                NSNumber *nmVal = values[i];
                NSString *strVal = [NSString stringWithFormat:@"%@",nmVal];
                [strValues addObject:strVal ];
            }//for i
        }else{
            for(int i=0; i<values.count; i++){
                NSObject *objVal = values[i];
                NSString *strVal = nil;
                if ([objVal isKindOfClass:NSString.class]){
                    strVal = (NSString*)objVal;
                }else{
                    strVal = [NSString stringWithFormat:@"%@",objVal ];
                }
                strVal = [strVal stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                strVal = [NSString stringWithFormat:@"'%@'",strVal ];
                [strValues addObject:strVal ];
            }//for i
        }
        [strCondition appendFormat:@"(%@)",[strValues componentsJoinedByString:@","]];
    }
    NSDictionary *retDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             strCondition,@"strCondition",
                             sqlParams,@"sqlParams",
                             nil];
    NSLog(@"getUnitCondition_withColumn %@ %@ %@ %d ret:\n %@",columnName,operator,values,notFlag,retDict);
    return retDict;
}

/*
 notFlag1 column1 op1 values1
 */
+(NSDictionary*)getMediumUnitCondition_withExpressionItems:(NSArray*)expressionItems andJoinBoolOp:(NSString*)joinBoolOp andOptions:(NSDictionary*)options
{
    NSLog(@"getMediumUnitCondition_withExpressionItems enter, %@ . %@ . %@",expressionItems,joinBoolOp,options);
    NSNumber *nmVarBeParamWay = [options objectForKey:@"varBeParamWay"];
    BOOL varBeParamWay = FALSE;
    if (nmVarBeParamWay!=nil)
        varBeParamWay = [nmVarBeParamWay boolValue];
    
    assert(expressionItems.count==4);
    NSNumber *nmNotFlag = expressionItems[0];
    NSString *strColumn = expressionItems[1];
    NSString *strOp = expressionItems[2];
    NSArray *values = expressionItems[3];
//    assert(nmNotFlag!=nil);
    assert(joinBoolOp.length>0);
    assert(strColumn.length>0);
    assert(strOp.length>0);
    assert(values.count > 0);
    
    NSMutableString *strCondition = [NSMutableString stringWithCapacity:100];
    NSMutableArray *sqlParams = [NSMutableArray arrayWithCapacity:10];
    bool firstInnerConditionAdd = false;
    
    if ([[strOp uppercaseString] isEqualToString:@"IN"]){
        NSDictionary *unitConditionData = [self getUnitCondition_withColumn:strColumn andOp:strOp andValues:values andNotFlag:[nmNotFlag boolValue] andOptions:options];
        NSString * unitCondition = [unitConditionData objectForKey:@"strCondition"];
        NSArray* localSqlParams = [unitConditionData objectForKey:@"sqlParams"];
        [strCondition appendString:unitCondition];
        [sqlParams addObjectsFromArray:localSqlParams];
    }else{
        for(int i=0 ; i<values.count; i++){
            NSObject *valObj = values[i];
            NSDictionary *unitConditionData = [self getUnitCondition_withColumn:strColumn andOp:strOp andValue:valObj andNotFlag:[nmNotFlag boolValue] andOptions:options];
            NSString * unitCondition = [unitConditionData objectForKey:@"strCondition"];
            NSArray* localSqlParams = [unitConditionData objectForKey:@"sqlParams"];
            if (firstInnerConditionAdd){
                [strCondition appendFormat:@" %@ ",joinBoolOp];
            }else{
                firstInnerConditionAdd = true;
            }
            [strCondition appendString:unitCondition];
            [sqlParams addObjectsFromArray:localSqlParams];
        }//for
    }
    NSDictionary *retDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             strCondition,@"strCondition",
                             sqlParams,@"sqlParams",
                             nil];
    NSLog(@"getMediumUnitCondition_withExpressionItems %@ %@ ret:\n %@",expressionItems,joinBoolOp,retDict);
    return retDict;
}

/*
 options contain: flag varBeParamWay(contrary is varDirectInSql)
 [notFlag1 column1 op1 values1],[notFlag1 column1 op1 values1]
 */
+(NSDictionary*)getBigUnitCondition_withExpressionItems:(NSArray*)expressionItemsArray andJoinBoolOp:(NSString*)joinBoolOp andOptions:(NSDictionary*)options
{
    NSNumber *nmVarBeParamWay = [options objectForKey:@"varBeParamWay"];
    BOOL varBeParamWay = FALSE;
    if (nmVarBeParamWay!=nil)
        varBeParamWay = [nmVarBeParamWay boolValue];

    assert(joinBoolOp.length>0);
    assert(expressionItemsArray.count>0);
    NSMutableString *strCondition = [NSMutableString stringWithCapacity:1000];
    NSMutableArray *sqlParams = [NSMutableArray arrayWithCapacity:100];
    bool firstInnerConditionAdd = false;
    for(int i=0; i<expressionItemsArray.count; i++){
        NSArray *expressionItems = expressionItemsArray[i];
        assert(expressionItems.count==4);
        NSDictionary *unitConditionData = [self getMediumUnitCondition_withExpressionItems:expressionItems andJoinBoolOp:joinBoolOp andOptions:options];
        NSString * unitCondition = [unitConditionData objectForKey:@"strCondition"];
        NSArray* localSqlParams = [unitConditionData objectForKey:@"sqlParams"];
        if (firstInnerConditionAdd){
            [strCondition appendFormat:@" %@ ",joinBoolOp];
        }else{
            firstInnerConditionAdd = true;
        }
        [strCondition appendFormat:@"(%@)",unitCondition];
        [sqlParams addObjectsFromArray:localSqlParams];
    }
    NSDictionary *retDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             strCondition,@"strCondition",
                             sqlParams,@"sqlParams",
                             nil];
    NSLog(@"getBigUnitCondition_withExpressionItems %@ %@ ret:\n %@",expressionItemsArray,joinBoolOp,retDict);
    return retDict;
}

/*
 options contain: flag varBeParamWay(contrary is varDirectInSql)
 filters contain:
 flag needWhereWord
 includeOR AND (cond1 OR cond2 OR cond3 ...)
    expressionItemsArray
         column1 op1 values1
         column2 op2 values2
 includeAND AND cond1 AND cond2 AND cond3 ...
    expressionItemsArray
         column1 op1 values1
         column2 op2 values2
 exclude --  AND NOT cond1 AND NOT cond2 AND NOT cond3 ...
    expressionItemsArray
         column1 op1 values1
         column2 op2 values2
 
 op can be = , like, in
 */
+(NSDictionary*)getConditionsPart_withFilters:(NSDictionary*)filters andOptions:(NSDictionary*)options
{
        
    NSNumber *nmNeedWhereWord = [filters objectForKey:@"needWhereWord"];
    BOOL needWhereWord = FALSE;
    if (nmNeedWhereWord!=nil)
        needWhereWord = [nmNeedWhereWord boolValue];
    
    NSMutableString *strConditions = [NSMutableString stringWithCapacity:10000];
    NSMutableArray *sqlParams = [NSMutableArray arrayWithCapacity:100];
    if (needWhereWord){
        [strConditions appendString:@"\n WHERE 1=1"];
    }
    NSArray *includeORdata = [filters objectForKey:@"includeOR"];
    NSArray *includeANDdata = [filters objectForKey:@"includeAND"];
    NSArray *excludeData = [filters objectForKey:@"exclude"];
    
    if (includeORdata.count>0){
        NSNumber *nmNotFlag = [NSNumber numberWithBool:FALSE];
        NSMutableArray * expressionItemsArray = [NSMutableArray arrayWithCapacity:includeORdata.count];
        for(int i=0; i<includeORdata.count; i++){
            NSArray *expressionItems = includeORdata[i];
            NSMutableArray *expressionItems2 = [NSMutableArray arrayWithCapacity:(expressionItems.count+1)];
            [expressionItems2 addObject:nmNotFlag];
            [expressionItems2 addObjectsFromArray:expressionItems];
            [expressionItemsArray addObject:expressionItems2];
        }
        NSDictionary *unitConditionData = [self getBigUnitCondition_withExpressionItems:expressionItemsArray andJoinBoolOp:@"OR" andOptions:options];
        NSString * unitCondition = [unitConditionData objectForKey:@"strCondition"];
        NSArray* localSqlParams = [unitConditionData objectForKey:@"sqlParams"];
        [strConditions appendFormat:@" AND (%@)",unitCondition ];
        [sqlParams addObjectsFromArray:localSqlParams];
    }//if (includeORDict!=nil)
    if (includeANDdata.count>0){
        NSNumber *nmNotFlag = [NSNumber numberWithBool:FALSE];
        NSMutableArray * expressionItemsArray = [NSMutableArray arrayWithCapacity:includeANDdata.count];
        for(int i=0; i<includeANDdata.count; i++){
            NSArray *expressionItems = includeANDdata[i];
            NSMutableArray *expressionItems2 = [NSMutableArray arrayWithCapacity:(expressionItems.count+1)];
            [expressionItems2 addObject:nmNotFlag];
            [expressionItems2 addObjectsFromArray:expressionItems];
            [expressionItemsArray addObject:expressionItems2];
        }
        NSDictionary *unitConditionData = [self getBigUnitCondition_withExpressionItems:expressionItemsArray andJoinBoolOp:@"AND" andOptions:options];
        NSString * unitCondition = [unitConditionData objectForKey:@"strCondition"];
        NSArray* localSqlParams = [unitConditionData objectForKey:@"sqlParams"];
        [strConditions appendFormat:@" AND (%@)",unitCondition ];
        [sqlParams addObjectsFromArray:localSqlParams];
    }//if (includeANDDict!=nil)
    if (excludeData.count>0){
        NSNumber *nmNotFlag = [NSNumber numberWithBool:TRUE];
        NSMutableArray * expressionItemsArray = [NSMutableArray arrayWithCapacity:excludeData.count];
        for(int i=0; i<excludeData.count; i++){
            NSArray *expressionItems = excludeData[i];
            NSMutableArray *expressionItems2 = [NSMutableArray arrayWithCapacity:(expressionItems.count+1)];
            [expressionItems2 addObject:nmNotFlag];
            [expressionItems2 addObjectsFromArray:expressionItems];
            [expressionItemsArray addObject:expressionItems2];
        }
        NSDictionary *unitConditionData = [self getBigUnitCondition_withExpressionItems:expressionItemsArray andJoinBoolOp:@"AND" andOptions:options];
        NSString * unitCondition = [unitConditionData objectForKey:@"strCondition"];
        NSArray* localSqlParams = [unitConditionData objectForKey:@"sqlParams"];
        [strConditions appendFormat:@" AND (%@)",unitCondition ];
        [sqlParams addObjectsFromArray:localSqlParams];
    }//if (excludeDict!=nil)
    NSDictionary *retDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             strConditions,@"strCondition",
                             sqlParams,@"sqlParams",
                             nil];
    NSLog(@"getBigUnitCondition_withExpressionItems %@ ret:%@",filters,retDict);
    return retDict;
}
/*
 options contain: flag varBeParamWay(contrary is varDirectInSql)
 filters contain:
    includeOR AND (cond1 OR cond2 OR cond3 ...)
        expressionItemsArray
            column1 op1 values1
            column2 op2 values2
    includeAND AND cond1 AND cond2 AND cond3 ...
        expressionItemsArray
            column1 op1 values1
            column2 op2 values2
    exclude --  AND NOT cond1 AND NOT cond2 AND NOT cond3 ...
        expressionItemsArray
            column1 op1 values1
            column2 op2 values2
 
 op can be = , like, in
 */
-(NSArray *)getRowsByQuery:(NSString*)strQuery andFilters:(NSDictionary*)filters andWhereExistInQuery:(BOOL)ifWhereExistInQuery andAfterWherePart:(NSString*)afterWherePart andOptions:options
{
    NSMutableDictionary *filtersDict = [NSMutableDictionary dictionaryWithDictionary:filters];
    [filtersDict setObject:[NSNumber numberWithBool:(!ifWhereExistInQuery)] forKey:@"needWhereWord"];
    NSDictionary *conditionData = [self.class getConditionsPart_withFilters:filtersDict andOptions:options];
    NSString *strCondition = [conditionData objectForKey:@"strCondition"];
    NSArray *sqlParams = [conditionData objectForKey:@"sqlParams"];
    NSMutableString *strWholeQuery = [NSMutableString stringWithString:strQuery];
    [strWholeQuery appendString:strCondition];
    if (afterWherePart.length>0) [strWholeQuery appendString:afterWherePart];
    
    NSLog(@"getRowsByQuery:andFilters strWholeQuery=%@, \nParams=%@",strWholeQuery,sqlParams);
    FMResultSet *rs = [dbfm executeQuery:strWholeQuery withArgumentsInArray:sqlParams];
    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];
    
    return dataAry;
}



-(NSArray *) getFoodIdsByFilters_withIncludeFoodClassAry:(NSArray*)includeFoodClassAry andExcludeFoodClassAry:(NSArray*)excludeFoodClassAry andIncludeEqualFoodClassAry:(NSArray*)includeEqualFoodClassAry andIncludeFoodIds:(NSArray*)includeFoodIds andExcludeFoodIds:(NSArray*)excludeFoodIds
{
    //    if (includeFoodClass == nil && excludeFoodClass == nil)
    //        return nil;
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*1];
    //现在FoodNutritionCustom是view，这会导致F.NDB_No整个为dict的key值
    [sqlStr appendString:@"SELECT F.NDB_No \n"];
//    [sqlStr appendString:@"  FROM FoodNutritionCustom F \n"];
    [sqlStr appendString:@"  FROM FoodNutrition F join FoodCustom FC on F.NDB_No=FC.NDB_No \n"];
//    [sqlStr appendString:@"    LEFT OUTER JOIN FoodLimit FL ON F.NDB_No=FL.NDB_No \n"];
//    [sqlStr appendString:@"    LEFT OUTER JOIN FoodPicPath P ON F.NDB_No=P.NDB_No \n"];
    
    NSMutableArray *exprIncludeORdata = [NSMutableArray array];
    NSMutableArray *exprIncludeANDdata = [NSMutableArray array];
    NSMutableArray *exprExcludedata = [NSMutableArray array];
    
    if (includeFoodClassAry.count > 0){
        NSString *strColumn = COLUMN_NAME_classify;
        NSString *strOp = @"LIKE";
        for(int i=0; i<includeFoodClassAry.count; i++){
            NSString *includeFoodClass = includeFoodClassAry[i];
            NSMutableArray *expr = [NSMutableArray arrayWithCapacity:3];
            [expr addObject:strColumn];
            [expr addObject:strOp];
            [expr addObject:[NSArray arrayWithObjects:includeFoodClass, nil]];
            [exprIncludeORdata addObject:expr];
        }
    }
    if (includeEqualFoodClassAry.count > 0){
        NSString *strColumn = COLUMN_NAME_classify;
        NSString *strOp = @"=";
        for(int i=0; i<includeEqualFoodClassAry.count; i++){
            NSString *includeFoodClass = includeEqualFoodClassAry[i];
            NSMutableArray *expr = [NSMutableArray arrayWithCapacity:3];
            [expr addObject:strColumn];
            [expr addObject:strOp];
            [expr addObject:[NSArray arrayWithObjects:includeFoodClass, nil]];
            [exprIncludeORdata addObject:expr];
        }
    }

    if (includeFoodIds.count>0){
        NSString *strColumn = @"F.NDB_No";
        NSString *strOp = @"IN";
        NSMutableArray *expr = [NSMutableArray arrayWithCapacity:3];
        [expr addObject:strColumn];
        [expr addObject:strOp];
        [expr addObject:includeFoodIds];
        [exprIncludeANDdata addObject:expr];
    }

    if (excludeFoodClassAry.count > 0){
        NSString *strColumn = COLUMN_NAME_classify;
        NSString *strOp = @"LIKE";
        for(int i=0; i<excludeFoodClassAry.count; i++){
            NSString *excludeFoodClass = excludeFoodClassAry[i];
            NSMutableArray *expr = [NSMutableArray arrayWithCapacity:3];
            [expr addObject:strColumn];
            [expr addObject:strOp];
            [expr addObject:[NSArray arrayWithObjects:excludeFoodClass, nil]];
            [exprExcludedata addObject:expr];
        }
    }
    if (excludeFoodIds.count>0){
        NSString *strColumn = @"F.NDB_No";
        NSString *strOp = @"IN";
        NSMutableArray *expr = [NSMutableArray arrayWithCapacity:3];
        [expr addObject:strColumn];
        [expr addObject:strOp];
        [expr addObject:excludeFoodIds];
        [exprExcludedata addObject:expr];
    }
    
    NSDictionary *filters = [NSDictionary dictionaryWithObjectsAndKeys:
                             exprIncludeORdata,@"includeOR",
                             exprIncludeANDdata,@"includeAND",
                             exprExcludedata,@"exclude",
                             nil];
    NSDictionary *localOptions = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:false],@"varBeParamWay", nil];
    NSArray * dataAry = [self getRowsByQuery:sqlStr andFilters:filters andWhereExistInQuery:false andAfterWherePart:nil andOptions:localOptions];
    
    
//    NSMutableString *sqlStrWherePart = [NSMutableString stringWithCapacity:1000*1];
//    bool firstConditionAdded = false;
//    if (includeFoodClassAry.count > 0 || includeEqualFoodClassAry>0){
//        NSMutableString *strLocalConditions = [NSMutableString stringWithCapacity:1000*1];
//        bool firstInnerConditionAdd = false;
//        for(int i=0; i<includeFoodClassAry.count; i++){
//            NSString *includeFoodClass = includeFoodClassAry[i];
//            assert(includeFoodClass.length>0);
//            if (firstInnerConditionAdd){
//                [strLocalConditions appendString:@" OR "];
//            }else{
//                firstInnerConditionAdd = true;
//            }
//            [strLocalConditions appendString:COLUMN_NAME_classify];
//            [strLocalConditions appendString:@" LIKE '"];
//            [strLocalConditions appendString:includeFoodClass];
//            [strLocalConditions appendString:@"%' "];
//        }//for
//        
//        for(int i=0; i<includeEqualFoodClassAry.count; i++){
//            NSString *includeEqualFoodClass = includeEqualFoodClassAry[i];
//            assert(includeEqualFoodClass.length>0);
//            if (firstInnerConditionAdd){
//                [strLocalConditions appendString:@" OR "];
//            }else{
//                firstInnerConditionAdd = true;
//            }
//            [strLocalConditions appendString:COLUMN_NAME_classify];
//            [strLocalConditions appendString:@" ='"];
//            [strLocalConditions appendString:includeEqualFoodClass];
//            [strLocalConditions appendString:@"' "];
//        }//for
//        
//        [sqlStrWherePart appendString:@"\n "];
//        if (firstConditionAdded){
//            [sqlStrWherePart appendString:@" AND "];
//        }else{
//            firstConditionAdded = true;
//        }
//        [sqlStrWherePart appendString:@"("];
//        [sqlStrWherePart appendString:strLocalConditions];
//        [sqlStrWherePart appendString:@")"];
//    }
//    
//    for(int i=0; i<excludeFoodClassAry.count; i++){
//        NSString *excludeFoodClass = excludeFoodClassAry[i];
//        if(excludeFoodClass.length > 0){
//            [sqlStrWherePart appendString:@"\n "];
//            if (firstConditionAdded){
//                [sqlStrWherePart appendString:@" AND "];
//            }else{
//                firstConditionAdded = true;
//            }
//            [sqlStrWherePart appendString:@" NOT "];
//            [sqlStrWherePart appendString:COLUMN_NAME_classify];
//            [sqlStrWherePart appendString:@" LIKE '"];
//            [sqlStrWherePart appendString:excludeFoodClass];
//            [sqlStrWherePart appendString:@"%' "];
//        }
//    }//for
//
//    NSMutableArray *allFoodIds = [NSMutableArray array];
//    if(includeFoodIds.count > 0){
//        NSMutableArray *placeholderAry = [NSMutableArray arrayWithCapacity:includeFoodIds.count];
//        for(int i=0; i<includeFoodIds.count; i++){
//            [placeholderAry addObject:@"?"];
//        }
//        NSString *placeholdersStr = [placeholderAry componentsJoinedByString:@","];
//        [sqlStrWherePart appendString:@"\n "];
//        if (firstConditionAdded){
//            [sqlStrWherePart appendString:@" AND "];
//        }else{
//            firstConditionAdded = true;
//        }
//        [sqlStrWherePart appendString:@" F.NDB_No in ("];
//        [sqlStrWherePart appendString:placeholdersStr];
//        [sqlStrWherePart appendString:@") "];
//        [allFoodIds addObjectsFromArray:includeFoodIds];
//    }
//    if(excludeFoodIds.count > 0){
//        NSMutableArray *placeholderAry = [NSMutableArray arrayWithCapacity:excludeFoodIds.count];
//        for(int i=0; i<excludeFoodIds.count; i++){
//            [placeholderAry addObject:@"?"];
//        }
//        NSString *placeholdersStr = [placeholderAry componentsJoinedByString:@","];
//        [sqlStrWherePart appendString:@"\n "];
//        if (firstConditionAdded){
//            [sqlStrWherePart appendString:@" AND "];
//        }else{
//            firstConditionAdded = true;
//        }
//        [sqlStrWherePart appendString:@" NOT F.NDB_No in ("];
//        [sqlStrWherePart appendString:placeholdersStr];
//        [sqlStrWherePart appendString:@") "];
//        [allFoodIds addObjectsFromArray:excludeFoodIds];
//    }
//    if (sqlStrWherePart.length > 0){
//        [sqlStr appendString:@" WHERE "];
//        [sqlStr appendString:sqlStrWherePart];
//    }
//    
//    NSLog(@"getFoodIdsByFilters_withIncludeFoodClass sqlStr=%@",sqlStr);
//    FMResultSet *rs = [dbfm executeQuery:sqlStr withArgumentsInArray:allFoodIds];
//    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];
    
    NSMutableArray *foodIdAry = [NSMutableArray arrayWithCapacity:dataAry.count];
    for(int i=0; i<dataAry.count; i++){
        NSDictionary *foodInfo = dataAry[i];
        NSString *foodId = foodInfo[COLUMN_NAME_NDB_No];
        assert(foodId!=nil);
        [foodIdAry addObject:foodId];
    }

    NSLog(@"getFoodIdsByFilters_withIncludeFoodClass ret:\n%@",foodIdAry);
    return foodIdAry;
}

//-----
-(NSArray *) getFoodsByFilters_withIncludeFoodClass:(NSString*)includeFoodClass andExcludeFoodClass:(NSString*)excludeFoodClass andEqualClass:(NSString*)equalClass andIncludeFoodIds:(NSArray*)includeFoodIds andExcludeFoodIds:(NSArray*)excludeFoodIds
{
//    if (includeFoodClass == nil && excludeFoodClass == nil)
//        return nil;
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*1];
    //看来如果sql语句中用了view，会有FL.[Lower_Limit(g)]等某些列整个成为列名,而且就算是[Lower_Limit(g)]，也还会保留[].而如果没有用到view，则Lower_Limit(g)是列名
    [sqlStr appendString:@"SELECT F.*,CnCaption,CnType,classify ,FC.[Lower_Limit(g)],FC.[Upper_Limit(g)],FC.normal_value,FC.first_recommend,FC.PicPath, SingleItemUnitName,SingleItemUnitWeight \n"];
//    [sqlStr appendString:@"  FROM FoodNutritionCustom F \n"];
    [sqlStr appendString:@"  FROM FoodNutrition F join FoodCustom FC on F.NDB_No=FC.NDB_No \n"];
//    [sqlStr appendString:@"    LEFT OUTER JOIN FoodLimit FL ON F.NDB_No=FL.NDB_No \n"];
//    [sqlStr appendString:@"    LEFT OUTER JOIN FoodPicPath P ON F.NDB_No=P.NDB_No \n"];
    
    NSMutableArray *exprIncludeORdata = [NSMutableArray array];
    NSMutableArray *exprIncludeANDdata = [NSMutableArray array];
    NSMutableArray *exprExcludedata = [NSMutableArray array];
    
    if (includeFoodClass.length>0){
        NSString *strColumn = COLUMN_NAME_classify;
        NSString *strOp = @"LIKE";
        NSMutableArray *expr = [NSMutableArray arrayWithCapacity:3];
        [expr addObject:strColumn];
        [expr addObject:strOp];
        [expr addObject:[NSArray arrayWithObjects:includeFoodClass, nil]];
        [exprIncludeANDdata addObject:expr];
    }
    if (equalClass.length>0){
        NSString *strColumn = COLUMN_NAME_classify;
        NSString *strOp = @"=";
        NSMutableArray *expr = [NSMutableArray arrayWithCapacity:3];
        [expr addObject:strColumn];
        [expr addObject:strOp];
        [expr addObject:[NSArray arrayWithObjects:equalClass, nil]];
        [exprIncludeANDdata addObject:expr];
    }
    if (includeFoodIds.count>0){
        NSString *strColumn = @"F.NDB_No";
        NSString *strOp = @"IN";
        NSMutableArray *expr = [NSMutableArray arrayWithCapacity:3];
        [expr addObject:strColumn];
        [expr addObject:strOp];
        [expr addObject:includeFoodIds];
        [exprIncludeANDdata addObject:expr];
    }
    
    if (excludeFoodClass.length > 0){
        NSString *strColumn = COLUMN_NAME_classify;
        NSString *strOp = @"LIKE";
        NSMutableArray *expr = [NSMutableArray arrayWithCapacity:3];
        [expr addObject:strColumn];
        [expr addObject:strOp];
        [expr addObject:[NSArray arrayWithObjects:excludeFoodClass, nil]];
        [exprExcludedata addObject:expr];
    }
    if (excludeFoodIds.count>0){
        NSString *strColumn = @"F.NDB_No";
        NSString *strOp = @"IN";
        NSMutableArray *expr = [NSMutableArray arrayWithCapacity:3];
        [expr addObject:strColumn];
        [expr addObject:strOp];
        [expr addObject:excludeFoodIds];
        [exprExcludedata addObject:expr];
    }
    
    NSDictionary *filters = [NSDictionary dictionaryWithObjectsAndKeys:
                             exprIncludeORdata,@"includeOR",
                             exprIncludeANDdata,@"includeAND",
                             exprExcludedata,@"exclude",
                             nil];
    NSDictionary *localOptions = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:false],@"varBeParamWay", nil];
    NSArray * dataAry = [self getRowsByQuery:sqlStr andFilters:filters andWhereExistInQuery:false andAfterWherePart:nil andOptions:localOptions];
    return dataAry;
    
//    
//    NSMutableString *sqlStrWherePart = [NSMutableString stringWithCapacity:1000*1];
//    bool firstConditionAdded = false;
//    if(includeFoodClass.length > 0){
//        [sqlStrWherePart appendString:@"\n "];
//        if (firstConditionAdded){
//            [sqlStrWherePart appendString:@" AND "];
//        }else{
//            firstConditionAdded = true;
//        }
//        [sqlStrWherePart appendString:COLUMN_NAME_classify];
//        [sqlStrWherePart appendString:@" LIKE '"];
//        [sqlStrWherePart appendString:includeFoodClass];
//        [sqlStrWherePart appendString:@"%' "];
//    }
//    if(excludeFoodClass.length > 0){
//        [sqlStrWherePart appendString:@"\n "];
//        if (firstConditionAdded){
//            [sqlStrWherePart appendString:@" AND "];
//        }else{
//            firstConditionAdded = true;
//        }
//        [sqlStrWherePart appendString:@" NOT "];
//        [sqlStrWherePart appendString:COLUMN_NAME_classify];
//        [sqlStrWherePart appendString:@" LIKE '"];
//        [sqlStrWherePart appendString:excludeFoodClass];
//        [sqlStrWherePart appendString:@"%' "];
//    }
//    
//    if(equalClass.length > 0){
//        [sqlStrWherePart appendString:@"\n "];
//        if (firstConditionAdded){
//            [sqlStrWherePart appendString:@" AND "];
//        }else{
//            firstConditionAdded = true;
//        }
//        [sqlStrWherePart appendString:COLUMN_NAME_classify];
//        [sqlStrWherePart appendString:@" ='"];
//        [sqlStrWherePart appendString:equalClass];
//        [sqlStrWherePart appendString:@"' "];
//    }
//    
//    NSMutableArray *allFoodIds = [NSMutableArray array];
//    if(includeFoodIds.count > 0){
//        NSMutableArray *placeholderAry = [NSMutableArray arrayWithCapacity:includeFoodIds.count];
//        for(int i=0; i<includeFoodIds.count; i++){
//            [placeholderAry addObject:@"?"];
//        }
//        NSString *placeholdersStr = [placeholderAry componentsJoinedByString:@","];
//        [sqlStrWherePart appendString:@"\n "];
//        if (firstConditionAdded){
//            [sqlStrWherePart appendString:@" AND "];
//        }else{
//            firstConditionAdded = true;
//        }
//        [sqlStrWherePart appendString:@" F.NDB_No in ("];
//        [sqlStrWherePart appendString:placeholdersStr];
//        [sqlStrWherePart appendString:@") "];
//        [allFoodIds addObjectsFromArray:includeFoodIds];
//    }
//    if(excludeFoodIds.count > 0){
//        NSMutableArray *placeholderAry = [NSMutableArray arrayWithCapacity:excludeFoodIds.count];
//        for(int i=0; i<excludeFoodIds.count; i++){
//            [placeholderAry addObject:@"?"];
//        }
//        NSString *placeholdersStr = [placeholderAry componentsJoinedByString:@","];
//        [sqlStrWherePart appendString:@"\n "];
//        if (firstConditionAdded){
//            [sqlStrWherePart appendString:@" AND "];
//        }else{
//            firstConditionAdded = true;
//        }
//        [sqlStrWherePart appendString:@" NOT F.NDB_No in ("];
//        [sqlStrWherePart appendString:placeholdersStr];
//        [sqlStrWherePart appendString:@") "];
//        [allFoodIds addObjectsFromArray:excludeFoodIds];
//    }
//    if (sqlStrWherePart.length > 0){
//        [sqlStr appendString:@" WHERE "];
//        [sqlStr appendString:sqlStrWherePart];
//    }
//
//    NSLog(@"getFoodsByFilters_withIncludeFoodClass sqlStr=%@",sqlStr);
//    FMResultSet *rs = [dbfm executeQuery:sqlStr withArgumentsInArray:allFoodIds];
//    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];
//    NSLog(@"getFoodsByFilters_withIncludeFoodClass ret:\n%@",dataAry);
//    return dataAry;
}
-(NSDictionary *) getOneFoodByFilters_withIncludeFoodClass:(NSString*)includeFoodClass andExcludeFoodClass:(NSString*)excludeFoodClass andEqualClass:(NSString*)equalClass andIncludeFoodIds:(NSArray*)includeFoodIds  andExcludeFoodIds:(NSArray*)excludeFoodIds
{
    NSArray* foods = [self getFoodsByFilters_withIncludeFoodClass:includeFoodClass andExcludeFoodClass:excludeFoodClass andEqualClass:equalClass andIncludeFoodIds:includeFoodIds andExcludeFoodIds:excludeFoodIds];
    if(foods.count==0)
        return nil;
    if(foods.count==1)
        return foods[0];
    int idx = random() % foods.count;
    return foods[idx];
}
-(NSDictionary *) getOneFoodByFilters_withIncludeFoodClass:(NSString*)includeFoodClass andExcludeFoodClass:(NSString*)excludeFoodClass andIncludeFoodIds:(NSArray*)includeFoodIds  andExcludeFoodIds:(NSArray*)excludeFoodIds
{
    NSArray* foods = [self getFoodsByFilters_withIncludeFoodClass:includeFoodClass andExcludeFoodClass:excludeFoodClass andEqualClass:nil andIncludeFoodIds:includeFoodIds andExcludeFoodIds:excludeFoodIds];
    if(foods.count==0)
        return nil;
    if(foods.count==1)
        return foods[0];
    int idx = random() % foods.count;
    return foods[idx];
}

-(bool) existAnyGivenFoodsBeRichOfNutrition:(NSString *)nutrientAsColumnName andGivenFoodIds:(NSArray*)givenFoodIds
{
    if (givenFoodIds.count == 0)
        return false;
    
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*1];
    [sqlStr appendString:@"SELECT F.NDB_No \n"];
//    [sqlStr appendString:@"  FROM FoodNutritionCustom F JOIN Food_Supply_DRI_Amount D on F.NDB_No=D.NDB_No \n"];
    [sqlStr appendString:@"  FROM FoodNutrition F join FoodCustom FC on F.NDB_No=FC.NDB_No JOIN Food_Supply_DRI_Amount D on F.NDB_No=D.NDB_No \n"];
    [sqlStr appendString:@" WHERE "];
    [sqlStr appendString:@"D.["];
    [sqlStr appendString:nutrientAsColumnName];
    [sqlStr appendString:@"]"];
    [sqlStr appendString:@">0"];
    
    [sqlStr appendString:@" AND D.["];
    [sqlStr appendString:nutrientAsColumnName];
    [sqlStr appendString:@"]"];
    [sqlStr appendString:@"<1000 \n"];
    
    NSMutableArray *placeholderAry = [NSMutableArray arrayWithCapacity:givenFoodIds.count];
    for(int i=0; i<givenFoodIds.count; i++){
        [placeholderAry addObject:@"?"];
    }
    NSString *placeholdersStr = [placeholderAry componentsJoinedByString:@","];
    [sqlStr appendString:@" AND F.NDB_No in ("];
    [sqlStr appendString:placeholdersStr];
    [sqlStr appendString:@") \n"];

    [sqlStr appendString:@" LIMIT 1"];

    NSLog(@"existAnyGivenFoodsBeRichOfNutrition sqlStr=%@",sqlStr);
    
    FMResultSet *rs = [dbfm executeQuery:sqlStr withArgumentsInArray:givenFoodIds];
    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];
    bool retval = (dataAry.count > 0);
    NSLog(@"existAnyGivenFoodsBeRichOfNutrition ret:%d",retval);
    return retval;
}



-(NSArray *) getAllFood
{
    NSLog(@"getAllFood begin");
//    NSString *query = @""
//    "SELECT FNC.*,P.PicPath FROM FoodNutritionCustom FNC LEFT OUTER JOIN FoodPicPath P ON FNC.NDB_No=P.NDB_No"
//    " ORDER BY CnType, NDB_No"
//    ;
//
//    FMResultSet *rs = [dbfm executeQuery:query];
//    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];
//    assert(dataAry.count > 0);
////    NSLog(@"getAllFood ret:\n%@",dataAry);
//    return dataAry;
    
    return [self getFoodsByFilters_withIncludeFoodClass:nil andExcludeFoodClass:nil andEqualClass:nil andIncludeFoodIds:nil andExcludeFoodIds:nil];
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

    return [self getFoodsByFilters_withIncludeFoodClass:nil andExcludeFoodClass:nil andEqualClass:nil andIncludeFoodIds:idAry andExcludeFoodIds:nil];
}


/*
 用以支持得到nutrients的信息数据，并可以通过普通的nutrient的列名取到相应的nutrient信息。
 */
-(NSMutableDictionary*)getNutrientInfoAs2LevelDictionary_withNutrientIds:(NSArray*)nutrientIds
{
    NSLog(@"getNutrientInfoAs2LevelDictionary_withNutrientIds begin");
    
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*100];
    [sqlStr appendString:@"SELECT * FROM NutritionInfo"];
    if (nutrientIds!=nil && nutrientIds.count >0){
        NSMutableArray *placeholderAry = [NSMutableArray arrayWithCapacity:nutrientIds.count];
        for(int i=0; i<nutrientIds.count; i++){
            [placeholderAry addObject:@"?"];
        }
        NSString *placeholdersStr = [placeholderAry componentsJoinedByString:@","];
        
        [sqlStr appendString:@"  WHERE NutrientID in ("];
        [sqlStr appendString:placeholdersStr];
        [sqlStr appendString:@")"];
    }

    FMResultSet *rs = [dbfm executeQuery:sqlStr withArgumentsInArray:nutrientIds];
    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];
    NSMutableDictionary *dic2Level = [LZUtility dictionaryArrayTo2LevelDictionary_withKeyName:@"NutrientID" andDicArray:dataAry];

    NSLog(@"getNutrientInfoAs2LevelDictionary_withNutrientIds ret:\n%@",dic2Level);
    return dic2Level;
}

-(NSDictionary*)getNutrientInfo:(NSString*)nutrientId
{
    NSLog(@"getNutrientInfo begin");
    
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*100];
    [sqlStr appendString:@"SELECT * FROM NutritionInfo"];
    [sqlStr appendString:@"  WHERE NutrientID = ?"];
    
    FMResultSet *rs = [dbfm executeQuery:sqlStr withArgumentsInArray:[NSArray arrayWithObject:nutrientId]];
    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];
    NSDictionary *nutrientInfo = nil;
    if (dataAry.count>0){
        nutrientInfo = dataAry[0];
    }
    
    NSLog(@"getNutrientInfo ret:\n%@",nutrientInfo);
    return nutrientInfo;
}



-(NSDictionary*)getCustomRichFood_SetDict
{
    NSArray *rows = [self selectAllForTable:TABLE_NAME_CustomRichFood andOrderBy:nil];
    NSMutableDictionary * dict2Level = [NSMutableDictionary dictionary];
    for(int i=0; i<rows.count; i++){
        NSDictionary *row = rows[i];
        NSString *nutrientId = row[COLUMN_NAME_NutrientID];
        NSString *foodId = row[COLUMN_NAME_NDB_No];
        assert(nutrientId.length>0 && foodId.length>0);
        NSMutableSet *foodIdSet = dict2Level[nutrientId];
        if (foodIdSet==nil){
            foodIdSet = [NSMutableSet set];
            [dict2Level setObject:foodIdSet forKey:nutrientId];
        }
        [foodIdSet addObject:foodId];
    }//for
    return dict2Level;
}


-(NSArray *) getRichNutritionFoodForNutrient:(NSString *)nutrientName andNutrientAmount:(NSNumber*)nutrientAmount
{
    NSArray * foods = [self getRichNutritionFood:nutrientName andTopN:0];
    
    for(int i=0; i<foods.count; i++){
        NSMutableDictionary *food = foods[i];
        NSNumber * foodNutrientStandard = [food objectForKey:nutrientName];
        if ([foodNutrientStandard doubleValue]!=0.0){
            double dFoodAmount = [nutrientAmount doubleValue]/ [foodNutrientStandard doubleValue] * 100.0;
            [food setObject:[NSNumber numberWithDouble:dFoodAmount] forKey:Key_FoodAmount];
        }else{
            //do nothing, then get will obtain nil, though should not
        }
    }
    NSLog(@"getRichNutritionFoodForNutrient ret:\n%@",foods);
    return foods;
}


/*
 主要作用是把食物按类别排序，以供显示
 */
-(NSArray *)getOrderedFoodIds:(NSArray *)idAry
{
    NSLog(@"getOrderedFoodIds begin");
    if (idAry==nil || idAry.count ==0)
        return nil;
    NSMutableArray *placeholderAry = [NSMutableArray arrayWithCapacity:idAry.count];
    for(int i=0; i<idAry.count; i++){
        [placeholderAry addObject:@"?"];
    }
    NSString *placeholdersStr = [placeholderAry componentsJoinedByString:@","];
    
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*100];
    [sqlStr appendString:@"SELECT "];
    [sqlStr appendString:COLUMN_NAME_NDB_No];
//    [sqlStr appendString:@"  FROM FoodNutritionCustom \n"];
    [sqlStr appendString:@"  FROM FoodCustom \n"];
    [sqlStr appendString:@"  WHERE NDB_No in ("];
    [sqlStr appendString:placeholdersStr];
    [sqlStr appendString:@")\n"];
    [sqlStr appendString:@"  ORDER BY "];
    [sqlStr appendString:COLUMN_NAME_classify];
    NSLog(@"getOrderedFoodIds sqlStr=%@",sqlStr);
    FMResultSet *rs = [dbfm executeQuery:sqlStr withArgumentsInArray:idAry];
    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];
    NSMutableArray *orderedIdAry = [NSMutableArray arrayWithCapacity:idAry.count];
    for(int i=0; i<dataAry.count; i++){
        NSDictionary *rowData = dataAry[i];
        NSString *idData = [rowData objectForKey:COLUMN_NAME_NDB_No];
        if(idData != nil)
            [orderedIdAry addObject:idData];
    }
    
    NSLog(@"getOrderedFoodIds ret:\n%@",orderedIdAry);
    return orderedIdAry;
}




/*
 单条语句暂且不管transaction的问题，假定不抛exception，在返回false值后让外层判断来rollback
 return auto increment id value
 */
-(NSNumber*)insertFoodCollocation_withName:(NSString*)collationName
{
    NSDate *dtNow = [NSDate date];
    long long llms = [LZUtility getMillisecond:dtNow];
    
    NSString *insertSql = [NSString stringWithFormat:
                          @"  INSERT INTO FoodCollocation (CollocationName, CollocationCreateTime) VALUES (?,?);"
                          ];
    NSArray *paramAry = [NSArray arrayWithObjects:collationName, [NSNumber numberWithLongLong:llms],nil];
    BOOL dbopState = [dbfm executeUpdate:insertSql error:nil withArgumentsInArray:paramAry];
    NSNumber *nmAutoIncrColumnValue = nil;
    if (dbopState){
        NSString *sql = @"select last_insert_rowid();";
        FMResultSet *rs = [dbfm executeQuery:sql];
        if ([rs next]) {
            NSArray *resultArray = rs.resultArray;
            assert(resultArray.count>0);
            nmAutoIncrColumnValue = resultArray[0];
        }
    }
    return nmAutoIncrColumnValue;
}
/*
 单条语句暂且不管transaction的问题，假定不抛exception，在返回false值后让外层判断来rollback
 */
-(BOOL)updateFoodCollocationName:(NSString*)collationName byId:(NSNumber*)nmCollocationId
{
    NSString *updSql = [NSString stringWithFormat:
                        @" UPDATE FoodCollocation SET CollocationName=? WHERE CollocationId=?;"
                        ];
    NSArray *paramAry = [NSArray arrayWithObjects:collationName, nmCollocationId,nil];
    BOOL dbopState = [dbfm executeUpdate:updSql error:nil withArgumentsInArray:paramAry];
    return dbopState;
}
-(BOOL)updateFoodCollocationTime:(long long)collationTime byId:(NSNumber*)nmCollocationId
{
    NSString *updSql = [NSString stringWithFormat:
                        @" UPDATE FoodCollocation SET CollocationCreateTime=? WHERE CollocationId=?;"
                        ];
    NSNumber *nm_collationTime = [NSNumber numberWithLongLong:collationTime];
    NSArray *paramAry = [NSArray arrayWithObjects:nm_collationTime, nmCollocationId,nil];
    BOOL dbopState = [dbfm executeUpdate:updSql error:nil withArgumentsInArray:paramAry];
    return dbopState;
}
-(BOOL)deleteFoodCollocationById:(NSNumber*)nmCollocationId
{
    return [self deleteTableByEqualFilter_withTableName:TABLE_NAME_FoodCollocation andField:COLUMN_NAME_CollocationId andValue:nmCollocationId];
}
/*
 单条语句暂且不管transaction的问题，假定不抛exception，在返回false值后让外层判断来rollback
 */
-(NSDictionary*)getFoodCollocationById:(NSNumber*)nmCollocationId
{
    NSArray *rows = [self selectTableByEqualFilter_withTableName:TABLE_NAME_FoodCollocation andField:COLUMN_NAME_CollocationId andValue:nmCollocationId];
    
    NSDictionary *rowDict = nil;
    if (rows.count > 0){
        rowDict = rows[0];
    }
    return rowDict;
}

-(NSArray*)getAllFoodCollocation
{
    NSArray * rows = [self selectAllForTable:TABLE_NAME_FoodCollocation andOrderBy:@" ORDER BY CollocationCreateTime DESC"];
    return rows;
}


-(NSArray*)getCollocationFoodData_withCollocationId:(NSNumber*)nmCollocationId
{
    return [self selectTableByEqualFilter_withTableName:TABLE_NAME_CollocationFood andField:COLUMN_NAME_CollocationId andValue:nmCollocationId
                                             andColumns:[NSArray arrayWithObjects:COLUMN_NAME_FoodId,COLUMN_NAME_FoodAmount, nil]];
}
/*
 单条语句暂且不管transaction的问题，假定不抛exception，在返回false值后让外层判断来rollback
 */
-(BOOL)deleteCollocationFoodData_withCollocationId:(NSNumber*)nmCollocationId
{
    return [self deleteTableByEqualFilter_withTableName:TABLE_NAME_CollocationFood andField:COLUMN_NAME_CollocationId andValue:nmCollocationId];
}

/*
 单条语句暂且不管transaction的问题，假定不抛exception，在返回false值后让外层判断来rollback
 */
-(BOOL)insertCollocationFood_withCollocationId:(NSNumber*)nmCollocationId andFoodId:(NSString*)foodId andFoodAmount:(NSNumber*)foodAmount
{
    NSString *insertSql = [NSString stringWithFormat:
                           @"INSERT INTO CollocationFood (CollocationId, FoodId, FoodAmount) VALUES (?,?,?);"
                           ];
    NSArray *paramAry = [NSArray arrayWithObjects:nmCollocationId, foodId, foodAmount, nil];
    BOOL dbopState = [dbfm executeUpdate:insertSql error:nil withArgumentsInArray:paramAry];
    return dbopState;
}
-(BOOL)insertCollocationFoods_withCollocationId:(NSNumber*)nmCollocationId andFoodAmount2LevelArray:(NSArray*)foodAmount2LevelArray andNeedTransaction:(BOOL)needTransaction andOuterTransactionExist:(BOOL)outerTransactionExist
{
    if (needTransaction && !outerTransactionExist){
        [dbfm beginTransaction];//here created transaction
    }
    
    for(int i=0; i<foodAmount2LevelArray.count; i++){
        NSArray *foodAndAmount = foodAmount2LevelArray[i];
        NSString *foodId = foodAndAmount[0];
        NSNumber *nmFoodAmount = foodAndAmount[1];
        BOOL dbopState = [self insertCollocationFood_withCollocationId:nmCollocationId andFoodId:foodId andFoodAmount:nmFoodAmount];
        if (!dbopState){
            if (needTransaction){
                [dbfm rollback];
            }
            return false;
        }
    }
    
    if (needTransaction){
        if (!outerTransactionExist){
            [dbfm commit];//transaction is created here, so need commit here
        }else{
            //let outer codes commit
        }
    }
    return true;
}


-(NSNumber *)insertFoodCollocationData_withCollocationName:(NSString*)collationName andFoodAmount2LevelArray:(NSArray*)foodAmount2LevelArray andNeedTransaction:(BOOL)needTransaction andOuterTransactionExist:(BOOL)outerTransactionExist
{
    BOOL nowTransactionExist = outerTransactionExist;
    if (needTransaction){
        if (!outerTransactionExist){
            [dbfm beginTransaction];//here created transaction
            nowTransactionExist = true;
        }
    }
    
    
    NSNumber *nmCollocationId = [self insertFoodCollocation_withName:collationName];
    if (nmCollocationId==nil){
        if (needTransaction)
            [dbfm rollback];
        return nil;
    }
    BOOL dbopState =[self insertCollocationFoods_withCollocationId:nmCollocationId andFoodAmount2LevelArray:foodAmount2LevelArray andNeedTransaction:needTransaction andOuterTransactionExist:nowTransactionExist];
    if (!dbopState){
        if (needTransaction)
            //[dbfm rollback];//should not rollback here because inner codes has rollbacked.
        return nil;
    }
    
    if (needTransaction){
        if (!outerTransactionExist){
            [dbfm commit];//transaction is created here, so need commit here
        }else{
            //let outer codes commit
        }
    }
    return nmCollocationId;
}
-(NSNumber *)insertFoodCollocationData_withCollocationName:(NSString*)collationName andFoodAmount2LevelArray:(NSArray*)foodAmount2LevelArray
{
    assert(collationName.length > 0);
    return [self insertFoodCollocationData_withCollocationName:collationName andFoodAmount2LevelArray:foodAmount2LevelArray andNeedTransaction:true andOuterTransactionExist:false];
}


-(BOOL)updateFoodCollocationData_withCollocationId:(NSNumber*)nmCollocationId andNewCollocationName:(NSString*)collocationName andFoodAmount2LevelArray:(NSArray*)foodAmount2LevelArray andNeedTransaction:(BOOL)needTransaction andOuterTransactionExist:(BOOL)outerTransactionExist
{
    BOOL nowTransactionExist = outerTransactionExist;
    if (needTransaction){
        if (!outerTransactionExist){
            [dbfm beginTransaction];//here created transaction
            nowTransactionExist = true;
        }
    }
    BOOL dbopState = false;
    if (collocationName.length > 0){
        dbopState = [self updateFoodCollocationName:collocationName byId:nmCollocationId];
        if (!dbopState){
            if (needTransaction)
                [dbfm rollback];
            return false;
        }
    }

    dbopState = [self deleteCollocationFoodData_withCollocationId:nmCollocationId];
    if (!dbopState){
        if (needTransaction)
            [dbfm rollback];
        return false;
    }
    dbopState =[self insertCollocationFoods_withCollocationId:nmCollocationId andFoodAmount2LevelArray:foodAmount2LevelArray andNeedTransaction:needTransaction andOuterTransactionExist:nowTransactionExist];
    if (!dbopState){
        if (needTransaction)
            //[dbfm rollback];//should not rollback here because inner codes has rollbacked.
            return false;
    }
    
    NSDate *dtNow = [NSDate date];
    long long llmsNow = [LZUtility getMillisecond:dtNow];
    dbopState = [self updateFoodCollocationTime:llmsNow byId:nmCollocationId];
    if (!dbopState){
        if (needTransaction)
            [dbfm rollback];
        return false;
    }
    
    if (needTransaction){
        if (!outerTransactionExist){
            [dbfm commit];//transaction is created here, so need commit here
        }else{
            //let outer codes commit
        }
    }
    return true;
}

/*
 如果 collocationName 为nil，则不改name。
 */
-(BOOL)updateFoodCollocationData_withCollocationId:(NSNumber*)nmCollocationId andNewCollocationName:(NSString*)collocationName andFoodAmount2LevelArray:(NSArray*)foodAmount2LevelArray
{
    return [self updateFoodCollocationData_withCollocationId:nmCollocationId andNewCollocationName:collocationName andFoodAmount2LevelArray:foodAmount2LevelArray andNeedTransaction:true andOuterTransactionExist:false];
}

-(NSDictionary*)getFoodCollocationData_withCollocationId:(NSNumber*)nmCollocationId
{
    NSDictionary * rowFoodCollocation = [self getFoodCollocationById:nmCollocationId];
    NSArray *foodAndAmountArray = [self getCollocationFoodData_withCollocationId:nmCollocationId];
    NSMutableDictionary *retDict = [NSMutableDictionary dictionary];
    if (rowFoodCollocation!=nil)
        [retDict setObject:rowFoodCollocation forKey:@"rowFoodCollocation"];
    if (foodAndAmountArray!=nil)
        [retDict setObject:foodAndAmountArray forKey:@"foodAndAmountArray"];
    NSLog(@"getFoodCollocationData_withCollocationId %@ return:\n%@",nmCollocationId,retDict);
    return retDict;
}

-(BOOL)deleteFoodCollocationData_withCollocationId:(NSNumber*)nmCollocationId
{
    BOOL dbopState1 = [self deleteFoodCollocationById:nmCollocationId];
    BOOL dbopState2 = [self deleteCollocationFoodData_withCollocationId:nmCollocationId];
    return dbopState1 && dbopState2;
}








@end




























