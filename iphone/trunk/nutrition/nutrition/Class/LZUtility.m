//
//  LZUtility.m
//  nutrition
//
//  Created by liu miao on 4/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZUtility.h"
#import "LZConstants.h"
#import "LZRecommendFood.h"
#import <math.h>
@implementation LZUtility

+(NSDecimalNumber*)getDecimalFromDouble:(double)dval withScale:(NSInteger)scale
{
    NSString *s1 = [NSString stringWithFormat:@"%%.%df",scale];
    NSString *s2 = [NSString stringWithFormat:s1,dval ];
    NSDecimalNumber *nd = [NSDecimalNumber decimalNumberWithString:s2];
    return nd;
}

+(NSNumber *)add2NSNumberByDouble_withNumber1:(NSNumber*)nm1 andNumber2:(NSNumber*)nm2
{
    double d1 = 0;
    if (nm1 != nil && (NSNull*)nm1 != [NSNull null]) d1 = [nm1 doubleValue];
    double d2 = 0;
    if (nm2 != nil && (NSNull*)nm2 != [NSNull null]) d2 = [nm2 doubleValue];
    double d = d1 +d2;
    return [NSNumber numberWithDouble:d];
}
+(NSNumber *)addNumberWithDouble:(double)d1 andNumber2:(NSNumber*)nm2
{
    double d2 = 0;
    if (nm2 != nil && (NSNull*)nm2 != [NSNull null]) d2 = [nm2 doubleValue];
    double d = d1 +d2;
    return [NSNumber numberWithDouble:d];
}

// dividend / divider
+(NSNumber *)divideNSNumberByDouble_withDividend:(NSNumber*)dividend andDivider:(NSNumber*)divider
{
    if ([divider doubleValue]==0) return [NSNumber numberWithDouble:0];
    double d = [dividend doubleValue] / [divider doubleValue];
    return [NSNumber numberWithDouble:d];
}

+(NSNumber *)addDoubleToDictionaryItem:(double)valAdd withDictionary:(NSMutableDictionary*)data andKey:(NSString *)datakey
{
    assert(data!=nil);
    assert(datakey!=nil);
    id dataVal = [data objectForKey:datakey];
    double sum = 0 ;
    if (dataVal != nil && dataVal != [NSNull null]){
        NSNumber *nmDataVal = dataVal;
        sum = [nmDataVal doubleValue]+valAdd;
    }else{
        sum = valAdd;
    }
    NSNumber *nmSum = [NSNumber numberWithDouble:sum];
    [data setObject:nmSum forKey:datakey];
    return nmSum;
}

+(void)addDoubleDictionaryToDictionary_withSrcAmountDictionary:(NSDictionary*)srcAmountDict withDestDictionary:(NSMutableDictionary*)destAmountDict
{
    if (srcAmountDict.count==0)
        return;
    if (destAmountDict == nil)
        return;
    NSArray * keys = srcAmountDict.allKeys;
    for(int i=0; i<keys.count; i++){
        NSString *key = keys[i];
        NSNumber *nmVal = srcAmountDict[key];
        [self.class addDoubleToDictionaryItem:[nmVal doubleValue] withDictionary:destAmountDict andKey:key];
    }
}

+(double)getDoubleFromDictionaryItem_withDictionary:(NSMutableDictionary*)data andKey:(NSString *)datakey
{
    assert(data!=nil);
    assert(datakey!=nil);
    id dataVal = [data objectForKey:datakey];
    if (dataVal==nil || dataVal == [NSNull null])
        return 0;
    else{
        NSNumber *nmDataVal = dataVal;
        return [nmDataVal doubleValue];
    }
}

+(NSMutableArray *)addUnitItemToArrayDictionary_withUnitItem:(NSObject*)unitItem withArrayDictionary:(NSMutableDictionary*)arrayDict andKey:(NSString *)keyForArray;
{
    assert(unitItem!=nil);
    assert(arrayDict!=nil);
    assert(keyForArray!=nil);
    NSMutableArray *itemAsArray = arrayDict[keyForArray];
    if (itemAsArray == nil){
        itemAsArray = [NSMutableArray array];
        [arrayDict setObject:itemAsArray forKey:keyForArray];
    }
    [itemAsArray addObject:unitItem];
    return itemAsArray;
}

+(NSMutableDictionary*)generateDictionaryWithFillItem:(NSObject*)fillItem andKeys:(NSArray*)keys
{
    assert(fillItem!=nil);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:keys.count];
    for(int i=0; i<keys.count; i++){
        id key = keys[i];
        dict[key] = fillItem;
    }
    return dict;
}

+(NSMutableArray*)generateArrayWithFillItem:(NSObject*)fillItem andArrayLength:(int)length
{
    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:length];
    for(int i=0; i<length; i++){
        [ary addObject:fillItem];
    }
    return ary;
}


+(NSString *) convert2DArrayToCsv: (NSString *)csvFileName withData:(NSArray*)ary2D
{
    NSLog(@"convert2DArrayToCsv enter");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *csvFilePath = [documentsDirectory stringByAppendingPathComponent:csvFileName];
    NSLog(@"csvFilePath=%@",csvFilePath);
    
    NSMutableData *writer = [[NSMutableData alloc] init];
    for(int i=0; i<ary2D.count; i++){
        NSArray *ary1D = ary2D[i];
        NSMutableString *rowStr = [NSMutableString stringWithCapacity:10000];
        for(int j=0 ; j<ary1D.count; j++){
            NSObject *cell = ary1D[j];
            NSMutableString *cellStr = [NSMutableString stringWithCapacity:100];
            [cellStr appendString:@"\""];
            
            NSString *s1 = nil;
            if (cell == nil || cell == [NSNull null]){
                s1 = nil;
            }else if ([cell isKindOfClass:[NSString class]]){
                s1 = (NSString*)cell;
            }else if ([cell isKindOfClass:[NSNumber class]]){
                NSNumber *nm = (NSNumber *)cell;
                s1 = [nm stringValue];
            }else{
                s1 = [cell description];
            }
            if (s1 != nil){
                if ([s1 rangeOfString:@"\""].location != NSNotFound){
                    NSString *s2 = [s1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\"\""];
                    [cellStr appendString:s2];
                }else{
                    [cellStr appendString:s1];
                }
            }
            
            [cellStr appendString:@"\""];
            if (j<ary1D.count-1){
                [cellStr appendString:@","];
            }else{
                [cellStr appendString:@"\n"];
            }
            [rowStr appendString:cellStr];
        }//for j
        
        [writer appendData: [rowStr dataUsingEncoding:NSUTF8StringEncoding] ];
    }//for i
    
    [writer writeToFile:csvFilePath atomically:YES];
    return csvFilePath;
}

+(NSString *)convert2DArrayToCsv:(NSString*)csvFileName withColumnNames:(NSArray*)columnNames andRows2D:(NSArray*)rows2D
{
    NSMutableArray * data = [NSMutableArray arrayWithCapacity:(1+rows2D.count)];
    if (columnNames!=nil)
        [data addObject:columnNames];
    [data addObjectsFromArray:rows2D];
    return [self convert2DArrayToCsv:csvFileName withData:data];
}

+(NSString *)convert3DArrayToCsv:(NSString*)csvFileName andRows2DAry:(NSArray*)rows2DAry
{
    NSMutableArray * data2D = [NSMutableArray arrayWithCapacity:(1000)];
    for(int i=0; i<rows2DAry.count; i++){
        NSArray *rows2D = rows2DAry[i];
        [data2D addObjectsFromArray:rows2D ];
    }
    return [self convert2DArrayToCsv:csvFileName withData:data2D];
}


+(NSMutableString *) convert2DArrayToHtmlTable:(NSArray*)ary2D withColumnNames:(NSArray*)columnNames
{
    NSLog(@"convert2DArrayToHtmlTable enter");
    
    NSMutableString *strTable = nil;
    if (ary2D == nil || ary2D.count == 0){
        strTable = [NSMutableString stringWithString:@"<div>NONE</div>"];
        return strTable;//return nil will cause following error
    }
    strTable = [NSMutableString stringWithCapacity:1000*ary2D.count];
    [strTable appendString:@"\n<table style=\"border=1px;text-align:right;\">\n"];
    
    if (columnNames != nil && columnNames.count > 0){
        NSMutableString *rowStr = [NSMutableString stringWithCapacity:1000];
        [rowStr appendString:@"\t<tr>\n"];
        for(int i=0; i<columnNames.count; i++){
            NSString *columnName = columnNames[i];
            [rowStr appendString:@"\t\t<th>"];
            [rowStr appendString:columnName];
            [rowStr appendString:@"</th>\n"];
        }
        [rowStr appendString:@"</tr>\n"];
        [strTable appendString:rowStr];
    }
    
    for(int i=0; i<ary2D.count; i++){
        NSArray *ary1D = ary2D[i];
        NSMutableString *rowStr = [NSMutableString stringWithCapacity:1000];
        [rowStr appendString:@"\t<tr>\n"];
        for(int j=0 ; j<ary1D.count; j++){
            NSObject *cell = ary1D[j];
            NSMutableString *cellStr = [NSMutableString stringWithCapacity:100];
            [cellStr appendString:@"\t\t<td>"];
            
            NSString *s1 = nil;
            if (cell == nil || cell == [NSNull null]){
                s1 = nil;
            }else if ([cell isKindOfClass:[NSString class]]){
                s1 = (NSString*)cell;
            }else if ([cell isKindOfClass:[NSNumber class]]){
                NSNumber *nm = (NSNumber *)cell;
                //s1 = [nm stringValue];
                s1 = [NSString stringWithFormat:@"%.4f",[nm doubleValue] ] ;
            }else{
                s1 = [cell description];
            }
            if (s1 != nil){
                [cellStr appendString:s1];
            }
            
            [cellStr appendString:@"</td>\n"];
            [rowStr appendString:cellStr];
        }//for j
        [rowStr appendString:@"</tr>\n"];
        [strTable appendString:rowStr];
    }//for i
    
    [strTable appendString:@"</table>\n"];
    return strTable;
}


+(NSMutableString *) convert3DArrayToHtmlTables:(NSArray*)ary3D
{
    NSLog(@"convert3DArrayToHtmlTables enter");
    
    NSMutableString *strTables = nil;
    if (ary3D == nil || ary3D.count == 0){
        strTables = [NSMutableString stringWithString:@"<div>NONE</div>"];
        return strTables;//return nil will cause following error
    }
    strTables = [NSMutableString string];
    for(int i=0 ; i<ary3D.count; i++){
        NSArray *ary2D = ary3D[i];
        NSMutableString * strTable = [self convert2DArrayToHtmlTable:ary2D withColumnNames:nil];
        [strTables appendString:strTable];
    }//for
    return strTables;
}




+(NSMutableArray*)generateEmptyArray:(int)count
{
    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:count];
    for(int i=0; i<count; i++){
        [ary addObject:[NSNull null]];
    }
    return ary;
}

+(NSString *)copyResourceToDocumentWithResFileName:(NSString*)resFileName andDestFileName:(NSString*)destFileName
{
    NSString *originDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:resFileName];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *destFilePath = [documentsDirectory stringByAppendingPathComponent:destFileName];
    
    NSFileManager * defFileManager = [NSFileManager defaultManager];
    NSError *err = nil;
    if ([defFileManager fileExistsAtPath:destFilePath]){
        [defFileManager removeItemAtPath:destFilePath error:&err];
        if (err != nil){
            NSLog(@"copyResourceToDocumentWithResFileName, defFileManager removeItemAtPath err=%@",err);
        }
    }
    
    [defFileManager copyItemAtPath:originDBPath toPath:destFilePath error:&err];
    if (err != nil){
        NSLog(@"copyResourceToDocumentWithResFileName, defFileManager copyItemAtPath err=%@",err);
        return nil;
    }
    return destFilePath;
}


+(NSString*)getFullHtml_withPart:(NSString*)htmlPart
{
    NSMutableString * str = [NSMutableString string];
    [str appendString:@"<html><head><meta charset=\"UTF-8\"></head><body>\n"];
    [str appendString:htmlPart];
    [str appendString:@"\n</body></html>"];
    return str;
}

+(NSMutableArray*)getPropertyArrayFromDictionaryArray_withPropertyName:(NSString*)propertyName andDictionaryArray:(NSArray*)dicAry
{
    NSMutableArray *propAry = [NSMutableArray array];
    if (dicAry.count == 0)
        return propAry;
    for(int i=0; i<dicAry.count; i++){
        NSDictionary *dic = dicAry[i];
        id val = [dic objectForKey:propertyName];
        [propAry addObject:val];
    }
    return propAry;
}



/*
 从数组去掉集合里也存在的元素，直接在数组上修改，返回数组本身
 */
+(NSMutableArray*)arrayMinusSet_withArray:(NSMutableArray*)srcAry andMinusSet:(NSSet*)minusSet
{
    if (srcAry.count == 0 || minusSet.count == 0)
        return srcAry;
    NSMutableArray *toBeMinusAry = srcAry;
    for(int i=toBeMinusAry.count-1; i>=0; i--){
        NSString *item = toBeMinusAry[i];
        if ([minusSet containsObject:item]){
            [toBeMinusAry removeObjectAtIndex:i];
        }
    }
    return toBeMinusAry;
}
+(NSMutableArray*)arrayMinusArray_withSrcArray:(NSMutableArray*)srcAry andMinusArray:(NSArray*)minusAry
{
    
    if (srcAry.count == 0 || minusAry.count == 0)
        return srcAry;
    return [self.class arrayMinusSet_withArray:srcAry andMinusSet:[NSSet setWithArray:minusAry]];
}
/*
 数组与集合取交集，直接在数组上修改，返回数组本身
 */
+(NSMutableArray*)arrayIntersectSet_withArray:(NSMutableArray*)ary andSet:(NSSet*)set
{
    if (ary.count == 0)
        return ary;
    if (set.count == 0)
        return [NSMutableArray array];
    for(int i=ary.count-1; i>=0; i--){
        NSString *item = ary[i];
        if (![set containsObject:item]){
            [ary removeObjectAtIndex:i];
        }
    }
    return ary;
}
+(NSMutableArray*)arrayIntersectArray_withSrcArray:(NSMutableArray*)srcAry andIntersectArray:(NSArray*)intersectAry
{
    if (intersectAry.count == 0)
        return [NSMutableArray array];
    if (srcAry.count == 0)
        return srcAry;
    return [self.class arrayIntersectSet_withArray:srcAry andSet:[NSSet setWithArray:intersectAry]];
}

+(NSMutableArray *)arrayAddArrayInSetWay_withArray1:(NSArray*)ary1 andArray2:(NSArray*)ary2{
    NSMutableArray *ary = [NSMutableArray arrayWithArray:ary1];
    NSSet *set1 = [NSSet setWithArray:ary1];
    for(int i=0 ; i<ary2.count; i++){
        id obj1 = ary2[i];
        if (![set1 containsObject:obj1]){
            [ary addObject:obj1];
        }
    }
    return ary;
}

/*
 两个数组的所含元素的集合是否相等
 */
+(BOOL)arrayEqualArrayInSetWay_withArray1:(NSArray*)ary1 andArray2:(NSArray*)ary2
{
    if(ary1.count != ary2.count)
        return FALSE;
    if(ary1.count==0)
        return TRUE;
    NSSet *set1 = [NSSet setWithArray:ary1];
    NSSet *set2 = [NSSet setWithArray:ary2];
    BOOL ret = [set1 isEqualToSet:set2];
    return ret;
}

+(BOOL)arrayContainArrayInSetWay_withOuterArray:(NSArray*)outerAry andInnerArray:(NSArray*)innerAry
{
    if (innerAry.count == 0)
        return true;

    NSSet *outerSet = [NSSet setWithArray:outerAry];
    NSSet *innerSet = [NSSet setWithArray:innerAry];
    BOOL ret = [innerSet isSubsetOfSet:outerSet];
    return ret;
}


+(NSMutableDictionary*)dictionaryArrayTo2LevelDictionary_withKeyName:(NSString*)keyName andDicArray:(NSArray*)dicArray
{
    if (dicArray.count==0)
        return nil;
    NSMutableDictionary *dic2Level = [NSMutableDictionary dictionaryWithCapacity:dicArray.count];
    for(int i=0; i<dicArray.count; i++){
        NSDictionary *dic = dicArray[i];
        NSString *keyVal = [dic objectForKey:keyName];
        [dic2Level setValue:dic forKey:keyVal];
    }
    return dic2Level;
}

/*
 按 key,value,key,value..的方式把dictionary的数据放到一个array中
 */
+(NSMutableArray*)dictionaryAllToArray:(NSDictionary*)dict
{
    if (dict==nil)
        return nil;
    NSArray *keys = [dict allKeys];
    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:keys.count*2];
    for(int i=0; i<keys.count; i++){
        NSString *key = keys[i];
        [ary addObject:key];
        [ary addObject:dict[key]];
    }
    return ary;
}


+(UIColor*)getNutrientColorForNutrientId:(NSString *)nutrientId
{
    /*@"Vit_A_RAE",@"Vit_C_(mg)",@"Vit_D_(µg)",@"Vit_E_(mg)",@"Vit_K_(µg)",
     @"Thiamin_(mg)",@"Riboflavin_(mg)",@"Niacin_(mg)",@"Vit_B6_(mg)",@"Folate_Tot_(µg)",
     @"Vit_B12_(µg)",@"Panto_Acid_mg)",
     @"Calcium_(mg)",@"Copper_(mg)",@"Iron_(mg)",@"Magnesium_(mg)",@"Manganese_(mg)",
     @"Phosphorus_(mg)",@"Selenium_(µg)",@"Zinc_(mg)",@"Potassium_(mg)",
     @"Protein_(g)",@"Lipid_Tot_(g)",
     @"Fiber_TD_(g)",@"Choline_Tot_ (mg)",*/
    NSDictionary * colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor colorWithRed:28/255.f green:124/255.f blue:25/255.f alpha:1.0f],@"Vit_A_RAE",
                                [UIColor colorWithRed:1/255.f green:162/255.f blue:144/255.f alpha:1.0f],@"Vit_C_(mg)",
                                [UIColor colorWithRed:252/255.f green:80/255.f blue:0/255.f alpha:1.0f],@"Vit_D_(µg)",
                                [UIColor colorWithRed:193/255.f green:208/255.f blue:63/255.f alpha:1.0f],@"Vit_E_(mg)",
                                [UIColor colorWithRed:56/255.f green:240/255.f blue:242/255.f alpha:1.0f],@"Vit_K_(µg)",
                                [UIColor colorWithRed:227/255.f green:28/255.f blue:121/255.f alpha:1.0f],@"Thiamin_(mg)",
                                [UIColor colorWithRed:0/255.f green:86/255.f blue:184/255.f alpha:1.0f],@"Riboflavin_(mg)",
                                [UIColor colorWithRed:236/255.f green:170/255.f blue:0/255.f alpha:1.0f],@"Niacin_(mg)",
                                [UIColor colorWithRed:213/255.f green:0/255.f blue:88/255.f alpha:1.0f],@"Vit_B6_(mg)",
                                [UIColor colorWithRed:65/255.f green:46/255.f blue:4/255.f alpha:1.0f],@"Folate_Tot_(µg)",
                                [UIColor colorWithRed:46/255.f green:105/255.f blue:172/255.f alpha:1.0f],@"Vit_B12_(µg)",
                                [UIColor colorWithRed:185/255.f green:52/255.f blue:12/255.f alpha:1.0f],@"Panto_Acid_mg)",
                                [UIColor colorWithRed:255/255.f green:234/255.f blue:0/255.f alpha:1.0f],@"Calcium_(mg)",
                                [UIColor colorWithRed:200/255.f green:56/255.f blue:242/255.f alpha:1.0f],@"Copper_(mg)",
                                [UIColor colorWithRed:0/255.f green:161/255.f blue:224/255.f alpha:1.0f],@"Iron_(mg)",
                                [UIColor colorWithRed:70/255.f green:220/255.f blue:3/255.f alpha:1.0f],@"Magnesium_(mg)",
                                [UIColor colorWithRed:107/255.f green:22/255.f blue:132/255.f alpha:1.0f],@"Manganese_(mg)",
                                [UIColor colorWithRed:142/255.f green:72/255.f blue:32/255.f alpha:1.0f],@"Phosphorus_(mg)",
                                [UIColor colorWithRed:136/255.f green:136/255.f blue:136/255.f alpha:1.0f],@"Selenium_(µg)",
                                [UIColor colorWithRed:255/255.f green:0/255.f blue:0/255.f alpha:1.0f],@"Zinc_(mg)",
                                [UIColor colorWithRed:97/255.f green:245/255.f blue:184/255.f alpha:1.0f],@"Potassium_(mg)",
                                [UIColor colorWithRed:255/255.f green:209/255.f blue:0/255.f alpha:1.0f],@"Protein_(g)",
                                [UIColor colorWithRed:255/255.f green:179/255.f blue:171/255.f alpha:1.0f],@"Lipid_Tot_(g)",
                                [UIColor colorWithRed:56/255.f green:218/255.f blue:242/255.f alpha:1.0f],@"Fiber_TD_(g)",
                                [UIColor colorWithRed:130/255.f green:56/255.f blue:242/255.f alpha:1.0f],@"Choline_Tot_ (mg)",
                                nil];
    UIColor *nutrientColor = [colorDict objectForKey:nutrientId];
    if (nutrientColor == nil)
    {
        return [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:1];
    }
    else
    {
        return nutrientColor;
    }
}


+ (BOOL)isUserProfileComplete
{
    
    NSNumber *userSex = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserSexKey];
    NSNumber *userAge = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserAgeKey];
    NSNumber *userHeight = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserHeightKey];
    NSNumber *userWeight = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserWeightKey];
    NSNumber *userActivityLevel = [[NSUserDefaults standardUserDefaults] objectForKey:LZUserActivityLevelKey];
    
    return (userSex && userAge && userHeight && userWeight && userActivityLevel);
}

+ (NSDictionary *)getActivityLevelInfo
{
    NSArray *levelArray = [[NSArray alloc]initWithObjects:@"轻",@"中等",@"强",@"很强", nil];
    NSDictionary *levelDescription = [[NSDictionary alloc]initWithObjectsAndKeys:@"每日仅做一些轻度运动，如散步，购物，做家务等。",@"轻",
                                                                                 @"每日做大概30分钟中等运动，如快速步行，平地骑车，跳交谊舞等。",@"中等",  
                                                                                 @"每日做大概60分钟中等运动；或30分钟的强度运动，如中速跑步，爬山，打羽毛球等。",@"强",
                                                                                 @"每日做大概45~60分钟的剧烈运动，如快跑，游泳，打篮球等。",@"很强",nil];
    NSDictionary *activityDict = [[NSDictionary alloc]initWithObjectsAndKeys:levelArray,@"levelArray",levelDescription,@"levelDescription" ,nil];
    return activityDict;
    
}

+(long long)getMillisecond:(NSDate*)datetime
{
    NSTimeInterval ti = [datetime timeIntervalSince1970];
    long long llms = (long long)round(ti*1000);
    return llms;
}

+(void)initializePreferNutrient
{
    NSArray *preferArray = [[NSUserDefaults standardUserDefaults]objectForKey:KeyUserRecommendPreferNutrientArray];
    NSArray *nutrientArray = [LZRecommendFood getCustomNutrients:nil];
    if (preferArray == nil || ([preferArray count]!= [nutrientArray count]))
    {
        NSMutableArray *newPreferArray = [NSMutableArray array];
        for (NSString *nutrinetId in nutrientArray)
        {
            NSDictionary *state = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithBool:YES],nutrinetId ,nil];
            [newPreferArray addObject:state];
        }
        [[NSUserDefaults standardUserDefaults]setObject:newPreferArray forKey:KeyUserRecommendPreferNutrientArray];
    }
}

+(NSArray *)convertPreferNutrientArrayToParamArray:(NSArray *)preferArray
{
    NSMutableArray *convertedArray = [NSMutableArray array];
    for (NSDictionary *nutrientState in preferArray)
    {
        NSArray *keys = [nutrientState allKeys];
        NSString *key = [keys objectAtIndex:0];
        NSNumber *state = [nutrientState objectForKey:key];
        if ([state boolValue])
        {
            [convertedArray addObject:key];
        }
    }
    NSArray *result = [NSArray arrayWithArray:convertedArray];
    return result;
    
}

+ (NSString *)stampFromInterval:(NSNumber *) seconds
{
    if(seconds == nil || [seconds intValue] == 0)
        return @"";
    if ([[seconds stringValue] length] > 10) {
        seconds	 = [NSNumber numberWithInteger:[[[seconds stringValue] substringToIndex:10] intValue]];
    }
    NSDate *_data = [NSDate dateWithTimeIntervalSince1970:[seconds doubleValue]];
//    NSDate *current = [NSDate date];
    NSString *time;
//    if ([LZUtility twoDateIsSameDay:_data second:current])
//    {
//        NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
//        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans"]];
//        [formatter setAMSymbol:@"上午"];
//        [formatter setPMSymbol:@"下午"];
//        [formatter setDateFormat:@"HH:mm"];
//        time = [formatter stringFromDate:_data];
//        time = @"今天";
//    }
//    else
//    {
        NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans"]];
        [formatter setDateFormat:@"MM.dd"];
        time = [formatter stringFromDate:_data];
//    }
    //MMM dd h:mm a
    return time;
}

+ (BOOL)twoDateIsSameDay:(NSDate *)fist second:(NSDate *)second
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:fist];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:second];
    return [comp1 day]   == [comp2 day] &&
    
    [comp1 month] == [comp2 month] &&
    
    [comp1 year]  == [comp2 year];
    
}

+(NSString*)convertNumberToFoodIdStr:(NSNumber *)foodIdNum
{
    NSString *s = [NSString stringWithFormat:@"%05d",[foodIdNum intValue]];
    return s;
//    NSString *iDStr = [NSString stringWithFormat:@"%d",[foodIdNum intValue]];
//    if ([iDStr length]==4)
//    {
//        iDStr = [NSString stringWithFormat:@"0%@",iDStr];
//    }
//    return iDStr;
}
+(BOOL)isUseUnitDisplay:(NSNumber *)totalWeight unitWeight:(NSNumber *)singleWeight
{
    float result = fmodf([totalWeight floatValue]*2, [singleWeight floatValue]);
    NSLog(@"result %f",result);
    if (result < Config_nearZero)
    {
        return YES;
    }
    return NO;
}



+(NSMutableString*)getObjectDescription : (NSObject*)obj andIndent:(NSUInteger)level
{
    NSMutableString *str = [NSMutableString string];
    NSString * strIndent = @"";
    if (level>0){
        NSArray *indentAry = [LZUtility generateArrayWithFillItem:@"\t" andArrayLength:level];
        strIndent = [indentAry componentsJoinedByString:@""];
    }
    if ([obj isKindOfClass:NSString.class]){
        [str appendFormat:@"\n%@%@",strIndent,obj];
    }else if([obj isKindOfClass:NSArray.class]){
        [str appendFormat:@"\n%@(",strIndent];
        NSArray *ary = (NSArray *)obj;
        for(int i=0; i<ary.count; i++){
            NSString *s = [self getObjectDescription:ary[i] andIndent:level+1];
            [str appendFormat:@"%@ ,",s];
        }
        [str appendFormat:@"\n%@)",strIndent];
    }else if([obj isKindOfClass:NSDictionary.class]){
        [str appendFormat:@"\n%@{",strIndent];
        NSDictionary *dict = (NSDictionary *)obj;
        for (NSString *key in dict) {
            NSObject *val = dict[key];
            [str appendFormat:@"\n\t%@%@=",strIndent,key];
            NSString *s = [self getObjectDescription:val andIndent:level+2];
            [str appendFormat:@"%@ ;",s];
        }
        [str appendFormat:@"\n%@}",strIndent];
        
    }else{
        [str appendFormat:@"\n%@%@",strIndent,[obj debugDescription]];
    }
    
    return str;
}



@end















