//
//  LZFacade.h
//  ImpExpTool
//
//  Created by Yasofon on 13-5-14.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZFacade : NSObject

+(void)testMain;

//+(void)generateInitialData;
+(void)generateInitialDataToAllInOne;
+(void)generateVariousCsv_withDBFilePath:(NSString *)dbFilePath;

+(void)runSomeTool;

@end
