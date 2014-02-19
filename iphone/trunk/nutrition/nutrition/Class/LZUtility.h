//
//  LZUtility.h
//  nutrition
//
//  Created by liu miao on 4/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LZDataAccess.h"
#import "LZUtility.h"
#import "LZConstants.h"


enum {
    // iPhone 1,3,3GS 标准分辨率(320x480px)
    UIDevice_iPhoneStandardRes      = 1,
    // iPhone 4,4S 高清分辨率(640x960px)
    UIDevice_iPhoneHiRes            = 2,
    // iPhone 5 高清分辨率(640x1136px)
    UIDevice_iPhoneTallerHiRes      = 3,
    // iPad 1,2 标准分辨率(1024x768px)
    UIDevice_iPadStandardRes        = 4,
    // iPad 3 High Resolution(2048x1536px)
    UIDevice_iPadHiRes              = 5
}; typedef NSUInteger UIDeviceResolution;


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
+(NSMutableDictionary *)groupbyDictionaryArrayToArrayDictionary:(NSArray*)dictArray andKeyName:(NSString *)keyName;

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

+(NSArray*)getSubArray:(NSArray*)ary andFrom:(int)from andLength:(int)length;

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

+ (UIColor*)getSymptomTypeColorForId:(NSString *)typeId;
+ (BOOL)isUserProfileComplete;
+(NSDictionary*)getUserInfo;

+ (NSDictionary *)getActivityLevelInfo;

+(long long)getMillisecond:(NSDate*)datetime;
+(NSDate *)getDateFromMillisecond:(long long) msSince1970;

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

+(NSDate *)convertOldDateToTodayDate:(NSDate *)date;

+(void)setCheckReminderOn:(BOOL)isOn;

+(NSDate *)getDateForHour:(int)hours Minutes:(int)minutes;

+(BOOL)isCurrentLanguageChinese;

+(NSString *)getNutritionNameInfo:(NSString *)name isChinese:(BOOL)isChinese;
+ (UIImage *) createImageWithColor: (UIColor *) color imageSize:(CGSize )imageSize;

+(NSString *)getSingleItemUnitName:(NSString *)unitName;


+(bool)existAtLeastN_withToBeCheckedCollection:(NSArray*)toBeCheckedAry andFullCollection:(id)fullCol andAtLeastN:(int)atLeastN;
+(NSArray*)inferIllnesses_withSymptoms:(NSArray*)symptomIds andMeasureData:(NSDictionary*)measureData;

+ (NSString *)convertIntToInch:(NSInteger)number;
+(int)calculateAgeAccordingToTheBirthdate:(NSDate *)birthdate;
+(NSDate *)dateBeforeTodayForYears:(int)years;
+(double)getBMI_withWeight:(double)weight andHeight:(double)height;
+(NSString*)getAccurateStringWithDecimal:(float)num;
+(int)getMonthLocalForDistance:(int)distance startLocal:(int)startLocal;


+(NSString*)getPersistKey_ByEachVersion_DBFileUpdatedFlag;
+(NSString*)getPersistKey_ByEachVersion_alreadyLoadFromRemoteDataInParse;


+(NSString *)uniqueDeviceId;

+(double)getSystemVersionValue;
+(BOOL)is_IOS7_OR_LATER;

+ (BOOL)isRunningOnScreen4inch;


+(NSString*)getLocalNutrientName:(NSDictionary*)nutrientDict;
+(NSString*)getLocalNutrientShortName:(NSDictionary*)nutrientDict;
+(NSString*)getLocalFoodName:(NSDictionary*)foodAttrDict;

@end















