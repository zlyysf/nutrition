//
//  LZGlobal.m
//  nutrition
//
//  Created by Yasofon on 14-2-7.
//  Copyright (c) 2014年 lingzhi mobile. All rights reserved.
//

#import "LZGlobal.h"
#import "LZUtility.h"
#import "LZDataAccess.h"

#import "LZNutrientionManager.h"

@interface LZGlobal()

@property (strong,nonatomic)NSDictionary *m_nutrientInfoDict2Level;
@property (strong,nonatomic)NSDictionary *m_foodInfoDict2Level;

@end


@implementation LZGlobal

@synthesize m_nutrientInfoDict2Level, m_foodInfoDict2Level;



+(LZGlobal*)SharedInstance
{
    static dispatch_once_t LZNMOnce;
    static LZGlobal * sharedInstance;
    dispatch_once(&LZNMOnce, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}

-(id)init
{
    if (self = [super init])
    {
    }
    return self;
}

-(NSDictionary *)getAllNutrient2LevelDict
{
    if (m_nutrientInfoDict2Level == nil){
        LZDataAccess *da = [LZDataAccess singleton];
        m_nutrientInfoDict2Level = [da getNutrientInfoAs2LevelDictionary_withNutrientIds:nil];
    }
    return m_nutrientInfoDict2Level;
}

-(NSDictionary *)getAllFood2LevelDict
{
    if (m_foodInfoDict2Level == nil){
        LZDataAccess *da = [LZDataAccess singleton];
        NSArray *dataAry = [da getAllFood];
        m_foodInfoDict2Level = [LZUtility dictionaryArrayTo2LevelDictionary_withKeyName:COLUMN_NAME_NDB_No andDicArray:dataAry];
    }
    return m_foodInfoDict2Level;
}

@end
