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
+(NSMutableString *) convert2DArrayToHtmlTable:(NSArray*)ary2D withColumnNames:(NSArray*)columnNames;
+(NSMutableArray*)generateEmptyArray:(int)count;




@end
