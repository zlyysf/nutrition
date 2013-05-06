//
//  LZRecommendFood.h
//  nutrition
//
//  Created by Yasofon on 13-5-2.
//  Copyright (c) 2013年 lingzhi mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZUtility.h"

@interface LZRecommendFood : NSObject


-(NSMutableDictionary *) recommendFoodForEnoughNuitritionWithPreIntake:(NSDictionary*)takenFoodAmountDict sex:(int)sex age:(int)age weight:(float)weight height:(float)height activityLevel:(int )activityLevel;

-(NSArray*) generateData2D_RecommendFoodForEnoughNuitrition:(NSDictionary*)recmdDict;
-(void) formatCsv_RecommendFoodForEnoughNuitrition: (NSString *)csvFileName withRecommendResult:(NSDictionary*)recmdDict;
-(NSString *) convert2DArrayToCsv: (NSString *)csvFileName withData:(NSArray*)ary2D;
-(NSMutableString *) convert2DArrayToText:(NSArray*)ary2D;

@end












