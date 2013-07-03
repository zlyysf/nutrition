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
    [sqlStr appendString:@"SELECT F.* ,FL.[Lower_Limit(g)],FL.[Upper_Limit(g)],FL.normal_value,P.PicPath, "];
    [sqlStr appendString:@"\n D.["];
    [sqlStr appendString:nutrientAsColumnName];
    [sqlStr appendString:@"] AS RichLevel "];
    
    [sqlStr appendString:@"\n  FROM FoodNutritionCustom F JOIN Food_Supply_DRI_Amount D on F.NDB_No=D.NDB_No "];
    [sqlStr appendString:@"\n    LEFT OUTER JOIN FoodLimit FL ON F.NDB_No=FL.NDB_No \n"];
    [sqlStr appendString:@"\n    LEFT OUTER JOIN FoodPicPath P ON F.NDB_No=P.NDB_No \n"];
    [sqlStr appendString:@"\n  WHERE "];
    [sqlStr appendString:@"\n    D.["];
    [sqlStr appendString:nutrientAsColumnName];
    [sqlStr appendString:@"]"];
    [sqlStr appendString:@">0"];
    
    [sqlStr appendString:@"\n AND D.["];
    [sqlStr appendString:nutrientAsColumnName];
    [sqlStr appendString:@"]"];
    [sqlStr appendString:@"<1000 "];
    
    if(includeFoodClass.length > 0){
        [sqlStr appendString:@"\n    AND "];
        [sqlStr appendString:COLUMN_NAME_classify];
        [sqlStr appendString:@" LIKE '"];
        [sqlStr appendString:includeFoodClass];
        [sqlStr appendString:@"%' "];
    }
    if(excludeFoodClass.length > 0){
        [sqlStr appendString:@"\n    AND NOT "];
        [sqlStr appendString:COLUMN_NAME_classify];
        [sqlStr appendString:@" LIKE '"];
        [sqlStr appendString:excludeFoodClass];
        [sqlStr appendString:@"%' "];
    }
    
    NSMutableArray *allFoodIds = [NSMutableArray array];
    if(includeFoodIds.count > 0){
        NSMutableArray *placeholderAry = [NSMutableArray arrayWithCapacity:includeFoodIds.count];
        for(int i=0; i<includeFoodIds.count; i++){
            [placeholderAry addObject:@"?"];
        }
        NSString *placeholdersStr = [placeholderAry componentsJoinedByString:@","];

        [sqlStr appendString:@"\n    AND F.NDB_No in ("];
        [sqlStr appendString:placeholdersStr];
        [sqlStr appendString:@") "];
        [allFoodIds addObjectsFromArray:includeFoodIds];
    }
    if(excludeFoodIds.count > 0){
        NSMutableArray *placeholderAry = [NSMutableArray arrayWithCapacity:excludeFoodIds.count];
        for(int i=0; i<excludeFoodIds.count; i++){
            [placeholderAry addObject:@"?"];
        }
        NSString *placeholdersStr = [placeholderAry componentsJoinedByString:@","];
        [sqlStr appendString:@"\n    AND NOT F.NDB_No in ("];
        [sqlStr appendString:placeholdersStr];
        [sqlStr appendString:@") "];
        [allFoodIds addObjectsFromArray:excludeFoodIds];
    }
    
    [sqlStr appendString:@"\n ORDER BY "];
    [sqlStr appendString:@"D.["];
    [sqlStr appendString:nutrientAsColumnName];
    [sqlStr appendString:@"] ASC"];
    
    if (topN){
        [sqlStr appendString:@"\n LIMIT "];
        [sqlStr appendString:[[NSNumber numberWithInt:topN] stringValue]];
    }
    
    NSLog(@"getRichNutritionFood sqlStr=%@",sqlStr);
    
//    FMResultSet *rs = [dbfm executeQuery:sqlStr];
    FMResultSet *rs = [dbfm executeQuery:sqlStr withArgumentsInArray:allFoodIds];
    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];

    NSLog(@"getRichNutritionFood ret:\n%@",dataAry);
    return dataAry;
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

//    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*1];
//    [sqlStr appendString:@"SELECT F.* ,FL.[Lower_Limit(g)],FL.[Upper_Limit(g)],FL.normal_value,P.PicPath \n"];
//    [sqlStr appendString:@" ,D.["];
//    [sqlStr appendString:nutrientAsColumnName];
//    [sqlStr appendString:@"] AS RichLevel \n"];
//    
//    [sqlStr appendString:@"  FROM FoodNutritionCustom F JOIN Food_Supply_DRI_Amount D on F.NDB_No=D.NDB_No \n"];
//    [sqlStr appendString:@"    LEFT OUTER JOIN FoodLimit FL ON F.NDB_No=FL.NDB_No \n"];
//    [sqlStr appendString:@"    LEFT OUTER JOIN FoodPicPath P ON F.NDB_No=P.NDB_No \n"];
//    
//    [sqlStr appendString:@" WHERE "];
//    [sqlStr appendString:@"D.["];
//    [sqlStr appendString:nutrientAsColumnName];
//    [sqlStr appendString:@"]"];
//    [sqlStr appendString:@">0"];
//    
//    [sqlStr appendString:@" AND D.["];
//    [sqlStr appendString:nutrientAsColumnName];
//    [sqlStr appendString:@"]"];
//    [sqlStr appendString:@"<1000 \n"];
//    
//    NSMutableArray *placeholderAry = [NSMutableArray arrayWithCapacity:givenFoodIds.count];
//    for(int i=0; i<givenFoodIds.count; i++){
//        [placeholderAry addObject:@"?"];
//    }
//    NSString *placeholdersStr = [placeholderAry componentsJoinedByString:@","];
//    [sqlStr appendString:@" AND F.NDB_No in ("];
//    [sqlStr appendString:placeholdersStr];
//    [sqlStr appendString:@") \n"];
//    
//    NSLog(@"getFoodsOfRichNutritionAndIntersectGivenSet_withNutrient sqlStr=%@",sqlStr);
//    
//    FMResultSet *rs = [dbfm executeQuery:sqlStr withArgumentsInArray:givenFoodIds];
//    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];
//    NSLog(@"getFoodsOfRichNutritionAndIntersectGivenSet_withNutrient ret:\n%@",dataAry);
//    if (dataAry.count == 0)
//        return nil;
//    else
//        return dataAry;
    return [self getRichNutritionFood:nutrientAsColumnName andIncludeFoodClass:nil andExcludeFoodClass:nil andIncludeFoodIds:givenFoodIds andExcludeFoodIds:nil andTopN:0];
}


-(NSArray *) getFoodsByFilters_withIncludeFoodClass:(NSString*)includeFoodClass andExcludeFoodClass:(NSString*)excludeFoodClass andEqualClass:(NSString*)equalClass andIncludeFoodIds:(NSArray*)includeFoodIds andExcludeFoodIds:(NSArray*)excludeFoodIds
{
//    if (includeFoodClass == nil && excludeFoodClass == nil)
//        return nil;
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*1];
    [sqlStr appendString:@"SELECT F.* ,FL.[Lower_Limit(g)],FL.[Upper_Limit(g)],FL.normal_value,P.PicPath \n"];
    [sqlStr appendString:@"  FROM FoodNutritionCustom F \n"];
    [sqlStr appendString:@"    LEFT OUTER JOIN FoodLimit FL ON F.NDB_No=FL.NDB_No \n"];
    [sqlStr appendString:@"    LEFT OUTER JOIN FoodPicPath P ON F.NDB_No=P.NDB_No \n"];
    
    NSMutableString *sqlStrWherePart = [NSMutableString stringWithCapacity:1000*1];
    bool firstConditionAdded = false;
    if(includeFoodClass.length > 0){
        [sqlStrWherePart appendString:@"\n "];
        if (firstConditionAdded){
            [sqlStrWherePart appendString:@" AND "];
        }else{
            firstConditionAdded = true;
        }
        [sqlStrWherePart appendString:COLUMN_NAME_classify];
        [sqlStrWherePart appendString:@" LIKE '"];
        [sqlStrWherePart appendString:includeFoodClass];
        [sqlStrWherePart appendString:@"%' "];
    }
    if(excludeFoodClass.length > 0){
        [sqlStrWherePart appendString:@"\n "];
        if (firstConditionAdded){
            [sqlStrWherePart appendString:@" AND "];
        }else{
            firstConditionAdded = true;
        }
        [sqlStrWherePart appendString:@" NOT "];
        [sqlStrWherePart appendString:COLUMN_NAME_classify];
        [sqlStrWherePart appendString:@" LIKE '"];
        [sqlStrWherePart appendString:excludeFoodClass];
        [sqlStrWherePart appendString:@"%' "];
    }
    
    if(equalClass.length > 0){
        [sqlStrWherePart appendString:@"\n "];
        if (firstConditionAdded){
            [sqlStrWherePart appendString:@" AND "];
        }else{
            firstConditionAdded = true;
        }
        [sqlStrWherePart appendString:COLUMN_NAME_classify];
        [sqlStrWherePart appendString:@" ='"];
        [sqlStrWherePart appendString:equalClass];
        [sqlStrWherePart appendString:@"' "];
    }
    
    NSMutableArray *allFoodIds = [NSMutableArray array];
    if(includeFoodIds.count > 0){
        NSMutableArray *placeholderAry = [NSMutableArray arrayWithCapacity:includeFoodIds.count];
        for(int i=0; i<includeFoodIds.count; i++){
            [placeholderAry addObject:@"?"];
        }
        NSString *placeholdersStr = [placeholderAry componentsJoinedByString:@","];
        [sqlStrWherePart appendString:@"\n "];
        if (firstConditionAdded){
            [sqlStrWherePart appendString:@" AND "];
        }else{
            firstConditionAdded = true;
        }
        [sqlStrWherePart appendString:@" F.NDB_No in ("];
        [sqlStrWherePart appendString:placeholdersStr];
        [sqlStrWherePart appendString:@") "];
        [allFoodIds addObjectsFromArray:includeFoodIds];
    }
    if(excludeFoodIds.count > 0){
        NSMutableArray *placeholderAry = [NSMutableArray arrayWithCapacity:excludeFoodIds.count];
        for(int i=0; i<excludeFoodIds.count; i++){
            [placeholderAry addObject:@"?"];
        }
        NSString *placeholdersStr = [placeholderAry componentsJoinedByString:@","];
        [sqlStrWherePart appendString:@"\n "];
        if (firstConditionAdded){
            [sqlStrWherePart appendString:@" AND "];
        }else{
            firstConditionAdded = true;
        }
        [sqlStrWherePart appendString:@" NOT F.NDB_No in ("];
        [sqlStrWherePart appendString:placeholdersStr];
        [sqlStrWherePart appendString:@") "];
        [allFoodIds addObjectsFromArray:excludeFoodIds];
    }
    if (sqlStrWherePart.length > 0){
        [sqlStr appendString:@" WHERE "];
        [sqlStr appendString:sqlStrWherePart];
    }

    NSLog(@"getFoodsByFilters_withIncludeFoodClass sqlStr=%@",sqlStr);
    FMResultSet *rs = [dbfm executeQuery:sqlStr withArgumentsInArray:allFoodIds];
    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];
    assert(dataAry.count > 0);
    NSLog(@"getFoodsByFilters_withIncludeFoodClass ret:\n%@",dataAry);
    return dataAry;
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
    [sqlStr appendString:@"  FROM FoodNutritionCustom F JOIN Food_Supply_DRI_Amount D on F.NDB_No=D.NDB_No \n"];
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




///*
// idAry 的元素需要是字符串类型。
// 返回值是array。
// */
//-(NSArray *)getFoodByIds:(NSArray *)idAry
//{
//    NSLog(@"getFoodByIds begin");
//    if (idAry==nil || idAry.count ==0)
//        return nil;
//    NSMutableArray *placeholderAry = [NSMutableArray arrayWithCapacity:idAry.count];
//    for(int i=0; i<idAry.count; i++){
//        [placeholderAry addObject:@"?"];
//    }
//    NSString *placeholdersStr = [placeholderAry componentsJoinedByString:@","];
//    
//    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*100];
//    [sqlStr appendString:@"SELECT * FROM FoodNutritionCustom WHERE NDB_No in ("];
//    [sqlStr appendString:placeholdersStr];
//    [sqlStr appendString:@")"];
//    
//    FMResultSet *rs = [dbfm executeQuery:sqlStr withArgumentsInArray:idAry];
//    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];
//    assert(dataAry.count > 0);
//    NSLog(@"getFoodByIds ret:\n%@",dataAry);
//    return dataAry;
//}

/*
 idAry 的元素需要是字符串类型。
 返回值是array。
 */
-(NSArray *)getFoodAttributesByIds:(NSArray *)idAry
{
    NSLog(@"getFoodAttributesByIds begin");
    if (idAry==nil || idAry.count ==0)
        return nil;
//    NSMutableArray *placeholderAry = [NSMutableArray arrayWithCapacity:idAry.count];
//    for(int i=0; i<idAry.count; i++){
//        [placeholderAry addObject:@"?"];
//    }
//    NSString *placeholdersStr = [placeholderAry componentsJoinedByString:@","];
//    
//    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*100];
//    [sqlStr appendString:@"SELECT FNC.*,FL.[Lower_Limit(g)],FL.[Upper_Limit(g)],FL.normal_value,P.PicPath \n"];
//    [sqlStr appendString:@"  FROM FoodNutritionCustom FNC \n"];
//    [sqlStr appendString:@"    LEFT OUTER JOIN FoodLimit FL ON FNC.NDB_No=FL.NDB_No \n"];
//    [sqlStr appendString:@"    LEFT OUTER JOIN FoodPicPath P ON FNC.NDB_No=P.NDB_No \n"];
//    [sqlStr appendString:@"  WHERE FNC.NDB_No in ("];
//    [sqlStr appendString:placeholdersStr];
//    [sqlStr appendString:@")"];
//    NSLog(@"getFoodAttributesByIds sqlStr=%@",sqlStr);
//    FMResultSet *rs = [dbfm executeQuery:sqlStr withArgumentsInArray:idAry];
//    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];
//    assert(dataAry.count > 0);
//    NSLog(@"getFoodAttributesByIds ret:\n%@",dataAry);
//    return dataAry;
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
    [sqlStr appendString:@"  FROM FoodNutritionCustom \n"];
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






@end




























