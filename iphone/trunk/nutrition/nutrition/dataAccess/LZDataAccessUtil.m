//
//  LZDataAccessUtil.m
//  nutrition
//
//  Created by Yasofon on 13-8-21.
//  Copyright (c) 2013年 lingzhi mobile. All rights reserved.
//

#import "LZDataAccessUtil.h"

@implementation LZDataAccess(Util)

+(NSArray *)FMResultSetToDictionaryArray:(FMResultSet *)rs
{
    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:10];
    while ([rs next]) {
        NSDictionary *rowDict = rs.resultDictionary;
        [ary addObject:rowDict];
    }
    return ary;
}

@end
