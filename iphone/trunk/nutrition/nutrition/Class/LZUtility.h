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

+(NSNumber *)addDoubleToDictionaryItem:(double)valAdd withDictionary:(NSMutableDictionary*)data andKey:(NSString *)datakey;


+(NSString *) convert2DArrayToCsv: (NSString *)csvFileName withData:(NSArray*)ary2D;
+(NSString *)convert2DArrayToCsv:(NSString*)csvFileName withColumnNames:(NSArray*)columnNames andRows2D:(NSArray*)rows2D;

+(NSMutableString *) convert2DArrayToHtmlTable:(NSArray*)ary2D withColumnNames:(NSArray*)columnNames;
+(NSMutableArray*)generateEmptyArray:(int)count;

+(NSString *)copyResourceToDocumentWithResFileName:(NSString*)resFileName andDestFileName:(NSString*)destFileName;

+(NSString*)getFullHtml_withPart:(NSString*)htmlPart;

+(NSMutableArray*)getPropertyArrayFromDictionaryArray_withPropertyName:(NSString*)propertyName andDictionaryArray:(NSArray*)dicAry;

+(NSMutableArray*)arrayMinusSet_withArray:(NSMutableArray*)srcAry andMinusSet:(NSSet*)minusSet;
+(NSMutableArray*)arrayMinusArray_withSrcArray:(NSMutableArray*)srcAry andMinusArray:(NSArray*)minusAry;
+(NSMutableArray*)arrayIntersectSet_withArray:(NSMutableArray*)ary andSet:(NSSet*)set;

+(BOOL)arrayEqualArrayInSetWay_withArray1:(NSArray*)ary1 andArray2:(NSArray*)ary2;

+(NSMutableDictionary*)dictionaryArrayTo2LevelDictionary_withKeyName:(NSString*)keyName andDicArray:(NSArray*)dicArray;

+(NSMutableArray*)dictionaryAllToArray:(NSDictionary*)dict;

+(UIColor*)getNutrientColorForNutrientId:(NSString *)nutrientId;

+ (BOOL)isUserProfileComplete;

+ (NSDictionary *)getActivityLevelInfo;
@end
