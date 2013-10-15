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
#import "MBProgressHUD.h"
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

+(NSNumber *)addIntToDictionaryItem:(int)valAdd withDictionary:(NSMutableDictionary*)data andKey:(NSString *)datakey
{
    assert(data!=nil);
    assert(datakey!=nil);
    id dataVal = [data objectForKey:datakey];
    int sum = 0 ;
    if (dataVal != nil && dataVal != [NSNull null]){
        NSNumber *nmDataVal = dataVal;
        sum = [nmDataVal intValue]+valAdd;
    }else{
        sum = valAdd;
    }
    NSNumber *nmSum = [NSNumber numberWithInt:sum];
    [data setObject:nmSum forKey:datakey];
    return nmSum;
}
+(int)getIntFromDictionaryItem_withDictionary:(NSMutableDictionary*)data andKey:(NSString *)datakey
{
    assert(data!=nil);
    assert(datakey!=nil);
    id dataVal = [data objectForKey:datakey];
    if (dataVal==nil || dataVal == [NSNull null])
        return 0;
    else{
        NSNumber *nmDataVal = dataVal;
        return [nmDataVal intValue];
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
                                [UIColor colorWithRed:255/255.f green:92/255.f blue:54/255.f alpha:1.0f],@"Vit_A_RAE",
                                [UIColor colorWithRed:62/255.f green:171/255.f blue:47/255.f alpha:1.0f],@"Vit_C_(mg)",
                                [UIColor colorWithRed:255/255.f green:144/255.f blue:86/255.f alpha:1.0f],@"Vit_D_(µg)",
                                [UIColor colorWithRed:1/255.f green:162/255.f blue:144/255.f alpha:1.0f],@"Vit_E_(mg)",
                                [UIColor colorWithRed:56/255.f green:240/255.f blue:242/255.f alpha:1.0f],@"Vit_K_(µg)",
                                [UIColor colorWithRed:227/255.f green:28/255.f blue:121/255.f alpha:1.0f],@"Thiamin_(mg)",
                                [UIColor colorWithRed:204/255.f green:47/255.f blue:36/255.f alpha:1.0f],@"Riboflavin_(mg)",
                                [UIColor colorWithRed:236/255.f green:170/255.f blue:0/255.f alpha:1.0f],@"Niacin_(mg)",
                                [UIColor colorWithRed:0/255.f green:153/255.f blue:204/255.f alpha:1.0f],@"Vit_B6_(mg)",
                                [UIColor colorWithRed:215/255.f green:132/255.f blue:44/255.f alpha:1.0f],@"Folate_Tot_(µg)",
                                [UIColor colorWithRed:30/255.f green:216/255.f blue:226/255.f alpha:1.0f],@"Vit_B12_(µg)",
                                [UIColor colorWithRed:185/255.f green:52/255.f blue:12/255.f alpha:1.0f],@"Panto_Acid_mg)",
                                [UIColor colorWithRed:230/255.f green:71/255.f blue:132/255.f alpha:1.0f],@"Calcium_(mg)",
                                [UIColor colorWithRed:200/255.f green:56/255.f blue:242/255.f alpha:1.0f],@"Copper_(mg)",
                                [UIColor colorWithRed:66/255.f green:108/255.f blue:169/255.f alpha:1.0f],@"Iron_(mg)",
                                [UIColor colorWithRed:208/255.f green:100/255.f blue:206/255.f alpha:1.0f],@"Magnesium_(mg)",
                                [UIColor colorWithRed:107/255.f green:22/255.f blue:132/255.f alpha:1.0f],@"Manganese_(mg)",
                                [UIColor colorWithRed:142/255.f green:72/255.f blue:32/255.f alpha:1.0f],@"Phosphorus_(mg)",
                                [UIColor colorWithRed:136/255.f green:136/255.f blue:136/255.f alpha:1.0f],@"Selenium_(µg)",
                                [UIColor colorWithRed:146/255.f green:100/255.f blue:205/255.f alpha:1.0f],@"Zinc_(mg)",
                                [UIColor colorWithRed:97/255.f green:245/255.f blue:184/255.f alpha:1.0f],@"Potassium_(mg)",
                                [UIColor colorWithRed:187/255.f green:194/255.f blue:4/255.f alpha:1.0f],@"Protein_(g)",
                                [UIColor colorWithRed:255/255.f green:179/255.f blue:171/255.f alpha:1.0f],@"Lipid_Tot_(g)",
                                [UIColor colorWithRed:99/255.f green:201/255.f blue:39/255.f alpha:1.0f],@"Fiber_TD_(g)",
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
    NSArray *levelArray = [[NSArray alloc]initWithObjects:NSLocalizedString(@"activitylevel0",@"轻"),NSLocalizedString(@"activitylevel1", @"中等"),NSLocalizedString(@"activitylevel2",@"强"),NSLocalizedString(@"activitylevel3",@"很强"), nil];
    NSDictionary *levelDescription = [[NSDictionary alloc]initWithObjectsAndKeys:NSLocalizedString(@"activitylevel0_des",@"每日仅做一些轻度运动，如散步，购物，做家务等。"),NSLocalizedString(@"activitylevel0",@"轻"),
                                                                                 NSLocalizedString(@"activitylevel1_des",@"每日做大概30分钟中等运动，如快速步行，平地骑车，跳交谊舞等。"),NSLocalizedString(@"activitylevel1",@"中等"),  
                                                                                 NSLocalizedString(@"activitylevel2_des",@"每日做大概60分钟中等运动；或30分钟的强度运动，如中速跑步，爬山，打羽毛球等。"),NSLocalizedString(@"activitylevel2",@"强"),
                                                                                 NSLocalizedString(@"activitylevel3_des",@"每日做大概45~60分钟的剧烈运动，如快跑，游泳，打篮球等。"),NSLocalizedString(@"activitylevel3",@"很强"),nil];
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
    //NSArray *preferArray = [[NSUserDefaults standardUserDefaults]objectForKey:KeyUserRecommendPreferNutrientArray];
    NSArray *nutrientArray = [LZRecommendFood getCustomNutrients:nil];
    //if (preferArray == nil || ([preferArray count]!= [nutrientArray count]))
    //{
        NSMutableArray *newPreferArray = [NSMutableArray array];
        for (NSString *nutrinetId in nutrientArray)
        {
            NSDictionary *state = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithBool:YES],nutrinetId ,nil];
            [newPreferArray addObject:state];
        }
        [[NSUserDefaults standardUserDefaults]setObject:newPreferArray forKey:KeyUserRecommendPreferNutrientArray];
        [[NSUserDefaults standardUserDefaults]synchronize];
    //}
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
+(NSString *)getCurrentTimeIdentifier
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    unsigned unitFlags = NSHourCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents * currentComp = [calendar components:unitFlags fromDate:now];
    int hour = [currentComp hour];//([currentComp hour]+ ([currentComp minute]>0?1:0))%24;
    if (hour >=6 && hour < 12)
    {
        return @"上午";
    }
    else if (hour >=12 && hour < 19)
    {
        return @"下午";
    }
    else
    {
       return @"睡前";
    }
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
+(BOOL)isIphoneDeviceVersionFive
{
    if ([[UIScreen mainScreen] bounds].size.height == 568)//iphone5
        return YES;
    else
        return NO;
}

+(void)addFood:(NSString *)foodId withFoodAmount:(NSNumber *)foodAmount
{
    NSMutableDictionary *intakeDict = [[NSMutableDictionary alloc]init];
    NSDictionary *dailyIntake = [[NSUserDefaults standardUserDefaults]objectForKey:LZUserDailyIntakeKey];
    if(dailyIntake != nil)
    {
        [intakeDict addEntriesFromDictionary:dailyIntake];
    }
    
    BOOL needSaveData = NO;
    if ([foodAmount intValue]>0)
    {
        needSaveData = YES;
        NSNumber *takenAmountNum = [intakeDict objectForKey:foodId];
        if (takenAmountNum)
            [intakeDict setObject:[NSNumber numberWithInt:[foodAmount intValue]+[takenAmountNum intValue]] forKey:foodId];
        else
            [intakeDict setObject:foodAmount forKey:foodId];
    }
    if (needSaveData) {
        [[NSNotificationCenter defaultCenter]postNotificationName:Notification_TakenFoodChangedKey object:nil userInfo:nil];
        [[NSUserDefaults standardUserDefaults]setObject:intakeDict forKey:LZUserDailyIntakeKey];
        [[NSUserDefaults  standardUserDefaults]synchronize];
        MBProgressHUD * hud = [[MBProgressHUD alloc]initWithWindow:[UIApplication sharedApplication].keyWindow];//HUDForView:;
        [[UIApplication sharedApplication].keyWindow addSubview:hud];
        hud.mode = MBProgressHUDModeText;
        hud.removeFromSuperViewOnHide = YES;
        hud.labelText = NSLocalizedString(@"tianjia_HUDLabel_content",@"添加成功！");
        hud.animationType = MBProgressHUDAnimationZoomIn;
        [hud show:NO];
        [hud hide:YES afterDelay:0.4f];
        //NSLog(@"%@",[UIApplication sharedApplication].keyWindow.subviews);
    }

}
+(void)setReviewFlagForNewVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *flagKey = [NSString stringWithFormat:@"%@%@-RF",AppVersionCheckName,appVersion];
    BOOL flagExists = [[NSUserDefaults standardUserDefaults]boolForKey:flagKey];
    if (flagExists)
    {
        return;
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:KeyIsAlreadyReviewdeOurApp];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:flagKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }

}
+(void)initializeCheckReminder
{
    if (([[NSUserDefaults standardUserDefaults]objectForKey:KeyCheckReminderShangWu] == nil) || ([[NSUserDefaults standardUserDefaults]objectForKey:KeyCheckReminderXiaWu] == nil)||([[NSUserDefaults standardUserDefaults]objectForKey:KeyCheckReminderShuiQian] == nil))
    {
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        unsigned unitFlags = NSYearCalendarUnit |NSMonthCalendarUnit | NSDayCalendarUnit;
        NSDateComponents *todayComp = [calendar components:unitFlags fromDate:date];
        [todayComp setHour:9];
        NSDate *shangwuDate = [calendar dateFromComponents:todayComp];
//        NSTimeZone *zone = [NSTimeZone systemTimeZone];
//        NSInteger interval = [zone secondsFromGMTForDate: date];
//        NSDate *shangwuDate1 = [shangwuDate  dateByAddingTimeInterval: interval];
        [todayComp setHour:16];
        NSDate *xiawuDate = [calendar dateFromComponents:todayComp];
//        NSDate *xiawuDate1 = [xiawuDate  dateByAddingTimeInterval: interval];
        [todayComp setHour:22];
        NSDate *shuiqianDate = [calendar dateFromComponents:todayComp];
//        NSDate *shuiqianDate1 = [shuiqianDate dateByAddingTimeInterval: interval];
        [[NSUserDefaults standardUserDefaults]setObject:shangwuDate forKey:KeyCheckReminderShangWu];
        [[NSUserDefaults standardUserDefaults]setObject:xiawuDate forKey:KeyCheckReminderXiaWu];
        [[NSUserDefaults standardUserDefaults]setObject:shuiqianDate forKey:KeyCheckReminderShuiQian];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [LZUtility setCheckReminderOn:YES];
    }
}
+(NSString *)getDateFormatOutput:(NSDate*)date
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] init]];
    [formatter setAMSymbol:NSLocalizedString(@"AMSymbol",@"上午")];
    [formatter setPMSymbol:NSLocalizedString(@"PMSymbol",@"下午")];
    [formatter setDateFormat:NSLocalizedString(@"timeformat_timesettings",@"ahh:mm ,for chinese we set ahh:mm,for en we should set hh:mma")];
    return  [formatter stringFromDate:date];
}
+(NSDate *)getDateForHour:(int)hours Minutes:(int)minutes
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit |NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *todayComp = [calendar components:unitFlags fromDate:date];
    [todayComp setHour:hours];
    [todayComp setMinute:minutes];
    NSDate *newDate = [calendar dateFromComponents:todayComp];
    return newDate;

}
+(NSDate *)convertOldDateToTodayDate:(NSDate *)date
{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit |NSMonthCalendarUnit | NSDayCalendarUnit;
    unsigned unitFlags1 = NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *todayComp = [calendar components:unitFlags fromDate:today];
    NSDateComponents *inputComp = [calendar components:unitFlags1 fromDate:date];
    [todayComp setHour:[inputComp hour]];
    [todayComp setMinute:[inputComp minute]];
    NSDate *todayDate = [calendar dateFromComponents:todayComp];
    return todayDate;
}
+(void)setCheckReminderOn:(BOOL)isOn
{
    NSSet *keySet = [NSSet setWithObjects:KeyCheckReminderXiaWu,KeyCheckReminderShangWu,KeyCheckReminderShuiQian, nil];
    NSArray *oldScheduledNotify = [[UIApplication sharedApplication]scheduledLocalNotifications];
    NSMutableArray *newScheduled = [[NSMutableArray alloc]init];
    if (isOn) //change localnotify state on
    {
        NSDate *shangwuDateDefault = [[NSUserDefaults standardUserDefaults]objectForKey:KeyCheckReminderShangWu];
        NSDate *xiawuDateDeFault = [[NSUserDefaults standardUserDefaults]objectForKey:KeyCheckReminderXiaWu];
        NSDate *shuiqianDateDefault = [[NSUserDefaults standardUserDefaults]objectForKey:KeyCheckReminderShuiQian];
        for (UILocalNotification *local in oldScheduledNotify)
        {
            NSDictionary *info = [local userInfo];
            if(info == nil  || (![keySet containsObject:[info objectForKey:@"notifyType"]]))
            {
                NSDictionary *userDict = [NSDictionary dictionaryWithObject:KeyNotifyTimeTypeReminder forKey:@"notifyType"];
                [local setUserInfo:userDict];
                [newScheduled addObject:local];
                break;
            }
        }
        UILocalNotification *shangwuLocal = [[UILocalNotification alloc]init];
        [shangwuLocal setAlertAction:NSLocalizedString(@"localnotify_checkreminder_action",@"去诊断")];
        [shangwuLocal setAlertBody:NSLocalizedString(@"localnotify_checkreminder_content",@"诊断时间到了")];
        [shangwuLocal setRepeatInterval:NSDayCalendarUnit];
        [shangwuLocal setApplicationIconBadgeNumber:1];
        [shangwuLocal setFireDate:shangwuDateDefault];
        [shangwuLocal setTimeZone:[NSTimeZone defaultTimeZone]];
        [shangwuLocal setSoundName:UILocalNotificationDefaultSoundName];
        NSDictionary *infoDict = [NSDictionary dictionaryWithObject:KeyCheckReminderShangWu forKey:@"notifyType"];
        [shangwuLocal setUserInfo:infoDict];
        [newScheduled addObject:shangwuLocal];
        
        UILocalNotification *xiawuLocal = [[UILocalNotification alloc]init];
        [xiawuLocal setAlertAction:NSLocalizedString(@"localnotify_checkreminder_action",@"去诊断")];
        [xiawuLocal setAlertBody:NSLocalizedString(@"localnotify_checkreminder_content",@"诊断时间到了")];
        [xiawuLocal setRepeatInterval:NSDayCalendarUnit];
        [xiawuLocal setApplicationIconBadgeNumber:1];
        [xiawuLocal setFireDate:xiawuDateDeFault];
        [xiawuLocal setTimeZone:[NSTimeZone defaultTimeZone]];
        [xiawuLocal setSoundName:UILocalNotificationDefaultSoundName];
        NSDictionary *infoDict1 = [NSDictionary dictionaryWithObject:KeyCheckReminderXiaWu forKey:@"notifyType"];
        [xiawuLocal setUserInfo:infoDict1];
        [newScheduled addObject:xiawuLocal];
        
        UILocalNotification *shuiqianLocal = [[UILocalNotification alloc]init];
        [shuiqianLocal setAlertAction:NSLocalizedString(@"localnotify_checkreminder_action",@"去诊断")];
        [shuiqianLocal setAlertBody:NSLocalizedString(@"localnotify_checkreminder_content",@"诊断时间到了")];
        [shuiqianLocal setRepeatInterval:NSDayCalendarUnit];
        [shuiqianLocal setApplicationIconBadgeNumber:1];
        [shuiqianLocal setFireDate:shuiqianDateDefault];
        [shuiqianLocal setTimeZone:[NSTimeZone defaultTimeZone]];
        [shuiqianLocal setSoundName:UILocalNotificationDefaultSoundName];
        NSDictionary *infoDict2 = [NSDictionary dictionaryWithObject:KeyCheckReminderShuiQian forKey:@"notifyType"];
        [shuiqianLocal setUserInfo:infoDict2];
        [newScheduled addObject:shuiqianLocal];
    }
    else //remove localnotify
    {
        for (UILocalNotification *local in oldScheduledNotify)
        {
            NSDictionary *info = [local userInfo];
            if(info == nil  || (![keySet containsObject:[info objectForKey:@"notifyType"]]))
            {
                NSDictionary *userDict = [NSDictionary dictionaryWithObject:KeyNotifyTimeTypeReminder forKey:@"notifyType"];
                [local setUserInfo:userDict];
                [newScheduled addObject:local];
                break;
            }
        }
    }
    [[UIApplication sharedApplication] setScheduledLocalNotifications:newScheduled];
}
+(BOOL)isCurrentLanguageChinese
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh-Hans"])
    {
        return YES;
    }
    return NO;
}

+(NSDictionary *)getNutritionNameInfo:(NSString *)name
{
    NSString *chinisePart = @"";
    NSString *englishPart = @"";
    int alength = [name length];
    for (int i = 0; i<alength; i++) {
        //char commitChar = [name characterAtIndex:i];
        NSString *temp = [name substringWithRange:NSMakeRange(i,1)];
        const char *u8Temp = [temp UTF8String];
        if (3==strlen(u8Temp))
        {
            chinisePart = [chinisePart stringByAppendingString:temp];
        }
        else
        {
            englishPart = [englishPart stringByAppendingString:temp];
        }
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:chinisePart,@"ChinesePart",englishPart,@"EnglishPart", nil];
    return dict;
}

+ (UIImage *) createImageWithColor: (UIColor *) color imageSize:(CGSize )imageSize
{
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;

    
    
//    CGRect frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
//    UIGraphicsBeginImageContext(frame.size);
//    CGContextRef     context = UIGraphicsGetCurrentContext();
//    CGSize          myShadowOffset = CGSizeMake (1.5,  1.5);
//    float           myColorValues[] = {140/255.f, 137/255.f, 137/255.f, 0.75};
//    CGColorRef      myColor;
//    CGColorSpaceRef myColorSpace;
//    CGContextSaveGState(context);
//    //    CGContextSetShadow (myContext, myShadowOffset, 0);
//    
//    // Your drawing code here
//    myColorSpace = CGColorSpaceCreateDeviceRGB ();
//    myColor = CGColorCreate (myColorSpace, myColorValues);
//    CGContextSetShadowWithColor (context, myShadowOffset, 0, myColor);
//    // Your drawing code here
//    [[UIColor colorWithRed:194/255.f green:194/255.f blue:194/255.f alpha:1] setStroke];
//    [color setFill];
//    //CGContextRef     context = UIGraphicsGetCurrentContext();
//    
//    //CGMutablePathRef pathRef = [self pathwithFrame:rect withRadius:radius];
//    CGPoint x1,x2,x3,x4; //x为4个顶点
//    CGPoint y1,y2,y3,y4,y5,y6,y7,y8; //y为4个控制点
//    //从左上角顶点开始，顺时针旋转,x1->y1->y2->x2
//    
//    x1 = frame.origin;
//    x2 = CGPointMake(frame.origin.x+frame.size.width, frame.origin.y);
//    x3 = CGPointMake(frame.origin.x+frame.size.width, frame.origin.y+frame.size.height);
//    x4 = CGPointMake(frame.origin.x                 , frame.origin.y+frame.size.height);
//    
//    
//    y1 = CGPointMake(frame.origin.x, frame.origin.y);
//    y2 = CGPointMake(frame.origin.x+frame.size.width, frame.origin.y);
//    y3 = CGPointMake(frame.origin.x+frame.size.width, frame.origin.y);
//    y4 = CGPointMake(frame.origin.x+frame.size.width, frame.origin.y+frame.size.height);
//    
//    y5 = CGPointMake(frame.origin.x+frame.size.width, frame.origin.y+frame.size.height);
//    y6 = CGPointMake(frame.origin.x, frame.origin.y+frame.size.height);
//    y7 = CGPointMake(frame.origin.x, frame.origin.y+frame.size.height);
//    y8 = CGPointMake(frame.origin.x, frame.origin.y);
//    
//    
//    CGMutablePathRef pathRef = CGPathCreateMutable();
//    
//        CGPathMoveToPoint(pathRef,    &CGAffineTransformIdentity, x1.x,x1.y);
//        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, x2.x,x2.y);
//        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, x3.x,x3.y);
//        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, x4.x,x4.y);
//    CGPathCloseSubpath(pathRef);
//    
//    CGContextAddPath(context, pathRef);
//    CGContextSetLineWidth(context, 0.5);
//    CGContextDrawPath(context,kCGPathFillStroke);
//    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
//    CGPathRelease(pathRef);
//    UIGraphicsEndImageContext();
//    return theImage;

    
}
@end















