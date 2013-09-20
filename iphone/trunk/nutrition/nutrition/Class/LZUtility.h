//
//  LZUtility.h
//  nutrition
//
//  Created by liu miao on 4/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LZDataAccess.h"


@interface LZUtility : NSObject

+(NSDecimalNumber*)getDecimalFromDouble:(double)dval withScale:(NSInteger)scale;

+(NSNumber *)add2NSNumberByDouble_withNumber1:(NSNumber*)nm1 andNumber2:(NSNumber*)nm2;
+(NSNumber *)addNumberWithDouble:(double)d1 andNumber2:(NSNumber*)nm2;

+(NSNumber *)divideNSNumberByDouble_withDividend:(NSNumber*)dividend andDivider:(NSNumber*)divider;

+(NSNumber *)addDoubleToDictionaryItem:(double)valAdd withDictionary:(NSMutableDictionary*)data andKey:(NSString *)datakey;
+(void)addDoubleDictionaryToDictionary_withSrcAmountDictionary:(NSDictionary*)srcAmountDict withDestDictionary:(NSMutableDictionary*)destAmountDict;
+(double)getDoubleFromDictionaryItem_withDictionary:(NSMutableDictionary*)data andKey:(NSString *)datakey;

+(NSNumber *)addIntToDictionaryItem:(int)valAdd withDictionary:(NSMutableDictionary*)data andKey:(NSString *)datakey;
+(int)getIntFromDictionaryItem_withDictionary:(NSMutableDictionary*)data andKey:(NSString *)datakey;

+(NSMutableArray *)addUnitItemToArrayDictionary_withUnitItem:(NSObject*)unitItem withArrayDictionary:(NSMutableDictionary*)arrayDict andKey:(NSString *)keyForArray;

+(NSMutableArray*)generateArrayWithFillItem:(NSObject*)fillItem andArrayLength:(int)length;
+(NSMutableDictionary*)generateDictionaryWithFillItem:(NSObject*)fillItem andKeys:(NSArray*)keys;

+(NSString *) convert2DArrayToCsv: (NSString *)csvFileName withData:(NSArray*)ary2D;
+(NSString *)convert2DArrayToCsv:(NSString*)csvFileName withColumnNames:(NSArray*)columnNames andRows2D:(NSArray*)rows2D;
+(NSString *)convert3DArrayToCsv:(NSString*)csvFileName andRows2DAry:(NSArray*)rows2DAry;

+(NSMutableString *) convert2DArrayToHtmlTable:(NSArray*)ary2D withColumnNames:(NSArray*)columnNames;
+(NSMutableString *) convert3DArrayToHtmlTables:(NSArray*)ary3D;
+(NSMutableArray*)generateEmptyArray:(int)count;

+(NSString *)copyResourceToDocumentWithResFileName:(NSString*)resFileName andDestFileName:(NSString*)destFileName;

+(NSString*)getFullHtml_withPart:(NSString*)htmlPart;



+(NSMutableArray*)arrayMinusSet_withArray:(NSMutableArray*)srcAry andMinusSet:(NSSet*)minusSet;
+(NSMutableArray*)arrayMinusArray_withSrcArray:(NSMutableArray*)srcAry andMinusArray:(NSArray*)minusAry;
+(NSMutableArray*)arrayIntersectSet_withArray:(NSMutableArray*)ary andSet:(NSSet*)set;
+(NSMutableArray*)arrayIntersectArray_withSrcArray:(NSMutableArray*)srcAry andIntersectArray:(NSArray*)intersectAry;

+(NSMutableArray *)arrayAddArrayInSetWay_withArray1:(NSArray*)ary1 andArray2:(NSArray*)ary2;

+(BOOL)arrayEqualArrayInSetWay_withArray1:(NSArray*)ary1 andArray2:(NSArray*)ary2;
+(BOOL)arrayContainArrayInSetWay_withOuterArray:(NSArray*)outerAry andInnerArray:(NSArray*)innerAry;

+(NSMutableArray*)getPropertyArrayFromDictionaryArray_withPropertyName:(NSString*)propertyName andDictionaryArray:(NSArray*)dicAry;

+(NSMutableDictionary*)dictionaryArrayTo2LevelDictionary_withKeyName:(NSString*)keyName andDicArray:(NSArray*)dicArray;

+(NSMutableArray*)dictionaryAllToArray:(NSDictionary*)dict;

+(UIColor*)getNutrientColorForNutrientId:(NSString *)nutrientId;

+ (BOOL)isUserProfileComplete;

+ (NSDictionary *)getActivityLevelInfo;

+(long long)getMillisecond:(NSDate*)datetime;

+(void)initializePreferNutrient;

+(NSArray *)convertPreferNutrientArrayToParamArray:(NSArray *)preferArray;

+ (NSString *)stampFromInterval:(NSNumber *) seconds;

+ (BOOL)twoDateIsSameDay:(NSDate *)fist second:(NSDate *)second;

+(NSString*)convertNumberToFoodIdStr:(NSNumber *)foodIdNum;

+(BOOL)isUseUnitDisplay:(NSNumber *)totalWeight unitWeight:(NSNumber *)singleWeight;

+(NSMutableString*)getObjectDescription : (NSObject*)obj andIndent:(NSUInteger)level;

+(BOOL)isIphoneDeviceVersionFive;

+(void)addFood:(NSString *)foodId withFoodAmount:(NSNumber *)foodAmount;

+(void)setReviewFlagForNewVersion;

+(NSString *)getCurrentTimeIdentifier;

+(void)initializeCheckReminder;

+(NSString *)getDateFormatOutput:(NSDate*)date;
@end















