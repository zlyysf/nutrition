//
//  LZDataAccessUtil.h
//  nutrition
//
//  Created by Yasofon on 13-8-21.
//  Copyright (c) 2013年 lingzhi mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZDataAccess.h"

@interface LZDataAccess(Util)

+(NSArray *)FMResultSetToDictionaryArray:(FMResultSet *)rs;

@end
