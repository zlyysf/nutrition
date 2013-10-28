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
#import "LZDataAccessUtil.h"

@implementation LZDataAccess

+(LZDataAccess *)singleton {
    static dispatch_once_t pred;
    static LZDataAccess *shared;
    // Will only be run once, the first time this is called
    dispatch_once(&pred, ^{
        shared = [[LZDataAccess alloc] initDB];
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

+ (NSString *)srcResourceDbFilePath {
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:cDbFile];
    NSLog(@"dbFilePath=%@",filePath);
    return filePath;
}



- (id)initDB{
    self = [super init];
    if (self) {

        NSString *dbFilePath = [self.class dbFilePath];
        NSString *srcResourceDbFilePath = [self.class srcResourceDbFilePath];
        NSFileManager * defFileManager = [NSFileManager defaultManager];
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        //NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSString *flagKey = [NSString stringWithFormat:@"%@%@-DB",AppVersionCheckName,appVersion];

        BOOL fileExists,isDir;
        fileExists = [defFileManager fileExistsAtPath:dbFilePath isDirectory:&isDir];
        NSLog(@"initDB, dbFilePath exist=%d",fileExists);
        if (!fileExists){
            NSError *err = nil;
            [defFileManager copyItemAtPath:srcResourceDbFilePath toPath:dbFilePath error:&err];
            if (err != nil){
                NSLog(@"initDB, fail to copy srcResourceDbFilePath to dbFilePath, %@",err);
                return nil;
            }
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:flagKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self openDB_withFilePath:dbFilePath];
        }else{
            //db file exist , need to check if it be old version when upgrade
            //if exist older db, need remove it then copy new one            
            
            BOOL flagExists = [[NSUserDefaults standardUserDefaults]boolForKey:flagKey];
            NSLog(@"initDB, flag %@=%d",flagKey,fileExists);
            if (!flagExists) {
                NSError *err = nil;
                [defFileManager removeItemAtPath:dbFilePath error:&err];
                if (err != nil){
                    NSLog(@"initDB, fail to remove dbFilePath, %@",err);
                    return nil;
                }
                [defFileManager copyItemAtPath:srcResourceDbFilePath toPath:dbFilePath error:&err];
                if (err != nil){
                    NSLog(@"initDB , fail to copy srcResourceDbFilePath to dbFilePath, %@",err);
                    return nil;
                }
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:flagKey];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [self openDB_withFilePath:dbFilePath];
            }else{
                [self openDB_withFilePath:dbFilePath];
            }
        }
    }
    return self;
}

- (id)init_withDBcon:(FMDatabase *)innerDBCon
{
    assert(innerDBCon!=nil);
    self = [super init];
    if (self) {
        dbfm = innerDBCon;
    }
    return self;
}


-(void)openDB_withFilePath: (NSString *)dbFilePath
{
    [self closeDB];
    
    NSFileManager * defFileManager = [NSFileManager defaultManager];
    BOOL fileExists;
    fileExists = [defFileManager fileExistsAtPath:dbFilePath];
    if (!fileExists){
        NSLog(@"openDB_withFilePath, file not Exists, %@", dbFilePath);
        return;
    }
    
    dbfm = [FMDatabase databaseWithPath:dbFilePath];
    if (![dbfm open]) {
        [dbfm close];
        dbfm = nil;
        NSLog(@"openDB_withFilePath, FMDatabase databaseWithPath failed, %@", dbFilePath);
    }
}
-(void)closeDB
{
    if (dbfm != nil){
        [dbfm close];
        dbfm = nil;
    }
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
    NSString *gender = @"male";
    if (sex !=0)
        gender = @"female";
    NSDictionary *part2 = [self getDRIbyGender:gender andAge:age];
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
    NSString *gender = @"male";
    if (sex !=0)
        gender = @"female";
    NSDictionary *part2 = [self getDRIULbyGender:gender andAge:age];
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithDictionary:part1];
    [ret addEntriesFromDictionary:part2];
    
    if (needConsiderLoss){
        ret = [self letDRIULConsiderLoss:ret];
    }
    
    NSLog(@"getStandardDRIULs ret:\n%@",ret);
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
 upperLimitType的值使用列名
 */
-(NSArray *)getRichFoodForNutrientAmount_withNutrient:(NSString *)nutrientAsColumnName andNutrientSupplyAmount:(double)nutrientSupplyAmount andTopN:(int)topN andIfNeedCustomDefinedFoods:(BOOL)ifNeedCustomDefinedFoods andUpperLimitType:(NSString*)upperLimitType
{
    NSLog(@"getRichNutritionFood enter");
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*1];
    //看来如果sql语句中用了view，会有FL.[Lower_Limit(g)]等某些列整个成为列名,而且就算是[Lower_Limit(g)]，也还会保留[].而如果没有用到view，则Lower_Limit(g)是列名
    [sqlStr appendString:@"SELECT F.*,CnCaption,FoodNameEn,CnType,classify ,FC.[Lower_Limit(g)],FC.[Upper_Limit(g)],FC.normal_value,FC.first_recommend,FC.increment_unit,FC.PicPath, SingleItemUnitName,SingleItemUnitWeight, "];
    [sqlStr appendFormat:@"\n D.[%@] AS RichLevel ",nutrientAsColumnName];
    [sqlStr appendString:@"\n  FROM FoodNutrition F join FoodCustom FC on F.NDB_No=FC.NDB_No JOIN Food_Supply_DRI_Amount D on F.NDB_No=D.NDB_No "];
    if (ifNeedCustomDefinedFoods){
        [sqlStr appendFormat:@"\n    JOIN CustomRichFood CRF ON FC.NDB_No=CRF.NDB_No AND CRF.NutrientId='%@' \n",nutrientAsColumnName];
    }
    NSString *upperLimitColumn = COLUMN_NAME_normal_value;
    if ([COLUMN_NAME_Upper_Limit isEqualToString:upperLimitType]){
        upperLimitColumn = COLUMN_NAME_Upper_Limit;
    }
    [sqlStr appendFormat:@"\n  WHERE F.[%@]*FC.[%@]/100.0 >= %f",nutrientAsColumnName,upperLimitColumn,nutrientSupplyAmount];
    
    NSMutableString *afterWherePart = [NSMutableString string ];
//    [afterWherePart appendString:@"\n ORDER BY "];
//    [afterWherePart appendString:@"D.["];
//    [afterWherePart appendString:nutrientAsColumnName];
//    [afterWherePart appendString:@"] ASC"];
    if (topN){
        [afterWherePart appendString:@"\n LIMIT "];
        [afterWherePart appendString:[[NSNumber numberWithInt:topN] stringValue]];
    }

    NSDictionary *localOptions = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:false],@"varBeParamWay", nil];
    NSArray * dataAry = [self getRowsByQuery:sqlStr andFilters:nil andWhereExistInQuery:true andAfterWherePart:afterWherePart andOptions:localOptions];
    return dataAry;
}


/*
 取富含某种营养素的前n个食物的清单
 */
-(NSArray *) getRichNutritionFood:(NSString *)nutrientAsColumnName andTopN:(int)topN andIfNeedCustomDefinedFoods:(BOOL) ifNeedCustomDefinedFoods
{
    return [self getRichNutritionFood:nutrientAsColumnName andIncludeFoodClass:nil andExcludeFoodClass:nil andIncludeFoodIds:nil andExcludeFoodIds:nil andTopN:topN andIfNeedCustomDefinedFoods:ifNeedCustomDefinedFoods];
}

/*
 取富含某种营养素的前n个食物的清单
 注意food的class是一个树结构
 */
-(NSArray *) getRichNutritionFood:(NSString *)nutrientAsColumnName andIncludeFoodClass:(NSString*)includeFoodClass andExcludeFoodClass:(NSString*)excludeFoodClass andIncludeFoodIds:(NSArray*)includeFoodIds  andExcludeFoodIds:(NSArray*)excludeFoodIds andTopN:(int)topN andIfNeedCustomDefinedFoods:(BOOL) ifNeedCustomDefinedFoods
{
    NSLog(@"getRichNutritionFood enter");
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*1];
    //看来如果sql语句中用了view，会有FL.[Lower_Limit(g)]等某些列整个成为列名,而且就算是[Lower_Limit(g)]，也还会保留[].而如果没有用到view，则Lower_Limit(g)是列名
    [sqlStr appendString:@"SELECT F.*,CnCaption,FoodNameEn,CnType,classify ,FC.[Lower_Limit(g)],FC.[Upper_Limit(g)],FC.normal_value,FC.first_recommend,FC.increment_unit,FC.PicPath, SingleItemUnitName,SingleItemUnitWeight, "];
    [sqlStr appendFormat:@"\n D.[%@] AS RichLevel ",nutrientAsColumnName];
//    [sqlStr appendString:@"\n  FROM FoodNutritionCustom F JOIN Food_Supply_DRI_Amount D on F.NDB_No=D.NDB_No "];
    [sqlStr appendString:@"\n  FROM FoodNutrition F join FoodCustom FC on F.NDB_No=FC.NDB_No JOIN Food_Supply_DRI_Amount D on F.NDB_No=D.NDB_No "];
    if (ifNeedCustomDefinedFoods){
        [sqlStr appendFormat:@"\n    JOIN CustomRichFood CRF ON FC.NDB_No=CRF.NDB_No AND CRF.NutrientId='%@' \n",nutrientAsColumnName];
    }
    
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
    

}

-(NSDictionary *) getOneRichNutritionFood:(NSString *)nutrientAsColumnName andIncludeFoodClass:(NSString*)includeFoodClass andExcludeFoodClass:(NSString*)excludeFoodClass  andIncludeFoodIds:(NSArray*)includeFoodIds andExcludeFoodIds:(NSArray*)excludeFoodIds andGetStrategy:(NSString*)getStrategy  andIfNeedCustomDefinedFoods:(BOOL) ifNeedCustomDefinedFoods
{
    NSArray * foodAry = [self getRichNutritionFood:nutrientAsColumnName andIncludeFoodClass:includeFoodClass andExcludeFoodClass:excludeFoodClass andIncludeFoodIds:includeFoodIds andExcludeFoodIds:excludeFoodIds andTopN:0 andIfNeedCustomDefinedFoods:ifNeedCustomDefinedFoods];
    if (foodAry.count == 0)
        return nil;
    if( [Strategy_random isEqualToString:getStrategy] && (foodAry.count > 1) ){
        int idx = random() % foodAry.count;
        return foodAry[idx];
    }else{
        return foodAry[0];
    }
}


-(NSArray *) getFoodsOfRichNutritionAndIntersectGivenSet_withNutrient:(NSString *)nutrientAsColumnName andGivenFoodIds:(NSArray*)givenFoodIds andIfNeedCustomDefinedFoods:(BOOL) ifNeedCustomDefinedFoods
{
    NSLog(@"getFoodsOfRichNutritionAndIntersectGivenSet_withNutrient enter");
    if (givenFoodIds.count == 0)
        return nil;
    return [self getRichNutritionFood:nutrientAsColumnName andIncludeFoodClass:nil andExcludeFoodClass:nil andIncludeFoodIds:givenFoodIds andExcludeFoodIds:nil andTopN:0 andIfNeedCustomDefinedFoods:ifNeedCustomDefinedFoods];
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
-(NSMutableString*) getSql_SelectFoodMainPart
{
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*1];
    //看来如果sql语句中用了view，会有FL.[Lower_Limit(g)]等某些列整个成为列名,而且就算是[Lower_Limit(g)]，也还会保留[].而如果没有用到view，则Lower_Limit(g)是列名
    [sqlStr appendString:@"SELECT F.*,CnCaption,FoodNameEn,CnType,classify ,FC.[Lower_Limit(g)],FC.[Upper_Limit(g)],FC.normal_value,FC.first_recommend,FC.increment_unit, FC.PicPath, SingleItemUnitName,SingleItemUnitWeight \n"];
    //    [sqlStr appendString:@"  FROM FoodNutritionCustom F \n"];
    [sqlStr appendString:@"  FROM FoodNutrition F join FoodCustom FC on F.NDB_No=FC.NDB_No \n"];
    //    [sqlStr appendString:@"    LEFT OUTER JOIN FoodLimit FL ON F.NDB_No=FL.NDB_No \n"];
    //    [sqlStr appendString:@"    LEFT OUTER JOIN FoodPicPath P ON F.NDB_No=P.NDB_No \n"];
    
    return sqlStr;
}

-(NSArray *) getFoodsByFilters_withIncludeFoodClass:(NSString*)includeFoodClass andExcludeFoodClass:(NSString*)excludeFoodClass andEqualClass:(NSString*)equalClass andIncludeFoodIds:(NSArray*)includeFoodIds andExcludeFoodIds:(NSArray*)excludeFoodIds
{
//    if (includeFoodClass == nil && excludeFoodClass == nil)
//        return nil;
    NSMutableString *sqlStr = [self getSql_SelectFoodMainPart];
    
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

//-(bool) existAnyGivenFoodsBeRichOfNutrition:(NSString *)nutrientAsColumnName andGivenFoodIds:(NSArray*)givenFoodIds
//{
//    if (givenFoodIds.count == 0)
//        return false;
//    
//    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*1];
//    [sqlStr appendString:@"SELECT F.NDB_No \n"];
////    [sqlStr appendString:@"  FROM FoodNutritionCustom F JOIN Food_Supply_DRI_Amount D on F.NDB_No=D.NDB_No \n"];
//    [sqlStr appendString:@"  FROM FoodNutrition F join FoodCustom FC on F.NDB_No=FC.NDB_No JOIN Food_Supply_DRI_Amount D on F.NDB_No=D.NDB_No \n"];
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
//    [sqlStr appendString:@" LIMIT 1"];
//
//    NSLog(@"existAnyGivenFoodsBeRichOfNutrition sqlStr=%@",sqlStr);
//    
//    FMResultSet *rs = [dbfm executeQuery:sqlStr withArgumentsInArray:givenFoodIds];
//    NSArray * dataAry = [self.class FMResultSetToDictionaryArray:rs];
//    bool retval = (dataAry.count > 0);
//    NSLog(@"existAnyGivenFoodsBeRichOfNutrition ret:%d",retval);
//    return retval;
//}



-(NSArray *) getAllFood
{
    NSLog(@"getAllFood begin");
//    NSString *query = @""
//    "SELECT FNC.*,P.PicPath FROM FoodNutritionCustom FNC LEFT OUTER JOIN FoodPicPath P ON FNC.NDB_No=P.NDB_No"
//    " ORDER BY CnType, NDB_No"
//    ;
//
//    FMResultSet *rs = [dbfm executeQuery:query];
//    NSArray * dataAry = [LZDataAccess FMResultSetToDictionaryArray:rs];
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




-(NSArray *) getFoodsByColumnValuePairFilter_withColumnValuePairs_equal:(NSArray*)columnValuePairs_equal andColumnValuesPairs_equal:(NSArray*)columnValuesPairs_equal andColumnValuePairs_like:(NSArray*)columnValuePairs_like andColumnValuesPairs_like:(NSArray*)columnValuesPairs_like
{
    NSLog(@"getFoodsByColumnValuePairFilter_withColumnValuePairs_equal enter");
    //    if (includeFoodClass == nil && excludeFoodClass == nil)
    //        return nil;
    NSMutableString *sqlStr = [self getSql_SelectFoodMainPart];
    
//    NSMutableArray *exprIncludeORdata = [NSMutableArray array];
    NSMutableArray *exprIncludeANDdata = [NSMutableArray array];
//    NSMutableArray *exprExcludedata = [NSMutableArray array];
    
    if (columnValuePairs_equal.count > 0){
        for (int i=0; i<columnValuePairs_equal.count; i++) {
            NSArray* columnValuePair = columnValuePairs_equal[i];
            NSString *strColumn = columnValuePair[0];
            NSString *strOp = @"=";
            id val = columnValuePair[1];
            NSMutableArray *expr = [NSMutableArray arrayWithCapacity:3];
            [expr addObject:strColumn];
            [expr addObject:strOp];
            [expr addObject:[NSArray arrayWithObjects:val, nil]];
            [exprIncludeANDdata addObject:expr];
        }
    }
    if (columnValuesPairs_equal.count > 0){
        for (int i=0; i<columnValuesPairs_equal.count; i++) {
            NSArray* columnValuesPair = columnValuesPairs_equal[i];
            NSString *strColumn = columnValuesPair[0];
            NSString *strOp = @"=";
            NSArray *values = columnValuesPair[1];
            NSMutableArray *expr = [NSMutableArray arrayWithCapacity:3];
            [expr addObject:strColumn];
            [expr addObject:strOp];
            [expr addObject:values];
            [exprIncludeANDdata addObject:expr];
        }
    }
    
    if (columnValuePairs_like.count > 0){
        for (int i=0; i<columnValuePairs_like.count; i++) {
            NSArray* columnValuePair = columnValuePairs_like[i];
            NSString *strColumn = columnValuePair[0];
            NSString *strOp = @"LIKE";
            NSString *val = [NSString stringWithFormat:@"%%%@",columnValuePair[1]] ;
            NSMutableArray *expr = [NSMutableArray arrayWithCapacity:3];
            [expr addObject:strColumn];
            [expr addObject:strOp];
            [expr addObject:[NSArray arrayWithObjects:val, nil]];
            [exprIncludeANDdata addObject:expr];
        }
    }
    if (columnValuesPairs_like.count > 0){
        for (int i=0; i<columnValuesPairs_like.count; i++) {
            NSArray* columnValuesPair = columnValuesPairs_like[i];
            NSString *strColumn = columnValuesPair[0];
            NSString *strOp = @"LIKE";
            NSArray *values = columnValuesPair[1];
            NSMutableArray *valuesForLike = [NSMutableArray arrayWithCapacity:values.count];
            for(int j=0; j<values.count; j++){
                NSString *val = [NSString stringWithFormat:@"%%%@",values[j]] ;
                [valuesForLike addObject:val];
            }
            NSMutableArray *expr = [NSMutableArray arrayWithCapacity:3];
            [expr addObject:strColumn];
            [expr addObject:strOp];
            [expr addObject:valuesForLike];
            [exprIncludeANDdata addObject:expr];
        }
    }

    NSDictionary *filters = [NSDictionary dictionaryWithObjectsAndKeys:
//                             exprIncludeORdata,@"includeOR",
                             exprIncludeANDdata,@"includeAND",
//                             exprExcludedata,@"exclude",
                             nil];
    NSDictionary *localOptions = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:false],@"varBeParamWay", nil];
    NSArray * dataAry = [self getRowsByQuery:sqlStr andFilters:filters andWhereExistInQuery:false andAfterWherePart:nil andOptions:localOptions];
    NSLog(@"getFoodsByColumnValuePairFilter_withColumnValuePairs_equal return:\n%@",[LZUtility getObjectDescription:dataAry andIndent:0]);
    return dataAry;
}


-(NSArray *) getFoodsByShowingPart:(NSString*)cnNamePart andEnNamePart:(NSString*)enNamePart andCnType:(NSString*)cnType
{
    NSLog(@"getFoodsByShowingPart enter, cnNamePart=%@, enNamePart=%@, cnType=%@",cnNamePart,enNamePart,cnType);
    NSMutableArray* columnValuePairs_like = [NSMutableArray arrayWithCapacity:2];
    if (cnNamePart.length > 0){
        [columnValuePairs_like addObject:[NSArray arrayWithObjects:COLUMN_NAME_CnCaption,cnNamePart, nil]];
    }
    if (enNamePart.length > 0){
        [columnValuePairs_like addObject:[NSArray arrayWithObjects:COLUMN_NAME_FoodNameEn,enNamePart, nil]];
    }
    
    NSMutableArray* columnValuePairs_equal = [NSMutableArray arrayWithCapacity:1];
    if (cnType.length > 0){
        [columnValuePairs_equal addObject:[NSArray arrayWithObjects:COLUMN_NAME_CnType,cnType, nil]];
    }
    return [self getFoodsByColumnValuePairFilter_withColumnValuePairs_equal:columnValuePairs_equal andColumnValuesPairs_equal:nil andColumnValuePairs_like:columnValuePairs_like andColumnValuesPairs_like:nil];
}

-(NSArray *)getFoodCnTypes
{
    NSMutableString *sqlStr = [NSMutableString stringWithCapacity:1000*1];
    [sqlStr appendString:@"SELECT distinct CnType FROM FoodCustom FC\n"];
    NSString *orderByPart = @" ORDER BY CnType";
    NSArray * dataAry = [self getRowsByQuery:sqlStr andFilters:nil andWhereExistInQuery:false andAfterWherePart:orderByPart andOptions:nil];
    NSArray * valAry = [LZUtility getPropertyArrayFromDictionaryArray_withPropertyName:@"CnType" andDictionaryArray:dataAry];
    NSLog(@"getFoodCnTypes ret: %@",[LZUtility getObjectDescription:valAry andIndent:0] );
    return valAry;
}


/*
 用以支持得到nutrients的信息数据，并可以通过普通的nutrient的列名取到相应的nutrient信息。
 */
-(NSMutableDictionary*)getNutrientInfoAs2LevelDictionary_withNutrientIds:(NSArray*)nutrientIds
{
    NSLog(@"getNutrientInfoAs2LevelDictionary_withNutrientIds enter, nutrientIds=%@",[nutrientIds debugDescription]);
    
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


-(NSArray *) getRichNutritionFoodForNutrient:(NSString *)nutrientName andNutrientAmount:(NSNumber*)nutrientAmount andIfNeedCustomDefinedFoods:(BOOL) ifNeedCustomDefinedFoods
{
    NSArray * foods = [self getRichNutritionFood:nutrientName andTopN:0 andIfNeedCustomDefinedFoods:ifNeedCustomDefinedFoods];
    
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
//    NSArray * rows = [self selectAllForTable:TABLE_NAME_FoodCollocation andOrderBy:@" ORDER BY CollocationCreateTime DESC"];
    NSArray * rows = [self selectAllForTable:TABLE_NAME_FoodCollocation andOrderBy:nil];
    return rows;
}


-(NSArray*)getCollocationFoodData_withCollocationId:(NSNumber*)nmCollocationId
{
    return [self selectTableByEqualFilter_withTableName:TABLE_NAME_CollocationFood andField:COLUMN_NAME_CollocationId andValue:nmCollocationId
                                             andColumns:[NSArray arrayWithObjects:COLUMN_NAME_FoodId,COLUMN_NAME_FoodAmount, nil] andOrderByPart:nil andNeedDistinct:false];
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


-(NSArray*)getDiseaseGroupInfo_byType:(NSString*)groupType
{
    NSArray *dgDictAry = [self selectTableByEqualFilter_withTableName:TABLE_NAME_DiseaseGroup andField:COLUMN_NAME_dsGroupType andValue:groupType andColumns:nil andOrderByPart:nil andNeedDistinct:false];
    NSLog(@"getDiseaseGroup_byType ret:%@", [LZUtility getObjectDescription:dgDictAry andIndent:0] );
//    NSLog(@"getDiseaseGroup_byType ret:%@",[dgDictAry debugDescription]);// show chinese as unicode as '\U1234'
//    NSLog(@"getDiseaseGroup_byType ret:%s",[[dgDictAry debugDescription] UTF8String]);// show chinese as unicode as '\U1234'
//    NSLog(@"getDiseaseGroup_byType ret:%s",[[dgDictAry description] UTF8String]);// show chinese as unicode as '\U1234'
//    NSLog(@"getDiseaseGroup_byType ret:%s",[[dgDictAry description] UTF8String]);// show chinese as unicode as '\U1234'
    return dgDictAry;
}

//-(NSArray*)getDiseaseNamesOfGroup:(NSString*)groupName andDepartment:(NSString*)department andDiseaseType:(NSString*)diseaseType andTimeType:(NSString*)timeType
//{
//    NSLog(@"getDiseaseNamesOfGroup enter, groupName=%@, department=%@, diseaseType=%@, timeType=%@",groupName,department,diseaseType,timeType);
//    
//    NSMutableArray *fieldValuePairs = [NSMutableArray array];
//    if (groupName != nil) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_DiseaseGroup,groupName, nil]];
//    if (department != nil) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_DiseaseDepartment,department, nil]];
//    if (diseaseType != nil) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_DiseaseType,diseaseType, nil]];
//    if (timeType != nil) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_DiseaseTimeType,timeType, nil]];
//
//    NSArray *diseaseInfoAry = [self selectTableByEqualFilter_withTableName:TABLE_NAME_DiseaseInGroup andFieldValuePairs:fieldValuePairs andSelectColumns:[NSArray arrayWithObjects:COLUMN_NAME_Disease, nil] andOrderByPart:nil andNeedDistinct:false];
//    NSArray *diseaseNameAry = [LZUtility getPropertyArrayFromDictionaryArray_withPropertyName:COLUMN_NAME_Disease andDictionaryArray:diseaseInfoAry];
//    
////    NSLog(@"getDiseaseNamesOfGroup return=%@",[diseaseNameAry descriptionWithLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]]); // show chinese as unicode as '\U1234'
//    NSLog(@"getDiseaseNamesOfGroup return=%@",[diseaseNameAry debugDescription]);//can show chinese, not unicode as '\U1234'
//
//    return diseaseNameAry;
//}
-(NSArray*)getDiseaseIdsOfGroup:(NSString*)groupName andDepartment:(NSString*)department andDiseaseType:(NSString*)diseaseType andTimeType:(NSString*)timeType
{
    NSLog(@"getDiseaseIdsOfGroup enter, groupName=%@, department=%@, diseaseType=%@, timeType=%@",groupName,department,diseaseType,timeType);
    
    NSMutableArray *fieldValuePairs = [NSMutableArray array];
    if (groupName != nil) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_DiseaseGroup,groupName, nil]];
    if (department != nil) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_DiseaseDepartment,department, nil]];
    if (diseaseType != nil) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_DiseaseType,diseaseType, nil]];
    if (timeType != nil) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_DiseaseTimeType,timeType, nil]];
    
    NSArray *diseaseInfoAry = [self selectTableByEqualFilter_withTableName:TABLE_NAME_DiseaseInGroup andFieldValuePairs:fieldValuePairs andSelectColumns:[NSArray arrayWithObjects:COLUMN_NAME_Disease, nil] andOrderByPart:nil andNeedDistinct:false];
    NSArray *diseaseIdAry = [LZUtility getPropertyArrayFromDictionaryArray_withPropertyName:COLUMN_NAME_Disease andDictionaryArray:diseaseInfoAry];
    
    NSLog(@"getDiseaseIdsOfGroup return=%@",[diseaseIdAry debugDescription]);//can show chinese, not unicode as '\U1234'
    
    return diseaseIdAry;
}

/*
 return DiseaseInfo array. DiseaseInfo is Dictionary.
 */
-(NSArray*)getDiseaseInfosOfGroup:(NSString*)groupName andDepartment:(NSString*)department andDiseaseType:(NSString*)diseaseType andTimeType:(NSString*)timeType
{
    NSLog(@"getDiseaseInfosOfGroup enter, groupName=%@, department=%@, diseaseType=%@, timeType=%@",groupName,department,diseaseType,timeType);
    
    NSMutableArray *fieldValuePairs = [NSMutableArray array];
    if (groupName != nil) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_DiseaseGroup,groupName, nil]];
    if (department != nil) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_DiseaseDepartment,department, nil]];
    if (diseaseType != nil) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_DiseaseType,diseaseType, nil]];
    if (timeType != nil) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_DiseaseTimeType,timeType, nil]];
    
    NSArray *diseaseInfoAry = [self selectTableByEqualFilter_withTableName:TABLE_NAME_DiseaseInGroup andFieldValuePairs:fieldValuePairs andSelectColumns:nil andOrderByPart:nil andNeedDistinct:false];

    NSLog(@"getDiseaseInfosOfGroup return=%@",[LZUtility getObjectDescription:diseaseInfoAry andIndent:0]);
    return diseaseInfoAry;
}

///*
// Departments -- array, DepartmentDiseasesDict -- array dict
// */
//-(NSDictionary*)getDiseasesOrganizedByColumn:(NSString*)organizedByColumn andFilters_Group:(NSString*)groupName andDepartment:(NSString*)department andDiseaseType:(NSString*)diseaseType andTimeType:(NSString*)timeType
//{
//    NSLog(@"getDiseasesOrganizedByColumn enter, organizedByColumn=%@, groupName=%@, department=%@, diseaseType=%@, timeType=%@",organizedByColumn,groupName,department,diseaseType,timeType);
//    
//    NSMutableArray *fieldValuePairs = [NSMutableArray array];
//    if (groupName != nil) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_DiseaseGroup,groupName, nil]];
//    if (department != nil) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_DiseaseDepartment,department, nil]];
//    if (diseaseType != nil) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_DiseaseType,diseaseType, nil]];
//    if (timeType != nil) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_DiseaseTimeType,timeType, nil]];
//    
//    NSArray *departmentInfoAry = [self selectTableByEqualFilter_withTableName:TABLE_NAME_DiseaseInGroup andFieldValuePairs:fieldValuePairs andSelectColumns:[NSArray arrayWithObjects:organizedByColumn, nil] andOrderByPart:nil andNeedDistinct:true];
//    NSLog(@"getDiseasesOrganizedByColumn departmentInfoAry=%@", [LZUtility getObjectDescription:departmentInfoAry andIndent:0] );
//    NSArray *departmentNames = [LZUtility getPropertyArrayFromDictionaryArray_withPropertyName:organizedByColumn andDictionaryArray:departmentInfoAry];
//    
//    NSArray *diseaseRowAry = [self selectTableByEqualFilter_withTableName:TABLE_NAME_DiseaseInGroup andFieldValuePairs:fieldValuePairs andSelectColumns:[NSArray arrayWithObjects:COLUMN_NAME_Disease,organizedByColumn, nil] andOrderByPart:nil andNeedDistinct:false];
//    NSMutableDictionary *departmentDiseasesDict = [NSMutableDictionary dictionaryWithCapacity:departmentNames.count];
//    for(int i=0; i<diseaseRowAry.count; i++){
//        NSDictionary *diseaseRow = diseaseRowAry[i];
//        NSString *diseaseName = diseaseRow[COLUMN_NAME_Disease];
//        NSString *diseaseDepartment = diseaseRow[organizedByColumn];
//        [LZUtility addUnitItemToArrayDictionary_withUnitItem:diseaseName withArrayDictionary:departmentDiseasesDict andKey:diseaseDepartment];
//    }
//    
//    NSMutableDictionary *retData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                    departmentNames,@"departmentNames",
//                                    departmentDiseasesDict,@"departmentDiseasesDict",
//                                    nil];
//    NSLog(@"getDiseasesOrganizedByColumn ret:%@", [LZUtility getObjectDescription:retData andIndent:0] );
//    return retData;
//}
/*
 Departments -- array, DepartmentDiseaseInfosDict -- array dict。看来目前暂且没有用上
 */
-(NSDictionary*)getDiseaseInfosOrganizedByColumn:(NSString*)organizedByColumn andFilters_Group:(NSString*)groupName andDepartment:(NSString*)department andDiseaseType:(NSString*)diseaseType andTimeType:(NSString*)timeType
{
    NSLog(@"getDiseaseInfosOrganizedByColumn enter, organizedByColumn=%@, groupName=%@, department=%@, diseaseType=%@, timeType=%@",organizedByColumn,groupName,department,diseaseType,timeType);
    
    NSMutableArray *fieldValuePairs = [NSMutableArray array];
    if (groupName != nil) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_DiseaseGroup,groupName, nil]];
    if (department != nil) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_DiseaseDepartment,department, nil]];
    if (diseaseType != nil) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_DiseaseType,diseaseType, nil]];
    if (timeType != nil) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_DiseaseTimeType,timeType, nil]];
    
    NSArray *departmentInfoAry = [self selectTableByEqualFilter_withTableName:TABLE_NAME_DiseaseInGroup andFieldValuePairs:fieldValuePairs andSelectColumns:[NSArray arrayWithObjects:organizedByColumn, nil] andOrderByPart:nil andNeedDistinct:true];
    NSLog(@"getDiseaseInfosOrganizedByColumn departmentInfoAry=%@", [LZUtility getObjectDescription:departmentInfoAry andIndent:0] );
    NSArray *departmentNames = [LZUtility getPropertyArrayFromDictionaryArray_withPropertyName:organizedByColumn andDictionaryArray:departmentInfoAry];
    
    NSArray *diseaseRowAry = [self selectTableByEqualFilter_withTableName:TABLE_NAME_DiseaseInGroup andFieldValuePairs:fieldValuePairs andSelectColumns:nil andOrderByPart:nil andNeedDistinct:false];
    NSMutableDictionary *departmentDiseaseInfosDict = [NSMutableDictionary dictionaryWithCapacity:departmentNames.count];
    for(int i=0; i<diseaseRowAry.count; i++){
        NSDictionary *diseaseRow = diseaseRowAry[i];
        NSString *diseaseDepartment = diseaseRow[organizedByColumn];
        [LZUtility addUnitItemToArrayDictionary_withUnitItem:diseaseRow withArrayDictionary:departmentDiseaseInfosDict andKey:diseaseDepartment];
    }
    
    NSMutableDictionary *retData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    departmentNames,@"departmentNames",
                                    departmentDiseaseInfosDict,@"departmentDiseaseInfosDict",
                                    nil];
    NSLog(@"getDiseaseInfosOrganizedByColumn ret:%@", [LZUtility getObjectDescription:retData andIndent:0] );
    return retData;
}


//-(NSDictionary*)getDiseaseNutrientRows_ByDiseaseNames:(NSArray*)diseaseNames andDiseaseGroup:(NSString*)groupName
//{
//    NSMutableArray *fieldValuePairs = [NSMutableArray array];
//    if (groupName != nil) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_DiseaseGroup,groupName, nil]];
//    if (diseaseNames != nil) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_Disease,diseaseNames, nil]];
//    
//    NSArray *diseaseNutrientRows = [self selectTableByEqualFilter_withTableName:TABLE_NAME_DiseaseNutrient andFieldValuePairs:fieldValuePairs andSelectColumns:[NSArray arrayWithObjects:COLUMN_NAME_Disease,COLUMN_NAME_NutrientID,COLUMN_NAME_LackLevelMark, nil] andOrderByPart:nil andNeedDistinct:true];
//    NSLog(@"getDiseaseNutrientRows_ByDiseaseNames diseaseNutrientRows=%@", [LZUtility getObjectDescription:diseaseNutrientRows andIndent:0] );
//    
//    NSMutableDictionary * diseaseNutrientInfosByDiseaseDict = [NSMutableDictionary dictionaryWithCapacity:diseaseNames.count];
//    for(int i=0; i<diseaseNutrientRows.count; i++){
//        NSDictionary *diseaseNutrientRow = diseaseNutrientRows[i];
//        NSString *diseaseName = diseaseNutrientRow[COLUMN_NAME_Disease];
//        [LZUtility addUnitItemToArrayDictionary_withUnitItem:diseaseNutrientRow withArrayDictionary:diseaseNutrientInfosByDiseaseDict andKey:diseaseName];
//    }
//    NSLog(@"in getDiseaseNutrientRows_ByDiseaseNames, diseaseNutrientInfosByDiseaseDict=%@",[LZUtility getObjectDescription:diseaseNutrientInfosByDiseaseDict andIndent:0]);
//    return diseaseNutrientInfosByDiseaseDict;
//}
-(NSDictionary*)getDiseaseNutrientRows_ByDiseaseIds:(NSArray*)diseaseIds andDiseaseGroup:(NSString*)groupName
{
    NSMutableArray *fieldValuePairs = [NSMutableArray array];
    if (groupName != nil) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_DiseaseGroup,groupName, nil]];
    if (diseaseIds != nil) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_Disease,diseaseIds, nil]];
    
    NSArray *diseaseNutrientRows = [self selectTableByEqualFilter_withTableName:TABLE_NAME_DiseaseNutrient andFieldValuePairs:fieldValuePairs andSelectColumns:[NSArray arrayWithObjects:COLUMN_NAME_Disease,COLUMN_NAME_NutrientID,COLUMN_NAME_LackLevelMark, nil] andOrderByPart:nil andNeedDistinct:true];
    NSLog(@"getDiseaseNutrientRows_ByDiseaseIds diseaseNutrientRows=%@", [LZUtility getObjectDescription:diseaseNutrientRows andIndent:0] );
    
    NSMutableDictionary * diseaseNutrientInfosByDiseaseDict = [NSMutableDictionary dictionaryWithCapacity:diseaseIds.count];
    for(int i=0; i<diseaseNutrientRows.count; i++){
        NSDictionary *diseaseNutrientRow = diseaseNutrientRows[i];
        NSString *diseaseId = diseaseNutrientRow[COLUMN_NAME_Disease];
        [LZUtility addUnitItemToArrayDictionary_withUnitItem:diseaseNutrientRow withArrayDictionary:diseaseNutrientInfosByDiseaseDict andKey:diseaseId];
    }
    NSLog(@"in getDiseaseNutrientRows_ByDiseaseIds, diseaseNutrientInfosByDiseaseDict=%@",[LZUtility getObjectDescription:diseaseNutrientInfosByDiseaseDict andIndent:0]);
    return diseaseNutrientInfosByDiseaseDict;
}

/*
 day 是 8位整数,如  20120908
 TimeType 等于 0时，表示没有TimeType的过滤条件
 */
-(NSArray*)getUserCheckDiseaseRecord_withDay:(int)day andTimeType:(int)TimeType
{
    NSLog(@"getUserCheckDiseaseRecord_withDay enter");
    NSMutableArray *fieldValuePairs = [NSMutableArray array];
    [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_Day,[NSNumber numberWithInt:day], nil]];
    if (TimeType > 0) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_TimeType,[NSNumber numberWithInt:TimeType], nil]];
    
    NSArray *rows = [self selectTableByEqualFilter_withTableName:TABLE_NAME_UserCheckDiseaseRecord andFieldValuePairs:fieldValuePairs andSelectColumns:nil andOrderByPart:nil andNeedDistinct:false];
    NSLog(@"getUserCheckDiseaseRecord_withDay rows=%@", [LZUtility getObjectDescription:rows andIndent:0] );
    return rows;
}
-(BOOL)saveUserCheckDiseaseRecord_withDay:(int)day andTimeType:(int)TimeType UpdateTime:(NSDate*)UpdateTime andDiseases:(NSArray*)Diseases andLackNutrientIDs:(NSArray*)LackNutrientIDs andHealthMark:(int)HealthMark
{
    NSLog(@"saveUserCheckDiseaseRecord_withDay enter");
    NSArray *rows = [self getUserCheckDiseaseRecord_withDay:day andTimeType:TimeType];
    if (rows.count ==0){
        return [self insertUserCheckDiseaseRecord_withDay:day andTimeType:TimeType UpdateTime:UpdateTime andDiseases:Diseases andLackNutrientIDs:LackNutrientIDs andHealthMark:HealthMark];
    }else{
        return [self updateUserCheckDiseaseRecord_withDay:day andTimeType:TimeType UpdateTime:UpdateTime andDiseases:Diseases andLackNutrientIDs:LackNutrientIDs andHealthMark:HealthMark];
    }
}
/*
 day 是 8位整数,如  20120908
 TimeType 的可取值：1 代表上午，2 代表下午，3 代表晚上
 */
-(BOOL)insertUserCheckDiseaseRecord_withDay:(int)day andTimeType:(int)TimeType UpdateTime:(NSDate*)UpdateTime andDiseases:(NSArray*)Diseases andLackNutrientIDs:(NSArray*)LackNutrientIDs andHealthMark:(int)HealthMark
{
    NSLog(@"insertUserCheckDiseaseRecord_withDay enter");
//    NSDateFormatter *dtFmt_yyyyMMdd_CurrentTimeZone = [[NSDateFormatter alloc]init];
//    [dtFmt_yyyyMMdd_CurrentTimeZone setDateFormat:@"yyyyMMdd"];
//    NSDateFormatter *dtFmt_HHmmss_CurrentTimeZone = [[NSDateFormatter alloc]init];
//    [dtFmt_HHmmss_CurrentTimeZone setDateFormat:@"HHmmss"];
    
    NSTimeInterval dUpdateTime = [UpdateTime timeIntervalSince1970];
    long long llUpdateTime = (long long)round(dUpdateTime*1000);
    NSString *sDiseases = @"";
    if (Diseases!=nil && Diseases.count > 0){
        sDiseases = [Diseases componentsJoinedByString:SeperatorForNames];
    }
    NSString *sLackNutrientIDs = @"";
    if (LackNutrientIDs!=nil && LackNutrientIDs.count > 0){
        sLackNutrientIDs = [LackNutrientIDs componentsJoinedByString:SeperatorForNames];
    }

    NSString *insertSql = [NSString stringWithFormat:
                           @"INSERT INTO UserCheckDiseaseRecord (Day, TimeType, UpdateTime, Diseases, LackNutrientIDs, HealthMark) VALUES (?,?,?,?,?,?);"
                           ];
    NSArray *paramAry = [NSArray arrayWithObjects:[NSNumber numberWithInt:day], [NSNumber numberWithInt:TimeType], [NSNumber numberWithLongLong:llUpdateTime], sDiseases, sLackNutrientIDs, [NSNumber numberWithInt:HealthMark], nil];
    BOOL dbopState = [dbfm executeUpdate:insertSql error:nil withArgumentsInArray:paramAry];
    return dbopState;
}
-(BOOL)updateUserCheckDiseaseRecord_withDay:(int)day andTimeType:(int)TimeType UpdateTime:(NSDate*)UpdateTime andDiseases:(NSArray*)Diseases andLackNutrientIDs:(NSArray*)LackNutrientIDs andHealthMark:(int)HealthMark
{
    NSLog(@"updateUserCheckDiseaseRecord_withDay enter");

    NSTimeInterval dUpdateTime = [UpdateTime timeIntervalSince1970];
    long long llUpdateTime = (long long)round(dUpdateTime*1000);
    NSString *sDiseases = @"";
    if (Diseases!=nil && Diseases.count > 0){
        sDiseases = [Diseases componentsJoinedByString:@","];
    }
    NSString *sLackNutrientIDs = @"";
    if (LackNutrientIDs!=nil && LackNutrientIDs.count > 0){
        sLackNutrientIDs = [LackNutrientIDs componentsJoinedByString:@","];
    }
    
    NSString *updateSql = [NSString stringWithFormat:
                           @"UPDATE UserCheckDiseaseRecord SET UpdateTime=?, Diseases=?, LackNutrientIDs=?, HealthMark=? WHERE Day=? AND TimeType=? ;"
                           ];
    NSArray *paramAry = [NSArray arrayWithObjects:[NSNumber numberWithLongLong:llUpdateTime], sDiseases, sLackNutrientIDs, [NSNumber numberWithInt:HealthMark], [NSNumber numberWithInt:day], [NSNumber numberWithInt:TimeType], nil];
    BOOL dbopState = [dbfm executeUpdate:updateSql error:nil withArgumentsInArray:paramAry];
    return dbopState;
}




-(NSDictionary*)getTranslationItemsDictionaryByType:(NSString*)itemType
{
    NSLog(@"getTranslationItemsDictionaryByType enter, itemType=%@",itemType);
    NSMutableArray *fieldValuePairs = [NSMutableArray array];
    if (itemType != nil) [fieldValuePairs addObject:[NSArray arrayWithObjects:COLUMN_NAME_ItemType,itemType, nil]];
    
    NSArray *translationItemInfoAry = [self selectTableByEqualFilter_withTableName:TABLE_NAME_TranslationItem andFieldValuePairs:fieldValuePairs andSelectColumns:nil andOrderByPart:nil andNeedDistinct:false];
    NSDictionary *translationItemInfo2LevelDict = [LZUtility dictionaryArrayTo2LevelDictionary_withKeyName:COLUMN_NAME_ItemID andDicArray:translationItemInfoAry];
    
    NSLog(@"getTranslationItemsDictionaryByType return=%@",[LZUtility getObjectDescription:translationItemInfo2LevelDict andIndent:0]);
    return translationItemInfo2LevelDict;
}



@end






























































