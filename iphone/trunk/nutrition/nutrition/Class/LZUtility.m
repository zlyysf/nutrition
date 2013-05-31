//
//  LZUtility.m
//  nutrition
//
//  Created by liu miao on 4/27/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZUtility.h"
#import "LZConstants.h"
@implementation LZUtility


+(NSNumber *)addDoubleToDictionaryItem:(double)valAdd withDictionary:(NSMutableDictionary*)data andKey:(NSString *)datakey
{
    assert(data!=nil);
    assert(datakey!=nil);
    id dataVal = [data objectForKey:datakey];
    double sum = 0 ;
    if (dataVal != nil){
        NSNumber *nmDataVal = dataVal;
        sum = [nmDataVal doubleValue]+valAdd;
    }else{
        sum = valAdd;
    }
    NSNumber *nmSum = [NSNumber numberWithDouble:sum];
    [data setObject:nmSum forKey:datakey];
    return nmSum;
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
    [data addObject:columnNames];
    [data addObjectsFromArray:rows2D];
    return [self convert2DArrayToCsv:csvFileName withData:data];
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
    [strTable appendString:@"\n<table style=\"border=1px;\">\n"];
    
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
                s1 = [NSString stringWithFormat:@"%.2f",[nm doubleValue] ] ;
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

+(NSMutableDictionary*)dictionaryArrayTo2LevelDictionary_withKeyName:(NSString*)keyName andDicArray:(NSArray*)dicArray
{
    if (dicArray.count==0)
        return nil;
    NSMutableDictionary *dic2Level = [NSMutableDictionary dictionaryWithCapacity:dicArray.count];
    for(int i=0; i<dicArray.count; i++){
        NSDictionary *dic = dicArray[i];
        NSObject *keyVal = [dic objectForKey:keyName];
        [dic2Level setValue:dic forKey:keyVal];
    }
    return dic2Level;
}


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
    /*VA:2e69ac   VB6:be206b  VC:01a290   VD:f25e38   VE:c1d03f   钙:facf04   铁：009bd4  锌：e34e35   纤维：24c5d9   叶酸：412e04
@"Vit_A_RAE",@"Vit_C_(mg)",@"Vit_D_(µg)",@"Vit_E_(mg)",@"Vit_B6_(mg)",@"Calcium_(mg)",@"Iron_(mg)",@"Zinc_(mg)",@"Fiber_TD_(g)",@"Folate_Tot_(µg)"*/
    NSDictionary * colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor colorWithRed:46/255.f green:105/255.f blue:172/255.f alpha:1.0f],@"Vit_A_RAE",
                                [UIColor colorWithRed:1/255.f green:162/255.f blue:144/255.f alpha:1.0f],@"Vit_C_(mg)",
                                [UIColor colorWithRed:242/255.f green:94/255.f blue:56/255.f alpha:1.0f],@"Vit_D_(µg)",
                                [UIColor colorWithRed:193/255.f green:208/255.f blue:63/255.f alpha:1.0f],@"Vit_E_(mg)",
                                [UIColor colorWithRed:190/255.f green:32/255.f blue:107/255.f alpha:1.0f],@"Vit_B6_(mg)",
                                [UIColor colorWithRed:250/255.f green:207/255.f blue:4/255.f alpha:1.0f],@"Calcium_(mg)",
                                [UIColor colorWithRed:0/255.f green:155/255.f blue:212/255.f alpha:1.0f],@"Iron_(mg)",
                                [UIColor colorWithRed:227/255.f green:78/255.f blue:53/255.f alpha:1.0f],@"Zinc_(mg)",
                                [UIColor colorWithRed:36/255.f green:197/255.f blue:217/255.f alpha:1.0f],@"Fiber_TD_(g)",
                                [UIColor colorWithRed:65/255.f green:46/255.f blue:4/255.f alpha:1.0f],@"Folate_Tot_(µg)",
                                nil];
    UIColor *nutrientColor = [colorDict objectForKey:nutrientId];
    if (nutrientColor == NULL)
    {
        return [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:1];
    }
    else
    {
        return nutrientColor;
    }
}






@end






















